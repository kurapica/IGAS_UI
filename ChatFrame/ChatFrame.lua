-----------------------------------------
-- Script for ChatFrame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ChatFrame"

function OnLoad(self)
	self:SecureHook("FCF_StopDragging")

	_DBChar.ChatFramePos = _DBChar.ChatFramePos or {}
	_ChatFramePos = _DBChar.ChatFramePos
end

function OnEnable(self)
	local i = 1
	_G.CHAT_SHOW_IME = false

	while _G["ChatFrame" .. i] do
		_G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 38, - 38)
		FCF_SetWindowAlpha(_G["ChatFrame" .. i], 0)

		_G["ChatFrame" .. i .. "EditBoxLeft"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxRight"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxMid"]:Hide()
		_G["ChatFrame" .. i .. "ButtonFrame"]:Hide()

		i = i + 1
	end

	ChatFrameMenuButton:Hide()
	FriendsMicroButton:Hide()

	for name, loc in pairs(_ChatFramePos) do
		IGAS[name].Location = loc
	end
end

function FCF_StopDragging(frame)
	local name = frame:GetName()
	_ChatFramePos[name] = IGAS[name].Location
end