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

raidPanelMask = Mask("Mask", raidPanel)
raidPanelMask.AsMove = true

raidPetPanel = PetUnitPanel("IGAS_UI_RAIDPETPANEL")
raidPetPanel:SetPoint("TOPLEFT", raidPanel, "TOPRIGHT", 3, 0)
raidPetPanel.ElementType = iRaidUnitFrame
raidPetPanel.ElementPrefix = "iRaidPetUnitFrame"
raidPetPanel.VSpacing = 3
raidPetPanel.HSpacing = 3

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

-- Show ->
showRaid = raidPanelConfig:AddMenuButton(L"Show", L"Show in a raid")
showRaid.IsCheckButton = true
showRaid.ConfigName = "ShowRaid"
raidpanelPropArray:Insert(showRaid)

showParty = raidPanelConfig:AddMenuButton(L"Show", L"Show in a party")
showParty.IsCheckButton = true
showParty.ConfigName = "ShowParty"
raidpanelPropArray:Insert(showParty)

showPlayer = raidPanelConfig:AddMenuButton(L"Show", L"Show the player in party")
showPlayer.IsCheckButton = true
showPlayer.ConfigName = "ShowPlayer"
raidpanelPropArray:Insert(showPlayer)

showSolo = raidPanelConfig:AddMenuButton(L"Show", L"Show when solo")
showSolo.IsCheckButton = true
showSolo.ConfigName = "ShowSolo"
raidpanelPropArray:Insert(showSolo)

raidPanelConfig:GetMenuButton(L"Show").DropDownList.MultiSelect = true

-- Group ->
for _, v in ipairs(System.Reflector.GetEnums(IFGroup.GroupType)) do
	local groupBy = raidPanelConfig:AddMenuButton(L"Group By", L[v])
	groupBy.IsCheckButton = true
	groupBy.ConfigName = "GroupBy"
	groupBy.ConfigValue = v
	raidpanelPropArray:Insert(groupBy)
end

raidPanelConfig:GetMenuButton(L"Group By").DropDownList.MultiSelect = false

-- Sort ->
for _, v in ipairs(System.Reflector.GetEnums(IFGroup.SortType)) do
	local sortBy = raidPanelConfig:AddMenuButton(L"Sort By", L[v])
	sortBy.IsCheckButton = true
	sortBy.ConfigName = "SortBy"
	sortBy.ConfigValue = v
	raidpanelPropArray:Insert(sortBy)
end

raidPanelConfig:GetMenuButton(L"Sort By").DropDownList.MultiSelect = false

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