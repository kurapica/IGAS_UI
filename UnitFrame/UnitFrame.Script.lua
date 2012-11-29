-----------------------------------------
-- Script for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.UnitFrame"

_LockMode = true

Toggle = {
	Message = L"Lock Unit Frame",
	Get = function()
		return _LockMode
	end,
	Set = function (value)
		_LockMode = value

		if not _LockMode then
			for _, frm in ipairs(arUnit) do
				if frm ~= frmPlayer then
					frm:UnregisterUnitWatch()
				end
			end
			IFMovable._ModeOn(_IGASUI_UNITFRAME_GROUP)
			IFResizable._ModeOn(_IGASUI_UNITFRAME_GROUP)
		else
			IFMovable._ModeOff(_IGASUI_UNITFRAME_GROUP)
			IFResizable._ModeOff(_IGASUI_UNITFRAME_GROUP)
			for _, frm in ipairs(arUnit) do
				if frm ~= frmPlayer then
					frm:RegisterUnitWatch()
				end
			end
		end

		Toggle.Update()
	end,
	Update = function() end,
}

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
	if option and (option:lower() == "uf" or option:lower() == "unitframe") then
		if InCombatLockdown() then return end

		info = info and info:lower()

		if info == "unlock" then
			Toggle.Set(true)
		elseif info == "lock" then
			Toggle.Set(false)
		else
			Log(2, "/iu uf unlock - unlock the unit frames.")
			Log(2, "/iu uf lock - lock the unit frames.")
		end

		return true
	end
end

function HideBlzUnitFrame(self)
	self:UnregisterAllEvents()
	self:Hide()
end

function OnEnable(self)
	HideBlzUnitFrame(_G.PlayerFrame)
	HideBlzUnitFrame(_G.PetFrame)
	HideBlzUnitFrame(_G.PartyMemberFrame1)
	HideBlzUnitFrame(_G.PartyMemberFrame2)
	HideBlzUnitFrame(_G.PartyMemberFrame3)
	HideBlzUnitFrame(_G.PartyMemberFrame4)
	HideBlzUnitFrame(_G.TargetFrame)
	HideBlzUnitFrame(_G.FocusFrame)
	HideBlzUnitFrame(_G.RuneFrame)
	HideBlzUnitFrame(_G.CastingBarFrame)
	HideBlzUnitFrame(_G.Boss1TargetFrame)
	HideBlzUnitFrame(_G.Boss2TargetFrame)
	HideBlzUnitFrame(_G.Boss3TargetFrame)
	HideBlzUnitFrame(_G.Boss4TargetFrame)
	HideBlzUnitFrame(_G.Boss5TargetFrame)

	_M:SecureHook("ShowPartyFrame")
end

function ShowPartyFrame()
	IFNoCombatTaskHandler._RegisterNoCombatTask(HidePartyFrame)
end

function OnLoad(self)
	_DB = _Addon._DB.UnitFrame or {}
	_Addon._DB.UnitFrame = _DB

	for i = 1, #arUnit do
		if _DB[i] and _DB[i].Size then
			arUnit[i].Size = _DB[i].Size
		end
		if _DB[i] and _DB[i].Location then
			arUnit[i].Location = _DB[i].Location
		end
	end
end

--------------------
-- Script Handler
--------------------
function arUnit:OnPositionChanged(index)
	_DB[index] = _DB[index] or {}
	_DB[index].Location = arUnit[index].Location
end

function arUnit:OnSizeChanged(index)
	_DB[index] = _DB[index] or {}
	_DB[index].Size = arUnit[index].Size
end

