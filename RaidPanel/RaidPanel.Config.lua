IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Config for RaidPanel
--==========================
-- Need show buff list
_Buff_List = {
	-- [spellId] = true,
}

RaidPanel_Config = {
	-- Status bar texture
	STATUSBAR_TEXTURE_PATH = [[Interface\Tooltips\UI-Tooltip-Background]],

	-- Color settings
	--- Default border color
	DEFAULT_BORDER_COLOR = ColorType(0, 0, 0),

	--- RaidPanel's target border color
	TARGET_BORDER_COLOR = ColorType(1, 1, 1),

	-- UnitFrame settings
	UNITFRAME_VSPACING = 1,
	UNITFRAME_HSPACING = 1,

	-- UnitPanel settings
	UNITPANEL_VSPACING = 3,
	UNITPANEL_HSPACING = 3,
	UNITPANEL_MARGINTOP = 3,
	UNITPANEL_MARGINBOTTOM = 3,
	UNITPANEL_MARGINLEFT = 3,
	UNITPANEL_MARGINRIGHT = 3,

	-- Elements
	Elements = {
		iHealthBar = {
			Type = iHealthBar,
			Direction = "rest",
		},
		MyHealPredictionBar = {
			Type = MyHealPredictionBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"My heal prediction",
			Index = 1,
		},
		AllHealPredictionBar = {
			Type = AllHealPredictionBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"All heal prediction",
			Index = 2,
		},
		TotalAbsorbBar = {
			Type = TotalAbsorbBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"Total Absorb",
			Index = 3,
		},
		HealAbsorbBar = {
			Type = HealAbsorbBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"Heal Absorb",
			Index = 4,
		},
		iPowerBar = {
			Type = iPowerBar,
			Direction = "south", Size = 3, Unit = "px",
			Locale = L"Power bar",
			Index = 5,
		},
		iNameLabel = {
			Type = iNameLabel,
			Location = {
				AnchorPoint("TOPLEFT", 2, -2),
				AnchorPoint("TOPRIGHT", -2, -2),
			},
			Locale = L"Name indicator",
			Index = 6,
		},
		iBuffPanel = {
			Type = iBuffPanel,
			Location = { AnchorPoint("LEFT") },
			Locale = L"Buff panel",
			Index = 7,
		},
		iDebuffPanel = {
			Type = iDebuffPanel,
			Location = { AnchorPoint("BOTTOMRIGHT") },
			Locale = L"Debuff panel",
			Index = 8,
		},
		DisconnectIcon = {
			Type = DisconnectIcon,
			Location = { AnchorPoint("BOTTOMLEFT") },
			Locale = L"Disconnect indicator",
			Index = 9,
		},
		RangeChecker = {
			Type = RangeChecker,
			Location = { AnchorPoint("CENTER", 16, 0, nil, "LEFT") },
			Property = { UseIndicator = true },
			Locale = L"Range indicator",
			Index = 10,
		},
		LeaderIcon = {
			Type = LeaderIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "TOPLEFT") },
			Locale = L"Leader indicator",
			Index = 11,
		},
		RoleIcon = {
			Type = RoleIcon,
			Location = { AnchorPoint("TOPRIGHT") },
			Property = { ShowInCombat = false },
			Locale = L"Group Role indicator",
			Index = 12,
		},
		RoleIcon_Dead = {
			Type = RoleIcon,
			Location = { AnchorPoint("TOPRIGHT") },
			Property = { ShowInCombat = true },
		},
		RaidRosterIcon = {
			Type = RaidRosterIcon,
			Location = { AnchorPoint("TOPLEFT") },
			Locale = L"Raid roster indicator",
			Index = 13,
		},
		RaidTargetIcon = {
			Type = RaidTargetIcon,
			Location = { AnchorPoint("CENTER", 0, 0, "TOP") },
			Locale = L"Raid/Group target indicator",
			Index = 14,
		},
		ResurrectIcon = {
			Type = ResurrectIcon,
			Location = { AnchorPoint("BOTTOM") },
			Locale = L"Resurrect indicator",
			Index = 15,
		},
		ReadyCheckIcon = {
			Type = ReadyCheckIcon,
			Location = { AnchorPoint("BOTTOM") },
			Locale = L"ReadyCheck indicator",
			Index = 16,
		},
		iTarget = {
			Type = iTarget,
			Locale = L"Target indicator",
			Index = 17,
		},
	},

	-- Styles
	Style = {
		Normal = {
			"iHealthBar",
			"MyHealPredictionBar",
			"AllHealPredictionBar",
			"TotalAbsorbBar",
			"HealAbsorbBar",
			"iPowerBar",
			"iNameLabel",
			"iBuffPanel",
			"iDebuffPanel",
			"DisconnectIcon",
			"RangeChecker",
			"LeaderIcon",
			"RoleIcon",
			"RaidRosterIcon",
			"RaidTargetIcon",
			"ResurrectIcon",
			"ReadyCheckIcon",
			"iTarget",
		},
		Pet = {
			"iHealthBar",
			"iNameLabel",
			"iBuffPanel",
			"iDebuffPanel",
		},
		Dead = {
			"iHealthBar",
			"iNameLabel",
			"DisconnectIcon",
			"RangeChecker",
			"RoleIcon_Dead",
			"ResurrectIcon",
		},
	},
}
}