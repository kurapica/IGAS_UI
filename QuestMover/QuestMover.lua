IGAS:NewAddon "IGAS_UI.QuestMover"

local locked = true
local mask
local menu

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
				menu:Hide()
				Task.NoCombatCall(RefreshMiniButtonPos)
			end
		elseif _G["ObjectiveTrackerFrame"] then
			if not mask then
				mask = Mask("IGAS_UI_ObjectiveTracker_Mask", ObjectiveTrackerFrame)
				mask.AsMove = true
				mask.AsResize = true
				mask.OnMoveFinished = function()
					if not _DB.ENABLE then
						_DB.ENABLE = true
						ObjectiveTrackerFrame:SetMovable(true)
						ObjectiveTrackerFrame:SetUserPlaced(true)
					end
					_DB.Location = ObjectiveTrackerFrame.Location
					Task.NoCombatCall(RefreshMiniButtonPos)
				end
				mask.OnResizeFinished = function()
					if not _DB.ENABLE then
						_DB.ENABLE = true
						ObjectiveTrackerFrame:SetMovable(true)
						ObjectiveTrackerFrame:SetUserPlaced(true)
					end
					_DB.Location = ObjectiveTrackerFrame.Location
					_DB.Size = ObjectiveTrackerFrame.Size
				end
				menu = DropDownList("IGAS_UI_ObjectiveTracker_Menu", ObjectiveTrackerFrame)
				menu.ShowOnCursor = false
				menu.AutoHide = false
				menu.Visible = false
				menu:SetPoint("TOP", mask, "BOTTOM")

				_MenuModifyAnchorPoints = menu:AddMenuButton(L"Modify AnchorPoints")
				_MenuModifyAnchorPoints:ActiveThread("OnClick")
				_MenuModifyAnchorPoints.OnClick = function(self)
					if not _DB.ENABLE then
						_DB.ENABLE = true
						ObjectiveTrackerFrame:SetMovable(true)
						ObjectiveTrackerFrame:SetUserPlaced(true)
					end

					IGAS:ManageAnchorPoint(ObjectiveTrackerFrame, nil, true)

					_DB.Location = ObjectiveTrackerFrame.Location
					Task.NoCombatCall(RefreshMiniButtonPos)
				end
			end

			mask:Show()
			menu:Show()
		end

		Toggle.Update()
	end,
	Update = function() end,
}

function OnLoad(self)
	_DB = _Addon._DB.QuestMover or {}
	_Addon._DB.QuestMover = _DB

	if _DB.ENABLE then
		if ObjectiveTrackerFrame then
			ObjectiveTrackerFrame:SetMovable(true)
			ObjectiveTrackerFrame:SetUserPlaced(true)
		end
	end
end

function OnEnable(self)
	if _DB.Location then
		ObjectiveTrackerFrame.Location = _DB.Location
	end

	if _DB.Size then
		ObjectiveTrackerFrame.Size = _DB.Size
	end

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

-- Choose rewards
TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN = _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN

GameTooltip = _G.GameTooltip

QuestFrameRewardPanel = IGAS.QuestFrameRewardPanel
QuestFrameRewardPanel:ActiveThread("OnShow")
QuestFrameRewardPanel.OnShow = QuestFrameRewardPanel.OnShow + function()
	Task.Delay(0.1)

	for i = 1, GetNumQuestChoices() do
		local ft = IGAS["QuestInfoRewardsFrameQuestInfoItem"..i].WarnTrans
		if not ft then
			ft = Texture("WarnTrans", IGAS["QuestInfoRewardsFrameQuestInfoItem"..i])
			ft:SetPoint("TOPRIGHT", 0, 0)
			ft:SetSize(24, 24)
			ft.TexturePath = [[Interface\Addons\IGAS_UI\Resource\HelpIcon-ReportAbuse.blp]]
		end
		ft.Visible = false

		GameTooltip:SetOwner(UIParent,"ANCHOR_TOPRIGHT")
		GameTooltip:SetQuestItem("choice", i)
		local _, link = GameTooltip:GetItem()
		GameTooltip:Hide()

		if link then
			GameTooltip:SetOwner(UIParent,"ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(link)

			local j = 1
			local t = _G["GameTooltipTextLeft"..j]

			while t and t:IsShown() do
				if t:GetText() == TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN then
					ft.Visible = true
					break
				end

				j = j + 1
				t = _G["GameTooltipTextLeft"..j]
			end
			GameTooltip:Hide()
		end
	end
end

QuestFrameRewardPanel.OnHide = QuestFrameRewardPanel.OnHide + function()
	local i = 1

	while _G["QuestInfoRewardsFrameQuestInfoItem"..i] do
		if IGAS["QuestInfoRewardsFrameQuestInfoItem"..i].WarnTrans then
			IGAS["QuestInfoRewardsFrameQuestInfoItem"..i].WarnTrans.Visible = false
		end

		i = i + 1
	end
end