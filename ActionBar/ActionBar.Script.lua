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

_MainBar = nil
_PetBar = nil
_StanceBar = nil
_BagSlotBar = nil

_QuestMap = {}
_ItemType = nil

_HiddenMainMenuBar = false
_BagSlotBarConfig = nil

ITEM_CONSUMABLE = 4
ITEM_QUEST = 10

_HiddenFrame = CreateFrame("Frame")	-- No need use IGAS frame
_HiddenFrame:Hide()

GameTooltip = _G.GameTooltip
UIParent = _G.UIParent
ITEM_BIND_QUEST = _G.ITEM_BIND_QUEST

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

	for name in pairs(_DBAutoPopupList) do
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

	-- Register system events
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")

	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

	_LoadingConfig = GetSpecialization() or 1
	LoadConfig(_DBChar[_LoadingConfig])

	self:ActiveThread("OnEnable")
end

function OnEnable(self)
	UPDATE_SHAPESHIFT_FORMS(self)

	-- Load toy informations
	C_ToyBox.FilterToys()
	for name, v in pairs(_DBAutoPopupList) do if v.Type == "Toy" then AutoActionTask(name):RestartTask() end end

	_HeadList:Each(function(self)
		self:RefreshForAutoHide()
	end)
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
	for i = 1, GetNumShapeshiftForms() do
	    local id = select(5, GetShapeshiftFormInfo(i))
	    if id then
	    	btn:SetAction("spell", id)
	    	btn.Visible = true
	    	btn = btn.Brother
	    end
	end

	while btn do
		btn.Visible = false
		btn:SetAction(nil)
		btn = btn.Brother
	end

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
			Task.NoCombatCall(LoadConfig, _DBChar[now])
			Task.NoCombatCall(UPDATE_SHAPESHIFT_FORMS)
		end
	end
end

function PLAYER_LOGOUT(self)
	local spec = GetSpecialization() or 1

	_DBChar[spec] = GenerateConfig(true)

	ClearScreen()	-- make sure no key bindings would be saved
end

function GenerateBarConfig(header, includeContent)
	local bar = {}

	-- bar set
	bar.Location = header.Location
	if header.FreeMode then
		bar.Size = header.Size
	end

	bar.RowCount = header.RowCount
	bar.ColCount = header.ColCount

	bar.ActionBar = header.ActionBar
	bar.MainBar = header.MainBar
	bar.PetBar = header.PetBar
	bar.StanceBar = header.StanceBar
	bar.ReplaceBlzMainAction = header.ReplaceBlzMainAction

	bar.AutoHideCondition = System.Reflector.Clone(header.AutoHideCondition)

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
	local config = { PopupDuration = IActionButton.PopupDuration }

	if _HiddenMainMenuBar and _BagSlotBar then
		local bar = {}

		-- bar set
		bar.Location = _BagSlotBar.Location

		bar.MarginX = _BagSlotBar.MarginX
		bar.MarginY = _BagSlotBar.MarginY
		bar.Scale = _BagSlotBar.Scale
		bar.Expansion = _BagSlotBar.Expansion

		config.BagSlotBar = bar
	end

	for _, header in ipairs(_HeadList) do
		tinsert(config, GenerateBarConfig(header, includeContent))
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
			btn:SetBindingKey(set.HotKey)
			if set.ActionKind and set.ActionTarget then
				btn:SetAction(set.ActionKind, set.ActionTarget, set.ActionDetail)
			end

			if btn.FreeMode then
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

		header.AutoHideCondition = System.Reflector.Clone(bar.AutoHideCondition)

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
end

function ClearScreen()
	for i = #_HeadList, 1, -1 do
		RemoveHeader(_HeadList[i])
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
	header.AutoHideCondition = nil
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

			MainMenuBarBackpackButton:SetParent(_HiddenFrame)
			CharacterBag0Slot:SetParent(_HiddenFrame)
			CharacterBag1Slot:SetParent(_HiddenFrame)
			CharacterBag2Slot:SetParent(_HiddenFrame)
			CharacterBag3Slot:SetParent(_HiddenFrame)

			-- Hidden blizzard frame
			MultiBarBottomLeft:SetParent(_HiddenFrame)
			MultiBarBottomRight:SetParent(_HiddenFrame)
			MultiBarRight:SetParent(_HiddenFrame)

			MainMenuBar:EnableMouse(false)

			local animations = {IGAS:GetUI(MainMenuBar).slideOut:GetAnimations()}
			animations[1]:SetOffset(0, 0)

			MainMenuBarArtFrame:SetParent(_HiddenFrame)

			MainMenuExpBar:SetParent(_HiddenFrame)

			MainMenuBarMaxLevelBar:SetParent(_HiddenFrame)

			ReputationWatchBar:SetParent(_HiddenFrame)

			StanceBarFrame:SetParent(_HiddenFrame)

			PossessBarFrame:SetParent(_HiddenFrame)

			PetActionBarFrame:SetParent(_HiddenFrame)

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
		else
			_BagSlotBar.Location = { AnchorPoint("BOTTOMLEFT", GetScreenWidth() - _BagSlotBar.Width, 0) }
			_BagSlotBar.Scale = 1
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

			MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame)
			CharacterBag0Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag1Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag2Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag3Slot:SetParent(MainMenuBarArtFrame)

			MainMenuBarBackpackButton:ClearAllPoints()
			MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -4, 6)

			-- Show blizzard frame
			MultiBarBottomLeft:SetParent(MainMenuBar)
			MultiBarBottomRight:SetParent(MainMenuBar)
			MultiBarRight:SetParent(UIParent)

			MainMenuBar:EnableMouse(true)

			local animations = {IGAS:GetUI(MainMenuBar).slideOut:GetAnimations()}
			animations[1]:SetOffset(0, -180)

			MainMenuBarArtFrame:SetParent(MainMenuBar)

			MainMenuExpBar:SetParent(MainMenuBar)

			MainMenuBarMaxLevelBar:SetParent(MainMenuBar)

			ReputationWatchBar:SetParent(MainMenuBar)

			StanceBarFrame:SetParent(MainMenuBar)

			PossessBarFrame:SetParent(MainMenuBar)

			PetActionBarFrame:SetParent(MainMenuBar)
		end
	end
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

	-- Always show grid
	_MenuAlwaysShowGrid.Checked = header.AlwaysShowGrid

	-- Bar FreeMode
	_MenuFreeMode.Enabled = notBagSlotBar
	_MenuFreeMode.Checked = header.FreeMode

	-- Manual mode
	_MenuManual.Enabled = notBagSlotBar and header.FreeMode

	-- Auto Swap
	_MenuSwap.Enabled = notBagSlotBar
	_MenuSwap.Checked = header.AutoSwapRoot

	-- Auto Generate
	if header.ActionBar or header.MainBar or header.PetBar or header.StanceBar then
		_MenuAutoGenerate.Enabled = false
	else
		_MenuAutoGenerate.Enabled = true
	end

	-- Mouse down
	_MenuUseDown.Enabled = notBagSlotBar
	_MenuUseDown.Checked = IFActionHandler._IsGroupUseButtonDownEnabled(_IGASUI_ACTIONBAR_GROUP)

	-- Popup Duration
	_MenuPopupDuration.Text = L"Popup Duration" .. " : " .. tostring(IActionButton.PopupDuration)

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

	-- Hide Blz bar
	_MenuHideBlz:BlockEvent("OnCheckChanged")
	_MenuHideBlz.Checked = _HiddenMainMenuBar
	_MenuHideBlz:UnBlockEvent("OnCheckChanged")

	-- Delete
	_MenuDelete.Enabled = notBagSlotBar and header~=_HeadList[1]
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
			_StanceBar = _Menu.Parent
			_Menu.Parent.StanceBar = true
			UPDATE_SHAPESHIFT_FORMS()
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
	_MenuManual.Enabled = self.Checked
	if not self.Checked then
		IFMovable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
		IFResizable._ModeOff(_IGASUI_ACTIONBAR_GROUP)
	end
end

function _MenuManual:OnClick()
	IFMovable._Toggle(_IGASUI_ACTIONBAR_GROUP)
	IFResizable._Toggle(_IGASUI_ACTIONBAR_GROUP)
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
			end
		end)
	else
		self:ThreadCall(function (self)
			if IGAS:MsgBox(L"Do you want load the layout?", "n") then
				LoadBarConfig(header, _ActionBarLayout[key])
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
		RemoveHeader(_Menu.Parent)
	end
end

function _MenuNew:OnClick()
	if IGAS:MsgBox(L"Please confirm to create new action bar", "n") then
		NewHeader()
	end
end
