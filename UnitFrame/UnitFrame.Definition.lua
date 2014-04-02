IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Definition for UnitFrame
--==========================

_IGASUI_RAIDPANEL_GROUP = "IRaidPanel"	-- Same as the raidPanel, no raidpanel no settings.
_IGASUI_UNITFRAME_GROUP = "IUnitFrame"

class "iUnitFrame"
	inherit "UnitFrame"
	extend "IFMovable" "IFResizable" "IFToggleable"

	if UnitFrame_Config.ENABLE_HOVER_SPELLCAST then extend "IFSpellHandler" end

	DEFAULT_SIZE = Size(200, 48)

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Arguments__{}
	function ApplyConfig(self)
		if not self.Unit then return end

		local config = UnitFrame_Config.Units[self.Unit:match("%a+")]

		if config then ApplyConfig(self, config) end

		if self.Unit == "player" then
			config = UnitFrame_Config.Classes[select(2, UnitClass("player"))]

			if config then ApplyConfig(self, config) end
		end
	end

	__Arguments__{ System.Table }
	function ApplyConfig(self, config)
		for n, name in ipairs(config) do
			local set = UnitFrame_Config.Elements[name]
			local obj

			-- Create element
			if set.Name then
				self:AddElement(set.Name, set.Type, set.Direction, set.Size, set.Unit)
				obj = self:GetElement(set.Name)
			else
				self:AddElement(set.Type, set.Direction, set.Size, set.Unit)
				obj = self:GetElement(set.Type)
			end

			if obj then
				-- Apply Location
				if not set.Direction and set.Location then
					obj:ClearAllPoints()
					for _, anchor in ipairs(set.Location) do
						local parent = anchor.relativeTo and self[anchor.relativeTo] or self

						if parent then
							obj:SetPoint(anchor.point, parent, anchor.relativePoint or anchor.point, anchor.xOffset or 0, anchor.yOffset or 0)
						end
					end
				end

				-- Apply Property
				if set.Property then
					pcall(obj, set.Property)
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
		Get = function(self)
			return _IGASUI_RAIDPANEL_GROUP
		end,
	}

	property "IFMovingGroup" {
		Get = function(self)
			return _IGASUI_UNITFRAME_GROUP
		end,
	}

	property "IFResizingGroup" {
		Get = function(self)
			return _IGASUI_UNITFRAME_GROUP
		end,
	}

	property "IFTogglingGroup" {
		Get = function(self)
			return _IGASUI_UNITFRAME_GROUP
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iUnitFrame(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Size = DEFAULT_SIZE

		self.Panel.VSpacing = UnitFrame_Config.PANEL_VSPACING or 0
		self.Panel.HSpacing = UnitFrame_Config.PANEL_HSPACING or 0

		self.IFMovable = true
		self.IFResizable = true
		self.IFToggleable = true

		arUnit:Insert(self)
	end
endclass "iUnitFrame"
