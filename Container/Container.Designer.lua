-----------------------------------------
-- Designer for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

--------------------------
-- Header Menu
--------------------------
headerMenu = DropDownList("IGAS_UI_Container_Menu")

mnuModifyAnchor = headerMenu:AddMenuButton(L"Modify AnchorPoints")
mnuModifyAnchor:ActiveThread("OnClick")

mnuShowRuleManager = headerMenu:AddMenuButton(L"Show the view manager")

--------------------------
-- Container
--------------------------
_ContainerHeader = ContainerHeader("IGAS_UI_ContainerHeader")
_ContainerHeader:SetPoint("TOPRIGHT", - 140, -100)

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

--------------------------
-- Bank
--------------------------
_BankHeader = ContainerHeader("IGAS_UI_BankHeader", UIParent, true)
_BankHeader:SetPoint("TOPLEFT", 10, -100)
_BankHeader.Visible = false

_BankHeader:RegisterStateDriver("autohide", "[combat]hide;nohide")
_BankHeader:SetAttribute("_onstate-autohide", [[
	if newstate == "hide" then
		self:Hide()
	end
]])

--------------------------
-- Menu
--------------------------

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
btnAdd:SetPoint("BOTTOMLEFT", viewRuleTree, "TOPLEFT")
btnAdd:SetSize(32, 24)
btnAdd.Text = "+"
btnAdd.Style = "Classic"
btnAdd:ActiveThread("OnClick")
btnAdd.FrameStrata = "HIGH"

lblFitler = FontString("LabelFilter", viewRuleManager)
lblFitler:SetPoint("TOPLEFT", viewRuleTree, "TOPRIGHT", 4, 0)
lblFitler.Text = L"Tooltip Filter(Use ';' to seperate)"

htmlFilter = SingleTextBox("HtmlFilter", viewRuleManager)
htmlFilter:SetPoint("TOPLEFT", lblFitler, "BOTTOMLEFT")
htmlFilter.Height = 24
htmlFilter:SetPoint("RIGHT", -4, 0)

htmlRule = HTMLViewer("HtmlRule", viewRuleManager)
htmlRule:SetPoint("TOPLEFT", htmlFilter, "BOTTOMLEFT")
htmlRule:SetPoint("RIGHT", -4, 0)
htmlRule.Height = 100
htmlRule:ActiveThread("OnHyperlinkClick")
htmlRule:ActiveThread("OnReceiveDrag")
htmlRule.Visible = false
htmlRule:RegisterForDrag("LeftButton", "RightButton")

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