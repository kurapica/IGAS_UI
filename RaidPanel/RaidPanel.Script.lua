IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Script for RaidPanel
--==========================

SpellBookFrame = _G.SpellBookFrame
MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS
BOOKTYPE_SPELL = _G.BOOKTYPE_SPELL

NUM_RAID_GROUPS = _G.NUM_RAID_GROUPS
MEMBERS_PER_RAID_GROUP = _G.MEMBERS_PER_RAID_GROUP

_IGASUI_HELPFUL_SPELL = {}

Toggle = {
	Message = L"Lock Raid Panel",
	Get = function()
		return not raidPanelMask.Visible
	end,
	Set = function (value)
		if value then
			raidPanel:Refresh()
			raidPanelMask.Visible = false
			raidPanelConfig.Visible = false
		elseif not InCombatLockdown() then
			if raidPanel.Width < 4 then
				raidPanel.Element[1].Unit = "player"
			end
			raidPanelMask.Visible = true
			raidPanelConfig.Visible = true
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
			raidPanelConfig.Visible = true
		elseif info == "lock" then
			raidPanelMask.Visible = false
			raidPanelConfig.Visible = false
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

	-- System Events
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
end

function OnEnable(self)
	_LoadingConfig = GetSpecialization() or 1

	-- Update from old save
	if not _DBChar.Version then
		local oldSave = _DBChar

		_DBChar = { Version = 1 }
		_Addon._DBChar.RaidPanel = _DBChar

		-- Check Specialization
		for i = 1, 4 do
			if oldSave[i] then
				_DBChar[i] = System.Reflector.Clone(oldSave)

				for j = 1, 4 do
					_DBChar[i][j] = nil
				end

				_DBChar[i].SpellBindings = oldSave[i]
			end
		end

		if not _DBChar[_LoadingConfig] then
			_DBChar[_LoadingConfig] = System.Reflector.Clone(oldSave)
			for j = 1, 4 do
				_DBChar[_LoadingConfig][j] = nil
			end
		end
	end

	_DBChar[_LoadingConfig] = _DBChar[_LoadingConfig] or {}

	LoadConfig(_DBChar[_LoadingConfig])

	self:SecureHook("SpellButton_UpdateButton")
	LEARNED_SPELL_IN_TAB(self)
end

function LoadConfig(_DBChar)
	raidPanelConfig.Visible = false

	-- Load location
	if _DBChar.Location then
		raidPanel.Location = _DBChar.Location
	else
		raidPanel:ClearAllPoints()
		raidPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -300)
	end

	-- Load disable settings
	_DBChar.DisableElement = _DBChar.DisableElement or {}
	_DisableElement = _DBChar.DisableElement
	raidpanelMenuArray:Each(function(self)
		self.Checked = not _DisableElement[self.ElementName]

		raidPanel:Each(UpdateConfig4UnitFrame, self)
		raidPetPanel:Each(UpdateConfig4UnitFrame, self)
		raidUnitWatchPanel:Each(UpdateConfig4UnitFrame, self)
	end)

	-- Load raid panel settings
	_DBChar.RaidPanelSet = _DBChar.RaidPanelSet or {}
	_RaidPanelSet = _DBChar.RaidPanelSet

	_DBChar.RaidPetPanelSet = _DBChar.RaidPetPanelSet or {}
	_RaidPetPanelSet = _DBChar.RaidPetPanelSet

	_DBChar.RaidDeadPanelSet = _DBChar.RaidDeadPanelSet or {}
	_RaidDeadPanelSet = _DBChar.RaidDeadPanelSet

	_DBChar.RaidUnitWatchSet = _DBChar.RaidUnitWatchSet or {}
	_RaidUnitWatchSet = _DBChar.RaidUnitWatchSet

	-- Default settings
	if not next(_RaidPanelSet) then
		_RaidPanelSet.ShowRaid = true
		_RaidPanelSet.ShowParty = true
		_RaidPanelSet.ShowPlayer = true
		_RaidPanelSet.ShowSolo = true
		_RaidPanelSet.GroupBy = "GROUP"
		_RaidPanelSet.SortBy = "INDEX"
		_RaidPanelSet.Orientation = "VERTICAL"
	end

	if not next(_RaidPetPanelSet) then
		_RaidPetPanelSet.ShowRaid = true
		_RaidPetPanelSet.ShowParty = true
		_RaidPetPanelSet.ShowPlayer = true
		_RaidPetPanelSet.ShowSolo = true
		_RaidPetPanelSet.GroupBy = "GROUP"
		_RaidPetPanelSet.SortBy = "INDEX"
		_RaidPetPanelSet.Orientation = "VERTICAL"
	end

	if not next(_RaidDeadPanelSet) then
		_RaidDeadPanelSet.ShowRaid = true
		_RaidDeadPanelSet.ShowParty = false
		_RaidDeadPanelSet.ShowPlayer = false
		_RaidDeadPanelSet.ShowSolo = false
		_RaidDeadPanelSet.GroupBy = "GROUP"
		_RaidDeadPanelSet.SortBy = "INDEX"
		_RaidDeadPanelSet.Orientation = "HORIZONTAL"
	end

	if not next(_RaidUnitWatchSet) then
		_RaidUnitWatchSet.Orientation = "HORIZONTAL"
		_RaidUnitWatchSet.UnitList = { "target", "tank", "tanktarget" }
		_RaidUnitWatchSet.AutoLayout = true
	end

	if _DBChar.RaidPanelActivated == nil then
		_DBChar.RaidPanelActivated = true
	end

	if _DBChar.RaidPetPanelActivated == nil then
		_DBChar.RaidPetPanelActivated = true
	end

	if _DBChar.RaidPetPanelDeactivateInRaid == nil then
		_DBChar.RaidPetPanelDeactivateInRaid = true
	end

	if _DBChar.RaidDeadPanelActivated == nil then
		_DBChar.RaidDeadPanelActivated = false
	end

	if _DBChar.PetPanelLocation == nil then
		_DBChar.PetPanelLocation = "RIGHT"
	end

	_DBChar.ElementWidth = _DBChar.ElementWidth or 80
	raidPanel.ElementWidth = _DBChar.ElementWidth
	raidPetPanel.ElementWidth = _DBChar.ElementWidth
	raidDeadPanel.ElementWidth = _DBChar.ElementWidth
	raidUnitWatchPanel.ElementWidth = _DBChar.ElementWidth

	mnuRaidPanelSetWidth.Text = L"Width : " .. tostring(raidPanel.ElementWidth)

	_DBChar.ElementHeight = _DBChar.ElementHeight or 32
	raidPanel.ElementHeight = _DBChar.ElementHeight
	raidPetPanel.ElementHeight = _DBChar.ElementHeight
	raidDeadPanel.ElementHeight = _DBChar.ElementHeight
	raidUnitWatchPanel.ElementHeight = _DBChar.ElementHeight

	mnuRaidPanelSetHeight.Text = L"Height : " .. tostring(raidPanel.ElementHeight)

	_DBChar.PowerHeight = _DBChar.PowerHeight or 3
	UpdatePowerHeight()

	_DBChar.MacroList = _DBChar.MacroList or {}

	-- Aura Size
	auraPanelCheckArray:Each("Checked", false)

	_DBChar.AuraSize = nil
	_DBChar.BuffPanelSet = _DBChar.BuffPanelSet or {
		ColumnCount = 3,
		RowCount = 2,
		ElementSize = 16,
		Orientation = Orientation.HORIZONTAL,
		Location = { AnchorPoint("TOPLEFT", 0, 0, "iHealthBar") },
		TopToBottom = true,
		LeftToRight = true,
		ShowTooltip = true,
		RightRemove = true,
	}
	UpdateAuraPanelForAll(iBuffPanel, _DBChar.BuffPanelSet)

	_M["mnuBuffColumnCount" .. _DBChar.BuffPanelSet.ColumnCount].Checked = true
	_M["mnuBuffRowCount" .. _DBChar.BuffPanelSet.RowCount].Checked = true
	_M["mnuBuffAuraSize"].Text = L"Aura Size : " .. _DBChar.BuffPanelSet.ElementSize
	_M["mnuBuffOrientation_" .. _DBChar.BuffPanelSet.Orientation].Checked = true
	_M["mnuBuffLoc_" .. _DBChar.BuffPanelSet.Location[1].point].Checked = true
	_M["mnuBuffTopToBottom"].Checked = _DBChar.BuffPanelSet.TopToBottom
	_M["mnuBuffLeftToRight"].Checked = _DBChar.BuffPanelSet.LeftToRight
	_M["mnuBuffShowTooltip"].Checked = _DBChar.BuffPanelSet.ShowTooltip
	_M["mnuBuffRightRemove"].Checked = _DBChar.BuffPanelSet.RightRemove

	_DBChar.DebuffPanelSet = _DBChar.DebuffPanelSet or {
		ColumnCount = 3,
		RowCount = 2,
		ElementSize = 16,
		Orientation = Orientation.VERTICAL,
		Location = { AnchorPoint("BOTTOMRIGHT", 0, 0, "iHealthBar") },
		TopToBottom = false,
		LeftToRight = false,
		ShowTooltip = true,
		RightRemove = true,
	}
	UpdateAuraPanelForAll(iDebuffPanel, _DBChar.DebuffPanelSet)

	_M["mnuDebuffColumnCount" .. _DBChar.DebuffPanelSet.ColumnCount].Checked = true
	_M["mnuDebuffRowCount" .. _DBChar.DebuffPanelSet.RowCount].Checked = true
	_M["mnuDebuffAuraSize"].Text = L"Aura Size : " .. _DBChar.DebuffPanelSet.ElementSize
	_M["mnuDebuffOrientation_" .. _DBChar.DebuffPanelSet.Orientation].Checked = true
	_M["mnuDebuffLoc_" .. _DBChar.DebuffPanelSet.Location[1].point].Checked = true
	_M["mnuDebuffTopToBottom"].Checked = _DBChar.DebuffPanelSet.TopToBottom
	_M["mnuDebuffLeftToRight"].Checked = _DBChar.DebuffPanelSet.LeftToRight
	_M["mnuDebuffShowTooltip"].Checked = _DBChar.DebuffPanelSet.ShowTooltip
	_M["mnuDebuffRightRemove"].Checked = _DBChar.DebuffPanelSet.RightRemove

	_DBChar.ClassBuffPanelSet = _DBChar.ClassBuffPanelSet or {
		ColumnCount = 3,
		RowCount = 2,
		ElementSize = 16,
		Orientation = Orientation.HORIZONTAL,
		Location = { AnchorPoint("BOTTOM", 0, 0, "iHealthBar") },
		TopToBottom = false,
		LeftToRight = true,
		ShowTooltip = false,
		ShowOnPlayer = true,
	}
	UpdateAuraPanelForAll(iClassBuffPanel, _DBChar.ClassBuffPanelSet)

	_M["mnuClassBuffColumnCount" .. _DBChar.ClassBuffPanelSet.ColumnCount].Checked = true
	_M["mnuClassBuffRowCount" .. _DBChar.ClassBuffPanelSet.RowCount].Checked = true
	_M["mnuClassBuffAuraSize"].Text = L"Aura Size : " .. _DBChar.ClassBuffPanelSet.ElementSize
	_M["mnuClassBuffOrientation_" .. _DBChar.ClassBuffPanelSet.Orientation].Checked = true
	_M["mnuClassBuffLoc_" .. _DBChar.ClassBuffPanelSet.Location[1].point].Checked = true
	_M["mnuClassBuffTopToBottom"].Checked = _DBChar.ClassBuffPanelSet.TopToBottom
	_M["mnuClassBuffLeftToRight"].Checked = _DBChar.ClassBuffPanelSet.LeftToRight
	_M["mnuClassBuffShowTooltip"].Checked = _DBChar.ClassBuffPanelSet.ShowTooltip
	_M["mnuClassBuffShowOnPlayer"].Checked = _DBChar.ClassBuffPanelSet.ShowOnPlayer

	-- Load Config
	SetLocation(_DBChar.PetPanelLocation)
	if _DBChar.PetPanelLocation == "BOTTOM" then
		mnuRaidPetPanelLocationBottom.Checked = true
	else
		mnuRaidPetPanelLocationRight.Checked = true
	end

	for k, v in pairs(_RaidPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidPanel, v)
		else
			raidPanel[k] = v
		end
	end
	for k, v in pairs(_RaidPetPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidPetPanel, v)
		else
			raidPetPanel[k] = v
		end
	end
	for k, v in pairs(_RaidDeadPanelSet) do
		if k == "Orientation" then
			SetOrientation(raidDeadPanel, v)
		else
			raidDeadPanel[k] = v
		end
	end
	SetOrientation(raidUnitWatchPanel, _RaidUnitWatchSet.Orientation)
	raidpanelPropArray:Each(function(self)
		if self.ConfigValue then
			self.Checked = (self.UnitPanel[self.ConfigName] == self.ConfigValue)
		else
			self.Checked = self.UnitPanel[self.ConfigName]
		end
	end)
	mnuRaidPetPanelDeactivateInRaid.Checked = _DBChar.RaidPetPanelDeactivateInRaid
	mnuRaidPanelActivated.Checked = _DBChar.RaidPanelActivated
	mnuRaidPetPanelActivated.Checked = _DBChar.RaidPetPanelActivated
	mnuRaidDeadPanelActivated.Checked = _DBChar.RaidDeadPanelActivated

	-- Filter Settings
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
				return
			end
		end
		self.Checked = false
	end)
	classFilterArray:Each(function(self)
		for _, v in ipairs(_ClassFilter) do
			if v == self.FilterValue then
				self.Checked = true
				return
			end
		end
		self.Checked = false
	end)
	roleFilterArray:Each(function(self)
		for _, v in ipairs(_RoleFilter) do
			if v == self.FilterValue then
				self.Checked = true
				return
			end
		end
		self.Checked = false
	end)

	-- Filter for dead
	_DBChar.DeadGroupFilter = _DBChar.DeadGroupFilter or {}
	_DBChar.DeadClassFilter = _DBChar.DeadClassFilter or {}
	_DBChar.DeadRoleFilter = _DBChar.DeadRoleFilter or {}
	_DeadGroupFilter = _DBChar.DeadGroupFilter
	_DeadClassFilter = _DBChar.DeadClassFilter
	_DeadRoleFilter = _DBChar.DeadRoleFilter

	raidDeadPanel.GroupFilter = _DeadGroupFilter
	raidDeadPanel.ClassFilter = _DeadClassFilter
	raidDeadPanel.RoleFilter = _DeadRoleFilter

	groupDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadGroupFilter) do
			if v == self.FilterValue then
				self.Checked = true
				return
			end
		end
		self.Checked = false
	end)
	classDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadClassFilter) do
			if v == self.FilterValue then
				self.Checked = true
				return
			end
		end
		self.Checked = false
	end)
	roleDeadFilterArray:Each(function(self)
		for _, v in ipairs(_DeadRoleFilter) do
			if v == self.FilterValue then
				self.Checked = true
				return
			end
		end
		self.Checked = false
	end)

	-- Debuff filter
	_DB.DebuffSpellList = nil
	_DB.DebuffBlackList = _DB.DebuffBlackList or {}

	_DebuffBlackList = _DB.DebuffBlackList

	-- Buff filter
	_DBChar.BuffBlackList = nil
	_DB.BuffBlackList = _DB.BuffBlackList or {}
	_BuffBlackList = _DB.BuffBlackList

	-- ClassBuff filter
	_DB.ClassBuffList = _DB.ClassBuffList or BaseClassBuffList
	_ClassBuffList = _DB.ClassBuffList
	BuildClassBuffMap()

	-- Buff order List
	_DBChar.BuffOrderList = _DBChar.BuffOrderList or {}
	_BuffOrderList = _DBChar.BuffOrderList

	BuilderBuffOrderCache()

	-- Default true
	_DBChar.DebuffRightMouseRemove = nil
	_DBChar.ShowDebuffTooltip = nil

	-- Spell bindings
	if _DBChar.SpellBindings then
		_IGASUI_SPELLHANDLER:Import(_DBChar.SpellBindings)
	end

	if _DBChar.ElementUseClassColor == nil then _DBChar.ElementUseClassColor = true end
	if _DBChar.ElementUseDebuffColor == nil then _DBChar.ElementUseDebuffColor = true end
	if _DBChar.ElementUseSmoothColor == nil then _DBChar.ElementUseSmoothColor = true end
	if _DBChar.ElementUseMouseDown == nil then _DBChar.ElementUseMouseDown = true end
	if _DBChar.ElementSmoothUpdate == nil then _DBChar.ElementSmoothUpdate = false end
	if _DBChar.ElementSmoothUpdateDelay == nil then _DBChar.ElementSmoothUpdateDelay = 0.2 end

	mnuRaidPanelSetUseClassColor.Checked = _DBChar.ElementUseClassColor
	mnuRaidPanelSetUseDebuffColor.Checked = _DBChar.ElementUseDebuffColor
	mnuRaidPanelSetUseSmoothColor.Checked = _DBChar.ElementUseSmoothColor
	mnuRaidPanelSetUseDown.Checked = _DBChar.ElementUseMouseDown
	mnuRaidPanelSetSmooth.Checked = _DBChar.ElementSmoothUpdate
	mnuRaidPanelSetSmoothDelay.Text = L"Smoothing delay" .. " : " .. _DBChar.ElementSmoothUpdateDelay
	UpdateHealthBar4UseClassColor()

	raidPanel:InitWithCount(25)
	raidPanel.Activated = _DBChar.RaidPanelActivated

	raidPetPanel:InitWithCount(10)
	raidPetPanel.DeactivateInRaid = _DBChar.RaidPetPanelDeactivateInRaid
	raidPetPanel.Activated = _DBChar.RaidPetPanelActivated

	raidDeadPanel:InitWithCount(10)
	raidDeadPanel.Activated = _DBChar.RaidDeadPanelActivated

	mnuRaidUnitwatchAutoLayout.Checked = _RaidUnitWatchSet.AutoLayout
	raidUnitWatchPanel.KeepMaxSize = not _RaidUnitWatchSet.AutoLayout
	raidUnitWatchPanel.AutoPosition = _RaidUnitWatchSet.AutoLayout

	mnuRaidUnitwatchOnlyEnemy.Enabled = _RaidUnitWatchSet.AutoLayout
	mnuRaidUnitwatchOnlyEnemy.Checked = _RaidUnitWatchSet.AutoLayout and _RaidUnitWatchSet.OnlyEnemy

	InstallUnitList()
end

function BuilderBuffOrderCache()
	_BuffOrderCache = { MAX = #_BuffOrderList }

	for i, v in ipairs(_BuffOrderList) do
		_BuffOrderCache[v] = i
	end
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
		_DBChar[_LoadingConfig].SpellBindings = _IGASUI_SPELLHANDLER:Export()

		if not _DBChar[now] then
			_DBChar[now] = System.Reflector.Clone(_DBChar[_LoadingConfig])
			_DBChar[now].SpellBindings = nil
		end

		_LoadingConfig = now

		LoadConfig(_DBChar[now])
	end
	LEARNED_SPELL_IN_TAB(self)
end

PLAYER_ENTERING_WORLD = PLAYER_SPECIALIZATION_CHANGED

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
	_DBChar[_LoadingConfig].SpellBindings = _IGASUI_SPELLHANDLER:Export()
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
	_DBChar[_LoadingConfig].Location = raidPanel.Location
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
	return InitUnitFrame(unitframe)
end

function raidPetPanel:OnElementAdd(unitframe)
	return InitUnitFrame(unitframe)
end

function raidUnitWatchPanel:OnElementAdd(unitframe)
	return InitUnitFrame(unitframe)
end

function raidUnitWatchPanel:OnElementRemove(unitframe)
	if unitframe.StateRegistered then
		unitframe:UnregisterStateDriver("visibility")
		unitframe.StateRegistered = false
	end
	unitframe.Unit = nil
	unitframe.Visible = false
end

function mnuRaidPanelSetWidth:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the element's width(px)", "ic") or nil)

	if value and value > 10 then
		_DBChar[_LoadingConfig].ElementWidth = value
		raidPanel.ElementWidth = value
		raidPetPanel.ElementWidth = value
		raidDeadPanel.ElementWidth = value
		raidUnitWatchPanel.ElementWidth = value

		self.Text = L"Width : " .. tostring(value)

		if raidPanelMask.Visible then
			raidPanelMask:SetSize(raidPanel:GetSize())
		end
	end
end

function mnuRaidPanelSetHeight:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the element's height(px)", "ic") or nil)

	if value and value > _DBChar[_LoadingConfig].PowerHeight then
		_DBChar[_LoadingConfig].ElementHeight = value
		raidPanel.ElementHeight = value
		raidPetPanel.ElementHeight = value
		raidDeadPanel.ElementHeight = value
		raidUnitWatchPanel.ElementHeight = value

		self.Text = L"Height : " .. tostring(value)

		if raidPanelMask.Visible then
			raidPanelMask:SetSize(raidPanel:GetSize())
		end
	end
end

function mnuRaidPanelSetPowerHeight:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the power bar's height(px)", "ic") or nil)

	if value and value > 0 and value < raidPanel.ElementHeight then
		_DBChar[_LoadingConfig].PowerHeight = value

		UpdatePowerHeight()
	end
end

function mnuRaidPanelSetSmoothDelay:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the smoothing update delay(s)", "ic")) or nil

	if value and value >= 0.1 then
		_DBChar[_LoadingConfig].ElementSmoothUpdateDelay = value
		self.Text = L"Smoothing delay" .. " : " .. value
		UpdateHealthBar4UseClassColor()
	end
end

function mnuRaidPanelSetUseClassColor:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].ElementUseClassColor = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function mnuRaidPanelSetUseDebuffColor:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].ElementUseDebuffColor = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function mnuRaidPanelSetUseSmoothColor:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].ElementUseSmoothColor = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function mnuRaidPanelSetUseDown:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].ElementUseMouseDown = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function mnuRaidPanelSetSmooth:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].ElementSmoothUpdate = self.Checked

		UpdateHealthBar4UseClassColor()
	end
end

function raidpanelMenuArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		_DisableElement[self[index].ElementName] = not self[index].Checked

		raidPanel:Each(UpdateConfig4UnitFrame, self[index])
		raidPetPanel:Each(UpdateConfig4UnitFrame, self[index])
		raidUnitWatchPanel:Each(UpdateConfig4UnitFrame, self[index])
	end
end

function raidpanelPropArray:OnCheckChanged(index)
	if raidPanelConfig.Visible and (self[index].Checked or not self[index].ConfigValue) then
		if self[index].ConfigName == "Orientation" then
			SetOrientation(self[index].UnitPanel, self[index].ConfigValue)
		else
			self[index].UnitPanel[self[index].ConfigName] = self[index].ConfigValue or self[index].Checked
		end

		-- keep set
		if self[index].UnitPanel == raidPanel then
			_RaidPanelSet[self[index].ConfigName] = raidPanel[self[index].ConfigName]
		elseif self[index].UnitPanel == raidPetPanel then
			_RaidPetPanelSet[self[index].ConfigName] = raidPetPanel[self[index].ConfigName]
		elseif self[index].UnitPanel == raidDeadPanel then
			_RaidDeadPanelSet[self[index].ConfigName] = raidDeadPanel[self[index].ConfigName]
		elseif self[index].UnitPanel == raidUnitWatchPanel then
			_RaidUnitWatchSet[self[index].ConfigName] = raidUnitWatchPanel[self[index].ConfigName]
		end
	end
end

function mnuRaidPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].RaidPanelActivated = self.Checked

		raidPanel.Activated = _DBChar[_LoadingConfig].RaidPanelActivated
	end
end

function mnuRaidPetPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].RaidPetPanelActivated = self.Checked

		raidPetPanel.Activated = _DBChar[_LoadingConfig].RaidPetPanelActivated
	end
end

function mnuRaidPetPanelDeactivateInRaid:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].RaidPetPanelDeactivateInRaid = self.Checked

		raidPetPanel.DeactivateInRaid = _DBChar[_LoadingConfig].RaidPetPanelDeactivateInRaid
	end
end

function mnuRaidDeadPanelActivated:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DBChar[_LoadingConfig].RaidDeadPanelActivated = self.Checked

		raidDeadPanel.Activated = _DBChar[_LoadingConfig].RaidDeadPanelActivated
	end
end

function mnuRaidPetPanelLocationRight:OnCheckChanged()
	if raidPanelConfig.Visible and self.Checked then
		SetLocation("RIGHT")
	end
end

function mnuRaidPetPanelLocationBottom:OnCheckChanged()
	if raidPanelConfig.Visible and self.Checked then
		SetLocation("BOTTOM")
	end
end

function groupFilterArray:OnCheckChanged(index)
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
end

function groupDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadGroupFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadGroupFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.GroupFilter = _DeadGroupFilter

		raidDeadPanel:Refresh()
	end
end

function classDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadClassFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadClassFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.ClassFilter = _DeadClassFilter

		raidDeadPanel:Refresh()
	end
end

function roleDeadFilterArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		wipe(_DeadRoleFilter)

		for _, filter in ipairs(self) do
			if filter.Checked then
				tinsert(_DeadRoleFilter, filter.FilterValue)
			end
		end

		raidDeadPanel.RoleFilter = _DeadRoleFilter

		raidDeadPanel:Refresh()
	end
end

function mnuRaidUnitWatchList:OnClick()
	lstWatchUnit.Keys = _RaidUnitWatchSet.UnitList
	lstWatchUnit.Items = _RaidUnitWatchSet.UnitList

	frmUnitList.Visible = true
	frmUnitList.Modified = false
end

function mnuRaidUnitwatchAutoLayout:OnCheckChanged()
	if raidPanelConfig.Visible then
		_RaidUnitWatchSet.AutoLayout = self.Checked

		raidUnitWatchPanel.KeepMaxSize = not _RaidUnitWatchSet.AutoLayout
		raidUnitWatchPanel.AutoPosition = _RaidUnitWatchSet.AutoLayout

		if not self.Checked then
			_RaidUnitWatchSet.OnlyEnemy = false
			mnuRaidUnitwatchOnlyEnemy.Checked = false
			mnuRaidUnitwatchOnlyEnemy.Enabled = false
		else
			mnuRaidUnitwatchOnlyEnemy.Enabled = true
		end

		InstallUnitList()
	end
end

function mnuRaidUnitwatchOnlyEnemy:OnCheckChanged()
	if raidPanelConfig.Visible then
		_RaidUnitWatchSet.OnlyEnemy = self.Checked

		InstallUnitList()
	end
end

function mnuRaidPanelModifyAnchors:OnClick()
	IGAS:ManageAnchorPoint(raidPanel, nil, true)

	_DBChar[_LoadingConfig].Location = raidPanel.Location
end

function auraPanelCheckArray:OnCheckChanged(index)
	if raidPanelConfig.Visible then
		local chkBtn = self[index]
		local set = chkBtn.ConfigSet

		if chkBtn.IsToggle then
			_DBChar[_LoadingConfig][set][chkBtn.ConfigName] = chkBtn.Checked

			if set == "BuffPanelSet" then
				return UpdateAuraPanelForAll(iBuffPanel, _DBChar[_LoadingConfig][set])
			elseif set == "DebuffPanelSet" then
				return UpdateAuraPanelForAll(iDebuffPanel, _DBChar[_LoadingConfig][set])
			elseif set == "ClassBuffPanelSet" then
				return UpdateAuraPanelForAll(iClassBuffPanel, _DBChar[_LoadingConfig][set])
			end
		elseif chkBtn.Checked then
			_DBChar[_LoadingConfig][set][chkBtn.ConfigName] = chkBtn.ConfigValue

			if set == "BuffPanelSet" then
				return UpdateAuraPanelForAll(iBuffPanel, _DBChar[_LoadingConfig][set])
			elseif set == "DebuffPanelSet" then
				return UpdateAuraPanelForAll(iDebuffPanel, _DBChar[_LoadingConfig][set])
			elseif set == "ClassBuffPanelSet" then
				return UpdateAuraPanelForAll(iClassBuffPanel, _DBChar[_LoadingConfig][set])
			end
		end
	end
end

function auraPanelSizeArray:OnClick(index)
	local set = self[index].ConfigSet
	local value = tonumber(IGAS:MsgBox(L"Please input the aura's size(px)", "ic") or nil)

	if value and value > 0 then
		_DBChar[_LoadingConfig][set].ElementSize = value
		if set == "BuffPanelSet" then
			_M["mnuBuffAuraSize"].Text = L"Aura Size : " .. _DBChar[_LoadingConfig][set].ElementSize
			return UpdateAuraPanelForAll(iBuffPanel, _DBChar[_LoadingConfig][set])
		elseif set == "DebuffPanelSet" then
			_M["mnuDebuffAuraSize"].Text = L"Aura Size : " .. _DBChar[_LoadingConfig][set].ElementSize
			return UpdateAuraPanelForAll(iDebuffPanel, _DBChar[_LoadingConfig][set])
		elseif set == "ClassBuffPanelSet" then
			_M["mnuClassBuffAuraSize"].Text = L"Aura Size : " .. _DBChar[_LoadingConfig][set].ElementSize
			return UpdateAuraPanelForAll(iClassBuffPanel, _DBChar[_LoadingConfig][set])
		end
	end
end

function btnAdd:OnClick()
	local unit = IGAS:MsgBox(L"Please input the unit id", "ic")

	if unit and strtrim(unit) ~= "" then
		unit = strlower(strtrim(unit))

		for _, v in ipairs(lstWatchUnit.Keys) do
			if v == unit then return end
		end

		tinsert(_RaidUnitWatchSet.UnitList, unit)
		lstWatchUnit:Refresh()
		frmUnitList.Modified = true
	end
end

function btnRemove:OnClick()
	local index = lstWatchUnit.SelectedIndex
	if index > 0 and IGAS:MsgBox(L"Are you sure to delete the unit id", "n") then
		tremove(_RaidUnitWatchSet.UnitList, index)
		lstWatchUnit:Refresh()
		frmUnitList.Modified = true
	end
end

function btnUp:OnClick()
	local index = lstWatchUnit.SelectedIndex
	if index > 1 then
		local lst = _RaidUnitWatchSet.UnitList

		lst[index], lst[index-1] = lst[index-1], lst[index]
		lstWatchUnit:Refresh()
		lstWatchUnit.SelectedIndex = index - 1
		frmUnitList.Modified = true
	end
end

function btnDown:OnClick()
	local index = lstWatchUnit.SelectedIndex
	local lst = _RaidUnitWatchSet.UnitList

	if index > 0 and index < #lst  then
		lst[index], lst[index+1] = lst[index+1], lst[index]
		lstWatchUnit:Refresh()
		lstWatchUnit.SelectedIndex = index + 1
		frmUnitList.Modified = true
	end
end

function btnInfo:OnClick()
	helper.Visible = true
	helper.Text = L"Unit List Info"
end

function frmUnitList:OnHide()
	helper.Visible = false

	if frmUnitList.Modified then
		InstallUnitList()
	end
end

local _prev = GetTime()

function IGAS.GameTooltip:OnTooltipSetSpell()
	if GetTime() == _prev then return end
	_prev = GetTime()

	local name, rank, id = self:GetSpell()
	if id then
		self:AddLine("    ")
		self:AddLine("ID: " .. tostring(id), 1, 1, 1)
	end
end

function mnuRaidPanelMacroBind:OnClick()
	MacroBindingRow.RefreshAll()

	frmMacroBindPanel:Show()
end

function btnAddMacro:OnClick()
	MacroBindingRow.NewRow()
end

function frmMacroBindPanel:OnShow()
	frmMacroBindPanel.OnShow = nil

	local tipCnt = 1
	_Tips = {
		L"Use '%unit' in macro as spell target",
		L"You can drag spell into the edit box",
	}
	Task.ThreadCall(function()
		while true do
			frmMacroBindPanel.Message = _Tips[tipCnt]
			tipCnt = tipCnt + 1
			if tipCnt > #_Tips then tipCnt = 1 end
			Task.Delay(5)
		end
	end)
end

function frmMacroBindPanel:OnHide()
	Task.NoCombatCall(MacroBindingRow.ApplyNewSettings)
end

--------------------
-- Tool function
--------------------
function BuildClassBuffMap()
	_ClassBuffMap = _ClassBuffMap or {}
	wipe(_ClassBuffMap)

	for i, v in ipairs(_ClassBuffList) do
		_ClassBuffMap[v] = i
	end
end

function AddType4Config(type, text)
	local name = System.Reflector.GetNameSpaceName(type)
	local btn = raidPanelConfig:AddMenuButton(L"Indicator", text)

	btn.IsCheckButton = true
	btn.ElementName = name
	btn.ElementType = type

	raidpanelMenuArray:Insert(btn)
end

function UpdateConfig4UnitFrame(unitframe, mnuBtn)
	local ele = unitframe:GetElement(mnuBtn.ElementType)
	if ele then ele.Activated = mnuBtn.Checked end
end

function UpdateConfig4MenuBtn(mnuBtn, unitframe)
	return UpdateConfig4UnitFrame(unitframe, mnuBtn)
end

function SetOrientation(self, value)
	self.Orientation = value

	if self.Orientation == "HORIZONTAL" then
		self.RowCount = NUM_RAID_GROUPS
		self.ColumnCount = MEMBERS_PER_RAID_GROUP
	else
		self.ColumnCount = NUM_RAID_GROUPS
		self.RowCount = MEMBERS_PER_RAID_GROUP
	end
end

function SetLocation(value)
	_DBChar[_LoadingConfig].PetPanelLocation = value

	Task.NoCombatCall(function()
		if value == "RIGHT" then
			raidPetPanel:ClearAllPoints()
			raidPetPanel:SetPoint("TOPLEFT", raidPanel, "TOPRIGHT")

			raidDeadPanel:ClearAllPoints()
			raidDeadPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")
		elseif value == "BOTTOM" then
			raidPetPanel:ClearAllPoints()
			raidPetPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")

			raidDeadPanel:ClearAllPoints()
			raidDeadPanel:SetPoint("TOPLEFT", raidPetPanel, "BOTTOMLEFT")
		end
	end)
end

function UpdateHealthBar4UseClassColor()
	local useClassColor = _DBChar[_LoadingConfig].ElementUseClassColor
	local useDebuffColor = _DBChar[_LoadingConfig].ElementUseDebuffColor
	local useSmoothColor = _DBChar[_LoadingConfig].ElementUseSmoothColor
	local useMouseDown = _DBChar[_LoadingConfig].ElementUseMouseDown and "AnyDown" or "AnyUp"
	local smoothUpdate = _DBChar[_LoadingConfig].ElementSmoothUpdate
	local smoothdelay = _DBChar[_LoadingConfig].ElementSmoothUpdateDelay
	raidPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = useClassColor
		self:GetElement(iHealthBar).UseDebuffColor = useDebuffColor
		self:GetElement(iHealthBar).UseSmoothColor = useSmoothColor
		self:GetElement(iHealthBar).Smoothing = smoothUpdate
		self:GetElement(iHealthBar).SmoothDelay = smoothdelay
		self:RegisterForClicks(useMouseDown)
	end)
	raidPetPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = useClassColor
		self:GetElement(iHealthBar).UseDebuffColor = useDebuffColor
		self:GetElement(iHealthBar).UseSmoothColor = useSmoothColor
		self:GetElement(iHealthBar).Smoothing = smoothUpdate
		self:GetElement(iHealthBar).SmoothDelay = smoothdelay
		self:RegisterForClicks(useMouseDown)
	end)
	raidDeadPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = useClassColor
		self:GetElement(iHealthBar).UseDebuffColor = useDebuffColor
		self:GetElement(iHealthBar).UseSmoothColor = useSmoothColor
		self:GetElement(iHealthBar).Smoothing = smoothUpdate
		self:GetElement(iHealthBar).SmoothDelay = smoothdelay
		self:RegisterForClicks(useMouseDown)
	end)
	raidUnitWatchPanel:Each(function(self)
		self:GetElement(iHealthBar).UseClassColor = useClassColor
		self:GetElement(iHealthBar).UseDebuffColor = useDebuffColor
		self:GetElement(iHealthBar).UseSmoothColor = useSmoothColor
		self:GetElement(iHealthBar).Smoothing = smoothUpdate
		self:GetElement(iHealthBar).SmoothDelay = smoothdelay
		self:RegisterForClicks(useMouseDown)
	end)
end

function UpdatePowerHeight()
	local value = _DBChar[_LoadingConfig].PowerHeight

	raidPanel:Each(function (self)
		if self:GetElement(iPowerBar) then
			self:AddElement(iPowerBar, "south", value, "px")
		end
	end)
	raidPetPanel:Each(function(self)
		if self:GetElement(iPowerBar) then
			self:AddElement(iPowerBar, "south", value, "px")
		end
	end)
	raidUnitWatchPanel:Each(function (self)
		if self:GetElement(iPowerBar) then
			self:AddElement(iPowerBar, "south", value, "px")
		end
	end)

	mnuRaidPanelSetPowerHeight.Text = L"Power Height : " .. tostring(value)
end

function InitUnitFrame(unitframe)
	raidpanelMenuArray:Each(UpdateConfig4MenuBtn, unitframe)

	local ele = unitframe:GetElement(iPowerBar)

	if ele then
		unitframe:AddElement(iPowerBar, "south", _DBChar[_LoadingConfig].PowerHeight, "px")
	end

	-- Init the aura panels
	UpdateAuraPanel(unitframe, iBuffPanel, _DBChar[_LoadingConfig].BuffPanelSet)
	UpdateAuraPanel(unitframe, iDebuffPanel, _DBChar[_LoadingConfig].DebuffPanelSet)
	UpdateAuraPanel(unitframe, iClassBuffPanel, _DBChar[_LoadingConfig].ClassBuffPanelSet)
end

-- Aura Panels
function UpdateAuraPanel(self, type, config)
	local ele = self:GetElement(type)
	if ele then
		ele.ColumnCount = config.ColumnCount
		ele.RowCount = config.RowCount
		ele.ElementWidth = config.ElementSize
		ele.ElementHeight = config.ElementSize
		ele.Orientation = config.Orientation
		ele.TopToBottom = config.TopToBottom
		ele.LeftToRight = config.LeftToRight
		ele.Location = config.Location

		ele:Each("ShowTooltip", config.ShowTooltip)
		ele:Each("MouseEnabled", config.ShowTooltip or config.RightRemove)
	end
end

function UpdateAuraPanelForAll(type, config)
	if type == iBuffPanel then
		local font = AuraCountFont_Buff.Font
		font.height = config.ElementSize
		AuraCountFont_Buff.Font = font
	elseif type == iDebuffPanel then
		local font = AuraCountFont_Debuff.Font
		font.height = config.ElementSize
		AuraCountFont_Debuff.Font = font
	elseif type == iClassBuffPanel then
		local font = AuraCountFont_ClassBuff.Font
		font.height = config.ElementSize
		AuraCountFont_ClassBuff.Font = font
	end

	raidPanel:Each(UpdateAuraPanel, type, config)
	raidPetPanel:Each(UpdateAuraPanel, type, config)
	raidUnitWatchPanel:Each(UpdateAuraPanel, type, config)
end

-- Unit List

local _TempList = {}
local _TankList = {}
local _RefreshUnitListMark = 0

function InstallUnitList()
	_RefreshUnitListMark = _RefreshUnitListMark + 1

	return RefreshUnitList()
end

function RefreshUnitList()
	Task.NoCombatCall(function()
		local list = _RaidUnitWatchSet.UnitList
		local scanRole = false

		for i, unit in ipairs(list) do
			if unit:match("maintank") or unit:match("mainassist") or unit:match("tank") then
				scanRole = true
				break
			end
		end

		if scanRole then
			wipe(_TempList)
			wipe(_TankList)

			local unit
			local maintank, mainassist

			if IsInRaid() then
				for i = 1, GetNumGroupMembers() do
					unit = "raid" .. i
					if GetPartyAssignment("MAINTANK", unit) then
						maintank = unit
					elseif GetPartyAssignment("MAINASSIST", unit) then
						mainassist = unit
					end

					if UnitGroupRolesAssigned(unit) == "TANK" then
						tinsert(_TankList, unit)
					end
				end
			else
				for i = 0, GetNumSubgroupMembers() do
					unit = i == 0 and "player" or ("party" .. i)

					if GetPartyAssignment("MAINTANK", unit) then
						maintank = unit
					elseif GetPartyAssignment("MAINASSIST", unit) then
						mainassist = unit
					end

					if UnitGroupRolesAssigned(unit) == "TANK" then
						tinsert(_TankList, unit)
					end
				end
			end

			for i, unit in ipairs(list) do
				if unit:match("maintank") then
					if maintank then
						unit = unit:gsub("maintank", maintank)
						if not _TempList[unit] then
							_TempList[unit] = true
							tinsert(_TempList, unit)
						end
					end
				elseif unit:match("mainassist") then
					if mainassist then
						unit = unit:gsub("mainassist", mainassist)
						if not _TempList[unit] then
							_TempList[unit] = true
							tinsert(_TempList, unit)
						end
					end
				elseif unit:match("tank") then
					if #_TankList > 0 then
						for _, tank in ipairs(_TankList) do
							tunit = unit:gsub("tank", tank)
							if not _TempList[tunit] then
								_TempList[tunit] = true
								tinsert(_TempList, tunit)
							end
						end
					end
				else
					if not _TempList[unit] then
						_TempList[unit] = true
						tinsert(_TempList, unit)
					end
				end
			end

			raidUnitWatchPanel.Count = #_TempList

			for i, unit in ipairs(_TempList) do
				local unitframe = raidUnitWatchPanel.Element[i]
				if unitframe.StateRegistered then
					unitframe:UnregisterStateDriver("visibility")
					unitframe.StateRegistered = false
				end
				unitframe.Unit = unit

				if _RaidUnitWatchSet.AutoLayout then
					if _RaidUnitWatchSet.OnlyEnemy and not unit:match("nameplate") then
						unitframe.NoUnitWatch = true
						unitframe.StateRegistered = true
						unitframe:RegisterStateDriver("visibility", ("[@%s,harm]show;hide"):format(unit))
					else
						unitframe.NoUnitWatch = false
					end
				else
					unitframe.NoUnitWatch = true
					unitframe.Visible = true
				end
			end

			wipe(_TempList)
			wipe(_TankList)

			local currentMark = _RefreshUnitListMark

			Task.WaitCall("GROUP_ROSTER_UPDATE", "UNIT_NAME_UPDATE", function()
				if currentMark == _RefreshUnitListMark then
					return RefreshUnitList()
				end
			end)
		else
			raidUnitWatchPanel.Count = #list

			for i, unit in ipairs(list) do
				local unitframe = raidUnitWatchPanel.Element[i]
				if unitframe.StateRegistered then
					unitframe:UnregisterStateDriver("visibility")
					unitframe.StateRegistered = false
				end
				unitframe.Unit = unit
				if _RaidUnitWatchSet.AutoLayout then
					if _RaidUnitWatchSet.OnlyEnemy and not unit:match("nameplate") then
						unitframe.NoUnitWatch = true
						unitframe.StateRegistered = true
						unitframe:RegisterStateDriver("visibility", ("[@%s,harm]show;hide"):format(unit))
					else
						unitframe.NoUnitWatch = false
					end
				else
					unitframe.NoUnitWatch = true
					unitframe.Visible = true
				end
			end
		end
	end)
end

--------------------
-- Load elements menu
--------------------
local order = {}

for _, ele in pairs(Config.Elements) do
	if ele.Locale and ele.Index then
		order[ele.Index] = ele
	end
end

for _, ele in ipairs(order) do
	AddType4Config(ele.Type, ele.Locale)
end

order = nil
