IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Config for RaidPanel
--==========================
-- Need show buff list
_Buff_List = {
	-- [spellId] = true,
	[155777] = true, -- [Druid][Germination]
	[53563] = true,  -- [Paladin][Beacon of Light]
	[156910] = true, -- [Paladin][Beacon of Faith]
	[203528] = true, -- [Paladin][Greater Blessing of Might]
	[203538] = true, -- [Paladin][Greater Blessing of Kings]
	[203539] = true, -- [Paladin][Greater Blessing of Wisdom]
}

local index = 0

local function newIndex()
	index = index + 1
	return index
end

Config = {
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
			Index = newIndex(),
		},
		AllHealPredictionBar = {
			Type = AllHealPredictionBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"All heal prediction",
			Index = newIndex(),
		},
		TotalAbsorbBar = {
			Type = TotalAbsorbBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"Total Absorb",
			Index = newIndex(),
		},
		HealAbsorbBar = {
			Type = HealAbsorbBar,
			Property = { HealthBar = "iHealthBar" },
			Locale = L"Heal Absorb",
			Index = newIndex(),
		},
		iPowerBar = {
			Type = iPowerBar,
			Direction = "south", Size = 3, Unit = "px",
			Locale = L"Power bar",
			Index = newIndex(),
		},
		iNameLabel = {
			Type = iNameLabel,
			Location = {
				AnchorPoint("TOPLEFT", 14, -2, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", -14, 2, "iHealthBar"),
			},
			Locale = L"Name indicator",
			Index = newIndex(),
		},
		iBuffPanel = {
			Type = iBuffPanel,
			Location = { AnchorPoint("LEFT") },
			Locale = L"Buff panel",
			Index = newIndex(),
		},
		iDebuffPanel = {
			Type = iDebuffPanel,
			Location = { AnchorPoint("BOTTOMRIGHT") },
			Locale = L"Debuff panel",
			Index = newIndex(),
		},
		DisconnectIcon = {
			Type = DisconnectIcon,
			Location = { AnchorPoint("BOTTOMLEFT") },
			Locale = L"Disconnect indicator",
			Index = newIndex(),
		},
		RangeChecker = {
			Type = RangeChecker,
			Location = { AnchorPoint("CENTER", 16, 0, nil, "LEFT") },
			Property = { UseIndicator = true, FrameStrata="DIALOG" },
			Locale = L"Range indicator",
			Index = newIndex(),
		},
		LeaderIcon = {
			Type = LeaderIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "TOPLEFT") },
			Locale = L"Leader indicator",
			Index = newIndex(),
		},
		RoleIcon = {
			Type = iRoleIcon,
			Location = { AnchorPoint("TOPRIGHT") },
			Property = { ShowInCombat = false },
			Locale = L"Group Role indicator",
			Index = newIndex(),
		},
		RoleIcon_Dead = {
			Type = iRoleIcon,
			Location = { AnchorPoint("TOPRIGHT") },
			Property = { ShowInCombat = true },
		},
		RaidRosterIcon = {
			Type = RaidRosterIcon,
			Location = { AnchorPoint("TOPLEFT") },
			Locale = L"Raid roster indicator",
			Index = newIndex(),
		},
		RaidTargetIcon = {
			Type = RaidTargetIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "TOP") },
			Locale = L"Raid/Group target indicator",
			Index = newIndex(),
		},
		ResurrectIcon = {
			Type = ResurrectIcon,
			Location = { AnchorPoint("BOTTOM") },
			Locale = L"Resurrect indicator",
			Index = newIndex(),
		},
		ReadyCheckIcon = {
			Type = ReadyCheckIcon,
			Location = { AnchorPoint("BOTTOM") },
			Locale = L"ReadyCheck indicator",
			Index = newIndex(),
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
		UnitWatch = {
			"iHealthBar",
			"MyHealPredictionBar",
			"AllHealPredictionBar",
			"TotalAbsorbBar",
			"HealAbsorbBar",
			"iNameLabel",
			"iBuffPanel",
			"iDebuffPanel",
			"RangeChecker",
			"RaidTargetIcon",
			"ResurrectIcon",
		},
	},
}