IGAS:NewAddon "IGAS_UI.NamePlate"

import "System.Widget"
import "System.Widget.Unit"

BASE_NAME_FONT_HEIGHT = 14
MAX_NAME_FONT_HEIGHT = 20

-- Font
NAME_FONT = Font("IGAS_UI_NamePlate_NameFont")
NAME_FONT.Font = {
	path = _G.UNIT_NAME_FONT,
	height = 16,
}

CAST_FONT = Font("IGAS_UI_NamePlate_CastFont")
CAST_FONT:CopyFontObject(NAMEPLATE_SPELLCAST_FONT)
