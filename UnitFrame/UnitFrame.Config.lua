IGAS:NewAddon "IGAS_UI.UnitFrame"

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
			Location = { AnchorPoint("BOTTOMRIGHT", -1, 4, "iHealthBar") },
			Property = { UseClassColor = true },
		},
		NameLabel_Target = {
			Type = NameLabel,
			Location = { AnchorPoint("TOPRIGHT", 0, 0, nil, "BOTTOMRIGHT") },
			Property = { UseClassColor = true, UseTapColor = true, UseSelectionColor = true },
		},
		NameLabel_Focus = {
			Type = NameLabel,
			Location = { AnchorPoint("BOTTOMRIGHT", -1, 4, "iHealthBar") },
			Property = { UseClassColor = true, UseTapColor = true },
		},
		LevelLabel = {
			Type = LevelLabel,
			Location = { AnchorPoint("RIGHT", -4, 0, "NameLabel", "LEFT") },
		},
		iPowerBarFrequent = {
			Type = iPowerBarFrequent,
			Direction = "south", Size = 2, Unit = "px",
			Property = { Smoothing = true },
		},
		iCastBar = {
			Type = iCastBar,
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "iPowerBarFrequent"),
				AnchorPoint("BOTTOMRIGHT", 0, 0, "iPowerBarFrequent"),
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
			Direction = "south", Size = 2, Unit = "px",
			Property = {
				StatusBarColor = ColorType(0, 0, 1)
			}
		},
		iClassPower = {
			Type = iClassPower,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", -1, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 2 },
		},
		iRuneBar = {
			Type = iRuneBar,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 2 },
		},
		iSecureTotemBar = {
			Type = iSecureTotemBar,
			Name = "IGAS_UI_Player_SecureTotemBar",
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
			Location = { AnchorPoint("TOP", 0, 0, "iPowerBarFrequent", "TOP") },
		},
		iStaggerBar = {
			Type = iStaggerBar,
			Location = {
				AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 4, nil, "TOPRIGHT"),
			},
			Property = { Height = 2 },
		},
		iBuffPanel = {
			Type = AuraPanel,
			Name = "iBuffPanel",
			Location = { AnchorPoint("BOTTOMLEFT", 0, 4, nil, "TOPLEFT") },
			Property = {
				ElementType = iAuraIcon,
				Filter = "HELPFUL",
				RowCount = 6,
				ColumnCount = 3,
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
				ElementType = iAuraIcon,
				Filter = "HELPFUL|PLAYER",
				RowCount = 3,
				ColumnCount = 3,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,
				HSpacing = 1,
				VSpacing = 1,
				TopToBottom = false,

				CustomFilter = function (self, unit, index, filter)
					local name, _, _, _, _, duration, _, caster = UnitAura(unit, index, filter)
					return name and caster == "player"
				end,
			},
		},
		iOtherBuffPanel = {
			Type = AuraPanel,
			Name = "iOtherBuffPanel",
			Location = { AnchorPoint("BOTTOMLEFT", 0, 0, "iPlayerBuffPanel", "BOTTOMRIGHT") },
			Property = {
				ElementType = iAuraIcon,
				Filter = "HELPFUL",
				RowCount = 6,
				ColumnCount = 5,
				MarginTop = 2,
				ElementWidth = 16,
				ElementHeight = 16,
				HSpacing = 1,
				VSpacing = 1,
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
				ElementType = iAuraIcon,
				Filter = "HARMFUL",
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
				ElementType = iAuraIcon,
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
				ElementType = iAuraIcon,
				Filter = "HARMFUL|PLAYER",
				RowCount = 3,
				ColumnCount = 3,
				MarginTop = 2,
				ElementWidth = 24,
				ElementHeight = 24,
				TopToBottom = false,
			},
		},
		iDebuffPanel_Simple = {
			Type = AuraPanel,
			Name = "iDebuffPanel",
			Location = { AnchorPoint("TOPLEFT", 0, -4, nil, "BOTTOMLEFT") },
			Property = {
				ElementType = iAuraIcon,
				Filter = "HARMFUL",
				RowCount = 6,
				ColumnCount = 6,
				MarginTop = 2,
				ElementWidth = 16,
				ElementHeight = 16,

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
				"iPowerBarFrequent",
				"iCastBar",
				--"HealthTextFrequent",
				"HealthTextFrequent2",
				"iClassPower",
				"iSecureTotemBar",
				"CombatIcon",
				"PvpIcon",
				"iPlayerPowerText",
			},
			Size = Size(200, 14),
			Location = { AnchorPoint("TOPRIGHT", -100, -100, nil, "CENTER") },
		},
		{
			Unit = "pet",
			HideFrame1 = "PetFrame",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iPowerBarFrequent",
				"iCastBar",
				--"HealthTextFrequent",
				"HealthTextFrequent2",
				"iBuffPanel",
				"iDebuffPanel_Simple",
			},
			Size = Size(160, 10),
			Location = { AnchorPoint("TOPRIGHT", -32, -32, "player", "BOTTOM") },
		},
		{
			Unit = "target",
			HideFrame1 = "TargetFrame",
			Elements = {
				"iHealthBar",
				"NameLabel_Target",
				"LevelLabel",
				"iPowerBarFrequent",
				"iCastBar",
				--"HealthTextFrequent",
				"HealthTextFrequent2",
				"iPlayerBuffPanel",
				"iOtherBuffPanel",
				"iOtherDebuffPanel",
				"iPlayerDebuffPanel",
				"QuestBossIcon",
			},
			Size = Size(200, 10),
			Location = { AnchorPoint("TOPLEFT", 100, -100, nil, "CENTER") },
		},
		{
			Unit = "targettarget",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iDebuffPanel_Simple",
			},
			Size = Size(160, 4),
			Location = { AnchorPoint("TOPLEFT", 32, -32, "target", "BOTTOM") },
		},
		{
			Unit = "focus",
			HideFrame1 = "FocusFrame",
			Elements = {
				"iHealthBar",
				"NameLabel_Focus",
				"LevelLabel",
				"iBuffPanel",
				"iDebuffPanel_Simple",
			},
			Size = Size(160, 4),
			Location = { AnchorPoint("BOTTOMRIGHT", 0, 18, "player", "TOP") },
		},
		{
			Unit = "boss%d",
			Max = 5,
			HideFrame1 = "Boss%dTargetFrame",
			Elements = {
				"iHealthBar",
				"NameLabel",
				"LevelLabel",
				"iPowerBarFrequent",
				"iCastBar",
				--"HealthTextFrequent",
				"HealthTextFrequent2",
				"iBuffPanel",
				"iDebuffPanel",
				"RaidTargetIcon",
			},
			Size = Size(200, 10),
			Location = { AnchorPoint("TOPLEFT", 300, - 60) }, DX = 0, DY = -60
		},
		{
			Unit = "party%d",
			Max = 4,
			HideFrame1 = "PartyMemberFrame%d",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iPowerBarFrequent",
				"iCastBar",
				--"HealthTextFrequent",
				"HealthTextFrequent2",
				"iDebuffPanel_Simple",
			},
			Size = Size(200, 10),
			Location = { AnchorPoint("TOPLEFT", 40, - 60) }, DX = 0, DY = -60
		},
		{
			Unit = "partypet%d",
			Max	= 4,
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
			},
			Size = Size(160, 4),
			Location = { AnchorPoint("TOPLEFT", 0, -18, "party%d", "BOTTOM") },
		},
		{
			Unit = "focustarget",
			Elements = {
				"iHealthBar",
				"NameLabel_Simple",
				"LevelLabel",
				"iDebuffPanel_Simple",
			},
			Size = Size(160, 4),
			Location = { AnchorPoint("RIGHT", -4, 0, "focus", "LEFT") },
		},
	},

	-- Class settings
	Classes = {
		DEATHKNIGHT = { "iRuneBar" },
		MONK = { "iStaggerBar" },
	},
}