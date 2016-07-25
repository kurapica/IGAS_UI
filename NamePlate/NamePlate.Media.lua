IGAS:NewAddon "IGAS_UI.NamePlate"

import "System.Widget"
import "System.Widget.Unit"

Media = {
	-- Status bar texture
	STATUSBAR_TEXTURE_PATH = [[Interface\Addons\IGAS_UI\Resource\healthtex.tga]],

	-- Color settings
	--- Default border color
	DEFAULT_BORDER_COLOR = ColorType(0, 0, 0),
	ACTIVED_BORDER_COLOR = ColorType(1, 1, 1),

	--- Cast bar color
	CASTBAR_COLOR = ColorType(0.25, 0.78, 0.92),
	CASTBAR_BORDER_NORMAL_COLOR = ColorType(1, 1, 1),
	CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR = ColorType(0.77, 0.12 , 0.23),

	-- Font
	NAME_FONT = Font("IGAS_UI_NamePlate_NameFont") {
		Font = {
			path = _G.UNIT_NAME_FONT,
			height = 16,
		},
	},

	BASE_NAME_FONT_HEIGHT = 14,
	MAX_NAME_FONT_HEIGHT = 20,
}
