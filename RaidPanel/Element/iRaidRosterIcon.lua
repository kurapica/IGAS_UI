-----------------------------------------
-- Raid Roster Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIRaidRosterIcon
-- @type interface
-- @name IFIRaidRosterIcon
-----------------------------------------------
interface "IFIRaidRosterIcon"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIRaidRosterIcon(self)
		self:AddElement(RaidRosterIcon)
		self.RaidRosterIcon:SetPoint("TOPLEFT", 0, 0)
    end
endinterface "IFIRaidRosterIcon"

partclass "iRaidUnitFrame"
	extend "IFIRaidRosterIcon"
endclass "iRaidUnitFrame"
