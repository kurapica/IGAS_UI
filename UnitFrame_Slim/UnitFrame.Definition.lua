-----------------------------------------
-- Definition for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.UnitFrame"

import "System.Widget"
import "System.Widget.Unit"

_IGASUI_RAIDPANEL_GROUP = "IRaidPanel"	-- Same as the raidPanel, no raidpanel no settings.

_IGASUI_UNITFRAME_GROUP = "IUnitFrame"

RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
DEFAULT_COLOR = ColorType(1, 1, 1)

CASTBAR_COLOR = ColorType(0, 0, 0.8)
BUFF_SIZE = 24

_Buff_List = {
	-- [spellId] = true,
}

_Debuff_List = {
	-- [spellId] = true,
}

-----------------------------------------------
--- iBorder
-- @type interface
-- @name iBorder
-----------------------------------------------
interface "iBorder"
	_PLAYER_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
	_THIN_BORDER = {
	    edgeFile = "Interface\\Buttons\\WHITE8x8",
	    edgeSize = 1,
	}

	_BORDER_COLOR = ColorType(0, 0, 0)

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
	-- Initialize
	------------------------------------------------------
    function iBorder(self)
		self.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]

		local bg = Frame("Back", self)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = _THIN_BORDER
		bg.BackdropBorderColor = _BORDER_COLOR

		local bgColor = Texture("Bg", bg, "BACKGROUND")
		bgColor:SetAllPoints()

		self.Bg = bgColor

		self.SetStatusBarColor = SetStatusBarColor

		if self:IsClass(iClassPowerButton) then
			self:SetStatusBarColor(_PLAYER_COLOR.r, _PLAYER_COLOR.g, _PLAYER_COLOR.b)
    	end
    end
endinterface "iBorder"

-----------------------------------------------
--- iSUnitFrame
-- @type class
-- @name iSUnitFrame
-----------------------------------------------
class "iSUnitFrame"
	inherit "UnitFrame"
	-- extend "IFSpellHandler"	-- enable this for hover spell casting
	extend "IFMovable" "IFResizable"

	_IGASUI_RAIDPANEL_GROUP = _IGASUI_RAIDPANEL_GROUP
	_IGASUI_UNITFRAME_GROUP = _IGASUI_UNITFRAME_GROUP

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

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iSUnitFrame(...)
		local frm = Super(...)

		frm:ConvertClass(iSUnitFrame)
		frm.Panel.VSpacing = 4

		frm:SetSize(200, 48)

		frm.IFMovable = true
		frm.IFResizable = true

		-- Health
		frm:AddElement(iHealthBar, "rest")

		-- Name
		frm:AddElement(NameLabel)
		frm.NameLabel.UseClassColor = true
		frm.NameLabel:SetPoint("RIGHT", frm.iHealthBar, "RIGHT", -4, 0)

		-- Level
		frm:AddElement(LevelLabel)
		frm.LevelLabel:SetPoint("RIGHT", frm.NameLabel, "LEFT", -4, 0)

		arUnit:Insert(frm)

		return frm
	end
endclass "iSUnitFrame"

-----------------------------------------------
--- iUnitFrame
-- @type class
-- @name iUnitFrame
-----------------------------------------------
class "iUnitFrame"
	inherit "iSUnitFrame"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iUnitFrame(...)
		local frm = Super(...)

		-- Power
		frm:AddElement(iPowerBar, "south", 6, "px")

		-- Name
		frm.NameLabel:ClearAllPoints()
		frm.NameLabel:SetPoint("TOPRIGHT", frm, "BOTTOMRIGHT")

		-- Cast
		frm:AddElement(iCastBar)
		frm.iCastBar:SetAllPoints(frm.iHealthBar)

		-- Percent Health text
		frm:AddElement(HealthTextFrequent)
		frm.HealthTextFrequent.ShowPercent = true
		frm.HealthTextFrequent:SetPoint("RIGHT", frm.iHealthBar, "LEFT", -4, 0)

		-- Full Health Text
		frm:AddElement("HealthTextFrequent2", HealthTextFrequent)
		frm.HealthTextFrequent2.ValueFormat = "%.1f"
		frm.HealthTextFrequent2:SetPoint("TOPLEFT", frm, "BOTTOMLEFT", 0, -2)

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
	extend "iBorder"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(...)
		local bar = Super(...)

		bar.UseClassColor = true

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
	extend "iBorder"
endclass "iPowerBar"

-----------------------------------------------
--- iHiddenManaBar
-- @type class
-- @name iHiddenManaBar
-----------------------------------------------
class "iHiddenManaBar"
	inherit "HiddenManaBar"
	extend "iBorder"
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
		local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

		if name and duration > 0 and (_Buff_List[spellID] or isEnemy or caster == "player") then
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

		obj.ElementWidth = BUFF_SIZE
		obj.ElementHeight = BUFF_SIZE

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
		local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

		if name and duration > 0 and (_Debuff_List[spellID] or isFriend or caster == "player") then
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

		obj.ElementWidth = BUFF_SIZE
		obj.ElementHeight = BUFF_SIZE

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

	------------------------------------------------------
	-- Method
	------------------------------------------------------

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
		status.StatusBarColor = CASTBAR_COLOR
	end
endclass "iCastBar"

-----------------------------------------------
--- iClassPowerButton
-- @type class
-- @name iClassPowerButton
-----------------------------------------------
class "iClassPowerButton"
	inherit "StatusBar"
	extend "iBorder"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Activated
	property "Activated" {
		Get = function(self)
			return self.__Activated
		end,
		Set = function(self, value)
			if self.Activated ~= value then
				self.__Activated = value

				if value then
					self.Glow.AnimOut.Playing = false

					self.Glow.AnimIn.Playing = true
				else
					self.Glow.AnimIn.Playing = false

					self.Glow.AnimOut.Playing = true
				end
			end
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function AnimIn_OnPlay(self)
		self.Parent.Alpha = 0

		local width, height = self.Parent.Parent:GetSize()
		self.Parent:SetSize(width*1.05, height*2)
	end

	local function AnimIn_OnFinished(self)
		self.Parent.Alpha = 1
	end

	local function AnimOut_OnPlay(self)
		self.Parent.Alpha = 1
	end

	local function AnimOut_OnFinished(self)
		self.Parent.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iClassPowerButton(...)
		local btn = Super(...)

		local glow = Texture("Glow", btn, "ARTWORK")
		glow.Alpha = 0
		glow.TexturePath = [[Interface\SpellActivationOverlay\IconAlert]]
		--glow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
		glow:SetTexCoord(0.13, 0.395, 0.27734375, 0.52734375)
		glow:SetPoint("CENTER")

		local animIn = AnimationGroup("AnimIn", glow)

		local alpha = Alpha("Alpha", animIn)
		alpha.Order = 1
		alpha.Duration = 0.2
		alpha.Change = 1

		animIn.OnPlay = AnimIn_OnPlay
		animIn.OnFinished = AnimIn_OnFinished

		local animOut = AnimationGroup("AnimOut", glow)

		alpha = Alpha("Alpha", animOut)
		alpha.Order = 1
		alpha.Duration = 0.2
		alpha.Change = -1

		animOut.OnPlay = AnimOut_OnPlay
		animOut.OnFinished = AnimOut_OnFinished

		return btn
	end
endclass "iClassPowerButton"

-----------------------------------------------
--- iClassPower
-- @type class
-- @name iClassPower
-----------------------------------------------
class "iClassPower"
	inherit "Frame"
	extend "IFClassPower" "IFComboPoint"

	_MaxPower = 5

	SPELL_POWER_SOUL_SHARDS = _G.SPELL_POWER_SOUL_SHARDS
	SPELL_POWER_BURNING_EMBERS = _G.SPELL_POWER_BURNING_EMBERS
	SPELL_POWER_HOLY_POWER = _G.SPELL_POWER_HOLY_POWER
	SPELL_POWER_CHI = _G.SPELL_POWER_CHI

	MAX_POWER_PER_EMBER = _G.MAX_POWER_PER_EMBER

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
			self[i].Activated = false
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
					self[i].Activated = true
				else
					self[i].Value = value
					self[i].Activated = false
				end
				value = value - MAX_POWER_PER_EMBER
				if value < 0 then value = 0 end
			end
		elseif self.__NumBar == 1 then
			self[1].Value = value
		else
			local needActive = false

			if self.__ClassPowerType == SPELL_POWER_HOLY_POWER then
				if value >= 3 then
					needActive = true
				end
			elseif value >= self.__Max then
				needActive = true
			end

			for i = 1, self.__NumBar do
				if value >= i then
					self[i].Value = 1
					self[i].Activated = needActive
				else
					self[i].Value = 0
					self[i].Activated = false
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
			obj[i] = iClassPowerButton("Bar"..i, obj)
			obj[i]:Hide()
			obj[i]:SetPoint("TOP")
			obj[i]:SetPoint("BOTTOM")
		end

		obj.OnSizeChanged = obj.OnSizeChanged + OnSizeChanged

		if select(2, UnitClass("player")) == "ROGUE" or select(2, UnitClass("player")) == "DRUID" then
			obj.Refresh = IFComboPoint.Refresh
			obj.__ClassPowerType = 100
			obj.__Min, obj.__Max = 0, _G.MAX_COMBO_POINTS
		end

		return obj
    end
endclass "iClassPower"

-----------------------------------------------
--- iRuneBar
-- @type class
-- @name iRuneBar
-----------------------------------------------
class "iRuneBar"
	inherit "LayoutPanel"
	extend "IFRune"

	MAX_RUNES = 6

	RUNETYPE_COMMON = 0
	RUNETYPE_BLOOD = 1
	RUNETYPE_UNHOLY = 2
	RUNETYPE_FROST = 3
	RUNETYPE_DEATH = 4

	RuneColors = {
		[RUNETYPE_COMMON] = ColorType(1, 1, 1),
		[RUNETYPE_BLOOD] = ColorType(1, 0, 0),
		[RUNETYPE_UNHOLY] = ColorType(0.1, 0.8, 0.1),
		[RUNETYPE_FROST] = ColorType(0, 1, 1),
		[RUNETYPE_DEATH] = ColorType(0.8, 0.1, 1),
	}

	RuneMapping = {
		[1] = "BLOOD",
		[2] = "UNHOLY",
		[3] = "FROST",
		[4] = "DEATH",
	}

	RuneBtnMapping = {
		[1] = 1,
		[2] = 2,
		[3] = 5,
		[4] = 6,
		[5] = 3,
		[6] = 4,
	}

	-----------------------------------------------
	--- iRuneButton
	-- @type class
	-- @name iRuneButton
	-----------------------------------------------
	class "iRuneButton"
		inherit "Button"
		extend "IFCooldownStatus"

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- RuneType
		property "RuneType" {
			Get = function(self)
				return self.__RuneType
			end,
			Set = function(self, value)
				if self.RuneType ~= value then
					self.__RuneType = value

					if value then
						self.CooldownStatus.Visible = true
						self.CooldownStatus.StatusBarColor = RuneColors[value]
					else
						self.CooldownStatus.Visible = false
					end
				end
			end,
			Type = System.Number + nil,
		}
		-- Ready
		property "Ready" {
			Get = function(self)
				return self.__Ready
			end,
			Set = function(self, value)
				if self.Ready ~= value then
					self.__Ready = value

					if value then
						self:OnCooldownUpdate()
						self.CooldownStatus.Activated = true
					else
						self.CooldownStatus.Activated = false
					end
				end
			end,
			Type = System.Boolean,
		}

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function iRuneButton(...)
			local obj = Super(...)

			-- Use these for cooldown
			local bar = iClassPowerButton("CooldownStatus", obj)
			bar:SetAllPoints()

			obj.IFCooldownStatusReverse = true
			obj.IFCooldownStatusAlwaysShow = true

			return obj
	    end
	endclass "iRuneButton"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iRuneBar(...)
		local panel = Super(...)
		local pct = floor(100 / MAX_RUNES)
		local margin = (100 - pct * MAX_RUNES + 1) / 2

		panel.FrameStrata = "LOW"
		panel.Toplevel = true

		local btnRune, pos

		for i = 1, MAX_RUNES do
			btnRune = iRuneButton("Individual"..i, panel)
			btnRune.ID = i

			panel:AddWidget(btnRune)

			pos = RuneBtnMapping[i]

			panel:SetWidgetLeftWidth(btnRune, margin + (pos-1)*pct, "pct", pct-1, "pct")

			panel[i] = btnRune
		end

		return panel
    end
endclass "iRuneBar"
