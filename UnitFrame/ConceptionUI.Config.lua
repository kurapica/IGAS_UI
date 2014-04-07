IGAS:NewAddon "IGAS_UI.UnitFrame"


--==========================
-- Config for UnitFrame
--==========================
Config = {
	-- enable hover spell cast like raid panels
	ENABLE_HOVER_SPELLCAST = false,

	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 1,
	PANEL_HSPACING = 0,

	-- Element settings
	Elements = {
		HealthBar_Left = {
			Type = iHealthBar,
			Direction = "south", Size = 3, Unit = "px",
			Property = { ReverseFill = true },
		},
		PowerBar_Left = {
			Type = iPowerBar,
			Direction = "south", Size = 1, Unit = "px",
			Property = { ReverseFill = true },
		},
		HealthBar_Right = {
			Type = iHealthBar,
			Direction = "south", Size = 3, Unit = "px",
		},
		PowerBar_Right = {
			Type = iPowerBar,
			Direction = "south", Size = 1, Unit = "px",
		},
		BarBack = {
			Type = Frame,
			Name = "BarBack",
			Location = {
				AnchorPoint("TOPLEFT", -3, 3, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", 3, -3, "iPowerBar"),
			},
			Init = function(self)
				self.FrameStrata = "BACKGROUND"
				self.Backdrop = TextureConfig.BarBackdrop
				self.BackdropColor = TextureConfig.BarBackdropColor
				self.BackdropBorderColor = TextureConfig.BarBackdropColor
			end,
		},
	},

	-- Units settings
	Units = {
		player = {
			-- Init
			Init = function(self)
				self.Alpha = 1
				self.Backdrop = TextureConfig.Backdrop
				self.BackdropColor = TextureConfig.BackdropColor
			end,

			-- Elements
			"PowerBar_Left",
			"HealthBar_Left",
			"BarBack",
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
		partypet = {
		},
		focustarget = {
		},
	},

	-- Class settings
	Classes = {
		DRUID = {  },
		DEATHKNIGHT = {  },
		MONK = {  },
	},
}