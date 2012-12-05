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
			if _Header4CharacterBag then
				_Header4CharacterBag.Visible = not value
			end
		end)
		Toggle.Update()
	end,
	Update = function() end,
}

_MainBar = nil
_QuestBar = nil
_PetBar = nil
_StanceBar = nil
_QuestMap = {}
_ItemType = nil

_HiddenMainMenuBar = false

_Header4CharacterBag = nil
_Header4CharacterBagLocation = nil

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

	_LayoutSave = {}
	_LayoutLoad = {}
	tinsert(_LayoutSave, L"New Layout")
	tinsert(_LayoutLoad, L"Reset")
	for name in pairs(_DB) do
		tinsert(_LayoutSave, name)
		tinsert(_LayoutLoad, name)
	end

	_ListSave.Keys = _LayoutSave
	_ListSave.Items = _LayoutSave
	_ListLoad.Keys = _LayoutLoad
	_ListLoad.Items = _LayoutLoad

	self:RegisterEvent"PLAYER_SPECIALIZATION_CHANGED"
	self:RegisterEvent"PLAYER_LOGOUT"

	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")
	self:RegisterEvent("BAG_OPEN")
	self:RegisterEvent("BAG_CLOSED")

	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

	_LoadingConfig = GetSpecialization() or 1
	LoadConfig(_DBChar[_LoadingConfig])

	self:ActiveThread("OnEnable")
end

function OnEnable(self)
	UPDATE_SHAPESHIFT_FORMS(self)
	System.Threading.Sleep(2)
	_ItemType = {GetAuctionItemClasses()}
	self:RegisterEvent("BAG_UPDATE")	-- Delay register to reduce cost
	BAG_UPDATE(self)
end

_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "ab" or option:lower() == "actionbar") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "reset" then
			LoadConfig()
		elseif info == "show" then
			_HeadList:Each("HideOutOfCombat", false)
		elseif info == "hide" then
			_HeadList:Each("HideOutOfCombat", true)
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
	    local name = select(2, GetShapeshiftFormInfo(i))
	    name = GetSpellLink(name)
	    name = tonumber(name and name:match("spell:(%d+)"))
	    if name then
	    	btn:SetAction("spell", name)
	    	btn.Visible = true
	    	btn = btn.Brother
	    end
	end

	while btn do
		btn.Visible = false
		btn:SetAction(nil)
		btn = btn.Brother
	end
end

function UPDATE_SHAPESHIFT_FORMS(self)
	if not _StanceBar then return end

	IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateStanceBar)
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

function BAG_UPDATE(self)
	if _ItemType and _QuestBar and not InCombatLockdown() then
		IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateQuestBar)
	end
end

function MERCHANT_SHOW(self)
	self:UnregisterEvent("BAG_UPDATE")
end

function MERCHANT_CLOSED(self)
	self:RegisterEvent("BAG_UPDATE")
end

function BAG_OPEN(self)
	self:UnregisterEvent("BAG_UPDATE")
end

function BAG_CLOSED(self)
	self:RegisterEvent("BAG_UPDATE")
	BAG_UPDATE(self)
end

function PLAYER_SPECIALIZATION_CHANGED(self, ...)
	local now = GetSpecialization() or 1
	if now ~= _LoadingConfig then
		_DBChar[_LoadingConfig] = GenerateConfig(true)
		_LoadingConfig = now
		if _DBChar[now] then
			IFNoCombatTaskHandler._RegisterNoCombatTask(LoadConfig, _DBChar[now])
			IFNoCombatTaskHandler._RegisterNoCombatTask(UPDATE_SHAPESHIFT_FORMS)
		end
	end
end

function PLAYER_LOGOUT(self)
	local spec = GetSpecialization() or 1

	_DBChar[spec] = GenerateConfig(true)
end

function GenerateConfig(includeContent)
	local config = {}
	local btn, branch, bar, set, bset

	config.HiddenMainMenuBar = _HiddenMainMenuBar
	config.Header4CharacterBagLocation = _Header4CharacterBagLocation

	for _, header in ipairs(_HeadList) do
		bar = {}

		-- bar set
		bar.Location = header.Location
		if header.FreeMode then
			bar.Size = header.Size
		end

		bar.RowCount = header.RowCount
		bar.ColCount = header.ColCount

		bar.ActionBar = header.ActionBar
		bar.MainBar = header.MainBar
		bar.QuestBar = header.QuestBar
		bar.PetBar = header.PetBar
		bar.StanceBar = header.StanceBar
		bar.ReplaceBlzMainAction = header.ReplaceBlzMainAction

		bar.HideOutOfCombat = header.HideOutOfCombat
		bar.HideInPetBattle = header.HideInPetBattle
		bar.HideInVehicle = header.HideInVehicle

		bar.FreeMode = header.FreeMode
		bar.LockMode = header.LockMode

		bar.MarginX = header.MarginX
		bar.MarginY = header.MarginY
		bar.Scale = header.Scale

		-- brother
		btn = header

		while btn do
			set = {}

			if btn.FreeMode then
				set.Location = btn.Location
				set.Size = btn.Size
			end
			set.BranchCount = btn.BranchCount
			set.Expansion = btn.Expansion
			set.FlyoutDirection = btn.FlyoutDirection
			set.HotKey = btn:GetBindingKey()
			if includeContent then
				set.ActionKind, set.ActionTarget = btn:GetAction()
			end

			-- branch
			branch = btn.Branch

			while branch do
				bset = {}

				if branch.FreeMode then
					bset.Location = branch.Location
					bset.Size = branch.Size
				end
				bset.HotKey = branch:GetBindingKey()
				if includeContent then
					bset.ActionKind, bset.ActionTarget = branch:GetAction()
				end

				tinsert(set, bset)
				branch = branch.Branch
			end

			tinsert(bar, set)
			btn = btn.Brother
		end

		tinsert(config, bar)
	end

	return config
end

function LoadConfig(config)
	ClearScreen()

	local set, bset
	local header, btn, branch

	if config and next(config) then
		_HiddenMainMenuBar = config.HiddenMainMenuBar
		_Header4CharacterBagLocation = config.Header4CharacterBagLocation

		for _, bar in ipairs(config) do
			header = NewHeader()
			header.IHeader.Visible = false

			header.HideOutOfCombat = bar.HideOutOfCombat
			header.HideInPetBattle = bar.HideInPetBattle
			header.HideInVehicle = bar.HideInVehicle

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
			header.QuestBar = bar.QuestBar
			if header.QuestBar then
				_QuestBar = header
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

			btn = header

			for _, set in ipairs(bar) do
				btn.FlyoutDirection = set.FlyoutDirection
				btn:SetBindingKey(set.HotKey)
				if set.ActionKind and set.ActionTarget then
					btn:SetAction(set.ActionKind, set.ActionTarget)
				end

				if btn.FreeMode then
					btn.Location = set.Location
					btn.Size = set.Size
				end

				btn:GenerateBranch(set.BranchCount)

				branch = btn.Branch

				for _, bset in ipairs(set) do
					branch:SetBindingKey(bset.HotKey)
					if bset.ActionKind and bset.ActionTarget then
						branch:SetAction(bset.ActionKind, bset.ActionTarget)
					end

					if branch.FreeMode then
						branch.Location = bset.Location
						branch.Size = bset.Size
					end

					branch.Visible = btn.Expansion

					branch = branch.Branch
				end

				btn.Expansion = set.Expansion

				btn = btn.Brother
			end
		end

		BAG_UPDATE()
		UPDATE_SHAPESHIFT_FORMS()
	else
		NewHeader()

		_HiddenMainMenuBar = false
		_Header4CharacterBagLocation = nil
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
	if header == _QuestBar then
		header.QuestBar = false
		_QuestBar = nil
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
	_HeadList:Remove(header)

	_Recycle_IHeaders(header.IHeader)
	_Recycle_ITails(header.ITail)
	_Recycle_IButtons(header)
end

function UpdateBlzMainMenuBar()
	if _HiddenMainMenuBar then
		if not _Header4CharacterBag then
			-- CharacterBag
			_Header4CharacterBag = _Recycle_IHeaders()
			_Header4CharacterBag.ActionButton = MainMenuBarBackpackButton
			_Header4CharacterBag.Visible = not _DBChar.LockBar

			MainMenuBarBackpackButton:SetParent(UIParent)
			CharacterBag0Slot:SetParent(UIParent)
			CharacterBag1Slot:SetParent(UIParent)
			CharacterBag2Slot:SetParent(UIParent)
			CharacterBag3Slot:SetParent(UIParent)

			if _Header4CharacterBagLocation then
				MainMenuBarBackpackButton.Location = _Header4CharacterBagLocation
			end

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
	else
		-- CharacterBag
		if _Header4CharacterBag then
			_Recycle_IHeaders(_Header4CharacterBag)
			_Header4CharacterBag = nil

			MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame)
			CharacterBag0Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag1Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag2Slot:SetParent(MainMenuBarArtFrame)
			CharacterBag3Slot:SetParent(MainMenuBarArtFrame)

			MainMenuBarBackpackButton:ClearAllPoints()
			MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -4, 6)

			_Header4CharacterBagLocation = nil

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

function SaveHeadPosition(self)
	if self == _Header4CharacterBag then
		_Header4CharacterBagLocation = self.Parent.Location
	end
end

--------------------
-- Script Handler
--------------------
function MainMenuBarBackpackButton:OnEnter()
	if not InCombatLockdown() and _Header4CharacterBag then
		_Header4CharacterBag.Visible = true
	end
end

function _Menu:OnShow()
	local header = self.Parent

	-- Action Map
	if header.MainBar then
		_ListActionMap.SelectedIndex = 2
	elseif header.ActionBar then
		_ListActionMap.SelectedIndex = header.ActionBar + 2
	elseif header.QuestBar then
		_ListActionMap.SelectedIndex = 9
	elseif header.PetBar then
		_ListActionMap.SelectedIndex = 10
	elseif header.StanceBar then
		_ListActionMap.SelectedIndex = 11
	else
		_ListActionMap.SelectedIndex = 1
	end

	-- Action Lock
	_MenuLock.Checked = not IFActionHandler._IsGroupDragEnabled(_IGASUI_ACTIONBAR_GROUP)

	-- Button Scale
	_ListScale:SelectItemByValue(header.Scale)

	-- Button MarginX
	_ListMarginX:SelectItemByValue(header.MarginX)

	-- Button MarginY
	_ListMarginY:SelectItemByValue(header.MarginY)

	-- AutoHide
	_MenuHideOutOfCombat.Checked = header.HideOutOfCombat
	_MenuHideInPetBattle.Checked = header.HideInPetBattle
	_MenuHideInVehicle.Checked = header.HideInVehicle

	-- Bar FreeMode
	_MenuFreeMode.Checked = header.FreeMode

	-- Manual mode
	_MenuManual.Enabled = header.FreeMode

	-- Mouse down
	_MenuUseDown.Checked = IFActionHandler._IsGroupUseButtonDownEnabled(_IGASUI_ACTIONBAR_GROUP)

	-- Save
	_ListSave.SelectedIndex = nil

	-- Load
	_ListLoad.SelectedIndex = nil

	-- Hide Blz bar
	_MenuHideBlz.Checked = _HiddenMainMenuBar

	-- Delete
	_MenuDelete.Enabled = header~=_HeadList[1]
end

function _MenuClose:OnClick()
	_Menu:Hide()
end

function _ListActionMap:OnItemChoosed(key, item)
	local index = self.SelectedIndex

	if index == 1 then
		_Menu.Parent.ActionBar = nil
		if _Menu.Parent == _MainBar then
			_MainBar = nil
			_Menu.Parent.MainBar = false
			_Menu.Parent.ReplaceBlzMainAction = false
		end
		if _Menu.Parent == _QuestBar then
			_QuestBar = nil
			_Menu.Parent.QuestBar = false
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
			if _Menu.Parent == _QuestBar then
				_QuestBar = nil
				_Menu.Parent.QuestBar = false
			end
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
		if not _QuestBar then
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
			_QuestBar = _Menu.Parent
			_Menu.Parent.QuestBar = true
			BAG_UPDATE()
		end
	elseif index == 10 then
		if not _PetBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _QuestBar then
				_QuestBar = nil
				_Menu.Parent.QuestBar = false
			end
			if _Menu.Parent == _StanceBar then
				_StanceBar = nil
				_Menu.Parent.StanceBar = false
			end
			_PetBar = _Menu.Parent
			_Menu.Parent.PetBar = true
		end
	elseif index == 11 then
		if not _StanceBar then
			if _Menu.Parent == _MainBar then
				return
			end
			if _Menu.Parent == _QuestBar then
				_QuestBar = nil
				_Menu.Parent.QuestBar = false
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
		if _Menu.Parent == _QuestBar then
			_QuestBar = nil
			_Menu.Parent.QuestBar = false
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

function _ListScale:OnItemChoosed(key, item)
	_Menu.Parent.Scale = key
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

function _MenuHideOutOfCombat:OnCheckChanged()
	_Menu.Parent.HideOutOfCombat = self.Checked
end

function _MenuHideInPetBattle:OnCheckChanged()
	_Menu.Parent.HideInPetBattle = self.Checked
end

function _MenuHideInVehicle:OnCheckChanged()
	_Menu.Parent.HideInVehicle = self.Checked
end

function _MenuUseDown:OnCheckChanged()
	if self.Checked then
		IFActionHandler._EnableGroupUseButtonDown(_IGASUI_ACTIONBAR_GROUP)
	else
		IFActionHandler._DisableGroupUseButtonDown(_IGASUI_ACTIONBAR_GROUP)
	end
end

function _MenuKeyBinding:OnClick()
	IFKeyBinding._ModeOn()
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

function _MenuHideBlz:OnCheckChanged()
	_HiddenMainMenuBar = self.Checked
	IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateBlzMainMenuBar)
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
