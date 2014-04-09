IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Init functions
--==========================
local function ReMap_OnPositionChanged(self)
	local prefix = (self::GetCenter() < GetScreenWidth() / 2) and "L_" or "R_"

	local unit = self.Unit

	for _, unitset in ipairs(Config.Units) do
		if unit:match(unitset.Unit) then
			for _, ele in ipairs(unitset.Elements) do
				local config = type(ele) == "string" and Config.Elements[ele] or ele
				local obj = config.Name and self:GetElement(config.Name) or self:GetElement(config.Type)

				local loc = config[prefix .. "Location"]

				if loc then obj.Location = loc end

				local props = config[prefix .. "Property"]

				if props then pcall(obj, props) end
			end
		end
	end
end

local function OnUnitFrameEnter(self)
	if self:GetElement("Arrow") then
		self:GetElement("Arrow").Visible = true
	end
end

local function OnUnitFrameLeave(self)
	if self:GetElement("Arrow") then
		self:GetElement("Arrow").Visible = false
	end
end

local function OnUnitFrameLoaded(self)
	self.Alpha = 1
	self.Backdrop = TextureMap.Backdrop
	self.BackdropColor = TextureMap.BackdropColor

	self.OnPositionChanged = self.OnPositionChanged + ReMap_OnPositionChanged
	self.OnEnter = self.OnEnter + OnUnitFrameEnter
	self.OnLeave = self.OnLeave + OnUnitFrameLeave

	return ReMap_OnPositionChanged(self)
end

--==========================
-- Config for UnitFrame
--==========================
Config = {
	-- enable hover spell cast like raid panels
	ENABLE_HOVER_SPELLCAST = false,

	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 2,
	PANEL_HSPACING = 0,

	-- Element settings
	Elements = {
		-- Major
		HealthBar_Major = {
			Type = iHealthBar,
			Direction = "south", Size = 3, Unit = "px",
			Property = { Smoothing = true, UseSmoothColor = true },
			L_Property = { ReverseFill = true },
			R_Property = { ReverseFill = false },
		},
		PowerBar = {
			Type = iPowerBar,
			Direction = "south", Size = 1, Unit = "px",
			Property = { Smoothing = true, UseSmoothColor = true },
			L_Property = { ReverseFill = true },
			R_Property = { ReverseFill = false },
		},
		HealthText_Major = {
			Type = HealthTextFrequent,
			L_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			R_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			Property = {
				Smoothing = false,
				Font = FontType(FontMap.HandelGotD, 28, "NORMAL", false)
			},
		},
		PowerText = {
			Type = PowerTextFrequent,
			L_Location = { AnchorPoint("TOPRIGHT", 0, -2, "iPowerBar", "BOTTOMRIGHT") },
			R_Location = { AnchorPoint("TOPLEFT", 0, -2, "iPowerBar", "BOTTOMLEFT") },
			Property = {
				Smoothing = false,
				Font = FontType(UNIT_NAME_FONT, 8, "NORMAL", false)
			},
		},
		NameLabel_Major = {
			Type = NameLabel,
			L_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			R_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			Property = {
				UseClassColor = true,
				Font = FontType(UNIT_NAME_FONT, 13, "NORMAL", false),
			},
		},
		NameLabel_Target = {
			Type = NameLabel,
			L_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			R_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			Property = {
				UseClassColor = true,
				UseTapColor = true,
				UseSelectionColor = true,
				Font = FontType(UNIT_NAME_FONT, 13, "NORMAL", false),
			},
		},
		LevelLabel_Major = {
			Type = LevelLabel,
			L_Location = { AnchorPoint("LEFT", 0, 0, "NameLabel", "RIGHT") },
			R_Location = { AnchorPoint("RIGHT", 0, 0, "NameLabel", "LEFT") },
			Property = {
				LevelFormat = "[ %d ]",
				Font = FontType(UNIT_NAME_FONT, 13, "NORMAL", false),
			},
		},

		-- Min --
		HealthBar_Min = {
			Type = iHealthBar,
			Direction = "south", Size = 1, Unit = "px",
			Property = { Smoothing = true, UseSmoothColor = true },
			L_Property = { ReverseFill = true },
			R_Property = { ReverseFill = false },
		},
		HealthText_Min = {
			Type = HealthTextFrequent,
			L_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			R_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			Property = {
				Smoothing = false,
				Font = FontType(FontMap.HandelGotD, 12, "NORMAL", false)
			},
		},
		NameLabel_Min = {
			Type = NameLabel,
			L_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			R_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			Property = {
				UseClassColor = true,
				Font = FontType(UNIT_NAME_FONT, 10, "NORMAL", false),
			},
		},

		-- Other --
		BarBackdrop = {
			Type = iBarBackdrop,
			Location = {
				AnchorPoint("TOPLEFT", -3, 3, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", 3, -3),
			},
		},
		Arrow = {
			Type = Texture,
			Name = "Arrow",
			L_Location = { AnchorPoint("LEFT", 0, -0.5, "iHealthBar", "RIGHT") },
			R_Location = { AnchorPoint("RIGHT", 0, -0.5, "iHealthBar", "LEFT") },
			Size = Size(16, 16),
			Property = { Visible = false }
			L_Property = { TexturePath = TextureMap.ArrowL },
			R_Property = { TexturePath = TextureMap.ArrowR },
		},
		TargetName = {
			Type = iTargetName,
			Location = { AnchorPoint("TOPLEFT"), AnchorPoint("BOTTOMRIGHT") },
		},
		CastBar = {
			Type = iCastBar,
			Location = {
				AnchorPoint("TOPLEFT"),
				AnchorPoint("BOTTOMRIGHT", 0, 2, iHealthBar, "TOPRIGHT"),
			},
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
				"PowerBar",
				"HealthBar_Major",
				"HealthText_Major",
				"PowerText",
				"NameLabel_Major",
				"LevelLabel_Major",
				"BarBackdrop",
				"Arrow",
				"CastBar",
			},
			Size = Size(210, 32),
			Location = { AnchorPoint("TOPLEFT", 40, 0) },
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "pet",
			HideFrame1 = "PetFrame",
			Elements = {
				"PowerBar",
				"HealthBar_Min",
				"HealthText_Min",
				"PowerText",
				"NameLabel_Min",
				"BarBackdrop",
				"Arrow",
			},
			Size = Size(130, 14),
			Location = { AnchorPoint("TOPLEFT", 180, -40) },
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "pettarget",
			Elements = { "TargetName", },
			Size = Size(100, 14),
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "pet", "TOPRIGHT"),
				AnchorPoint("BOTTOMLEFT", 0, 0, "pet", "BOTTOMRIGHT"),
			},
		},
		{
			Unit = "target",
			HideFrame1 = "TargetFrame",
			Elements = {
				"PowerBar",
				"HealthBar_Major",
				"HealthText_Major",
				"PowerText",
				"NameLabel_Target",
				"LevelLabel_Major",
				"BarBackdrop",
				"Arrow",
				"CastBar",
			},
			Size = Size(210, 32),
			Location = { AnchorPoint("TOPLEFT", 280, 0) },
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "targettarget",
			Elements = { "TargetName", },
			Size = Size(100, 14),
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "target", "TOPRIGHT"),
				AnchorPoint("BOTTOMLEFT", 0, 0, "target", "BOTTOMRIGHT"),
			},
		},
		{
			Unit = "focus",
			HideFrame1 = "FocusFrame",
			Elements = {
				"PowerBar",
				"HealthBar_Major",
				"HealthText_Major",
				"PowerText",
				"NameLabel_Major",
				"BarBackdrop",
				"Arrow",
			},
			Size = Size(130, 14),
			Location = { AnchorPoint("TOPLEFT", 20, -40) },
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "boss%d",
			Max = 5,
			HideFrame1 = "Boss%dTargetFrame",
			Elements = {
				"PowerBar",
				"HealthBar_Major",
				"HealthText_Major",
				"PowerText",
				"NameLabel_Major",
				"BarBackdrop",
				"Arrow",
				"CastBar",
			},
			Size = Size(210, 32),
			Location = { AnchorPoint("TOPLEFT", 600, - 64) }, DX = 0, DY = -64,
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "party%d",
			Max = 4,
			HideFrame1 = "PartyMemberFrame%d",
			Elements = {
				"PowerBar",
				"HealthBar_Major",
				"HealthText_Major",
				"PowerText",
				"NameLabel_Major",
				"LevelLabel_Major",
				"BarBackdrop",
				"Arrow",
				"CastBar",
			},
			Size = Size(210, 32),
			Location = { AnchorPoint("TOPLEFT", 40, - 114) }, DX = 0, DY = -64,
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "partypet%d",
			Max	= 4,
			Elements = {
				"PowerBar",
				"HealthBar_Min",
				"HealthText_Min",
				"PowerText",
				"NameLabel_Min",
				"BarBackdrop",
				"Arrow",
			},
			Size = Size(130, 14),
			Location = { AnchorPoint("BOTTOMLEFT", 0, 0, "party%d", "BOTTOMRIGHT") },
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "focustarget",
			Elements = { "TargetName", },
			Size = Size(100, 14),
			Location = {
				AnchorPoint("TOPLEFT", 0, 0, "focus", "TOPRIGHT"),
				AnchorPoint("BOTTOMLEFT", 0, 0, "focus", "BOTTOMRIGHT"),
			},
		},
	},

	-- Class settings
	Classes = {
		DRUID = { "iEclipseBar" },
		DEATHKNIGHT = { "iRuneBar" },
		MONK = { "iStaggerBar" },
	},
}