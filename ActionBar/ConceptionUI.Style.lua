-----------------------------------------
-- Style Interface for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

local path = [[Interface\AddOns\ConceptionUI\media\]]

TextureMap = {
	Button			= path..[[texture\button]],
	ButtonShadow	= path..[[texture\buttonShadow]],
	ButtonOverlay	= path..[[texture\buttonOverlay]],

	NormalColor		= ColorType(0, 0, 0),
	PushColor		= ColorType(1, 0, 0),
	HightLightColor	= ColorType(1, 1, 0),
	CheckedColor	= ColorType(0, 0, 0),

	ButtonBorder 	= { -- action bar buttons
		bgFile		= nil,
		edgeFile	= path..[[texture\backdropPixel]],
		edgeSize	= 2,
		insets		= {left=2, right=2, top=2, bottom=2},
		tile		= false
	},
}

interface "IFStyle"

    function IFStyle(self)
    	self.UseBlizzardArt = false

		self.NormalTexturePath = TextureMap.ButtonOverlay
		self.NormalTexture.VertexColor = TextureMap.NormalColor
    	self.NormalTexture:ClearAllPoints()
    	self.NormalTexture:SetAllPoints()

    	self.PushedTexturePath = TextureMap.ButtonOverlay
    	self.PushedTexture.VertexColor = TextureMap.PushColor

    	self.HighlightTexturePath = TextureMap.ButtonOverlay
    	self.HighlightTexture.VertexColor = TextureMap.HightLightColor

    	self.CheckedTexturePath = TextureMap.ButtonOverlay
    	self.CheckedTexture.VertexColor = TextureMap.CheckedColor

		self:GetChild('Border'):SetTexture(nil)

		self:GetChild('HotKey'):SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		--self:GetChild('HotKey'):SetDrawLayer('HIGHLIGHT')

		self:GetChild('Name'):SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		--self:GetChild('Name'):SetDrawLayer('HIGHLIGHT')

		self:GetChild('Count'):SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		self:GetChild('Count'):SetDrawLayer('OVERLAY')

		self:GetChild('Icon'):SetTexCoord(.1, .9, .1, .9)

		self:GetChild("FlyoutBorder"):SetTexture(nil)
		self:GetChild("FlyoutBorderShadow"):SetTexture(nil)

		local shadowFrame = Frame("ShadowFrame", self)
		shadowFrame = CreateFrame('Frame', nil, self)
		shadowFrame:SetFrameLevel(self:GetFrameLevel() -1)
		shadowFrame:SetPoint('TOPLEFT', -8, 8)
		shadowFrame:SetPoint('BOTTOMRIGHT', 8, -8)

		local shadow = Texture("Shadow", shadowFrame, "BACKGROUND")
		shadow:SetTexture(TextureMap.buttonShadow)
		shadow:SetVertexColor(0, 0, 0, .6)
		shadow:SetAllPoints()

		local borderFrame = Frame("BorderFrame", self)
		borderFrame:SetPoint('TOPLEFT', -2, 2)
		borderFrame:SetPoint('BOTTOMRIGHT', 2, -2)
		borderFrame:SetFrameLevel(self:GetFrameLevel()-2)
		borderFrame:SetBackdrop(TextureMap.ButtonBorder)
		borderFrame:SetBackdropBorderColor(.1, .1, .1, 1)
    end
endinterface "IFStyle"

class "IActionButton"
	extend "IFStyle"

	local function RefreshBorder(self)
		if self.Count == nil then
			if self.EquippedItemIndicator then
				self:GetChild("BorderFrame"):SetBackdropBorderColor(.1, .6, .1, 1)
			else
				self:GetChild("BorderFrame"):SetBackdropBorderColor(.1, .1, .1, 1)
			end
		elseif self.Count == "0" then
			self:GetChild("BorderFrame"):SetBackdropBorderColor(.6, .1, .1, 1)
		else
			self:GetChild("BorderFrame"):SetBackdropBorderColor(.1, .1, .1, 1)
		end
	end

	__Handler__( function(self)
		self:GetChild("Count").Text = tostring(value or "")

		return RefreshBorder(self)
	end)
	property "Count" { Type = System.String + System.Number + nil }

	__Handler__( RefreshBorder )
	property "EquippedItemIndicator" { Type = Boolean }

endclass "IActionButton"