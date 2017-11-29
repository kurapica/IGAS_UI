-----------------------------------------
-- Definition for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

if IsAddOnLoaded("Masque") then
	MSQ = LibStub("Masque", true)
	IGAS_UI_Group = MSQ:Group("IGAS_UI", "ActionBar")

	function ReloadMasqueSkin()
		IGAS_UI_Group:ReSkin()
	end

	function AddtoMasque(self)
		self.UseMasque = true

		IGAS_UI_Group:AddButton(IGAS:GetUI(self), {
			FloatingBG = IGAS:GetUI(self:GetChild("FlyoutBorder")),
			Icon = IGAS:GetUI(self:GetChild("Icon")),
			-- Cooldown = {...},
			Flash = IGAS:GetUI(self:GetChild("Flash")),
			Pushed = IGAS:GetUI(self.PushedTexture),
			Normal = IGAS:GetUI(self.NormalTexture),
			-- Disabled = {...},
			Checked = IGAS:GetUI(self.CheckedTexture),
			Border = IGAS:GetUI(self:GetChild("Border")),
			-- AutoCastable = {...},
			Highlight = IGAS:GetUI(self.HighlightTexture),
			HotKey = IGAS:GetUI(self:GetChild("HotKey")),
			Count = IGAS:GetUI(self:GetChild("Count")),
			Name = IGAS:GetUI(self:GetChild("Name")),
			-- Duration = {...},
			-- Shine = {...},
		})
	end
else
	function ReloadMasqueSkin()
		-- fake
	end

	function AddtoMasque(self)
		-- fake
	end
end
