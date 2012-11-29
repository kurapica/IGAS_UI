-----------------------------------------
-- Power Bar for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iPowerBar
-- @type class
-- @name iPowerBar
-----------------------------------------------
class "iPowerBar"
	inherit "PowerBar"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iPowerBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		return bar
	end
endclass "iPowerBar"

-----------------------------------------------
--- IFIPowerBar
-- @type interface
-- @name IFIPowerBar
-----------------------------------------------
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
