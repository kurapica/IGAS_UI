-----------------------------------------
-- Minimap
-----------------------------------------
IGAS:NewAddon "IGAS_UI.MiniMap"

import "System.Widget"

_THIN_BORDER = {
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
}

Minimap = IGAS.Minimap

local locked = true
local mask
local maskBuffFrame
local mnuMinimap
local mnuBuffFrame

Toggle = {
	Message = L"Lock Minimap",
	Get = function()
		return locked
	end,
	Set = function (value)
		locked = value

		if locked then
			if mask then mask:Hide() mnuMinimap:Hide() end
			if maskBuffFrame then maskBuffFrame:Hide() mnuBuffFrame:Hide() end
			if _DB.AutoFade then
				Minimap:OnEnter()
			else
				Minimap.Alpha = 1
				MinimapZoneTextButton.Alpha = 1
			end
		else
			if not mask then
				mask = Mask("IGAS_UI_Minimap_Mask", Minimap)
				mask.AsMove = true
				mask.AsResize = true
				mask.OnMoveFinished = function()
					_DB.Location = Minimap.Location
				end
				mask.OnResizeFinished = function()
					_DB.Location = Minimap.Location
					local width, height = Minimap:GetSize()
					local size = math.min(width, height)
					Minimap:SetSize(size, size)
					_DB.Size = Minimap.Size
					local zoom = Minimap.Zoom
					if zoom > 0 then
						Minimap.Zoom = 0
						Minimap.Zoom = zoom
					else
						Minimap.Zoom = 1
						Minimap.Zoom = 0
					end
				end

				mnuMinimap = DropDownList("IGAS_UI_Minimap_Menu", Minimap)
				mnuMinimap.ShowOnCursor = false
				mnuMinimap.AutoHide = false
				mnuMinimap.Visible = false
				mnuMinimap:SetPoint("TOP", mask, "BOTTOM")

				_MenuAutoFade = mnuMinimap:AddMenuButton(L"Auto Fade Out")
				_MenuAutoFade.IsCheckButton = true
				_MenuAutoFade.OnCheckChanged = function(self)
					_DB.AutoFade = self.Checked
				end

				local modify = mnuMinimap:AddMenuButton(L"Modify AnchorPoints")
				modify:ActiveThread("OnClick")
				modify.OnClick = function(self)
					IGAS:ManageAnchorPoint(Minimap, UIParent, true)
					_DB.Location = Minimap.Location
				end
			end

			if not maskBuffFrame then
				maskBuffFrame = Mask("IGAS_UI_BuffFrame_Mask", BuffFrame)
				maskBuffFrame.AsMove = true
				maskBuffFrame.OnMoveFinished = function()
					_DB.BuffFrameLocation = BuffFrame.Location
				end

				mnuBuffFrame = DropDownList("IGAS_UI_BuffFrame_Menu", BuffFrame)
				mnuBuffFrame.ShowOnCursor = false
				mnuBuffFrame.AutoHide = false
				mnuBuffFrame.Visible = false
				mnuBuffFrame:SetPoint("TOP", maskBuffFrame, "BOTTOM")

				local modify = mnuBuffFrame:AddMenuButton(L"Modify AnchorPoints")
				modify:ActiveThread("OnClick")
				modify.OnClick = function(self)
					IGAS:ManageAnchorPoint(BuffFrame, UIParent, true)
					_DB.BuffFrameLocation = BuffFrame.Location
				end
			end

			_MenuAutoFade.Checked = _DB.AutoFade
			Minimap.Alpha = 1
			MinimapZoneTextButton.Alpha = 1

			mask:Show()
			mnuMinimap:Show()
			maskBuffFrame:Show()
			mnuBuffFrame:Show()
		end

		Toggle.Update()
	end,
	Update = function() end,
}

function BuildBorder(self)
	self.Backdrop = _THIN_BORDER
	self.BackdropBorderColor = Media.PLAYER_CLASS_COLOR
end

function OnLoad(self)
	self:SecureHook("TimeManager_LoadUI")
	self:SecureHook("UIParent_UpdateTopFramePositions")

	_DB = _Addon._DB.Minimap or {}
	_Addon._DB.Minimap = _DB

	if _DB.Location then
		Minimap.Location = _DB.Location
	end

	if _DB.Size then
		local width, height = _DB.Size.width, _DB.Size.height
		local size = math.min(width, height)
		Minimap:SetSize(size, size)
		local zoom = Minimap.Zoom
		if zoom > 0 then
			Minimap.Zoom = 0
			Minimap.Zoom = zoom
		else
			Minimap.Zoom = 1
			Minimap.Zoom = 0
		end
	end

	_DB.MoveBuffFrame = nil
	if _DB.BuffFrameLocation then
		BuffFrame.Location = _DB.BuffFrameLocation
	end

	if _DB.AutoFade then
		Minimap:OnEnter()
	end
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

				--BuildBorder(TimeManagerClockButton)

				TimeManagerClockTicker:ClearAllPoints()
				TimeManagerClockTicker:SetPoint("CENTER")

				TimeManagerClockButton:SetSize(TimeManagerClockTicker:GetStringWidth()+4, TimeManagerClockTicker:GetStringHeight() + 4)

				TimeManagerClockButton:ClearAllPoints()
				TimeManagerClockButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 4)

				return
			end
		end
	end)
end

function UIParent_UpdateTopFramePositions()
	if _DB.BuffFrameLocation then
		Task.NoCombatCall(function()
			BuffFrame.Location = _DB.BuffFrameLocation
		end)
	end
end

-----------------------------
-- Init
-----------------------------

Minimap.MouseWheelEnabled = true

function Minimap:OnMouseWheel(wheel)
    if wheel > 0 then
        Minimap.Zoom = Minimap.Zoom < 5 and (Minimap.Zoom + 1) or 5
    else
        Minimap.Zoom = Minimap.Zoom > 0 and (Minimap.Zoom - 1) or 0
    end
end

function Minimap:OnEnter()
	if _DB.AutoFade then
		self.Alpha = 1
		MinimapZoneTextButton.Alpha = 1
		self.StartTime = GetTime()

		if not self.ThreadStart then
			Task.ThreadCall(function()
				self.ThreadStart = true

				local alpha = 0

				while alpha < 1 do
					self.Alpha = 1-alpha
					MinimapZoneTextButton.Alpha = 1 - alpha

					if self:IsMouseOver() then
						self.StartTime = GetTime()
						alpha = 0
					else
						alpha = (GetTime() - self.StartTime) / 3.0
					end

					Task.Next()
				end

				self.Alpha = 0
				MinimapZoneTextButton.Alpha = 0
				self.ThreadStart = false
			end)
		end
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

-- GarrisonLandingPageMinimapButton
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("CENTER", Minimap, "BOTTOMLEFT")

-- MiniMapInstanceDifficulty
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -6, 4)

-- GuildInstanceDifficulty
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -6, 4)

-- MiniMapChallengeMode
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- QueueStatusMinimapButton
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("CENTER", Minimap, "BOTTOMLEFT", 0, 30)
