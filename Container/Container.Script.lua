-----------------------------------------
-- Script for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

Toggle = {
	Message = L"Lock Container Frame",
	Get = function()
		return not containerFrameMask.Visible
	end,
	Set = function (value)
		if value then
			containerFrameMask.Visible = false
		elseif not InCombatLockdown() then
			containerFrameMask.Visible = true
		end
	end,
	Update = function() end,
}

HTML_TEMPLATE = [[
<html>
<body>
%s
</body>
</html>
]]

HTML_HREF_TEMPLATE = [[<a href="%s">%s</a>]]

HTML_RESULT = [[
<p>%s</p>
]]

local conditions = {}
for i, v in ipairs(_ItemConditions) do
	local text = "<p>"
	text = text .. HTML_HREF_TEMPLATE:format(-i, L"[not]")
	text = text .. HTML_HREF_TEMPLATE:format(i, "[" .. v.Name .. "]")
	text = text .. " - " .. v.Desc .. "</p><br/>"

	tinsert(conditions, text)
end

local conditionHtml = HTML_TEMPLATE:format(table.concat( conditions, ""))
conditions = nil

-------------------------------
-- Event Handlers
-------------------------------
function OnLoad(self)
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	for i = 1, 13 do
		if _G["ContainerFrame" .. i] then
			_G["ContainerFrame" .. i]:UnregisterAllEvents()
		end
	end

	self:SecureHook("OpenAllBags")
	self:SecureHook("CloseAllBags")

	-- DB
	-- _DB.ContainerDB = nil
	_ContainerDB = _DB.ContainerDB or {
		ViewConfigs = {
			{
				Name = L"Default",
				ContainerRules = {
					{ {2} }, -- Backpack
					{ {3} }, -- Container1
					{ {4} }, -- Container2
					{ {5} }, -- Container3
					{ {6} }, -- Container4
				},
			},
			{
				Name = L"All-In-One",
				ContainerRules = {
					{ {1} }, -- Any
				},
			},
		}
	}
	_DB.ContainerDB = _ContainerDB

	-- Location
	if _ContainerDB.Location then
		_ContainerHeader.Location = _ContainerDB.Location
	end
end

function OnEnable(self)
	_ContainerHeader:ApplyConfig(_ContainerDB.ViewConfigs)

	-- Open View
	if _ContainerDB.SelectedView then
		for i = 1, _ContainerHeader.Count do
			if _ContainerHeader.Element[i].Text == _ContainerDB.SelectedView then
				_ContainerHeader.Element[i].ContainerView:Show()
				_ContainerHeader.Element[i]:SetAttribute("viewactive", true)
				break
			end
		end
	end
end

function OpenAllBags()
	if not InCombatLockdown() then
		CloseBackpack();
		for i=1, NUM_BAG_FRAMES, 1 do
			CloseBag(i);
		end
		_ContainerHeader.Visible = true
	end
end

function CloseAllBags()
	if not InCombatLockdown() then
		_ContainerHeader.Visible = false
	end
end

function PLAYER_REGEN_DISABLED(self)
	btnSetting.Visible = false
	viewRuleManager.Visible = false

	if containerFrameMask.Visible then
		containerFrameMask.Visible = false

		_ContainerHeader:StopMovingOrSizing()
		_ContainerHeader.Movable = false
	end
end

function PLAYER_REGEN_ENABLED(self)
	btnSetting.Visible = true
end

-------------------------------
-- UI Handlers
-------------------------------
function containerFrameMask:OnShow()
	Toggle.Update()
end

function containerFrameMask:OnHide()
	Toggle.Update()
end

function btnSetting:OnClick()
	if not InCombatLockdown() then
		containerConfig.Visible = true
	end
end

function mnuShowRuleManager:OnClick()
	viewRuleManager.Visible = true
end

function containerFrameMask:OnMoveFinished()
	_ContainerDB.Location = _ContainerHeader.Location
end

function mnuModifyAnchor:OnClick()
	IGAS:ManageAnchorPoint(_ContainerHeader, nil, true)

	_ContainerDB.Location = _ContainerHeader.Location
end

function viewRuleManager:OnShow()
	htmlRule.Text = ""

	local tree = {}

	for i, config in ipairs(_ContainerDB.ViewConfigs) do
		local node = { Text = config.Name, FunctionName = "X,+", Childs = {} }
		for j, containerRule in ipairs(config.ContainerRules) do
			local cnode = { Text = L"Container" .. j, FunctionName = "X,+", Childs = {} }

			for k, rules in ipairs(containerRule) do
				local rnode = { Text = L"Rule" .. k, FunctionName = "X", Data = System.Reflector.Clone(rules) }
				tinsert(cnode.Childs, rnode)
			end

			tinsert(node.Childs, cnode)
		end

		tinsert(tree, node)
	end

	viewRuleTree:SetTree(tree)
end

function viewRuleManager:OnHide()
	viewRuleTree:SetTree(nil)
	htmlRule.Visible = false
	htmlCondition.Visible = false
end

function btnAdd:OnClick()
	local name = IGAS:MsgBox(L["Please input the container view's name"], "ic")

	if type(name) == "string" then
		name = strtrim(name)

		local node = viewRuleTree

		for i = 1, node.ChildNodeCount do
			if node:GetNode(i).Text == name then
				return node:GetNode(i):Select()
			end
		end

		node = node:AddNode{ Text = name, FunctionName = "X,+" }

		return node:Select()
	end
end

function viewRuleTree:OnNodeFunctionClick(func, node)
	if func == "X" then
		if node.Level == 1 then
			if IGAS:MsgBox(L"Do you want delete the container view?", "n") then
				node:Dispose()
			end
		elseif node.Level == 2 then
			if IGAS:MsgBox(L"Do you want delete the container?", "n") then
				node:Dispose()
			end
		elseif node.Level == 3 then
			if IGAS:MsgBox(L"Do you want delete the contianer rule?", "n") then
				node:Dispose()
			end
		end
	elseif func == "+" then
		if node.Level == 1 then
			node = node:AddNode{ Text = L"Container" .. (node.ChildNodeCount+1), FunctionName = "X,+" }
			return node:Select()
		elseif node.Level == 2 then
			node = node:AddNode{ Text = L"Rule" .. (node.ChildNodeCount+1), FunctionName = "X", Data = {} }
			return node:Select()
		end
	end
end

function viewRuleTree:OnNodeSelected(node)
	if node.Level == 3 then
		htmlCondition.Visible = true
		htmlRule.Visible = true
		htmlRule.Node = node
		htmlRule.Text = buildResult(node.MetaData.Data)
	else
		htmlCondition.Visible = false
		htmlRule.Visible = false
	end
end

function htmlCondition:OnShow()
	self.Text = conditionHtml
end

function htmlRule:OnHyperlinkClick(v)
	v = tonumber(v)
	local data = self.Node.MetaData.Data
	for i, j in ipairs(data) do
		if j == v then
			tremove(data, i)
			Task.Next()
			htmlRule.Text = buildResult(data)
			return
		end
	end
end

function htmlCondition:OnHyperlinkClick(v)
	v = tonumber(v)
	local data = htmlRule.Node.MetaData.Data

	for i, j in ipairs(data) do
		if j == v then
			return
		end
	end
	tinsert(data, v)
	htmlRule.Text = buildResult(data)
end

function btnApply:OnClick()
	local config = {}

	for i = 1, viewRuleTree.ChildNodeCount do
		local view = {}
		local node = viewRuleTree:GetNode(i)

		view.Name = node.Text
		view.ContainerRules = {}

		for j = 1, node.ChildNodeCount do
			local container = {}
			local cnode = node:GetNode(j)

			for k = 1, cnode.ChildNodeCount do
				local rnode = cnode:GetNode(k)
				local rule = rnode.MetaData.Data

				if rule and #rule > 0 then
					tinsert(container, rule)
				end
			end

			if #container > 0 then
				tinsert(view.ContainerRules, container)
			end
		end

		if #view.ContainerRules > 0 then
			tinsert(config, view)
		end
	end

	viewRuleManager.Visible = false

	_ContainerDB.ViewConfigs = config
	_ContainerHeader:ApplyConfig(config)
end

-------------------------------
-- Helper
-------------------------------
function buildResult(data)
	local text = {}
	if data and #data > 0 then
		for i, cnd in ipairs(data) do
			if cnd < 0 then
				tinsert(text, HTML_HREF_TEMPLATE:format(cnd, L"[not]" .. "[" .. (_ItemConditions[math.abs(cnd)].Name) .. "]"))
			else
				tinsert(text, HTML_HREF_TEMPLATE:format(cnd, "[" .. (_ItemConditions[cnd].Name) .. "]"))
			end
		end
	end
	return HTML_TEMPLATE:format(HTML_RESULT:format(table.concat( text, L" and " )))
end