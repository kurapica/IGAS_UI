-----------------------------------------
-- Script for ChatFrame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ChatFrame"

_LoadedTab = 1

function OnLoad(self)
	_G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	_G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

	self:SecureHook("FCF_StopDragging")
	self:SecureHook("FCF_OpenTemporaryWindow")

	_DBChar.ChatFramePos = _DBChar.ChatFramePos or {}
	_ChatFramePos = _DBChar.ChatFramePos
end

function OnEnable(self)
	local _leave = true
	_G.CHAT_SHOW_IME = false

	while _G["ChatFrame" .. _LoadedTab] do
		ApplyStyle("ChatFrame" .. _LoadedTab)

		_LoadedTab = _LoadedTab + 1
	end

	_G.QuickJoinToastButton:Hide()

	_G.ChatFrameMenuButton:ClearAllPoints()
	_G.ChatFrameMenuButton:SetAlpha(0.1)
	_G.ChatFrameMenuButton:SetPoint("TOPRIGHT", _G["ChatFrame1"])
	--[[_G.ChatFrameMenuButton:HookScript("OnEnter", function(self) _leave = false self:SetAlpha(1) end)
	_G.ChatFrameMenuButton:HookScript("OnLeave", function(self)
		_leave = true
		Task.ThreadCall(function()
			while _leave and self:GetAlpha() > 0.1 do
				self:SetAlpha(self:GetAlpha() - 0.1)
				Task.Delay(0.1)
			end
		end)
	end)--]]

	for name, loc in pairs(_ChatFramePos) do
		IGAS[name].Location = loc
	end

	self:SecureHook(_G["ChatFrame" .. 1 .. "Tab"], "SetAlpha")
	ChatFrameMenuButton:SetAlpha(_G["ChatFrame" .. 1 .. "Tab"]:GetAlpha())
end

function FCF_OpenTemporaryWindow()
	while _G["ChatFrame" .. _LoadedTab] do
		ApplyStyle("ChatFrame" .. _LoadedTab)

		_LoadedTab = _LoadedTab + 1
	end
end

function ApplyStyle(tabName)
	_G[tabName]:SetClampRectInsets(0, 0, 38, - 38)
	FCF_SetWindowAlpha(_G[tabName], 0)

	_G[tabName .. "EditBoxLeft"]:Hide()
	_G[tabName .. "EditBoxRight"]:Hide()
	_G[tabName .. "EditBoxMid"]:Hide()
	_G[tabName .. "ButtonFrame"]:Hide()

	_G[tabName .. "Tab"].noMouseAlpha = 0
	_G[tabName .. "Tab"].leftTexture:SetTexture(nil)
	_G[tabName .. "Tab"].middleTexture:SetTexture(nil)
	_G[tabName .. "Tab"].rightTexture:SetTexture(nil)
end

function SetAlpha(self, alpha)
	ChatFrameMenuButton:SetAlpha(alpha)
end

function FCF_StopDragging(frame)
	local name = frame:GetName()
	_ChatFramePos[name] = IGAS[name].Location
end