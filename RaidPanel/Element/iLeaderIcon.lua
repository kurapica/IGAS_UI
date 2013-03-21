-----------------------------------------
-- Leader Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

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

AddType4Config(LeaderIcon, L"Leader indicator")