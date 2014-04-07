IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Media for UnitFrame
--==========================
import "System.Widget"
import "System.Widget.Unit"

-- Need show buff list
_Buff_List = {
	-- [spellId] = true,
}

-- Need show debuff list
_Debuff_List = {
	-- [spellId] = true,
}

Media = {
	-- Status bar texture
	STATUSBAR_TEXTURE_PATH = [[Interface\Tooltips\UI-Tooltip-Background]],

	-- Color settings
	--- Default border color
	DEFAULT_BORDER_COLOR = ColorType(0, 0, 0),

	--- Elite target border color
	ELITE_BORDER_COLOR = ColorType(1, 0.84, 0),

	--- Rare target border color
	RARE_BORDER_COLOR = ColorType(0.75, 0.75, 0.75),

	--- Cast bar color
	CASTBAR_COLOR = ColorType(0, 0, 0.8),
}