-----------------------------------------
-- Resurrect Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

interface "IFIResurrect"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIResurrect(self)
		self:AddElement(ResurrectIcon)
		self.ResurrectIcon:SetPoint("BOTTOM")
    end
endinterface "IFIResurrect"

partclass "iRaidUnitFrame"
	extend "IFIResurrect"
endclass "iRaidUnitFrame"

AddType4Config(ResurrectIcon, L"Resurrect indicator")
