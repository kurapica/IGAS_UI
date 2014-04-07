IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Elements for UnitFrame
--==========================
interface "IFStatusBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFStatusBar(self)
    	self.StatusBarTexturePath = TextureConfig.Blank
    	self.DefaultColor = TextureConfig.DefaultBarColor

    	local bg = Texture("Bg", self, "BACKGROUND")
		bg.Color = TextureConfig.BackgroundColor
		bg:SetAllPoints()
    end
endinterface "IFStatusBar"

class "iHealthBar"
	inherit "HealthBarFrequent"
	extend "IFStatusBar"
endclass "iHealthBar"

class "iPowerBar"
	inherit "PowerBarFrequent"
	extend "IFStatusBar"

	function iPowerBar(self, ...)
		Super(self, ...)

		self.UsePowerColor = false
	end
endclass "iPowerBar"