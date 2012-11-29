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

		frm:SetBackdrop(_BackDrop)
		frm:SetSize(200, 48)

		frm.IFMovable = true
		frm.IFResizable = true

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

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

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

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iPowerBar(...)
		local bar = Super(...)

		bar.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		return bar
    end
endclass "iPowerBar"

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
--- iBorderColor
-- @type class
-- @name iBorderColor
-----------------------------------------------
class "iBorderColor"
	inherit "VirtualUIObject"
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
			self.Parent.Parent.BackdropBorderColor = RAID_CLASS_COLORS[select(2, UnitClass(self.Unit))] or DEFAULT_COLOR
		else
			self.Parent.Parent.BackdropBorderColor = DEFAULT_COLOR
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iBorderColor(...)
		local obj = Super(...)

		return obj
    end
endclass "iBorderColor"

-----------------------------------------------
--- iClassPower
-- @type class
-- @name iClassPower
-----------------------------------------------
class "iClassPower"
	inherit "FontString"
	extend "IFClassPower"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Value
	property "Value" {
		Get = function(self)
			return tonumber(self.Text)
		end,
		Set = function(self, value)
			self.Text = tostring(value or 0)
		end,
		Type = System.Number + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iClassPower(...)
		local obj = Super(...)

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

-----------------------------------------------
--- iHiddenManaBar
-- @type class
-- @name iHiddenManaBar
-----------------------------------------------
class "iHiddenManaBar"
	inherit "HiddenManaBar"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iHiddenManaBar(...)
		local obj = Super(...)

		obj.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		return obj
    end
endclass "iHiddenManaBar"