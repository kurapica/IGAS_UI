-----------------------------------------
-- TargetTarget Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmTargetTarget = iUnitFrame("IGAS_UI_TargetTargetFrame")
frmTargetTarget:SetPoint("TOPLEFT", 380, -50)
frmTargetTarget.Unit = "targettarget"

frmTargetTarget:SetSize(160, 36)

-- Debuff Panel
frmTargetTarget:AddElement(iDebuffPanel)
frmTargetTarget.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmTargetTarget, "TOPRIGHT", 0, 4)
