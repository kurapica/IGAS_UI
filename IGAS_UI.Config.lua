IGAS:NewAddon "IGAS_UI"

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Config for UnitFrame
--==========================
UnitFrame_Config = {
	-- enable hover spell cast like raid panels
	ENABLE_HOVER_SPELLCAST = false,

	DEFAULT_SIZE = Size(200, 48),
	PANEL_VSPACING = 4,
	PANEL_HSPACING = 0,

	-- Style settings
	simple = {
		[1] = {
			Type = iHealthBar,
			Direction = "rest",
		},
		[2] = {
			Type = NameLabel,
			Location = {
				AnchorPoint("RIGHT", -4, 0, "iHealthBar"),
			},
			Property = {
				UseClassColor = true,
			},
		},
		[3] = {
			Type = LevelLabel,
			Location = {
				AnchorPoint("RIGHT", -4, 0, "NameLabel", "LEFT"),
			},
		}
	},

	player = {

	},

	pet = {

	},

	target = {

	},

	targettarget = {

	},

	focus = {

	},

	boss = {

	},

	party = {

	},

	focustarget = {

	},
}

--==========================
-- Config for RaidPanel
--==========================

--==========================
-- Config for ActionButton
--==========================