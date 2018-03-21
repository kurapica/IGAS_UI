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

mnuShowTokenList = headerMenu:AddMenuButton(L"Show the token watch list")

mnuSetScale = headerMenu:AddMenuButton(L"Scale")
mnuSetScale:ActiveThread("OnClick")

mnuAutoRepair = headerMenu:AddMenuButton(L"Auto Repair", L"Auto Repair")
mnuAutoRepair.IsCheckButton = true

mnuAutoRepairChkRep = headerMenu:AddMenuButton(L"Auto Repair", L"Check Reputation")
_ListReputation = List("LstReputation", mnuAutoRepairChkRep)
_ListReputation:SetList({
	_G["FACTION_STANDING_LABEL"..1],
	_G["FACTION_STANDING_LABEL"..2],
	_G["FACTION_STANDING_LABEL"..3],
	_G["FACTION_STANDING_LABEL"..4],
	_G["FACTION_STANDING_LABEL"..5],
	_G["FACTION_STANDING_LABEL"..6],
	_G["FACTION_STANDING_LABEL"..7],
	_G["FACTION_STANDING_LABEL"..8],
})
_ListReputation.Width = 150
_ListReputation.Height = 250
_ListReputation.Visible = false
mnuAutoRepairChkRep.DropDownList = _ListReputation

mnuAutoSell = headerMenu:AddMenuButton(L"Auto Sell")
mnuAutoSell.IsCheckButton = true

mnuAutoSplit = headerMenu:AddMenuButton(L"Auto Split")
mnuAutoSplit.IsCheckButton = true

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
_ToggleButton.OpenBag = function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end
_ToggleButton.CloseBag = function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end

--SetOverrideBindingClick(_ToggleButton, true, GetBindingKey("OPENALLBAGS") or "B", "IGAS_UI_ContainerToggle", "LeftButton")
--SetOverrideBindingClick(_ToggleButton, true, "SHIFT-" .. (GetBindingKey("OPENALLBAGS") or "B"), "IGAS_UI_ContainerToggle", "LeftButton")

_ContainerHeader:SetFrameRef("ToggleButton", _ToggleButton)
_ContainerHeader:RegisterStateDriver("autobind", "[combat]enable;disable")
_ContainerHeader:SetAttribute("_onstate-autobind", [[
	self:SetAttribute("autobindescape", newstate == "enable")
	if newstate == "enable" and self:IsShown() then
		self:GetFrameRef("ToggleButton"):SetBindingClick(true, "ESCAPE", "IGAS_UI_ContainerToggle", "LeftButton")
	else
		self:GetFrameRef("ToggleButton"):ClearBinding("ESCAPE")
	end
]])
_ContainerHeader:SetAttribute("_onshow", [[
	if self:GetAttribute("autobindescape") then
		self:GetFrameRef("ToggleButton"):SetBindingClick(true, "ESCAPE", "IGAS_UI_ContainerToggle", "LeftButton")
	end
]])
_ContainerHeader:SetAttribute("_onhide", [[
	self:GetFrameRef("ToggleButton"):ClearBinding("ESCAPE")
]])

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

--------------------------
-- Token Watch List
--------------------------
tokenWatchManager = Form("IGAS_UI_ContainerTokenWatchManager")
tokenWatchManager.Visible = false
tokenWatchManager:SetSize(510, 400)
tokenWatchManager.Caption = L"Token Watch List Manager"
tokenWatchManager.Resizable = false
tokenWatchManager.Message = L"Double click to add or remove token"

tokenWatchTree = TreeView("TokenTree", tokenWatchManager)
tokenWatchTree:SetPoint("TOPLEFT", 4, -26)
tokenWatchTree:SetPoint("BOTTOMLEFT", 4, 32)
tokenWatchTree.Width = 250
tokenWatchTree.Style = "Classic"

tokenWatchList = List("TokenList", tokenWatchManager)
tokenWatchList:SetPoint("TOPLEFT", tokenWatchTree, "TOPRIGHT")
tokenWatchList:SetPoint("BOTTOMRIGHT", -4, 32)