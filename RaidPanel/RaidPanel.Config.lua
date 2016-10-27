IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Config for RaidPanel
--==========================
local index = 0

local function newIndex()
	index = index + 1
	return index
end

BaseClassBuffList = {
	-- Paladin
	132403, -- Shield of the Righteous
	31850,	-- Ardent Defender
	86659,	-- Guardian of Ancient Kings
	1022,	-- Blessing of Protection
	642,	-- Divine Shield
	-- Death Knight
	48707,	-- Anti-Magic Shell
	55233,	-- Vampiric Blood
	81256,	-- Dancing Rune Weapon
	195181,	-- Bone Shield
	194679,	-- Rune Tap
	206977,	-- Blood Mirror
	48792,	-- Icebound Fortitude
	207319,	-- Corpse Shield
	-- Warrior
	184364,	-- Enraged Regeneration
	23920,	-- Spell Reflection
	132404,	-- Shield Block
	190456,	-- Ignore Pain
	871,	-- Shield Wall
	12975,	-- Last Stand
	-- Monk
	125174,	-- Touch of Karma
	122783,	-- Diffuse Magic
	122278,	-- Dampen Harm
	120954,	-- Fortifying Brew
	215479,	-- Ironskin Brew
	-- Druid
	192081,	-- Ironfur
	192083,	-- Mark of Ursol
	200851,	-- Rage of the Sleeper
	22812,	-- Barkskin
	22842,	-- Frenzied Regeneration
	-- Demon Hunter
	218256,	-- Empower Wards
	187827,	-- Metamorphosis
	203819,	-- Demon Spikes
	203981,	-- Soul Fragments
	-- Useful
	128849, -- Guard
}

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
			Location = { AnchorPoint("TOPLEFT") },
			Locale = L"Buff panel",
			Index = newIndex(),
		},
		iDebuffPanel = {
			Type = iDebuffPanel,
			Location = { AnchorPoint("BOTTOMRIGHT", 0, 0, "iHealthBar") },
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
			Property = { UseIndicator = false, FrameStrata="DIALOG" },
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
		iClassBuffPanel = {
			Type = iClassBuffPanel,
			Location = { AnchorPoint("BOTTOM", 0, 0, "iHealthBar") },
			Locale = L"Class Buff indicator",
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
			"iClassBuffPanel",
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
			"iClassBuffPanel",
		},
	},
}