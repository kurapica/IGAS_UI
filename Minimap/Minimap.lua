-----------------------------------------
-- Minimap
-----------------------------------------
IGAS:NewAddon "IGAS_UI.MiniMap"

import "System.Widget"

_PLAYER_COLOR = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
_THIN_BORDER = {
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
}

function BuildBorder(self)
	self.Backdrop = _THIN_BORDER
	self.BackdropBorderColor = _PLAYER_COLOR
end

function OnLoad(self)
	self:SecureHook("TimeManager_LoadUI")
end

function TimeManager_LoadUI()
	_M:ThreadCall(function()
		while true do
			Threading.Sleep(0.1)
			if _G.TimeManagerClockButton then
				Threading.Sleep(0.1)

				for _, f in pairs{TimeManagerClockButton:GetRegions()} do
				    if f:IsClass(Texture) then
				        f:Hide()
				    end
				end

				BuildBorder(TimeManagerClockButton)

				TimeManagerClockTicker:ClearAllPoints()
				TimeManagerClockTicker:SetPoint("CENTER")

				TimeManagerClockButton:SetSize(TimeManagerClockTicker:GetStringWidth()+4, TimeManagerClockTicker:GetStringHeight() + 4)

				TimeManagerClockButton:ClearAllPoints()
				TimeManagerClockButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT")

				return
			end
		end
	end)
end

Minimap = IGAS.Minimap

Minimap.MouseWheelEnabled = true

function Minimap:OnMouseWheel(wheel)
    if wheel > 0 then
        Minimap.Zoom = Minimap.Zoom < 5 and (Minimap.Zoom + 1) or 5
    else
        Minimap.Zoom = Minimap.Zoom > 0 and (Minimap.Zoom - 1) or 0
    end
end

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 4)
MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 4)

MiniMapTracking:Show()
MiniMapTrackingBackground:Hide()
MiniMapTrackingIconOverlay:Hide()
MiniMapTrackingButtonBorder:Hide()

MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetAllPoints()
MinimapZoneText.JustifyH = "CENTER"

MinimapBorderTop.TexturePath = nil
MiniMapWorldMapButton:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MinimapBorder.TexturePath = nil
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")

innerBorder = Frame("InnerBorder", Minimap)
innerBorder.FrameStrata = "LOW"
innerBorder:SetAllPoints()
BuildBorder(innerBorder)

outBorder = Frame("OutBorder", Minimap)
outBorder.FrameStrata = "BACKGROUND"
outBorder:SetPoint("TOP", MinimapZoneTextButton, "TOP", 0, 4)
outBorder:SetPoint("BOTTOMLEFT", -4, -4)
outBorder:SetPoint("BOTTOMRIGHT", 4, -4)
BuildBorder(outBorder)

-- GameTimeFrame
GameTimeFrame.NormalTexture.TexturePath = nil
GameTimeFrame.PushedTexture.TexturePath = nil
GameTimeFrame.HighlightTexture.TexturePath = nil
GameTimeFrame.NormalFontObject = TextStatusBarTextLarge

GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT")
GameTimeFrame:SetSize(30, 30)
