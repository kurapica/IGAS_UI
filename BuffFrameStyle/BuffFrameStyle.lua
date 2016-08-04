-----------------------------------------
-- BuffFrameStyle
-----------------------------------------
IGAS:NewAddon "IGAS_UI.BuffFrameStyle"

import "System.Widget"

_BorderTexture = [[Interface\Addons\IGAS_UI\Resource\border.tga]]

_PLAYER_CLASS_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
_PLAYER_CLASS_COLOR.a = 1

_Masked = {}

_M:SecureHook("BuffButton_OnLoad")

function BuffButton_OnLoad(self)
	BuildStyle(self)
end

function BuildStyle(buff)
	if not _Masked[buff] then
		_Masked[buff] = true

		local mask = Texture("IGAS_UI_Mask", buff)
		mask:SetAllPoints()
		mask.DrawLayer = "OVERLAY"
		mask.TexturePath = _BorderTexture
		mask.VertexColor = _PLAYER_CLASS_COLOR
	end
end
