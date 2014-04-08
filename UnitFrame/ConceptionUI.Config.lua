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

local function OnUnitFrameLoaded(self)
	self.Alpha = 1
	self.Backdrop = TextureMap.Backdrop
	self.BackdropColor = TextureMap.BackdropColor

	self.OnPositionChanged = self.OnPositionChanged + ReMap_OnPositionChanged

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
		HealthBar = {
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
		HealthText = {
			Type = HealthTextFrequent,
			L_Location = { AnchorPoint("TOPLEFT", 0, -2, "iPowerBar", "BOTTOMLEFT") },
			R_Location = { AnchorPoint("TOPRIGHT", 0, -2, "iPowerBar", "BOTTOMRIGHT") },
			Property = {
				Smoothing = false,
				Font = FontType(FontMap.HandelGotD, 10, "NORMAL", false)
			},
		},
		PowerText = {
			Type = PowerTextFrequent,
			L_Location = { AnchorPoint("TOPRIGHT", 0, -2, "iPowerBar", "BOTTOMRIGHT") },
			R_Location = { AnchorPoint("TOPLEFT", 0, -2, "iPowerBar", "BOTTOMLEFT") },
			Property = {
				Smoothing = false,
				Font = FontType(FontMap.HandelGotD, 10, "NORMAL", false)
			},
		},
		NameLabel = {
			Type = NameLabel,
			L_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			R_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			Property = { UseClassColor = true },
		},
		NameLabel_Target = {
			Type = NameLabel,
			L_Location = { AnchorPoint("BOTTOMLEFT", 0, 2, "iHealthBar", "TOPLEFT") },
			R_Location = { AnchorPoint("BOTTOMRIGHT", 0, 2, "iHealthBar", "TOPRIGHT") },
			Property = { UseClassColor = true, UseTapColor = true, UseSelectionColor = true },
		},
		BarBackdrop = {
			Type = iBarBackdrop,
			Location = {
				AnchorPoint("TOPLEFT", -3, 3, "iHealthBar"),
				AnchorPoint("BOTTOMRIGHT", 3, -3, "iPowerBar"),
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
				"HealthBar",
				"HealthText",
				"PowerText",
				"NameLabel",
				"BarBackdrop",
				"Arrow",
			},
			Size = Size(200, 36),
			Location = AnchorPoint("TOPLEFT", 40, 0),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "pet",
			HideFrame1 = "PetFrame",
			Elements = {
			},
			Size = Size(160, 24),
			Location = AnchorPoint("TOPLEFT", 180, -40),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "target",
			HideFrame1 = "TargetFrame",
			Elements = {
				"PowerBar",
				"HealthBar",
				"HealthText",
				"PowerText",
				"NameLabel_Target",
				"BarBackdrop",
				"Arrow",
			},
			Size = Size(200, 36),
			Location = AnchorPoint("TOPLEFT", 280, 0),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "targettarget",
			Elements = {
			},
			Size = Size(160, 24),
			Location = AnchorPoint("TOPLEFT", 420, -40),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "focus",
			HideFrame1 = "FocusFrame",
			Elements = {
			},
			Size = Size(160, 24),
			Location = AnchorPoint("TOPLEFT", 20, -40),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "boss%d",
			Max = 5,
			HideFrame1 = "Boss%dTargetFrame",
			Elements = {
			},
			Size = Size(200, 36),
			Location = AnchorPoint("TOPLEFT", 600, - 64), DX = 0, DY = -64,
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "party%d",
			Max = 4,
			HideFrame1 = "PartyMemberFrame%d",
			Elements = {
			},
			Size = Size(200, 36),
			Location = AnchorPoint("TOPLEFT", 40, - 124), DX = 0, DY = -64,
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "partypet%d",
			Max	= 4,
			Elements = {
			},
			Size = Size(160, 24),
			Location = AnchorPoint("BOTTOMLEFT", 0, 0, "party%d", "BOTTOMRIGHT"),
			Loaded = OnUnitFrameLoaded,
		},
		{
			Unit = "focustarget",
			Elements = {
			},
			Size = Size(160, 24),
			Location = AnchorPoint("TOPLEFT", 20, -70),
			Loaded = OnUnitFrameLoaded,
		},
	},

	-- Class settings
	Classes = {
		DRUID = { "iEclipseBar" },
		DEATHKNIGHT = { "iRuneBar" },
		MONK = { "iStaggerBar" },
	},
}