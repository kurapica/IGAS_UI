IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "HealthBarFrequent"
	extend "iBorder" "iStatusBarStyle"
	extend "IFClassification"

	function SetClassification(self, classification)
		if self.Unit == "target" then
			if classification == "worldboss" or classification == "elite" then
				self.Back.BackdropBorderColor = Media.ELITE_BORDER_COLOR
			elseif classification == "rareelite" or classification == "rare" then
				self.Back.BackdropBorderColor = Media.RARE_BORDER_COLOR
			else
				self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
			end
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.UseClassColor = true
	end
endclass "iHealthBar"
