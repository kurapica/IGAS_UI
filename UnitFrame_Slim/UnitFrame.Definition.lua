-----------------------------------------
-- Definition for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.UnitFrame"

import "System.Widget"
import "System.Widget.Unit"

_IGASUI_RAIDPANEL_GROUP = "IRaidPanel"	-- Same as the raidPanel, no raidpanel no settings.

_IGASUI_UNITFRAME_GROUP = "IUnitFrame"

RAID_CLASS_COLORS = IGAS:CopyTable(_G.RAID_CLASS_COLORS)
DEFAULT_COLOR = ColorType(1, 1, 1)
PLAYER_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

_THIN_BORDER = {
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
}

_BORDER_COLOR = ColorType(0, 0, 0)
_BACK_MULTI = 0.4
_BACK_ALPHA = 0.25

-----------------------------------------------
--- iUnitFrame
-- @type class
-- @name iUnitFrame
-----------------------------------------------
class "iUnitFrame"
	inherit "UnitFrame"
	-- extend "IFSpellHandler"
	extend "IFMovable" "IFResizable"

	_IGASUI_RAIDPANEL_GROUP = _IGASUI_RAIDPANEL_GROUP
	_IGASUI_UNITFRAME_GROUP = _IGASUI_UNITFRAME_GROUP

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 1,
	}

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IFSpellHandlerGroup
	property "IFSpellHandlerGroup" {
		Get = function(self)
			return _IGASUI_RAIDPANEL_GROUP
		end,
	}
	-- IFMovingGroup
	property "IFMovingGroup" {
		Get = function(self)
			return _IGASUI_UNITFRAME_GROUP
		end,
	}
	-- IFResizingGroup
	property "IFResizingGroup" {
		Get = function(self)
			return _IGASUI_UNITFRAME_GROUP
		end,
	}

	function iUnitFrame(...)
		local frm = Super(...)

		frm:ConvertClass(iUnitFrame)
		frm.Panel.VSpacing = 4

		frm:SetSize(200, 48)

		frm.IFMovable = true
		frm.IFResizable = true

		frm:AddElement(iHealthBar, "rest")

		frm:AddElement(iPowerBar, "south", 2, "px")

		frm:AddElement(NameLabel)
		frm.NameLabel.UseClassColor = true
		frm.NameLabel:SetPoint("TOPRIGHT", frm, "BOTTOMRIGHT")

		frm:AddElement(LevelLabel)
		frm.LevelLabel:SetPoint("RIGHT", frm.NameLabel, "LEFT", -4, 0)

		frm:AddElement(iCastBar)
		frm.iCastBar:SetAllPoints(frm.iHealthBar)

		arUnit:Insert(frm)

		return frm
	end
endclass "iUnitFrame"

-----------------------------------------------
--- iHealthBar
-- @type class
-- @name iHealthBar
-----------------------------------------------
class "iHealthBar"
	inherit "HealthBarFrequent"

	_BACK_MULTI = _BACK_MULTI
	_BACK_ALPHA = _BACK_ALPHA

	function SetStatusBarColor(self, r, g, b, a)
	    if r and g and b then
	        Super.SetStatusBarColor(self, r, g, b)
	        self.Bg:SetTexture(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		bar.UseClassColor = true

		local bg = Frame("Back", bar)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = _THIN_BORDER
		bg.BackdropBorderColor = _BORDER_COLOR

		local bgColor = Texture("Bg", bg, "BACKGROUND")
		bgColor:SetAllPoints()

		bar.Bg = bgColor

		return bar
	end
endclass "iHealthBar"

-----------------------------------------------
--- iPowerBar
-- @type class
-- @name iPowerBar
-----------------------------------------------
class "iPowerBar"
	inherit "PowerBarFrequent"

	_BACK_MULTI = _BACK_MULTI
	_BACK_ALPHA = _BACK_ALPHA

	function SetStatusBarColor(self, r, g, b, a)
	    if r and g and b then
	        Super.SetStatusBarColor(self, r, g, b)
	        self.Bg:SetTexture(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iPowerBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		local bg = Frame("Back", bar)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = _THIN_BORDER
		bg.BackdropBorderColor = _BORDER_COLOR

		local bgColor = Texture("Bg", bg, "BACKGROUND")
		bgColor:SetAllPoints()

		bar.Bg = bgColor

		return bar
	end
endclass "iPowerBar"

-----------------------------------------------
--- iHiddenManaBar
-- @type class
-- @name iHiddenManaBar
-----------------------------------------------
class "iHiddenManaBar"
	inherit "HiddenManaBar"

	_BACK_MULTI = _BACK_MULTI
	_BACK_ALPHA = _BACK_ALPHA

	function SetStatusBarColor(self, r, g, b, a)
	    if r and g and b then
	        Super.SetStatusBarColor(self, r, g, b)
	        self.Bg:SetTexture(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHiddenManaBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		local bg = Frame("Back", bar)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = _THIN_BORDER
		bg.BackdropBorderColor = _BORDER_COLOR

		local bgColor = Texture("Bg", bg, "BACKGROUND")
		bgColor:SetAllPoints()

		bar.Bg = bgColor

		return bar
	end
endclass "iHiddenManaBar"

-----------------------------------------------
--- iBuffPanel
-- @type class
-- @name iBuffPanel
-----------------------------------------------
class "iBuffPanel"
	inherit "AuraPanel"

	------------------------------------
	--- Custom Filter method
	-- @name CustomFilter
	-- @type function
	-- @param unit
	-- @param index
	-- @param filter
	-- @return boolean
	------------------------------------
	function CustomFilter(self, unit, index, filter)
		local isEnemy = UnitCanAttack("player", unit)
		local name, _, _, _, _, duration, _, caster = UnitAura(unit, index, filter)

		if name and duration > 0 and (isEnemy or caster == "player") then
			return true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iBuffPanel(...)
		local obj = Super(...)

		obj.Filter = "HELPFUL"
		obj.HighLightPlayer = true
		obj.RowCount = 6
		obj.ColumnCount = 6
		obj.MarginTop = 2

		return obj
    end
endclass "iBuffPanel"

-----------------------------------------------
--- iDebuffPanel
-- @type class
-- @name iDebuffPanel
-----------------------------------------------
class "iDebuffPanel"
	inherit "AuraPanel"

	------------------------------------
	--- Custom Filter method
	-- @name CustomFilter
	-- @type function
	-- @param unit
	-- @param index
	-- @param filter
	-- @return boolean
	------------------------------------
	function CustomFilter(self, unit, index, filter)
		local isFriend = not UnitCanAttack("player", unit)
		local name, _, _, _, _, duration, _, caster = UnitAura(unit, index, filter)

		if name and duration > 0 and (isFriend or caster == "player") then
			return true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(...)
		local obj = Super(...)

		obj.Filter = "HARMFUL"
		obj.HighLightPlayer = true
		obj.RowCount = 6
		obj.ColumnCount = 6
		obj.MarginTop = 2

		return obj
    end
endclass "iDebuffPanel"

-----------------------------------------------
--- iCastBar
-- @type class
-- @name iCastBar
-----------------------------------------------
class "iCastBar"
	inherit "CastBar"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.Unit then
			self.__CastBar.BackdropBorderColor = RAID_CLASS_COLORS[select(2, UnitClass(self.Unit))] or DEFAULT_COLOR
		else
			self.__CastBar.BackdropBorderColor = DEFAULT_COLOR
		end
	end

	------------------------------------
	--- Custom the statusbar
	-- @name SetUpCooldownStatus
	-- @class function
	-- @param status
	------------------------------------
	function SetUpCooldownStatus(self, status)
		self.__CastBar = status
		Super.SetUpCooldownStatus(self, status)
		status.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
	end
endclass "iCastBar"

-----------------------------------------------
--- iClassPower
-- @type class
-- @name iClassPower
-----------------------------------------------
class "iClassPower"
	inherit "Frame"
	extend "IFClassPower"

	_MaxPower = 5

	SPELL_POWER_BURNING_EMBERS = _G.SPELL_POWER_BURNING_EMBERS

	MAX_POWER_PER_EMBER = _G.MAX_POWER_PER_EMBER

	-----------------------------------------------
	--- ClassPowerBar
	-- @type class
	-- @name ClassPowerBar
	-----------------------------------------------
	class "ClassPowerBar"
		inherit "StatusBar"

		_BACK_MULTI = _BACK_MULTI
		_BACK_ALPHA = _BACK_ALPHA

		------------------------------------------------------
		-- Property
		------------------------------------------------------

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function ClassPowerBar(...)
			local bar = Super(...)

			bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

			local bg = Frame("Back", bar)
			bg.FrameStrata = "BACKGROUND"
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg.Backdrop = _THIN_BORDER
			bg.BackdropBorderColor = _BORDER_COLOR

			local bgColor = Texture("Bg", bg, "BACKGROUND")
			bgColor:SetAllPoints()

			bar:SetStatusBarColor(PLAYER_COLOR.r, PLAYER_COLOR.g, PLAYER_COLOR.b)
			bgColor:SetTexture(PLAYER_COLOR.r * _BACK_MULTI, PLAYER_COLOR.g * _BACK_MULTI, PLAYER_COLOR.b * _BACK_MULTI, _BACK_ALPHA)

			return bar
	    end
	endclass "ClassPowerBar"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function RefreshBar(self)
		local numBar

		if self.__ClassPowerType == SPELL_POWER_BURNING_EMBERS then
			numBar = floor(self.__Max / MAX_POWER_PER_EMBER)
			if numBar > 3 then
				numBar = 4
			end
		elseif self.__ClassPowerType then
			numBar = self.__Max
		else
			return
		end

		if numBar > _MaxPower then
			numBar = 1
		end

		for i = _MaxPower, numBar + 1, -1 do
			self[i]:Hide()
		end

		local width = floor((self.Parent.Width - self.HSpacing * (numBar-1)) / numBar)

		self.__NumBar = numBar

		for i = 1, numBar do
			self[i].Width = width
			self[i]:SetPoint("LEFT", (width + self.HSpacing) * (i - 1), 0)
			self[i]:Show()

			if self.__ClassPowerType == SPELL_POWER_BURNING_EMBERS then
				self[i]:SetMinMaxValues(0, MAX_POWER_PER_EMBER)
			elseif numBar == 1 then
				self[i]:SetMinMaxValues(0, self.__Max)
			else
				self[i]:SetMinMaxValues(0, 1)
			end
		end

		return self:RefreshValue()
	end

	function RefreshValue(self)
		if not self.__NumBar then return end

		local value = self.__Value or 0

		if self.__ClassPowerType == SPELL_POWER_BURNING_EMBERS then
			for i = 1, self.__NumBar do
				if value >= MAX_POWER_PER_EMBER then
					self[i].Value = MAX_POWER_PER_EMBER
				else
					self[i].Value = value
				end
				value = value - MAX_POWER_PER_EMBER
				if value < 0 then value = 0 end
			end
		elseif self.__NumBar == 1 then
			self[1].Value = value
		else
			for i = 1, self.__NumBar do
				if value >= i then
					self[i].Value = 1
				else
					self[i].Value = 0
				end
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Value
	property "Value" {
		Get = function(self)
			return self.__Value
		end,
		Set = function(self, value)
			if self.__Value ~= value then
				self.__Value = value
				return self:RefreshValue()
			end
		end,
		Type = System.Number + nil,
	}
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self.__Min, self.__Max)
		end,
		Set = function(self, value)
			if self.__Max ~= value.max then
				self.__Min, self.__Max = value.min, value.max

				return self:RefreshBar()
			end
		end,
		Type = System.MinMax,
	}
	-- ClassPowerType
	property "ClassPowerType" {
		Get = function(self)
			return self.__ClassPowerType
		end,
		Set = function(self, value)
			if self.__ClassPowerType ~= value then
				self.__ClassPowerType = value
			end
		end,
		Type = System.Number+nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		return self:RefreshBar()
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iClassPower(...)
		local obj = Super(...)

		obj.HSpacing = 3

		for i = 1, _MaxPower do
			obj[i] = ClassPowerBar("Bar"..i, obj)
			obj[i]:Hide()
			obj[i]:SetPoint("TOP")
			obj[i]:SetPoint("BOTTOM")
		end

		obj.OnSizeChanged = obj.OnSizeChanged + OnSizeChanged

		return obj
    end
endclass "iClassPower"

-----------------------------------------------
--- iTargetName
-- @type class
-- @name iTargetName
-----------------------------------------------
class "iTargetName"
	inherit "NameLabel"
	extend "IFHealthFrequent"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		if self.Unit and UnitIsTapped(self.Unit) and not UnitIsTappedByPlayer(self.Unit) and not UnitIsTappedByAllThreatList(self.Unit) then
			self.Text = "|cff7f7f7f" .. UnitName(self.Unit) .. "|r"
		else
			Super.Refresh(self)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Value
	property "Value" {
		Set = function(self, value)
			return self:Refresh()
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iTargetName(...)
		local obj = Super(...)

		return obj
    end
endclass "iTargetName"
