-----------------------------------------
-- Focus Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmFocus = iUnitFrame("IGAS_UI_FocusFrame")
frmFocus:SetPoint("TOPLEFT", 480, 0)
frmFocus.Unit = "focus"

frmFocus:SetSize(160, 36)

-- Portrait
frmFocus:AddElement(Unit3DPortrait, "east", 36, "px")

-- Cast Bar
frmFocus:AddElement(iCastBar, "south", 12, "px")

-- Power Bar
frmFocus:AddElement(iPowerBar, "south", 8, "px")
frmFocus:AddElement(PowerTextFrequent)
frmFocus.PowerTextFrequent:SetPoint("RIGHT", frmFocus.iPowerBar, "RIGHT")
frmFocus.PowerTextFrequent.Visible = false

-- Health Bar
frmFocus:AddElement(iHealthBar, "rest")
frmFocus:AddElement(HealthTextFrequent)
frmFocus.HealthTextFrequent:SetPoint("RIGHT", frmFocus.iHealthBar, "RIGHT")
frmFocus.HealthTextFrequent.ShowLost = true
frmFocus.HealthTextFrequent:SetVertexColor(1, 0, 0)

-- Unit Name
frmFocus:AddElement(NameLabel)
frmFocus.NameLabel.UseClassColor = true
frmFocus.NameLabel:SetPoint("TOPLEFT", frmFocus.iHealthBar, "TOPLEFT")
frmFocus.NameLabel:SetPoint("TOPRIGHT", frmFocus.iHealthBar, "TOPRIGHT")

-- Border Color
frmFocus:AddElement(iBorderColor)

-- Buff Panel
frmFocus:AddElement(iBuffPanel)
frmFocus.iBuffPanel:SetPoint("TOPLEFT", frmFocus.Panel, "BOTTOMLEFT")

-- Debuff Panel
frmFocus:AddElement(iDebuffPanel)
frmFocus.iDebuffPanel:SetPoint("TOPRIGHT", frmFocus.Panel, "BOTTOMRIGHT")

arUnit:Insert(frmFocus)

-----------------------------------------
-- Script Handler
-----------------------------------------
frmFocus.OnSizeChanged = frmFocus.OnSizeChanged + function(self)
	self:AddElement(Unit3DPortrait, "east", self.Height, "px")
end

function frmFocus:OnEnter()
	if not InCombatLockdown() then
		self.HealthTextFrequent.ShowMax = true
		self.HealthTextFrequent.ShowLost = false
		self.PowerTextFrequent.Visible = true
		self.HealthTextFrequent:SetVertexColor(1, 1, 1)
	end
end

function frmFocus:OnLeave()
	self.HealthTextFrequent.ShowMax = false
	self.HealthTextFrequent.ShowLost = true
	self.PowerTextFrequent.Visible = false
	self.HealthTextFrequent:SetVertexColor(1, 0, 0)
end