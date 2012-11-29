-----------------------------------------
-- Player Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPlayer = iUnitFrame("IGAS_UI_PlayerFrame")
frmPlayer:SetPoint("TOPLEFT")
frmPlayer.Unit = "player"

-- Portrait
frmPlayer:AddElement(Unit3DPortrait, "west", 36, "px")

-- Cast Bar
frmPlayer:AddElement(iCastBar, "south", 12, "px")

-- Hidden Mana Bar
frmPlayer:AddElement(iHiddenManaBar, "south", 8, "px")

-- Power Bar
frmPlayer:AddElement(iPowerBar, "south", 8, "px")
frmPlayer:AddElement(PowerTextFrequent)
frmPlayer.PowerTextFrequent:SetPoint("RIGHT", frmPlayer.iPowerBar, "RIGHT")
frmPlayer.PowerTextFrequent.Visible = false

-- Health Bar
frmPlayer:AddElement(iHealthBar, "rest")
frmPlayer:AddElement(HealthTextFrequent)
frmPlayer.HealthTextFrequent:SetPoint("RIGHT", frmPlayer.iHealthBar, "RIGHT")
frmPlayer.HealthTextFrequent.ShowLost = true
frmPlayer.HealthTextFrequent:SetVertexColor(1, 0, 0)

-- Unit Name
frmPlayer:AddElement(NameLabel)
frmPlayer.NameLabel.UseClassColor = true
frmPlayer.NameLabel:SetPoint("TOPLEFT", frmPlayer.iHealthBar, "TOPLEFT")
frmPlayer.NameLabel:SetPoint("TOPRIGHT", frmPlayer.iHealthBar, "TOPRIGHT")

-- Border Color
frmPlayer:AddElement(iBorderColor)

-- Level
frmPlayer:AddElement(LevelLabel)
frmPlayer.LevelLabel:SetPoint("TOPLEFT", frmPlayer.iHealthBar)

-- Class Power
if select(2, UnitClass("player")) == "PALADIN" then
	frmPlayer:AddElement(PaladinPowerBar)
	frmPlayer.PaladinPowerBar:SetPoint("TOP", frmPlayer, "BOTTOM")
elseif select(2, UnitClass("player")) == "PRIEST" then
	frmPlayer:AddElement(PriestPowerBar)
	frmPlayer.PriestPowerBar:SetPoint("TOP", frmPlayer, "BOTTOM")
elseif select(2, UnitClass("player")) == "MONK" then
	frmPlayer:AddElement(MonkPowerBar)
	frmPlayer.MonkPowerBar:SetPoint("TOP", frmPlayer, "BOTTOM", 0, 17)
elseif select(2, UnitClass("player")) == "DEATHKNIGHT" then
	frmPlayer:AddElement(RuneBar)
	frmPlayer.RuneBar:SetPoint("TOP", frmPlayer, "BOTTOM")
	frmPlayer.RuneBar.Scale = 1.4
elseif select(2, UnitClass("player")) == "DRUID" then
	frmPlayer:AddElement(EclipseBar)
	frmPlayer.EclipseBar:SetPoint("TOP", frmPlayer, "BOTTOM")
elseif select(2, UnitClass("player")) == "WARLOCK" then
	frmPlayer:AddElement(WarlockPowerBar)
	frmPlayer.WarlockPowerBar:SetPoint("TOP", frmPlayer, "BOTTOM")
end

-- Totem
frmPlayer:AddElement(TotemBar)
frmPlayer.TotemBar:SetPoint("BOTTOM", frmPlayer, "TOP")

-- Combat Icon
frmPlayer:AddElement(CombatIcon)
frmPlayer.CombatIcon:SetPoint("CENTER", frmPlayer, "TOPLEFT")

arUnit:Insert(frmPlayer)

-----------------------------------------
-- Script Handler
-----------------------------------------
frmPlayer.OnSizeChanged = frmPlayer.OnSizeChanged + function(self)
	self:AddElement(Unit3DPortrait, "west", self.Height, "px")
end

function frmPlayer:OnEnter()
	if not InCombatLockdown() then
		self.HealthTextFrequent.ShowMax = true
		self.HealthTextFrequent.ShowLost = false
		self.PowerTextFrequent.Visible = true
		self.HealthTextFrequent:SetVertexColor(1, 1, 1)
	end
end

function frmPlayer:OnLeave()
	self.HealthTextFrequent.ShowMax = false
	self.HealthTextFrequent.ShowLost = true
	self.PowerTextFrequent.Visible = false
	self.HealthTextFrequent:SetVertexColor(1, 0, 0)
end