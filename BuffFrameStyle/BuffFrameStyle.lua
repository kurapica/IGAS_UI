-----------------------------------------
-- BuffFrameStyle
-----------------------------------------
IGAS:NewAddon "IGAS_UI.BuffFrameStyle"

import "System.Widget"

_BorderTexture = [[Interface\Addons\IGAS_UI\Resource\border.tga]]

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
		mask.VertexColor = Media.ACTIVED_BORDER_COLOR

		local icon = _G[buff:GetName() .. "Icon"]
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", buff, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -2, 2)

		_M:SecureHook(icon, "SetTexture", HookSetTexture)
	end
end

function HookSetTexture(self, path)
	if path then
		self:SetTexCoord(0.06, 0.94, 0.06, 0.94)
	end
end
