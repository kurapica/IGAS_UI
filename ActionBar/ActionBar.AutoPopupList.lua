-----------------------------------------
-- Form for Auto Pop-up actions
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ActionBar"

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
autoGenerateForm.Panel.HSpacing = 3
autoGenerateForm.Panel.VSpacing = 3

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

autoGenerateForm:AddWidget("CommitGrp", GroupBox, "south", 32, "px")
grpCommit = autoGenerateForm:GetWidget("CommitGrp")
grpCommit.Caption = ""
grpCommit:SetMinResize(120, 32)
grpCommit:SetMaxResize(300, 32)
grpCommit.Visible = false

autoGenerateForm:AddWidget("OptionGrp", GroupBox, "rest")
grpOption = autoGenerateForm:GetWidget("OptionGrp")
grpOption.Caption = ""
grpOption:SetMinResize(160, 160)
grpOption:SetMaxResize(300, 300)
grpOption.Visible = false

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

chkFavourite = CheckBox("chkFavourite", grpOption)
chkFavourite:GetChild("Text").FontObject = "ChatFontNormal"
chkFavourite:SetPoint("TOPLEFT", chkAutoGenerate, "BOTTOMLEFT", 0, -16)
chkFavourite:SetPoint("TOPRIGHT", chkAutoGenerate, "BOTTOMRIGHT")
chkFavourite:SetPoint("LEFT", grpOption, "CENTER")
chkFavourite.Text = L"Only Favourite"
chkFavourite.Checked = false

cboItemClass = ComboBox("cboItemClass", grpOption)
cboItemClass:SetPoint("TOPLEFT", chkAutoGenerate, "BOTTOMLEFT", 0, -16)
cboItemClass:SetPoint("TOPRIGHT", chkAutoGenerate, "BOTTOMRIGHT")
cboItemClass:SetPoint("RIGHT", grpOption, "CENTER")
cboItemClass.Value = 0

_AuctionItemClasses = {}

local i = 0
local itemCls = GetItemClassInfo(i)

while itemCls and #itemCls > 0 do
	_AuctionItemClasses[i] = { Name = itemCls, SubClass = {} }

	local j = 0
	local itemSubCls = GetItemSubClassInfo(i, j)

	while itemSubCls and #itemSubCls > 0 do
		_AuctionItemClasses[i].SubClass[j] = itemSubCls

		j = j + 1
		itemSubCls = GetItemSubClassInfo(i, j)
	end

	cboItemClass:AddItem(i, itemCls)

	i = i + 1
	itemCls = GetItemClassInfo(i)
end

cboItemClass.Visible = false

cboItemSubClass = ComboBox("cboItemSubClass", grpOption)
cboItemSubClass:SetPoint("TOP", cboItemClass)
cboItemSubClass:SetPoint("RIGHT", -4, 0)
cboItemSubClass:SetPoint("LEFT", grpOption, "CENTER")
cboItemSubClass.Visible = false

lblFilter = FontString("lblFilter", grpOption)
lblFilter.FontObject = "ChatFontNormal"
lblFilter:SetPoint("TOPLEFT", cboItemClass, "BOTTOMLEFT", 0, -16)
lblFilter.Text = L"Tooltip filter(Like 'Artifact Power', use ';' to seperate)"

txtFilter = SingleTextBox("txtFilter", grpOption)
txtFilter:SetPoint("TOPLEFT", lblFilter, "BOTTOMLEFT", 0, -16)
txtFilter.Height = 24
txtFilter:SetPoint("RIGHT", -4, 0)

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
			cboItemClass.Value = _autoPopupSet.ItemClass or 0
			cboItemClass:OnValueChanged(cboItemClass.Value)
			cboItemSubClass.Value = _autoPopupSet.ItemSubClass or 100
			lblFilter.Visible = true
			txtFilter.Visible = true
			txtFilter.Text = _autoPopupSet.TipFilter or ""
		else
			cboItemClass.Visible = false
			cboItemSubClass.Visible = false
			lblFilter.Visible = false
			txtFilter.Visible = false
		end
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
		cboItemClass.Visible = true
		cboItemSubClass.Visible = true
		chkAutoGenerate.Checked = false
		optMaxActionButtons.Enabled = false
		optMaxActionButtons.Value = 1
		lblFilter.Visible = false
		txtFilter.Visible = false

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
		cboItemClass.Value = _autoPopupSet and _autoPopupSet.ItemClass or 0
		cboItemClass:OnValueChanged(cboItemClass.Value)
		cboItemSubClass.Value = _autoPopupSet and _autoPopupSet.ItemSubClass or 100
		lblFilter.Visible = true
		txtFilter.Visible = true
		txtFilter.Text = _autoPopupSet and _autoPopupSet.TipFilter or ""
	else
		cboItemClass.Visible = false
		cboItemSubClass.Visible = false
		lblFilter.Visible = false
		txtFilter.Visible = false
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

function btnSave:OnClick()
	if _autoPopupSet then
		_autoPopupSet.Type = cboType.Value
		_autoPopupSet.OnlyFavourite = chkFavourite.Checked
		_autoPopupSet.AutoGenerate = chkAutoGenerate.Checked
		_autoPopupSet.MaxAction = mround(optMaxActionButtons.Value)
		if _autoPopupSet.Type == "Item" then
			_autoPopupSet.ItemClass = cboItemClass.Value
			if cboItemSubClass.Value < 100 then
				_autoPopupSet.ItemSubClass = cboItemSubClass.Value
			else
				_autoPopupSet.ItemSubClass = nil
			end

			local filter = txtFilter.Text
			if type(filter) == "string" then filter = strtrim(filter) end
			if filter == "" then filter = nil end
			_autoPopupSet.TipFilter = filter
		else
			_autoPopupSet.ItemClass = nil
			_autoPopupSet.ItemSubClass = nil
			_autoPopupSet.TipFilter = nil
		end

		local task = AutoActionTask(_autoPopupSet.Name)
		task:StopTask()

		task.Type = _autoPopupSet.Type
		task.OnlyFavourite = _autoPopupSet.OnlyFavourite
		task.AutoGenerate = _autoPopupSet.AutoGenerate
		task.MaxAction = _autoPopupSet.MaxAction
		task.ItemClass = _autoPopupSet.ItemClass
		task.ItemSubClass = _autoPopupSet.ItemSubClass
		task.TipFilter = _autoPopupSet.TipFilter

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
	Task.NextCall(autoGenerateForm.Panel.Layout, autoGenerateForm.Panel)
end

function autoGenerateForm:OnHide()
	autoGenerateForm.RootActionButton = nil
end

function cboItemClass:OnValueChanged(key)
	cboItemSubClass:AddItem(100, L"All")
	cboItemSubClass.Value = 100
	cboItemSubClass:Clear()

	local subCls = _AuctionItemClasses[key].SubClass

	for i = 0, #subCls do
		cboItemSubClass:AddItem(i, subCls[i])
	end
end
