-----------------------------------------
-- Focus Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

for i = 1, 5 do
	frmBoss = iUnitFrame("IGAS_UI_BossFrame"..i)
	frmBoss:SetPoint("TOPLEFT", 640, - 36 * i)
	frmBoss.Unit = "boss"..i

	frmBoss:SetSize(160, 36)

	-- Buff Panel
	frmBoss:AddElement(iBuffPanel)
	frmBoss.iBuffPanel:SetPoint("BOTTOMLEFT", frmBoss, "TOPLEFT")

	-- Debuff Panel
	frmBoss:AddElement(iDebuffPanel)
	frmBoss.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmBoss, "TOPRIGHT")
end