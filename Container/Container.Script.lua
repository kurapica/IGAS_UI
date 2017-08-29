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
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")

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

	self:SecureHook("UseContainerItem", "Hook_UseContainerItem")
	self:SecureHook("ContainerFrameItemButton_OnClick")
	self:SecureHook("ContainerFrameItemButton_OnModifiedClick")
	self:SecureHook("BuybackItem")
	self:SecureHook("BuyMerchantItem")

	self:SecureHook("OpenStackSplitFrame")

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

	-- Other settings
	_ToolSet = _ContainerDB.ToolSet or {
		AutoRepair = true,
		AutoRepairChkRep = 3,
		AutoSell = true,
		AutoSplit = true,
	}
	_ContainerDB.ToolSet = _ToolSet

	_CharContainerDB = _DBChar.ContainerDB or {
		DontSell = {},
		NeedSell = {},
	}
	_DBChar.ContainerDB = _CharContainerDB

	_ToolDontSell = _CharContainerDB.DontSell
	_ToolNeedSell = _CharContainerDB.NeedSell

	-- Location
	if _ContainerDB.Location then
		_ContainerHeader.Location = _ContainerDB.Location
	end

	if _ContainerDB.BankLocation then
		_BankHeader.Location = _ContainerDB.BankLocation
	end

	-- Scale
	if _ToolSet.Scale then
		_ContainerHeader:SetScale(_ToolSet.Scale)
		_BankHeader:SetScale(_ToolSet.Scale)
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

local _MERCHANT_SHOW = false

function MERCHANT_SHOW(self)
	_MERCHANT_SHOW = true

	if _ToolSet.AutoRepair then DoAutoRepair() end
	if _ToolSet.AutoSell then DoAutoSell() end
end

function MERCHANT_CLOSED(self)
	_MERCHANT_SHOW = false
end

-------------------------------
-- UI Handlers
-------------------------------
function headerMenu:OnShow()
	mnuAutoRepair.Checked = _ToolSet.AutoRepair
	_ListReputation.SelectedIndex = _ToolSet.AutoRepairChkRep

	mnuAutoSell.Checked = _ToolSet.AutoSell

	mnuAutoSplit.Checked = _ToolSet.AutoSplit

	mnuSetScale.Text = L"Scale" .. ":" .. (_ToolSet.Scale or 1)
end

function mnuAutoRepair:OnCheckChanged()
	_ToolSet.AutoRepair = self.Checked
end

function mnuSetScale:OnClick()
	local val = tonumber(IGAS:MsgBox(L"Please input the scale number [0.5-3]", "ic"))
	if val and val >= 0.5 and val <= 3 then
		_ToolSet.Scale = val
		mnuSetScale.Text = L"Scale" .. ":" .. (_ToolSet.Scale or 1)
		_ContainerHeader:SetScale(val)
		_BankHeader:SetScale(val)
	end
end

function _ListReputation:OnItemChoosed(key, item)
	_ToolSet.AutoRepairChkRep = self.SelectedIndex
end

function mnuAutoSell:OnCheckChanged()
	_ToolSet.AutoSell = self.Checked
end

function mnuAutoSplit:OnCheckChanged()
	_ToolSet.AutoSplit = self.Checked
end

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
			local cnode = { Text = containerRule.Name or L"Container" .. j, FunctionName = "R,X,+", Childs = {} }

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

		node = node:AddNode{ Text = name, FunctionName = "R,X,+" }

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
				if parent:GetNode(i).Text:match("^" .. L"Container" .. "%d+$") then
					parent:GetNode(i).Text = L"Container" .. i
				end
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
			node = node:AddNode{ Text = L"Container" .. (node.ChildNodeCount+1), FunctionName = "R,X,+" }
			return node:Select()
		elseif node.Level == 2 then
			node = node:AddNode{ Text = L"Rule" .. (node.ChildNodeCount+1), FunctionName = "X", Data = {} }
			return node:Select()
		end
	elseif func == "R" then
		local name = IGAS:MsgBox(node.Level == 1 and L["Please input the container view's name"]
			or node.Level == 2 and L["Please input the container's name"], "ic")

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

			if not cnode.Text:match("^" .. L"Container" .. "%d+$") then
				container.Name = cnode.Text
			else
				container.Name = nil
			end

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

function FormatMoney(money)
	if money >= 10000 then
		return (GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE):format(math.floor(money / 10000), 0, 0, math.floor(money % 10000 / 100), 0, 0, money % 100, 0, 0)
	elseif money >= 100 then
		return (SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE):format(math.floor(money % 10000 / 100), 0, 0, money % 100, 0, 0)
	else
		return (COPPER_AMOUNT_TEXTURE):format(money % 100, 0, 0)
	end
end

-------------------------------
-- Auto Repair
-------------------------------
function DoAutoRepair(self)
	if UnitReaction("target", "player") < _ToolSet.AutoRepairChkRep then return end

	local repairByGuild = false

	if not CanMerchantRepair() then return end

	repairAllCost, canRepair = GetRepairAllCost()

	if repairAllCost == 0 or not canRepair then return end

	--See if can guildbank repair
	if CanGuildBankRepair() then

		local guildName, _, guildRankIndex = GetGuildInfo("player")

		GuildControlSetRank(guildRankIndex)

		if GetGuildBankWithdrawGoldLimit()*10000 >= repairAllCost then
			repairByGuild = true
			RepairAllItems(1)
		else
			if repairAllCost > GetMoney() then
				return Warn(L["[AutoRepair] No enough money to repair."])
			end

			RepairAllItems()
		end
		PlaySound("ITEM_REPAIR")
	else
		if repairAllCost > GetMoney() then
			return Warn(L["[AutoRepair] No enough money to repair."])
		end

		RepairAllItems()
		PlaySound("ITEM_REPAIR")
	end

	Warn("-----------------------------")
	if repairByGuild then
		Info(L["[AutoRepair] Cost [Guild] %s."], FormatMoney(repairAllCost))
	else
		Info(L["[AutoRepair] Cost %s."], FormatMoney(repairAllCost))
	end
	Warn("-----------------------------")
end

-------------------------------
-- Auto Sell
-------------------------------
_SelledList = {}
_SelledCount = {}
_SelledMoney = {}

function DoAutoSell()
	wipe(_SelledList)
	wipe(_SelledCount)
	wipe(_SelledMoney)

	local selled = false

	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemId = GetContainerItemID(bag, slot)
			if itemId then
				local _, _, itemRarity, _, _, _, _, _, _, _, money = GetItemInfo(itemId)

				if money and money > 0 and (_ToolNeedSell[itemId] or (itemRarity == 0 and not _ToolDontSell[itemId])) then
					local _, count, _, _, _, _, link = GetContainerItemInfo(bag, slot)
					UseContainerItem(bag, slot)
					selled = true
					Add2List(link, count, money)
				end
			end
		end
	end

	if selled then
		Warn("-----------------------------")
		Info(L["[AutoSell] Item List:"])
		local money = 0
		for _, link in ipairs(_SelledList) do
			money = money + _SelledMoney[link]
			icon = select(10, GetItemInfo(link)) or ""

			if _SelledCount[link] > 1 then
				Info("\124T%s:0\124t %s (%d) => %s.", icon, link, _SelledCount[link], FormatMoney(_SelledMoney[link]))
			else
				Info("\124T%s:0\124t %s => %s.", icon, link, FormatMoney(_SelledMoney[link]))
			end
		end
		Info(L["[AutoSell] Total : %s."], FormatMoney(money))
		Warn(L["[AutoSell] Buy back item if you don't want auto sell it."])
		Warn(L["[AutoSell] Alt+Right-Click to mark item as auto sell."])
		Warn("-----------------------------")
	end
end

function Add2List(link, count, money)
	count = count or 1
	money = money * count

	if _SelledCount[link] then
		_SelledCount[link] = _SelledCount[link] + (count or 1)
		_SelledMoney[link] = _SelledMoney[link] + money
	else
		tinsert(_SelledList, link)
		_SelledCount[link] = count or 1
		_SelledMoney[link] = money
	end
end

function GetItemId(link)
	local _, link = GetItemInfo(link)
	if link then return tonumber(link:match":(%d+):") end
end

-------------------------------
-- Auto Sell
-------------------------------
function ContainerFrameItemButton_OnClick(self, button)
	if _MERCHANT_SHOW and _ToolSet.AutoSell and button == "RightButton" and IsModifiedClick("Alt") then
		local itemId = GetContainerItemID(self:GetParent():GetID(), self:GetID())

		if itemId then
			_ToolDontSell[itemId] = nil
			_ToolNeedSell[itemId] = true
			DoAutoSell()
		end
	end
end

function ContainerFrameItemButton_OnModifiedClick(self, button)
	if _MERCHANT_SHOW and _ToolSet.AutoSell and button == "RightButton" and IsModifiedClick("Alt") then
		local itemId = GetContainerItemID(self:GetParent():GetID(), self:GetID())

		if itemId then
			_ToolDontSell[itemId] = nil
			_ToolNeedSell[itemId] = true
			DoAutoSell()
		end
	elseif IsAltKeyDown() and button and button:upper() == "LEFTBUTTON" then
		local itemLink = GetContainerItemLink(self:GetParent():GetID(), self:GetID())
		if itemLink then
			local _, _, _, _, _, _, _, itemStackCount = GetItemInfo(itemLink)
			if itemStackCount > 1 then
				return Task.ThreadCall(StackItem, tonumber(itemLink:match":(%d+):"), itemStackCount)
			end
		end
	end
end

-------------------------------
-- Rollback auto sell
-------------------------------
function BuybackItem(index)
	local link = GetBuybackItemLink(index)

	if link then
		local itemId = GetItemId(link)

		if itemId then
			_ToolNeedSell[itemId] = nil
			local _, _, itemRarity = GetItemInfo(itemId)
			if itemRarity == 0 then
				_ToolDontSell[itemId] = true
			end
		end
	end
end

function BuyMerchantItem(index, quantity)
	local link = GetMerchantItemLink(index)

	if link then
		local itemId = GetItemId(link)

		if itemId then
			_ToolNeedSell[itemId] = nil
		end
	end
end

-------------------------------
-- Auto Split
-------------------------------
StackSplitFrame = _G.StackSplitFrame
StackSplitOkayButton = _G.StackSplitOkayButton
StackSplitCancelButton = _G.StackSplitCancelButton

StackSplitAllButton = CreateFrame("Button", "StackSplitAllButton", StackSplitFrame, "UIPanelButtonTemplate")
StackSplitAllButton:SetWidth(42)
StackSplitAllButton:SetHeight(24)
StackSplitAllButton:Hide()
StackSplitAllButton:SetPoint("CENTER", StackSplitFrame, "BOTTOM", 0, 32)
StackSplitAllButton:SetText(L"Auto")
StackSplitAllButton:SetScript("OnClick", function()
	if not InCombatLockdown() then
		local item = StackSplitFrame.owner
		local split = StackSplitFrame.split

	    StackSplitFrame:Hide()

	    if item then
	        return Task.ThreadCall(SplitItem, item:GetParent():GetID(), item:GetID(), split)
	    end
	end
end)

function OpenStackSplitFrame(maxStack, parent, anchor, anchorTo)
	if _ToolSet.AutoSplit and StackSplitFrame:IsShown() and not InCombatLockdown() then
		local bag = parent:GetParent() and parent:GetParent():GetID()
		if bag and bag >=0 and bag <= NUM_BAG_FRAMES then
			StackSplitOkayButton:SetWidth(40)
			StackSplitOkayButton:SetPoint("RIGHT", StackSplitFrame, "BOTTOM", -23, 32)
			StackSplitCancelButton:SetWidth(40)
			StackSplitCancelButton:SetPoint("LEFT", StackSplitFrame, "BOTTOM", 23, 32)

			StackSplitAllButton:Show()
		else
			StackSplitOkayButton:SetWidth(64)
			StackSplitOkayButton:SetPoint("RIGHT", StackSplitFrame, "BOTTOM", -3, 32)
			StackSplitCancelButton:SetWidth(64)
			StackSplitCancelButton:SetPoint("LEFT", StackSplitFrame, "BOTTOM", 5, 32)

			StackSplitAllButton:Hide()
		end
	end
end

StackSplitFrame:HookScript("OnHide", function(self)
	Task.NoCombatCall(function()
		if StackSplitAllButton:IsShown() then
			StackSplitOkayButton:SetWidth(64)
			StackSplitOkayButton:SetPoint("RIGHT", StackSplitFrame, "BOTTOM", -3, 32)
			StackSplitCancelButton:SetWidth(64)
			StackSplitCancelButton:SetPoint("LEFT", StackSplitFrame, "BOTTOM", 5, 32)

			StackSplitAllButton:Hide()
		end
	end)
end)

----------------------------------------
-- Stack
----------------------------------------
StackLoc = {}
ceil = math.ceil

function StackItem(itemId, itemStackCount)
	GetLocForStack(itemId, itemStackCount)

	if ceil(StackLoc.Sum / itemStackCount) < StackLoc["Cnt"] then
		while StackItemOnce(itemStackCount) do
			Task.Delay(1)
		end
	end
end

function StackItemOnce(itemStackCount)
	local start, last, chg = 1, StackLoc["Cnt"], false
	local _, esLink

	-- ReCount
	for i, v in ipairs(StackLoc) do
		esLink = GetContainerItemLink(v["bag"], v["slot"])
		if esLink then
			_, v["cnt"] = GetContainerItemInfo(v["bag"], v["slot"])
		else
			v["cnt"] = 0
		end
	end

	-- Stack main
	while start < last do
		if StackLoc[start]["cnt"] < itemStackCount then
			if StackLoc[last]["cnt"] > 0 then
				if StackLoc[last]["cnt"] + StackLoc[start]["cnt"] <= itemStackCount then
					PickupContainerItem(StackLoc[last]["bag"], StackLoc[last]["slot"])
					PickupContainerItem(StackLoc[start]["bag"], StackLoc[start]["slot"])
				else
					SplitContainerItem(StackLoc[last]["bag"], StackLoc[last]["slot"], itemStackCount - StackLoc[start]["cnt"])
					PickupContainerItem(StackLoc[start]["bag"], StackLoc[start]["slot"])
				end
				chg = true
				start = start + 1
				last = last - 1
			else
				last = last - 1
			end
		else
			start = start + 1
		end
	end

	return chg
end

function GetLocForStack(itemId, itemStackCount)
    local shdCnt = 0
    StackLoc.Sum = 0

	for bag = NUM_BAG_FRAMES,0,-1 do
		for slot = GetContainerNumSlots(bag),1,-1 do
			local esLink = GetContainerItemLink(bag, slot)

			if esLink then
				if tonumber(esLink:match":(%d+):") == itemId then
					local _, itemCount = GetContainerItemInfo(bag, slot)
					if itemCount < itemStackCount then
						shdCnt = shdCnt + 1
						if not StackLoc[shdCnt] then
							StackLoc[shdCnt]= {}
						end
						StackLoc[shdCnt]["bag"] = bag
						StackLoc[shdCnt]["slot"] = slot
						StackLoc[shdCnt]["cnt"] = itemCount

						StackLoc.Sum = StackLoc.Sum + itemCount
					end
				end
			end
		end
	end

    StackLoc["Cnt"] = shdCnt
    shdCnt = shdCnt + 1
    StackLoc[shdCnt] = nil

	-- Sort
	SortStack()
end

function SortStack()
	local chg = false

	for i, v in ipairs(StackLoc) do
		if StackLoc[i+1] then
			if StackLoc[i]["cnt"] < StackLoc[i+1]["cnt"] then
				chg = true
				StackLoc[i+1], StackLoc[i] = StackLoc[i], StackLoc[i+1]
			end
		end
	end

	if chg then
		return SortStack()
	end
end

----------------------------------------
-- Split
----------------------------------------
FreeLoc = {}

function GetFreeLocForSplit(Cnt)
    local shdCnt = 0

	for bag = NUM_BAG_FRAMES,0,-1 do
		for slot = GetContainerNumSlots(bag),1,-1 do
			if shdCnt >= Cnt then
				break
			end

			esLink = GetContainerItemLink(bag,slot)
			if not esLink then
				shdCnt = shdCnt + 1
				if not FreeLoc[shdCnt] then
					FreeLoc[shdCnt]= {}
				end
				FreeLoc[shdCnt]["bag"] = bag
				FreeLoc[shdCnt]["slot"] = slot
				FreeLoc[shdCnt]["used"] = false
			end
		end
	end

    FreeLoc["Cnt"] = shdCnt
    shdCnt = shdCnt + 1
    FreeLoc[shdCnt] = nil
end

function GetFree()
    for _, loc in ipairs(FreeLoc) do
        if not loc["used"] then
            loc["used"] = true
            return loc
        end
    end
    return nil
end

function SplitItem(bag, slot, num)
    local _, itemCount = GetContainerItemInfo(bag, slot)
    local loc

    if itemCount > num and num > 0 then
        GetFreeLocForSplit(math.ceil(itemCount/num))

        while itemCount > num do
        	loc = GetFree()

        	if not loc then return end

			SplitContainerItem(bag, slot, num)
			PickupContainerItem(loc["bag"], loc["slot"])

        	Task.Delay(1)	-- Seep safe, wait for 1 sec

        	_, itemCount = GetContainerItemInfo(bag, slot)
        end

        Info(L"[AutoSplit] You also can use Alt+Left-Click to push items together.")
    end
end