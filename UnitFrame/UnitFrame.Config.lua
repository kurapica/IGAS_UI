IGAS:NewAddon "IGAS_UI.UnitFrame"

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Config for UnitFrame
--==========================
-- Need show buff list
_Buff_List = {
	-- [spellId] = true,
}

-- Need show debuff list
_Debuff_List = {
	-- [spellId] = true,
}

UnitFrame_Config = {
	-- enable hover spell cast like raid panels
	ENABLE_HOVER_SPELLCAST = false,

	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 4,
	PANEL_HSPACING = 0,

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

	-- Element settings
	Elements = {
		iHealthBar = {
			Type = iHealthBar,
			Direction = "rest",
			Property = { Smoothing = true },
		},
		NameLabel = {
			Type = NameLabel,
			Location = { AnchorPoint("TOPRIGHT", 0, 0, nil, "BOTTOMRIGHT") },
			Property = { UseClassColor = true },
		},
		NameLabel_Simple = {
			Type = NameLabel,
			Location = { AnchorPoint("RIGHT", -4, 0, "iHealthBar") },
			Property = { UseClassColor = true },
		},
		NameLabel_Target = {
			Type = NameLabel,
			Location = { AnchorPoint("TOPRIGHT", 0, 0, nil, "BOTTOMRIGHT") },
			Property = { UseClassColor = true, UseTapColor = true, UseSelectionColor = true },
		},
		NameLabel_Focus = {
			Type = NameLabel,
			Location = { AnchorPoint("TOPRIGHT", 0, 0, nil, "BOTTOMRIGHT") },
			Property = { UseClassColor = true, UseTapColor = true },
		},
		LevelLabel = {
			Type = LevelLabel,
			Location = { AnchorPoint("RIGHT", -4, 0, "NameLabel", "LEFT") },
		},
		iPowerBar = {
			Type = iPowerBar,
			Direction = "south", Size = 6, Unit = "px",
			Property = { Smoothing = true },
		},
		iCastBar = {
			Type = iCastBar,
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", 0, 0, "iHealthBar"),
			},
		},
		HealthTextFrequent = {
			Type = HealthTextFrequent,
			Location = { AnchorPoint("RIGHT", -4, 0, "iHealthBar", "LEFT") },
			Property = { ShowPercent = true },
		},
		HealthTextFrequent2 = {
			Type = HealthTextFrequent,
			Name = "HealthTextFrequent2",
			Location = { AnchorPoint("TOPLEFT", 0, -2, nil, "BOTTOMLEFT") },
			Property = { ValueFormat = "%.1f" },
		},
		iHiddenManaBar = {
			Type = iHiddenManaBar,
			Direction = "south", Size = 6, Unit = "px",
		},
		iClassPower = {
			Type = iClassPower,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 6 },
		},
		iEclipseBar = {
			Type = iEclipseBar,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 6 },
		},
		iRuneBar = {
			Type = iRuneBar,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 6 },
		},
		TotemBar = {
			Type = TotemBar,
			Location = { AnchorPoint("BOTTOM", 0, 4, nil, "TOP") },
		},
		CombatIcon = {
			Type = CombatIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "TOPLEFT") },
		},
		PvpIcon = {
			Type = PvpIcon,
			Location = { AnchorPoint("CENTER", 12, 0, nil, "RIGHT") },
		},
		iPlayerPowerText = {
			Type = iPlayerPowerText,
			Location = { AnchorPoint("RIGHT", -4, 0, "iPowerBar", "LEFT") },
		},
		iStaggerBar = {
			Type = iStaggerBar,
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", 0, 0, "iHealthBar"),
			},
		},
		iBuffPanel = {
			Type = AuraPanel,
			Name = "iBuffPanel",
			Location = { AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT") },
			Property = {
				Filter = "HELPFUL",
				HighLightPlayer = true,
				RowCount = 6,
				ColumnCount = 6,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,

				CustomFilter = function(self, unit, index, filter)
					local isEnemy = UnitCanAttack("player", unit)
					local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

					if name and duration > 0 and (_Buff_List[spellID] or isEnemy or caster == "player") then
						return true
					end
				end,
			},
		},
		iDebuffPanel = {
			Type = AuraPanel,
			Name = "iDebuffPanel",
			Location = { AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT") },
			Property = {
				Filter = "HARMFUL",
				HighLightPlayer = true,
				RowCount = 6,
				ColumnCount = 6,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,

				CustomFilter = function (self, unit, index, filter)
					local isFriend = not UnitCanAttack("player", unit)
					local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

					if name and duration > 0 and (_Debuff_List[spellID] or isFriend or caster == "player") then
						return true
					end
				end,
			},
		},
		iDebuffPanel_ToT = {
			Type = AuraPanel,
			Name = "iDebuffPanel",
			Location = { AnchorPoint("TOPRIGHT", 0, -4, nil, "BOTTOMRIGHT") },
			Property = {
				Filter = "HARMFUL",
				HighLightPlayer = true,
				RowCount = 6,
				ColumnCount = 6,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,

				CustomFilter = function (self, unit, index, filter)
					local isFriend = not UnitCanAttack("player", unit)
					local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

					if name and duration > 0 and (_Debuff_List[spellID] or isFriend or caster == "player") then
						return true
					end
				end,
			},
		},
		QuestBossIcon = {
			Type = QuestBossIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "LEFT") },
			Property = { Scale = 2 },
		},
		RaidTargetIcon = {
			Type = RaidTargetIcon,
			Location = { AnchorPoint("CENTER", 0, 0, nil, "TOP") },
		},
	},

	-- Units settings
	Units = {
		player = {
			"iHealthBar",
			"NameLabel",
			"LevelLabel",
			"iHiddenManaBar",
			"iPowerBar",
			"iCastBar",
			"HealthTextFrequent",
			"HealthTextFrequent2",
			"iClassPower",
			"TotemBar",
			"CombatIcon",
			"PvpIcon",
			"iPlayerPowerText",
		},
		pet = {
			"iHealthBar",
			"NameLabel",
			"LevelLabel",
			"iPowerBar",
			"iCastBar",
			"HealthTextFrequent",
			"HealthTextFrequent2",
			"iBuffPanel",
			"iDebuffPanel",
		},
		target = {
			"iHealthBar",
			"NameLabel_Target",
			"LevelLabel",
			"iPowerBar",
			"iCastBar",
			"HealthTextFrequent",
			"HealthTextFrequent2",
			"iBuffPanel",
			"iDebuffPanel",
			"QuestBossIcon",
		},
		targettarget = {
			"iHealthBar",
			"NameLabel_Simple",
			"LevelLabel",
			"iDebuffPanel_ToT",
		},
		focus = {
			"iHealthBar",
			"NameLabel_Focus",
			"LevelLabel",
			"iBuffPanel",
			"iDebuffPanel",
		},
		boss = {
			"iHealthBar",
			"NameLabel",
			"LevelLabel",
			"iPowerBar",
			"iCastBar",
			"HealthTextFrequent",
			"HealthTextFrequent2",
			"iBuffPanel",
			"iDebuffPanel",
			"RaidTargetIcon",
		},
		party = {
			"iHealthBar",
			"NameLabel",
			"LevelLabel",
			"iPowerBar",
			"iCastBar",
			"HealthTextFrequent",
			"HealthTextFrequent2",
			"iDebuffPanel",
		},
		partypet = {
			"iHealthBar",
			"NameLabel_Simple",
			"LevelLabel",
		},
		focustarget = {
			"iHealthBar",
			"NameLabel_Simple",
			"LevelLabel",
			"iDebuffPanel_ToT",
		},
	},

	-- Class settings
	Classes = {
		DRUID = { "iEclipseBar" },
		DEATHKNIGHT = { "iRuneBar" },
		MONK = { "iStaggerBar" },
	},
}