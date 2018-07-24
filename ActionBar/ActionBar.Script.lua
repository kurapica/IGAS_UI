-----------------------------------------
-- Script for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

Toggle = {
	Message = L"Lock Action Bar",
	Get = function()
		return _DBChar.LockBar
	end,
	Set = function (value)
		_DBChar.LockBar = value
		_HeadList:Each(function(self)
			self.LockMode = value
			self.IHeader.Visible = not value
			if not value then
				self.__AutoFadeOutStart = false
				self.FadeAlpha = 1
				self.Visible = true
			else
				self:RefreshForAutoHide()
			end
		end)
		if _BagSlotBar then
			_BagSlotBar.IHeader.Visible = not value
		end
		if value then UpdateStanceBar() end
		Toggle.Update()
	end,
	Update = function() end,
}

local _MainBar = nil
local _PetBar = nil
local _StanceBar = nil
local _BagSlotBar = nil
local _WorldMarkerBar = nil
local _RaidTargetBar = nil

_QuestMap = {}
_ItemType = nil

_HiddenMainMenuBar = false
_BagSlotBarConfig = nil

ITEM_CONSUMABLE = 4
ITEM_QUEST = 10

_HiddenFrame = CreateFrame("Frame")	-- No need use IGAS frame
_HiddenFrame:Hide()
_HiddenFrame.OnStatusBarsUpdated = function() end

GameTooltip = _G.GameTooltip
UIParent = _G.UIParent
ITEM_BIND_QUEST = _G.ITEM_BIND_QUEST

COLOR_NORMAL = ColorType(1, 1, 1)
COLOR_OOR = ColorType(1, 0.3, 0.1)
COLOR_OOM = ColorType(0.1, 0.3, 1)
COLOR_UNUSABLE = ColorType(0.4, 0.4, 0.4)

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	_DB = _Addon._DB.ActionBar or {}
	_DBChar = _Addon._DBChar.ActionBar or {}
	_Addon._DB.ActionBar = _DB
	_Addon._DBChar.ActionBar = _DBChar

	-- Load layout
	_LayoutSave = {L"New Layout"}
	_LayoutLoad = {L"Reset"}

	for name in pairs(_DB) do
		tinsert(_LayoutSave, name)
		tinsert(_LayoutLoad, name)
	end

	_ListSave.Keys = _LayoutSave
	_ListSave.Items = _LayoutSave
	_ListLoad.Keys = _LayoutLoad
	_ListLoad.Items = _LayoutLoad

	-- Load settings
	_DBCharSet = _DBChar.ActionSet or {}
	_DBChar.ActionSet = _DBCharSet

	_DBAutoPopupList = _Addon._DB.AutoPopupList or {}
	_Addon._DB.AutoPopupList = _DBAutoPopupList

	for name, popset in pairs(_DBAutoPopupList) do
		autoList:AddItem(name, name)
	end

	_ActionSetSave = {L"New Set"}
	_ActionSetLoad = {}

	for name in pairs(_DBCharSet) do
		tinsert(_ActionSetSave, name)
		tinsert(_ActionSetLoad, name)
	end

	_ListSaveSet.Keys = _ActionSetSave
	_ListSaveSet.Items = _ActionSetSave
	_ListLoadSet.Keys = _ActionSetLoad
	_ListLoadSet.Items = _ActionSetLoad

	-- Action bar's layout
	_ActionBarLayout = _Addon._DB.ActionBarLayout or {}
	_Addon._DB.ActionBarLayout = _ActionBarLayout

	_ActionBarLayoutSave = {L"New Layout"}
	_ActionBarLayoutLoad = {L"Reset"}

	for name in pairs(_ActionBarLayout) do
		tinsert(_ActionBarLayoutSave, name)
		tinsert(_ActionBarLayoutLoad, name)
	end

	_ListBarSave.Keys = _ActionBarLayoutSave
	_ListBarSave.Items = _ActionBarLayoutSave
	_ListBarLoad.Keys = _ActionBarLayoutLoad
	_ListBarLoad.Items = _ActionBarLayoutLoad

	-- Action bar's settings
	_ActionBarSettings = _Addon._DB.ActionBarSettings or {}
	_Addon._DB.ActionBarSettings = _ActionBarSettings

	_ActionBarSettingsSave = {L"New Set"}
	_ActionBarSettingsLoad = {L"Reset"}

	for name in pairs(_ActionBarSettings) do
		tinsert(_ActionBarSettingsSave, name)
		tinsert(_ActionBarSettingsLoad, name)
	end

	_ListBarContentSave.Keys = _ActionBarSettingsSave
	_ListBarContentSave.Items = _ActionBarSettingsSave
	_ListBarContentLoad.Keys = _ActionBarSettingsLoad
	_ListBarContentLoad.Items = _ActionBarSettingsLoad

	-- Global Styles
	_ActionBarGlobalStyle = _Addon._DB.ActionBarGlobalStyle or {}
	_Addon._DB.ActionBarGlobalStyle = _ActionBarGlobalStyle

	-- Unusable color
	_ActionBarColorUnusable = _ActionBarGlobalStyle.ColorUnusable or {
		ENABLE = false,
		OOM = COLOR_OOM,
		OOR = COLOR_OOR,
		UNUSABLE = COLOR_UNUSABLE,
	}
	_ActionBarGlobalStyle.ColorUnusable = _ActionBarColorUnusable

	_MenuColorOOM.Color = _ActionBarColorUnusable.OOM
	_MenuColorOOR.Color = _ActionBarColorUnusable.OOR
	_MenuColorUnusable.Color = _ActionBarColorUnusable.UNUSABLE

	COLOR_OOM = _ActionBarColorUnusable.OOM
	COLOR_OOR = _ActionBarColorUnusable.OOR
	COLOR_UNUSABLE = _ActionBarColorUnusable.UNUSABLE

	if _ActionBarColorUnusable.ENABLE then
		_MenuColorToggle.Text = L"Disable"

		InstallUnusableColor()
	else
		_MenuColorToggle.Text = L"Enable"
	end

	-- Use cooldown label
	_ActionBarUseCooldownLabel = _ActionBarGlobalStyle.UseCooldownLabel or { ENABLE = false }
	_ActionBarGlobalStyle.UseCooldownLabel = _ActionBarUseCooldownLabel

	if _ActionBarUseCooldownLabel.ENABLE then
		_MenuCDLabelToggle.Text = L"Disable"

		InstallUseCooldownLabel()
	else
		_MenuCDLabelToggle.Text = L"Enable"
	end

	-- Hide global cooldown
	_ActionBarHideGlobalCD = _ActionBarGlobalStyle.HideGlobalCD or { ENABLE = false }
	_ActionBarGlobalStyle.HideGlobalCD = _ActionBarHideGlobalCD
	_MenuNoGCD.Checked = _ActionBarHideGlobalCD.ENABLE

	-- Auto-gen item black list
	_AutoGenItemBlackList = _DBChar.AutoGenItemBlackList or {}
	_DBChar.AutoGenItemBlackList = _AutoGenItemBlackList

	-- Global action bars
	_GlobalActionBar = _Addon._DB.GlobalActionBar or {}
	_Addon._DB.GlobalActionBar = _GlobalActionBar

	-- Register system events
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("ACTIONBAR_HIDEGRID")

	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

	LoadGlobalActionBar()

	self:ActiveThread("OnEnable")
end

function OnEnable(self)
	_LoadingConfig = GetSpecialization() or 1
	LoadConfig(_DBChar[_LoadingConfig])

	UPDATE_SHAPESHIFT_FORMS(self)

	-- Load toy informations
	C_ToyBox.ForceToyRefilter()
	for name, v in pairs(_DBAutoPopupList) do if v.Type == "Toy" then AutoActionTask(name):RestartTask() end end

	_HeadList:Each(function(self)
		self:RefreshForAutoHide()
	end)

	-- Skin data may not existed in OnLoad
	ReloadMasqueSkin()
end

_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "ab" or option:lower() == "actionbar") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "reset" then
			LoadConfig()
		elseif info == "unlock" then
			Toggle.Set(false)
		elseif info == "lock" then
			Toggle.Set(true)
		end

		return true
	end
end

function UpdateStanceBar()
	if not _StanceBar then return end

	-- Make sure player not modify this bar
	_StanceBar:GenerateBrother(1, _G.NUM_STANCE_SLOTS)

	local btn = _StanceBar
	_StanceBar.Visible = false
	for i = 1, GetNumShapeshiftForms() do
	    local id = select(4, GetShapeshiftFormInfo(i))
	    if id then
	    	btn:SetAction("spell", id)
	    	btn = btn.Brother
	    end
	end
	while btn do
		btn:SetAction(nil)
		btn = btn.Brother
	end

	_StanceBar.Visible = true
	_StanceBar:RefreshForAutoHide()
end

function UPDATE_SHAPESHIFT_FORMS(self)
	if not _StanceBar then return end

	Task.NoCombatCall(UpdateStanceBar)
end

function UpdateQuestBar()
	local _, cls, subclass, link
	local btn = _QuestBar

	if not btn then return end

	wipe(_QuestMap)

	for bag = 0, _G.NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			link = GetContainerItemLink(bag, slot)

			link = tonumber(link and link:match("item:(%d+)"))

			if link and not _QuestMap[link] then
				_, _, _, _, _, cls, subclass = GetItemInfo(link)

				if GetItemSpell(link) then
					if cls == _ItemType[ITEM_QUEST] then
						-- skip
					elseif cls == _ItemType[ITEM_CONSUMABLE] then
						GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
						GameTooltip:SetBagItem(bag, slot)
						if _G["GameTooltipTextLeft2"]:GetText() ~= ITEM_BIND_QUEST then
							link = nil
						end
						GameTooltip:Hide()
					else
						link = nil
					end

					if link then
						_QuestMap[link] = true

						btn:SetAction("item", link)
						btn = btn.Brother

						if not btn then
							break
						end
					end
				end
			end
		end
		if not btn then
			break
		end
	end

	while btn do
		btn:SetAction(nil, nil)
		btn = btn.Brother
	end
end

function PLAYER_SPECIALIZATION_CHANGED(self)
	local now = GetSpecialization() or 1
	if now ~= _LoadingConfig then
		_DBChar[_LoadingConfig] = GenerateConfig(true)
		_LoadingConfig = now
		if _DBChar[now] then
			Task.NoCombatCall(function()
				LoadConfig(_DBChar[now])
				UPDATE_SHAPESHIFT_FORMS()
				_HeadList:Each(function(self) self:RefreshForAutoHide() end)
			end)
		end
	end
end

PLAYER_ENTERING_WORLD = PLAYER_SPECIALIZATION_CHANGED

function PLAYER_LOGOUT(self)
	local spec = GetSpecialization() or 1

	_DBChar[spec] = GenerateConfig(true)

	-- Global Action bar
	wipe(_GlobalActionBar)

	for _, header in ipairs(_HeadList) do
		if header.AsGlobal then
			tinsert(_GlobalActionBar, GenerateBarConfig(header, true))
		end
	end

	ClearScreen(true)	-- make sure no key bindings would be saved
end

function ACTIONBAR_HIDEGRID(self)
	Task.NextCall(function()
		_HeadList:Each(function(self)
			self:OnLeave()
		end)
	end)
end

function GenerateBarConfig(header, includeContent)
	local bar = {}

	-- bar set
	bar.Location = header.Location
	for _, anchor in ipairs(bar.Location) do
		anchor.relativeTo = nil	-- Clear the name
	end
	if header.FreeMode then
		bar.Size = header.Size
	end

	bar.RowCount = header.RowCount
	bar.ColCount = header.ColCount

	bar.ActionBar = header.ActionBar
	bar.MainBar = header.MainBar
	bar.PetBar = header.PetBar
	bar.StanceBar = header.StanceBar
	bar.WorldMarkBar = header.WorldMarkBar
	bar.RaidTargetBar = header.RaidTargetBar
	bar.ReplaceBlzMainAction = header.ReplaceBlzMainAction

	bar.AutoHideCondition = System.Reflector.Clone(header.AutoHideCondition)
	bar.AutoFadeOut = header.AutoFadeOut
	bar.MinAlpha 	= header.MinAlpha
	bar.MaxAlpha 	= header.MaxAlpha

	bar.AlwaysShowGrid = header.AlwaysShowGrid

	bar.AutoSwapRoot = header.AutoSwapRoot

	bar.FreeMode = header.FreeMode
	bar.LockMode = header.LockMode

	bar.MarginX = header.MarginX
	bar.MarginY = header.MarginY
	bar.Scale = header.Scale

	-- brother
	local btn = header

	while btn do
		local set = {}

		if btn.FreeMode then
			set.Location = btn.Location
			for _, anchor in ipairs(set.Location) do
				anchor.relativeTo = nil	-- Clear the name
			end
			set.Size = btn.Size
		end
		set.BranchCount = btn.BranchCount
		set.Expansion = btn.Expansion
		set.FlyoutDirection = btn.FlyoutDirection
		set.HotKey = btn:GetBindingKey()
		if includeContent then
			set.ActionKind, set.ActionTarget, set.ActionDetail = btn:GetAction()
		end

		if btn.AutoActionTask then
			set.AutoActionTask = btn.AutoActionTask.Name
		end

		-- branch
		local branch = btn.Branch

		while branch do
			local bset = {}

			if branch.FreeMode then
				bset.Location = branch.Location
				for _, anchor in ipairs(bset.Location) do
					anchor.relativeTo = nil	-- Clear the name
				end
				bset.Size = branch.Size
			end
			bset.HotKey = branch:GetBindingKey()
			if includeContent then
				bset.ActionKind, bset.ActionTarget, bset.ActionDetail = branch:GetAction()
			end

			tinsert(set, bset)
			branch = branch.Branch
		end

		tinsert(bar, set)
		btn = btn.Brother
	end

	return bar
end

function GenerateConfig(includeContent)
	local config = { PopupDuration = IActionButton.PopupDuration, DebuffThreshold = IActionButton.DebuffThreshold, RecordThreshold = IActionButton.RecordThreshold }

	if _HiddenMainMenuBar and _BagSlotBar then
		local bar = {}

		-- bar set
		bar.Location = _BagSlotBar.Location

		bar.MarginX = _BagSlotBar.MarginX
		bar.MarginY = _BagSlotBar.MarginY
		bar.Scale = _BagSlotBar.Scale
		bar.Expansion = _BagSlotBar.Expansion
		bar.AutoFadeOut = _BagSlotBar.AutoFadeOut
		bar.MinAlpha 	= _BagSlotBar.MinAlpha
		bar.MaxAlpha 	= _BagSlotBar.MaxAlpha

		config.BagSlotBar = bar
	end

	for _, header in ipairs(_HeadList) do
		if not header.AsGlobal then
			tinsert(config, GenerateBarConfig(header, includeContent))
		end
	end

	return config
end

function LoadBarConfig(header, bar)
	header.IHeader.Visible = false

	if bar then
		header.AutoSwapRoot = bar.AutoSwapRoot

		header.FreeMode = bar.FreeMode
		header.LockMode = bar.LockMode

		header.MarginX = bar.MarginX
		header.MarginY = bar.MarginY
		header.Scale = bar.Scale

		header.Location = bar.Location
		if header.FreeMode then
			header.Size = bar.Size
		end

		header.ActionBar = bar.ActionBar
		header.MainBar = bar.MainBar
		if header.MainBar then
			_MainBar = header
		end
		header.PetBar = bar.PetBar
		if header.PetBar then
			_PetBar = header
		end
		header.StanceBar = bar.StanceBar
		if header.StanceBar then
			_StanceBar = header
		end

		header:GenerateBrother(bar.RowCount, bar.ColCount)

		header.ReplaceBlzMainAction = bar.ReplaceBlzMainAction

		local btn = header

		for _, set in ipairs(bar) do
			btn.FlyoutDirection = set.FlyoutDirection

			if btn == header then
				header.WorldMarkBar = bar.WorldMarkBar
				if header.WorldMarkBar then
					_WorldMarkerBar = header
				end

				header.RaidTargetBar = bar.RaidTargetBar
				if header.RaidTargetBar then
					_RaidTargetBar = header
				end
			end

			btn:SetBindingKey(set.HotKey)
			if set.ActionKind and set.ActionTarget then
				btn:SetAction(set.ActionKind, set.ActionTarget, set.ActionDetail)
			end

			if btn.FreeMode then
				if btn ~= header then
					local name = header:GetName()
					for _, anchor in ipairs(set.Location) do
						anchor.relativeTo = name	-- Set the name
					end
				end
				btn.Location = set.Location
				btn.Size = set.Size
			end

			btn:GenerateBranch(set.BranchCount)

			local branch = btn.Branch

			for _, bset in ipairs(set) do
				branch:SetBindingKey(bset.HotKey)
				if bset.ActionKind and bset.ActionTarget then
					branch:SetAction(bset.ActionKind, bset.ActionTarget, bset.ActionDetail)
				end

				if branch.FreeMode then
					local name = btn:GetName()
					for _, anchor in ipairs(bset.Location) do
						anchor.relativeTo = name	-- Set the name
					end
					branch.Location = bset.Location
					branch.Size = bset.Size
				end

				branch.Visible = btn.Expansion

				branch = branch.Branch
			end

			btn.Expansion = set.Expansion

			if btn.Branch and set.AutoActionTask and _DBAutoPopupList[set.AutoActionTask] then
				AutoActionTask(set.AutoActionTask):AddRoot(btn)
			end

			btn = btn.Brother
		end

		header.MaxAlpha 	= bar.MaxAlpha
		header.MinAlpha 	= bar.MinAlpha
		header.AutoHideCondition = System.Reflector.Clone(bar.AutoHideCondition)
		header.AutoFadeOut 	= bar.AutoFadeOut
		header.AlwaysShowGrid = bar.AlwaysShowGrid
	else
		if header == _MainBar then
			header.MainBar = false
			header.ReplaceBlzMainAction = false
			_MainBar = nil
		end
		if header == _PetBar then
			header.PetBar = false
			_PetBar = nil
		end
		if header == _StanceBar then
			header.StanceBar = false
			_StanceBar = nil
		end
		if header == _WorldMarkerBar then
			header.WorldMarkBar = false
			_WorldMarkerBar = nil
		end
		if header == _RaidTargetBar then
			header.RaidTargetBar = false
			_RaidTargetBar = nil
		end
		header:GenerateBrother(1, 1)
		header:GenerateBranch(0)
	end
end

function LoadConfig(config)
	ClearScreen()

	local set, bset
	local header, btn, branch

	if config and next(config) then
		IActionButton.PopupDuration = config.PopupDuration
		IActionButton.DebuffThreshold = config.DebuffThreshold
		IActionButton.RecordThreshold = config.RecordThreshold

		_HiddenMainMenuBar = config.BagSlotBar and true or false
		_BagSlotBarConfig = config.BagSlotBar

		for _, bar in ipairs(config) do
			header = NewHeader()
			LoadBarConfig(header, bar)
		end

		UPDATE_SHAPESHIFT_FORMS()
	else
		NewHeader()

		_HiddenMainMenuBar = false
		_BagSlotBarConfig = nil
	end

	UpdateBlzMainMenuBar()

	ReloadMasqueSkin()
end

function LoadGlobalActionBar()
	for _, bar in ipairs(_GlobalActionBar) do
		local header = NewHeader()
		LoadBarConfig(header, bar)
		header.AsGlobal = true
	end
end

function ClearScreen(includeGlobal)
	for i = #_HeadList, 1, -1 do
		if includeGlobal or not _HeadList[i].AsGlobal then
			RemoveHeader(_HeadList[i])
		end
	end
end

function NewHeader()
	local header = _Recycle_IButtons()
	local iHeader = _Recycle_IHeaders()
	local iTail = _Recycle_ITails()

	_HeadList:Insert(header)

	iHeader.ActionButton = header
	iTail.ActionButton = header

	header:ClearAllPoints()
	header:SetPoint"CENTER"

	return header
end

function RemoveHeader(header)
	if header == _MainBar then
		header.MainBar = false
		header.ReplaceBlzMainAction = false
		_MainBar = nil
	end
	if header == _PetBar then
		header.PetBar = false
		_PetBar = nil
	end
	if header == _StanceBar then
		header.StanceBar = false
		_StanceBar = nil
	end
	if header == _WorldMarkerBar then
		header.WorldMarkBar = false
		_WorldMarkerBar = nil
	end
	if header == _RaidTargetBar then
		header.RaidTargetBar = false
		_RaidTargetBar = nil
	end
	header.AutoHideCondition = nil
	header.AutoFadeOut = false
	header.MaxAlpha = 1
	header.MinAlpha = 0
	header:GenerateBrother(1, 1)
	header:GenerateBranch(0)
	_HeadList:Remove(header)

	_Recycle_IHeaders(header.IHeader)
	_Recycle_ITails(header.ITail)
	_Recycle_IButtons(header)
end

function UpdateBlzMainMenuBar()
	if _HiddenMainMenuBar then
		if not _BagSlotBar then
			-- CharacterBag
			_BagSlotBar = _Recycle_IButtons()
			_BagSlotBar.FlyoutDirection = "LEFT"
			_BagSlotBar:GenerateBranch(4)
			_BagSlotBar.BagSlot = 0
			_BagSlotBar.BagSlotCountStyle = "AllEmpty"
			_BagSlotBar.CountFormat = "(%s)"

			local btn = _BagSlotBar
			for i = 1, 4 do
				btn = btn.Branch
				btn.BagSlot = i
				btn.Visible = false
			end
			btn:BlockEvent("OnMouseDown")

			local iHeader = _Recycle_IHeaders()
			iHeader.ActionButton = _BagSlotBar
			iHeader.Visible = not _DBChar.LockBar

			MainMenuBar:SetAlpha(0)
			MainMenuBar:SetMovable(true)
			MainMenuBar:SetUserPlaced(true)
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("RIGHT", UIParent, "LEFT", -1000, 0)

			MicroButtonAndBagsBar:SetParent(_HiddenFrame)

			--[[
			-- Hidden blizzard frame
			MultiBarBottomLeft:SetParent(_HiddenFrame)
			MultiBarBottomRight:SetParent(_HiddenFrame)
			MultiBarRight:SetParent(_HiddenFrame)

			--MainMenuBar:EnableMouse(false)

			local animations = {IGAS:GetUI(MainMenuBar).slideOut:GetAnimations()}
			animations[1]:SetOffset(0, 0)

			MainMenuBarArtFrame:SetParent(_HiddenFrame)

			StatusTrackingBarManager:SetParent(_HiddenFrame)

			StanceBarFrame:SetParent(_HiddenFrame)

			PossessBarFrame:SetParent(_HiddenFrame)

			PetActionBarFrame:SetParent(_HiddenFrame)
			--]]

			if _MainBar then
				_MainBar.ReplaceBlzMainAction = false
			end
		end

		if _BagSlotBarConfig then
			-- bar set
			_BagSlotBar.Location = _BagSlotBarConfig.Location
			_BagSlotBar.MarginX = _BagSlotBarConfig.MarginX
			_BagSlotBar.MarginY = _BagSlotBarConfig.MarginY
			_BagSlotBar.Scale = _BagSlotBarConfig.Scale
			_BagSlotBar.Expansion = _BagSlotBarConfig.Expansion
			_BagSlotBar.MaxAlpha = _BagSlotBarConfig.MaxAlpha
			_BagSlotBar.MinAlpha = _BagSlotBarConfig.MinAlpha
			_BagSlotBar.AutoFadeOut = _BagSlotBarConfig.AutoFadeOut
		else
			_BagSlotBar.Location = { AnchorPoint("BOTTOMLEFT", GetScreenWidth() - _BagSlotBar.Width, 0) }
			_BagSlotBar.Scale = 1
			_BagSlotBar.Expansion = false
		end

		if _Addon:GetModule("Container") then
			_BagSlotBar.Visible = false
			_BagSlotBar.Expansion = false
		end
	else
		-- CharacterBag
		if _BagSlotBar then
			_BagSlotBarConfig = nil

			-- bar set
			--[[_BagSlotBarConfig.Location = _BagSlotBar.Location

			_BagSlotBarConfig.MarginX = _BagSlotBar.MarginX
			_BagSlotBarConfig.MarginY = _BagSlotBar.MarginY
			_BagSlotBarConfig.Scale = _BagSlotBar.Scale
			_BagSlotBarConfig.Expansion = _BagSlotBar.Expansion--]]

			_Recycle_IHeaders(_BagSlotBar.IHeader)

			local btn = _BagSlotBar
			_BagSlotBar.BagSlotCountStyle = "Hidden"
			_BagSlotBar.CountFormat = "%s"
			for i = 1, 4 do btn = btn.Branch end
			btn:UnBlockEvent("OnMouseDown")

			_BagSlotBar:GenerateBranch(0)
			_Recycle_IButtons(_BagSlotBar)
			_BagSlotBar = nil

			MainMenuBar:SetAlpha(1)
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("BOTTOM")
			MainMenuBar:SetUserPlaced(false)
			MainMenuBar:SetMovable(false)

			MicroButtonAndBagsBar:SetParent(MainMenuBar)

			--[[
			-- Show blizzard frame
			MultiBarBottomLeft:SetParent(MainMenuBar)
			MultiBarBottomRight:SetParent(MainMenuBar)
			MultiBarRight:SetParent(UIParent)

			--MainMenuBar:EnableMouse(true)

			local animations = {IGAS:GetUI(MainMenuBar).slideOut:GetAnimations()}
			animations[1]:SetOffset(0, -180)

			MainMenuBarArtFrame:SetParent(MainMenuBar)

			StatusTrackingBarManager:SetParent(MainMenuBar)

			StanceBarFrame:SetParent(MainMenuBar)

			PossessBarFrame:SetParent(MainMenuBar)

			PetActionBarFrame:SetParent(MainMenuBar)
			--]]
		end
	end
end

function UpdateUsableColor(self)
	if self.Usable then
		if self.InRange == false then
			self:GetChild("Icon").VertexColor = COLOR_OOR
		else
			self:GetChild("Icon").VertexColor = COLOR_NORMAL
		end
	else
		local atype = self.ActionType
		local _, oom
		if atype == "action" then
			_, oom = IsUsableAction(self.ActionTarget)
		elseif atype == "spell" then
			_, oom = IsUsableSpell((GetSpellInfo(self.ActionTarget)))
		end
		if oom then
			self:GetChild("Icon").VertexColor = COLOR_OOM
		else
			self:GetChild("Icon").VertexColor = COLOR_UNUSABLE
		end
	end
end

function InstallUnusableColor()
	class (IActionButton) (function(_ENV)
		__Handler__( UpdateUsableColor )
		property "InRange" { Type = BooleanNil_01 }

		__Handler__( UpdateUsableColor )
		property "Usable" { Type = BooleanNil }
	end)

	-- Refresh buttons
	local i = 1

	while _G["IActionButton" .. i] do
		local btn = IGAS["IActionButton" .. i]
		btn:GetChild("HotKey"):SetVertexColor(1, 1, 1)
		btn:Refresh()
		i = i + 1
	end
end

function RefreshForUnusableColor()
	if _ActionBarColorUnusable.ENABLE then
		-- Refresh buttons
		local i = 1

		while _G["IActionButton" .. i] do
			UpdateUsableColor(IGAS["IActionButton" .. i])
			i = i + 1
		end
	end
end

function InstallUseCooldownLabel()
	class (IActionButton) (function(_ENV)
		extend "IFCooldownLabel"

		function SetUpCooldownLabel(self, label)
			label:SetPoint("CENTER")
			if self.Height > 0 then
				label:SetFont(label:GetFont(), self.Height * 2 / 3, "OUTLINE")
			end
		end

		property "IFCooldownLabelUseDecimal" { Type = Boolean, Default = true }
		property "IFCooldownLabelAutoColor" { Type = Boolean, Default = true }
		property "IFCooldownLabelMinDuration" { Type = Number, Default = 1.6 }
	end)
end

--------------------
-- Script Handler
--------------------
function _Menu:OnShow()
	local header = self.Parent
	local notBagSlotBar = header ~= _BagSlotBar

	-- Action Map
	_MenuMap.Enabled = notBagSlotBar
	if header.MainBar then
		_ListActionMap.SelectedIndex = 2
	elseif header.ActionBar then
		_ListActionMap.SelectedIndex = header.ActionBar + 2
	elseif header.PetBar then
		_ListActionMap.SelectedIndex = 9
	elseif header.StanceBar then
		_ListActionMap.SelectedIndex = 10
	elseif header.WorldMarkBar then
		_ListActionMap.SelectedIndex = 11
	elseif header.RaidTargetBar then
		_ListActionMap.SelectedIndex = 12
	else
		_ListActionMap.SelectedIndex = 1
	end

	-- Action Lock
	_MenuLock.Checked = not IFActionHandler._IsGroupDragEnabled(_IGASUI_ACTIONBAR_GROUP)

	-- Button Scale
	_ListScale:SelectItemByValue(mround(header.Scale*10)/10)

	-- Button MarginX
	_ListMarginX:SelectItemByValue(header.MarginX)

	-- Button MarginY
	_ListMarginY:SelectItemByValue(header.MarginY)

	-- AutoHide
	_MenuAutoHide.Enabled = notBagSlotBar

	-- Auto fade out
	_MenuAutoFadeOut.Checked = header.AutoFadeOut

	_MenuMaxAlpha.Text = L"Max Opacity" .. " : " .. header.MaxAlpha
	_MenuMinAlpha.Text = L"Min Opacity" .. " : " .. header.MinAlpha

	-- Always show grid
	_MenuAlwaysShowGrid.Checked = header.AlwaysShowGrid

	-- Bar FreeMode
	_MenuFreeMode.Enabled = notBagSlotBar
	_MenuFreeMode.Checked = header.FreeMode

	-- Manual mode
	-- _MenuManual.Enabled = notBagSlotBar and header.FreeMode
	if header.Brother == nil and header.Branch then
		_MenuFreeSquare.Enabled = true
		_MenuFreeCircle.Enabled = true
	else
		_MenuFreeSquare.Enabled = false
		_MenuFreeCircle.Enabled = false
	end

	-- Auto Swap
	_MenuSwap.Enabled = notBagSlotBar
	_MenuSwap.Checked = header.AutoSwapRoot

	-- As Global
	_MenuAsGlobal.Checked = header.AsGlobal

	-- Auto Generate
	if header.ActionBar or header.MainBar or header.PetBar or header.StanceBar or header.WorldMarkBar or header.RaidTargetBar then
		_MenuAutoGenerate.Enabled = false
	else
		_MenuAutoGenerate.Enabled = true
	end

	-- Mouse down
	_MenuUseDown.Enabled = notBagSlotBar
	_MenuUseDown.Checked = IFActionHandler._IsGroupUseButtonDownEnabled(_IGASUI_ACTIONBAR_GROUP)

	-- Popup Duration
	_MenuPopupDuration.Text = L"Popup Duration" .. " : " .. tostring(IActionButton.PopupDuration)

	-- Debuff alert
	_MenuDebuffThreshold.Text = L"Debuff Alert Threshold" .. " : " .. tostring(IActionButton.DebuffThreshold)
	_MenuDebuffRecord.Text = L"Debuff Record Min Threshold" .. " : " .. tostring(IActionButton.RecordThreshold)

	-- Save Set
	_ListSaveSet.SelectedIndex = nil

	-- Load Set
	_ListLoadSet.SelectedIndex = nil

	-- Save Layout
	_ListSave.SelectedIndex = nil

	-- Load Layout
	_ListLoad.SelectedIndex = nil

	-- Aciton Bar's Layout
	_ListBarSave.SelectedIndex = nil
	_ListBarLoad.SelectedIndex = nil

	-- Action Bar's Settings
	_ListBarContentLoad.SelectedIndex = nil
	_ListBarContentSave.SelectedIndex = nil

	-- Hide Blz bar
	_MenuHideBlz:BlockEvent("OnCheckChanged")
	_MenuHideBlz.Checked = _HiddenMainMenuBar
	_MenuHideBlz:UnBlockEvent("OnCheckChanged")

	-- Delete
	_MenuDelete.Enabled = notBagSlotBar and header~=_HeadList[1]

	-- Auto Gen
	_MenuAutoGenerate.Enabled = notBagSlotBar

	-- MenuBar
	_MenuBarSave.Enabled = notBagSlotBar
	_MenuBarLoad.Enabled = notBagSlotBar

	-- Setting
	_MenuBarContentSave.Enabled = notBagSlotBar
	_MenuBarContentLoad.Enabled = notBagSlotBar
end

function _MenuClose:OnClick()
	_Menu:Hide()
end

function _ListActionMap:OnItemChoosed(key, item)
	local index = self.SelectedIndex

	-- Clear auto-pop actions
	if index > 1 then
		local btn = _Menu.Parent
		while btn do
			btn:GenerateBranch(0)
			btn = btn.Brother
		end
	end

	if index == 1 then
		_Menu.Parent.ActionBar = nil
		if _Menu.Parent == _MainBar then
			_MainBar = nil
			_Menu.Parent.MainBar = false
			_Menu.Parent.ReplaceBlzMainAction = false
		end
		if _Menu.Parent == _PetBar then
			_PetBar = nil
			_Menu.Parent.PetBar = false
		end
		if _Menu.Parent == _StanceBar then
			_StanceBar = nil
			_Menu.Parent.StanceBar = false
		end
		if _Menu.Parent == _WorldMarkerBar then
			_WorldMarkerBar = nil
			_Menu.Parent.WorldMarkBar = false
		end
		if _Menu.Parent == _RaidTargetBar then
			_RaidTargetBar = nil
			_Menu.Parent.RaidTargetBar = false
		end
	elseif index == 2 then
		if not _MainBar then
			if _Menu.Parent == _PetBar then
				_PetBar = nil
				_Menu.Parent.PetBar = false
			end
			if _Menu.Parent == _StanceBar then
				_StanceBar = nil
				_Menu.Parent.StanceBar = false
			end
			if _Menu.Parent == _WorldMarkerBar then
				_WorldMarkerBar = nil
				_Menu.Parent.WorldMarkBar =  false
			end
			if _Menu.Parent == _RaidTargetBar then
				_RaidTargetBar = nil
				_Menu.Parent.RaidTargetBar = false
			end
			_MainBar = _Menu.Parent
			_Menu.Parent.ActionBar = nil
			_Menu.Parent.MainBar = true
			if not _HiddenMainMenuBar then
				_Menu.Parent:ThreadCall(function(self)
					if IGAS:MsgBox(L"Do you want use this bar to take place of the blizzard's main action buttons?", "n") then
						_Menu.Parent.ReplaceBlzMainAction = true
					end
				end)
			end
		end
	elseif index == 9 then
		if not _PetBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _StanceBar then
				_StanceBar = nil
				_Menu.Parent.StanceBar = false
			end
			if _Menu.Parent == _WorldMarkerBar then
				_WorldMarkerBar = nil
				_Menu.Parent.WorldMarkBar =  false
			end
			if _Menu.Parent == _RaidTargetBar then
				_RaidTargetBar = nil
				_Menu.Parent.RaidTargetBar = false
			end
			_PetBar = _Menu.Parent
			_Menu.Parent.PetBar = true
		end
	elseif index == 10 then
		if not _StanceBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _PetBar then
				_PetBar = nil
				_Menu.Parent.PetBar = false
			end
			if _Menu.Parent == _WorldMarkerBar then
				_WorldMarkerBar = nil
				_Menu.Parent.WorldMarkBar =  false
			end
			if _Menu.Parent == _RaidTargetBar then
				_RaidTargetBar = nil
				_Menu.Parent.RaidTargetBar = false
			end
			_StanceBar = _Menu.Parent
			_Menu.Parent.StanceBar = true
			UPDATE_SHAPESHIFT_FORMS()
		end
	elseif index == 11 then
		if not _WorldMarkerBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _PetBar then
				_PetBar = nil
				_Menu.Parent.PetBar = false
			end
			if _Menu.Parent == _StanceBar then
				_StanceBar = nil
				_Menu.Parent.StanceBar = false
			end
			if _Menu.Parent == _RaidTargetBar then
				_RaidTargetBar = nil
				_Menu.Parent.RaidTargetBar = false
			end
			_WorldMarkerBar = _Menu.Parent
			_Menu.Parent.WorldMarkBar = true
		end
	elseif index == 12 then
		if not _RaidTargetBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _PetBar then
				_PetBar = nil
				_Menu.Parent.PetBar = false
			end
			if _Menu.Parent == _StanceBar then
				_StanceBar = nil
				_Menu.Parent.StanceBar = false
			end
			if _Menu.Parent == _WorldMarkerBar then
				_WorldMarkerBar = nil
				_Menu.Parent.WorldMarkBar =  false
			end
			_RaidTargetBar = _Menu.Parent
			_Menu.Parent.RaidTargetBar = true
		end
	else
		if _Menu.Parent == _MainBar then
			_MainBar = nil
			_Menu.Parent.MainBar = false
			_Menu.Parent.ReplaceBlzMainAction = false
		end
		if _Menu.Parent == _PetBar then
			_PetBar = nil
			_Menu.Parent.PetBar = false
		end
		if _Menu.Parent == _StanceBar then
			_StanceBar = nil
			_Menu.Parent.StanceBar = false
		end
		if _Menu.Parent == _WorldMarkerBar then
			_WorldMarkerBar = nil
			_Menu.Parent.WorldMarkBar =  false
		end
		if _Menu.Parent == _RaidTargetBar then
			_RaidTargetBar = nil
			_Menu.Parent.RaidTargetBar = false
		end
		_Menu.Parent.ActionBar = index - 2
	end
	_Menu:Hide()
end

function _MenuLock:OnCheckChanged()
	if self.Checked then
		IFActionHandler._DisableGroupDrag(_IGASUI_ACTIONBAR_GROUP)
	else
		IFActionHandler._EnableGroupDrag(_IGASUI_ACTIONBAR_GROUP)
	end
end

function _MenuSwap:OnCheckChanged()
	_Menu.Parent.AutoSwapRoot = self.Checked
end

function _MenuAsGlobal:OnCheckChanged()
	_Menu.Parent.AsGlobal = self.Checked
end

function _ListScale:OnItemChoosed(key, item)
	local btn = _Menu.Parent
	local loc = btn.Location
	local e = btn:GetEffectiveScale()

	for _, anchor in ipairs(loc) do
		anchor.xOffset = (anchor.xOffset or 0) * e
		anchor.yOffset = (anchor.yOffset or 0) * e
	end

	btn.Scale = key

	e = btn:GetEffectiveScale()

	for _, anchor in ipairs(loc) do
		anchor.xOffset = (anchor.xOffset or 0) / e
		anchor.yOffset = (anchor.yOffset or 0) / e
	end

	btn.Location = loc

	_Menu:Hide()
end

function _ListMarginX:OnItemChoosed(key, item)
	_Menu.Parent.MarginX = key
	_Menu:Hide()
end

function _ListMarginY:OnItemChoosed(key, item)
	_Menu.Parent.MarginY = key
	_Menu:Hide()
end

function _MenuAutoHide:OnClick()
	local header = _Menu.Parent

	local data = _Addon:SelectMacroCondition(header.AutoHideCondition)

	if data then
		header.AutoHideCondition = data
	end
end

function _MenuAutoFadeOut:OnCheckChanged()
	_Menu.Parent.AutoFadeOut = self.Checked
end

function _MenuMaxAlpha:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the max opacity(0 - 1)", "ic") or nil)

	if value then
		if value < 0 or value > 1 then return end
		if _Menu.Parent.MinAlpha > value then IGAS:MsgBox(L"The min opacity can't be greater than the max opacity") end
		_Menu.Parent.MaxAlpha = value
		_Menu.Parent.FadeAlpha = value
		_MenuMaxAlpha.Text = L"Max Opacity" .. " : " .. value
	end
end

function _MenuMinAlpha:OnClick()
	local value = tonumber(IGAS:MsgBox(L"Please input the min opacity(0 - 1)", "ic") or nil)

	if value then
		if value < 0 or value > 1 then return end
		if _Menu.Parent.MaxAlpha < value then IGAS:MsgBox(L"The min opacity can't be greater than the max opacity") end
		_Menu.Parent.MinAlpha = value
		_MenuMinAlpha.Text = L"Min Opacity" .. " : " .. value
		if _Menu.Parent:GetAlpha() < value then
			_Menu.Parent.FadeAlpha = value
		end
	end
end

function _MenuAlwaysShowGrid:OnCheckChanged()
	_Menu.Parent.AlwaysShowGrid = self.Checked
end

function _MenuUseDown:OnCheckChanged()
	if self.Checked then
		IFActionHandler._EnableGroupUseButtonDown(_IGASUI_ACTIONBAR_GROUP)
	else
		IFActionHandler._DisableGroupUseButtonDown(_IGASUI_ACTIONBAR_GROUP)
	end
end

function _MenuPopupDuration:OnClick()
	_Menu.Visible = false

	local value = tonumber(IGAS:MsgBox(L"Please input the popup's duration(0.1 - 5)", "ic") or nil)

	if value then
		if value < 0.1 or value > 5 then return end
		IActionButton.PopupDuration = value
	end
end

function _MenuDebuffThreshold:OnClick()
	_Menu.Visible = false

	local value = tonumber(IGAS:MsgBox(L"Please input the debuff alert threshold(0 - 10)", "ic") or nil)

	if value then
		if value < 0 or value > 10 then return end
		IActionButton.DebuffThreshold = value
	end
end

function _MenuDebuffRecord:OnClick()
	_Menu.Visible = false

	local value = tonumber(IGAS:MsgBox(L"Please input the debuff record min threshold(0 - 10)", "ic") or nil)

	if value then
		if value < 0 or value > 10 then return end
		IActionButton.RecordThreshold = value
	end
end

function _MenuKeyBinding:OnClick()
	IFKeyBinding._ModeOn()
end

function _MenuAutoGenerate:OnClick()
	local btn = _Menu.Parent
	local usedMask = {}
	while btn do
		if btn.Branch then
			local mask = _Recycle_AutoPopupMask()
			mask.Parent = btn
			mask.Visible = true
			tinsert(usedMask, mask)
		end
		btn = btn.Brother
	end
	_Menu.Visible = false
	if #usedMask > 0 then
		IGAS:MsgBox(L"Please click the root button")
		for _, mask in ipairs(usedMask) do _Recycle_AutoPopupMask(mask) end
	end
	usedMask = nil
end

function _MenuFreeMode:OnCheckChanged()
	_Menu.Parent.FreeMode = self.Checked
	-- _MenuManual.Enabled = self.Checked
	if not self.Checked then
		IFMovable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
		IFResizable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
		ReloadMasqueSkin()
	end
end

function _MenuManual:OnClick()
	IFMovable._Toggle(_IGASUI_ACTIONBAR_GROUP)
	IFResizable._Toggle(_IGASUI_ACTIONBAR_GROUP)

	if not IFResizable._IsModeOn(_IGASUI_ACTIONBAR_GROUP) then
		ReloadMasqueSkin()
	end
end

function _MenuFreeSquare:OnClick()
	local header = _Menu.Parent
	_Menu:Hide()

	header.FreeMode = true

	local oldExp = header.Expansion
	header.Expansion = true

	_FreeMask.Parent = header.Branch
	_FreeMask.Visible = true
	_FreeMask.Mode = "Square"

	IGAS:MsgBox(L"Drag the masked button to modify the layout.")

	_FreeMask.Parent = nil
	_FreeMask.Visible = false

	header.Expansion = oldExp
end

function _MenuFreeCircle:OnClick()
	local header = _Menu.Parent
	_Menu:Hide()

	header.FreeMode = true

	local oldExp = header.Expansion
	header.Expansion = true

	_FreeMask.Parent = header.Branch
	_FreeMask.Visible = true
	_FreeMask.Mode = "Circle"

	IGAS:MsgBox(L"Drag the masked button to modify the layout.")

	_FreeMask.Parent = nil
	_FreeMask.Visible = false

	header.Expansion = oldExp
end

function _ListSaveSet:OnItemChoosed(key, item)
	_Menu:Hide()
	if key == L"New Set" then
		self:ThreadCall(function (self)
			local name = ""
			while strtrim(name) == "" or name == L"New Set" or _DBCharSet[name] do
				name = IGAS:MsgBox(L"Please input the new set name", "ic")
				if not name then
					return
				end
			end
			_DBCharSet[name] = GenerateConfig(true)
			tinsert(_ActionSetSave, name)
			tinsert(_ActionSetLoad, name)
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want overwrite the existed set?", "n") then
				_DBCharSet[key] = GenerateConfig(true)
			end
		end)
	end
end

function _ListLoadSet:OnItemChoosed(key, item)
	_Menu:Hide()

	self:ThreadCall(function (self)
		if IGAS:MsgBox(L"Do you want load the set?", "n") then
			LoadConfig(_DBCharSet[key])
		end
	end)
end

function _ListSave:OnItemChoosed(key, item)
	_Menu:Hide()
	if key == L"New Layout" then
		self:ThreadCall(function (self)
			local name = ""
			while strtrim(name) == "" or name == L"New Layout" or name == L"Reset" or _DB[name] do
				name = IGAS:MsgBox(L"Please input the new layout name", "ic")
				if not name then
					return
				end
			end
			_DB[name] = GenerateConfig()
			tinsert(_LayoutSave, name)
			tinsert(_LayoutLoad, name)
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want overwrite the existed layout?", "n") then
				_DB[key] = GenerateConfig()
			end
		end)
	end
end

function _ListLoad:OnItemChoosed(key, item)
	_Menu:Hide()
	if key == L"Reset" then
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want reset the layout?", "n") then
				LoadConfig()
			end
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want load the layout?", "n") then
				LoadConfig(_DB[key])
			end
		end)
	end
end


function _ListBarSave:OnItemChoosed(key, item)
	local header = _Menu.Parent
	_Menu:Hide()
	if key == L"New Layout" then
		self:ThreadCall(function (self)
			local name = ""
			while strtrim(name) == "" or name == L"New Layout" or name == L"Reset" or _ActionBarLayout[name] do
				name = IGAS:MsgBox(L"Please input the new layout name", "ic")
				if not name then
					return
				end
			end
			_ActionBarLayout[name] = GenerateBarConfig(header)
			tinsert(_ActionBarLayoutSave, name)
			tinsert(_ActionBarLayoutLoad, name)
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want overwrite the existed layout?", "n") then
				_ActionBarLayout[key] = GenerateBarConfig(header)
			end
		end)
	end
end

function _ListBarLoad:OnItemChoosed(key, item)
	local header = _Menu.Parent
	_Menu:Hide()
	if key == L"Reset" then
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want reset the layout?", "n") then
				LoadBarConfig(header)
				ReloadMasqueSkin()
			end
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want load the layout?", "n") then
				LoadBarConfig(header, _ActionBarLayout[key])
				ReloadMasqueSkin()
			end
		end)
	end
end

function _ListBarContentSave:OnItemChoosed(key, item)
	local header = _Menu.Parent
	_Menu:Hide()
	if key == L"New Set" then
		self:ThreadCall(function (self)
			local name = ""
			while strtrim(name) == "" or name == L"New Set" or _ActionBarSettings[name] do
				name = IGAS:MsgBox(L"Please input the new set name", "ic")
				if not name then
					return
				end
			end
			_ActionBarSettings[name] = GenerateBarConfig(header, true)
			tinsert(_ActionBarSettingsSave, name)
			tinsert(_ActionBarSettingsLoad, name)
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want overwrite the existed set?", "n") then
				_ActionBarSettings[key] = GenerateBarConfig(header, true)
			end
		end)
	end
end

function _ListBarContentLoad:OnItemChoosed(key, item)
	local header = _Menu.Parent
	_Menu:Hide()

	if key == L"Reset" then
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want reset the layout?", "n") then
				LoadBarConfig(header)
				ReloadMasqueSkin()
			end
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want load the set?", "n") then
				LoadBarConfig(header, _ActionBarSettings[key])
				ReloadMasqueSkin()
			end
		end)
	end
end

function _MenuHideBlz:OnCheckChanged()
	_HiddenMainMenuBar = self.Checked
	Task.NoCombatCall(UpdateBlzMainMenuBar)
end

function _MenuDelete:OnClick()
	if IGAS:MsgBox(L"Please confirm to delete this action bar", "n") then
		if IFMovable._IsModeOn(_IGASUI_ACTIONBAR_GROUP) then
			IFMovable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
			IFResizable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
		end
		RemoveHeader(_Menu.Parent)
	end
end

function _MenuNew:OnClick()
	if IGAS:MsgBox(L"Please confirm to create new action bar", "n") then
		NewHeader()
	end
end

function _MenuColorToggle:OnClick()
	if _ActionBarColorUnusable.ENABLE then
		if IGAS:MsgBox(L"Disable the feature would require reload, \ndo you continue?", "n") then
			_ActionBarColorUnusable.ENABLE = false
			ReloadUI()
		end
	else
		_ActionBarColorUnusable.ENABLE = true
		_MenuColorToggle.Text = L"Disable"
		InstallUnusableColor()
	end
end

function _MenuColorOOM:OnColorPicked(r, g, b, a)
	local color = ColorType(r, g, b, a)

	COLOR_OOM = color
	_ActionBarColorUnusable.OOM = color

	return RefreshForUnusableColor()
end

function _MenuColorOOR:OnColorPicked(r, g, b, a)
	local color = ColorType(r, g, b, a)

	COLOR_OOR = color
	_ActionBarColorUnusable.OOR = color

	return RefreshForUnusableColor()
end

function _MenuColorUnusable:OnColorPicked(r, g, b, a)
	local color = ColorType(r, g, b, a)

	COLOR_UNUSABLE = color
	_ActionBarColorUnusable.UNUSABLE = color

	return RefreshForUnusableColor()
end

function _MenuCDLabelToggle:OnClick()
	if _ActionBarUseCooldownLabel.ENABLE then
		if IGAS:MsgBox(L"Disable the feature would require reload, \ndo you continue?", "n") then
			_ActionBarUseCooldownLabel.ENABLE = false
			ReloadUI()
		end
	else
		if IGAS:MsgBox(L"Enable the feature would require reload, \ndo you continue?", "n") then
			_ActionBarUseCooldownLabel.ENABLE = true
			ReloadUI()
		end
	end
end

function _MenuNoGCD:OnCheckChanged()
	_ActionBarHideGlobalCD.ENABLE = self.Checked
end

local _prev = GetTime()

function IGAS.GameTooltip:OnTooltipSetItem()
	if GetTime() == _prev then return end
	_prev = GetTime()

	local item, link = self:GetItem()
	if link then
		link = tonumber(link:match("Hitem:(%d+)"))
		if link then
			local itemCls, itemSubCls = select(6, GetItemInfo(link))

			if itemCls and itemSubCls then
				self:AddLine("    ")
				self:AddDoubleLine(itemCls .. "-" .. itemSubCls, "ID: " .. link, 1, 1, 1, 1, 1, 1)
			end
		end
	end
end

function _MenuSowAutoGenBlackList:OnClick()
	_AutoGenBlackListForm:Show()
end

function _AutoGenBlackListForm:OnShow()
	_AutoGenBlackListList:Clear()

	for item in pairs(_AutoGenItemBlackList) do
		_AutoGenBlackListList:AddItem(item, GetItemInfo(item), GetItemIcon(item))
	end
end

function _AutoGenBlackListForm:OnHide()
	_AutoGenBlackListList:Clear()
	AutoActionTask.RestartAllTaskByType(AutoActionTask.AutoActionTaskType.Item)
end

function _AutoGenBlackListList:OnItemDoubleClick(key)
	_AutoGenItemBlackList[key] = nil
	self:RemoveItem(key)
end

function _AutoGenBlackListList:OnGameTooltipShow(gametooltip, key)
	gametooltip:SetHyperlink(select(2, GetItemInfo(key)))
end

function _MenuModifyAnchorPoints:OnClick()
	local btn = _Menu.Parent
	_Menu:Hide()
	IGAS:ManageAnchorPoint(btn, nil, true)
end

----------------------------------------------------
-- Debuff Spell Activator
----------------------------------------------------
_RecycleAlert = Recycle(SpellActivationAlert, "IGASUI_SpellActivationAlert%d", IGASUI_IActionButton_Manager)

function SpellAlert_OnFinished(self)
	if self._ActionButton then
		self._ActionButton._IGASUI_OverLay = nil
		self._ActionButton = nil
		self.Parent = IGASUI_IActionButton_Manager
		self:StopAnimation()
		self:ClearAllPoints()
		self:Hide()

		return _RecycleAlert(self)
	end
end

function _RecycleAlert:OnInit(alert)
	alert.OnFinished = SpellAlert_OnFinished
end

local _TargetAura = {}
local _DebuffMap = {}
local _ActiveSpell = {}

_Button2Spell = {}

function UpdateOverlayGlow(self)
	local spellID = _Button2Spell[self]

	if spellID and _ActiveSpell[spellID] then
		ShowOverlayGlow(self)
	else
		HideOverlayGlow(self)
	end
end

function ShowOverlayGlow(self)
	if not self._IGASUI_OverLay then
		local alert = _RecycleAlert()
		local width, height = self:GetSize()

		alert.Parent = self

		alert:ClearAllPoints()
		alert:SetSize(width*1.4, height*1.4)
		alert:SetPoint("CENTER", self, "CENTER")

		alert._ActionButton = self
		self._IGASUI_OverLay = alert
		self._IGASUI_OverLay.AnimInPlaying = true
	end
end

function HideOverlayGlow(self)
	if self._IGASUI_OverLay then
		if self.Visible then
			self._IGASUI_OverLay.AnimOutPlaying = true
		else
			SpellAlert_OnFinished(self._IGASUI_OverLay)
		end
	end
end

function ActiveOverLayGlow(spellID)
	if not _ActiveSpell[spellID] and GetSpellCooldown(spellID) == 0 then
		_ActiveSpell[spellID] = true

		for button, id in pairs(_Button2Spell) do
			if id == spellID then
				ShowOverlayGlow(button)
			end
		end
	end
end

function DeactiveOverLayGlow(spellID)
	if _ActiveSpell[spellID] then
		_ActiveSpell[spellID] = nil

		for button, id in pairs(_Button2Spell) do
			if id == spellID then
				HideOverlayGlow(button)
			end
		end
	end
end

function UpdateTargetDebuffs()
	local index = 1
	local name, _, duration, expires
	local unit = "target"
	local filter = "HARMFUL|PLAYER"
	local now = GetTime()
	local threshold = IActionButton.DebuffThreshold
	local record = IActionButton.RecordThreshold

	if UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDead("target") then
		name, _, _, _, duration, expires = UnitAura(unit, index, filter)

		wipe(_TargetAura)

		while name do
			if expires and expires > 0 and duration and duration > 0 and duration >= record then
				_TargetAura[name] = expires - now
				if not _DebuffMap[name] then
					_DebuffMap[name] = select(7, GetSpellInfo(name))
				end
			end
			index = index + 1
			name, _, _, _, duration, expires = UnitAura(unit, index, filter)
		end

		for name, spell in pairs(_DebuffMap) do
			if not _TargetAura[name] or _TargetAura[name] < threshold then
				ActiveOverLayGlow(spell)
			else
				DeactiveOverLayGlow(spell)
			end
		end
	else
		wipe(_TargetAura)
		for spell in pairs(_ActiveSpell) do
			DeactiveOverLayGlow(spell)
		end
	end
end

local frame = CreateFrame("Frame")
frame:Hide()
--frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
frame:RegisterUnitEvent("UNIT_AURA", "target")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		frame:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" then
		frame:Show()
	else
		return UpdateTargetDebuffs()
	end
end)
local _Elapsed = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	_Elapsed = _Elapsed + elapsed
	if _Elapsed > 0.5 then
		_Elapsed = 0
		UpdateTargetDebuffs()
	end
end)