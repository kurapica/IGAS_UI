IGAS:NewAddon "IGAS_UI"

--==========================
-- IGAS_UI Definitions
--==========================

------------------------------------
-- UnitFrame & RaidPanel StatusBar
------------------------------------
-- StatusBar texture path
STATUSBAR_TEXTURE_PATH = [[Interface\Tooltips\UI-Tooltip-Background]]

------------------------------------
-- Border Color
------------------------------------
-- Default border color
DEFAULT_BORDER_COLOR = ColorType(0, 0, 0)
-- Elite target border color
ELITE_BORDER_COLOR = ColorType(1, 0.84, 0)
-- Rare target border color
RARE_BORDER_COLOR = ColorType(0.75, 0.75, 0.75)
-- RaidPanel's target border color
TARGET_BORDER_COLOR = ColorType(1, 1, 1)
-- Cast bar color
CASTBAR_COLOR = ColorType(0, 0, 0.8)

------------------------------------
-- Buff & Debuff
------------------------------------
-- Debuff size for target name plate
TARGET_DEBUFF_SIZE = 42
-- Max alpha for debuff length than, if set to 5, the icon should be max alpha if the debuff length than 5s
TARGET_DEBUFF_MAX_ALPHA_LIMIT = 5
-- Buff size for Unit Frame
BUFF_SIZE = 24
-- Need show buff list
_Buff_List = {
	-- [spellId] = true,
}
-- Need show debuff list
_Debuff_List = {
	-- [spellId] = true,
}

interface "iStatusBarStyle"
	_BACK_MULTI = 0.2
	_BACK_ALPHA = 0.8

	STATUSBAR_TEXTURE_PATH = STATUSBAR_TEXTURE_PATH

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	local oldSetStatusBarColor = StatusBar.SetStatusBarColor

	function SetStatusBarColor(self, r, g, b, a)
	    if r then
	        oldSetStatusBarColor(self, r, g, b)

	        self.Bg:SetVertexColor(r * _BACK_MULTI, g * _BACK_MULTI, b * _BACK_MULTI, _BACK_ALPHA)
	    end
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function iStatusBarStyle(self)
		self.StatusBarTexturePath = STATUSBAR_TEXTURE_PATH

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

	function _BuildBorder(self)
		local bg = Frame("Back", self)
		bg.FrameStrata = "BACKGROUND"
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg.Backdrop = THIN_BORDER
		bg.BackdropBorderColor = DEFAULT_BORDER_COLOR
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function iBorder(self)
		_BuildBorder(self)
    end
endinterface "iBorder"
