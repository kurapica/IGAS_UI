IGAS:NewAddon "IGAS_UI.NamePlate"

Config = {
	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 1,
	PANEL_HSPACING = 0,

	-- Element settings
	Elements = {
		{
			Type = iCastBar,
			Location = {
				AnchorPoint("TOPLEFT", 0, -4, nil, "BOTTOMLEFT"),
				AnchorPoint("TOPRIGHT", 0, -4, nil, "BOTTOMRIGHT"),
			},
			Property = {
				Height = 8,
			},
		},
		{
			Type = iPowerBar,
			Direction = "south", Size = 2, Unit = "px",
		},
		{
			Type = iHealthBar,
			Direction = "south", Size = 6, Unit = "px",
		},
		{
			Type = Frame,
			Name = "SeperatePanel",
			Direction = "south", Size = 1, Unit = "px",
		},
		{
			Type = iNameLabel,
			Direction = "south", Size = 16, Unit = "px",
			Property = {
				UseTapColor = true,
				UseSelectionColor = true,
				UseClassColor = true,
				Font = {
					path = _G.UNIT_NAME_FONT,
					height = 16,
				}
			},
		},
		{
			Type = Frame,
			Name = "RestPanel",
			Direction = "rest",
		},
		{
			Type = iAuraPanel,
			Location = {
				AnchorPoint("BOTTOM", 0, 0, "RestPanel", "BOTTOM")
			},
		},
	}
}