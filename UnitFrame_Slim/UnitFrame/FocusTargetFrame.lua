-----------------------------------------
-- TargetTarget Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmFocusTarget = iSUnitFrame("IGAS_UI_FocusTargetFrame")
frmFocusTarget:SetPoint("TOPLEFT", 20, -70)
frmFocusTarget:SetSize(160, 24)
frmFocusTarget.Unit = "focustarget"

-- Debuff Panel
frmFocusTarget:AddElement(iDebuffPanel)
frmFocusTarget.iDebuffPanel:SetPoint("TOPRIGHT", frmFocusTarget, "BOTTOMRIGHT", 0, -4)
