-----------------------------------------
-- Focus Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

for i = 1, 5 do
	frmBoss = iUnitFrame("IGAS_UI_BossFrame"..i)
	frmBoss:SetPoint("TOPLEFT", 640, - 36 * i)
	frmBoss.Unit = "boss"..i

	frmBoss:SetSize(160, 36)

	-- Portrait
	frmBoss:AddElement(Unit3DPortrait, "east", 36, "px")

	-- Cast Bar
	frmBoss:AddElement(iCastBar, "south", 12, "px")

	-- Power Bar
	frmBoss:AddElement(iPowerBar, "south", 8, "px")
	frmBoss:AddElement(PowerTextFrequent)
	frmBoss.PowerTextFrequent:SetPoint("RIGHT", frmBoss.iPowerBar, "RIGHT")
	frmBoss.PowerTextFrequent.Visible = false

	-- Health Bar
	frmBoss:AddElement(iHealthBar, "rest")
	frmBoss:AddElement(HealthTextFrequent)
	frmBoss.HealthTextFrequent:SetPoint("RIGHT", frmBoss.iHealthBar, "RIGHT")
	frmBoss.HealthTextFrequent.ShowLost = true
	frmBoss.HealthTextFrequent:SetVertexColor(1, 0, 0)

	-- Unit Name
	frmBoss:AddElement(NameLabel)
	frmBoss.NameLabel.UseClassColor = true
	frmBoss.NameLabel:SetPoint("TOPLEFT", frmBoss.iHealthBar, "TOPLEFT")
	frmBoss.NameLabel:SetPoint("TOPRIGHT", frmBoss.iHealthBar, "TOPRIGHT")

	-- Border Color
	frmBoss:AddElement(iBorderColor)

	-- Buff Panel
	frmBoss:AddElement(iBuffPanel)
	frmBoss.iBuffPanel:SetPoint("TOPLEFT", frmBoss.Panel, "BOTTOMLEFT")

	-- Debuff Panel
	frmBoss:AddElement(iDebuffPanel)
	frmBoss.iDebuffPanel:SetPoint("TOPRIGHT", frmBoss.Panel, "BOTTOMRIGHT")

	arUnit:Insert(frmBoss)

	-----------------------------------------
	-- Script Handler
	-----------------------------------------
	frmBoss.OnSizeChanged = frmBoss.OnSizeChanged + function(self)
		self:AddElement(Unit3DPortrait, "east", self.Height, "px")
	end

	function frmBoss:OnEnter()
		if not InCombatLockdown() then
			self.HealthTextFrequent.ShowMax = true
			self.HealthTextFrequent.ShowLost = false
			self.PowerTextFrequent.Visible = true
			self.HealthTextFrequent:SetVertexColor(1, 1, 1)
		end
	end

	function frmBoss:OnLeave()
		self.HealthTextFrequent.ShowMax = false
		self.HealthTextFrequent.ShowLost = true
		self.PowerTextFrequent.Visible = false
		self.HealthTextFrequent:SetVertexColor(1, 0, 0)
	end
end