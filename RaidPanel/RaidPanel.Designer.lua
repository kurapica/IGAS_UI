IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Designer for RaidPanel
--==========================

SPELLS_PER_PAGE = _G.SPELLS_PER_PAGE

chkMode = CheckBox("IGASUI_BindingMode", SpellBookFrame)
chkMode:SetPoint("TOPRIGHT", -16, -32)
chkMode.Text = L"Spell Binding"
chkMode.Checked = false

Masks = Array(BindingButton)

for i = 1, SPELLS_PER_PAGE do
	Masks:Insert(BindingButton("SpellBindingMask", _G["SpellButton"..i]))
end

raidPanel = iUnitPanel("IGAS_UI_RAIDPANEL")
raidPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -300)
raidPanel.ElementPrefix = "iRaidUnitFrame"
raidPanel.FrameLevel = 0

raidPanelMask = Mask("Mask", raidPanel)
raidPanelMask.AsMove = true

raidPetPanel = iPetUnitPanel("IGAS_UI_RAIDPETPANEL")
raidPetPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")
raidPetPanel.ElementPrefix = "iRaidPetUnitFrame"
raidPetPanel.FrameLevel = 0

raidDeadPanel = iUnitPanel("IGAS_UI_DEADPANEL")
raidDeadPanel:SetPoint("TOPLEFT", raidPetPanel, "BOTTOMLEFT")
raidDeadPanel.Stype = "Dead"
raidDeadPanel.ElementPrefix = "iRaidDeadUnitFrame"
raidDeadPanel.ShowDeadOnly = true
raidDeadPanel.FrameLevel = 0

raidUnitWatchPanel = iUnitWatchPanel("IGAS_UI_UNITWATCHPANEL")
raidUnitWatchPanel:SetPoint("BOTTOMLEFT", raidPanel, "TOPLEFT")
raidUnitWatchPanel.ElementPrefix = "iUnitWatchFrame"
raidUnitWatchPanel.AutoSize = true
raidUnitWatchPanel.AutoPosition = true
raidUnitWatchPanel.TopToBottom = false
raidUnitWatchPanel.FrameLevel = 0

-- withPanel
withPanel = Frame("IGASUI_Withpanel", SpellBookFrame)
withPanel.Visible = false
withPanel:SetSize(84, 50)

withPanel:SetBackdrop{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 9,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

withPanel:SetBackdropColor(0.2, 0.2, 0.2)

chkTarget = CheckBox("ChkTarget", withPanel)
chkTarget:SetPoint("LEFT", 2)
chkTarget:SetPoint("TOP")
chkTarget.Text = "Target"

chkFocus = CheckBox("ChkFocus", withPanel)
chkFocus:SetPoint("LEFT", 2)
chkFocus:SetPoint("TOP", chkTarget, "BOTTOM")
chkFocus.Text = "Focus"

--------------------------
-- Raid panel's config menu
--------------------------
raidPanelConfig = DropDownList("Menu", raidPanel)
raidPanelConfig.MultiSelect = true
raidPanelConfig.ShowOnCursor = false
raidPanelConfig.AutoHide = false

raidPanelConfig:SetPoint("TOPLEFT", raidPanel, "TOPRIGHT")

raidpanelMenuArray = Array(DropDownList.DropDownMenuButton)

--------------------------
-- UnitPanel settings
--------------------------
raidpanelPropArray = Array(DropDownList.DropDownMenuButton)

-- Element Size
mnuRaidPanelSetWidth = raidPanelConfig:AddMenuButton(L"Element Settings", "Width")
mnuRaidPanelSetHeight = raidPanelConfig:AddMenuButton(L"Element Settings", "Height")
mnuRaidPanelSetPowerHeight = raidPanelConfig:AddMenuButton(L"Element Settings", "PowerHeight")
mnuRaidPanelSetUseClassColor = raidPanelConfig:AddMenuButton(L"Element Settings", L"Use Class Color")
mnuRaidPanelSetUseDebuffColor = raidPanelConfig:AddMenuButton(L"Element Settings", L"Use Debuff Color")
mnuRaidPanelSetUseSmoothColor = raidPanelConfig:AddMenuButton(L"Element Settings", L"Use Smoothing Color")
mnuRaidPanelSetUseDown = raidPanelConfig:AddMenuButton(L"Element Settings", L"Press down trigger")
mnuRaidPanelSetSmooth = raidPanelConfig:AddMenuButton(L"Element Settings", L"Smoothing updating")
mnuRaidPanelSetSmoothDelay = raidPanelConfig:AddMenuButton(L"Element Settings", L"Smoothing delay")
mnuRaidPanelMacroBind = raidPanelConfig:AddMenuButton(L"Element Settings", L"Macro Bindings")
mnuRaidPanelSetWidth:ActiveThread("OnClick")
mnuRaidPanelSetHeight:ActiveThread("OnClick")
mnuRaidPanelSetPowerHeight:ActiveThread("OnClick")
mnuRaidPanelSetUseClassColor.IsCheckButton = true
mnuRaidPanelSetUseDebuffColor.IsCheckButton = true
mnuRaidPanelSetUseSmoothColor.IsCheckButton = true
mnuRaidPanelSetUseDown.IsCheckButton = true
mnuRaidPanelSetSmooth.IsCheckButton = true
mnuRaidPanelSetSmoothDelay:ActiveThread("OnClick")

-- Activated
mnuRaidPanelActivated = raidPanelConfig:AddMenuButton(L"Raid panel", L"Activated")
mnuRaidPanelActivated.IsCheckButton = true

mnuRaidPetPanelActivated = raidPanelConfig:AddMenuButton(L"Pet panel", L"Activated")
mnuRaidPetPanelActivated.IsCheckButton = true

mnuRaidPetPanelDeactivateInRaid = raidPanelConfig:AddMenuButton(L"Pet panel", L"Deactivate in raid")
mnuRaidPetPanelDeactivateInRaid.IsCheckButton = true

mnuRaidDeadPanelActivated = raidPanelConfig:AddMenuButton(L"Dead panel", L"Activated")
mnuRaidDeadPanelActivated.IsCheckButton = true

-- Location
mnuRaidPetPanelLocationRight = raidPanelConfig:AddMenuButton(L"Pet panel", L"Location", L"Right")
mnuRaidPetPanelLocationRight.IsCheckButton = true

mnuRaidPetPanelLocationBottom = raidPanelConfig:AddMenuButton(L"Pet panel", L"Location", L"Bottom")
mnuRaidPetPanelLocationBottom.IsCheckButton = true

raidPanelConfig:GetMenuButton(L"Pet panel", L"Location").DropDownList.MultiSelect = false

-- UnitWatchPanel
mnuRaidUnitWatchList = raidPanelConfig:AddMenuButton(L"Unit watch panel", L"Modify unit list")
mnuRaidUnitwatchAutoLayout = raidPanelConfig:AddMenuButton(L"Unit watch panel", L"Auto layout")
mnuRaidUnitwatchAutoLayout.IsCheckButton = true
mnuRaidUnitwatchOnlyEnemy = raidPanelConfig:AddMenuButton(L"Unit watch panel", L"Only Enemy")
mnuRaidUnitwatchOnlyEnemy.IsCheckButton = true

-- Show ->
ShowProperty = {"ShowRaid", "ShowParty", "ShowPlayer", "ShowSolo"}
ShowLocale = {L"Show in a raid", L"Show in a party", L"Show the player in party", L"Show when solo",}

for i, v in ipairs(ShowProperty) do
	local show = raidPanelConfig:AddMenuButton(L"Raid panel", L"Show", ShowLocale[i])
	show.UnitPanel = raidPanel
	show.IsCheckButton = true
	show.ConfigName = v
	raidpanelPropArray:Insert(show)

	show = raidPanelConfig:AddMenuButton(L"Pet panel", L"Show", ShowLocale[i])
	show.UnitPanel = raidPetPanel
	show.IsCheckButton = true
	show.ConfigName = v
	raidpanelPropArray:Insert(show)

	show = raidPanelConfig:AddMenuButton(L"Dead panel", L"Show", ShowLocale[i])
	show.UnitPanel = raidDeadPanel
	show.IsCheckButton = true
	show.ConfigName = v
	raidpanelPropArray:Insert(show)
end

raidPanelConfig:GetMenuButton(L"Raid panel").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Pet panel").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Dead panel").DropDownList.MultiSelect = true

raidPanelConfig:GetMenuButton(L"Raid panel", L"Show").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Pet panel", L"Show").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Dead panel", L"Show").DropDownList.MultiSelect = true

ShowProperty = nil
ShowLocale = nil

-- Group ->
for v in System.Reflector.GetEnums(IFGroup.GroupType) do
	local groupBy = raidPanelConfig:AddMenuButton(L"Raid panel", L"Group By", L[v])
	groupBy.UnitPanel = raidPanel
	groupBy.IsCheckButton = true
	groupBy.ConfigName = "GroupBy"
	groupBy.ConfigValue = v
	raidpanelPropArray:Insert(groupBy)

	groupBy = raidPanelConfig:AddMenuButton(L"Pet panel", L"Group By", L[v])
	groupBy.UnitPanel = raidPetPanel
	groupBy.IsCheckButton = true
	groupBy.ConfigName = "GroupBy"
	groupBy.ConfigValue = v
	raidpanelPropArray:Insert(groupBy)

	groupBy = raidPanelConfig:AddMenuButton(L"Dead panel", L"Group By", L[v])
	groupBy.UnitPanel = raidDeadPanel
	groupBy.IsCheckButton = true
	groupBy.ConfigName = "GroupBy"
	groupBy.ConfigValue = v
	raidpanelPropArray:Insert(groupBy)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Group By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Group By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Dead panel", L"Group By").DropDownList.MultiSelect = false

-- Sort ->
for v in System.Reflector.GetEnums(IFGroup.SortType) do
	local sortBy = raidPanelConfig:AddMenuButton(L"Raid panel", L"Sort By", L[v])
	sortBy.UnitPanel = raidPanel
	sortBy.IsCheckButton = true
	sortBy.ConfigName = "SortBy"
	sortBy.ConfigValue = v
	raidpanelPropArray:Insert(sortBy)

	sortBy = raidPanelConfig:AddMenuButton(L"Pet panel", L"Sort By", L[v])
	sortBy.UnitPanel = raidPetPanel
	sortBy.IsCheckButton = true
	sortBy.ConfigName = "SortBy"
	sortBy.ConfigValue = v
	raidpanelPropArray:Insert(sortBy)

	sortBy = raidPanelConfig:AddMenuButton(L"Dead panel", L"Sort By", L[v])
	sortBy.UnitPanel = raidDeadPanel
	sortBy.IsCheckButton = true
	sortBy.ConfigName = "SortBy"
	sortBy.ConfigValue = v
	raidpanelPropArray:Insert(sortBy)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Sort By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Sort By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Dead panel", L"Sort By").DropDownList.MultiSelect = false

-- Orientation
for v in System.Reflector.GetEnums(Orientation) do
	local orientation = raidPanelConfig:AddMenuButton(L"Raid panel", L"Orientation", L[v])
	orientation.UnitPanel = raidPanel
	orientation.IsCheckButton = true
	orientation.ConfigName = "Orientation"
	orientation.ConfigValue = v
	raidpanelPropArray:Insert(orientation)

	orientation = raidPanelConfig:AddMenuButton(L"Pet panel", L"Orientation", L[v])
	orientation.UnitPanel = raidPetPanel
	orientation.IsCheckButton = true
	orientation.ConfigName = "Orientation"
	orientation.ConfigValue = v
	raidpanelPropArray:Insert(orientation)

	orientation = raidPanelConfig:AddMenuButton(L"Dead panel", L"Orientation", L[v])
	orientation.UnitPanel = raidDeadPanel
	orientation.IsCheckButton = true
	orientation.ConfigName = "Orientation"
	orientation.ConfigValue = v
	raidpanelPropArray:Insert(orientation)

	orientation = raidPanelConfig:AddMenuButton(L"Unit watch panel", L"Orientation", L[v])
	orientation.UnitPanel = raidUnitWatchPanel
	orientation.IsCheckButton = true
	orientation.ConfigName = "Orientation"
	orientation.ConfigValue = v
	raidpanelPropArray:Insert(orientation)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Dead panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Unit watch panel", L"Orientation").DropDownList.MultiSelect = false

-- Raid -> Filter -> Group
groupFilterArray = Array(DropDownList.DropDownMenuButton)

for i = 1, _G.NUM_RAID_GROUPS do
	local groupFilter = raidPanelConfig:AddMenuButton(L"Raid panel", L"Filter", L"GROUP", tostring(i))
	groupFilter.IsCheckButton = true
	groupFilter.FilterValue = i
	groupFilterArray:Insert(groupFilter)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Filter", L"GROUP").DropDownList.MultiSelect = true

-- Raid -> Filter -> Class
classFilterArray = Array(DropDownList.DropDownMenuButton)

for _, v in ipairs({
		"WARRIOR",
		"PALADIN",
		"HUNTER",
		"ROGUE",
		"PRIEST",
		"DEATHKNIGHT",
		"SHAMAN",
		"MAGE",
		"WARLOCK",
		"MONK",
		"DRUID",
		"DEMONHUNTER",
	}) do
	local classFilter = raidPanelConfig:AddMenuButton(L"Raid panel", L"Filter", L"CLASS", L[v])
	classFilter.IsCheckButton = true
	classFilter.FilterValue = v
	classFilterArray:Insert(classFilter)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Filter", L"CLASS").DropDownList.MultiSelect = true

-- Raid -> Filter -> Role
roleFilterArray = Array(DropDownList.DropDownMenuButton)

for _, v in ipairs({
		"MAINTANK",
		"MAINASSIST",
		"TANK",
		"HEALER",
		"DAMAGER",
		"NONE"
	}) do
	local roleFilter = raidPanelConfig:AddMenuButton(L"Raid panel", L"Filter", L"ROLE", L[v])
	roleFilter.IsCheckButton = true
	roleFilter.FilterValue = v
	roleFilterArray:Insert(roleFilter)
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Filter", L"ROLE").DropDownList.MultiSelect = true

-- Dead -> Filter -> Group
groupDeadFilterArray = Array(DropDownList.DropDownMenuButton)

for i = 1, _G.NUM_RAID_GROUPS do
	local groupFilter = raidPanelConfig:AddMenuButton(L"Dead panel", L"Filter", L"GROUP", tostring(i))
	groupFilter.IsCheckButton = true
	groupFilter.FilterValue = i
	groupDeadFilterArray:Insert(groupFilter)
end

raidPanelConfig:GetMenuButton(L"Dead panel", L"Filter", L"GROUP").DropDownList.MultiSelect = true

-- Dead -> Filter -> Class
classDeadFilterArray = Array(DropDownList.DropDownMenuButton)

for _, v in ipairs({
		"WARRIOR",
		"PALADIN",
		"HUNTER",
		"ROGUE",
		"PRIEST",
		"DEATHKNIGHT",
		"SHAMAN",
		"MAGE",
		"WARLOCK",
		"MONK",
		"DRUID",
		"DEMONHUNTER",
	}) do
	local classFilter = raidPanelConfig:AddMenuButton(L"Dead panel", L"Filter", L"CLASS", L[v])
	classFilter.IsCheckButton = true
	classFilter.FilterValue = v
	classDeadFilterArray:Insert(classFilter)
end

raidPanelConfig:GetMenuButton(L"Dead panel", L"Filter", L"CLASS").DropDownList.MultiSelect = true

-- Dead -> Filter -> Role
roleDeadFilterArray = Array(DropDownList.DropDownMenuButton)

for _, v in ipairs({
		"MAINTANK",
		"MAINASSIST",
		"TANK",
		"HEALER",
		"DAMAGER",
		"NONE"
	}) do
	local roleFilter = raidPanelConfig:AddMenuButton(L"Dead panel", L"Filter", L"ROLE", L[v])
	roleFilter.IsCheckButton = true
	roleFilter.FilterValue = v
	roleDeadFilterArray:Insert(roleFilter)
end

raidPanelConfig:GetMenuButton(L"Dead panel", L"Filter", L"ROLE").DropDownList.MultiSelect = true

-- Aura Panels
auraPanelCheckArray = Array(DropDownList.DropDownMenuButton)
auraPanelSizeArray = Array(DropDownList.DropDownMenuButton)
auraPanelSizeArray:ActiveThread("OnClick")

for i, name in ipairs{L"Buff Panel", L"Debuff Panel", L"Class Buff Panel"} do
	local baseName = "mnu" .. (i==1 and "Buff" or i == 2 and "Debuff" or "ClassBuff")
	local set = i==1 and "BuffPanelSet" or i == 2 and "DebuffPanelSet" or "ClassBuffPanelSet"

	for j = 1, 4 do
		_M[baseName .. "ColumnCount" .. j] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Column Count", tostring(j))
		_M[baseName .. "RowCount" .. j] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Row Count", tostring(j))

		_M[baseName .. "ColumnCount" .. j].IsCheckButton = true
		_M[baseName .. "RowCount" .. j].IsCheckButton = true

		_M[baseName .. "ColumnCount" .. j].ConfigName = "ColumnCount"
		_M[baseName .. "ColumnCount" .. j].ConfigValue = j
		_M[baseName .. "ColumnCount" .. j].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "ColumnCount" .. j])

		_M[baseName .. "RowCount" .. j].ConfigName = "RowCount"
		_M[baseName .. "RowCount" .. j].ConfigValue = j
		_M[baseName .. "RowCount" .. j].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "RowCount" .. j])
	end
	raidPanelConfig:GetMenuButton(L"Element Settings", name, L"Column Count").DropDownList.MultiSelect = false
	raidPanelConfig:GetMenuButton(L"Element Settings", name, L"Row Count").DropDownList.MultiSelect = false

	_M[baseName .. "AuraSize"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, "AuraSize")
	_M[baseName .. "AuraSize"]:ActiveThread("OnClick")
	_M[baseName .. "AuraSize"].ConfigSet = set
	auraPanelSizeArray:Insert(_M[baseName .. "AuraSize"])

	for v in System.Reflector.GetEnums(Orientation) do
		_M[baseName .. "Orientation_" .. v] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Orientation", L[v])
		_M[baseName .. "Orientation_" .. v].IsCheckButton = true
		_M[baseName .. "Orientation_" .. v].ConfigName = "Orientation"
		_M[baseName .. "Orientation_" .. v].ConfigValue = v
		_M[baseName .. "Orientation_" .. v].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "Orientation_" .. v])
	end
	raidPanelConfig:GetMenuButton(L"Element Settings", name, L"Orientation").DropDownList.MultiSelect = false

	for v in System.Reflector.GetEnums(FramePoint) do
		_M[baseName .. "Loc_" .. v] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Location", L[v])
		_M[baseName .. "Loc_" .. v].IsCheckButton = true
		_M[baseName .. "Loc_" .. v].ConfigName = "Location"
		_M[baseName .. "Loc_" .. v].ConfigValue = { AnchorPoint(v, 0, 0, "iHealthBar") }
		_M[baseName .. "Loc_" .. v].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "Loc_" .. v])
	end
	raidPanelConfig:GetMenuButton(L"Element Settings", name, L"Location").DropDownList.MultiSelect = false

	_M[baseName .. "TopToBottom"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Top to Bottom")
	_M[baseName .. "TopToBottom"].IsCheckButton = true
	_M[baseName .. "TopToBottom"].ConfigName = "TopToBottom"
	_M[baseName .. "TopToBottom"].IsToggle = true
	_M[baseName .. "TopToBottom"].ConfigSet = set
	auraPanelCheckArray:Insert(_M[baseName .. "TopToBottom"])

	_M[baseName .. "LeftToRight"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Left to Right")
	_M[baseName .. "LeftToRight"].IsCheckButton = true
	_M[baseName .. "LeftToRight"].ConfigName = "LeftToRight"
	_M[baseName .. "LeftToRight"].IsToggle = true
	_M[baseName .. "LeftToRight"].ConfigSet = set
	auraPanelCheckArray:Insert(_M[baseName .. "LeftToRight"])

	_M[baseName .. "ShowTooltip"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Show tooltip")
	_M[baseName .. "ShowTooltip"].IsCheckButton = true
	_M[baseName .. "ShowTooltip"].ConfigName = "ShowTooltip"
	_M[baseName .. "ShowTooltip"].IsToggle = true
	_M[baseName .. "ShowTooltip"].ConfigSet = set
	auraPanelCheckArray:Insert(_M[baseName .. "ShowTooltip"])

	if i <= 2 then
		_M[baseName .. "RightRemove"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Alt+Right-click to black list")
		_M[baseName .. "RightRemove"].IsCheckButton = true
		_M[baseName .. "RightRemove"].ConfigName = "RightRemove"
		_M[baseName .. "RightRemove"].IsToggle = true
		_M[baseName .. "RightRemove"].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "RightRemove"])
	else
		_M[baseName .. "ShowOnPlayer"] = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Show on player")
		_M[baseName .. "ShowOnPlayer"].IsCheckButton = true
		_M[baseName .. "ShowOnPlayer"].ConfigName = "ShowOnPlayer"
		_M[baseName .. "ShowOnPlayer"].IsToggle = true
		_M[baseName .. "ShowOnPlayer"].ConfigSet = set
		auraPanelCheckArray:Insert(_M[baseName .. "ShowOnPlayer"])
	end

	raidPanelConfig:GetMenuButton(L"Element Settings", name).DropDownList.MultiSelect = true

	if i == 1 then
		mnuRaidPanelBuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Black List")

		function mnuRaidPanelBuffFilter:OnClick()
			iBuffFilter.Visible = true
		end

		mnuRaidPanelBuffOrder = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Buff Order List")

		function mnuRaidPanelBuffOrder:OnClick()
			iBuffOrder.Visible = true
		end
	elseif i == 2 then
		mnuRaidPanelDebuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"Black list")

		function mnuRaidPanelDebuffFilter:OnClick()
			iDebuffFilter.Visible = true
		end
	elseif i == 3 then
		mnuRaidPanelClassBuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", name, L"ClassBuff List")

		function mnuRaidPanelClassBuffFilter:OnClick()
			iClassBuffFilter.Visible = true
		end
	end
end

-- Buff filter
iBuffFilter = Form("IGAS_UI_IBuffFilter")
iBuffFilter.Caption = L"Black list"
iBuffFilter.Message = L"Double click to remove"
iBuffFilter.Resizable = false
iBuffFilter:SetSize(300, 400)
iBuffFilter.Visible = false

iBuffBlackList = List("BlackList", iBuffFilter)
iBuffBlackList:SetPoint("TOPLEFT", 4, -26)
iBuffBlackList:SetPoint("BOTTOMRIGHT", -4, 26)
iBuffBlackList.ShowTooltip = true

function iBuffFilter:OnShow()
	iBuffBlackList:SuspendLayout()

	iBuffBlackList:Clear()

	for spellID in pairs(_BuffBlackList) do
		local name, _, icon = GetSpellInfo(spellID)

		iBuffBlackList:AddItem(spellID, name, icon)
	end

	iBuffBlackList:ResumeLayout()
end

function iBuffBlackList:OnItemDoubleClick(spellID, name, icon)
	self:RemoveItem(spellID)
	_BuffBlackList[spellID] = nil
end

function iBuffBlackList:OnGameTooltipShow(GameTooltip, spellID)
	GameTooltip:SetSpellByID(spellID)
end

-- Debuff filter
iDebuffFilter = Form("IGAS_UI_IDebuffFilter")
iDebuffFilter.Caption = L"Black list"
iDebuffFilter.Message = L"Double click to remove"
iDebuffFilter.Resizable = false
iDebuffFilter:SetSize(300, 400)
iDebuffFilter.Visible = false

iDebuffBlackList = List("BlackList", iDebuffFilter)
iDebuffBlackList:SetPoint("TOPLEFT", 4, -26)
iDebuffBlackList:SetPoint("BOTTOMRIGHT", -4, 26)
iDebuffBlackList.ShowTooltip = true

function iDebuffFilter:OnShow()
	iDebuffBlackList:SuspendLayout()

	iDebuffBlackList:Clear()

	for spellID in pairs(_DebuffBlackList) do
		local name, _, icon = GetSpellInfo(spellID)

		iDebuffBlackList:AddItem(spellID, name, icon)
	end

	iDebuffBlackList:ResumeLayout()
end

function iDebuffBlackList:OnItemDoubleClick(spellID, name, icon)
	self:RemoveItem(spellID)
	_DebuffBlackList[spellID] = nil
end

function iDebuffBlackList:OnGameTooltipShow(GameTooltip, spellID)
	GameTooltip:SetSpellByID(spellID)
end

-- ClassBuff filter
iClassBuffFilter = Form("IGAS_UI_IClassBuffFilter")
iClassBuffFilter.Caption = L"ClassBuff List"
iClassBuffFilter.Message = L"The buff would be shown follow the order"
iClassBuffFilter.Resizable = false
iClassBuffFilter:SetSize(300, 400)
iClassBuffFilter.Visible = false

iClassBuffList = List("BuffList", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 4, -26),
		AnchorPoint("BOTTOMRIGHT", -4, 26),
	},
	ShowTooltip = true,

	OnShow = function(self)
		iClassBuffList:SuspendLayout()

		iClassBuffList:Clear()

		for _, spellID in ipairs(_ClassBuffList) do
			local name, _, icon = GetSpellInfo(spellID)

			iClassBuffList:AddItem(spellID, name or spellID, icon or "")
		end

		iClassBuffList:ResumeLayout()
	end,

	OnHide = function(self)
		BuildClassBuffMap()
	end,

	OnGameTooltipShow = function(self, GameTooltip, spellID)
		if tonumber(spellID) then
			GameTooltip:SetSpellByID(spellID)
		else
			local _, _, _, _, _, _, id = GetSpellInfo(spellID)
			if id then
				GameTooltip:SetSpellByID(id)
			end
		end
	end,
}

iClassBuffAdd = NormalButton("Add2List", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "BuffList", "BOTTOMLEFT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = "+",
	OnClick = function()
		local spell = IGAS:MsgBox(L"Please input the class buff's id or name", "ic")

		spell = tonumber(spell) or spell

		if spell then
			for _, v in ipairs(_ClassBuffList) do
				if v == spell then
					return iClassBuffList:SelectItemByValue(spell)
				end
			end

			local name, _, icon = GetSpellInfo(spell)

			tinsert(_ClassBuffList, spell)

			iClassBuffList:AddItem(spell, name or spell, icon or "")
		end
	end
}
iClassBuffAdd:ActiveThread("OnClick")

iClassBuffRemove = NormalButton("Remove4List", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Add2List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = "-",

	OnClick = function()
		local index = iClassBuffList.SelectedIndex
		if index > 0 and IGAS:MsgBox(L"Are you sure to delete the class buff", "c") then
			iClassBuffList:RemoveItemByIndex(index)
			tremove(_ClassBuffList, index)
		end
	end,
}
iClassBuffRemove:ActiveThread("OnClick")

iClassBuffUp = NormalButton("MoveUp", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Remove4List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = L"Up",
	OnClick = function()
		local index = iClassBuffList.SelectedIndex
		if index > 1 then
			_ClassBuffList[index], _ClassBuffList[index-1] = _ClassBuffList[index-1], _ClassBuffList[index]

			iClassBuffList.Keys[index], iClassBuffList.Keys[index-1] = iClassBuffList.Keys[index-1], iClassBuffList.Keys[index]
			iClassBuffList.Items[index], iClassBuffList.Items[index-1] = iClassBuffList.Items[index-1], iClassBuffList.Items[index]
			iClassBuffList.Icons[index], iClassBuffList.Icons[index-1] = iClassBuffList.Icons[index-1], iClassBuffList.Icons[index]
			iClassBuffList:Refresh()
			iClassBuffList.SelectedIndex = index - 1
		end
	end,
}

iClassBuffDown = NormalButton("MoveDown", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "MoveUp", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = L"Down",
	OnClick = function()
		local index = iClassBuffList.SelectedIndex
		if index > 0 and index < #_ClassBuffList then
			_ClassBuffList[index], _ClassBuffList[index+1] = _ClassBuffList[index+1], _ClassBuffList[index]

			iClassBuffList.Keys[index], iClassBuffList.Keys[index+1] = iClassBuffList.Keys[index+1], iClassBuffList.Keys[index]
			iClassBuffList.Items[index], iClassBuffList.Items[index+1] = iClassBuffList.Items[index+1], iClassBuffList.Items[index]
			iClassBuffList.Icons[index], iClassBuffList.Icons[index+1] = iClassBuffList.Icons[index+1], iClassBuffList.Icons[index]
			iClassBuffList:Refresh()
			iClassBuffList.SelectedIndex = index + 1
		end
	end,
}

iClassBuffExport = NormalButton("Export", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "MoveDown", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = L"Export",
	OnClick = function()
		local frm = Form("IGAS_UI_ClassBuff")
		frm.Caption = L"Export"
		frm.Visible = true

		local editor = CodeEditor("Editor", frm)
		editor:SetSize(300, 400)
		editor.Caption = L"Export"

		editor:SetPoint("TOPLEFT", 4, -26)
		editor:SetPoint("BOTTOMRIGHT", -4, 56)

		editor.Text = System.Serialization.Serialize(System.Serialization.StringFormatProvider{ Indent = true, IndentChar = "    " }, _ClassBuffList)

		local btn = NormalButton("Okay", frm)
		btn.Style = "Classic"
		btn:SetSize(40, 26)
		btn.Text = L"Close"
		btn:SetPoint("TOPRIGHT", editor, "BOTTOMRIGHT")
		btn.OnClick = function () frm:Hide() end
	end,
}

iClassBuffImport = NormalButton("Import", iClassBuffFilter) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Export", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 50,
	Style = "Classic",
	Text = L"Import",
	OnClick = function()
		local frm = Form("IGAS_UI_ClassBuff")
		frm.Caption = L"Import"
		frm.Visible = true

		local editor = CodeEditor("Editor", frm)
		editor:SetSize(300, 400)

		editor:SetPoint("TOPLEFT", 4, -26)
		editor:SetPoint("BOTTOMRIGHT", -4, 56)

		editor.Text = ""

		local btn = NormalButton("Okay", frm)
		btn.Style = "Classic"
		btn:SetSize(40, 26)
		btn.Text = L"Apply"
		btn:SetPoint("TOPRIGHT", editor, "BOTTOMRIGHT")
		btn.OnClick = function ()
			frm.Visible = false

			local ok, dt = pcall(System.Serialization.Deserialize, System.Serialization.StringFormatProvider(), editor.Text)
			if ok and type(dt) == "table" then
				wipe(_ClassBuffList)

				for _, v in ipairs(dt) do
					tinsert(_ClassBuffList, v)
				end

				return iClassBuffList:OnShow()
			else
				print(dt)
			end
		end
	end,
}

mnuRaidPanelModifyAnchors = raidPanelConfig:AddMenuButton(L"Element Settings", L"Modify AnchorPoints")
mnuRaidPanelModifyAnchors:ActiveThread("OnClick")

-- Unit List
frmUnitList = Form("IGAS_UI_UNITLIST") {
	Visible = false,
	Size = Size(200, 400),
	Caption = L"Unit List",
	Resizable = false,
}

helper = HTMLViewer("HTMLViewer", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, nil, "TOPRIGHT"),
		AnchorPoint("BOTTOMLEFT", 0, 0, nil, "BOTTOMRIGHT"),
	},
	Width = 400,
	Backdrop = {},
	Visible = false,
}

lstWatchUnit = List("WatchList", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 4, -26),
		AnchorPoint("BOTTOMRIGHT", -4, 26),
	},
}

btnAdd = NormalButton("Add2List", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "WatchList", "BOTTOMLEFT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = "+",
}

btnRemove = NormalButton("Remove4List", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Add2List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = "-",
}

btnUp = NormalButton("MoveUp", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Remove4List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = L"Up",
}

btnDown = NormalButton("MoveDown", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "MoveUp", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = L"Down",
}

btnInfo = NormalButton("Info", frmUnitList) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "MoveDown", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
		AnchorPoint("RIGHT"),
	},
	Style = "Classic",
	Text = "?",
}

btnAdd:ActiveThread("OnClick")
btnRemove:ActiveThread("OnClick")

--==========================
-- Macro Binding Panel
--==========================
frmMacroBindPanel = Form("IGAS_UI_MacroBindPanel")
frmMacroBindPanel.Visible = false
frmMacroBindPanel.Caption = L"Macro Bindings"

scrMacroBindPanel = ScrollForm("Scroll", frmMacroBindPanel)
scrMacroBindPanel:SetPoint("TOPLEFT", 4, -26)
scrMacroBindPanel:SetPoint("BOTTOMRIGHT", -4, 46)

conMacroBindPanel = scrMacroBindPanel.ScrollChild
conMacroBindPanel:SetPoint("LEFT")
conMacroBindPanel:SetPoint("RIGHT")

btnAddMacro = NormalButton("AddMacro", frmMacroBindPanel)
btnAddMacro.Height = 24
btnAddMacro.Width = 40
btnAddMacro:SetPoint("BOTTOMLEFT", 4, 24)
btnAddMacro.Style = "Classic"
btnAddMacro.Text = "+"

--==========================
-- Buff Order List
--==========================

-- Unit List
iBuffOrder = Form("IGAS_UI_BuffOrderList") {
	Visible = false,
	Size = Size(200, 400),
	Caption = L"Buff Order List",
	Resizable = false,

	OnShow = function(self)
		iBuffOrderList:SuspendLayout()

		iBuffOrderList:Clear()

		for _, spellID in ipairs(_BuffOrderList) do
			local name, _, icon = GetSpellInfo(spellID)

			iBuffOrderList:AddItem(spellID, name, icon)
		end

		iBuffOrderList:ResumeLayout()
	end,
}

iBuffOrderList = List("OrderList", iBuffOrder) {
	Location = {
		AnchorPoint("TOPLEFT", 4, -26),
		AnchorPoint("BOTTOMRIGHT", -4, 26),
	},

	OnItemDoubleClick = function(spellID, name, icon)
		self:RemoveItem(spellID)
		for i, v in ipairs(_BuffOrderList) do
			if v == spellID then
				return tremove(_BuffOrderList, i)
			end
		end
	end,

	OnGameTooltipShow = function(GameTooltip, spellID)
		GameTooltip:SetSpellByID(spellID)
	end,
}

btnBuffOrderAdd = NormalButton("Add2List", iBuffOrder) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "OrderList", "BOTTOMLEFT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = "+",

	OnClick = function(self)
		local spellID = IGAS:MsgBox(L"Please input the buff's spell id(you can get it in the game tip)", "ic")

		if spellID and strtrim(spellID) ~= "" then
			spellID = tonumber(strtrim(spellID))

			for _, v in ipairs(iBuffOrderList.Keys) do
				if v == spellID then return end
			end

			local name, _, icon = GetSpellInfo(spellID)

			if name then
				tinsert(_BuffOrderList, spellID)
				iBuffOrderList:AddItem(spellID, name, icon)
			end
		end
	end
}

btnBuffOrderRemove = NormalButton("Remove4List", iBuffOrder) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Add2List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = "-",

	OnClick = function(self)
		local index = iBuffOrderList.SelectedIndex
		if index > 0 then
			tremove(_BuffOrderList, index)
			iBuffOrderList:RemoveItemByIndex(index)
		end
	end
}

btnBuffOrderUp = NormalButton("MoveUp", iBuffOrder) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "Remove4List", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = L"Up",
	OnClick = function(self)
		local index = iBuffOrderList.SelectedIndex
		if index > 1 then
			local spellID = _BuffOrderList[index-1]
			local name, _, icon = GetSpellInfo(spellID)
			_BuffOrderList[index], _BuffOrderList[index-1] = _BuffOrderList[index-1], _BuffOrderList[index]
			iBuffOrderList:RemoveItemByIndex(index-1)
			iBuffOrderList:InsertItem(index, spellID, name, icon)
			iBuffOrderList.SelectedIndex = index - 1
		end
	end,
}

btnBuffOrderDown = NormalButton("MoveDown", iBuffOrder) {
	Location = {
		AnchorPoint("TOPLEFT", 0, 0, "MoveUp", "TOPRIGHT"),
		AnchorPoint("BOTTOM", 0, 4),
	},
	Width = 40,
	Style = "Classic",
	Text = L"Down",
	OnClick = function(self)
		local index = iBuffOrderList.SelectedIndex

		if index > 0 and index < #iBuffOrderList then
			local spellID = _BuffOrderList[index]
			local name, _, icon = GetSpellInfo(spellID)
			_BuffOrderList[index], _BuffOrderList[index+1] = _BuffOrderList[index+1], _BuffOrderList[index]
			iBuffOrderList:RemoveItemByIndex(index)
			iBuffOrderList:InsertItem(index+1, spellID, name, icon)
			iBuffOrderList.SelectedIndex = index + 1
		end
	end,
}

btnBuffOrderAdd:ActiveThread("OnClick")