IGAS:NewAddon "IGAS_UI"

--==========================
-- Share Features
--==========================
Media = {
	-- Status bar texture
	STATUSBAR_TEXTURE_PATH = [[Interface\Addons\IGAS_UI\Resource\healthtex.tga]],
	--STATUSBAR_TEXTURE_PATH2 = [[Interface\Addons\IGAS_UI\Resource\powertex.tga]],

	--BORDER_TEXTURE_PATH = [[Interface\Common\WhiteIconFrame]],
	BORDER_TEXTURE_PATH = [[Interface\Addons\IGAS_UI\Resource\border.tga]],

	-- Color settings
	DEFAULT_BORDER_COLOR = ColorType(0, 0, 0),
	ACTIVED_BORDER_COLOR = ColorType(1, 1, 1),
	WARN_BORDER_COLOR = ColorType(1, 0, 0),
	PLAYER_CLASS_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))],

	--- Elite target border color
	ELITE_BORDER_COLOR = ColorType(1, 0.84, 0),

	--- Rare target border color
	RARE_BORDER_COLOR = ColorType(0.75, 0.75, 0.75),

	--- Cast bar color
	CASTBAR_COLOR = ColorType(0.25, 0.78, 0.92),
	NAMEPLATE_CASTBAR_COLOR = ColorType(0.25, 0.78, 0.92),
	CASTBAR_BORDER_NORMAL_COLOR = ColorType(1, 1, 1),
	CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR = ColorType(0.77, 0.12 , 0.23),

	DEFAULT_BACKDROP = {
	    edgeFile = "Interface\\Buttons\\WHITE8x8",
	    edgeSize = 1,
	}
}

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
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function iBorder(self)
		local bg = Frame("Back", self)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = Media.DEFAULT_BACKDROP
		bg.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
    end
endinterface "iBorder"

interface "IFStyle"
	_PUSH_COLOR = ColorType(1 - Media.PLAYER_CLASS_COLOR.r, 1-Media.PLAYER_CLASS_COLOR.g, 1-Media.PLAYER_CLASS_COLOR.b)

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	_IconLoc = {
		AnchorPoint("TOPLEFT", 2, -2),
		AnchorPoint("BOTTOMRIGHT", -2, 2),
	}

	_BorderLoc = {
		AnchorPoint("TOPLEFT", -12, 12),
		AnchorPoint("BOTTOMRIGHT", 12, -12),
	}

	local function OnSizeChanged(self)
		local size = math.min(self.Width, self.Height)
		local border = math.max(2, math.ceil(size/24))

		self:GetChild("Icon").Location = {
			AnchorPoint("TOPLEFT", border, -border),
			AnchorPoint("BOTTOMRIGHT", -border, border),
		}

		if self:GetChild("HotKey") then self:GetChild("HotKey").Location = { AnchorPoint("TOPRIGHT", -border, -border) } end
		self:GetChild("Count").Location = { AnchorPoint("BOTTOMRIGHT", -border, border) }
		self:GetChild("Name").Location = { AnchorPoint("BOTTOM", 0, border) }

		border = math.floor(12 * size / 32)
		self:GetChild("Border").Location = {
			AnchorPoint("TOPLEFT", -border, border),
			AnchorPoint("BOTTOMRIGHT", border, -border),
		}
	end

    function IFStyle(self)
    	self.UseBlizzardArt = false

		self.NormalTexturePath = Media.BORDER_TEXTURE_PATH
		self.NormalTexture:ClearAllPoints()
		self.NormalTexture:SetAllPoints()
		self.NormalTexture.VertexColor = Media.PLAYER_CLASS_COLOR

		self.PushedTexturePath = Media.BORDER_TEXTURE_PATH
		self.PushedTexture.VertexColor = _PUSH_COLOR

		self:GetChild("Icon").Location = _IconLoc
		self:GetChild("Border").Location = _BorderLoc

		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged
    end
endinterface "IFStyle"

interface "IFSoulFragment"
	local min = math.min

	SPEC_DEMONHUNTER_VENGENCE = 2
	SOULFRAGMENT = 203981
	SOULFRAGMENTNAME = GetSpellInfo(SOULFRAGMENT)

	PowerBarColor[SOULFRAGMENT] = RAID_CLASS_COLORS.DEMONHUNTER

	local function PLAYER_SPECIALIZATION_CHANGED(self)
		if self.Unit == "player" and GetSpecialization() == SPEC_DEMONHUNTER_VENGENCE then
			self:RegisterUnitEvent("UNIT_AURA", "player")
			self:SetClassPowerVisible(true)
			self:SetClassPowerType(SOULFRAGMENT)
			self:SetUnitClassPower(min((select(4, UnitAura("player", SOULFRAGMENTNAME))) or 0, 5), 5)
		else
			self:SetClassPowerVisible(false)
			self:UnregisterEvent("UNIT_AURA")
		end
	end

	local function UNIT_AURA(self)
		self:SetUnitClassPower(min((select(4, UnitAura("player", SOULFRAGMENTNAME))) or 0, 5), 5)
	end

	function IFSoulFragment(self)
		if select(2, UnitClass("player")) == "DEMONHUNTER" then
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
			self.PLAYER_SPECIALIZATION_CHANGED = PLAYER_SPECIALIZATION_CHANGED
			self.UNIT_AURA = UNIT_AURA

			PLAYER_SPECIALIZATION_CHANGED(self)

			self.OnUnitChanged = self.OnUnitChanged + PLAYER_SPECIALIZATION_CHANGED
			self.OnForceRefresh = self.OnForceRefresh + PLAYER_SPECIALIZATION_CHANGED
		end
	end
endinterface "IFSoulFragment"

--==========================
-- Elements
--==========================
class "iPowerBarFrequent"
	inherit "PowerBarFrequent"
	extend "iBorder" "iStatusBarStyle"

	function iPowerBarFrequent(self, ...)
		Super(self, ...)

		self.FrameStrata = "BACKGROUND"
	end
endclass "iPowerBarFrequent"

class "iPowerBar"
	inherit "PowerBar"
	extend "iStatusBarStyle""iBorder"

	function iPowerBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "BACKGROUND"
	end
endclass "iPowerBar"

class "iHiddenManaBar"
	inherit "HiddenManaBar"
	extend "iBorder" "iStatusBarStyle"

	function iHiddenManaBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "BACKGROUND"
	end
endclass "iHiddenManaBar"

class "iPlayerPowerText"
	inherit "StatusText"
	extend "IFPowerFrequent"

	local abs = math.abs

	local function formatValue(self, value)
		if abs(value) >= 10^9 then
			return self.ValueFormat:format(value / 10^9) .. "b"
		elseif abs(value) >= 10^6 then
			return self.ValueFormat:format(value / 10^6) .. "m"
		elseif abs(value) >= 10^4 then
			return self.ValueFormat:format(value / 10^3) .. "k"
		else
			return tostring(value)
		end
	end

	local function RefreshStatus(self)
		if self.Value and self.Value ~= self.Max then
			if self.ShowPercent and self.Max then
				if self.Max > 0 then
					if self.Value > self.Max then
						self.Text = self.PercentFormat:format(100)
					else
						self.Text = self.PercentFormat:format(self.Value * 100 / self.Max)
					end
				else
					self.Text = self.PercentFormat:format(0)
				end
			else
				self.Text = formatValue(self, self.Value)
			end

			if self.Text == "0" then
				self.Text = " "
			end
		else
			self.Text = " "
		end
	end

	function SetUnitPower(self, value, max)
		self.Max = max or 100
		self.Value = value or 0
		return RefreshStatus(self)
	end

	__Handler__ ( RefreshStatus )
	property "ValueFormat" { Type = String, Default = "%.2f" }

	__Handler__ ( RefreshStatus )
	property "ShowPercent" { Type = Boolean }

	__Handler__ ( RefreshStatus )
	property "PercentFormat" { Type = String, Default = "%d%%" }

	function SetUnitPowerType(self, powerType)
		if powerType == 0 or powerType == "MANA" then
			self.ShowPercent = true
		else
			self.ShowPercent = false
		end
	end

	function iPlayerPowerText(self, ...)
		Super(self, ...)

		self.FontObject = IGAS.TextStatusBarText
		self.DrawLayer = "OVERLAY"
	end
endclass "iPlayerPowerText"

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
	extend "IFSoulFragment"

	_MaxPower = 8

	SPELL_POWER_HOLY_POWER = _G.SPELL_POWER_HOLY_POWER

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetUnitClassPower(self, value, max)
		if max then self.MaxValue = max end
		if value then self.Value = value end
	end

	function SetClassPowerType(self, ty)
		self.PowerType = ty
	end

	function RefreshBar(self)
		if not self.PowerType then return end
		local numBar = self.MaxValue

		if numBar > _MaxPower then numBar = 1 end

		for i = _MaxPower, numBar + 1, -1 do
			self[i]:Hide()
		end

		local width = floor((self.Parent.Width - 2 - self.HSpacing * (numBar-1)) / numBar)

		self.__NumBar = numBar

		for i = 1, numBar do
			self[i].StatusBarColor = PowerBarColor[self.PowerType]
			self[i]:ClearAllPoints()
			self[i]:SetPoint("TOP")
			self[i]:SetPoint("BOTTOM")
			self[i]:SetPoint("LEFT", 1 + (width + self.HSpacing) * (i - 1), 0)
			if i == numBar then
				self[i]:SetPoint("RIGHT", -1, 0)
			else
				self[i].Width = width
			end
			self[i].Activated = false
			self[i]:Show()

			if numBar == 1 then
				self[i]:SetMinMaxValues(0, self.MaxValue)
			else
				self[i]:SetMinMaxValues(0, 1)
			end
		end

		return self:RefreshValue()
	end

	function RefreshValue(self)
		if not self.__NumBar then return end

		local value = self.Value or 0

		if self.__NumBar == 1 then
			self[1].Value = value
		else
			local needActive = false

			if self.PowerType == SPELL_POWER_HOLY_POWER then
				if value >= 3 then
					needActive = true
				end
			elseif value >= self.MaxValue then
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
	property "Value" { Handler = RefreshValue, Type = Number }
	-- MinMaxValue
	property "MaxValue" { Handler = RefreshBar,	Type = Number }
	-- PowerType
	property "PowerType" { Handler = RefreshBar, Type = NumberNil }

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

		self.OnSizeChanged = self.OnSizeChanged + RefreshBar
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
	    end
	endclass "iRuneButton"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetRuneByIndex(self, index, start, duration, ready, isEnergize)
		local btn = self[index]
		if not btn then return end

		if not ready then
			if start then
				btn:Fire("OnCooldownUpdate", start, duration)
			end
			btn.Ready = false
		else
			btn.Ready = true
		end
	end

	function SetMaxRune(self, max)
		local pct = floor(100 / max)
		local margin = (100 - pct * max + 1) / 2

		self.FrameStrata = "LOW"
		self.Toplevel = true

		local btnRune

		for i = 1, max do
			btnRune = iRuneButton("Individual"..i, self)
			btnRune.ID = i

			self:AddWidget(btnRune)

			self:SetWidgetLeftWidth(btnRune, margin + (i-1)*pct, "pct", pct-1.5, "pct")

			self[i] = btnRune
		end
	end
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

	function SetUnitStagger(self, value, max)
		value = value or 0
		max = max or math.max(100, value)

		local per = value / max
		local perColor = per < 0.3 and 1 or per < 0.6 and 2 or 3
		if self.PerColor ~= perColor then
			self.PerColor = perColor
			self.StatusBarColor = color[perColor]
		end

		self:SetMinMaxValues(0, max)
		self:SetValue(value)
	end
endclass "iStaggerBar"

class "iAuraIcon"
	inherit "Frame"
	extend "IFCooldownIndicator"

	DebuffTypeColor = {}
	DebuffTypeColor["none"] = { r = 0.80, g = 0, b = 0 }
	DebuffTypeColor["Magic"]    = { r = 0.20, g = 0.60, b = 1.00 }
	DebuffTypeColor["Curse"]    = { r = 0.60, g = 0.00, b = 1.00 }
	DebuffTypeColor["Disease"]  = { r = 0.60, g = 0.40, b = 0 }
	DebuffTypeColor["Poison"]   = { r = 0.00, g = 0.60, b = 0 }
	DebuffTypeColor[""] = DebuffTypeColor["none"]

	function SetUpCooldownIndicator(self, indicator)
		indicator:SetHideCountdownNumbers(true)
		indicator:SetPoint("TOPLEFT", 2, -2)
		indicator:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	function Refresh(self, unit, index, filter)
		local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

		if name then
			self.Index = index

			-- Texture
			self.Icon.TexturePath = texture
			if texture then self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end

			-- Count
			if count and count > 1 then
				self.Count.Visible = true
				self.Count.Text = tostring(count)
			else
				self.Count.Visible = false
			end

			-- Stealable
			self.Stealable.Visible = not UnitIsUnit("player", unit) and isStealable

			-- Debuff
			if filter and not filter:find("HELPFUL") then
				self.Mask.VertexColor = DebuffTypeColor[dtype] or DebuffTypeColor.none
			else
				self.Mask.VertexColor = Media.ACTIVED_BORDER_COLOR
			end

			-- Remain
			self:OnCooldownUpdate(expires - duration, duration)

			self.Visible = true
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function UpdateTooltip(self)
		self = IGAS:GetWrapper(self)
		IGAS.GameTooltip:SetUnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)
	end

	local function OnEnter(self)
		if self.Visible then
			IGAS.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
			UpdateTooltip(self)
		end
	end

	local function OnLeave(self)
		IGAS.GameTooltip.Visible = false
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The aura index]]
	property "Index" { Type = Number }

	__Doc__[[Whether show the tooltip of the aura]]
	__Handler__( function(self, flag)
		if flag then
			self.OnEnter = self.OnEnter + OnEnter
			self.OnLeave = self.OnLeave + OnLeave
			self.MouseEnabled = true
		else
			self.OnEnter = self.OnEnter - OnEnter
			self.OnLeave = self.OnLeave - OnLeave
			self.MouseEnabled = false
		end
	end )
	property "ShowTooltip" { Type = Boolean, Default = true }

	function iAuraIcon(self, ...)
		Super(self, ...)

		self.MouseEnabled = true
		self.MouseWheelEnabled = false

		local icon = Texture("Icon", self, "BORDER")
		icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)

		local count = FontString("Count", self, "OVERLAY", "NumberFontNormal")
		count:SetPoint("BOTTOMRIGHT", -1, 0)

		local stealable = Texture("Stealable", self, "OVERLAY")
		stealable.TexturePath = [[Interface\TargetingFrame\UI-TargetingFrame-Stealable]]
		stealable.BlendMode = "ADD"
		stealable:SetPoint("TOPLEFT", -3, 3)
		stealable:SetPoint("BOTTOMRIGHT", 3, -3)

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave

		IGAS:GetUI(self).UpdateTooltip = UpdateTooltip

		local mask = Texture("Mask", self)
		mask:SetAllPoints()
		mask.DrawLayer = "OVERLAY"
		mask.TexturePath = Media.BORDER_TEXTURE_PATH
		mask.VertexColor = Media.ACTIVED_BORDER_COLOR
	end
endclass "iAuraIcon"

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
		label:SetPoint("LEFT", self, "RIGHT")
		label.JustifyH = "LEFT"
		label.FontObject = TextStatusBarText
	end

	function SetUpCooldownStatus(self, status)
		status:ClearAllPoints()
		status:SetAllPoints()
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

		local pHeight
		if self.AsNamePlate then
			pHeight = self.Icon.Height
		else
			pHeight = math.max(24, self.Parent.Height)
		end

		if math.abs((self.Icon.Width or 0) - pHeight) > 1 then
			if self.AsNamePlate then
				self.Icon.Width = pHeight
			else
				self.Icon:SetSize(pHeight, pHeight)
			end
		end

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		if texture then self.Icon.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
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

		local pHeight
		if self.AsNamePlate then
			pHeight = self.Icon.Height
		else
			pHeight = math.max(24, self.Parent.Height)
		end

		if math.abs((self.Icon.Width or 0) - pHeight) > 1 then
			if self.AsNamePlate then
				self.Icon.Width = pHeight
			else
				self.Icon:SetSize(pHeight, pHeight)
			end
		end

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		if texture then self.Icon.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
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
	property "DelayFormatString" { Type = String, Default = _DELAY_TEMPLATE }
	property "AsNamePlate" { Type = Boolean }

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
	function iCastBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.IFCooldownLabelUseDecimal = true
		self.IFCooldownLabelAutoColor = false
		self.IFCooldownLabelAutoSize = false

		local bgColor = Texture("Bg", self, "BACKGROUND")
		bgColor:SetTexture(0, 0, 0, 1)
		bgColor:SetAllPoints()

		-- Icon
		local icon = Frame("Icon", self)
		icon.FrameStrata = "BACKGROUND"
		icon.Backdrop = _BackDrop
		icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		icon:SetPoint("RIGHT", self.Parent, "LEFT", -2, 0)
		icon:SetSize(32, 32)

		local iconTxt = Texture("Texture", icon, "BACKGROUND")
		iconTxt:SetPoint("TOPLEFT", icon, "TOPLEFT", 2, -2)
		iconTxt:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)

		local nameBack = Frame("NameBack", self)
		nameBack:SetAllPoints()

		-- SpellName
		local text = FontString("SpellName", nameBack, "OVERLAY")
		text:SetVertexColor(1, 1, 1)
		text.FontObject = GameFontHighlight
		text:SetPoint("BOTTOM", self, "BOTTOM")

		-- SafeZone
		local safeZone = Texture("SafeZone", self, "ARTWORK")
		safeZone.Color = ColorType(1, 0, 0)
		safeZone.Visible = false

		self.OnHide = self.OnHide + OnHide
	end
endclass "iCastBar"
