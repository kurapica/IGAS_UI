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

raidPanelMask = Mask("Mask", raidPanel)
raidPanelMask.AsMove = true

raidPetPanel = iPetUnitPanel("IGAS_UI_RAIDPETPANEL")
raidPetPanel:SetPoint("TOPLEFT", raidPanel, "BOTTOMLEFT")
raidPetPanel.ElementPrefix = "iRaidPetUnitFrame"

raidDeadPanel = iUnitPanel("IGAS_UI_DEADPANEL")
raidDeadPanel:SetPoint("TOPLEFT", raidPetPanel, "BOTTOMLEFT")
raidDeadPanel.Stype = "Dead"
raidDeadPanel.ElementPrefix = "iRaidDeadUnitFrame"
raidDeadPanel.ShowDeadOnly = true

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
mnuRaidPanelSetWidth:ActiveThread("OnClick")
mnuRaidPanelSetHeight:ActiveThread("OnClick")
mnuRaidPanelSetPowerHeight:ActiveThread("OnClick")
mnuRaidPanelSetUseClassColor.IsCheckButton = true

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
end

raidPanelConfig:GetMenuButton(L"Raid panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Pet panel", L"Orientation").DropDownList.MultiSelect = false
raidPanelConfig:GetMenuButton(L"Dead panel", L"Orientation").DropDownList.MultiSelect = false

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
iDebuffBlackList.ShowTootip = true

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

-- Menu Settings
mnuRaidPanelDebuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", L"Debuff filter")

function mnuRaidPanelDebuffFilter:OnClick()
	iDebuffFilter.Visible = true
end

mnuRaidPanelDebuffRightMouseRemove = raidPanelConfig:AddMenuButton(L"Element Settings", L"Right mouse-click send debuff to black list")
mnuRaidPanelDebuffRightMouseRemove.IsCheckButton = true

mnuRaidPanelDebuffShowTooltip = raidPanelConfig:AddMenuButton(L"Element Settings", L"Show buff/debuff tootip")
mnuRaidPanelDebuffShowTooltip.IsCheckButton = true

function mnuRaidPanelDebuffRightMouseRemove:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DB.DebuffRightMouseRemove = self.Checked

		raidPanel:Each(function (self)
			self:GetElement(iDebuffPanel):Each("MouseEnabled", _DB.ShowDebuffTooltip or _DB.DebuffRightMouseRemove)
		end)
	end
end

function mnuRaidPanelDebuffShowTooltip:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DB.ShowDebuffTooltip = self.Checked

		raidPanel:Each(function (self)
			self:GetElement(iDebuffPanel):Each("ShowTooltip", _DB.ShowDebuffTooltip)
			self:GetElement(iDebuffPanel):Each("MouseEnabled", _DB.ShowDebuffTooltip or _DB.DebuffRightMouseRemove)

			if self:GetElement(iBuffPanel) then
				self:GetElement(iBuffPanel):Each("ShowTooltip", _DB.ShowDebuffTooltip)
			end
		end)
	end
end