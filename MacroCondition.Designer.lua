-----------------------------------------
-- Designer for MacroCondition
-----------------------------------------
IGAS:NewAddon "IGAS_UI.MacroCondition"

import "System.Widget"

macroCondition = Form("IGAS_UI_MacroCondition")
macroCondition.Visible = false
macroCondition:SetSize(600, 400)
macroCondition.Caption = L"Macro Condition Editor"
macroCondition.Message = " "
macroCondition.Layout = SplitLayoutPanel
macroCondition:SetMinResize(600, 400)
macroCondition:SetMaxResize(600, 400)
macroCondition.Resizable = false

macroCondition:AddWidget("AutoHideList", List, "west", 150, "px")
autoHideList = macroCondition:GetWidget("AutoHideList")
autoHideList:SetMinResize(100, 100)
autoHideList:SetMaxResize(200, 200)

btnAdd = NormalButton("Add2List", macroCondition)
btnAdd:SetPoint("TOPLEFT", autoHideList, "BOTTOMLEFT")
btnAdd:SetPoint("RIGHT", autoHideList, "CENTER")
btnAdd:SetPoint("BOTTOM", 0, 4)
btnAdd.Text = "+"
btnAdd.Style = "Classic"
btnAdd:ActiveThread("OnClick")

btnRemove = NormalButton("Remove4List", macroCondition)
btnRemove:SetPoint("TOPLEFT", btnAdd, "TOPRIGHT")
btnRemove:SetPoint("BOTTOMLEFT", btnAdd, "BOTTOMRIGHT")
btnRemove:SetPoint("RIGHT", autoHideList, "RIGHT")
btnRemove.Text = "-"
btnRemove.Style = "Classic"
btnRemove:ActiveThread("OnClick")

macroCondition:AddWidget("HelperGrp", GroupBox, "north", 60, "px")
grpHelper = macroCondition:GetWidget("HelperGrp")
grpHelper.Caption = ""
grpHelper:SetMinResize(60, 60)
grpHelper:SetMaxResize(60, 60)

lblHelper = FontString("LblHelper", grpHelper)
lblHelper:SetPoint("TOPLEFT", 4, -4)
lblHelper:SetPoint("BOTTOMRIGHT", -4, 4)
lblHelper.JustifyH = "Left"
lblHelper.JustifyV = "TOP"
lblHelper.Text = L"Double-click items in the left list to select a condition.\nDoublc-click items in the bottom list to dis-select."

macroCondition:AddWidget("CommitGrp", GroupBox, "south", 32, "px")
grpCommit = macroCondition:GetWidget("CommitGrp")
grpCommit.Caption = ""
grpCommit:SetMinResize(120, 32)
grpCommit:SetMaxResize(300, 32)

btnClose = NormalButton("btnClose", grpCommit)
btnClose.Style = "Classic"
btnClose.Text = L"Close"
btnClose:SetPoint("RIGHT", grpCommit)
btnClose.Width = 100
btnClose.Height = 24

btnSave = NormalButton("btnSave", grpCommit)
btnSave.Style = "Classic"
btnSave.Text = L"Apply"
btnSave:SetPoint("RIGHT", btnClose, "LEFT", -4, 0)
btnSave.Width = 100
btnSave.Height = 24

macroCondition:AddWidget("EnableList", List, "rest")
enableList = macroCondition:GetWidget("EnableList")

-----------------------------
-- Macro Condtion Maker
-----------------------------
macroMaker = Form("IGAS_UI_MacroMaker")
macroMaker:SetSize(600, 400)
macroMaker.Caption = L"Conditon Maker"
macroMaker.Resizable = false
macroMaker.Visible = false
macroMaker.Message = L"Click the link to add or remove the conditions."

txtDesc = SingleTextBox("TxtDesc", macroMaker)
txtDesc:SetPoint("TOPLEFT", 4, -26)
txtDesc:SetPoint("RIGHT", -4, 0)

htmlResult = HTMLViewer("HtmlResult", macroMaker)
htmlResult:SetPoint("TOPLEFT", txtDesc, "BOTTOMLEFT", 0, -4)
htmlResult:SetPoint("TOPRIGHT", txtDesc, "BOTTOMRIGHT", 0, -4)
htmlResult.Height = 48
htmlResult:ActiveThread("OnHyperlinkClick")

htmlCondition = HTMLViewer("HtmlCondition", macroMaker)
htmlCondition:SetPoint("TOPLEFT", htmlResult, "BOTTOMLEFT", 0, -4)
htmlCondition:SetPoint("BOTTOMRIGHT", macroMaker, -4, 32)

btnCloseCondition = NormalButton("btnCloseCondition", macroMaker)
btnCloseCondition.Style = "Classic"
btnCloseCondition.Text = L"Close"
btnCloseCondition:SetPoint("BOTTOMRIGHT", macroMaker, -4, 10)
btnCloseCondition.Width = 100
btnCloseCondition.Height = 24

btnSaveCondition = NormalButton("btnSaveCondition", macroMaker)
btnSaveCondition.Style = "Classic"
btnSaveCondition.Text = L"Save"
btnSaveCondition:SetPoint("RIGHT", btnCloseCondition, "LEFT", -4, 0)
btnSaveCondition.Width = 100
btnSaveCondition.Height = 24