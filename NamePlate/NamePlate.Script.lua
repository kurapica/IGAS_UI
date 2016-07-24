-----------------------------------------
-- Script for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

local _ClassPowerBar
local _RuneBar
local _StaggerBar
local _TotemBar
local _BarSize = 6
local _PlayerNamePlate

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	if _G.NamePlateDriverFrame then
		_G.NamePlateDriverFrame:UnregisterAllEvents()

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

		_G.InterfaceOptionsNamesPanelUnitNameplatesMakeLarger.setFunc = function() end
	end

	self:RegisterEvent("NAME_PLATE_CREATED")
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
end

function NAME_PLATE_CREATED(self, base)
	base.NamePlateMask = iNamePlateUnitFrame("iNamePlateMask", base)
end

function NAME_PLATE_UNIT_ADDED(self, unit)
	local base = C_NamePlate.GetNamePlateForUnit(unit)
	if UnitIsUnit("player", unit) then unit = "player" end

	base.NamePlateMask.Unit = unit

	if unit == "player" then InstallClassPower(base.NamePlateMask) end

	base.NamePlateMask:UpdateElements()
end

function NAME_PLATE_UNIT_REMOVED(self, unit)
	local base = C_NamePlate.GetNamePlateForUnit(unit)
	UninstallClassPower(base.NamePlateMask)
	base.NamePlateMask.Unit = nil
end

function InstallClassPower(self)
	if _PlayerNamePlate == self then return end
	if _PlayerNamePlate then UninstallClassPower(_PlayerNamePlate) end
	_PlayerNamePlate = self

	-- Common class power
	_ClassPowerBar = _ClassPowerBar or iClassPower("IGAS_UI_NamePlate_ClassPowerBar")
	self:AddElement(_ClassPowerBar, "south", _BarSize, "px")
	_ClassPowerBar.Unit = "player"

	-- Totem bar
	_TotemBar = _TotemBar or TotemBar("IGAS_UI_NamePlate_TotemBar")
	self:AddElement(_TotemBar)
	_TotemBar:SetPoint("TOP", self, "BOTTOM", 0, -14)
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
end

function UninstallClassPower(self)
	if _PlayerNamePlate ~= self then return end
	_PlayerNamePlate = nil

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
end