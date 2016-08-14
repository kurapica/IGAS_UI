-----------------------------------------
-- Designer for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

_ContainerHeader = ContainerHeader("IGAS_UI_ContainerHeader")
_ContainerHeader:SetPoint("TOPRIGHT", - 140, -100)
_ContainerHeader.Visible = false

_ToggleButton = CreateFrame("CheckButton", "IGAS_UI_ContainerToggle", UIParent, "SecureActionButtonTemplate")
_ToggleButton:Hide()
SecureHandlerSetFrameRef(_ToggleButton, "ContainerHeader", IGAS:GetUI(_ContainerHeader))
SecureHandlerExecute(_ToggleButton, [[ContainerHeader = self:GetFrameRef("ContainerHeader")]])
_ToggleButton:SetAttribute("type", "toggle")
_ToggleButton:SetAttribute("_toggle", [[if ContainerHeader:IsShown() then ContainerHeader:Hide() self:CallMethod("OpenBag") else ContainerHeader:Show() self:CallMethod("CloseBag") end]])
_ToggleButton.OpenBag = function() PlaySound("igBackPackOpen") end
_ToggleButton.CloseBag = function() PlaySound("igBackPackClose") end

SetOverrideBindingClick(_ToggleButton, true, GetBindingKey("OPENALLBAGS") or "B", "IGAS_UI_ContainerToggle", "LeftButton")
--SetOverrideBindingClick(_ToggleButton, true, "SHIFT-" .. (GetBindingKey("OPENALLBAGS") or "B"), "IGAS_UI_ContainerToggle", "LeftButton")

-- Setting
btnSetting = Button("Setting", _ContainerHeader)
btnSetting:SetPoint("TOPRIGHT", -2, -2)
btnSetting:SetSize(24, 24)
btnSetting:SetNormalFontObject(GameFontHighlight)
btnSetting.Text = "?"

--------------------------
-- Mask
--------------------------
containerFrameMask = Mask("Mask", _ContainerHeader)
containerFrameMask.AsMove = true

--------------------------
-- Menu
--------------------------
containerConfig = DropDownList("Menu", _ContainerHeader)

mnuModifyAnchor = containerConfig:AddMenuButton(L"Modify AnchorPoints")
mnuModifyAnchor:ActiveThread("OnClick")

mnuShowRuleManager = containerConfig:AddMenuButton(L"Show the view manager")

--------------------------
-- View Rule manager
--------------------------
viewRuleManager = Form("IGAS_UI_ContainerViewRuleManager")
viewRuleManager.Visible = false
viewRuleManager:SetSize(800, 400)
viewRuleManager.Caption = L"Container View Rule Manager"
viewRuleManager.Resizable = false

viewRuleTree = TreeView("RuleTree", viewRuleManager)
viewRuleTree:SetPoint("TOPLEFT", 4, -26)
viewRuleTree:SetPoint("BOTTOMLEFT", 4, 32)
viewRuleTree.Width = 250
viewRuleTree.Style = "Classic"
viewRuleTree:ActiveThread("OnNodeFunctionClick")

btnAdd = NormalButton("Add2Tree", viewRuleManager)
btnAdd:SetPoint("TOP", viewRuleTree, "BOTTOM")
btnAdd:SetPoint("BOTTOM", 0, 2)
btnAdd.Width = 100
btnAdd.Text = "+"
btnAdd.Style = "Classic"
btnAdd:ActiveThread("OnClick")

htmlRule = HTMLViewer("HtmlRule", viewRuleManager)
htmlRule:SetPoint("TOPLEFT", viewRuleTree, "TOPRIGHT", 4, 0)
htmlRule:SetPoint("RIGHT", -4, 0)
htmlRule.Height = 100
htmlRule:ActiveThread("OnHyperlinkClick")
htmlRule.Visible = false

htmlCondition = HTMLViewer("HtmlCondition", viewRuleManager)
htmlCondition:SetPoint("TOPLEFT", htmlRule, "BOTTOMLEFT")
htmlCondition:SetPoint("TOPRIGHT", htmlRule, "BOTTOMRIGHT")
htmlCondition:SetPoint("BOTTOM", 0, 32)
htmlCondition:ActiveThread("OnHyperlinkClick")
htmlCondition.Visible = false

btnApply = NormalButton("Apply", viewRuleManager)
btnApply:SetPoint("BOTTOMRIGHT", -4, 2)
btnApply:SetPoint("TOP", htmlCondition, "BOTTOMRIGHT")
btnApply.Width = 100
btnApply.Text = L"Apply"
btnApply.Style = "Classic"