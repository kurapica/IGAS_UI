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
	CASTBAR_COLOR = ColorType(0, 0, 0.8),
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

-----------------------------------------------
--- IFStyle
-- @type interface
-- @name IFStyle
-----------------------------------------------
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

--==========================
-- Elements
--==========================
class "iPowerBarFrequent"
	inherit "PowerBarFrequent"
	extend "iBorder" "iStatusBarStyle"
endclass "iPowerBarFrequent"

class "iPowerBar"
	inherit "PowerBar"
	extend "iStatusBarStyle""iBorder"
endclass "iPowerBar"

class "iHiddenManaBar"
	inherit "HiddenManaBar"
	extend "iBorder" "iStatusBarStyle"
endclass "iHiddenManaBar"

class "iPlayerPowerText"
	inherit "PowerTextFrequent"

	function SetUnitPowerType(self, powerType)
		if powerType == 0 or powerType == "MANA" then
			self.ShowPercent = true
		else
			self.ShowPercent = false
		end

		-- return Super.SetUnitPowerType(self)
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
			self[i].Width = width
			self[i]:SetPoint("LEFT", 1 + (width + self.HSpacing) * (i - 1), 0)
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