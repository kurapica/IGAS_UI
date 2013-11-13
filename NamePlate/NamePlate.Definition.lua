-----------------------------------------
-- Definition for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

import "System.Widget"

class "NamePlateMask"
	inherit "VirtualUIObject"

	STATUSBAR_TEXTURE_PATH = STATUSBAR_TEXTURE_PATH

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	local function OnShow(self)
		self.CastBack:SetAlpha(0)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function NamePlateMask(self, name, parent, ...)
		Super(self, name, parent, ...)

    	-- HealthBar
		self.HealthBar = ({({parent:GetChildren()})[1]:GetChildren()})[1]

		self.HealthBar:SetStatusBarTexture(STATUSBAR_TEXTURE_PATH, "ARTWORK")
		iBorder._BuildBorder(self.HealthBar)

		-- Original back
		local back = ({({parent:GetChildren()})[1]:GetRegions()})[2]
		back:SetAlpha(0)

		-- CastBar
		self.CastBar = IGAS:GetWrapper(({({parent:GetChildren()})[1]:GetChildren()})[2])

		self.CastBar.OnShow = OnShow

		self.CastBar:SetStatusBarTexture(STATUSBAR_TEXTURE_PATH, "ARTWORK")
		iBorder._BuildBorder(self.CastBar)

		self.CastBar.CastBack = ({({({parent:GetChildren()})[1]:GetChildren()})[2]:GetRegions()})[2]

		NamePlateArray:Insert(self)
    end
endclass "NamePlateMask"

class "iDebuffPanel"
	inherit "AuraPanel"

	TARGET_DEBUFF_SIZE = TARGET_DEBUFF_SIZE

	class "AuraIcon"
		inherit "Frame"
		extend "IFCooldownLabel"

		TARGET_DEBUFF_MAX_ALPHA_LIMIT = TARGET_DEBUFF_MAX_ALPHA_LIMIT
		NORMAL_COLOR = ColorType(1, 1, 1)
		LAST_COLOR = ColorType(1, 0.12, 0.12)

		--[======[
			@name AuraIcon
			@type class
			@desc The icon to display buff or debuff
		]======]

		local function SetText(self, text)
			FontString.SetText(self, text)

			text = tonumber(text) or 0

			if text >= TARGET_DEBUFF_MAX_ALPHA_LIMIT then
				self.Parent.Alpha = 1
			else
				self.Parent.Alpha = text / TARGET_DEBUFF_MAX_ALPHA_LIMIT
			end

			--Mark the minimal icon
			if text <= 5 then
				self.TextColor = LAST_COLOR
			else
				self.TextColor = NORMAL_COLOR
			end
		end

		------------------------------------------------------
		-- Event
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		--[======[
			@name SetUpCooldownLabel
			@type method
			@desc Custom the label
			@param label System.Widget.FontString
			@return nil
		]======]
		function SetUpCooldownLabel(self, label)
			IFCooldownLabel.SetUpCooldownLabel(self, label)

			label.SetText = SetText
		end

		--[======[
			@name Refresh
			@type method
			@desc Refresh the icon
			@format unit, index[, filter]
			@param unit string, the unit
			@param index number, the aura index
			@param filter string, the filiter token
			@return nil
		]======]
		function Refresh(self, unit, index, filter)
			local name, _, texture, count, _, duration, expires = UnitAura(unit, index, filter)

			if name then
				self.Index = index

				-- Texture
				self.Icon.TexturePath = texture

				-- Count
				if count and count > 1 then
					self.Count.Visible = true
					self.Count.Text = tostring(count)
				else
					self.Count.Visible = false
				end

				-- Remain
				self:OnCooldownUpdate(expires - duration, duration)

				self.Visible = true
			else
				self.Visible = false
			end
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------

		------------------------------------------------------
		-- Event Handler
		------------------------------------------------------
		local function UpdateTooltip(self)
			self = IGAS:GetWrapper(self)
			IGAS.GameTooltip:SetUnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)
		end

		local function OnEnter(self)
			if self.Visible then
				IGAS.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
				UpdateTooltip(self)
			end
		end

		local function OnLeave(self)
			IGAS.GameTooltip.Visible = false
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function AuraIcon(self, name, parent, ...)
			Super(self, name, parent, ...)

			local icon = Texture("Icon", self, "BORDER")
			icon:SetPoint("TOPLEFT", 1, -1)
			icon:SetPoint("BOTTOMRIGHT", -1, 1)

			local count = FontString("Count", self, "OVERLAY", "NumberFontNormal")
			count:SetPoint("BOTTOMRIGHT", -1, 0)

			self.OnEnter = self.OnEnter + OnEnter
			self.OnLeave = self.OnLeave + OnLeave

			IGAS:GetUI(self).UpdateTooltip = UpdateTooltip
		end
	endclass "AuraIcon"

	------------------------------------
	--- Custom Filter method
	-- @name CustomFilter
	-- @type function
	-- @param unit
	-- @param index
	-- @param filter
	-- @return boolean
	------------------------------------
	function CustomFilter(self, unit, index, filter)
		local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)

		if name and duration > 0 and caster == "player" and name ~= UnitChannelInfo("player") then
			return true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HARMFUL"
		self.RowCount = 6
		self.ColumnCount = 6
		self.MarginTop = 2

		self.ElementWidth = TARGET_DEBUFF_SIZE
		self.ElementHeight = TARGET_DEBUFF_SIZE

		self.ElementType = AuraIcon
    end
endclass "iDebuffPanel"
