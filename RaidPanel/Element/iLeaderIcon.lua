-----------------------------------------
-- Leader Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFILeaderIcon
-- @type interface
-- @name IFILeaderIcon
-----------------------------------------------
interface "IFILeaderIcon"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFILeaderIcon(self)
		self:AddElement(LeaderIcon)
		self.LeaderIcon:SetPoint("CENTER", self.LeaderIcon.Parent, "TOPLEFT")
    end
endinterface "IFILeaderIcon"

partclass "iRaidUnitFrame"
	extend "IFILeaderIcon"
endclass "iRaidUnitFrame"
