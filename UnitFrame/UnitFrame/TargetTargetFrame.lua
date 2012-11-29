-----------------------------------------
-- TargetTarget Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmTargetTarget = iUnitFrame("IGAS_UI_TargetTargetFrame")
frmTargetTarget:SetPoint("TOPLEFT", 380, -50)
frmTargetTarget.Unit = "targettarget"

frmTargetTarget:SetSize(160, 36)

-- Portrait
frmTargetTarget:AddElement(Unit3DPortrait, "east", 36, "px")

-- Power Bar
frmTargetTarget:AddElement(iPowerBar, "south", 8, "px")

-- Health Bar
frmTargetTarget:AddElement(iHealthBar, "rest")

-- Unit Name
frmTargetTarget:AddElement(NameLabel)
frmTargetTarget.NameLabel.UseClassColor = true
frmTargetTarget.NameLabel:SetPoint("TOPLEFT", frmTargetTarget.iHealthBar, "TOPLEFT")
frmTargetTarget.NameLabel:SetPoint("TOPRIGHT", frmTargetTarget.iHealthBar, "TOPRIGHT")

-- Border Color
frmTargetTarget:AddElement(iBorderColor)

-- Debuff Panel
frmTargetTarget:AddElement(iDebuffPanel)
frmTargetTarget.iDebuffPanel:SetPoint("TOPRIGHT", frmTargetTarget.Panel, "BOTTOMRIGHT")

arUnit:Insert(frmTargetTarget)

-----------------------------------------
-- Script Handler
-----------------------------------------
frmTargetTarget.OnSizeChanged = frmTargetTarget.OnSizeChanged + function(self)
	self:AddElement(Unit3DPortrait, "east", self.Height, "px")
end
