IGAS:NewAddon "IGAS_UI.QuestMover"

local locked = true
local mask

Toggle = {
	Message = L"Lock Quest Tracker",
	Get = function()
		return locked
	end,
	Set = function (value)
		locked = value

		if locked then
			if mask then
				mask:Hide()
				Task.NoCombatCall(RefreshMiniButtonPos)
			end
		elseif _G["ObjectiveTrackerFrame"] then
			if not mask then
				mask = Mask("IGAS_UI_ObjectiveTracker_Mask", IGAS.ObjectiveTrackerFrame)
				mask.AsMove = true
				mask.OnMoveFinished = function()
					Task.NoCombatCall(RefreshMiniButtonPos)
				end
			end

			mask:Show()
		end

		Toggle.Update()
	end,
	Update = function() end,
}

function OnLoad(self)
	if _G["ObjectiveTrackerFrame"] then
		_G["ObjectiveTrackerFrame"]:SetMovable(true)
		_G["ObjectiveTrackerFrame"]:SetUserPlaced(true)
	end
end

function OnEnable(self)
	Task.NoCombatCall(RefreshMiniButtonPos)
end

function RefreshMiniButtonPos()
	if _G["ObjectiveTrackerFrame"] then
		local header = _G["ObjectiveTrackerFrame"].HeaderMenu
		local btn = header.MinimizeButton
		local title = header.Title
		if _G["ObjectiveTrackerFrame"]:GetRight() <= GetScreenWidth()/2 then
			header:ClearAllPoints()
			header:SetPoint("TOPRIGHT", _G["ObjectiveTrackerFrame"], "TOPLEFT", -10, 0)
			title:ClearAllPoints()
			title:SetPoint("LEFT", btn, "RIGHT", 3, 1)
		else
			header:ClearAllPoints()
			header:SetPoint("TOPRIGHT", 0, 0)
			title:ClearAllPoints()
			title:SetPoint("RIGHT", btn, "LEFT", -3, 1)
		end
	end
end