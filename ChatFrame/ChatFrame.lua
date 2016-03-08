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
	local _leave = true
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

	_G.FriendsMicroButton:Hide()

	_G.ChatFrameMenuButton:ClearAllPoints()
	_G.ChatFrameMenuButton:SetAlpha(0.1)
	_G.ChatFrameMenuButton:SetPoint("TOPRIGHT", _G["ChatFrame1"])
	_G.ChatFrameMenuButton:HookScript("OnEnter", function(self) _leave = false self:SetAlpha(1) end)
	_G.ChatFrameMenuButton:HookScript("OnLeave", function(self)
		_leave = true
		Task.ThreadCall(function()
			while _leave and self:GetAlpha() > 0.1 do
				self:SetAlpha(self:GetAlpha() - 0.1)
				Task.Delay(0.1)
			end
		end)
	end)

	for name, loc in pairs(_ChatFramePos) do
		IGAS[name].Location = loc
	end
end

function FCF_StopDragging(frame)
	local name = frame:GetName()
	_ChatFramePos[name] = IGAS[name].Location
end