IGAS:NewAddon "IGAS_UI.MicroMenu"

local _MDL = _Addon:GetModule("ActionBar")
if not _MDL then return end

local locked = true
local mask
local menu
local _DB
local _MicroMenus = System.Reflector.Clone(_G.MICRO_BUTTONS)

Toggle = {
	Message = L"Lock Micro Menu",
	Get = function()
		return locked
	end,
	Set = function (value)
		locked = value

		if locked then
			if mask then mask:Hide() menu:Hide() end
			if _DB.KeepHide then
				_MicroMenuPanel.Visible = false
			elseif _DB.AutoFade then
				CharacterMicroButton:OnEnter()
			end
		elseif _MDL._HiddenMainMenuBar then
			if not mask then
				mask = Mask("IGAS_UI_MicroMenu_Mask", _MicroMenuPanel)
				mask.AsMove = true
				mask.OnMoveFinished = function()
					_DB.Location = _MicroMenuPanel.Location
				end
				menu = DropDownList("IGAS_UI_MicroMenu_Menu", _MicroMenuPanel)
				menu.ShowOnCursor = false
				menu.AutoHide = false
				menu.Visible = false
				menu:SetPoint("TOP", mask, "BOTTOM")

				_MenuAutoHide = menu:AddMenuButton(L"Auto Hide")
				_MenuAutoHide.IsCheckButton = true
				_MenuAutoHide.OnCheckChanged = function(self)
					_DB.KeepHide = self.Checked
				end

				_MenuAutoFade = menu:AddMenuButton(L"Auto Fade Out")
				_MenuAutoFade.IsCheckButton = true
				_MenuAutoFade.OnCheckChanged = function(self)
					_DB.AutoFade = self.Checked
				end

				_MenuModifyAnchorPoints = menu:AddMenuButton(L"Modify AnchorPoints")
				_MenuModifyAnchorPoints:ActiveThread("OnClick")
				_MenuModifyAnchorPoints.OnClick = function(self)
					IGAS:ManageAnchorPoint(_MicroMenuPanel, nil, true)
					_DB.Location = _MicroMenuPanel.Location
				end
			end

			_MenuAutoHide.Checked = _DB.KeepHide
			_MenuAutoFade.Checked = _DB.AutoFade
			mask:Show()
			menu:Show()
			_MicroMenuPanel.Alpha = 1
			_MicroMenuPanel.Visible = true
		end

		Toggle.Update()
	end,
	Update = function() end,
}

_OrgParent = CharacterMicroButton.Parent
_OrgLocation = CharacterMicroButton.Location

_MicroMenuPanel = Frame("IGAS_UI_MicroMenuPanel", _OrgParent)
_MicroMenuPanel.Location = _OrgLocation
_MicroMenuPanel.Height = CharacterMicroButton.Height
_MicroMenuPanel.Width = CharacterMicroButton.Width * #_G.MICRO_BUTTONS

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint("TOPLEFT", _MicroMenuPanel)

local function OnEnter(self)
	if _DB.AutoFade then
		_MicroMenuPanel.Alpha = 1
		_MicroMenuPanel.StartTime = GetTime()

		if not _MicroMenuPanel.ThreadStart then
			Task.ThreadCall(function()
				_MicroMenuPanel.ThreadStart = true

				local alpha = 0

				while alpha < 1 do
					_MicroMenuPanel.Alpha = 1-alpha

					if _MicroMenuPanel:IsMouseOver() then
						_MicroMenuPanel.StartTime = GetTime()
						alpha = 0
					else
						alpha = (GetTime() - _MicroMenuPanel.StartTime) / 3.0
					end

					Task.Next()
				end

				_MicroMenuPanel.Alpha = 0
				_MicroMenuPanel.ThreadStart = false
			end)
		end
	end
end

for i, btn in ipairs(_MicroMenus) do
	btn = IGAS[btn]
	btn.Parent = _MicroMenuPanel

	btn.OnEnter = OnEnter
end

_M:SecureHook(_MDL, "UpdateBlzMainMenuBar")
_M:SecureHook("MoveMicroButtons")

function UpdateBlzMainMenuBar()
	if not _DB then
		_DB = _Addon._DB.MicroMenu or { }
		_Addon._DB.MicroMenu = _DB
	end

	if _MDL._HiddenMainMenuBar then
		_MicroMenuPanel.Parent = UIParent

		if _DB.Location then
			_MicroMenuPanel.Location = _DB.Location
		else
			_MicroMenuPanel:ClearAllPoints()
			_MicroMenuPanel:SetPoint("BOTTOMLEFT")
		end

		if _DB.KeepHide then
			_MicroMenuPanel.Visible = false
		elseif _DB.AutoFade then
			CharacterMicroButton:OnEnter()
		end
	else
		_MicroMenuPanel.Alpha = 1
		_MicroMenuPanel.Visible = true
		_MicroMenuPanel.Parent = _OrgParent
		_MicroMenuPanel.Location = _OrgLocation
	end
end

function ResetPos()
	UpdateMicroButtonsParent(_MicroMenuPanel)
	CharacterMicroButton:ClearAllPoints()

	CharacterMicroButton:SetPoint("TOPLEFT", _MicroMenuPanel)
	_G.MoveMicroButtons("TOPLEFT", _MicroMenuPanel, "TOPLEFT", 0, 0, false)
end

function MoveMicroButtons(point, name)
	if name == _MicroMenuPanel then return end
	Task.NoCombatCall(function()
		if name:GetName() == "MicroButtonAndBagsBar" then
			ResetPos()
		else
			IGAS:GetWrapper(name).OnHide = ResetPos
		end
	end)
end