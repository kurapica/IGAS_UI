-----------------------------------------
-- Target Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iTarget
-- @type class
-- @name iTarget
-----------------------------------------------
class "iTarget"
	inherit "VirtualUIObject"
	extend "IFTarget"

	_FrameBackdrop = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 8,
	}

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IsTarget
	property "IsTarget" {
		Get = function(self)
			return self.__IsTarget or false
		end,
		Set = function(self, value)
			if self.IsTarget ~= value then
				self.__IsTarget = value
				if value then
					self.Parent:SetBackdrop(_FrameBackdrop)
				else
					self.Parent:SetBackdrop(nil)
				end
			end
		end,
		Type = System.Boolean,
	}
endclass "iTarget"

-----------------------------------------------
--- IFITarget
-- @type interface
-- @name IFITarget
-----------------------------------------------
interface "IFITarget"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFITarget(self)
		self:AddElement(iTarget)
    end
endinterface "IFITarget"

partclass "iRaidUnitFrame"
	extend "IFITarget"
endclass "iRaidUnitFrame"
