-----------------------------------------
-- Health Bar for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iHealthBar
-- @type class
-- @name iHealthBar
-----------------------------------------------
class "iHealthBar"
	inherit "HealthBar"
	extend "iStatusBarStyle"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self)
		self.UseDebuffColor = true
	end
endclass "iHealthBar"

-----------------------------------------------
--- iMyHealPrediction
-- @type class
-- @name iMyHealPrediction
-----------------------------------------------
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

-----------------------------------------------
--- iAllHealPrediction
-- @type class
-- @name iAllHealPrediction
-----------------------------------------------
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

-----------------------------------------------
--- IFIHealthBar
-- @type interface
-- @name IFIHealthBar
-----------------------------------------------
interface "IFIHealthBar"
	local function OnSizeChanged(self)
		self.Parent.iMyHealPrediction.Size = self.Size
		self.Parent.iAllHealPrediction.Size = self.Size
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIHealthBar(self)
		self:AddElement(iHealthBar, "rest")
		self:AddElement(iMyHealPrediction)
		self:AddElement(iAllHealPrediction)

		self.iMyHealPrediction:SetPoint("TOPLEFT", self.iHealthBar.StatusBarTexture, "TOPRIGHT")
		self.iAllHealPrediction:SetPoint("TOPLEFT", self.iHealthBar.StatusBarTexture, "TOPRIGHT")

		self.iMyHealPrediction.FrameLevel = self.iHealthBar.FrameLevel + 2
		self.iAllHealPrediction.FrameLevel = self.iHealthBar.FrameLevel + 2

		self.iHealthBar.OnSizeChanged = self.iHealthBar.OnSizeChanged + OnSizeChanged
    end
endinterface "IFIHealthBar"

partclass "iRaidUnitFrame"
	extend "IFIHealthBar"
endclass "iRaidUnitFrame"
