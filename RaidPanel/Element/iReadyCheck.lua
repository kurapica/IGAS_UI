-----------------------------------------
-- Ready Check Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIReadyCheck
-- @type interface
-- @name IFIReadyCheck
-----------------------------------------------
interface "IFIReadyCheck"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIReadyCheck(self)
		self:AddElement(ReadyCheckIcon)
		self.ReadyCheckIcon:SetPoint("BOTTOM")
    end
endinterface "IFIReadyCheck"

partclass "iRaidUnitFrame"
	extend "IFIReadyCheck"
endclass "iRaidUnitFrame"
