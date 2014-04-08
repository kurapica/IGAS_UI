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

	local function setProperty(self, prop, value)
		self[prop] = value
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
				for p, v in pairs(set.Property) do
					pcall(setProperty, obj, p, v)
				end
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "ToggleState" {
		Set = function(self, value)
			if value ~= self.ToggleState then
				if value then
					_DB.HideUnit[self.OldUnit] = nil

					self.Unit = self.OldUnit
					self.OldUnit = nil
				else
					_DB.HideUnit[self.Unit] = true

					self.OldUnit = self.Unit
					self.Unit = nil

					if IFToggleable._IsModeOn(_IGASUI_UNITFRAME_GROUP) then
						self.Visible = true
					end
				end
			end
		end,
		Get = function(self)
			return not self.OldUnit
		end,
		Type = Boolean,
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

		self.Panel.VSpacing = Config.PANEL_VSPACING or 0
		self.Panel.HSpacing = Config.PANEL_HSPACING or 0

		self.IFMovable = true
		self.IFResizable = true
		self.IFToggleable = true

		arUnit:Insert(self)
	end
endclass "iUnitFrame"
