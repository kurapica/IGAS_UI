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
	inherit "Frame"
	extend "IFCast" "IFCooldownLabel" "IFCooldownStatus"

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	_DELAY_TEMPLATE = FontColor.RED .. "(%.1f)" .. FontColor.CLOSE

	-- Update SafeZone
	local function Status_OnValueChanged(self, value)
		local parent = self.Parent

		if parent.Unit ~= "player" then
			return
		end

		local _, _, _, latencyWorld = GetNetStats()

		if latencyWorld == parent.LatencyWorld then
			-- well, GetNetStats update every 30s, so no need to go on
			return
		end

		parent.LatencyWorld = latencyWorld

		if latencyWorld > 0 and parent.Duration and parent.Duration > 0 then
			parent.SafeZone.Visible = true

			local pct = latencyWorld / parent.Duration / 1000

			if pct > 1 then pct = 1 end

			parent.SafeZone.Width = self.Width * pct
		else
			parent.SafeZone.Visible = false
		end
	end

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetUpCooldownLabel(self, label)
		label:SetPoint("RIGHT")
		label.JustifyH = "RIGHT"
		label.FontObject = "TextStatusBarText"
	end

	function SetUpCooldownStatus(self, status)
		status:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT")
		status:SetPoint("BOTTOMRIGHT")
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.CASTBAR_COLOR
		status.MinMaxValue = MinMax(1, 100)
		status.Layer = "BORDER"

		status.OnValueChanged = status.OnValueChanged + Status_OnValueChanged
	end

	function Start(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(self.Unit)

		if not name then
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		self.NameBack.SpellName.Text = name
		self.LineID = lineID

		if notInterruptible then
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
		else
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		end

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = true

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("RIGHT")
		self.SafeZone.Visible = false

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	function Fail(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Stop(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Interrupt(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Interruptible(self)
		self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
	end

	function UnInterruptible(self)
		self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
	end

	function Delay(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime = UnitCastingInfo(self.Unit)

		if not startTime or not endTime then return end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.EndTime = self.EndTime or endTime
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration
		self.NameBack.SpellName.Text = name .. self.DelayFormatString:format(self.DelayTime)

		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStart(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(self.Unit)

		if not name then
			self.Alpha = 0
			self.Duration = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		self.NameBack.SpellName.Text = name

		if notInterruptible then
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
		else
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		end

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = false

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("LEFT", self.Icon, "RIGHT")
		self.SafeZone.Visible = false

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	function ChannelUpdate(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime = UnitChannelInfo(self.Unit)

		if not name or not startTime or not endTime then
			self:OnCooldownUpdate()
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.EndTime = self.EndTime or endTime
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration
		if self.DelayTime > 0 then
			self.NameBack.SpellName.Text = name .. self.DelayFormatString:format(self.DelayTime)
		end
		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The delay time format string like "%.1f"]]
	property "DelayFormatString" { Type = String, Default = _DELAY_TEMPLATE }

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if self.Height > 0 then
			self.Icon.Width = self.Height
			self.NameBack.SpellName:SetFont(self.NameBack.SpellName:GetFont(), self.Height * 4 / 7, "OUTLINE")
		end
	end

	local function OnHide(self)
		self:OnCooldownUpdate()
		self.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iCastBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Height = 16
		self.Width = 200

		self.IFCooldownLabelUseDecimal = true
		self.IFCooldownLabelAutoColor = false

		-- Icon
		local icon = Frame("Icon", self)
		icon.FrameStrata = "LOW"
		icon.Backdrop = _BackDrop
		icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMLEFT")
		icon.Width = self.Height

		-- Icon
		local iconTxt = Texture("Texture", icon, "BACKGROUND")
		iconTxt:SetAllPoints()

		local nameBack = Frame("NameBack", self)
		nameBack:SetAllPoints()

		-- SpellName
		local text = FontString("SpellName", nameBack, "OVERLAY", "TextStatusBarText")
		text:SetPoint("LEFT", icon, "RIGHT")
		text.JustifyH = "LEFT"
		text:SetFont(text:GetFont(), self.Height * 4 / 7, "OUTLINE")

		-- SafeZone
		local safeZone = Texture("SafeZone", self, "ARTWORK")
		safeZone.Color = ColorType(1, 0, 0)
		safeZone.Visible = false

		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged
		self.OnHide = self.OnHide + OnHide
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
		Handler = function(self, value)
			if value then
				self.Back.BackdropBorderColor = Media.ACTIVED_BORDER_COLOR
			else
				self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
			end
		end,
		Type = Boolean,
	}
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