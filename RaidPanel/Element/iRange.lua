-----------------------------------------
-- Range Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIRange
-- @type interface
-- @name IFIRange
-----------------------------------------------
interface "IFIRange"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIRange(self)
		self:AddElement(RangeChecker)
    end
endinterface "IFIRange"

partclass "iRaidUnitFrame"
	extend "IFIRange"
endclass "iRaidUnitFrame"
