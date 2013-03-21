-----------------------------------------
-- Range Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iRange"
	inherit "VirtualUIObject"
	extend "IFRange"

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Alpha
	property "Alpha" {
		Get = function(self)
			return self.Parent.Alpha
		end,
		Set = function(self, value)
			self.Parent.Alpha = value
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "iRange"

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
		self:AddElement(iRange)
    end
endinterface "IFIRange"

partclass "iRaidUnitFrame"
	extend "IFIRange"
endclass "iRaidUnitFrame"
