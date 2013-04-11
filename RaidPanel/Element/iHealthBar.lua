-----------------------------------------
-- Health Bar for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iHealthBar"
	inherit "HealthBar"
	extend "iStatusBarStyle""iBorder"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self)
		self.UseDebuffColor = true
		self.FrameLevel = self.FrameLevel + 1
	end
endclass "iHealthBar"

class "iMyHealPrediction"
	inherit "StatusBar"
	extend "IFMyHealPrediction"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iMyHealPrediction(self)
		self.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		self.StatusBarColor = ColorType(0, 0.827, 0.765)
    end
endclass "iMyHealPrediction"

class "iAllHealPrediction"
	inherit "StatusBar"
	extend "IFAllHealPrediction"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iAllHealPrediction(self)
		self.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		self.StatusBarColor = ColorType(0, 0.631, 0.557)
    end
endclass "iAllHealPrediction"

class "iAbsorb"
	inherit "StatusBar"
	extend "IFAbsorb"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "OverAbsorb" {
		Set = function(self, value)
			self.Parent.OverAbsorbGlow.Visible = value
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iAbsorb(self)
    	local overAbsorbGlow = Texture("OverAbsorbGlow", self.Parent)

    	overAbsorbGlow.BlendMode = "ADD"
    	overAbsorbGlow.TexturePath = [[Interface\RaidFrame\Shield-Overshield]]
    	overAbsorbGlow.Width = 16
    	overAbsorbGlow.Visible = false

		overAbsorbGlow:SetPoint("TOPLEFT", self.Parent.iHealthBar, "TOPRIGHT", -7, 0)
		overAbsorbGlow:SetPoint("BOTTOMLEFT", self.Parent.iHealthBar, "BOTTOMRIGHT", -7, 0)
    end
endclass "iAbsorb"

interface "IFIHealthBar"
	local function OnSizeChanged(self)
		local size = self.Size

		self.Parent.iMyHealPrediction.Size = size
		self.Parent.iAllHealPrediction.Size = size
		self.Parent.iAbsorb.Size = size
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIHealthBar(self)
		self:AddElement(iHealthBar, "rest")
		self:AddElement(iMyHealPrediction)
		self:AddElement(iAllHealPrediction)
		self:AddElement(iAbsorb)

		self.iMyHealPrediction:SetPoint("TOPLEFT", self.iHealthBar.StatusBarTexture, "TOPRIGHT")
		self.iAllHealPrediction:SetPoint("TOPLEFT", self.iHealthBar.StatusBarTexture, "TOPRIGHT")
		self.iAbsorb:SetPoint("TOPLEFT", self.iHealthBar.StatusBarTexture, "TOPRIGHT")

		self.iMyHealPrediction.FrameLevel = self.iHealthBar.FrameLevel + 2
		self.iAllHealPrediction.FrameLevel = self.iHealthBar.FrameLevel + 2
		self.iAbsorb.FrameLevel = self.iHealthBar.FrameLevel + 2
		self.Panel.OverAbsorbGlow.FrameLevel = self.iHealthBar.FrameLevel + 2

		self.iHealthBar.OnSizeChanged = self.iHealthBar.OnSizeChanged + OnSizeChanged
    end
endinterface "IFIHealthBar"

partclass "iRaidUnitFrame"
	extend "IFIHealthBar"
endclass "iRaidUnitFrame"

AddType4Config(iMyHealPrediction, L"My heal prediction")
AddType4Config(iAllHealPrediction, L"All heal prediction")
AddType4Config(iAbsorb, L"Total Absorb")