-----------------------------------------
-- Power Bar for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iPowerBar"
	inherit "PowerBar"
	extend "iStatusBarStyle"
endclass "iPowerBar"

interface "IFIPowerBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIPowerBar(self)
		self:AddElement(iPowerBar, "south", 4, "px")
    end
endinterface "IFIPowerBar"

partclass "iRaidUnitFrame"
	extend "IFIPowerBar"
endclass "iRaidUnitFrame"

AddType4Config(iPowerBar, L"Power bar")