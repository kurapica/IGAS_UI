-----------------------------------------
-- Target Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmTarget = iUnitFrame("IGAS_UI_TargetFrame")
frmTarget:SetPoint("TOPLEFT", 240, 0)
frmTarget.Unit = "target"

-- Portrait
frmTarget:AddElement(Unit3DPortrait, "east", 36, "px")

-- Cast Bar
frmTarget:AddElement(iCastBar, "south", 12, "px")

-- Power Bar
frmTarget:AddElement(iPowerBar, "south", 8, "px")
frmTarget:AddElement(PowerTextFrequent)
frmTarget.PowerTextFrequent:SetPoint("RIGHT", frmTarget.iPowerBar, "RIGHT")
frmTarget.PowerTextFrequent.Visible = false

-- Health Bar
frmTarget:AddElement(iHealthBar, "rest")
frmTarget:AddElement(HealthTextFrequent)
frmTarget.HealthTextFrequent:SetPoint("RIGHT", frmTarget.iHealthBar, "RIGHT")
frmTarget.HealthTextFrequent.ShowLost = true
frmTarget.HealthTextFrequent:SetVertexColor(1, 0, 0)

-- Unit Name
frmTarget:AddElement(iTargetName)
frmTarget.iTargetName.UseSelectionColor = true
frmTarget.iTargetName:SetPoint("TOPLEFT", frmTarget.iHealthBar, "TOPLEFT")
frmTarget.iTargetName:SetPoint("TOPRIGHT", frmTarget.iHealthBar, "TOPRIGHT")

-- Border Color
frmTarget:AddElement(iBorderColor)

-- Level
frmTarget:AddElement(LevelLabel)
frmTarget.LevelLabel:SetPoint("TOPLEFT")

-- Buff Panel
frmTarget:AddElement(iBuffPanel)
frmTarget.iBuffPanel:SetPoint("TOPLEFT", frmTarget.Panel, "BOTTOMLEFT", 0, 0)

-- Debuff Panel
frmTarget:AddElement(iDebuffPanel)
frmTarget.iDebuffPanel:SetPoint("TOPRIGHT", frmTarget.Panel, "BOTTOMRIGHT", 0, 0)

-- Combo
frmTarget:AddElement(ComboBar)
frmTarget.ComboBar:SetPoint("BOTTOM", frmTarget, "TOP")

-- QuestBoss Icon
frmTarget:AddElement(QuestBossIcon)
frmTarget.QuestBossIcon:SetPoint("CENTER", frmTarget, "LEFT")

arUnit:Insert(frmTarget)

-----------------------------------------
-- Script Handler
-----------------------------------------
frmTarget.OnSizeChanged = frmTarget.OnSizeChanged + function(self)
	self:AddElement(Unit3DPortrait, "east", self.Height, "px")
end

function frmTarget:OnEnter()
	if not InCombatLockdown() then
		self.HealthTextFrequent.ShowMax = true
		self.HealthTextFrequent.ShowLost = false
		self.PowerTextFrequent.Visible = true
		self.HealthTextFrequent:SetVertexColor(1, 1, 1)
	end
end

function frmTarget:OnLeave()
	self.HealthTextFrequent.ShowMax = false
	self.HealthTextFrequent.ShowLost = true
	self.PowerTextFrequent.Visible = false
	self.HealthTextFrequent:SetVertexColor(1, 0, 0)
end