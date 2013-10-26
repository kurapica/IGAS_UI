-----------------------------------------
-- Raid Roster Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

interface "IFIRaidRosterIcon"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIRaidRosterIcon(self)
		self:AddElement(RaidRosterIcon)
		self.RaidRosterIcon:SetPoint("TOPLEFT", 0, 0)
    end
endinterface "IFIRaidRosterIcon"

class "iRaidUnitFrame"
	extend "IFIRaidRosterIcon"
endclass "iRaidUnitFrame"

AddType4Config(RaidRosterIcon, L"Raid roster indicator")