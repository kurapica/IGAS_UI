-----------------------------------------
-- Form for Auto Pop-up actions
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ActionBar"

_FilterCodeList = [[
-- _type : the action's type like "spell", "item"
-- action : the action's value like spell id, item id
local _type, action = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeSpell = [[
-- spellID : the spell's id
-- spellIndex : the spell's index in the spell book
local spellID, spellIndex = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeItem = [[
-- itemID : the item's id
-- bag : the bag
-- slot : the slot
local itemID, bag, slot = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeToy = [[
-- toyID : the toy's id
-- index : the toy's index that can be used by C_ToyBox.GetToyInfo
local toyID, index = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeBattlePet = [[
-- petID : the pet's id
-- index : the pet's index that can be used by C_PetJournal.GetPetInfoByIndex
local petID, index = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeMount = [[
-- mountID : the mount's id
-- index : the mount's index that can be used by C_MountJournal.GetMountInfo
local mountID, index = ...

-- return true to generate a button for the action
return true
]]

_FilterCodeEquipSet = [[
-- name : the equipset's name
-- index : the equipset's index that can be used by GetEquipmentSetInfo
local name, index = ...

-- return true to generate a button for the action
return true
]]

--------------------------------
-- Designer
--------------------------------
autoGenerateForm = Form("AutoGenerateAction")
autoGenerateForm.Caption = L"Auto Generate Pop-up Actions"
autoGenerateForm.Layout = SplitLayoutPanel
autoGenerateForm.Message = " "
autoGenerateForm:SetMinResize(400, 300)
autoGenerateForm:SetMaxResize(900, 600)
autoGenerateForm.Visible = false

autoGenerateForm:AddWidget(List, "west", 100, "px")
autoList = autoGenerateForm:GetWidget(List)
autoList:SetMinResize(100, 100)
autoList:SetMaxResize(150, 150)

btnAdd = NormalButton("Add2List", autoGenerateForm)
btnAdd:SetPoint("TOPLEFT", autoList, "BOTTOMLEFT")
btnAdd:SetPoint("RIGHT", autoList, "CENTER")
btnAdd:SetPoint("BOTTOM", 0, 4)
btnAdd.Text = "+"
btnAdd.Style = "Classic"
btnAdd:ActiveThread("OnClick")

btnRemove = NormalButton("Remove4List", autoGenerateForm)
btnRemove:SetPoint("TOPLEFT", btnAdd, "TOPRIGHT")
btnRemove:SetPoint("BOTTOMLEFT", btnAdd, "BOTTOMRIGHT")
btnRemove:SetPoint("RIGHT", autoList, "RIGHT")
btnRemove.Text = "-"
btnRemove.Style = "Classic"
btnRemove:ActiveThread("OnClick")

autoGenerateForm:AddWidget("OptionGrp", GroupBox, "north", 120, "px")
grpOption = autoGenerateForm:GetWidget("OptionGrp")
grpOption.Caption = ""
grpOption:SetMinResize(120, 120)
grpOption:SetMaxResize(300, 300)

autoGenerateForm:AddWidget("ItemList", List, "west", 100, "px")
itemList = autoGenerateForm:GetWidget("ItemList")
itemList:SetMinResize(100, 100)
itemList:SetMaxResize(150, 150)
itemList.Visible = false
itemList.ShowTooltip = true

autoGenerateForm:AddWidget("CommitGrp", GroupBox, "south", 24, "px")
grpCommit = autoGenerateForm:GetWidget("CommitGrp")
grpCommit.Caption = ""
grpCommit:SetMinResize(120, 24)
grpCommit:SetMaxResize(300, 24)

btnSave = NormalButton("btnSave", grpCommit)
btnSave.Style = "Classic"
btnSave.Text = L"Save"
btnSave:SetPoint("TOPLEFT")
btnSave:SetPoint("BOTTOMLEFT")
btnSave:SetPoint("RIGHT", grpCommit, "CENTER")

btnApply = NormalButton("btnApply", grpCommit)
btnApply.Style = "Classic"
btnApply.Text = L"Apply"
btnApply:SetPoint("TOPRIGHT")
btnApply:SetPoint("BOTTOMRIGHT")
btnApply:SetPoint("LEFT", grpCommit, "CENTER")

autoGenerateForm:AddWidget(CodeEditor, "rest")
editor = autoGenerateForm:GetWidget(CodeEditor)
editor.Visible = false

btnReceive = Action.ActionButton("IGAS_UI_AUTO_RECEIVE_BUTTON")
btnReceive:ClearAllPoints()
btnReceive:SetPoint("CENTER")
btnReceive.ShowGrid = true
btnReceive.UseBlizzardArt = true
btnReceive.FrameStrata = "DIALOG"
btnReceive.Visible = false

anim = Action.SpellActivationAlert("Alert", btnReceive)
anim:SetPoint("CENTER")
anim:SetSize(btnReceive.Width * 1.4, btnReceive.Height * 1.4)

btnAddItem = NormalButton("Add2ItemList", autoGenerateForm)
btnAddItem:SetPoint("TOPLEFT", itemList, "BOTTOMLEFT")
btnAddItem:SetPoint("RIGHT", itemList, "CENTER")
btnAddItem:SetPoint("BOTTOM", 0, 4)
btnAddItem.Text = "+"
btnAddItem.Style = "Classic"
btnAddItem:ActiveThread("OnClick")

btnRemoveItem = NormalButton("Remove4ItemList", autoGenerateForm)
btnRemoveItem:SetPoint("TOPLEFT", btnAddItem, "TOPRIGHT")
btnRemoveItem:SetPoint("BOTTOMLEFT", btnAddItem, "BOTTOMRIGHT")
btnRemoveItem:SetPoint("RIGHT", itemList, "RIGHT")
btnRemoveItem.Text = "-"
btnRemoveItem.Style = "Classic"
btnRemoveItem:ActiveThread("OnClick")

lblType = FontString("lblType", grpOption)
lblType.FontObject = "ChatFontNormal"
lblType:SetPoint("TOPLEFT", 4, -16)
lblType:SetPoint("RIGHT", grpOption, "CENTER")
lblType.Text = L"Action Type"

cboType = ComboBox("cboType", grpOption)
cboType:AddItem("List", L"Use List")
cboType:AddItem("Spell", L"Spell")
cboType:AddItem("Item", L"Item")
cboType:AddItem("Toy", L"Toy")
cboType:AddItem("BattlePet", L"BattlePet")
cboType:AddItem("Mount", L"Mount")
cboType:AddItem("EquipSet", L"EquipSet")

cboType:SetPoint("TOP", lblType)
cboType:SetPoint("RIGHT", -4, 0)
cboType:SetPoint("LEFT", grpOption, "CENTER")

chkAutoGenerate = CheckBox("chkAutoGenerate", grpOption)
chkAutoGenerate:GetChild("Text").FontObject = "ChatFontNormal"
chkAutoGenerate:SetPoint("TOPLEFT", lblType, "BOTTOMLEFT", 0, -16)
chkAutoGenerate:SetPoint("TOPRIGHT", lblType, "BOTTOMRIGHT")
chkAutoGenerate.Text = L"Auto-generate buttons"
chkAutoGenerate.Checked = false

optMaxActionButtons = OptionSlider("optMaxActionButtons", grpOption)
optMaxActionButtons:SetPoint("TOP", chkAutoGenerate)
optMaxActionButtons:SetPoint("RIGHT", -4, 0)
optMaxActionButtons:SetPoint("LEFT", grpOption, "CENTER")
optMaxActionButtons:SetMinMaxValues(1, 24)
optMaxActionButtons.Value = 1
optMaxActionButtons.Enabled = false

chkFilter = CheckBox("chkFilter", grpOption)
chkFilter:GetChild("Text").FontObject = "ChatFontNormal"
chkFilter:SetPoint("TOPLEFT", chkAutoGenerate, "BOTTOMLEFT", 0, -16)
chkFilter:SetPoint("TOPRIGHT", chkAutoGenerate, "BOTTOMRIGHT")
chkFilter.Text = L"Use filter"
chkFilter.Checked = false

chkFavourite = CheckBox("chkFavourite", grpOption)
chkFavourite:GetChild("Text").FontObject = "ChatFontNormal"
chkFavourite:SetPoint("TOP", chkFilter)
chkFavourite:SetPoint("RIGHT", -4, 0)
chkFavourite:SetPoint("LEFT", grpOption, "CENTER")
chkFavourite.Text = L"Only Favourite"
chkFavourite.Checked = false

--------------------------------
-- Script
--------------------------------
local _autoPopupSet

function autoList:OnItemChoosed(key)
	if key then
		_autoPopupSet = _DBAutoPopupList[key]
		if _autoPopupSet.Type then
			cboType.Value = _autoPopupSet.Value
		else
			cboType.Value = "List"
		end
		if _autoPopupSet.Type == "Toy" or _autoPopupSet.Type == "BattlePet" or _autoPopupSet.Type == "Mount" then
			chkFavourite.Visible = true
			chkFavourite.Checked = _autoPopupSet.OnlyFavourite
		else
			chkFavourite.Visible = false
			chkFavourite.Checked = false
		end
		chkFilter.Checked = _autoPopupSet.FilterCode and true or false
		editor.Visible = chkFilter.Checked
		editor.Text = _autoPopupSet.FilterCode
		chkAutoGenerate.Checked = _autoPopupSet.AutoGenerate
		optMaxActionButtons.Enabled = chkAutoGenerate.Checked
		optMaxActionButtons.Value = _autoPopupSet.MaxAction or 1
	end
end

function cboType:OnValueChanged(key)
	if _autoPopupSet.Type == "Toy" or _autoPopupSet.Type == "BattlePet" or _autoPopupSet.Type == "Mount" then
		chkFavourite.Visible = true
		chkFavourite.Checked = _autoPopupSet.OnlyFavourite
	else
		chkFavourite.Visible = false
		chkFavourite.Checked = false
	end
end

function btnAdd:OnClick()
    local name = IGAS:MsgBox("Please input the auto aciton list's name", "ic")
    if name and not autoList:GetItem(name) then
    	_DBAutoPopupList[name] = {}
        autoList:AddItem(name, name)
    end
end

function btnRemove:OnClick()
    local name = autoList:GetSelectedItemValue()
    if name and IGAS:MsgBox("Are you sure to delete the auto action list?", "n") then
        autoList:RemoveItem(name)
        _autoPopupSet = nil

        cboType.Value = "List"
		chkFavourite.Visible = false
		chkFavourite.Checked = false
		chkFilter.Checked = false
		editor.Visible = false
		editor.Text = ""
		chkAutoGenerate.Checked = false
		optMaxActionButtons.Enabled = false
		optMaxActionButtons.Value = 1
    end
end

function btnAddItem:OnClick()
    btnReceive.Visible = true
    IGAS:MsgBox("Please drag the item into the center button")
    btnReceive.Visible = false
end

function btnRemoveItem:OnClick()

end

function btnReceive:OnShow()
    anim.AnimInPlaying = true
end

function btnReceive:OnHide()
    anim:StopAnimation()
end

function btnReceive:UpdateAction()
    local kind, target, detail = self:GetAction()
    print(kind, target, detail)
    if kind == "spell" then
        itemList:AddItem("spell-" .. target, GetSpellLink(target))
    end
    self:SetAction(nil)
end

function itemList:OnGameTooltipShow(gametip, key, text)
    gametip:SetSpellByID(tonumber(key:match("%d+$")))
end

function chkAutoGenerate:OnValueChanged()
    optMaxActionButtons.Enabled = self.Checked
end

function chkFilter:OnValueChanged()
	editor.Visible = self.Checked
	if editor.Visible and _autoPopupSet then
		if not _autoPopupSet.FilterCode then
			-- Auto generate code
			if _autoPopupSet.Type == "List" then
				editor.Text = _FilterCodeList
			elseif _autoPopupSet.Type == "Spell" then
				editor.Text = _FilterCodeSpell
			elseif _autoPopupSet.Type == "Item" then
				editor.Text = _FilterCodeItem
			elseif _autoPopupSet.Type == "Toy" then
				editor.Text = _FilterCodeToy
			elseif _autoPopupSet.Type == "BattlePet" then
				editor.Text = _FilterCodeBattlePet
			elseif _autoPopupSet.Type == "Mount" then
				editor.Text = _FilterCodeMount
			elseif _autoPopupSet.Type == "EquipSet" then
				editor.Text = _FilterCodeEquipSet
			end
		end
	end
end