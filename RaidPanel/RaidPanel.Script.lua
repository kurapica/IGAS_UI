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
			raidPanelConfig.Visible = false
		else
			if not InCombatLockdown() then
				raidPanelMask.Visible = true
				raidPanelConfig.Visible = true
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

	-- Load location
	if _DBChar.Location then
		raidPanel.Location = _DBChar.Location
	end

	-- Load disable settings
	_DBChar.DisableElement = _DBChar.DisableElement or {}
	_DisableElement = _DBChar.DisableElement
	raidpanelMenuArray:Each(function(self)
		self.Checked = not _DisableElement[self.ElementName]

		raidPanel:Each(UpdateConfig4UnitFrame, self)
		raidPetPanel:Each(UpdateConfig4UnitFrame, self)
	end)

	-- Load raid panel settings
	_DBChar.RaidPanelSet = _DBChar.RaidPanelSet or {}
	_RaidPanelSet = _DBChar.RaidPanelSet

	-- Default settings
	if not next(_RaidPanelSet) then
		_RaidPanelSet.ShowRaid = true
		_RaidPanelSet.ShowParty = true
		_RaidPanelSet.ShowPlayer = true
		_RaidPanelSet.ShowSolo = true
		_RaidPanelSet.GroupBy = "GROUP"
		_RaidPanelSet.SortBy = "INDEX"
	end

	for k, v in pairs(_RaidPanelSet) do
		raidPanel[k] = v
	end
	raidpanelPropArray:Each(function(self)
		if self.ConfigValue then
			self.Checked = (raidPanel[self.ConfigName] == self.ConfigValue)
		else
			self.Checked = raidPanel[self.ConfigName]
		end
	end)

	--[[ Filter Settings
	_DBChar.GroupFilter = _DBChar.GroupFilter or {}
	_DBChar.ClassFilter = _DBChar.ClassFilter or {}
	_DBChar.RoleFilter = _DBChar.RoleFilter or {}
	_GroupFilter = _DBChar.GroupFilter
	_ClassFilter = _DBChar.ClassFilter
	_RoleFilter = _DBChar.RoleFilter

	raidPanel.GroupFilter = _GroupFilter
	raidPanel.ClassFilter = _ClassFilter
	raidPanel.RoleFilter = _RoleFilter

	groupFilterArray:Each(function(self)
		for _, v in ipairs(_GroupFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	classFilterArray:Each(function(self)
		for _, v in ipairs(_ClassFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)
	roleFilterArray:Each(function(self)
		for _, v in ipairs(_RoleFilter) do
			if v == self.FilterValue then
				self.Checked = true
				break
			end
		end
	end)--]]

	-- Used for RaidFrame updating
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("UPDATE_INSTANCE_INFO")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("VOICE_STATUS_UPDATE")
	self:RegisterEvent("PARTY_LFG_RESTRICTED")

	_LoadingConfig = GetSpecialization() or 1
	if _DBChar[_LoadingConfig] then
		_IGASUI_SPELLHANDLER:Import(_DBChar[_LoadingConfig])
	end

	raidPanel:InitWithCount(25)
end

function OnEnable(self)
	self:SecureHook("SpellButton_UpdateButton")
	LEARNED_SPELL_IN_TAB(self)

	self:ThreadCall(function()
		System.Threading.Sleep(3)

		IFNoCombatTaskHandler._RegisterNoCombatTask(function()
			_G.RaidFrame:UnregisterEvent("READY_CHECK")
			_G.RaidFrame:UnregisterEvent("READY_CHECK_CONFIRM")
			_G.RaidFrame:UnregisterEvent("READY_CHECK_FINISHED")
			_G.RaidFrame:UnregisterEvent("UPDATE_INSTANCE_INFO")
			_G.RaidFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
			_G.RaidFrame:UnregisterEvent("PARTY_LEADER_CHANGED")
			_G.RaidFrame:UnregisterEvent("VOICE_STATUS_UPDATE")
			_G.RaidFrame:UnregisterEvent("PARTY_LFG_RESTRICTED")

			_G.CompactRaidFrameContainer:UnregisterAllEvents()
			_G.CompactRaidFrameManager:UnregisterAllEvents()
			_G.CompactRaidFrameManager:Show()

			local button

			for i=1, 8 do
				button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarker"..i]
				button:GetNormalTexture():SetDesaturated(false)
				button:SetAlpha(1)
				button:Enable()
			end

			button = _G["CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerRemove"]
			button:GetNormalTexture():SetDesaturated(false)
			button:SetAlpha(1)
			button:Enable()

			button = _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll
			button:SetAlpha(1)
			button:Enable()

			button = _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck
			button:SetAlpha(1)
			button:Enable()
		end)
	end)
end

function UPDATE_INSTANCE_INFO(self)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RaidFrame_OnEvent, _G.RaidFrame, "UPDATE_INSTANCE_INFO")
end

function GROUP_ROSTER_UPDATE(self)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RaidFrame_OnEvent, _G.RaidFrame, "GROUP_ROSTER_UPDATE")
end

function PARTY_LEADER_CHANGED(self)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RaidFrame_OnEvent, _G.RaidFrame, "PARTY_LEADER_CHANGED")
end

function VOICE_STATUS_UPDATE(self)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RaidFrame_OnEvent, _G.RaidFrame, "PARTY_LEADER_CHANGED")
end

function PARTY_LFG_RESTRICTED(self)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RaidFrame_OnEvent, _G.RaidFrame, "PARTY_LEADER_CHANGED")
end

function PLAYER_REGEN_DISABLED(self)
	if raidPanelMask.Visible then
		raidPanelMask.Visible = false
		raidPanelConfig.Visible = false
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

function raidPanel:OnElementAdd(unitframe)
	raidpanelMenuArray:Each(UpdateConfig4MenuBtn, unitframe)
end

function raidPetPanel:OnElementAdd(unitframe)
	raidpanelMenuArray:Each(UpdateConfig4MenuBtn, unitframe)
end

function raidpanelMenuArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		_DisableElement[self[index].ElementName] = not self[index].Checked

		raidPanel:Each(UpdateConfig4UnitFrame, self[index])
		raidPetPanel:Each(UpdateConfig4UnitFrame, self[index])
	end
end

function raidpanelPropArray:OnCheckChanged(index)
	if raidPanelConfig.Visible and (self[index].Checked or not self[index].ConfigValue) then
		raidPanel[self[index].ConfigName] = self[index].ConfigValue or self[index].Checked

		-- keep set
		_RaidPanelSet[self[index].ConfigName] = raidPanel[self[index].ConfigName]

		raidPanel:Refresh()
	end
end

--[[function groupFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_GroupFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_GroupFilter, filter.FilterValue)
			end
		end

		raidPanel.GroupFilter = _GroupFilter

		raidPanel:Refresh()
	end
end

function classFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_ClassFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_ClassFilter, filter.FilterValue)
			end
		end

		raidPanel.ClassFilter = _ClassFilter

		raidPanel:Refresh()
	end
end

function roleFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_RoleFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_RoleFilter, filter.FilterValue)
			end
		end

		raidPanel.RoleFilter = _RoleFilter

		raidPanel:Refresh()
	end
end--]]


--------------------
-- Tool function
--------------------
function AddType4Config(type, text)
	local name = System.Reflector.GetName(type)
	local btn = raidPanelConfig:AddMenuButton(text)

	btn.IsCheckButton = true
	btn.ElementName = name
	btn.ElementType = type

	raidpanelMenuArray:Insert(btn)
end

function UpdateConfig4UnitFrame(unitframe, mnuBtn)
	unitframe:GetElement(mnuBtn.ElementType).Activated = mnuBtn.Checked
end

function UpdateConfig4MenuBtn(mnuBtn, unitframe)
	return UpdateConfig4UnitFrame(unitframe, mnuBtn)
end