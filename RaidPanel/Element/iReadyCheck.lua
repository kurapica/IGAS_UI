-----------------------------------------
-- Ready Check Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

interface "IFIReadyCheck"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIReadyCheck(self)
		self:AddElement(ReadyCheckIcon)
		self.ReadyCheckIcon:SetPoint("BOTTOM")
    end
endinterface "IFIReadyCheck"

class "iRaidUnitFrame"
	extend "IFIReadyCheck"
endclass "iRaidUnitFrame"

AddType4Config(ReadyCheckIcon, L"ReadyCheck indicator")
