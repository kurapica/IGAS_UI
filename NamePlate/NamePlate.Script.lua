-----------------------------------------
-- Script for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

local _BaseNamePlateWidth = 110
local _BaseNamePlateHeight = 45

local _ClassMainPowerBar
local _ClassMainPowerText
local _ClassPowerBar
local _RuneBar
local _StaggerBar
local _TotemBar

local _BarSize = Config.BAR_SIZE

local _PlayerNamePlate

local _VerticalScale
local _HorizontalScale

local _ArrayMask = System.Collections.List()

_QuestLog = {}
_WorldQuest = {}

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	if _G.NamePlateDriverFrame then
		-- _G.NamePlateDriverFrame:UnregisterAllEvents()

		_G.ClassNameplateBarRogueDruidFrame:UnregisterAllEvents()
		_G.ClassNameplateBarWarlockFrame:UnregisterAllEvents()
		_G.ClassNameplateBarPaladinFrame:UnregisterAllEvents()
		_G.ClassNameplateBarWindwalkerMonkFrame:UnregisterAllEvents()
		_G.ClassNameplateBrewmasterBarFrame:UnregisterAllEvents()
		_G.ClassNameplateBarMageFrame:UnregisterAllEvents()
		_G.DeathKnightResourceOverlayFrame:UnregisterAllEvents()

		_G.ClassNameplateManaBarFrame:UnregisterAllEvents()
		_G.NamePlateTargetResourceFrame:UnregisterAllEvents()
		_G.NamePlatePlayerResourceFrame:UnregisterAllEvents()

		self:SecureHook(_G.NamePlateDriverFrame, "UpdateNamePlateOptions", UpdateNamePlateOptions)
	end

	-- self:RegisterEvent("NAME_PLATE_CREATED")
	self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateCreated", NAME_PLATE_CREATED)
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_REMOVED")
	self:RegisterEvent("QUEST_LOG_UPDATE")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")

	SetCVar("showQuestTrackingTooltips", "1")
end

function OnEnable(self)
	UpdateNamePlateOptions()

	for _, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(MapUtil.GetDisplayableMapForPlayer())) do
		if task.inProgress then
			local name = C_TaskQuest.GetQuestInfoByQuestID(task.questId)
			if name then
				_WorldQuest[name] = task.questId
			end
		end
	end
end

function NAME_PLATE_CREATED(self, base)
	base.UnitFrame:Hide()
	base.UnitFrame:HookScript("OnShow", base.UnitFrame.Hide)

	base.NamePlateMask = iNamePlateUnitFrame("iNamePlateMask", base)
	base.NamePlateMask:ApplyFrameOptions(_VerticalScale, _HorizontalScale)
	_ArrayMask:Insert(base.NamePlateMask)
	Debug("NamePlate %d created", #_ArrayMask)
end

function NAME_PLATE_UNIT_ADDED(self, unit)
	local base = C_NamePlate.GetNamePlateForUnit(unit)
	if UnitIsUnit("player", unit) then unit = "player" end

	local mask = base.NamePlateMask
	if mask then
		mask.Unit = unit

		if unit == "player" then InstallClassPower(mask) end

		mask:UpdateElements()
	end
end

function NAME_PLATE_UNIT_REMOVED(self, unit)
	local base = C_NamePlate.GetNamePlateForUnit(unit)
	if base.NamePlateMask then
		UninstallClassPower(base.NamePlateMask)
		base.NamePlateMask.Unit = nil
	end
end

function QUEST_ACCEPTED(self, logid, questId)
	if QuestUtils_IsQuestWorldQuest(questId) then
		local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
		if name then
			_WorldQuest[name] = questId
			Task.NextCall(RefreshAllQuestMark)
		end
	end
end

function QUEST_REMOVED(self, questId)
	local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
	if name then
		_WorldQuest[name] = nil
		Task.NextCall(RefreshAllQuestMark)
	end
end

function QUEST_LOG_UPDATE(self)
	self:UnregisterEvent("QUEST_LOG_UPDATE")

	UpdateQuestLog()
end

function UNIT_QUEST_LOG_CHANGED(self, unit)
	if unit == "player" then
		Task.NextCall(UpdateQuestLog, true)
	end
end

function InstallClassPower(self)
	if _PlayerNamePlate == self then return end
	if _PlayerNamePlate then UninstallClassPower(_PlayerNamePlate) end
	_PlayerNamePlate = self

	self:SuspendLayout()

	-- Main class power
	_ClassMainPowerBar = _ClassMainPowerBar or iPowerBarFrequent("IGAS_UI_NamePlate_MainPowerBar")
	self:InsertElement("iHealthBar", _ClassMainPowerBar, "south", _BarSize * _VerticalScale, "px")
	_ClassMainPowerBar.Unit = "player"
	_ClassMainPowerBar.Visible = true
	_ClassMainPowerBar.FrameStrata = "BACKGROUND"

	local castBar = self:GetElement("iCastBar")
	castBar:ClearAllPoints()
	castBar:SetAllPoints(_ClassMainPowerBar)

	_ClassMainPowerText = _ClassMainPowerText or iPlayerPowerText("IGAS_UI_NamePlate_MainPowerText")
	self:AddElement(_ClassMainPowerText)
	_ClassMainPowerText:SetPoint("TOP", _ClassMainPowerBar)
	_ClassMainPowerText.Unit = "player"
	_ClassMainPowerText.Visible = true

	-- Common class power
	_ClassPowerBar = _ClassPowerBar or iClassPower("IGAS_UI_NamePlate_ClassPowerBar")
	self:AddElement(_ClassPowerBar, "south", _BarSize, "px")
	_ClassPowerBar.Unit = "player"

	-- Totem bar
	_TotemBar = _TotemBar or iTotemBar("IGAS_UI_NamePlate_TotemBar")
	self:AddElement(_TotemBar)
	-- Consider the cast bar
	_TotemBar:SetPoint("TOP", self, "BOTTOM", 0, -(6 + 8 * _VerticalScale))
	_TotemBar.Unit = "player"

	-- Rune bar
	if select(2, UnitClass("player")) == "DEATHKNIGHT" then
		_RuneBar = _RuneBar or iRuneBar("IGAS_UI_NamePlate_RuneBar")
		self:AddElement(_RuneBar, "south", _BarSize, "px")
		_RuneBar.Visible = true
		_RuneBar.Unit = "player"
	end

	-- Stagger bar
	if select(2, UnitClass("player")) == "MONK" then
		_StaggerBar = _StaggerBar or iStaggerBar("IGAS_UI_NamePlate_StaggerBar")
		self:AddElement(_StaggerBar, "south", _BarSize, "px")
		_StaggerBar.Unit = "player"
	end

	self:ResumeLayout()
end

function UninstallClassPower(self)
	if _PlayerNamePlate ~= self then return end
	_PlayerNamePlate = nil

	self:SuspendLayout()

	if _ClassMainPowerBar then
		self:GetElement("iCastBar").Location = Config.Elements[3].Location

		self:RemoveElement(_ClassMainPowerBar, true)
		_ClassMainPowerBar.Unit = nil
		_ClassMainPowerBar:ClearAllPoints()
		_ClassMainPowerBar.Visible = false
	end

	if _ClassMainPowerText then
		self:RemoveElement(_ClassMainPowerText, true)
		_ClassMainPowerText.Unit = nil
		_ClassMainPowerText.Visible = false
	end

	if _ClassPowerBar then
		self:RemoveElement(_ClassPowerBar, true)
		_ClassPowerBar.Unit = nil
		_ClassPowerBar:ClearAllPoints()
	end
	if _RuneBar then
		self:RemoveElement(_RuneBar, true)
		_RuneBar:ClearAllPoints()
		_RuneBar.Visible = false
	end
	if _StaggerBar then
		self:RemoveElement(_StaggerBar, true)
		_StaggerBar.Unit = nil
		_StaggerBar:ClearAllPoints()
	end
	if _TotemBar then
		self:RemoveElement(_TotemBar, true)
		_TotemBar.Unit = nil
		_TotemBar:ClearAllPoints()
	end

	self:ResumeLayout()
end

function UpdateNamePlateOptions()
	_VerticalScale = tonumber(GetCVar("NamePlateVerticalScale")) or 1
	_HorizontalScale = tonumber(GetCVar("NamePlateHorizontalScale")) or 1

	if _VerticalScale < 1 then _VerticalScale = 1 end
	if _HorizontalScale < 1 then _HorizontalScale = 1 end

	local font = NAME_FONT.Font
	font.height = math.min(BASE_NAME_FONT_HEIGHT * _VerticalScale, MAX_NAME_FONT_HEIGHT)
	NAME_FONT.Font = font

	local np = _PlayerNamePlate
	if np then UninstallClassPower(np) end

	_ArrayMask:Each(function(self) IGAS:GetUI(self.Parent).UnitFrame:Hide() end)
	_ArrayMask:Each(iNamePlateUnitFrame.ApplyFrameOptions, _VerticalScale, _HorizontalScale)

	if np then InstallClassPower(np) end
end

function UpdateQuestLog(forceRefresh)
	wipe(_QuestLog)

	for i = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader = GetQuestLogTitle(i)
		if not isHeader then
			_QuestLog[title] = i
		end
	end

	if forceRefresh then
		return RefreshAllQuestMark()
	end
end

function RefreshAllQuestMark()
	_ArrayMask:Each(RefreshQuestMark)
end

function RefreshQuestMark(self)
	local mark = self:GetElement(iQuestMark)
	if mark then mark:OnForceRefresh() end
end