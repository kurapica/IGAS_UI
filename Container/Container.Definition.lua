-----------------------------------------
-- Definition for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

import "System"
import "System.Widget"
import "System.Widget.Action"

BANK_CONTAINER = _G.BANK_CONTAINER
REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS
BAG_ITEM_QUALITY_COLORS = System.Reflector.Clone(BAG_ITEM_QUALITY_COLORS, true)
LE_ITEM_QUALITY_COMMON = _G.LE_ITEM_QUALITY_COMMON
for i, v in ipairs(BAG_ITEM_QUALITY_COLORS) do
	BAG_ITEM_QUALITY_COLORS[i] = ColorType(v)
end
BAG_ITEM_QUALITY_COLORS[0] = ColorType(0.4, 0.4, 0.4)
BAG_ITEM_QUALITY_COLORS[1] = ColorType(1, 1, 1)

_GameTooltip = CreateFrame("GameTooltip", "IGAS_UI_Container_Tooltip", UIParent, "GameTooltipTemplate")

_Backdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	tile = true, tileSize = 16, edgeSize = 1,
}
_BackColor = ColorType(0, 0, 0, 1)

-- Item Conditions
_ItemConditions = {
	{
		ID = 100000,
		Name = L"InItemList",
		Desc = L"The slot has item, and the item is in the list (choose the view to show the item list panel, drag the item to it will add the item, click the link in the panel will remove it)",
		Condition = "(itemID and itemList[itemID])",
	},
	{
		ID = 100001,
		Name = L"Any",
		Desc = L"No check, you should only use this for the last container of one view",
		Condition = "true",
	},
	{
		ID = 100002,
		BagOnly = true,
		Name = L"Backpack",
		Desc = L"The slot is in the backpack",
		Condition = "(bag == 0)",
		RequireBag = { 0 },
		DenyBag = { 1, 2, 3, 4 },
	},
	{
		ID = 100003,
		BagOnly = true,
		Name = L"Container1",
		Desc = L"The slot is in the 1st container(from the right)",
		Condition = "(bag == 1)",
		RequireBag = { 1 },
		DenyBag = { 0, 2, 3, 4 },
	},
	{
		ID = 100004,
		BagOnly = true,
		Name = L"Container2",
		Desc = L"The slot is in the 2nd container(from the right)",
		Condition = "(bag == 2)",
		RequireBag = { 2 },
		DenyBag = { 0, 1, 3, 4 },
	},
	{
		ID = 100005,
		BagOnly = true,
		Name = L"Container3",
		Desc = L"The slot is in the 3rd container(from the right)",
		Condition = "(bag == 3)",
		RequireBag = { 3 },
		DenyBag = { 0, 1, 2, 4 },
	},
	{
		ID = 100006,
		BagOnly = true,
		Name = L"Container4",
		Desc = L"The slot is in the 4th container(from the right)",
		Condition = "(bag == 4)",
		RequireBag = { 4 },
		DenyBag = { 0, 1, 2, 3 },
	},
	{
		ID = 110001,
		BankOnly = true,
		Name = L"Bank",
		Desc = L"The slot is in the bank",
		Condition = ("(bag == %d)"):format(_G.BANK_CONTAINER),
		RequireBag = { _G.BANK_CONTAINER },
		DenyBag = { _G.REAGENTBANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11 },
	},
	{
		ID = 110002,
		BankOnly = true,
		Name = L"ReagentBank",
		Desc = L"The slot is in the reagent bank",
		Condition = ("(bag == %d)"):format(_G.REAGENTBANK_CONTAINER),
		RequireBag = { _G.REAGENTBANK_CONTAINER },
		DenyBag = { _G.BANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11 },
	},
	{
		ID = 110003,
		BankOnly = true,
		Name = L"BankBag1",
		Desc = L"The slot is in the 1st bank bag",
		Condition = "(bag == 5)",
		RequireBag = { 5 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 6, 7, 8, 9, 10, 11 },
	},
	{
		ID = 110004,
		BankOnly = true,
		Name = L"BankBag2",
		Desc = L"The slot is in the 2nd bank bag",
		Condition = "(bag == 6)",
		RequireBag = { 6 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 7, 8, 9, 10, 11 },
	},
	{
		ID = 110005,
		BankOnly = true,
		Name = L"BankBag3",
		Desc = L"The slot is in the 3rd bank bag",
		Condition = "(bag == 7)",
		RequireBag = { 7 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 6, 8, 9, 10, 11 },
	},
	{
		ID = 110006,
		BankOnly = true,
		Name = L"BankBag4",
		Desc = L"The slot is in the 4th bank bag",
		Condition = "(bag == 8)",
		RequireBag = { 8 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 6, 7, 9, 10, 11 },
	},
	{
		ID = 110007,
		BankOnly = true,
		Name = L"BankBag5",
		Desc = L"The slot is in the 5th bank bag",
		Condition = "(bag == 9)",
		RequireBag = { 9 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 6, 7, 8, 10, 11 },
	},
	{
		ID = 110008,
		BankOnly = true,
		Name = L"BankBag6",
		Desc = L"The slot is in the 6th bank bag",
		Condition = "(bag == 10)",
		RequireBag = { 10 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 6, 7, 8, 9, 11 },
	},
	{
		ID = 110009,
		BankOnly = true,
		Name = L"BankBag7",
		Desc = L"The slot is in the 7th bank bag",
		Condition = "(bag == 11)",
		RequireBag = { 11 },
		DenyBag = { _G.BANK_CONTAINER, _G.REAGENTBANK_CONTAINER, 5, 6, 7, 8, 9, 10 },
	},
	{
		ID = 100007,
		Name = L"HasItem",
		Desc = L"The slot has item",
		Condition = "itemID",
	},
	{
		ID = 100008,
		Name = L"Readable",
		Desc = L"The slot has item, and the item is a readable item such as books or scrolls",
		Condition = "readable",
	},
	{
		ID = 100009,
		Name = L"Lootable",
		Desc = L"The slot has item, and the item is a temporary container containing items that can be looted",
		Condition = "lootable",
	},
	{
		ID = 100010,
		Name = L"HasNoValue",
		Desc = L"The slot has item, and the item has no sale price",
		Condition = "hasNoValue",
	},
	{
		ID = 100011,
		Name = L"IsQuestItem",
		Desc = L"The slot has item, and the item is a quest item",
		Condition = "(questId or isQuest)",
	},
	{
		ID = 100012,
		Name = L"IsEquipItem",
		Desc = L"The slot has item, and the item is an equipment",
		Condition = "(equipSlot and equipSlot~='' and equipSlot~='INVTYPE_BAG')",
	},
	{
		ID = 100013,
		Name = L"IsStackableItem",
		Desc = L"The slot has item, and the item is stackable",
		Condition = "(maxStack and maxStack > 1)",
	},
	{
		ID = 100014,
		Name = L"IsUsableItem",
		Desc = L"The slot has item, and the item can be used by right-click.",
		Condition = "itemSpell",
	},
	{
		ID = 100015,
		BagOnly = true,
		Name = L"IsNewItem",
		Desc = L"The slot has item, and the item is newly added.",
		Condition = "isNewItem",
	},
	{
		ID = 100016,
		BagOnly = true,
		Name = L"IsEquipSet",
		Desc = L"The slot has item, and the item is in a equip set.",
		Condition = "GetContainerItemEquipmentSetInfo(bag, slot)",
		RequireEvent = { "EQUIPMENT_SETS_CHANGED" },
	},
	--[[{
		ID = 100017,
		Name = _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN,
		Desc = L"The slot has item, and the item has unknown appearance",
		Condition = "(equipSlot and equipSlot~='' and equipSlot~='INVTYPE_BAG')",
		TooltipFilter = _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN,
	},
	{
		ID = 100018,
		Name = _G.ITEM_BIND_ON_EQUIP,
		Desc = L"The slot has item, and the item is a BOE equipment(unbind)",
		Condition = "(equipSlot and equipSlot~='' and equipSlot~='INVTYPE_BAG')",
		TooltipFilter = _G.ITEM_BIND_ON_EQUIP,
	},
	{
		ID = 100019,
		Name = _G.ARTIFACT_POWER,
		Desc = L"The slot has item, and the item is an artifact power",
		Condition = ("(cls == %q and subclass == %q)"):format(GetItemClassInfo(_G.LE_ITEM_CLASS_CONSUMABLE), GetItemSubClassInfo(_G.LE_ITEM_CLASS_CONSUMABLE, tremove({GetAuctionItemSubClasses(_G.LE_ITEM_CLASS_CONSUMABLE)}))),
		TooltipFilter = _G.ARTIFACT_POWER,
	},--]]
	{
		ID = 200001,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY0_DESC"],
		Desc = L"The slot has item, and the item is poor(color gray)",
		Condition = "(quality == LE_ITEM_QUALITY_POOR)",
	},
	{
		ID = 200002,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY1_DESC"],
		Desc = L"The slot has item, and the item is common(color white)",
		Condition = "(quality == LE_ITEM_QUALITY_COMMON)",
	},
	{
		ID = 200003,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY2_DESC"],
		Desc = L"The slot has item, and the item is uncommon(color green)",
		Condition = "(quality == LE_ITEM_QUALITY_UNCOMMON)",
	},
	{
		ID = 200004,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY3_DESC"],
		Desc = L"The slot has item, and the item is rare(color blue)",
		Condition = "(quality == LE_ITEM_QUALITY_RARE)",
	},
	{
		ID = 200005,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY4_DESC"],
		Desc = L"The slot has item, and the item is epic(color purple)",
		Condition = "(quality == LE_ITEM_QUALITY_EPIC)",
	},
	{
		ID = 200006,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY5_DESC"],
		Desc = L"The slot has item, and the item is legendary(color orange)",
		Condition = "(quality == LE_ITEM_QUALITY_LEGENDARY)",
	},
	{
		ID = 200007,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY6_DESC"],
		Desc = L"The slot has item, and the item is artifact(color golden yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_ARTIFACT)",
	},
	{
		ID = 200008,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY7_DESC"],
		Desc = L"The slot has item, and the item is heirloom(color light yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_HEIRLOOM)",
	},
	{
		ID = 200009,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY8_DESC"],
		Desc = L"The slot has item, and the item is wow token(color light yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_WOW_TOKEN)",
	},
}

local i = 0
local itemCls = GetItemClassInfo(i)
local _ID

while itemCls and #itemCls > 0 do
	_ID = 300000 + i * 1000
	tinsert(_ItemConditions, {
		ID = _ID,
		Name = itemCls,
		Desc = L"The slot has item, and the item's class is " .. itemCls,
		Condition = ("(cls == %q)"):format(itemCls),
	})

	local j = 0
	local itemSubCls = GetItemSubClassInfo(i, j)

	while itemSubCls and #itemSubCls > 0 do
		_ID = _ID + 1
		tinsert(_ItemConditions, {
			ID = _ID,
			Name = itemCls .. "-" .. itemSubCls,
			Desc = L"The slot has item, and the item's sub-class is " .. itemSubCls,
			Condition = ("(cls == %q and subclass == %q)"):format(itemCls, itemSubCls),
		})

		j = j + 1
		itemSubCls = GetItemSubClassInfo(i, j)
	end

	i = i + 1
	itemCls = GetItemClassInfo(i)
end

for i, v in ipairs(_ItemConditions) do
	_ItemConditions[v.ID] = v
end

-- Widget Classes
class "BagButton"
	inherit "ItemButton"
	extend "IFStyle"

	-- Block parent's UpdateAction
	function UpdateAction(self) end

	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
			if value then
				self:GetChild("Icon"):SetTexCoord(0.06, 0.94, 0.06, 0.94)
			end
		end,
		Type = String + Number,
	}

	function BagButton(self, ...)
		Super(self, ...)

		self.ShowGrid = true
		self.GameTooltipAnchor = "ANCHOR_RIGHT"
	end
endclass "BagButton"

class "BagPanel"
	inherit "SecureFrame"
	extend "IFSecurePanel"

	local function OnElementRemove(self, btn)
		btn:SetAction(nil)
		btn:Hide()
	end

	local function OnElementAdd(self, btn)
		btn:Show()
	end

	function BagPanel(self, name, ...)
		Super(self, name, ...)

		self.ElementType = BagButton
		self.ElementPrefix = name .. "_Button"

		self.RowCount = 1
		self.ColumnCount = 12
		self.ElementWidth = 36
		self.ElementHeight = 36

		self.Orientation = Orientation.HORIZONTAL
		self.HSpacing = 2
		self.VSpacing = 2
		self.KeepMaxSize = true

		self.MarginTop = 1
		self.MarginBottom = 1
		self.MarginLeft = 1
		self.MarginRight = 1

		self.OnElementRemove = self.OnElementRemove + OnElementRemove
		self.OnElementAdd = self.OnElementAdd + OnElementAdd
	end
endclass "BagPanel"

class "ContainerButton"
	inherit "ItemButton"
	extend "IFStyle"

	-- Block parent's UpdateAction
	function UpdateAction(self)
		local bag, slot = self.ActionTarget, self.ActionDetail
		if bag and slot then
			local _, _, _, quality, _, _, _, _, _, itemId = GetContainerItemInfo(bag, slot)
			if itemId then
				local _, _, _, iLevel, _, _, _, _, equipSlot = GetItemInfo(itemId)
				if equipSlot and equipSlot~='' and equipSlot~='INVTYPE_BAG' then
					_GameTooltip:SetOwner(self)
					_GameTooltip:SetBagItem(bag, slot)
					local i = 3
					local iLvl = _G["IGAS_UI_Container_TooltipTextLeft2"] and _G["IGAS_UI_Container_TooltipTextLeft2"]:GetText()
					while i <= 5 and iLvl and not tonumber(iLvl:match("%d+$")) do
						iLvl = _G["IGAS_UI_Container_TooltipTextLeft"..i] and _G["IGAS_UI_Container_TooltipTextLeft"..i]:GetText()
						i = i + 1
					end
					iLvl = iLvl and tonumber(iLvl:match("%d+$")) or iLevel
					self.iLevel.Text = BAG_ITEM_QUALITY_COLORS[quality].code .. tostring(iLvl) .. "|r"
					return _GameTooltip:Hide()
				end
			end
		end
		self.iLevel.Text = ""
	end

	__Handler__(function(self, val)
		if val then
			local itemID = GetContainerItemID(self.ActionTarget, self.ActionDetail)
			if IsArtifactRelicItem(itemID) then
				self.NormalTexturePath = [[Interface\Artifacts\RelicIconFrame]]
			else
				self.NormalTexturePath = Media.BORDER_TEXTURE_PATH
			end

			self.NormalTexture.VertexColor = BAG_ITEM_QUALITY_COLORS[val] or Media.PLAYER_CLASS_COLOR
		else
			self.NormalTexturePath = Media.BORDER_TEXTURE_PATH
			self.NormalTexture.VertexColor = Media.PLAYER_CLASS_COLOR
		end
	end)
	property "ItemQuality" { Type = NumberNil }

	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
			if value then
				self:GetChild("Icon"):SetTexCoord(0.06, 0.94, 0.06, 0.94)
			end
		end,
		Type = String + Number,
	}

	__Handler__(function(self, val) self.UpgradeIcon.Visible = val end)
	property "IsUpgradeItem" { Type = Boolean }

	function ContainerButton(self, ...)
		Super(self, ...)

		self.ShowGrid = false

		local lvl = FontString("iLevel", self, "OVERLAY")
		lvl.FontObject = Media.NumberFont
		lvl.JustifyH = "LEFT"
		lvl:SetPoint("BOTTOMLEFT", 4, 4)

		local upgrade = Texture("UpgradeIcon", self, "OVERLAY", nil, 1)
		upgrade:SetAtlas("bags-greenarrow", true)
		upgrade:SetPoint("TOPLEFT")
		upgrade.Visible = false
	end
endclass "ContainerButton"

class "Container"
	inherit "SecureFrame"
	extend "IFSecurePanel"

	local function OnElementRemove(self, btn)
		btn:SetAction(nil)
		btn.Visible = false
	end

	local function OnElementAdd(self, btn)
		btn.Visible = true
	end

	property "Name" {
		Type = String,
		Handler = function(self, name)
			if name and name ~= "" then
				self.NameLabel.Text = name
				self.MarginTop = self.NameLabel.Height + 1
			else
				self.MarginTop = 1
				self.NameLabel.Text = ""
			end
		end,
	}

	function Container(self, name, ...)
		Super(self, name, ...)

		local label = FontString("NameLabel", self)
		label.FontObject = GameFontHighlight
		label:SetPoint("TOPLEFT")

		local prev, id = name:match("^(.*)(%d+)$")
		id = tonumber(id)

		self.Parent[id] = self
		self.ID = id

		if id == 1 then
			self:SetPoint("TOPLEFT", self.Parent.Parent, "BOTTOMLEFT", 2, -8)
		else
			self:SetPoint("TOPLEFT", self.Parent:GetChild(prev .. (id-1)), "BOTTOMLEFT", 0, -8)
		end

		self.ElementType = ContainerButton
		self.ElementPrefix = name .. "_IButton"

		if self.Parent.Parent.IsBank then
			self.RowCount = 27
			self.ColumnCount = 14
		else
			self.RowCount = 20
			self.ColumnCount = 12
		end
		self.ElementWidth = 36
		self.ElementHeight = 36

		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = true
		self.HSpacing = 2
		self.VSpacing = 2
		self.AutoSize = true
		self.KeepColumnSize = true

		self.MarginTop = 1
		self.MarginBottom = 1
		self.MarginLeft = 1
		self.MarginRight = 1

		self.OnElementRemove = self.OnElementRemove + OnElementRemove
		self.OnElementAdd = self.OnElementAdd + OnElementAdd
	end
endclass "Container"

class "ContainerView"
	inherit "SecureFrame"

	local tconcat = table.concat

	local function matchText(txt, lst)
		for _, v in ipairs(lst) do
			if txt:match(v) then
				return true
			end
		end
		return false
	end

	local function buildContainerRules(containerRules, itemList, isBank)
		if not containerRules or #containerRules == 0 then return nil end

		local defines = {}
		local codes = {}
		local scanConds = {}
		local scanCodes = {}

		local bags = {}
		local evts = {}

		local groupCnt = 0
		local ruleCnt = 0
		local filterList = {}

		for i, containerRule in ipairs(containerRules) do
			if containerRule and #containerRule > 0 then
				groupCnt = groupCnt + 1

				for j, rules in ipairs(containerRule) do
					if rules and (#rules > 0 or rules.TooltipFilter) then
						ruleCnt = ruleCnt + 1

						local cond = {}
						local requireBag = false

						if rules.TooltipFilter then
							local filter = {}
							rules.TooltipFilter:gsub("[^;]+", function(w)
								w = strtrim(w)
								if w ~= "" then
									tinsert(filter, w)
								end
							end)
							filterList[ruleCnt] = filter
						else
							filterList[ruleCnt] = false
						end

						for k, rule in ipairs(rules) do
							if _ItemConditions[math.abs(rule)] then
								if _ItemConditions[math.abs(rule)].RequireEvent then
									for i, v in ipairs(_ItemConditions[math.abs(rule)].RequireEvent) do
										if not evts[v] then
											tinsert(evts, v)
											evts[v] = true
										end
									end
								end
								if rule > 0 then
									if not bags.RequireAll and _ItemConditions[rule].RequireBag then
										requireBag = true
										for i, v in ipairs(_ItemConditions[rule].RequireBag) do
											bags[v] = true
										end
									end

									tinsert(cond, _ItemConditions[rule].Condition)
								else
									if not bags.RequireAll and _ItemConditions[math.abs(rule)].DenyBag then
										requireBag = true
										for i, v in ipairs(_ItemConditions[math.abs(rule)].DenyBag) do
											bags[v] = true
										end
									end

									tinsert(cond, "not " .. _ItemConditions[math.abs(rule)].Condition)
								end
							end
						end

						if not requireBag then
							bags.RequireAll = true
						end

						if #cond > 0 then
							cond = tconcat(cond, " and ")
						elseif filterList[ruleCnt] then
							cond = "true"
						else
							cond = "false"
						end

						tinsert(defines, ("local isRule%d = %s\nlocal ruleFilterMatch%d = %s"):format(ruleCnt, cond, ruleCnt, filterList[ruleCnt] and "false" or "true"))

						if filterList[ruleCnt] then
							tinsert(scanConds, ("(isRule%d and filterList[%d])"):format(ruleCnt, ruleCnt))
							tinsert(scanCodes, ("ruleFilterMatch%d = ruleFilterMatch%d or matchText(tipText, filterList[%d])"):format(ruleCnt, ruleCnt, ruleCnt))
						end

						tinsert(codes, ("if isRule%d and ruleFilterMatch%d then yield(%d, bag, slot) else"):format(ruleCnt, ruleCnt, groupCnt))
					end
				end
			end
		end

		if #codes == 0 then
			return function() end
		else
			tinsert(codes, " end")
		end

		codes = tconcat(codes, "") or "if true then return end"

		local containerList

		if bags.RequireAll then
			if isBank then
				containerList = { BANK_CONTAINER, REAGENTBANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11 }
			else
				containerList = { 0, 1, 2, 3, 4 }
			end
		else
			containerList = {}
			for k in pairs(bags) do if tonumber(k) then tinsert(containerList, k) end end
			table.sort(containerList)
		end

		for k in pairs(evts) do
			if type(k) == "string" then
				evts[k] = nil
			end
		end

		if #evts == 0 then evts = nil end

		codes = ([[
			local containerList, itemList, filterList, matchText = ...
			local yield = coroutine.yield
			local GetContainerItemInfo = GetContainerItemInfo
			local GetContainerItemQuestInfo = GetContainerItemQuestInfo
			local GetItemInfo = GetItemInfo
			local GetItemSpell = GetItemSpell
			local IsNewItem =  C_NewItems.IsNewItem
			local BANK_CONTAINER = BANK_CONTAINER
			local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER
			local GameTooltip = IGAS_UI_Container_Tooltip
			local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID
			local ReagentBankButtonIDToInvSlotID = ReagentBankButtonIDToInvSlotID
			local pcall = pcall
			local SetInventoryItem = GameTooltip.SetInventoryItem
			local SetBagItem = GameTooltip.SetBagItem

			return function()
				for _, bag in ipairs(containerList) do
					for slot = 1, GetContainerNumSlots(bag) do
						local _, count, _, quality, readable, lootable, link, _, hasNoValue, itemID = GetContainerItemInfo(bag, slot)
						local isQuest, questId, isActive = GetContainerItemQuestInfo(bag, slot)
						local name, iLevel, reqLevel, cls, subclass, maxStack, equipSlot, vendorPrice
						local itemSpell, isNewItem

						if itemID then
							name, _, _, iLevel, reqLevel, cls, subclass, maxStack, equipSlot, _, vendorPrice = GetItemInfo(itemID)
							itemSpell = GetItemSpell(itemID)
							isNewItem = (bag >= 0 and bag <= 4) and IsNewItem(bag, slot)
						end

						%s

						if %s then
							local ok, msg

							GameTooltip:SetOwner(UIParent)
							if bag == BANK_CONTAINER then
								ok, msg = pcall(SetInventoryItem, GameTooltip,"player", BankButtonIDToInvSlotID(slot))
							elseif bag == REAGENTBANK_CONTAINER then
								ok, msg = pcall(SetInventoryItem, GameTooltip, "player", ReagentBankButtonIDToInvSlotID(slot))
							else
								ok, msg = pcall(SetBagItem, GameTooltip, bag, slot)
							end

							if ok then
								local i = 1
								local t = _G["IGAS_UI_Container_TooltipTextLeft"..i]

								while t and t:IsShown() do
									local tipText = t:GetText()
									if tipText and tipText ~= "" then
										%s
									end

									i = i + 1
									t = _G["IGAS_UI_Container_TooltipTextLeft"..i]
								end
							end
							GameTooltip:Hide()
						end

						%s
					end
				end
			end
		]]):format(tconcat(defines, "\n"), #scanConds>0 and tconcat(scanConds, " or ") or "false", tconcat(scanCodes, "\n"), codes)

		return loadstring(codes)(containerList, itemList or {}, filterList, matchText), evts
	end

	local function OnShow(self)
		self.OnShow = self.OnShow - OnShow

		if self.Dispatch and not self.TaskMark then
			return self:StartRefresh()
		end
	end

	local function refreshContainer(self, ...)
		self.TaskMark = (self.TaskMark or 0) + 1

		local taskMark = self.TaskMark
		local dispatch = self.Dispatch
		local count = self.RuleCount or 0
		local containerCnt = {}
		local configName = self.ConfigName
		if not dispatch or count == 0 then return end

		while self.TaskMark == taskMark do
			if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
			while InCombatLockdown() do Task.Delay(0.1) end
			if self.TaskMark ~= taskMark then break end

			for i = 1, count do containerCnt[i] = 0 end

			local replaceCnt = 0
			local chkCount = self.LoadInstant and 999 or self.FirstLoaded and 4 or 10
			local restartGen = false
			local st = GetTime()

			Debug("Process refreshContainer @pid %d for %s step %d", taskMark, configName, chkCount)

			for id, bag, slot in tpairs(dispatch) do
				containerCnt[id] = containerCnt[id] + 1
				local ele = self[id].Element[containerCnt[id]]
				if ele.ActionTarget ~= bag or ele.ActionDetail ~= slot then
					ele:SetAction("bagslot", bag, slot)

					replaceCnt = replaceCnt + 1
					if replaceCnt % chkCount == 0 then
						Task.Next()

						while InCombatLockdown() do
							-- well, bad luck
							local ret = Task.Wait(0.5, "PLAYER_REGEN_ENABLED", "BAG_UPDATE_DELAYED", ...)
							if ret and ret ~= "PLAYER_REGEN_ENABLED" then
								restartGen = true
								break
							end
						end
					end
				end
			end

			Debug("Finish refreshContainer @pid %d for %s cost %.2f", taskMark, configName, GetTime() - st)

			if not restartGen then
				self.FirstLoaded = false

				for i = 1, count do
					self[i].Count = containerCnt[i]
				end

				Task.Wait("BAG_UPDATE_DELAYED", ...)

				Task.Next()
			end
		end

		Debug("Stop refreshContainer @pid %d for %s", taskMark, configName)
	end

	local function refreshBank(self, ...)
		self.TaskMark = (self.TaskMark or 0) + 1

		local taskMark = self.TaskMark
		local dispatch = self.Dispatch
		local count = self.RuleCount or 0
		local containerCnt = {}
		local firstRun = true
		local configName = self.ConfigName
		if not dispatch or count == 0 then return end

		while self.TaskMark == taskMark do
			if firstRun then
				firstRun = true
				if not self.Parent.Visible then
					Task.Wait("BANKFRAME_OPENED")
				end
			else
				Task.Wait("BANKFRAME_OPENED")
			end

			while self.TaskMark == taskMark do
				-- should hide the bank frame if in combat
				if InCombatLockdown() then break end
				if self.TaskMark ~= taskMark then break end

				for i = 1, count do containerCnt[i] = 0 end

				local replaceCnt = 0
				local chkCount = 14
				local st = GetTime()

				Debug("Process refreshBank @pid %d for %s step %d", taskMark, configName, chkCount)

				for id, bag, slot in tpairs(dispatch) do
					containerCnt[id] = containerCnt[id] + 1
					local ele = self[id].Element[containerCnt[id]]
					if ele.ActionTarget ~= bag or ele.ActionDetail ~= slot then
						ele:SetAction("bagslot", bag, slot)

						replaceCnt = replaceCnt + 1
						if replaceCnt % chkCount == 0 then
							Task.Next()

							-- should hide the bank frame if in combat
							if InCombatLockdown() then break end
							if self.TaskMark ~= taskMark then break end
						end
					end
				end

				Debug("Finish refreshBank @pid %d for %s cost %.2f", taskMark, configName, GetTime() - st)

				-- should hide the bank frame if in combat
				if InCombatLockdown() then break end
				if self.TaskMark ~= taskMark then break end

				self.FirstLoaded = true

				for i = 1, count do
					self[i].Count = containerCnt[i]
				end

				local ret = Task.Wait("BANKFRAME_CLOSED", "BAG_UPDATE_DELAYED", "PLAYERBANKSLOTS_CHANGED", "PLAYERBANKBAGSLOTS_CHANGED", "PLAYERREAGENTBANKSLOTS_CHANGED", ...)

				if ret == "BANKFRAME_CLOSED" then break end
				local startSort = self.Parent.StartSort
				if startSort and math.abs(startSort - GetTime()) < 1 then
					while self.TaskMark == taskMark do
						ret = Task.Wait(2.5, "BANKFRAME_CLOSED", "BAG_UPDATE_DELAYED", "PLAYERBANKSLOTS_CHANGED", "PLAYERREAGENTBANKSLOTS_CHANGED")
						if ret == "BANKFRAME_CLOSED" then break end
						if not ret then break end
					end
				end
				if ret == "BANKFRAME_CLOSED" then break end
				Task.Next() -- Skip more events in the same time
			end
			if self.TaskMark ~= taskMark then break end
		end

		Debug("Stop refreshBank @pid %d for %s", taskMark, configName)
	end

	__Delegate__(Task.NoCombatCall)
	function ApplyContainerRules(self, containerRules, itemList, isBank, force)
		local dispatch, evts = buildContainerRules(containerRules, itemList, isBank)

		local count = containerRules and #containerRules or 0
		local i = 1
		local container

		while i <= count do
			container = self:GetChild(self.ElementPrefix .. i) or Container(self.ElementPrefix .. i, self)
			container.Visible = true

			container.Name = containerRules[i].Name

			i = i + 1
		end

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", self.Parent, "BOTTOMLEFT", 0, -4)
		self:SetPoint("TOPRIGHT", self.Parent, "BOTTOMRIGHT", 0, -4)
		if container then
			self:SetPoint("BOTTOM", container, "BOTTOM", 0, -4)
		else
			self.Height = 10
		end

		local container = self:GetChild(self.ElementPrefix .. i)
		while container do
			container.Count = 0
			container.Visible = false

			i = i + 1
			container = self:GetChild(self.ElementPrefix .. i)
		end

		self.IsBank = isBank
		self.RuleCount = count
		self.Dispatch = dispatch
		self.RequireEvents = evts

		if dispatch and force then
			self:StartRefresh()
		end
	end

	function StopRefresh(self)
		self.TaskMark = (self.TaskMark or 0) + 1
	end

	function StartRefresh(self)
		if self.RequireEvents then
			if self.IsBank then
				return Task.ThreadCall(refreshBank, self, unpack(self.RequireEvents))
			else
				return Task.ThreadCall(refreshContainer, self, unpack(self.RequireEvents))
			end
		else
			if self.IsBank then
				return Task.ThreadCall(refreshBank, self)
			else
				return Task.ThreadCall(refreshContainer, self)
			end
		end
	end

	property "LoadInstant" { Type = Boolean }
	property "FirstLoaded" { Type = Boolean, Default = true }

	function ContainerView(self, name, ...)
		Super(self, name, ...)
		self.Visible = false

		self.ElementPrefix = name .. "_Container"

		self:SetSize(1, 1)

		self.Backdrop = _Backdrop
		self.BackdropBorderColor = Media.PLAYER_CLASS_COLOR
		self.BackdropColor = _BackColor

		self.FrameLevel = 3

		self.OnShow = self.OnShow + OnShow
	end
endclass "ContainerView"

class "ViewButton"
	inherit "SecureCheckButton"

	local function OnAttributeChanged(self, name, value)
		if name == "viewactive" then
			self.Checked = value

			if value then
				if self.Parent.IsBank then
					_ContainerDB.SelectedBankView = self.Text
				else
					_ContainerDB.SelectedView = self.Text
				end
			end
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ViewButton(self, name, ...)
		Super(self, name, ...)

		self.FontString = FontString("Label", self)
		self.FontString.FontObject = GameFontHighlight
		self.FontString:SetAllPoints()

		self.CheckedTexturePath = [[Interface\Buttons\WHITE8x8]]
		self.CheckedTexture.VertexColor = ColorType(0, 0.4, 0.8)

		self.ContainerView = ContainerView(name .. "Panel", self.Parent)
		self.ContainerView:SetPoint("TOPLEFT", self.Parent, "BOTTOMLEFT")
		self.ContainerView:SetPoint("TOPRIGHT", self.Parent, "BOTTOMRIGHT")

		self:SetFrameRef("ContainerView", self.ContainerView)
		self:SetFrameRef("ViewManager", self.Parent)

		self:SetAttribute("type", "viewchange")
		self:SetAttribute("_viewchange", [[self:GetFrameRef("ViewManager"):RunFor(self, "ViewManager:RunFor(self, ActiveView)")]])

		self.OnAttributeChanged = self.OnAttributeChanged + OnAttributeChanged
	end
endclass "ViewButton"

class "TokenInfo"
	inherit "Button"

	local function OnEnter(self)
		_GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		_GameTooltip:SetCurrencyToken(self.ID)
	end

	local function OnLeave(self)
		_GameTooltip:Hide()
	end

	__Handler__(function(self, val)
		if val then
			local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(val)
			if count and count <= 99999 then
				self.Count.Text = tostring(count)
			else
				self.Count.Text = "*"
			end
			self.Icon.TexturePath = icon
			self.Icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
		end
	end)
	property "ID" { Type = NumberNil }

	function TokenInfo(self, ...)
		Super(self, ...)

		local cnt = FontString("Count", self, "ARTWORK", "GameFontHighlight")
		cnt.JustifyH = "RIGHT"
		cnt:SetSize(68, 32)
		cnt:SetPoint("TOPLEFT")

		local mask = Texture("Mask", self)
		mask:SetSize(32, 32)
		mask:SetPoint("LEFT", cnt, "RIGHT")
		mask.DrawLayer = "OVERLAY"
		mask.TexturePath = Media.BORDER_TEXTURE_PATH
		mask.VertexColor = Media.PLAYER_CLASS_COLOR

		local icon = Texture("Icon", self, "ARTWORK")
		icon:SetPoint("TOPLEFT", mask, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", mask, "BOTTOMRIGHT", -2, 2)

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
	end
endclass "TokenInfo"

class "TokenPanel"
	inherit "Frame"
	extend "IFElementPanel"

	local CurrentProcess = 0

	local function OnShow(self)
		local watchList = _ContainerDB.TokenWatchList
		CurrentProcess = CurrentProcess + 1

		local process = CurrentProcess

		Debug("[TokenPanel] Start process %d", process)

		while self:IsVisible() and process == CurrentProcess do
			local idx = 1

			if watchList then
				for i = 1, GetCurrencyListSize() do
					if idx > self.MaxCount then break end

					local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(i)
					if watchList[name] then
						self.Element[idx].ID = i
						self.Element[idx].Visible = true
						idx = idx + 1
					end
				end
			end

			while idx <= self.Count do
				self.Element[idx].Visible = false
				idx = idx + 1
			end

			self:UpdatePanelSize()

			Task.Delay(1)
		end

		Debug("[TokenPanel] Stop process %d", process)
	end

	function TokenPanel(self, ...)
		Super(self, ...)

		self.AutoSize = true
		self.ColumnCount = 1
		self.RowCount = 20
		self.ElementWidth = 100
		self.ElementHeight = 32
		self.HSpacing = 2
		self.VSpacing = 2
		self.MouseEnabled = false
		self.MouseWheelEnabled = false
		self.ElementType = TokenInfo

		self.OnShow = self.OnShow + OnShow
		self.OnShow.Delegate = Task.ThreadCall
	end
endclass "TokenPanel"

class "ContainerHeader"
	inherit "SecureFrame"
	extend "IFSecurePanel"

	local function OnElementRemove(self, viewBtn)
		viewBtn.ContainerView:StopRefresh()
		viewBtn.ContainerView:ApplyContainerRules(nil)
		viewBtn.Visible = false
		self:SetFrameRef("ViewBtn", viewBtn)
		self:Execute[[
			ViewButton[self:GetFrameRef("ViewBtn")] = nil
			self:GetFrameRef("ViewBtn"):GetFrameRef("ContainerView"):Hide()
			self:GetFrameRef("ViewBtn"):SetAttribute("viewactive", false)
		]]
	end

	local function OnElementAdd(self, viewBtn)
		self:SetFrameRef("ViewBtn", viewBtn)
		viewBtn.Visible = true
		self:Execute[[
			ViewButton[self:GetFrameRef("ViewBtn")] = true
		]]
	end

	local function GenerateBankSlots(bagPanel)
		if bagPanel.Visible then
			local num = GetNumBankSlots()
			local cnt = num
			for i = 1, num do bagPanel.Element[i]:SetAction("bag", i + 4) end
			if num < NUM_BANKBAGSLOTS then
				_G.BankFrame.nextSlotCost = GetBankSlotCost(num)

				cnt = cnt + 1
				bagPanel.Element[cnt].MacroText = "/click BankFramePurchaseButton"
				bagPanel.Element[cnt].CustomTooltip = _G.BANKSLOTPURCHASE
				bagPanel.Element[cnt].CustomTexture = [[Interface\PaperDollInfoFrame\Character-Plus]]
				bagPanel.Element[cnt]:Refresh()
			end

			if not IsReagentBankUnlocked() then
				cnt = cnt + 1
				bagPanel.Element[cnt].MacroText = "/click ReagentBankFrameUnlockInfoPurchaseButton"
				bagPanel.Element[cnt].CustomTooltip = _G.BANKSLOTPURCHASE
				bagPanel.Element[cnt].CustomTexture = [[Interface\PaperDollInfoFrame\Character-Plus]]
				bagPanel.Element[cnt]:Refresh()
			else
				bagPanel.Count = cnt
			end

			if num < NUM_BANKBAGSLOTS or not IsReagentBankUnlocked() then
				Task.ThreadCall(function()
					if Task.Wait("REAGENTBANK_PURCHASED", "PLAYERBANKBAGSLOTS_CHANGED") then
						return Task.NextCall(Task.NoCombatCall, GenerateBankSlots, bagPanel)
					end
				end)
			end
		end
	end

	property "IsBank" { Type = Boolean }

	function ApplyConfig(self, configs, force)
		self.Count = #configs

		for i, config in ipairs(configs) do
			self.Element[i].Text = config.Name
			self.Element[i].ContainerView.ConfigName = config.Name
			self.Element[i].ContainerView:ApplyContainerRules(config.ContainerRules, config.ItemList, self.IsBank, force)
		end
	end

	function ContainerHeader(self, name, parent, isBank)
		Super(self, name, parent, "SecureHandlerStateTemplate")

		self.IsBank = isBank
		self.Visible = false

		self:Execute[[
			ViewManager = self

			ViewButton = newtable()

			ActiveView = [=[
				for btn in pairs(ViewButton) do
					if btn ~= self then
						btn:GetFrameRef("ContainerView"):Hide()
						btn:SetAttribute("viewactive", false)
					else
						btn:GetFrameRef("ContainerView"):Show()
						btn:SetAttribute("viewactive", true)
					end
				end
			]=]
		]]

		self.Backdrop = _Backdrop
		self.BackdropBorderColor = Media.PLAYER_CLASS_COLOR
		self.BackdropColor = _BackColor

		self.ElementType = ViewButton
		self.ElementPrefix = name .. "_View"

		if isBank then
			self.RowCount = 6
			self.ColumnCount = 5
			self.ElementWidth = 95
			self.ElementHeight = 24
		else
			self.RowCount = 6
			self.ColumnCount = 4
			self.ElementWidth = 100
			self.ElementHeight = 24
		end

		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = true
		self.HSpacing = 2
		self.VSpacing = 2
		self.AutoSize = true
		self.KeepColumnSize = true

		self.MarginTop = 2
		self.MarginBottom = 30
		self.MarginLeft = 4
		self.MarginRight = 52

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
		self.OnElementRemove = self.OnElementRemove + OnElementRemove

		Mask("Mask", self).AsMove = true

		-- Search Box
		local searchBox = EditBox("SearchBox", self, "BagSearchBoxTemplate")
		searchBox:SetPoint("BOTTOMLEFT", 8, 4)
		searchBox:SetSize(160, 24)
		searchBox = IGAS:GetUI(searchBox)
		searchBox.Left:Hide()
		searchBox.Right:Hide()
		searchBox.Middle:Hide()

		-- Sort btn
		local sortBtn = SecureButton(name .. "SortButton", self)
		sortBtn:SetSize(28, 26)
		sortBtn:SetPoint("BOTTOMRIGHT", -2, 4)
		sortBtn.NormalTexture = Texture("Normal", sortBtn)
		sortBtn.NormalTexture:SetAllPoints()
		sortBtn.NormalTexture:SetAtlas("bags-button-autosort-up")
		sortBtn.PushedTexture = Texture("Push", sortBtn)
		sortBtn.PushedTexture:SetAllPoints()
		sortBtn.PushedTexture:SetAtlas("bags-button-autosort-down")
		sortBtn.HighlightTexturePath = [[Interface\Buttons\ButtonHilight-Square]]
		sortBtn.HighlightTexture.BlendMode = "ADD"

		if isBank then
			sortBtn.PreClick = function()
				_G.BankFrame.activeTabIndex = 2
				self.StartSort = GetTime()
			end
			sortBtn.OnEnter = function(self)
				_GameTooltip:SetOwner(self)
				_GameTooltip:SetText(_G.BAG_CLEANUP_REAGENT_BANK)
				_GameTooltip:Show()
			end
			sortBtn.OnLeave = function(self)
				_GameTooltip:Hide()
			end
			sortBtn:SetAttribute("type", "macro")
			sortBtn:SetAttribute("macrotext", "/click BankItemAutoSortButton")

			sortBtn = SecureButton(name .. "SortButton2", self)
			sortBtn:SetSize(28, 26)
			sortBtn:SetPoint("BOTTOMRIGHT", -30, 4)
			sortBtn.NormalTexture = Texture("Normal", sortBtn)
			sortBtn.NormalTexture:SetAllPoints()
			sortBtn.NormalTexture:SetAtlas("bags-button-autosort-up")
			sortBtn.PushedTexture = Texture("Push", sortBtn)
			sortBtn.PushedTexture:SetAllPoints()
			sortBtn.PushedTexture:SetAtlas("bags-button-autosort-down")
			sortBtn.HighlightTexturePath = [[Interface\Buttons\ButtonHilight-Square]]
			sortBtn.HighlightTexture.BlendMode = "ADD"

			sortBtn.PreClick = function()
				_G.BankFrame.activeTabIndex = 1
				self.StartSort = GetTime()
			end
			sortBtn.OnEnter = function(self)
				_GameTooltip:SetOwner(self)
				_GameTooltip:SetText(_G.BAG_CLEANUP_BANK)
				_GameTooltip:Show()
			end
			sortBtn.OnLeave = function(self)
				_GameTooltip:Hide()
			end
			sortBtn:SetAttribute("type", "macro")
			sortBtn:SetAttribute("macrotext", "/click BankItemAutoSortButton")

			sortBtn = BagButton(name .. "DepositButton", self)
			sortBtn:SetSize(28, 26)
			sortBtn:SetPoint("BOTTOMRIGHT", -58, 4)
			sortBtn.Custom = function()
				if not InCombatLockdown() and IsReagentBankUnlocked() then
					PlaySound("igMainMenuOption")
					DepositReagentBank()
				end
			end
			sortBtn.CustomTooltip = _G.REAGENTBANK_DEPOSIT
			sortBtn.CustomTexture = 644387
			sortBtn:Refresh()
		else
			sortBtn.PreClick = function()
				self.StartSort = GetTime()
			end
			sortBtn.OnEnter = function(self)
				_GameTooltip:SetOwner(self)
				_GameTooltip:SetText(_G.BAG_CLEANUP_BAGS)
				_GameTooltip:Show()
			end
			sortBtn.OnLeave = function(self)
				_GameTooltip:Hide()
			end
			sortBtn:SetAttribute("type", "macro")
			sortBtn:SetAttribute("macrotext", "/click BagItemAutoSortButton")
		end

		-- money frame
		local moneyFrame = CreateFrame("Frame", name .. "_MoneyFrame", self, "SmallMoneyFrameTemplate")
		moneyFrame:SetPoint("BOTTOMRIGHT", sortBtn, "BOTTOMLEFT", -4, 4)

		if not isBank then
			local tokenPanel = TokenPanel("TokenPanel", self)
			tokenPanel.FrameStrata = "DIALOG"
			tokenPanel:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 0)
		end

		-- Setting
		local btnContainerSetting = Button("Setting", self)
		btnContainerSetting:SetPoint("TOPRIGHT", -2, -2)
		btnContainerSetting:SetSize(50, 24)

		btnContainerSetting.OnClick = function()
			if not InCombatLockdown() then
				headerMenu.Header = self
				headerMenu.Visible = true
			end
		end

		local lblContainerSetting = FontString("Label", btnContainerSetting)
		lblContainerSetting.Text = "?"
		lblContainerSetting.FontObject = GameFontHighlight
		lblContainerSetting:SetPoint("RIGHT", -4, 0)

		local animContainerSetting = AnimationGroup("AutoSwap", btnContainerSetting)
		animContainerSetting.ToFinalAlpha = false
		animContainerSetting.Looping = "REPEAT"

		local alphaContainer = Alpha("Alpha", animContainerSetting)

		alphaContainer.Order = 1
		alphaContainer.StartDelay = 2
		alphaContainer.Duration = 1
		alphaContainer.FromAlpha = 1
		alphaContainer.ToAlpha = 0

		-- Toggle Container Bag
		local btnToggleContainer = Button("Toggle", self)
		btnToggleContainer:SetPoint("CENTER", self, "BOTTOM")
		btnToggleContainer:SetSize(32, 32)
		btnToggleContainer.NormalTexturePath = [[Interface\PaperDollInfoFrame\StatSortArrows]]
		btnToggleContainer.NormalTexture:SetTexCoord(0, 1, 0.5, 1)
		btnToggleContainer.NormalTexture:SetVertexColor(1, 1, 1)
		btnToggleContainer.NormalTexture:ClearAllPoints()
		btnToggleContainer.NormalTexture:SetPoint("CENTER", 0, 0)
		btnToggleContainer.NormalTexture:SetSize(16, 16)
		btnToggleContainer.FrameStrata = "HIGH"

		local bagPanel = BagPanel(name .. "_BagPanel", self)
		bagPanel:SetPoint("BOTTOMLEFT", 4, 32)
		bagPanel.Visible = false

		local animToggleContainer = AnimationGroup("AnimAlert", btnToggleContainer.NormalTexture)
		animToggleContainer.Looping = "REPEAT"

		local transToggleContainer1 = Translation("Trans1", animToggleContainer)
		transToggleContainer1.Order = 1
		transToggleContainer1.Duration = 0.1
		transToggleContainer1:SetOffset(0, 8)

		local transToggleContainer2 = Translation("Trans2", animToggleContainer)
		transToggleContainer2.Order = 2
		transToggleContainer2.Duration = 1
		transToggleContainer2:SetOffset(0, -8)

		self.OnShow = self.OnShow + function()
			animContainerSetting.Playing = true
			animToggleContainer.Playing = true
			animToggleContainer.Count = 0
		end

		self.OnHide = self.OnHide + function()
			animContainerSetting.Playing = false
			animToggleContainer.Playing = false
		end

		alphaContainer.OnFinished = function(this, requested)
			if not requested then
				if lblContainerSetting.Text == "?" then
					lblContainerSetting.Text = lblContainerSetting.OldText or "?"
				else
					lblContainerSetting.OldText = lblContainerSetting.Text
					lblContainerSetting.Text = "?"
				end
			end
		end

		transToggleContainer2.OnFinished = function()
			animToggleContainer.Count = (animToggleContainer.Count or 0) + 1

			if animToggleContainer.Count >= 5 then
				animToggleContainer.Playing = false
			end
		end

		btnToggleContainer.OnClick = function()
			if not InCombatLockdown() then
				if bagPanel.Visible then
					bagPanel.Visible = false
					-- for i = 1, bagPanel.Count do bagPanel.Element[i]:SetAction(nil) end
					self.MarginBottom = 30
					btnToggleContainer.NormalTexture:SetPoint("CENTER", 0, 0)
					btnToggleContainer.NormalTexture:SetTexCoord(0, 1, 0.5, 1)
					transToggleContainer1:SetOffset(0, 8)
					transToggleContainer2:SetOffset(0, -8)
				else
					self.MarginBottom = 72
					bagPanel.Visible = true
					if not self.IsFirstTimeToggled then
						self.IsFirstTimeToggled = true

						if self.IsBank then
							GenerateBankSlots(bagPanel)
						else
							for i = 0, 4 do bagPanel.Element[i+1]:SetAction("bag", i) end
						end
					end
					btnToggleContainer.NormalTexture:SetPoint("CENTER", 0, 4)
					btnToggleContainer.NormalTexture:SetTexCoord(0, 1, 0, 0.5)
					transToggleContainer1:SetOffset(0, -8)
					transToggleContainer2:SetOffset(0, 8)
				end
			end
		end

		if self.IsBank then
			Task.ThreadCall(function()
				while true do
					Task.Event("BANKFRAME_OPENED")

					while true do
						local _, tarFamily = GetContainerNumFreeSlots(0)
						local sFree, sTotal, free, total, bagFamily = 0, 0

						sFree = sFree + GetContainerNumFreeSlots(BANK_CONTAINER)
						sTotal = sTotal + GetContainerNumSlots(BANK_CONTAINER)

						local numSlots = GetNumBankSlots()

						for i = 1, numSlots do
							free, bagFamily = GetContainerNumFreeSlots(i + 4)
							total = GetContainerNumSlots(i + 4)

							if bagFamily == tarFamily then
								sFree = sFree + free
								sTotal = sTotal + total
							end
						end

						if sFree < math.min(10, sTotal/4) then
							lblContainerSetting.Text = ("(%s/%s)"):format(FontColor.RED .. (sTotal-sFree) .. FontColor.CLOSE, sTotal)
						else
							lblContainerSetting.Text = ("(%s/%s)"):format(sTotal-sFree, sTotal)
						end

						if Task.Wait("BANKFRAME_CLOSED", "BAG_UPDATE_DELAYED", "PLAYERBANKSLOTS_CHANGED", "PLAYERBANKBAGSLOTS_CHANGED") == "BANKFRAME_CLOSED" then break end
					end
				end
			end)
		else
			Task.ThreadCall(function()
				while true do
					local _, tarFamily = GetContainerNumFreeSlots(0)
					local sFree, sTotal, free, total, bagFamily = 0, 0
					for i = 0, 4 do
						free, bagFamily = GetContainerNumFreeSlots(i)
						total = GetContainerNumSlots(i)
						if bagFamily == tarFamily then
							sFree = sFree + free
							sTotal = sTotal + total
						end
					end

					if sFree < math.min(10, sTotal/4) then
						lblContainerSetting.Text = ("(%s/%s)"):format(FontColor.RED .. (sTotal-sFree) .. FontColor.CLOSE, sTotal)
					else
						lblContainerSetting.Text = ("(%s/%s)"):format(sTotal-sFree, sTotal)
					end

					Task.Event("BAG_UPDATE_DELAYED")
				end
			end)
		end
	end
endclass "ContainerHeader"