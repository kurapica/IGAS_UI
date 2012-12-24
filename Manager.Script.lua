-----------------------------------------
-- Script for Manager
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Manager"

NUM_RAID_ICONS = _G.NUM_RAID_ICONS

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	_DBChar = _Addon._DBChar.Manager or {}

	_Addon._DBChar.Manager = _DBChar

	if _DBChar.Position then
		manager.Position = _DBChar.Position
	end
end

--------------------
-- Script Handler
--------------------
function manager:OnPositionChanged()
	_DBChar.Position = manager.Position
end
