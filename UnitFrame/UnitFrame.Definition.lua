IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Definition for UnitFrame
--==========================

_IGASUI_RAIDPANEL_GROUP = "IRaidPanel"	-- Same as the raidPanel, no raidpanel no settings.
_IGASUI_UNITFRAME_GROUP = "IUnitFrame"

class "iUnitFrame"
	inherit "UnitFrame"
	extend "IFMovable" "IFResizable" "IFToggleable"

	if Config.ENABLE_HOVER_SPELLCAST then extend "IFSpellHandler" end

	DEFAULT_SIZE = Size(200, 48)
	MIN_SIZE = Size(48, 4)

	local function setProperty(self, prop, value)
		self[prop] = value
	end

	-- Manager Frame
	_ManagerFrame = SecureFrame("IGASUI_IUnitFrame_Manager", IGAS.UIParent, "SecureHandlerStateTemplate")
	_ManagerFrame.Visible = false

	-- Init manger frame's enviroment
	Task.NoCombatCall(function ()
		_ManagerFrame:Execute[[
			Manager = self

			State = newtable()
		]]
	end)

	local function RegisterAutoHide(self, cond)
		local unit = self.Unit

		self.AutoHideState = "autohide" .. unit

		_ManagerFrame:SetFrameRef("StateButton", self)
		_ManagerFrame:Execute(([[
			State["%s"] = Manager:GetFrameRef("StateButton")
		]]):format(self.AutoHideState))

		_ManagerFrame:RegisterStateDriver(self.AutoHideState, cond)
		_ManagerFrame:SetAttribute("_onstate-" .. self.AutoHideState, ([[
			local uf = State["%s"]
			if newstate == "hide" then
				UnregisterUnitWatch(uf)
				uf:Hide()
			else
				local unit = uf:GetAttribute("unit")

				if unit and unit ~= "player" then
					RegisterUnitWatch(uf)
				elseif unit then
					uf:Show()
				end
			end
		]]):format(self.AutoHideState))
		_ManagerFrame:SetAttribute("state-" .. self.AutoHideState, nil)
	end

	local function UnregisterAutoHide(self)
		if self.AutoHideState then
			_ManagerFrame:UnregisterStateDriver(self.AutoHideState)
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function ApplyConfig(self, config)
		if type(config) ~= "table" then return end

		if type(config.Init) == "function" then
			pcall(config.Init, self)
		end

		for _, name in ipairs(config) do
			local set = type(name) == "string" and Config.Elements[name] or name
			local obj

			-- Create element
			if set.Name then
				self:AddElement(set.Name, set.Type, set.Direction, set.Size, set.Unit)
				obj = self:GetElement(set.Name)
			else
				self:AddElement(set.Type, set.Direction, set.Size, set.Unit)
				obj = self:GetElement(set.Type)
			end

			-- Apply init
			if type(set.Init) == "function" then
				pcall(set.Init, obj)
			end

			-- Apply Size
			if set.Size then
				pcall(setProperty, obj, "Size", set.Size)
			end

			-- Apply Location
			if not set.Direction and set.Location then
				obj.Location = set.Location
			end

			-- Apply Property
			if set.Property then
				pcall(obj, set.Property)
			end
		end
	end

	function RefreshForAutoHide(self)
		if self.AutoHideState then
			_ManagerFrame:SetAttribute("state-" .. self.AutoHideState, nil)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "ToggleState" {
		Handler = function (self, value)
			if value then
				_DB.HideUnit[self.OldUnit] = nil

				self.Unit = self.OldUnit
				self.OldUnit = nil
			else
				UnregisterAutoHide(self)
				_DB.HideUnit[self.Unit] = true
				self.OldUnit = self.Unit
				self.Unit = nil
			end
			if IFToggleable._IsModeOn(_IGASUI_UNITFRAME_GROUP) then
				self.Visible = true
			end
		end,
		Type = Boolean,
		Default = true,
		Event = "OnAutoHideChanged"
	}

	property "AutoHideCondition" {
		Set = function(self, value)
			Task.NoCombatCall(function()
				if value and next(value) then
					local cond = ""
					for k in pairs(value) do
						cond = cond .. k .. "hide;"
					end
					cond = cond .. "show;"
					RegisterAutoHide(self, cond)
				else
					UnregisterAutoHide(self)
					if self.ToggleState then
						local unit = self.Unit
						if unit == "player" then
							self:Show()
						else
							self:RegisterUnitWatch()
						end
					end
				end
			end)
		end,
	}

	property "IFSpellHandlerGroup" {
		Set = false,
		Default = _IGASUI_RAIDPANEL_GROUP,
	}

	property "IFMovingGroup" {
		Set = false,
		Default = _IGASUI_UNITFRAME_GROUP,
	}

	property "IFResizingGroup" {
		Set = false,
		Default = _IGASUI_UNITFRAME_GROUP,
	}

	property "IFTogglingGroup" {
		Set = false,
		Default = _IGASUI_UNITFRAME_GROUP,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iUnitFrame(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Size = DEFAULT_SIZE
		self.MinResize = MIN_SIZE

		self.Panel.VSpacing = Config.PANEL_VSPACING or 0
		self.Panel.HSpacing = Config.PANEL_HSPACING or 0

		self.IFMovable = true
		self.IFResizable = true
		self.IFToggleable = true

		arUnit:Insert(self)
	end
endclass "iUnitFrame"
