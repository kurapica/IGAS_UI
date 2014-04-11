IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Elements for UnitFrame
--==========================
interface "IFStatusBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFStatusBar(self)
    	self.FrameStrata = "MEDIUM"
    	self.StatusBarTexturePath = TextureMap.Blank
    	self.DefaultColor = TextureMap.DefaultBarColor

    	local bg = Texture("Bg", self, "BACKGROUND")
		bg.Color = TextureMap.BackgroundColor
		bg:SetAllPoints(self)
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

class "iHiddenManaBar"
	inherit "HiddenManaBar"
	extend "IFStatusBar"
endclass "iHiddenManaBar"

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
		return Super.SetText(self, text and text ~= "" and ("> " .. text) or "")
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iTargetName(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.JustifyH = "LEFT"
		self.DrawLayer = "BORDER"
		self.Font = FontType(FontMap.HandelGotD, 10, "NORMAL", false)
	end
endclass "iTargetName"

class "iCastBar"
	inherit "CastBar"

	_Empty = {}

	function SetUpCooldownStatus(self, status)
		Super.SetUpCooldownStatus(self, status)
		status.StatusBarTexturePath = TextureMap.Blank
		status.StatusBarColor = TextureMap.CASTBAR_COLOR
	end

	function SetAlpha(self, alpha)
		local parent = self.Parent.Parent
		local unit = self.Unit
		local flag = alpha < 0.5

		if not unit then return end

		if not self.HideWhenCast then
			for _, unitset in ipairs(Config.Units) do
				if unit:match(unitset.Unit) then
					self.HideWhenCast = unitset.HideWhenCast or _Empty
					break
				end
			end
		end

		for _, ele in ipairs(self.HideWhenCast) do
			ele = Config.Elements[ele]

			local obj = ele.Name and parent:GetElement(ele.Name) or parent:GetElement(ele.Type)

			if obj then
				obj.Visible = flag
			end
		end

		Super.SetAlpha(self, alpha)
	end

	function iCastBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "HIGH"
	end
endclass "iCastBar"

class "iClassPowerButton"
	inherit "StatusBar"
	extend "IFStatusBar"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Handler__( function(self, value)
		self.Glow.AnimOut.Playing = not value
		self.Glow.AnimIn.Playing = value
	end )
	property "Activated" { Type = System.Boolean }

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

		local value = self.Value

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
	__Handler__( RefreshValue )
	property "Value" { Type = System.Number + nil }
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
		__Handler__( function(self, value)
			if value then
				self.CooldownStatus.Visible = true
				self.CooldownStatus.StatusBarColor = RuneColors[value]
			else
				self.CooldownStatus.Visible = false
			end
		end )
		property "RuneType" { Type = System.Number + nil }

		__Handler__( function(self, value)
			if value then
				self:OnCooldownUpdate()
				self.CooldownStatus.Activated = true
			else
				self.CooldownStatus.Activated = false
			end
		end )
		property "Ready" { Type = System.Boolean }

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

	__Handler__( function (self, value)
		self.Marker:SetTexCoord(unpack(ECLIPSE_MARKER_COORDS[value]))
	end )
	property "Direction" { Type = IFEclipse.EclipseDirection, Default = IFEclipse.EclipseDirection.None }

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

	__Handler__( function (self, value)
		self.PowerText.Text = tostring(abs(value))

		if self.__Max and self.__Max > 0 and value then
			self.Marker:SetPoint("CENTER", (value/self.__Max) *  (self.Width/2), 0)
		end
	end )
	property "Value" { Type = System.Number }

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
	extend "IFStagger" "IFStatusBar"

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

		self.StatusBarTexturePath = TextureMap.Blank

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