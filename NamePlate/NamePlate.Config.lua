IGAS:NewAddon "IGAS_UI.NamePlate"

Config = {
	-- DockLayout settings for UnitFrame
	PANEL_VSPACING = 3,
	PANEL_HSPACING = 0,
	BAR_SIZE = 2,

	-- Element settings
	Elements = {
		{
			Type = iHealthBar,
			Direction = "south", Size = 2, Unit = "px",
		},
		{
			Type = iNameLabel,
			Direction = "south", Size = 16, Unit = "px",
			Property = {
				LevelFormat = "%s",
				WithServerName = false,
				UseTapColor = true,
				UseSelectionColor = true,
				UseClassColor = true,
			},
		},
		{
			Type = iCastBar,
			Location = {
				AnchorPoint("TOPLEFT", 0, -4, nil, "BOTTOMLEFT"),
				AnchorPoint("TOPRIGHT", 0, -4, nil, "BOTTOMRIGHT"),
			},
			Property = { AsNamePlate = true },
			ApplyFrameOptions = function(self, verticalScale, horizontalScale)
				local height = math.min(Config.BAR_SIZE * verticalScale, 6)
				self.Height = height

				self.Icon:ClearAllPoints()
				self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -2, 0)
				self.Icon:SetPoint("TOPRIGHT", self.Parent.iNameLabel, "LEFT", -2, 0)
				self.Icon.Width = 24
			end,
		},
		{
			Type = Frame,
			Name = "RestPanel",
			Direction = "rest",
		},
		{
			Type = iAuraPanel,
			Location = {
				AnchorPoint("BOTTOM", 0, 0, "RestPanel")
			},
			Property = {
				ElementType = iAuraIcon,
			},
			ApplyFrameOptions = function(self, verticalScale, horizontalScale)
				local size = 24 * math.min(verticalScale, horizontalScale)
				self.ElementWidth = size
				self.ElementHeight = size
			end,
		},
		{
			Type = RaidTargetIcon,
			Location = {
				AnchorPoint("LEFT", 2, 0, "iHealthBar", "RIGHT")
			},
		},
		{
			Type = iQuestMark,
			Location = {
				AnchorPoint("RIGHT", -2, 0, "iHealthBar", "LEFT")
			},
		},
		{
			Type = iHighlightMark,
			Location = {
				AnchorPoint("BOTTOM", 0, -6, "iNameLabel", "TOP")
			},
		}
	}
}