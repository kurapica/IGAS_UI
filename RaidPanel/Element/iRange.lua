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
		self.RangeChecker.UseIndicator = true
		self.RangeChecker:SetPoint("CENTER", self, "LEFT", 16, 0)
    end
endinterface "IFIRange"

class "iRaidUnitFrame"
	extend "IFIRange"
endclass "iRaidUnitFrame"

class "iDeadUnitFrame"
	extend "IFIRange"
endclass "iDeadUnitFrame"

AddType4Config(RangeChecker, L"Range indicator")