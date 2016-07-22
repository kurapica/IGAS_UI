IGAS:NewAddon "IGAS_UI.UnitFrame"

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Config for UnitFrame
--==========================
Config = {
	-- enable hover spell cast like raid panels
	ENABLE_HOVER_SPELLCAST = false,

	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 4,
	PANEL_HSPACING = 0,

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
			Property = {
				StatusBarColor = ColorType(0.3, 0.3, 1)
			}
		},
		iClassPower = {
			Type = iClassPower,
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
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 6 },
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
				ElementWidth = 16,
				ElementHeight = 16,
				TopToBottom = false,
			},
		},
		iPlayerBuffPanel = {
			Type = AuraPanel,
			Name = "iPlayerBuffPanel",
			Location = { AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT") },
			Property = {
				Filter = "HELPFUL|PLAYER",
				HighLightPlayer = true,
				RowCount = 3,
				ColumnCount = 3,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,
				TopToBottom = false,
			},
		},
		iOtherBuffPanel = {
			Type = AuraPanel,
			Name = "iOtherBuffPanel",
			Location = { AnchorPoint("BOTTOMLEFT", 0, 0, "iPlayerBuffPanel", "BOTTOMRIGHT") },
			Property = {
				Filter = "HELPFUL",
				RowCount = 6,
				ColumnCount = 5,
				MarginTop = 2,
				ElementWidth = 16,
				ElementHeight = 16,
				TopToBottom = false,

				CustomFilter = function (self, unit, index, filter)
					local name, _, _, _, _, duration, _, caster = UnitAura(unit, index, filter)
					return name and caster ~= "player"
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
				ElementWidth = 16,
				ElementHeight = 16,
				TopToBottom = false,

				CustomFilter = function (self, unit, index, filter)
					local isFriend = not UnitCanAttack("player", unit)
					local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

					if name and duration > 0 and (_Debuff_List[spellID] or isFriend or caster == "player") then
						return true
					end
				end,
			},
		},
		iOtherDebuffPanel = {
			Type = AuraPanel,
			Name = "iOtherDebuffPanel",
			Location = { AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT") },
			Property = {
				Filter = "HARMFUL",
				RowCount = 6,
				ColumnCount = 5,
				MarginTop = 2,
				ElementWidth = 16,
				ElementHeight = 16,
				TopToBottom = false,

				CustomFilter = function (self, unit, index, filter)
					local name, _, _, _, _, duration, _, caster = UnitAura(unit, index, filter)
					return name and caster ~= "player"
				end,
			},
		},
		iPlayerDebuffPanel = {
			Type = AuraPanel,
			Name = "iPlayerDebuffPanel",
			Location = { AnchorPoint("BOTTOMRIGHT", 0, 0, "iOtherDebuffPanel", "BOTTOMLEFT") },
			Property = {
				Filter = "HARMFUL|PLAYER",
				HighLightPlayer = true,
				RowCount = 3,
				ColumnCount = 3,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,
				TopToBottom = false,
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
				ElementWidth = 16,
				ElementHeight = 16,
				TopToBottom = false,

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
		{
			Unit = "player",
			HideFrame1 = "PlayerFrame",
			HideFrame2 = "ComboFrame",
			HideFrame3 = "RuneFrame",
			HideFrame4 = "CastingBarFrame",
			Elements = {
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
			Size = Size(200, 36),
			Location = { AnchorPoint("TOPLEFT", 40, 0) },
		},
		{
			Unit = "pet",
			HideFrame1 = "PetFrame",
			Elements = {
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
			Size = Size(160, 24),
			Location = { AnchorPoint("TOPLEFT", 180, -40) },
		},
		{
			Unit = "target",
			HideFrame1 = "TargetFrame",
			Elements = {
				"iHealthBar",
				"NameLabel_Target",
				"LevelLabel",
				"iPowerBar",
				"iCastBar",
				"HealthTextFrequent",
				"HealthTextFrequent2",
				"iPlayerBuffPanel",
				"iOtherBuffPanel",
				"iOtherDebuffPanel",
				"iPlayerDebuffPanel",
				"QuestBossIcon",
			},
			Size = Size(200, 36),
			Location = { AnchorPoint("TOPLEFT", 280, 0) },
		},
		{
			Unit = "targettarget",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iDebuffPanel_ToT",
			},
			Size = Size(160, 24),
			Location = { AnchorPoint("TOPLEFT", 420, -40) },
		},
		{
			Unit = "focus",
			HideFrame1 = "FocusFrame",
			Elements = {
				"iHealthBar",
				"NameLabel_Focus",
				"LevelLabel",
				"iBuffPanel",
				"iDebuffPanel",
			},
			Size = Size(160, 24),
			Location = { AnchorPoint("TOPLEFT", 20, -40) },
		},
		{
			Unit = "boss%d",
			Max = 5,
			HideFrame1 = "Boss%dTargetFrame",
			Elements = {
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
			Size = Size(200, 36),
			Location = { AnchorPoint("TOPLEFT", 600, - 64) }, DX = 0, DY = -64
		},
		{
			Unit = "party%d",
			Max = 4,
			HideFrame1 = "PartyMemberFrame%d",
			Elements = {
				"iHealthBar",
				"NameLabel",
				"LevelLabel",
				"iPowerBar",
				"iCastBar",
				"HealthTextFrequent",
				"HealthTextFrequent2",
				"iDebuffPanel",
			},
			Size = Size(200, 36),
			Location = { AnchorPoint("TOPLEFT", 40, - 124) }, DX = 0, DY = -64
		},
		{
			Unit = "partypet%d",
			Max	= 4,
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
			},
			Size = Size(160, 24),
			Location = { AnchorPoint("BOTTOMLEFT", 0, 0, "party%d", "BOTTOMRIGHT") },
		},
		{
			Unit = "focustarget",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iDebuffPanel_ToT",
			},
			Size = Size(160, 24),
			Location = { AnchorPoint("TOPLEFT", 20, -70) },
		},
	},

	-- Class settings
	Classes = {
		DEATHKNIGHT = { "iRuneBar" },
		MONK = { "iStaggerBar" },
	},
}