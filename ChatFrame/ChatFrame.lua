-----------------------------------------
-- Script for ChatFrame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.ChatFrame"

local _LoadedTab = 1
local _CheckCompare = false
local _CheckType = nil
local _CheckAchievement = nil
local GameTooltip = _G.GameTooltip

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
		if IGAS[name] then IGAS[name].Location = loc end
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
	_G[tabName]:HookScript("OnHyperlinkEnter", OnHyperlinkEnter)
	_G[tabName]:HookScript("OnHyperlinkLeave", OnHyperlinkLeave)

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

-- OnHyperlinkEnter
function OnHyperlinkEnter(self, linkData)
	local linkType, id = strsplit(":", linkData, 3)

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, linkData)
	if ok then
		GameTooltip:Show()

		if linkType == "item" then
			_CheckCompare = true
			_CheckType = "item"

			return Task.ThreadCall(AutoCheckCompare)
		elseif linkType == "achievement" and id then
			local selfLink = GetAchievementLink(id)

			if selfLink then
				_CheckCompare = true
				_CheckType = "achievement"
				_CheckAchievement = selfLink

				return Task.ThreadCall(AutoCheckCompare)
			end
		end
	end
end

-- OnHyperlinkLeave
function OnHyperlinkLeave(self, linkData)
	_CheckCompare = false
	_CheckAchievement = nil
	_CheckType = nil
	GameTooltip:Hide()
	if ( GameTooltip.shoppingTooltips ) then
		for _, frame in pairs(GameTooltip.shoppingTooltips) do
			frame:Hide();
		end
	end
end

-- AutoCheckCompareAchievement
function AutoCheckCompare()
	local inCompare = false

	while true do
		if not _CheckCompare then
			inCompare = false
			return
		end

		Task.Next()

		if _CheckType == "item" then
			if GameTooltip:IsShown() and IsModifiedClick("COMPAREITEMS") then
				if not inCompare then
					inCompare = true
					GameTooltip_ShowCompareItem()
				end
			elseif inCompare then
				inCompare = false
				if ( GameTooltip.shoppingTooltips ) then
					for _, frame in pairs(GameTooltip.shoppingTooltips) do
						frame:Hide();
					end
				end
			end
		elseif _CheckType == "achievement" then
			if GameTooltip:IsShown() and IsModifiedClick("COMPAREITEMS") then
				if not inCompare then
					inCompare = true

					-- find correct side
					local rightDist = 0;
					local leftPos = GameTooltip:GetLeft();
					local rightPos = GameTooltip:GetRight();
					if ( not rightPos ) then
						rightPos = 0;
					end
					if ( not leftPos ) then
						leftPos = 0;
					end

					rightDist = GetScreenWidth() - rightPos;

					if (leftPos and (rightDist < leftPos)) then
						GameTooltip.shoppingTooltips[1]:SetOwner(GameTooltip, "ANCHOR_NONE")
						GameTooltip.shoppingTooltips[1]:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT")
					else
						GameTooltip.shoppingTooltips[1]:SetOwner(GameTooltip, "ANCHOR_NONE")
						GameTooltip.shoppingTooltips[1]:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT")
					end

					GameTooltip.shoppingTooltips[1]:SetHyperlink(_CheckAchievement)
					GameTooltip.shoppingTooltips[1]:Show()
				end
			elseif inCompare then
				inCompare = false
				if ( GameTooltip.shoppingTooltips ) then
					for _, frame in pairs(GameTooltip.shoppingTooltips) do
						frame:Hide();
					end
				end
			end
		end
	end
end