-----------------------------------------
-- Script for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

Toggle = {
	Message = L"Lock Container Frame",
	Get = function()
		return not _ContainerHeader.Mask.Visible
	end,
	Set = function (value)
		if value then
			_ContainerHeader.Mask.Visible = false
			_BankHeader.Mask.Visible = false
		elseif not InCombatLockdown() then
			_ContainerHeader.Mask.Visible = true
			_BankHeader.Mask.Visible = true
		end
	end,
	Update = function() end,
}

_DefaultContainerConfig = {
	Name = _G.BACKPACK_TOOLTIP,
	ContainerRules = {
		{ {100001} }, -- Any
	},
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
	if not v.BankOnly then
		local text = "<p>"
		text = text .. HTML_HREF_TEMPLATE:format(-v.ID, L"[not]")
		text = text .. HTML_HREF_TEMPLATE:format(v.ID, "[" .. v.Name .. "]")
		text = text .. " - " .. v.Desc .. "</p><br/>"

		tinsert(conditions, text)
	end
end

local cndContainerHtml = HTML_TEMPLATE:format(table.concat( conditions, ""))

conditions = {}
for i, v in ipairs(_ItemConditions) do
	if not v.BagOnly then
		local text = "<p>"
		text = text .. HTML_HREF_TEMPLATE:format(-v.ID, L"[not]")
		text = text .. HTML_HREF_TEMPLATE:format(v.ID, "[" .. v.Name .. "]")
		text = text .. " - " .. v.Desc .. "</p><br/>"

		tinsert(conditions, text)
	end
end

local cndBankHtml = HTML_TEMPLATE:format(table.concat( conditions, ""))
conditions = nil

-------------------------------
-- Event Handlers
-------------------------------
function OnLoad(self)
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	for i = 1, 13 do
		if _G["ContainerFrame" .. i] then
			_G["ContainerFrame" .. i]:UnregisterAllEvents()
		end
	end

	BankFrame:UnregisterAllEvents()
	BankSlotsFrame:UnregisterAllEvents()
	ReagentBankFrame:UnregisterAllEvents()

	self:SecureHook("OpenAllBags")
	self:SecureHook("CloseAllBags")

	-- DB
	if _DB.ContainerDB and (not _DB.ContainerDB.SaveFormatVer or _DB.ContainerDB.SaveFormatVer < 1) then
		_DB.ContainerDB = nil
	end
	_ContainerDB = _DB.ContainerDB or {
		SaveFormatVer = 1,
		ViewConfigs = {
			{
				Name = L"Default",
				ContainerRules = {
					{ {100002} }, -- Backpack
					{ {100003} }, -- Container1
					{ {100004} }, -- Container2
					{ {100005} }, -- Container3
					{ {100006} }, -- Container4
				},
			},
		},
	}
	_DB.ContainerDB = _ContainerDB

	-- Bank Config
	_ContainerDB.BankViewConfigs = _ContainerDB.BankViewConfigs or {
		{
			Name = L"Default",
			ContainerRules = {
				{ {-110002} },
			},
		},
		{
			Name = L"Reagent",
			ContainerRules = {
				{ {110002} }, -- ReagentBank
			},
		},
	}

	-- Location
	if _ContainerDB.Location then
		_ContainerHeader.Location = _ContainerDB.Location
	end

	if _ContainerDB.BankLocation then
		_BankHeader.Location = _ContainerDB.BankLocation
	end
end

function OnEnable(self)
	local configs = System.Reflector.Clone(_ContainerDB.ViewConfigs)
	tinsert(configs, 1, _DefaultContainerConfig)

	_ContainerHeader:ApplyConfig(configs)

	_ContainerHeader.Element[1].ContainerView:Show()
	_ContainerHeader.Element[1]:SetAttribute("viewactive", true)
	_ContainerHeader.Element[1].ContainerView.LoadInstant = true
	_ContainerHeader.Element[1].ContainerView:StartRefresh()

	Task.ThreadCall(function()
		local i = 1

		while i <= _ContainerHeader.Count do
			Task.Delay(10)

			if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
			while InCombatLockdown() do Task.Delay(0.1) end

			while i <= _ContainerHeader.Count and _ContainerHeader.Element[i].ContainerView.TaskMark do
				i = i + 1
			end

			if i <= _ContainerHeader.Count then
				Debug("[Container]Wakeup container %d", i)

				_ContainerHeader.Element[i].ContainerView:StartRefresh()
			end

			i = i + 1
		end

		Debug("[Container]Auto wakeup finished")
	end)

	_BankHeader:ApplyConfig(_ContainerDB.BankViewConfigs)

	if _ContainerDB.SelectedBankView then
		for i = 1, _BankHeader.Count do
			if _BankHeader.Element[i].Text == _ContainerDB.SelectedBankView then
				_BankHeader.Element[i].ContainerView:Show()
				_BankHeader.Element[i]:SetAttribute("viewactive", true)
				break
			end
		end
	end

	tinsert(UISpecialFrames,"IGAS_UI_ContainerHeader")
	tinsert(UISpecialFrames,"IGAS_UI_BankHeader")

	-- Token List
	if not _ContainerDB.TokenWatchList then
		local tbl = {}
		for i = 1, GetCurrencyListSize() do
			local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(i)
			if isHeader and i > 1 then break end
			if not isHeader then
				tbl[name] = true
			end
		end
		_ContainerDB.TokenWatchList = tbl
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
		if _BankHeader.Visible then
			CloseBankFrame()
			_BankHeader.Visible = false
		end
	end
end

function PLAYER_REGEN_DISABLED(self)
	viewRuleManager.Visible = false

	if _ContainerHeader.Mask.Visible then
		_ContainerHeader.Mask.Visible = false
		_BankHeader.Mask.Visible = false

		_ContainerHeader:StopMovingOrSizing()
		_ContainerHeader.Movable = false

		_BankHeader:StopMovingOrSizing()
		_BankHeader.Movable = false
	end
end

function BANKFRAME_OPENED(self)
	if not InCombatLockdown() then
		_BankHeader.Visible = true
	end
end

function BANKFRAME_CLOSED(self)
	if not InCombatLockdown() then
		_BankHeader.Visible = false
	end
end

function PLAYER_LEVEL_UP(self)
	for i = 1, _ContainerHeader.Count do
		local view = _ContainerHeader.Element[i].ContainerView

		local j = 1
		while view:GetChild(view.ElementPrefix .. j) do
			view:GetChild(view.ElementPrefix .. j):Each("UpdateAction")
			j = j + 1
		end
	end
end

-------------------------------
-- UI Handlers
-------------------------------
function _ContainerHeader.Mask:OnShow()
	Toggle.Update()
end

function _ContainerHeader.Mask:OnHide()
	Toggle.Update()
end

function mnuShowRuleManager:OnClick()
	viewRuleManager.Visible = true
end

function _ContainerHeader.Mask:OnMoveFinished()
	_ContainerDB.Location = _ContainerHeader.Location
end

function _BankHeader.Mask:OnMoveFinished()
	_ContainerDB.BankLocation = _BankHeader.Location
end

function _BankHeader:OnHide()
	if not InCombatLockdown() then
		CloseBankFrame()
	end
end

function mnuModifyAnchor:OnClick()
	if headerMenu.Header == _ContainerHeader then
		IGAS:ManageAnchorPoint(_ContainerHeader, nil, true)

		_ContainerDB.Location = _ContainerHeader.Location
	else
		IGAS:ManageAnchorPoint(_BankHeader, nil, true)

		_ContainerDB.Location = _BankHeader.Location
	end
end

function viewRuleManager:OnShow()
	htmlRule.Text = ""
	htmlFilter.Text = ""

	local tree = {}
	local viewconfigs = headerMenu.Header == _ContainerHeader and _ContainerDB.ViewConfigs or
						headerMenu.Header == _BankHeader and _ContainerDB.BankViewConfigs

	if not viewconfigs then return self:Hide() end

	for i, config in ipairs(viewconfigs) do
		local node = { Text = config.Name, FunctionName = "R,X,+", Childs = {}, Data = System.Reflector.Clone(config.ItemList) }
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
	lblFitler.Visible = false
	htmlFilter.Visible = false
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
				if self.SelectedNode and self.SelectedNode.Level == 3 and self.SelectedNode.Parent.Parent == node then
					self.SelectedNode = nil
					viewRuleTree:OnNodeSelected(nil)
				end

				node:Dispose()
			end
		elseif node.Level == 2 then
			local index = node.Index
			local parent = node.Parent
			if IGAS:MsgBox(L"Do you want delete the container?", "n") then
				if self.SelectedNode and self.SelectedNode.Level == 3 and self.SelectedNode.Parent == node then
					self.SelectedNode = nil
					viewRuleTree:OnNodeSelected(nil)
				end

				node:Dispose()
			end
			for i = index, parent.ChildNodeCount do
				parent:GetNode(i).Text = L"Container" .. i
			end
		elseif node.Level == 3 then
			local index = node.Index
			local parent = node.Parent
			if IGAS:MsgBox(L"Do you want delete the contianer rule?", "n") then
				if self.SelectedNode and self.SelectedNode == node then
					self.SelectedNode = nil
					viewRuleTree:OnNodeSelected(nil)
				end

				node:Dispose()
			end
			for i = index, parent.ChildNodeCount do
				parent:GetNode(i).Text = L"Rule" .. i
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
	elseif func == "R" then
		local name = IGAS:MsgBox(L["Please input the container view's name"], "ic")

		if type(name) == "string" then
			name = strtrim(name)

			local cnode = viewRuleTree

			for i = 1, cnode.ChildNodeCount do
				if cnode:GetNode(i).Text == name then
					return cnode:GetNode(i):Select()
				end
			end

			node.Text = name
		end
	end
end

function viewRuleTree:OnNodeSelected(node)
	if node and node.Level == 3 then
		htmlCondition.Visible = true
		lblFitler.Visible = true
		htmlFilter.Visible = true
		htmlRule.Visible = true
		htmlRule.Height = 100
		htmlRule.Node = node
		htmlRule.Text = buildResult(node.MetaData.Data)
		htmlFilter.Text = node.MetaData.Data.TooltipFilter or ""
		viewRuleManager.Message = ""
	elseif node and node.Level == 1 then
		viewRuleManager.Message = L"Drag item to the right panel"
		htmlCondition.Visible = false
		lblFitler.Visible = false
		htmlFilter.Visible = false
		htmlRule.Visible = true
		htmlRule.Height = viewRuleTree.Height - 40
		htmlRule.Node = node
		htmlRule.Text = buildItemList(node.MetaData.Data)
	else
		viewRuleManager.Message = ""
		lblFitler.Visible = false
		htmlFilter.Visible = false
		htmlCondition.Visible = false
		htmlRule.Visible = false
		htmlRule.Node = nil
		htmlRule.Text = ""
	end
end

function htmlCondition:OnShow()
	if headerMenu.Header == _ContainerHeader then
		self.Text = cndContainerHtml
	elseif headerMenu.Header == _BankHeader then
		self.Text = cndBankHtml
	end
end

function htmlRule:OnReceiveDrag()
	local type, index, subType, data = GetCursorInfo()

	if type == "item" and tonumber(index) then
		Debug("Receive item %s", index)

		if self.Node.Level == 1 then
			data = self.Node.MetaData.Data or {}
			self.Node.MetaData.Data = data

			data[tonumber(index)] = true

			Task.Next()
			self.Text = buildItemList(data)
		end

		ClearCursor()
	end
end

function htmlRule:OnHyperlinkClick(v)
	Debug("Remove condition %s", v)

	v = tonumber(v)

	if self.Node.Level == 1 then
		self.Node.MetaData.Data[v] = nil

		Task.Next()
		htmlRule.Text = buildItemList(self.Node.MetaData.Data)
	elseif self.Node.Level == 3 then
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
end

function htmlCondition:OnHyperlinkClick(v)
	Debug("Add condition %s", v)

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

function htmlRule:OnHyperlinkEnter(v)
	if self.Node.Level == 1 then
		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		_G.GameTooltip:SetHyperlink(select(2, GetItemInfo(v)))
		_G.GameTooltip:Show()
	end
end

function htmlRule:OnHyperlinkLeave(v)
	_G.GameTooltip:Hide()
end

function htmlFilter:OnTextChanged(isUserInput)
	if self.Visible and isUserInput and htmlRule.Node then
		local txt = strtrim(htmlFilter.Text)
		if txt ~= "" then
			htmlRule.Node.MetaData.Data.TooltipFilter = txt
		else
			htmlRule.Node.MetaData.Data.TooltipFilter = nil
		end
	end
end

function btnApply:OnClick()
	local config = {}

	for i = 1, viewRuleTree.ChildNodeCount do
		local view = {}
		local node = viewRuleTree:GetNode(i)

		view.Name = node.Text
		view.ContainerRules = {}
		view.ItemList = node.MetaData.Data

		for j = 1, node.ChildNodeCount do
			local container = {}
			local cnode = node:GetNode(j)

			for k = 1, cnode.ChildNodeCount do
				local rnode = cnode:GetNode(k)
				local rule = rnode.MetaData.Data

				if rule and (#rule > 0 or rule.TooltipFilter) then
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

	if headerMenu.Header == _ContainerHeader then
		_ContainerDB.ViewConfigs = config

		local configs = System.Reflector.Clone(_ContainerDB.ViewConfigs)
		tinsert(configs, 1, _DefaultContainerConfig)

		_ContainerHeader:ApplyConfig(configs, true)
	elseif headerMenu.Header == _BankHeader then
		_ContainerDB.BankViewConfigs = config
		_BankHeader:ApplyConfig(config, true)
	end
end

function mnuShowTokenList:OnClick()
	tokenWatchManager.Visible = not tokenWatchManager.Visible
end

function tokenWatchManager:OnShow()
	local tree = {}
	local header
	for i = 1, GetCurrencyListSize() do
		local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(i)

		if isHeader then
			header = { Text = name, Childs = {} }
			tinsert(tree, header)
		elseif header then
			tinsert(header.Childs, { Text = name })
		end
	end

	tokenWatchTree:SetTree(tree)

	tokenWatchList:Clear()
	for name in pairs(_ContainerDB.TokenWatchList) do
		tokenWatchList:AddItem(name, name)
	end
end

function tokenWatchTree:OnDoubleClick(node)
	if node.Level == 2 then
		local name = node.Text
		if not _ContainerDB.TokenWatchList[name] then
			_ContainerDB.TokenWatchList[name] = true
			tokenWatchList:AddItem(name, name)
		end
	end
end

function tokenWatchList:OnItemDoubleClick(key)
	tokenWatchList:RemoveItem(key)
	_ContainerDB.TokenWatchList[key] = nil
end

-------------------------------
-- Helper
-------------------------------
function buildResult(data)
	local text = {}
	if data and #data > 0 then
		for i, cnd in ipairs(data) do
			if _ItemConditions[math.abs(cnd)] then
				if cnd < 0 then
					tinsert(text, HTML_HREF_TEMPLATE:format(cnd, L"[not]" .. "[" .. (_ItemConditions[math.abs(cnd)].Name) .. "]"))
				else
					tinsert(text, HTML_HREF_TEMPLATE:format(cnd, "[" .. (_ItemConditions[cnd].Name) .. "]"))
				end
			end
		end
	end
	return HTML_TEMPLATE:format(HTML_RESULT:format(table.concat( text, L" and " )))
end

function buildItemList(itemlist)
	local text = {}
	if itemlist then
		for item in pairs(itemlist) do
			local name, link, quality = GetItemInfo(item)
			if not name then
				name, link, quality = GetItemInfo(item)
			end
			if name then
				tinsert(text, HTML_HREF_TEMPLATE:format(item, BAG_ITEM_QUALITY_COLORS[quality].code .. "[" .. GetItemInfo(item) .. "]" .. FontColor.CLOSE ))
			end
		end
	end
	return HTML_TEMPLATE:format(HTML_RESULT:format(table.concat( text, ", " )))
end