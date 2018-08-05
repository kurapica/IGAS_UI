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
				mask = Mask("IGAS_UI_ExtraBarMover_Mask", ExtraActionBarFrame)
				mask.AsMove = true
				mask.OnMoveFinished = function()
					_DB.Location = ExtraActionBarFrame.Location
				end
				mask.FrameLevel = mask.FrameLevel + 2

				menu = DropDownList("IGAS_UI_ExtraBarMover_Menu", ExtraActionBarFrame)
				menu.ShowOnCursor = false
				menu.AutoHide = false
				menu.Visible = false
				menu:SetPoint("TOP", mask, "BOTTOM")

				_MenuModifyAnchorPoints = menu:AddMenuButton(L"Modify AnchorPoints")
				_MenuModifyAnchorPoints:ActiveThread("OnClick")
				_MenuModifyAnchorPoints.OnClick = function(self)
					IGAS:ManageAnchorPoint(ExtraActionBarFrame, nil, true)
					_DB.Location = ExtraActionBarFrame.Location
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

	ExtraActionBarFrame:SetParent(UIParent)
	ExtraActionBarFrame:SetMovable(true)
	ExtraActionBarFrame:SetUserPlaced(true)
end

function OnEnable(self)
	if _DB.Location then
		ExtraActionBarFrame.Location = _DB.Location
	end
end
