-----------------------------------------
-- TargetTarget Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmTargetTarget = iSUnitFrame("IGAS_UI_TargetTargetFrame")
frmTargetTarget:SetPoint("TOPLEFT", 420, -40)
frmTargetTarget:SetSize(160, 24)
frmTargetTarget.Unit = "targettarget"

-- Debuff Panel
frmTargetTarget:AddElement(iDebuffPanel)
frmTargetTarget.iDebuffPanel:SetPoint("TOPRIGHT", frmTargetTarget, "BOTTOMRIGHT", 0, -4)
