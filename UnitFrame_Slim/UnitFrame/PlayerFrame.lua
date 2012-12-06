-----------------------------------------
-- Player Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPlayer = iUnitFrame("IGAS_UI_PlayerFrame")
frmPlayer:SetPoint("TOPLEFT")
frmPlayer.Unit = "player"

frmPlayer:InsertElement(frmPlayer.iPowerBar, iHiddenManaBar, "south", 2, "px")

-- Eclipse
if select(2, UnitClass("player")) == "DRUID" then
	frmPlayer:AddElement(EclipseBar)
	frmPlayer.EclipseBar:SetPoint("BOTTOM", frmPlayer, "TOP")
end

-- Class Power
frmPlayer:AddElement(iClassPower)
frmPlayer.iClassPower.Height = 4
frmPlayer.iClassPower:SetPoint("BOTTOMLEFT", frmPlayer, "TOPLEFT", 0, 4)
frmPlayer.iClassPower:SetPoint("BOTTOMRIGHT", frmPlayer, "TOPRIGHT", 0, 4)

-- Totem
frmPlayer:AddElement(TotemBar)
frmPlayer.TotemBar:SetPoint("BOTTOM", frmPlayer, "TOP")