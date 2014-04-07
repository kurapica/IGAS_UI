IGAS:NewAddon "IGAS_UI.UnitFrame"

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
	inherit "HealthBarFrequent"
	extend "iBorder" "iStatusBarStyle"

	function Refresh(self, ...)
		if self.Unit == "target" then
			local classification = UnitClassification("target")
			if classification == "worldboss" or classification == "elite" then
				self.Back.BackdropBorderColor = Media.ELITE_BORDER_COLOR
			elseif classification == "rareelite" or classification == "rare" then
				self.Back.BackdropBorderColor = Media.RARE_BORDER_COLOR
			else
				self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
			end
		end
		return Super.Refresh(self, ...)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.UseClassColor = true
	end
endclass "iHealthBar"

class "iPowerBar"
	inherit "PowerBarFrequent"
	extend "iBorder" "iStatusBarStyle"
endclass "iPowerBar"

class "iHiddenManaBar"
	inherit "HiddenManaBar"
	extend "iBorder" "iStatusBarStyle"
endclass "iHiddenManaBar"

class "iCastBar"
	inherit "CastBar"

	function SetUpCooldownStatus(self, status)
		self.__CastBar = status
		Super.SetUpCooldownStatus(self, status)
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.CASTBAR_COLOR
	end
endclass "iCastBar"

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
		local width, height = self.Parent.Parent:GetSize()
		self.Parent:SetSize(width*1.05, height*2)
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
	end
endclass "iClassPowerButton"

class "iClassPower"
	inherit "Frame"
	extend "IFClassPower" "IFComboPoint"

	_MaxPower = 5

	SPELL_POWER_SOUL_SHARDS = _G.SPELL_POWER_SOUL_SHARDS
	SPELL_POWER_BURNING_EMBERS = _G.SPELL_POWER_BURNING_EMBERS
	SPELL_POWER_HOLY_POWER = _G.SPELL_POWER_HOLY_POWER
	SPELL_POWER_CHI = _G.SPELL_POWER_CHI

	MAX_POWER_PER_EMBER = _G.MAX_POWER_PER_EMBER

	PLAYER_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function RefreshBar(self)
		local numBar

		if self.ClassPowerType == SPELL_POWER_BURNING_EMBERS then
			numBar = floor(self.__Max / MAX_POWER_PER_EMBER)
			if numBar > 3 then
				numBar = 4
			end
		elseif self.ClassPowerType then
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
			self[i]:SetStatusBarColor(PLAYER_COLOR.r, PLAYER_COLOR.g, PLAYER_COLOR.b)
			self[i].Width = width
			self[i]:SetPoint("LEFT", 1 + (width + self.HSpacing) * (i - 1), 0)
			self[i].Activated = false
			self[i]:Show()

			if self.ClassPowerType == SPELL_POWER_BURNING_EMBERS then
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

		if self.ClassPowerType == SPELL_POWER_BURNING_EMBERS then
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

		if select(2, UnitClass("player")) == "ROGUE" or select(2, UnitClass("player")) == "DRUID" then
			self.Refresh = IFComboPoint.Refresh
			self.ClassPowerType = 100
			self.__Min, self.__Max = 0, _G.MAX_COMBO_POINTS
		end
    end
endclass "iClassPower"

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

	class "iRuneButton"
		inherit "Button"
		extend "IFCooldownStatus"

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- RuneType
		property "RuneType" {
			Field = "__RuneType",
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
			Field = "__Ready",
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
	    function iRuneButton(self, name, parent, ...)
			Super(self, name, parent, ...)

			-- Use these for cooldown
			local bar = iClassPowerButton("CooldownStatus", self)
			bar:SetAllPoints()

			self.IFCooldownStatusReverse = true
			self.IFCooldownStatusAlwaysShow = true

			return self
	    end
	endclass "iRuneButton"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iRuneBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		local pct = floor(100 / MAX_RUNES)
		local margin = (100 - pct * MAX_RUNES + 1) / 2

		self.FrameStrata = "LOW"
		self.Toplevel = true

		local btnRune, pos

		for i = 1, MAX_RUNES do
			btnRune = iRuneButton("Individual"..i, self)
			btnRune.ID = i

			self:AddWidget(btnRune)

			pos = RuneBtnMapping[i]

			self:SetWidgetLeftWidth(btnRune, margin + (pos-1)*pct, "pct", pct-1, "pct")

			self[i] = btnRune
		end
    end
endclass "iRuneBar"

class "iPlayerPowerText"
	inherit "PowerTextFrequent"

	function Refresh(self)
		local powerType = self.Unit and UnitPowerType(self.Unit) or 0

		if powerType == 0 or powerType == "MANA" then
			self.ShowPercent = true
		else
			self.ShowPercent = false
		end

		return Super.Refresh(self)
	end
endclass "iPlayerPowerText"

class "iEclipseBar"
	inherit "Frame"
	extend "IFEclipse"

	ECLIPSE_MARKER_COORDS = _G.ECLIPSE_MARKER_COORDS
	GameTooltip = _G.GameTooltip
	BALANCE = _G.BALANCE
	BALANCE_TOOLTIP = _G.BALANCE_TOOLTIP

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- SunActivated
	property "SunActivated" {
		Get = function(self)
			return self.SunBar.Activated
		end,
		Set = function(self, flag)
			self.SunBar.Activated = flag
		end,
		Type = Boolean,
	}
	-- MoonActivated
	property "MoonActivated" {
		Get = function(self)
			return self.MoonBar.Activated
		end,
		Set = function(self, flag)
			self.MoonBar.Activated = flag
		end,
		Type = Boolean,
	}
	-- EclipseDirection
	property "Direction" {
		Get = function(self)
			return self.__EclipseBar_Direction or IFEclipse.EclipseDirection.None
		end,
		Set = function(self, dir)
			if dir and self.__EclipseBar_Direction ~= dir then
				self.__EclipseBar_Direction = dir
				self.Marker:SetTexCoord(unpack(ECLIPSE_MARKER_COORDS[dir]))
			end
		end,
		Type = IFEclipse.EclipseDirection,
	}
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self.__Min, self.__Max)
		end,
		Set = function(self, value)
			self.__Min, self.__Max = value.min, value.max
		end,
		Type = System.MinMax,
	}
	-- Value
	property "Value" {
		Field = "__Value",
		Set = function(self, value)
			self.__Value = value

			self.PowerText.Text = tostring(abs(value))

			if self.__Max and self.__Max > 0 and value then
				self.Marker:SetPoint("CENTER", (value/self.__Max) *  (self.Width/2), 0)
			end
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iEclipseBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		local sunBar = iClassPowerButton("SunBar", self)
		local moonBar = iClassPowerButton("MoonBar", self)

		sunBar:SetPoint("TOP")
		sunBar:SetPoint("BOTTOM")
		sunBar:SetPoint("RIGHT")
		sunBar:SetPoint("LEFT", self, "CENTER", 1, 0)

		moonBar:SetPoint("TOP")
		moonBar:SetPoint("BOTTOM")
		moonBar:SetPoint("LEFT")
		moonBar:SetPoint("RIGHT", self, "CENTER", -1, 0)

		sunBar:SetStatusBarColor(1, 1, 0)
		moonBar:SetStatusBarColor(0.0, 0.6, 1)

		sunBar.FrameLevel = self.FrameLevel
		moonBar.FrameLevel = self.FrameLevel

		sunBar:SetMinMaxValues(0, 1)
		moonBar:SetMinMaxValues(0, 1)

		sunBar.Value = 1
		moonBar.Value = 1

		-- Marker
		local marker = Texture("Marker", self, "OVERLAY")
		marker.TexturePath = [[Interface\PlayerFrame\UI-DruidEclipse]]
		marker.BlendMode = "ADD"
		marker:SetSize(30, 30)
		marker:SetPoint("CENTER", 0, 2)
		marker:SetTexCoord(1.0, 0.914, 0.82, 1.0)

		-- PowerText
		local powerText = FontString("PowerText", self, "OVERLAY", "TextStatusBarText")
		powerText:SetPoint("CENTER")
		powerText.Visible = true
    end
endclass "iEclipseBar"

class "iStaggerBar"
	inherit "StatusBar"
	extend "IFStagger"

	local function OnShow(self)
		self.Ag.Playing = true
	end

	local function OnHide(self)
		self.Ag.Playing = false
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iStaggerBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH

    	self.FrameLevel = self.FrameLevel + 2
    	self:SetStatusBarColor(1, 0, 0)
    	self.Alpha = 0
    	self.Visible = false

    	-- Flashing
    	local ag = AnimationGroup("Ag", self)
    	ag.Looping = "REPEAT"

    	local alphaIn = Alpha("AlphaIn", ag)
    	alphaIn.Duration = 0.5
    	alphaIn.Order = 1
    	alphaIn.Change = 1

    	local alphaOut = Alpha("AlphaOut", ag)
    	alphaOut.StartDelay = 1
    	alphaOut.Duration = 0.5
    	alphaOut.Order = 2
    	alphaOut.Change = -1

    	self.OnShow = self.OnShow + OnShow
    	self.OnHide = self.OnHide + OnHide
    end
endclass "iStaggerBar"