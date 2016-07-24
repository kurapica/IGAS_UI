IGAS:NewAddon "IGAS_UI.NamePlate"

--==========================
-- Interfaces
--==========================
interface "iStatusBarStyle"
	_BACK_MULTI = 0.2
	_BACK_ALPHA = 0.8

	local oldSetStatusBarColor = StatusBar.SetStatusBarColor

	local function SetStatusBarColor(self, r, g, b, a)
	    if r then
	        oldSetStatusBarColor(self, r, g, b)

	        self.Bg:SetVertexColor(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    end
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function iStatusBarStyle(self)
		self.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH

		local bgColor = Texture("Bg", self, "BACKGROUND")
		bgColor:SetTexture(1, 1, 1, 1)
		bgColor:SetAllPoints()
		self.Bg = bgColor	-- For quick access

		self.SetStatusBarColor = SetStatusBarColor
    end
endinterface "iStatusBarStyle"

interface "iBorder"
	THIN_BORDER = {
	    edgeFile = "Interface\\Buttons\\WHITE8x8",
	    edgeSize = 1,
	}

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function iBorder(self)
		local bg = Frame("Back", self)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = THIN_BORDER
		bg.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
    end
endinterface "iBorder"

--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "HealthBar"
	extend "iBorder" "iStatusBarStyle"

	_DefaultColor = ColorType(1, 1, 1)

	function Refresh(self, ...)
		local unit = self.Unit
		if unit then
			if UnitIsTapDenied(unit) then
				return self:SetStatusBarColor(0.5, 0.5, 0.5)
			end

			if not UnitIsPlayer(unit) then
				self:SetStatusBarColor(UnitSelectionColor(unit))
			else
				self.StatusBarColor = RAID_CLASS_COLORS[select(2, UnitClass(unit))] or _DefaultColor
			end
		end
		return Super.Refresh(self, ...)
	end
endclass "iHealthBar"

class "iPowerBar"
	inherit "PowerBar"
	extend "iBorder" "iStatusBarStyle"
endclass "iPowerBar"

class "iCastBar"
	inherit "CastBar"
	extend "iBorder"

	function SetUpCooldownStatus(self, status)
		self.__CastBar = status
		Super.SetUpCooldownStatus(self, status)
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.CASTBAR_COLOR
	end
endclass "iCastBar"

class "iAuraPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		local unit = self.Unit

		local filter

		if unit then
			if UnitIsUnit("player", unit) then
				filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY"
			else
				local reaction = UnitReaction("player", unit)
				if reaction and reaction <= 4 then
				-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
					filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY"
				end
			end
		end

		if filter then
			self.Filter = filter
			self.HasFilter = true
		else
			self.HasFilter = false
		end

		return Super.Refresh(self)
	end

	function CustomFilter(self, unit, index, filter)
		if not self.HasFilter then return false end

		if UnitIsUnit("player", unit) then
			local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)
			if name and duration > 0 then return true end
		else
			return true
		end
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iAuraPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 24
		self.ElementHeight = 24
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false
		self.LeftToRight = false
    end
endclass "iAuraPanel"

class "iNameLabel"
	inherit "NameLabel"
	function Refresh(self)
		if self.Unit and UnitIsUnit("player", self.Unit) then
			self.Visible = false
		else
			return Super.Refresh(self)
		end
	end
endclass "iNameLabel"

class "iClassPowerButton"
	inherit "StatusBar"
	extend "iBorder" "iStatusBarStyle"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Activated
	property "Activated" {
		Field = "__Activated",
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
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function AnimIn_OnPlay(self)
		self.Parent.Alpha = 0
		local width, height = self.Parent.Parent:GetSize()
		if width > 0 and height > 0 then
			self.Parent:SetSize(width*1.04, height*2)
		end
	end

	local function AnimIn_OnFinished(self)
		self.Parent.Alpha = 1
		local width, height = self.Parent.Parent:GetSize()
		if width > 0 and height > 0 then
			self.Parent:SetSize(width*1.04, height*2)
		end
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
	function iClassPowerButton(self, name, parent, ...)
		Super(self, name, parent, ...)

		local glow = Texture("Glow", self, "ARTWORK")
		glow.Alpha = 0
		glow.TexturePath = [[Interface\SpellActivationOverlay\IconAlert]]
		--glow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
		glow:SetTexCoord(0.13, 0.395, 0.27734375, 0.52734375)
		glow:SetPoint("CENTER")

		local animIn = AnimationGroup("AnimIn", glow)

		local alpha = Alpha("Alpha", animIn)
		alpha.Order = 1
		alpha.Duration = 0.2
		alpha.FromAlpha = 0
		alpha.ToAlpha = 1

		animIn.OnPlay = AnimIn_OnPlay
		animIn.OnFinished = AnimIn_OnFinished

		local animOut = AnimationGroup("AnimOut", glow)

		alpha = Alpha("Alpha", animOut)
		alpha.Order = 1
		alpha.Duration = 0.2
		alpha.FromAlpha = 1
		alpha.ToAlpha = 0

		animOut.OnPlay = AnimOut_OnPlay
		animOut.OnFinished = AnimOut_OnFinished
	end
endclass "iClassPowerButton"

class "iClassPower"
	inherit "Frame"
	extend "IFClassPower"

	_MaxPower = 8

	SPELL_POWER_HOLY_POWER = _G.SPELL_POWER_HOLY_POWER

	PLAYER_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function RefreshBar(self)
		local numBar

		if self.ClassPowerType then
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

		local width = floor((self.Parent.Width - 2 - self.HSpacing * (numBar-1)) / numBar)

		self.__NumBar = numBar

		for i = 1, numBar do
			self[i].StatusBarColor = PowerBarColor[self.ClassPowerType]
			self[i].Width = width
			self[i]:SetPoint("LEFT", 1 + (width + self.HSpacing) * (i - 1), 0)
			self[i].Activated = false
			self[i]:Show()

			if numBar == 1 then
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

		if self.__NumBar == 1 then
			self[1].Value = value
		else
			local needActive = false

			if self.ClassPowerType == SPELL_POWER_HOLY_POWER then
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
		Field = "__Value",
		Set = function(self, value)
			if self.__Value ~= value then
				self.__Value = value
				return self:RefreshValue()
			end
		end,
		Type = NumberNil,
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
		Type = MinMax,
	}
	-- ClassPowerType
	property "ClassPowerType" {
		Type = NumberNil,
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
    function iClassPower(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.HSpacing = 3

		for i = 1, _MaxPower do
			self[i] = iClassPowerButton("Bar"..i, self)
			self[i]:Hide()
			self[i]:SetPoint("TOP")
			self[i]:SetPoint("BOTTOM")
		end

		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged
    end
endclass "iClassPower"

class "iRuneBar"
	inherit "LayoutPanel"
	extend "IFRune"

	RuneColor = ColorType(0.8, 0.1, 1)

	class "iRuneButton"
		inherit "Button"
		extend "IFCooldownStatus"

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- Ready
		property "Ready" {
			Handler = function(self, value)
				if value then
					self:OnCooldownUpdate()
					self.CooldownStatus.Activated = true
				else
					self.CooldownStatus.Activated = false
				end
			end,
			Type = Boolean,
		}

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function iRuneButton(self, name, parent, ...)
			Super(self, name, parent, ...)

			-- Use these for cooldown
			local bar = iClassPowerButton("CooldownStatus", self)
			bar:SetAllPoints()

			self.IFCooldownStatusReverse = true
			self.IFCooldownStatusAlwaysShow = true

			bar.Visible = true
			bar.StatusBarColor = RuneColor
			return self
	    end
	endclass "iRuneButton"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "Max" {
		Handler = function(self, value)
			local pct = floor(100 / value)
			local margin = (100 - pct * value + 1) / 2

			self.FrameStrata = "LOW"
			self.Toplevel = true

			local btnRune

			for i = 1, value do
				btnRune = iRuneButton("Individual"..i, self)
				btnRune.ID = i

				self:AddWidget(btnRune)

				self:SetWidgetLeftWidth(btnRune, margin + (i-1)*pct, "pct", pct-1, "pct")

				self[i] = btnRune
			end
		end,
		Type = Number,
	}
endclass "iRuneBar"

class "iStaggerBar"
	inherit "StatusBar"
	extend "IFStagger"
	extend "iBorder" "iStatusBarStyle"

	local color = {
		{r = 0.52, g = 1.0, b = 0.52},
		{r = 1.0, g = 0.98, b = 0.72},
		{r = 1.0, g = 0.42, b = 0.42},
	}

	function SetValue(self, value)
		value = value or 0

		local min, max = self:GetMinMaxValues()
		local per = value / max
		local perColor = per < 0.3 and 1 or per < 0.6 and 2 or 3
		if self.PerColor ~= perColor then
			self.PerColor = perColor
			self.StatusBarColor = color[perColor]
		end
		Super.SetValue(self, value)
	end
endclass "iStaggerBar"