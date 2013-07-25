-----------------------------------------
-- Designer for RaidPanel
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

SPELLS_PER_PAGE = _G.SPELLS_PER_PAGE

chkMode = CheckBox("IGASUI_BindingMode", SpellBookFrame)
chkMode:SetPoint("TOPRIGHT", -16, -32)
chkMode.Text = L"Spell Binding"
chkMode.Checked = false

Masks = Array(BindingButton)

for i = 1, SPELLS_PER_PAGE do
	Masks:Insert(BindingButton("SpellBindingMask", _G["SpellButton"..i]))
end

raidPanel = UnitPanel("IGAS_UI_RAIDPANEL")
raidPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -300)
raidPanel.ElementType = iRaidUnitFrame
raidPanel.ElementPrefix = "iRaidUnitFrame"
raidPanel.KeepMaxPlayer = true
raidPanel.VSpacing = 3
raidPanel.HSpacing = 3
raidPanel.MarginTop = 3
raidPanel.MarginBottom = 3
raidPanel.MarginLeft = 3
raidPanel.MarginRight = 3

raidPanelMask = Mask("Mask", raidPanel)
raidPanelMask.AsMove = true

raidPetPanel = PetUnitPanel("IGAS_UI_RAIDPETPANEL")
raidPetPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")
raidPetPanel.ElementType = iRaidUnitFrame
raidPetPanel.ElementPrefix = "iRaidPetUnitFrame"
raidPetPanel.VSpacing = 3
raidPetPanel.HSpacing = 3
raidPetPanel.MarginTop = 3
raidPetPanel.MarginBottom = 3
raidPetPanel.MarginLeft = 3
raidPetPanel.MarginRight = 3

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

-- Activated
mnuRaidPanelActivated = raidPanelConfig:AddMenuButton(L"Raid panel", L"Activated")
mnuRaidPanelActivated.IsCheckButton = true

mnuRaidPetPanelActivated = raidPanelConfig:AddMenuButton(L"Pet panel", L"Activated")
mnuRaidPetPanelActivated.IsCheckButton = true

mnuRaidPetPanelDeactivateInRaid = raidPanelConfig:AddMenuButton(L"Pet panel", L"Deactivate in raid")
mnuRaidPetPanelDeactivateInRaid.IsCheckButton = true

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
end

raidPanelConfig:GetMenuButton(L"Raid panel").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Pet panel").DropDownList.MultiSelect = true

raidPanelConfig:GetMenuButton(L"Raid panel", L"Show").DropDownList.MultiSelect = true
raidPanelConfig:GetMenuButton(L"Pet panel", L"Show").DropDownList.MultiSelect = true

ShowProperty = nil
ShowLocale = nil

-- Group ->
for _, v in ipairs(System.Reflector.GetEnums(IFGroup.GroupType)) do
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
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Group By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Group By").DropDownList.MultiSelect = false

-- Sort ->
for _, v in ipairs(System.Reflector.GetEnums(IFGroup.SortType)) do
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
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Sort By").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Sort By").DropDownList.MultiSelect = false

-- Orientation
for _, v in ipairs(System.Reflector.GetEnums(Orientation)) do
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
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Orientation").DropDownList.MultiSelect = false

--[[ Filter -> Group
groupFilterArray = Array(DropDownList.DropDownMenuButton)

for i = 1, _G.NUM_RAID_GROUPS do
	local groupFilter = raidPanelConfig:AddMenuButton(L"Filter", L"Group", tostring(i))
	groupFilter.IsCheckButton = true
	groupFilter.FilterValue = i
	groupFilterArray:Insert(groupFilter)
end

raidPanelConfig:GetMenuButton(L"Filter", L"Group").DropDownList.MultiSelect = true

-- Filter -> Class
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
	}) do
	local classFilter = raidPanelConfig:AddMenuButton(L"Filter", L"Class", L[v])
	classFilter.IsCheckButton = true
	classFilter.FilterValue = v
	classFilterArray:Insert(classFilter)
end

raidPanelConfig:GetMenuButton(L"Filter", L"Class").DropDownList.MultiSelect = true

-- Filter -> Role
roleFilterArray = Array(DropDownList.DropDownMenuButton)

for _, v in ipairs({
		"MAINTANK",
		"MAINASSIST",
		"TANK",
		"HEALER",
		"DAMAGER",
		"NONE"
	}) do
	local roleFilter = raidPanelConfig:AddMenuButton(L"Filter", L"Role", L[v])
	roleFilter.IsCheckButton = true
	roleFilter.FilterValue = v
	roleFilterArray:Insert(roleFilter)
end

raidPanelConfig:GetMenuButton(L"Filter", L"Role").DropDownList.MultiSelect = true
--]]