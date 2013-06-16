-----------------------------------------
-- Definition for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

import "System.Widget"

class "NamePlateMask"
	inherit "VirtualUIObject"

	STATUSBAR_TEXTURE_PATH = STATUSBAR_TEXTURE_PATH

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	local function OnShow(self)
		self.CastBack:SetAlpha(0)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function NamePlateMask(self, name, parent)
    	-- HealthBar
		self.HealthBar = ({({parent:GetChildren()})[1]:GetChildren()})[1]

		self.HealthBar:SetStatusBarTexture(STATUSBAR_TEXTURE_PATH, "ARTWORK")
		iBorder._BuildBorder(self.HealthBar)

		-- Original back
		local back = ({({parent:GetChildren()})[1]:GetRegions()})[2]
		back:SetAlpha(0)

		-- CastBar
		self.CastBar = IGAS:GetWrapper(({({parent:GetChildren()})[1]:GetChildren()})[2])

		self.CastBar.OnShow = OnShow

		self.CastBar:SetStatusBarTexture(STATUSBAR_TEXTURE_PATH, "ARTWORK")
		iBorder._BuildBorder(self.CastBar)

		self.CastBar.CastBack = ({({({parent:GetChildren()})[1]:GetChildren()})[2]:GetRegions()})[2]
    end
endclass "NamePlateMask"