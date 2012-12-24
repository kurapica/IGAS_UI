-----------------------------------------
-- Focus Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmFocus = iUnitFrame("IGAS_UI_FocusFrame")
frmFocus:SetPoint("TOPLEFT", 20, -40)
frmFocus:SetSize(160, 24)
frmFocus.Unit = "focus"

-- Buff Panel
frmFocus:AddElement(iBuffPanel)
frmFocus.iBuffPanel:SetPoint("BOTTOMLEFT", frmFocus, "TOPLEFT", 0, 4)

-- Debuff Panel
frmFocus:AddElement(iDebuffPanel)
frmFocus.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmFocus, "TOPRIGHT", 0, 4)

-- NameLabel
frmFocus.NameLabel.UseTapColor = true

frmFocus:SetAttribute("shift-type1", "macro")
frmFocus:SetAttribute("shift-macrotext1", "/clearfocus")