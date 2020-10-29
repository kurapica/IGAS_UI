IGAS:NewAddon "IGAS_UI.ExtraBarMover"

local locked = true
local mask
local menu

Toggle = {
	Message = L"Lock Extra Action Bar",
	Get = function()
		return locked
	end,
	Set = function (value)
		locked = value

		if locked then
			if mask then
				mask:Hide()
				menu:Hide()
			end
		else
			if not mask then
				mask = Mask("IGAS_UI_ExtraBarMover_Mask", ZoneAbilityFrame)
				mask.AsMove = true
				mask.OnMoveFinished = function()
					_DB.Location = ZoneAbilityFrame.Location
				end
				mask.FrameLevel = mask.FrameLevel + 2

				menu = DropDownList("IGAS_UI_ExtraBarMover_Menu", ZoneAbilityFrame)
				menu.ShowOnCursor = false
				menu.AutoHide = false
				menu.Visible = false
				menu:SetPoint("TOP", mask, "BOTTOM")

				_MenuModifyAnchorPoints = menu:AddMenuButton(L"Modify AnchorPoints")
				_MenuModifyAnchorPoints:ActiveThread("OnClick")
				_MenuModifyAnchorPoints.OnClick = function(self)
					IGAS:ManageAnchorPoint(ZoneAbilityFrame, nil, true)
					_DB.Location = ZoneAbilityFrame.Location
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
	_DB = _Addon._DB.ExtraBarMover or {}
	_Addon._DB.ExtraBarMover = _DB

	ZoneAbilityFrame:SetParent(UIParent)
	ZoneAbilityFrame:SetMovable(true)
	ZoneAbilityFrame:SetUserPlaced(true)
end

function OnEnable(self)
	if _DB.Location then
		ZoneAbilityFrame.Location = _DB.Location
	end
end
