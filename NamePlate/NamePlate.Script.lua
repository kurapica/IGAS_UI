-----------------------------------------
-- Script for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

_Interval = 0.2
_MaxNamePlate = 0

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
_InChecking_Mode = false

function OnLoad(self)
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:ActiveThread("OnEvent")
end

function OnEnable(self)
	_Scan.Visible = true
end

function PLAYER_TARGET_CHANGED(self)
	if _InChecking_Mode then return end

	_InChecking_Mode = true

	while UnitExists('target') do
		Threading.Sleep(0.1)

		local plate

		for i = 1, #NamePlateArray do
			plate = NamePlateArray[i].Parent

			if plate.Visible and plate.Alpha > 0.9 then
				TargetDebuffPanel.Parent = plate
				TargetDebuffPanel:SetPoint("BOTTOM", plate, "TOP")
				TargetDebuffPanel.Visible = true
				TargetDebuffPanel:Refresh()

				_InChecking_Mode = false

				return
			end
		end
	end

	TargetDebuffPanel.Visible = false
	_InChecking_Mode = false
end

------------------------------------------------------
-- Widget Script Handler
------------------------------------------------------
function _Scan:OnUpdate(elapsed)
	self.__OnUpdateTimer = (self.__OnUpdateTimer or 0) + elapsed

	if self.__OnUpdateTimer > _Interval then
		self.__OnUpdateTimer = 0

		if GetCVarBool("nameplateShowEnemies") or GetCVarBool("nameplateShowFriends") then
			if _MaxNamePlate == 0 then
				return CheckWorldFrame()
			else
				return CheckG()
			end
		end
	end
end

function TargetDebuffPanel:OnHide()
	if UnitExists('target') then
		_M:ThreadCall(PLAYER_TARGET_CHANGED)
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
	while rawget(_G, "NamePlate" .. (_MaxNamePlate + 1)) do
		_MaxNamePlate = _MaxNamePlate + 1

		BuildNamePlate(_G["NamePlate" .. _MaxNamePlate])
	end
end

function BuildNamePlate(self)
	NamePlateMask("NamePlateMask", self)
end