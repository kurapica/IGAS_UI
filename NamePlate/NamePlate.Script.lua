-----------------------------------------
-- Script for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

local _ClassPowerBar
local _RuneBar
local _StaggerBar
local _TotemBar
local _BarSize = 6

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
	if UnitIsUnit("player", unit) then
		unit = "player"
		_ClassPowerBar = _ClassPowerBar or iClassPower("IGAS_UI_NamePlate_ClassPowerBar")
		base.NamePlateMask:AddElement(_ClassPowerBar, "south", _BarSize, "px")

		_TotemBar = _TotemBar or TotemBar("IGAS_UI_NamePlate_TotemBar")
		base.NamePlateMask:AddElement(_TotemBar)
		_TotemBar:SetPoint("TOP", base.NamePlateMask, "BOTTOM", 0, -14)

		if select(2, UnitClass("player")) == "DEATHKNIGHT" then
			_RuneBar = _RuneBar or iRuneBar("IGAS_UI_NamePlate_RuneBar")
			base.NamePlateMask:AddElement(_RuneBar, "south", _BarSize, "px")
			_RuneBar.Visible = true
		end
		if select(2, UnitClass("player")) == "MONK" then
			_StaggerBar = _StaggerBar or iStaggerBar("IGAS_UI_NamePlate_StaggerBar")
			base.NamePlateMask:AddElement(_StaggerBar, "south", _BarSize, "px")
		end
	end
	base.NamePlateMask.Unit = unit
	base.NamePlateMask:UpdateElements()
end

function NAME_PLATE_UNIT_REMOVED(self, unit)
	local base = C_NamePlate.GetNamePlateForUnit(unit)
	base.NamePlateMask.Unit = nil
	if UnitIsUnit("player", unit) then
		if _ClassPowerBar then base.NamePlateMask:RemoveElement(_ClassPowerBar, true) end
		if _RuneBar then base.NamePlateMask:RemoveElement(_RuneBar, true) _RuneBar:ClearAllPoints() _RuneBar.Visible = false end
		if _StaggerBar then base.NamePlateMask:RemoveElement(_StaggerBar, true) _StaggerBar:ClearAllPoints() end
		if _TotemBar then base.NamePlateMask:RemoveElement(_TotemBar, true) _TotemBar:ClearAllPoints() end
	end
end