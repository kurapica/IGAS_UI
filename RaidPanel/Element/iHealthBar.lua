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

	_BACK_MULTI = 0.2
	_BACK_ALPHA = 0.8

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetStatusBarColor(self, r, g, b, a)
	    if r and g and b then
	        StatusBar.SetStatusBarColor(self, r, g, b)
	        if self.Bg then
	        	self.Bg:SetTexture(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    	end
	    end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		bar.UseDebuffColor = true

		local bgColor = Texture("Bg", bar, "BACKGROUND")
		bgColor:SetAllPoints()

		return bar
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
    function iMyHealPrediction(...)
		local obj = Super(...)

		obj.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		obj.StatusBarColor = ColorType(0, 0.827, 0.765)

		return obj
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
    function iAllHealPrediction(...)
		local obj = Super(...)

		obj.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		obj.StatusBarColor = ColorType(0, 0.631, 0.557)

		return obj
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

		self.iHealthBar.OnSizeChanged = self.iHealthBar.OnSizeChanged + OnSizeChanged
    end
endinterface "IFIHealthBar"

partclass "iRaidUnitFrame"
	extend "IFIHealthBar"
endclass "iRaidUnitFrame"
