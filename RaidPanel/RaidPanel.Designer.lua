-----------------------------------------
-- Designer for RaidPanel
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

import "System.Widget"

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
raidPanel.SortByRole = true
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
raidPetPanel.DeactivateInRaid = true

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