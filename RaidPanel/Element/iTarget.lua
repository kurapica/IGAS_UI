-----------------------------------------
-- Target Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iTarget"
	inherit "VirtualUIObject"
	extend "IFTarget"

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
					self.UpdateFrame.iHealthBar.Back.BackdropBorderColor = TARGET_BORDER_COLOR
				else
					self.UpdateFrame.iHealthBar.Back.BackdropBorderColor = DEFAULT_BORDER_COLOR
				end
			end
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iTarget(self)
		self.UpdateFrame = self.Parent.Parent
	end
endclass "iTarget"

interface "IFITarget"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFITarget(self)
		self:AddElement(iTarget)
    end
endinterface "IFITarget"

class "iRaidUnitFrame"
	extend "IFITarget"
endclass "iRaidUnitFrame"

AddType4Config(iTarget, L"Target indicator")