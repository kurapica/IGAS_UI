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
			if _DB.AutoFade then
				ObjectiveTrackerFrame:OnEnter()
			else
				ObjectiveTrackerFrame.Alpha = 1
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

				_MenuAutoQuest = menu:AddMenuButton(L"Auto Quest")
				_MenuAutoQuest.IsCheckButton = true
				_MenuAutoQuest.OnCheckChanged = function(self)
					_AutoQuest.ToggleOn = self.Checked
				end

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

			ObjectiveTrackerFrame.Alpha = 1
			_MenuAutoQuest.Checked = _AutoQuest.ToggleOn

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

	_AutoQuest = _Addon._DBChar.AutoQuest or {
		ToggleOn = false,
		AbandonQuest = {},
	}
	_Addon._DBChar.AutoQuest = _AutoQuest

	if _DB.ENABLE then
		if ObjectiveTrackerFrame then
			ObjectiveTrackerFrame:SetMovable(true)
			ObjectiveTrackerFrame:SetUserPlaced(true)
		end
	end

	self:RegisterEvent("BAG_NEW_ITEMS_UPDATED")

	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_ACCEPTED")

	self:SecureHook("AbandonQuest")
end

function OnEnable(self)
	if _DB.Location then
		ObjectiveTrackerFrame.Location = _DB.Location
	end

	if _DB.Size then
		ObjectiveTrackerFrame.Size = _DB.Size
	end

	if _DB.AutoFade then
		ObjectiveTrackerFrame:OnEnter()
	end

	Task.NoCombatCall(RefreshMiniButtonPos)
end

function ObjectiveTrackerFrame:OnEnter()
	if _DB.AutoFade then
		self.Alpha = 1
		self.StartTime = GetTime()

		if not self.ThreadStart then
			Task.ThreadCall(function()
				self.ThreadStart = true

				local alpha = 0

				while alpha < 1 and _DB.AutoFade do
					self.Alpha = 1-alpha

					if self:IsMouseOver() then
						self.StartTime = GetTime()
						alpha = 0
					else
						alpha = (GetTime() - self.StartTime) / 3.0
					end

					Task.Next()
				end

				self.Alpha = _DB.AutoFade and 0 or 1
				self.ThreadStart = false
			end)
		end
	end
end

IGAS:GetWrapper(_G.ObjectiveTrackerBlocksFrame.QuestHeader).OnMouseUp = function(self, button)
	if button == "RightButton" then
		_DB.AutoFade = not _DB.AutoFade
		if _DB.AutoFade then
			ObjectiveTrackerFrame:OnEnter()
		else
			ObjectiveTrackerFrame.Alpha = 1
		end
	end
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

-- Auto Quest
local _startScan = false
function BAG_NEW_ITEMS_UPDATED(self)
	if not _startScan and _AutoQuest.ToggleOn then
		_startScan = true
		Task.NoCombatCall(function()
			_startScan = false

			for bag = 0, NUM_BAG_FRAMES do
				for slot = 1, GetContainerNumSlots(bag) do
					if C_NewItems.IsNewItem(bag, slot) then
						local isQuest, questId, isActive = GetContainerItemQuestInfo(bag, slot)

						if questId and (not isActive) then
							UseContainerItem(bag,slot)
						end
					end
				end
			end
		end)
	end
end

function QUEST_ACCEPTED(self, questIndex)
	questIndex = GetQuestLogTitle(questIndex)
	if questIndex then _AutoQuest.AbandonQuest[questIndex] = nil end
end

function GOSSIP_SHOW(self)
	if not _AutoQuest.ToggleOn then return end

	if GetNumGossipActiveQuests() > 0 then
		if SelectActiveQuest(1, GetGossipActiveQuests()) then return end
	end

	if GetNumGossipAvailableQuests() > 0 then
		if SelectAvailableQuest(1, GetGossipAvailableQuests()) then return end
	end
end

function QUEST_DETAIL(self)
	if _AutoQuest.ToggleOn and not _AutoQuest.AbandonQuest[GetTitleText()] then
		AcceptQuest()
	end
end

function SelectActiveQuest(index, name, level, isTrivial, isFinished, ...)
	if not name then return false end

	if isFinished then
		SelectGossipActiveQuest(index)
		return true
	end

	return SelectActiveQuest(index + 1, ...)
end

function SelectAvailableQuest(index, name, level, isTrivial, isDaily, isRepeatable, ...)
	if not name then return false end

	if not _AutoQuest.AbandonQuest[name] then
		SelectGossipAvailableQuest(index)
	end

	if select('#', ...) == 0 then
		return true
	else
		return SelectAvailableQuest(index + 1, ...)
	end
end

-- Blz Frames hook
QuestFrameAcceptButton:ActiveThread("OnShow")
function QuestFrameAcceptButton:OnShow()
	if not _AutoQuest.ToggleOn then return end

	Task.Delay(0.2)

	if QuestFrameAcceptButton.Visible and QuestFrameAcceptButton.Enabled then
		local questText = GetTitleText()

		if questText and _AutoQuest.AbandonQuest[questText] then return end

		if ( QuestFlagsPVP() ) then
			return
		else
			if QuestGetAutoAccept() and QuestIsFromAreaTrigger() then
				CloseQuest()
			else
				AcceptQuest()
			end
		end
	end
end

QuestFrameCompleteButton:ActiveThread("OnShow")
function QuestFrameCompleteButton:OnShow()
	if not _AutoQuest.ToggleOn then return end

	Task.Delay(0.2)

	if QuestFrameCompleteButton.Enabled then
		CompleteQuest()
	end
end

function AbandonQuest()
	local questName = GetAbandonQuestName()
	if questName then _AutoQuest.AbandonQuest[questName] = true end
end

-- Choose rewards
TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN = _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN

GameTooltip = _G.GameTooltip

QuestFrameRewardPanel = IGAS.QuestFrameRewardPanel
QuestFrameRewardPanel:ActiveThread("OnShow")
QuestFrameRewardPanel.OnShow = QuestFrameRewardPanel.OnShow + function()
	Task.Delay(0.1)

	local chooseItem = nil
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

		if ft.Visible and not chooseItem then
			chooseItem = i
			QuestInfoItem_OnClick(_G["QuestInfoRewardsFrameQuestInfoItem"..i])
			if GetNumQuestChoices() > 1 then
				return
			end
		end
	end

	if not chooseItem and _G.QuestInfoFrame.itemChoice == 0 and GetNumQuestChoices() > 0 then
		local index, maxV = 0, 0

		for i = 1, GetNumQuestChoices() do
			GameTooltip:SetOwner(UIParent)
			GameTooltip:SetAnchorType("ANCHOR_TOPRIGHT")

			GameTooltip:SetQuestItem("choice", i)

			if GameTooltip:GetMoney() > maxV then
				maxV = GameTooltip:GetMoney()
				index = i
			end
		end

		if index > 0 then
			QuestInfoItem_OnClick(_G["QuestInfoRewardsFrameQuestInfoItem"..index])
		end

		if GetNumQuestChoices() > 1 then
			return
		end
	end

	if not _AutoQuest.ToggleOn then return end

	local money = GetQuestMoneyToGet()
	if ( money and money > 0 ) then
		return
	else
		GetQuestReward(_G.QuestInfoFrame.itemChoice)
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