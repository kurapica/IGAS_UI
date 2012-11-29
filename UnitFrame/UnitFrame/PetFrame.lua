-----------------------------------------
-- Pet Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPet = iUnitFrame("IGAS_UI_PetFrame")
frmPet:SetPoint("TOPLEFT", 180, -50)
frmPet.Unit = "pet"

frmPet:SetSize(160, 36)

-- Portrait
frmPet:AddElement(Unit3DPortrait, "west", 36, "px")

-- Power Bar
frmPet:AddElement(iPowerBar, "south", 8, "px")
frmPet:AddElement(PowerTextFrequent)
frmPet.PowerTextFrequent:SetPoint("RIGHT", frmPet.iPowerBar, "RIGHT")
frmPet.PowerTextFrequent.Visible = false

-- Health Bar
frmPet:AddElement(iHealthBar, "rest")
frmPet:AddElement(HealthTextFrequent)
frmPet.HealthTextFrequent:SetPoint("RIGHT", frmPet.iHealthBar, "RIGHT")
frmPet.HealthTextFrequent.ShowLost = true
frmPet.HealthTextFrequent:SetVertexColor(1, 0, 0)

-- Unit Name
frmPet:AddElement(NameLabel)
frmPet.NameLabel:SetPoint("TOPLEFT", frmPet.iHealthBar, "TOPLEFT")
frmPet.NameLabel:SetPoint("TOPRIGHT", frmPet.iHealthBar, "TOPRIGHT")

-- Border Color
frmPet:AddElement(iBorderColor)

-- Buff Panel
frmPet:AddElement(iBuffPanel)
frmPet.iBuffPanel:SetPoint("TOPLEFT", frmPet.Panel, "BOTTOMLEFT")

-- Debuff Panel
frmPet:AddElement(iDebuffPanel)
frmPet.iDebuffPanel:SetPoint("TOPRIGHT", frmPet.Panel, "BOTTOMRIGHT")

arUnit:Insert(frmPet)

-----------------------------------------
-- Script Handler
-----------------------------------------
frmPet.OnSizeChanged = frmPet.OnSizeChanged + function(self)
	self:AddElement(Unit3DPortrait, "west", self.Height, "px")
end

function frmPet:OnEnter()
	if not InCombatLockdown() then
		self.HealthTextFrequent.ShowMax = true
		self.HealthTextFrequent.ShowLost = false
		self.PowerTextFrequent.Visible = true
		self.HealthTextFrequent:SetVertexColor(1, 1, 1)
	end
end

function frmPet:OnLeave()
	self.HealthTextFrequent.ShowMax = false
	self.HealthTextFrequent.ShowLost = true
	self.PowerTextFrequent.Visible = false
	self.HealthTextFrequent:SetVertexColor(1, 0, 0)
end