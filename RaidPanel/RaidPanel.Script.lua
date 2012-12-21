-----------------------------------------
-- Script for RaidPanel
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

SpellBookFrame = _G.SpellBookFrame
MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS
BOOKTYPE_SPELL = _G.BOOKTYPE_SPELL

_IGASUI_HELPFUL_SPELL = {}

Toggle = {
	Message = L"Lock Raid Panel",
	Get = function()
		return not raidPanelMask.Visible
	end,
	Set = function (value)
		if value then
			raidPanelMask.Visible = false
		else
			if not InCombatLockdown() then
				raidPanelMask.Visible = true
			end
		end
	end,
	Update = function() end,
}

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "rp" or option:lower() == "raidpanel") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "unlock" then
			raidPanelMask.Visible = true
		elseif info == "lock" then
			raidPanelMask.Visible = false
		else
			Log(2, "/iu rp unlock - unlock the raid panel.")
			Log(2, "/iu rp lock - lock the raid panel.")
		end

		return true
	end
end

function OnLoad(self)
	_DB = _Addon._DB.RaidPanel or {}
	_DBChar = _Addon._DBChar.RaidPanel or {}
	_Addon._DB.RaidPanel = _DB
	_Addon._DBChar.RaidPanel = _DBChar

	if _DBChar.Location then
		raidPanel.Location = _DBChar.Location
	end

	self:RegisterEvent"PLAYER_REGEN_DISABLED"
	self:RegisterEvent"PLAYER_SPECIALIZATION_CHANGED"
	self:RegisterEvent"PLAYER_LOGOUT"
	self:RegisterEvent"LEARNED_SPELL_IN_TAB"

	_LoadingConfig = GetSpecialization() or 1
	if _DBChar[_LoadingConfig] then
		_IGASUI_SPELLHANDLER:Import(_DBChar[_LoadingConfig])
	end
end

function OnEnable(self)
	self:SecureHook("SpellButton_UpdateButton")
	LEARNED_SPELL_IN_TAB(self)

	self:ThreadCall(function()
		System.Threading.Sleep(3)

		IFNoCombatTaskHandler._RegisterNoCombatTask(function()
			_G.CompactRaidFrameContainer:UnregisterAllEvents()
			_G.CompactRaidFrameManager:UnregisterAllEvents()
			_G.CompactRaidFrameManager:Show()

			for i=1, 8 do
				local button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarker"..i]
				button:GetNormalTexture():SetDesaturated(false)
				button:SetAlpha(1)
				button:Enable()

				button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerRemove"]
				button:GetNormalTexture():SetDesaturated(false)
				button:SetAlpha(1)
				button:Enable()
			end
		end)
	end)
end

function PLAYER_REGEN_DISABLED(self)
	if raidPanelMask.Visible then
		raidPanelMask.Visible = false
		raidPanel:StopMovingOrSizing()
		raidPanel.Movable = false
	end
	if chkMode.Checked then
		chkMode.Checked = false
		Masks:Each(UpdateMaskButton)
	end
end

function SpellButton_UpdateButton(self)
	UpdateMaskButton(Masks[self:GetID()])
	if withPanel.Target then
		withPanel.Target = nil
		withPanel.Visible = false
	end
end

function UpdateMaskButton(self)
	if chkMode.Checked then
		self:RefreshBindingKey()
	else
		self.Visible = false
	end
end

function PLAYER_SPECIALIZATION_CHANGED(self)
	local now = GetSpecialization() or 1
	if now ~= _LoadingConfig then
		_DBChar[_LoadingConfig] = _IGASUI_SPELLHANDLER:Export()
		_LoadingConfig = now

		if _DBChar[now] then
			_IGASUI_SPELLHANDLER:Import(_DBChar[now])
		end
	end
	LEARNED_SPELL_IN_TAB(self)
end

function LEARNED_SPELL_IN_TAB(self)
	wipe(_IGASUI_HELPFUL_SPELL)
	for i = 1, MAX_SKILLLINE_TABS do
	    local name, texture, offset, numEntries, isGuild, offspecID = GetSpellTabInfo(i)

	    if not name then
	        break
	    end

	    if not isGuild and offspecID == 0 then
	        for index = offset + 1, offset + numEntries do
	            local skillType, spellId = GetSpellBookItemInfo(index, BOOKTYPE_SPELL)
	            local isPassive = IsPassiveSpell(index, BOOKTYPE_SPELL)
	            local isHelpful = IsHelpfulSpell(index, BOOKTYPE_SPELL)
	            local name = GetSpellInfo(spellId)

	            if not isPassive and isHelpful then
	            	_IGASUI_HELPFUL_SPELL[spellId] = true
	            	_IGASUI_HELPFUL_SPELL[name] = true
	            end
	        end
	    end
	end
end

function PLAYER_LOGOUT(self)
	local spec = GetSpecialization() or 1

	_DBChar[spec] = _IGASUI_SPELLHANDLER:Export()
end

--------------------
-- Script Handler
--------------------
_Updating = false

function chkMode:OnValueChanged()
	if self.Checked and not _Updating then
		_Updating = true
		_IGASUI_SPELLHANDLER:BeginUpdate()
	end
	withPanel.Visible = false
	Masks:Each(UpdateMaskButton)
end

function chkMode:OnHide()
	withPanel.Visible = false
	self.Checked = false
	if _Updating then
		_Updating = false
		_IGASUI_SPELLHANDLER:CommitUpdate()
	end
end

function raidPanelMask:OnMoveFinished()
	_DBChar.Location = raidPanel.Location
end

function raidPanelMask:OnShow()
	Toggle.Update()
end

function raidPanelMask:OnHide()
	Toggle.Update()
end

function chkTarget:OnValueChanged()
	if self.Checked then
		chkFocus.Checked = false
	end
	if withPanel.Target then
		withPanel.Target.With = chkTarget.Checked and "target" or chkFocus.Checked and "focus" or nil
		withPanel.Target:SetBindingKey(withPanel.Target.BindKey)
	end
end

function chkFocus:OnValueChanged()
	if self.Checked then
		chkTarget.Checked = false
	end
	if withPanel.Target then
		withPanel.Target.With = chkTarget.Checked and "target" or chkFocus.Checked and "focus" or nil
		withPanel.Target:SetBindingKey(withPanel.Target.BindKey)
	end
end