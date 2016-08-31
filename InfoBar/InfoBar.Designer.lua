-----------------------------------------
-- Designer for Info Bar
-----------------------------------------
IGAS:NewAddon "IGAS_UI.InfoBar"

import "System.Widget"

_Status = Frame("IGASUI_InfoBar")
_Status.Movable = true
_Status.Resizable = true
_Status.MouseEnabled = true
_Status.MouseWheelEnabled = true
_Status.Width = 300
_Status.Height = 24
_Status:SetPoint"TOP"
_Status.MinResize = Size(100, 16)

_LeftTexture = Texture("LeftTexture", _Status)
_LeftTexture:SetPoint"TOPLEFT"
_LeftTexture:SetPoint"BOTTOMLEFT"
_LeftTexture:SetPoint("RIGHT", _Status, "CENTER")
_LeftTexture.Color = ColorType(1, 1, 1)

_RightTexture = Texture("RightTexture", _Status)
_RightTexture:SetPoint"TOPRIGHT"
_RightTexture:SetPoint"BOTTOMRIGHT"
_RightTexture:SetPoint("LEFT", _Status, "CENTER")
_RightTexture.Color = ColorType(1, 1, 1)

_Text = FontString("Status", _Status, "ARTWORK", "TextStatusBarTextLarge")
_Text:SetPoint"CENTER"

_Timer = Timer("RefreshTimer", _Status)
_Timer.Interval = 2
