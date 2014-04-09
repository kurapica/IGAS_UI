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

class "iTargetName"
	inherit "FontString"
	extend "IFUnitName"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetText(self, text)
		if text and text ~= "" then
			Super.SetText(self, "> " .. text)
		else
			Super.SetText("")
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iTargetName(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.DrawLayer = "BORDER"
		self.Font = FontType(FontMap.HandelGotD, 10, "NORMAL", false)
	end
endclass "iTargetName"

class "iCastBar"
	inherit "CastBar"

	function SetUpCooldownStatus(self, status)
		Super.SetUpCooldownStatus(self, status)
		status.StatusBarTexturePath = TextureMap.Blank
		status.StatusBarColor = Media.CASTBAR_COLOR
	end

	function iCastBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "HIGH"
	end
endclass "iCastBar"