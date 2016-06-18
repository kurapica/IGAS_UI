-----------------------------------------
-- Form for Auto Pop-up actions
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ActionBar"

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
autoGenerateForm:SetSize(600, 400)
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

autoGenerateForm:AddWidget("OptionGrp", GroupBox, "north", 160, "px")
grpOption = autoGenerateForm:GetWidget("OptionGrp")
grpOption.Caption = ""
grpOption:SetMinResize(160, 160)
grpOption:SetMaxResize(300, 300)
grpOption.Visible = false

autoGenerateForm:AddWidget("CommitGrp", GroupBox, "south", 32, "px")
grpCommit = autoGenerateForm:GetWidget("CommitGrp")
grpCommit.Caption = ""
grpCommit:SetMinResize(120, 32)
grpCommit:SetMaxResize(300, 32)
grpCommit.Visible = false

btnApply = NormalButton("btnApply", grpCommit)
btnApply.Style = "Classic"
btnApply.Text = L"Apply"
btnApply:SetPoint("CENTER", grpCommit)
btnApply:SetPoint("RIGHT")
btnApply.Width = 100
btnApply.Height = 24

btnSave = NormalButton("btnSave", grpCommit)
btnSave.Style = "Classic"
btnSave.Text = L"Save"
btnSave:SetPoint("CENTER", grpCommit)
btnSave:SetPoint("RIGHT", btnApply, "LEFT")
btnSave.Width = 100
btnSave.Height = 24

autoGenerateForm:AddWidget(CodeEditor, "rest")
editor = autoGenerateForm:GetWidget(CodeEditor)
editor.Visible = false

lblType = FontString("lblType", grpOption)
lblType.FontObject = "ChatFontNormal"
lblType:SetPoint("TOPLEFT", 4, -16)
lblType:SetPoint("RIGHT", grpOption, "CENTER")
lblType.Text = L"Action Type"

cboType = ComboBox("cboType", grpOption)
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

chkOrder = CheckBox("chkOrder", grpOption)
chkOrder:GetChild("Text").FontObject = "ChatFontNormal"
chkOrder:SetPoint("TOP", chkFilter)
chkOrder:SetPoint("RIGHT", -4, 0)
chkOrder:SetPoint("LEFT", grpOption, "CENTER")
chkOrder.Text = L"Use reverse order"
chkOrder.Checked = false

cboItemClass = ComboBox("cboItemClass", grpOption)
cboItemClass:SetPoint("TOPLEFT", chkFilter, "BOTTOMLEFT", 0, -16)
cboItemClass:SetPoint("TOPRIGHT", chkFilter, "BOTTOMRIGHT")
cboItemClass:AddItem(0, L"All")
cboItemClass.Value = 0

_AuctionItemClasses = { GetAuctionItemClasses() }
for i, v in ipairs(_AuctionItemClasses) do
	_AuctionItemClasses[i] = {
		Name = v,
		SubClass = { GetAuctionItemSubClasses(i) }
	}
	if i == 4 then
		tinsert(_AuctionItemClasses[i].SubClass, v)
	elseif i == 6 then
		for j in ipairs(_AuctionItemClasses[i].SubClass) do
			if j ~= 10 and j ~= 11 then
				_AuctionItemClasses[i].SubClass[j] = nil
			end
		end
	end

	if i == 4 or i == 6 or i == 9 or i == 10 then
		cboItemClass:AddItem(i, v)
	end
end
cboItemClass.Visible = false

cboItemSubClass = ComboBox("cboItemSubClass", grpOption)
cboItemSubClass:SetPoint("TOP", cboItemClass)
cboItemSubClass:SetPoint("RIGHT", -4, 0)
cboItemSubClass:SetPoint("LEFT", grpOption, "CENTER")
cboItemSubClass.Visible = false

--------------------------------
-- Script
--------------------------------
local _autoPopupSet

function autoList:OnItemChoosed(key)
	if key then
		_autoPopupSet = _DBAutoPopupList[key]
		if _autoPopupSet.Type then
			cboType.Value = _autoPopupSet.Type
		else
			cboType.Value = "Item"
		end
		if _autoPopupSet.Type == "Toy" or _autoPopupSet.Type == "BattlePet" or _autoPopupSet.Type == "Mount" then
			chkFavourite.Visible = true
			chkFavourite.Checked = _autoPopupSet.OnlyFavourite
		else
			chkFavourite.Visible = false
			chkFavourite.Checked = false
		end
		if cboType.Value == "Item" then
			cboItemClass.Visible = true
			cboItemSubClass.Visible = true
			chkOrder.Visible = true
			cboItemClass.Value = _autoPopupSet.ItemClass or 0
			cboItemClass:OnValueChanged(cboItemClass.Value)
			cboItemSubClass.Value = _autoPopupSet.ItemSubClass or 0
			chkOrder.Checked = _autoPopupSet.UseReverseOrder
		else
			cboItemClass.Visible = false
			cboItemSubClass.Visible = false
			chkOrder.Visible = false
		end
		chkFilter.Checked = _autoPopupSet.FilterCode and true or false
		editor.Visible = chkFilter.Checked
		editor.Text = _autoPopupSet.FilterCode or ""
		chkAutoGenerate.Checked = _autoPopupSet.AutoGenerate
		optMaxActionButtons.Enabled = chkAutoGenerate.Checked
		optMaxActionButtons.Value = _autoPopupSet.MaxAction or 1

		grpOption.Visible = true
		grpCommit.Visible = true
	else
		_autoPopupSet = nil

		cboType.Value = "Item"
		chkFavourite.Visible = false
		chkFavourite.Checked = false
		chkFilter.Checked = false
		cboItemClass.Visible = true
		cboItemSubClass.Visible = true
		chkOrder.Visible = true
		editor.Visible = false
		editor.Text = ""
		chkAutoGenerate.Checked = false
		optMaxActionButtons.Enabled = false
		optMaxActionButtons.Value = 1
		chkOrder.Checked = false

		grpOption.Visible = false
		grpCommit.Visible = false
	end
end

function cboType:OnValueChanged(key)
	if cboType.Value == "Toy" or cboType.Value == "BattlePet" or cboType.Value == "Mount" then
		chkFavourite.Visible = true
	else
		chkFavourite.Visible = false
		chkFavourite.Checked = false
	end
	if cboType.Value == "Item" then
		cboItemClass.Visible = true
		cboItemSubClass.Visible = true
		chkOrder.Visible = true
		cboItemClass.Value = _autoPopupSet and _autoPopupSet.ItemClass or 0
		cboItemClass:OnValueChanged(cboItemClass.Value)
		cboItemSubClass.Value = _autoPopupSet and _autoPopupSet.ItemSubClass or 0
		chkOrder.Checked = _autoPopupSet and _autoPopupSet.UseReverseOrder
	else
		cboItemClass.Visible = false
		cboItemSubClass.Visible = false
		chkOrder.Visible = false
	end
end

function btnAdd:OnClick()
	local name = IGAS:MsgBox(L"Please input the auto aciton list's name", "ic")
	if name and not autoList:GetItem(name) then
		_DBAutoPopupList[name] = { Name = name }
		autoList:AddItem(name, name)
		autoList:SelectItemByValue(name)
		autoList:OnItemChoosed(name)
	end
end

function btnRemove:OnClick()
	local name = autoList:GetSelectedItemValue()
	if name and IGAS:MsgBox(L"Are you sure to delete the auto action list?", "n") then
		autoList:RemoveItem(name)
		AutoActionTask(_autoPopupSet.Name):Dispose()
		_DBAutoPopupList[_autoPopupSet.Name] = nil
		autoList:OnItemChoosed(nil)
	end
end

function chkAutoGenerate:OnValueChanged()
	optMaxActionButtons.Enabled = self.Checked
	if not optMaxActionButtons.Enabled then
		optMaxActionButtons.Value = 1
	end
end

function chkFilter:OnValueChanged()
	editor.Visible = self.Checked
	if editor.Visible and _autoPopupSet then
		autoGenerateForm.Panel:Layout()
		if not _autoPopupSet.FilterCode then
			-- Auto generate code
			if cboType.Value == "Item" then
				editor.Text = _FilterCodeItem
			elseif cboType.Value == "Toy" then
				editor.Text = _FilterCodeToy
			elseif cboType.Value == "BattlePet" then
				editor.Text = _FilterCodeBattlePet
			elseif cboType.Value == "Mount" then
				editor.Text = _FilterCodeMount
			elseif cboType.Value == "EquipSet" then
				editor.Text = _FilterCodeEquipSet
			end
		end
	end
end

function btnSave:OnClick()
	if _autoPopupSet then
		_autoPopupSet.Type = cboType.Value
		_autoPopupSet.OnlyFavourite = chkFavourite.Checked
		_autoPopupSet.AutoGenerate = chkAutoGenerate.Checked
		_autoPopupSet.MaxAction = mround(optMaxActionButtons.Value)
		if _autoPopupSet.Type == "Item" then
			if cboItemClass.Value > 0 then
				_autoPopupSet.ItemClass = cboItemClass.Value
				if cboItemSubClass.Value > 0 then
					_autoPopupSet.ItemSubClass = cboItemSubClass.Value
				else
					_autoPopupSet.ItemSubClass = nil
				end
				_autoPopupSet.UseReverseOrder = chkOrder.Checked
			else
				_autoPopupSet.ItemClass = nil
				_autoPopupSet.ItemSubClass = nil
				_autoPopupSet.UseReverseOrder = nil
			end
		else
			_autoPopupSet.ItemClass = nil
			_autoPopupSet.ItemSubClass = nil
			_autoPopupSet.UseReverseOrder = nil
		end
		local code = editor.Visible and editor.Text
		if code then code = strtrim(code) end
		if not code or code == "" then code = nil end
		_autoPopupSet.FilterCode = code

		local task = AutoActionTask(_autoPopupSet.Name)

		task.Type = _autoPopupSet.Type
		task.OnlyFavourite = _autoPopupSet.OnlyFavourite
		task.AutoGenerate = _autoPopupSet.AutoGenerate
		task.MaxAction = _autoPopupSet.MaxAction
		task.FilterCode = _autoPopupSet.FilterCode
		task.ItemClass = _autoPopupSet.ItemClass
		task.ItemSubClass = _autoPopupSet.ItemSubClass
		task.UseReverseOrder = _autoPopupSet.UseReverseOrder

		return task:RestartTask()
	end
end

function btnApply:OnClick()
	if _autoPopupSet and autoGenerateForm.RootActionButton then
		local task = AutoActionTask(_autoPopupSet.Name)
		task:AddRoot(autoGenerateForm.RootActionButton)
	end
end

function autoGenerateForm:OnShow()
	if not autoGenerateForm.RootActionButton then self.Visible = false end
	if autoGenerateForm.RootActionButton.AutoActionTask then
		autoList:SelectItemByValue(autoGenerateForm.RootActionButton.AutoActionTask.Name)
		autoList:OnItemChoosed(autoGenerateForm.RootActionButton.AutoActionTask.Name)
	else
		autoList:SelectItemByValue(nil)
		autoList:OnItemChoosed(nil)
	end
end

function autoGenerateForm:OnHide()
	autoGenerateForm.RootActionButton = nil
end

function cboItemClass:OnValueChanged(key)
	cboItemSubClass:Clear()
	cboItemSubClass:AddItem(0, L"All")
	cboItemSubClass.Value = 0
	if key > 0 then
		for i, v in pairs(_AuctionItemClasses[key].SubClass) do
			cboItemSubClass:AddItem(i, v)
		end
	end
end