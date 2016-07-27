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
	inherit "StatusBar"
	extend "IFHealthFrequent" "IFFaction" "IFTarget" "IFThreat"
	extend "iBorder" "iStatusBarStyle"

	_DefaultColor = ColorType(1, 1, 1)

	local function IsPlayerEffectivelyTank()
		local assignedRole = UnitGroupRolesAssigned("player")
		if assignedRole == "NONE" then
			local spec = GetSpecialization()
			return spec and GetSpecializationRole(spec) == "TANK"
		end

		return assignedRole == "TANK"
	end

	function Refresh(self, ...)
		IFHealthFrequent.Refresh(self)

		local unit = self.Unit
		if unit then
			if UnitIsUnit(unit, "target") then
				self.Back.BackdropBorderColor = Media.ACTIVED_BORDER_COLOR
			else
				self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
			end

			if UnitIsTapDenied(unit) then
				return self:SetStatusBarColor(0.5, 0.5, 0.5)
			end

			if not UnitIsPlayer(unit) then
				if UnitCanAttack("player", unit) then
					local status = UnitThreatSituation("player", unit)
					if status and status > 0 then
						if IsPlayerEffectivelyTank() then
							local isTanking = UnitDetailedThreatSituation("player", unit)
							if self.isTanking ~= isTanking then
								if self.isTanking and not isTanking then
									self.LoseAggro.Playing = true
								end
							end
						end
						return self:SetStatusBarColor(GetThreatStatusColor(status))
					end
				end

				return self:SetStatusBarColor(UnitSelectionColor(unit))
			else
				local status = UnitThreatSituation(unit)
				if status and status > 0 then
					return self:SetStatusBarColor(GetThreatStatusColor(status))
				end

				self.StatusBarColor = RAID_CLASS_COLORS[select(2, UnitClass(unit))] or _DefaultColor
			end
		end
	end

	function iHealthBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "LOW"

		local animLoseAggro = AnimationGroup("LoseAggro", self)

		local alpha = Alpha("Alpha1", animLoseAggro)
		alpha.Order = 1
		alpha.Duration = 0.3
		alpha.FromAlpha = 1
		alpha.ToAlpha = 0

		alpha = Alpha("Alpha2", animLoseAggro)
		alpha.Order = 2
		alpha.Duration = 0.3
		alpha.FromAlpha = 1
		alpha.ToAlpha = 0
	end
endclass "iHealthBar"

class "iPowerBar"
	inherit "PowerBarFrequent"
	extend "iBorder" "iStatusBarStyle"
endclass "iPowerBar"

class "iCastBar"
	inherit "Frame"
	extend "IFCast" "IFCooldownStatus"
	extend "iBorder"

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	function SetUpCooldownStatus(self, status)
		status:ClearAllPoints()
		status:SetAllPoints()
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.CASTBAR_COLOR
		status.MinMaxValue = MinMax(1, 100)
		status.Layer = "BORDER"
	end

	function Start(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(self.Unit)

		if not name then
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Icon.Width = self.Icon.Height
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

		self.Icon.Width = self.Icon.Height
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
		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnHide(self)
		self:OnCooldownUpdate()
		self.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iCastBar(self, ...)
		Super(self, ...)

		local bgColor = Texture("Bg", self, "BACKGROUND")
		bgColor:SetTexture(0, 0, 0, 1)
		bgColor:SetAllPoints()

		local icon = Frame("Icon", self)
		icon.FrameStrata = "LOW"
		icon.Backdrop = _BackDrop
		icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT")
		icon:SetSize(32, 32)

		-- Icon
		local iconTxt = Texture("Texture", icon, "BACKGROUND")
		iconTxt:SetAllPoints()

		local nameBack = Frame("NameBack", self)
		nameBack:SetAllPoints()

		-- SpellName
		local text = FontString("SpellName", nameBack, "OVERLAY")
		text:SetVertexColor(1, 1, 1)
		text.FontObject = Media.CAST_FONT
		text:SetPoint("CENTER", self, "BOTTOM")

		self.OnHide = self.OnHide + OnHide
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
			if name and duration > 0 and duration <= 60 then return true end
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

		self.ColumnCount = 4
		self.RowCount = 3
		self.ElementWidth = 24
		self.ElementHeight = 24
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false
		self.LeftToRight = true
    end
endclass "iAuraPanel"

class "iNameLabel"
	inherit "Frame"
	extend "IFUnitName" "IFFaction" "IFUnitLevel"

	local function parseColor(str, r, g, b)
		local color = ("\124cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		return color .. str .. "|r"
	end

	function Refresh(self)
		local unit = self.Unit
		if unit and UnitIsUnit("player", unit) then
			self.Visible = false
		else
			-- Parse Level
			local value = unit and UnitLevel(unit)
			local lvlText

			if value and value > 0 then
				if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
					local petLevel = UnitBattlePetLevel(unit)

					lvlText = parseColor(self.LevelFormat:format(petLevel), 1.0, 0.82, 0.0)
				else
					if UnitCanAttack("player", unit) then
						local color = GetQuestDifficultyColor(value)
						lvlText = parseColor(self.LevelFormat:format(value), color.r, color.g, color.b)
					else
						lvlText = parseColor(self.LevelFormat:format(value), 1.0, 0.82, 0.0)
					end
				end
			else
				lvlText = parseColor(self.LevelFormat:format("???") , 1.0, 0.82, 0.0)
			end

			-- Parse Name
			local nameText

			if unit then
				local name = GetUnitName(unit, self.WithServerName) or unit
				if self.UseTapColor and UnitIsTapDenied(unit) then
					nameText = parseColor(name, 0.5, 0.5, 0.5)
				elseif self.UseSelectionColor and not UnitIsPlayer(unit) then
					nameText = parseColor(name, UnitSelectionColor(unit))
				elseif self.UseClassColor then
					local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
					if color then
						nameText = parseColor(name, color.r, color.g, color.b)
					else
						nameText = parseColor(name, 1, 1, 1)
					end
				else
					nameText = parseColor(name, 1, 1, 1)
				end
			else
				nameText = parseColor(L"Unknown", 1, 1, 1)
			end

			self.Label.Text = lvlText .. " " .. nameText
			self.Visible = true
		end
	end

	__Handler__( Refresh )
	property "LevelFormat" { Type = String, Default = "%s" }

	__Handler__(Refresh)
	property "WithServerName" { Type = Boolean }

	__Handler__( Refresh )
	property "UseTapColor" { Type = Boolean }

	__Handler__( Refresh )
	property "UseSelectionColor" { Type = Boolean }

	__Handler__( Refresh )
	property "UseClassColor" { Type = Boolean }

	function iNameLabel(self, ...)
		Super(self, ...)

		local label = FontString("Label", self, "ARTWORK")
		label:SetPoint("BOTTOM")
		label.FontObject = Media.NAME_FONT
	end
endclass "iNameLabel"

class "iClassPowerButton"
	inherit "StatusBar"
	extend "iBorder" "iStatusBarStyle"

	--------------------------------
	-- Property
	--------------------------------
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

				self:SetWidgetLeftWidth(btnRune, margin + (i-1)*pct, "pct", pct-2, "pct")

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