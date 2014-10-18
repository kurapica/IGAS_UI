-----------------------------------------
-- Designer for Spell cooldown line
-----------------------------------------

IGAS:NewAddon "IGAS_UI.SpellCooldownLine"

_BUFF_MAXDURATION = 31
_GLOBAL_COOLDOWN = 1.5
_MAX_FRAG = 6

------------------------------
-- Backdrop Settings
------------------------------
_Backdrop = {
    edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND",
    tile = true, tileSize = 16, edgeSize = 1,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
_BackdropEmpty = {}

------------------------------
-- Spell Handler
------------------------------
btnHandler = Button("IGASUI_SpellCooldownLine_Handler")
btnHandler.Width = 48
btnHandler.Height = 48
btnHandler:SetPoint("BOTTOMLEFT", 450, 300)
btnHandler.MinResize = { width = 18, height = 18}

btnHandler.Backdrop = _Backdrop
btnHandler:RegisterForClicks("AnyDown", "AnyUp")
btnHandler.Movable = true
btnHandler.Resizable = true
btnHandler.MouseEnabled = true
btnHandler.MouseWheelEnabled = true

-- Sizer
sizer_se = Button("Sizer_se", btnHandler)
sizer_se.Width = 16
sizer_se.Height = 16
sizer_se.MouseEnabled = true
sizer_se:SetPoint("BOTTOMRIGHT", btnHandler, "BOTTOMRIGHT", 0, 0)
sizer_se.NormalTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]
sizer_se.HighlightTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]]
sizer_se.PushedTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]]

lineCooldown = Texture("CoolDownLine", btnHandler)

for i = 1, _MAX_FRAG do
	lineCooldown[i] = FontString("CoolDownLineTxt"..i, btnHandler, "BACKGROUND", "TextStatusBarText")
	lineCooldown[i].JustifyV = "BOTTOM"
	lineCooldown[i].Text = tostring(2^i)
end

lineBuff = Texture("BuffLine", btnHandler)

for i = 1, _MAX_FRAG do
	lineBuff[i] = FontString("BuffLineTxt"..i, btnHandler, "BACKGROUND", "TextStatusBarText")
	lineBuff[i].JustifyV = "BOTTOM"
	lineBuff[i].Text = tostring(2^i)
end

lstWhite = List("WhiteList", btnHandler)
lstWhite:SetPoint("RIGHT", btnHandler, "LEFT")
lstWhite.Width = 200
lstWhite.Height = 160
lstWhite.Visible = false
lstWhite.ShowTootip = true

lstBlack = List("BlackList", btnHandler)
lstBlack:SetPoint("LEFT", btnHandler, "RIGHT")
lstBlack.Width = 200
lstBlack.Height = 160
lstBlack.Visible = false
lstBlack.ShowTootip = true