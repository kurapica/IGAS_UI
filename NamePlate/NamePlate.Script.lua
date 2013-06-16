-----------------------------------------
-- Script for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

_Interval = 0.2
_MaxNamePlate = 0

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	
end

function OnEnable(self)
	_Scan.Visible = true
end

------------------------------------------------------
-- Widget Script Handler
------------------------------------------------------
function _Scan:OnUpdate(elapsed)
	self.__OnUpdateTimer = (self.__OnUpdateTimer or 0) + elapsed

	if self.__OnUpdateTimer > _Interval then
		self.__OnUpdateTimer = 0

		if GetCVarBool("nameplateShowEnemies") == 1 or GetCVarBool("nameplateShowFriends") == 1 then
			if _MaxNamePlate == 0 then
				return CheckWorldFrame()
			else
				return CheckG()
			end
		end
	end
end

------------------------------------------------------
-- Helper Function
------------------------------------------------------
function CheckWorldFrame()
	local name, index
	for k, v in ipairs{_G.WorldFrame:GetChildren()} do
		name = v:GetName()

		if name and name:match("NamePlate%d+") then
			index = tonumber(name:match("NamePlate(%d+)"))

			if index then
				BuildNamePlate(_G["NamePlate" .. index])

				if index > _MaxNamePlate then
					_MaxNamePlate = index
				end
			end
		end
	end
end

function CheckG()
	-- Keep it simple
	if rawget(_G, "NamePlate" .. (_MaxNamePlate + 1)) then
		_MaxNamePlate = _MaxNamePlate + 1

		BuildNamePlate(_G["NamePlate" .. _MaxNamePlate])
	end
end

function BuildNamePlate(self)
	NamePlateMask("NamePlateMask", self)
end