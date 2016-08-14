-----------------------------------------
-- Definition for Container
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Container"

import "System"
import "System.Widget"
import "System.Widget.Action"

_Backdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	tile = true, tileSize = 16, edgeSize = 1,
}
_BackColor = ColorType(0, 0, 0, 1)

-- Item Conditions
_ItemConditions = {
	{
		ID = 100001,
		Name = L"Any",
		Desc = L"No check, you should only use this for the last container of one view",
		Condition = "true",
	},
	{
		ID = 100002,
		Name = L"Backpack",
		Desc = L"The slot is in the backpack",
		Condition = "(bag == 0)",
	},
	{
		ID = 100003,
		Name = L"Container1",
		Desc = L"The slot is in the 1st container(from the right)",
		Condition = "(bag == 1)",
	},
	{
		ID = 100004,
		Name = L"Container2",
		Desc = L"The slot is in the 2nd container(from the right)",
		Condition = "(bag == 2)",
	},
	{
		ID = 100005,
		Name = L"Container3",
		Desc = L"The slot is in the 3rd container(from the right)",
		Condition = "(bag == 3)",
	},
	{
		ID = 100006,
		Name = L"Container4",
		Desc = L"The slot is in the 4th container(from the right)",
		Condition = "(bag == 4)",
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
		Condition = "(equipSlot and equipSlot~='')",
	},
	{
		ID = 100013,
		Name = L"IsStackableItem",
		Desc = L"The slot has item, and the item is stackable",
		Condition = "(maxStack and maxStack > 1)"
	},
	{
		ID = 100014,
		Name = L"IsUsableItem",
		Desc = L"The slot has item, and the item can be used by right-click.",
		Condition = "itemSpell",
	},
	{
		ID = 200001,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY0_DESC"],
		Desc = L"The slot has item, and the item is poor(color gray)",
		Condition = "(quality == LE_ITEM_QUALITY_POOR)"
	},
	{
		ID = 200002,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY1_DESC"],
		Desc = L"The slot has item, and the item is common(color white)",
		Condition = "(quality == LE_ITEM_QUALITY_COMMON)"
	},
	{
		ID = 200003,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY2_DESC"],
		Desc = L"The slot has item, and the item is uncommon(color green)",
		Condition = "(quality == LE_ITEM_QUALITY_UNCOMMON)"
	},
	{
		ID = 200004,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY3_DESC"],
		Desc = L"The slot has item, and the item is rare(color blue)",
		Condition = "(quality == LE_ITEM_QUALITY_RARE)"
	},
	{
		ID = 200005,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY4_DESC"],
		Desc = L"The slot has item, and the item is epic(color purple)",
		Condition = "(quality == LE_ITEM_QUALITY_EPIC)"
	},
	{
		ID = 200006,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY5_DESC"],
		Desc = L"The slot has item, and the item is legendary(color orange)",
		Condition = "(quality == LE_ITEM_QUALITY_LEGENDARY)"
	},
	{
		ID = 200007,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY6_DESC"],
		Desc = L"The slot has item, and the item is artifact(color golden yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_ARTIFACT)"
	},
	{
		ID = 200008,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY7_DESC"],
		Desc = L"The slot has item, and the item is heirloom(color light yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_HEIRLOOM)"
	},
	{
		ID = 200009,
		Name = _G["RARITY"] .. "-" .. _G["ITEM_QUALITY8_DESC"],
		Desc = L"The slot has item, and the item is wow token(color light yellow)",
		Condition = "(quality == LE_ITEM_QUALITY_WOW_TOKEN)"
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
		Condition = ("(cls == %q)"):format(itemCls)
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
class "ContainerButton"
	inherit "ItemButton"
	extend "IFStyle"

	BAG_ITEM_QUALITY_COLORS = System.Reflector.Clone(BAG_ITEM_QUALITY_COLORS, true)
	LE_ITEM_QUALITY_COMMON = _G.LE_ITEM_QUALITY_COMMON

	-- Block parent's UpdateAction
	function UpdateAction(self) end

	__Handler__(function(self, val)
		if val then
			local itemID = GetContainerItemID(self.ActionTarget, self.ActionDetail)
			if IsArtifactRelicItem(itemID) then
				self.NormalTexturePath = [[Interface\Artifacts\RelicIconFrame]]
			else
				self.NormalTexturePath = Media.BORDER_TEXTURE_PATH
			end

			if val >= LE_ITEM_QUALITY_COMMON and BAG_ITEM_QUALITY_COLORS[val] then
				self.NormalTexture.VertexColor = BAG_ITEM_QUALITY_COLORS[val]
			else
				self.NormalTexture.VertexColor = Media.PLAYER_CLASS_COLOR
			end
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

	function ContainerButton(self, ...)
		Super(self, ...)

		self.ShowGrid = false
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

	function Container(self, name, ...)
		Super(self, name, ...)

		local prev, id = name:match("^(.*)(%d+)$")
		id = tonumber(id)

		self.Parent[id] = self
		self.ID = id

		if id == 1 then
			self:SetPoint("TOPLEFT", self.Parent.Parent, "BOTTOMLEFT", 2, -8)
		else
			self:SetPoint("TOPLEFT", self.Parent:GetChild(prev .. (id-1)), "BOTTOMLEFT")
		end

		self.ElementType = ContainerButton
		self.ElementPrefix = name .. "_IButton"

		self.RowCount = 20
		self.ColumnCount = 12
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

	local function buildRules(containerRules)
		if not containerRules or #containerRules == 0 then return nil end

		local codes = {}

		for i, containerRule in ipairs(containerRules) do
			if containerRule and #containerRule > 0 then
				for j, rules in ipairs(containerRule) do
					if rules and #rules > 0 then
						local cond = {}

						for k, rule in ipairs(rules) do
							if rule > 0 then
								tinsert(cond, _ItemConditions[rule].Condition)
							else
								tinsert(cond, "not " .. _ItemConditions[math.abs(rule)].Condition)
							end
						end

						cond = tconcat(cond, " and ")

						tinsert(codes, ("if %s then yield(%d, bag, slot) else"):format(cond, i))
					end
				end
			end
		end

		if #codes > 0 then tinsert(codes, " end") end

		codes = tconcat(codes, "") or "if true then return end"

		Debug(codes)

		codes = ([[
			return function()
				local yield = coroutine.yield
				local GetContainerItemInfo = GetContainerItemInfo
				local GetContainerItemQuestInfo = GetContainerItemQuestInfo
				local GetItemInfo = GetItemInfo
				local GetItemSpell = GetItemSpell

				for bag = 0, _G.NUM_BAG_FRAMES do
					for slot = 1, GetContainerNumSlots(bag) do
						local _, count, _, quality, readable, lootable, link, _, hasNoValue, itemID = GetContainerItemInfo(bag, slot)
						local isQuest, questId, isActive = GetContainerItemQuestInfo(bag, slot)
						local name, iLevel, reqLevel, cls, subclass, maxStack, equipSlot, vendorPrice
						local itemSpell

						if itemID then
							name, _, _, iLevel, reqLevel, cls, subclass, maxStack, equipSlot, _, vendorPrice = GetItemInfo(itemID)
							itemSpell = GetItemSpell(itemID)
						end

						%s
					end
				end
			end
		]]):format(codes)

		return loadstring(codes)()
	end

	__Delegate__(Task.NoCombatCall)
	function ApplyContainerRules(self, containerRules)
		local dispatch = buildRules(containerRules)

		local count = containerRules and #containerRules or 0
		local i = 1
		local container

		while i <= count do
			container = self:GetChild(self.ElementPrefix .. i) or Container(self.ElementPrefix .. i, self)
			container.Visible = true

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

		self.TaskMark = (self.TaskMark or 0) + 1

		if dispatch then
			Task.ThreadCall(function()
				local taskMark = self.TaskMark
				local containerCnt = {}

				while self.TaskMark == taskMark do
					if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
					if self.TaskMark ~= taskMark then break end

					Debug("Process @pid %d for %s", taskMark, self.Name)

					for i = 1, count do containerCnt[i] = 0 end

					for id, bag, slot in tpairs(dispatch) do
						containerCnt[id] = containerCnt[id] + 1
						local ele = self[id].Element[containerCnt[id]]
						if ele.ActionTarget ~= bag or ele.ActionDetail ~= slot then
							ele:SetAction("bagslot", bag, slot)
						end
					end

					for i = 1, count do
						self[i].Count = containerCnt[i]
					end

					Task.Event("BAG_UPDATE_DELAYED")
					Task.Continue()
				end

				Debug("Stop @pid %d for %s", taskMark, self.Name)
			end)
		end
	end

	function ContainerView(self, name, ...)
		Super(self, name, ...)

		self.ElementPrefix = name .. "_Container"

		self:SetSize(1, 1)

		self.Backdrop = _Backdrop
		self.BackdropBorderColor = Media.PLAYER_CLASS_COLOR
		self.BackdropColor = _BackColor

		self.FrameLevel = 3
	end
endclass "ContainerView"

class "ViewButton"
	inherit "SecureCheckButton"

	local function OnAttributeChanged(self, name, value)
		if name == "viewactive" then
			self.Checked = value

			if value then
				_ContainerDB.SelectedView = self.Text
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
		self.ContainerView.Visible = false

		self:SetFrameRef("ContainerView", self.ContainerView)
		self:SetFrameRef("ViewManager", self.Parent)

		self:SetAttribute("type", "viewchange")
		self:SetAttribute("_viewchange", [[self:GetFrameRef("ViewManager"):RunFor(self, "ViewManager:RunFor(self, ActiveView)")]])

		self.OnAttributeChanged = self.OnAttributeChanged + OnAttributeChanged
	end
endclass "ViewButton"

class "ContainerHeader"
	inherit "SecureFrame"
	extend "IFSecurePanel"

	local function OnElementRemove(self, viewBtn)
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

	function ApplyConfig(self, configs)
		self.Count = #configs

		for i, config in ipairs(configs) do
			self.Element[i].Text = config.Name
			self.Element[i].ContainerView:ApplyContainerRules(config.ContainerRules)
		end
	end

	function ContainerHeader(self, name, ...)
		Super(self, name, ...)

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

		self.RowCount = 5
		self.ColumnCount = 4
		self.ElementWidth = 106
		self.ElementHeight = 24

		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = true
		self.HSpacing = 2
		self.VSpacing = 2
		self.AutoSize = true
		self.KeepColumnSize = true

		self.MarginTop = 2
		self.MarginBottom = 30
		self.MarginLeft = 4
		self.MarginRight = 26

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
		self.OnElementRemove = self.OnElementRemove + OnElementRemove

		-- Search Box
		local searchBox = EditBox("SearchBox", self, "BagSearchBoxTemplate")
		searchBox:SetPoint("BOTTOMLEFT", 8, 4)
		searchBox:SetSize(160, 24)
		searchBox = IGAS:GetUI(searchBox)
		searchBox.Left:Hide()
		searchBox.Right:Hide()
		searchBox.Middle:Hide()

		-- money frame
		local moneyFrame = CreateFrame("Frame", "IGAS_UI_MoneyFrame", self, "SmallMoneyFrameTemplate")
		moneyFrame:SetPoint("BOTTOMRIGHT", -2, 8)
	end
endclass "ContainerHeader"