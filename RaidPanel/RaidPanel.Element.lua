IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Layout for RaidPanel
--==========================

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Global
--==========================
AuraCountFont = Font("IGAS_AuraCountFont")
AuraCountFont:CopyFontObject("NumberFontNormal")

--==========================
-- Interfaces
--==========================
interface "iStatusBarStyle"
	_BACK_MULTI = 0.2
	_BACK_ALPHA = 0.8

	------------------------------------------------------
	-- Method
	------------------------------------------------------
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
		self.StatusBarTexturePath = Config.STATUSBAR_TEXTURE_PATH

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
		bg.BackdropBorderColor = Config.DEFAULT_BORDER_COLOR
    end
endinterface "iBorder"

--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "HealthBar"
	extend "iStatusBarStyle""iBorder"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.UseDebuffColor = true

		if _DBChar[GetSpecialization() or 1].ElementUseClassColor then
			self.UseClassColor = true
		end
		self.FrameLevel = self.FrameLevel + 1
	end
endclass "iHealthBar"

class "iPowerBar"
	inherit "PowerBar"
	extend "iStatusBarStyle""iBorder"
endclass "iPowerBar"

class "iNameLabel"
	inherit "NameLabel"
	extend "IFThreat"

	_TARGET_TEMPLATE = FontColor.RED .. ">>" .. FontColor.CLOSE .. "%s" .. FontColor.RED .. "<<" .. FontColor.CLOSE

	local sSetText = Super.SetText

	local function UpdateText(self)
		if self.ThreatLevel >= 2 then
			sSetText(self, _TARGET_TEMPLATE:format(self.__iNameLabelText or ""))
		else
			sSetText(self, self.__iNameLabelText)
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetText(self, text)
		self.__iNameLabelText = text or ""
		return UpdateText(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ThreatLevel
	property "ThreatLevel" {
		Set = function(self, value)
			self.__iNameLabelThreatLevel = value
			return UpdateText(self)
		end,
		Field = "__iNameLabelThreatLevel",
		Type = Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iNameLabel(self, ...)
		Super(self, ...)

		self.UseClassColor = true
		self.DrawLayer = "BORDER"

		self:SetWordWrap(false)
	end
endclass "iNameLabel"

class "iBuffPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function CustomFilter(self, unit, index, filter)
		local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

		if name and UnitCanAttack("player", unit) then return true end

		if name and caster == "player" and (count > 0 or (_Buff_List[spellID] or _IGASUI_HELPFUL_SPELL[spellID] or _IGASUI_HELPFUL_SPELL[name]) and duration > 0 and duration < 31) then
			return true
		end
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnElementAdd(self, element)
		element.ShowTooltip = _DBChar[GetSpecialization() or 1].ShowDebuffTooltip
		element:GetChild("Count").FontObject = AuraCountFont
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iBuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HELPFUL|PLAYER"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.VERTICAL

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iBuffPanel"

class "iDebuffPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function CustomFilter(self, unit, index, filter)
		local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)

		if UnitCanAttack("player", unit) then return caster == "player" end

		if _DebuffBlackList[spellID] then return false end

		return true
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnMouseUp(self, button)
		if button == "RightButton" and _DBChar[GetSpecialization() or 1].DebuffRightMouseRemove and not UnitCanAttack("player", self.Parent.Unit) then
			local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)

			if name then
				_DebuffBlackList[spellID] = true

				return self.Parent:Refresh()
			end
		end
	end

	local function OnElementAdd(self, element)
		element.ShowTooltip = _DBChar[GetSpecialization() or 1].ShowDebuffTooltip
		element.MouseEnabled = _DBChar[GetSpecialization() or 1].ShowDebuffTooltip or _DBChar[GetSpecialization() or 1].DebuffRightMouseRemove
		element.OnMouseUp = element.OnMouseUp + OnMouseUp
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HARMFUL"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false
		self.LeftToRight = false

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iDebuffPanel"

class "iTarget"
	inherit "VirtualUIObject"
	extend "IFTarget"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IsTarget
	property "IsTarget" {
		Field = "__IsTarget",
		Set = function(self, value)
			if self.IsTarget ~= value then
				self.__IsTarget = value
				if not self.TargetBack then self.TargetBack = self.Parent.Parent.iHealthBar.Back end
				if value then
					self.TargetBack.BackdropBorderColor = Config.TARGET_BORDER_COLOR
				else
					self.TargetBack.BackdropBorderColor = Config.DEFAULT_BORDER_COLOR
				end
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iTarget(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.TargetBack = false
	end
endclass "iTarget"