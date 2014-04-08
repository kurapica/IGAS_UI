IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Elements for UnitFrame
--==========================
interface "IFStatusBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFStatusBar(self)
    	self.StatusBarTexturePath = TextureMap.Blank
    	self.DefaultColor = TextureMap.DefaultBarColor

    	local bg = Texture("Bg", self, "BACKGROUND")
		bg.Color = TextureMap.BackgroundColor
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

class "iBarBackdrop"
	inherit "Frame"

    function iBarBackdrop(self, ...)
    	Super(self, ...)

    	self.FrameStrata = "BACKGROUND"
    	self.Backdrop = TextureMap.Backdrop
    	self.BackdropColor = TextureMap.BarBackdropColor
    	self.BackdropBorderColor = TextureMap.BarBackdropColor
    end
endclass "iBarBackdrop"