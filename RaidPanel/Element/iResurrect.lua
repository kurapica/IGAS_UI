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

class "iRaidUnitFrame"
	extend "IFIResurrect"
endclass "iRaidUnitFrame"

class "iDeadUnitFrame"
	extend "IFIResurrect"
endclass "iDeadUnitFrame"

AddType4Config(ResurrectIcon, L"Resurrect indicator")
