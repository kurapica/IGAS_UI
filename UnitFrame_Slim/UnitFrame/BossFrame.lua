-----------------------------------------
-- Boss Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

for i = 1, 5 do
	frmBoss = iUnitFrame("IGAS_UI_BossFrame"..i)
	frmBoss:SetPoint("TOPLEFT", 600, - 64 * i)
	frmBoss:SetSize(200, 36)
	frmBoss.Unit = "boss"..i

	-- Target
	frmBoss:AddElement(RaidTargetIcon)
	frmBoss.RaidTargetIcon:SetPoint("CENTER", frmBoss, "TOP")

	-- Buff Panel
	frmBoss:AddElement(iBuffPanel)
	frmBoss.iBuffPanel:SetPoint("BOTTOMLEFT", frmBoss, "TOPLEFT", 0, 4)

	-- Debuff Panel
	frmBoss:AddElement(iDebuffPanel)
	frmBoss.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmBoss, "TOPRIGHT", 0, 4)
end