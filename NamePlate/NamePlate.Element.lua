IGAS:NewAddon "IGAS_UI.NamePlate"

--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "StatusBar"
	extend "IFHealthFrequent" "IFFaction" "IFTarget" "IFThreat"
	extend "iBorder" "iStatusBarStyle"

	_DefaultColor = ColorType(1, 1, 1)

	local function IsPlayerEffectivelyTank()
		local assignedRole = UnitGroupRolesAssigned("player")
		if assignedRole == "NONE" then
			local spec = GetSpecialization()
			return spec and GetSpecializationRole(spec) == "TANK"
		end

		return assignedRole == "TANK"
	end

	local function UpdateStatusBarColor(self)
		local unit = self.Unit
		if unit then
			if self.IsTapDenied then
				self:SetStatusBarColor(0.5, 0.5, 0.5)
				return
			end

			local status = self.ThreatLevel

			if status and status > 0 then
				if not UnitIsPlayer(unit) and IsPlayerEffectivelyTank() then
					local isTanking = UnitDetailedThreatSituation("player", unit)
					if self.isTanking ~= isTanking then
						if self.isTanking and not isTanking then
							if not self.LoseAggro:IsPlaying() then
								self.LoseAggro.Playing = true
							end
						end
						self.isTanking = isTanking
					end
				end

				self:SetStatusBarColor(GetThreatStatusColor(status))
			else
				self:SetStatusBarColor(self:GetFactionColor())
			end
		end
	end

	function SetThreatLevel(self, lvl)
		self.ThreatLevel = lvl
	end

	function UpdateFaction(self)
		self.IsTapDenied = self.Unit and UnitIsTapDenied(self.Unit)
	end

	function SetTargetState(self, isTarget)
		if isTarget then
			self.Back.BackdropBorderColor = Media.ACTIVED_BORDER_COLOR
		else
			self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
		end
	end

	-- Property
	property "ThreatLevel" { Type = Number, Handler = UpdateStatusBarColor }
	property "IsTapDenied" { Type = Boolean, Handler = UpdateStatusBarColor }

	function iHealthBar(self, ...)
		Super(self, ...)

		self.FrameStrata = "LOW"

		local animLoseAggro = AnimationGroup("LoseAggro", self)

		local alpha = Alpha("Alpha1", animLoseAggro)
		alpha.Order = 1
		alpha.Duration = 0.3
		alpha.FromAlpha = 1
		alpha.ToAlpha = 0

		alpha = Alpha("Alpha2", animLoseAggro)
		alpha.Order = 2
		alpha.Duration = 0.3
		alpha.FromAlpha = 1
		alpha.ToAlpha = 0

		self.OnForceRefresh = self.OnForceRefresh + UpdateStatusBarColor
	end
endclass "iHealthBar"

class "iCastBar"
	inherit "Frame"
	extend "IFCast" "IFCooldownStatus"
	extend "iBorder"

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	function SetUpCooldownStatus(self, status)
		status:ClearAllPoints()
		status:SetAllPoints()
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.NAMEPLATE_CASTBAR_COLOR
		status.MinMaxValue = MinMax(1, 100)
		status.Layer = "BORDER"
	end

	function Start(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(self.Unit)

		if not name then
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Icon.Width = self.Icon.Height
		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		self.NameBack.SpellName.Text = name
		self.LineID = lineID

		if notInterruptible then
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
		else
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		end

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = true

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	function Fail(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Stop(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Interrupt(self, spell, rank, lineID, spellID)
		if not lineID or lineID == self.LineID then
			self:OnCooldownUpdate()
			self.Alpha = 0
			self.Duration = 0
			self.LineID = nil
		end
	end

	function Interruptible(self)
		self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
	end

	function UnInterruptible(self)
		self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
	end

	function Delay(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime = UnitCastingInfo(self.Unit)

		if not startTime or not endTime then return end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.EndTime = self.EndTime or endTime
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration

		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStart(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo(self.Unit)

		if not name then
			self.Alpha = 0
			self.Duration = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Icon.Width = self.Icon.Height
		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.Texture.TexturePath = texture
		self.NameBack.SpellName.Text = name

		if notInterruptible then
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NONINTERRUPTIBLE_COLOR
		else
			self.Icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		end

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = false

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	function ChannelUpdate(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime = UnitChannelInfo(self.Unit)

		if not name or not startTime or not endTime then
			self:OnCooldownUpdate()
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.EndTime = self.EndTime or endTime
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration
		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnHide(self)
		self:OnCooldownUpdate()
		self.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iCastBar(self, ...)
		Super(self, ...)

		local bgColor = Texture("Bg", self, "BACKGROUND")
		bgColor:SetTexture(0, 0, 0, 1)
		bgColor:SetAllPoints()

		local icon = Frame("Icon", self)
		icon.FrameStrata = "LOW"
		icon.Backdrop = _BackDrop
		icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT")
		icon:SetSize(32, 32)

		-- Icon
		local iconTxt = Texture("Texture", icon, "BACKGROUND")
		iconTxt:SetAllPoints()

		local nameBack = Frame("NameBack", self)
		nameBack:SetAllPoints()

		-- SpellName
		local text = FontString("SpellName", nameBack, "OVERLAY")
		text:SetVertexColor(1, 1, 1)
		text.FontObject = CAST_FONT
		text:SetPoint("CENTER", self, "BOTTOM")

		self.OnHide = self.OnHide + OnHide
	end
endclass "iCastBar"

class "iAuraPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function UpdateAuras(self)
		local unit = self.Unit

		local filter

		if unit then
			if UnitIsUnit("player", unit) then
				filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY"
			else
				local reaction = UnitReaction("player", unit)
				if reaction and reaction <= 4 then
				-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
					filter = "HARMFUL|PLAYER|INCLUDE_NAME_PLATE_ONLY"
				end
			end
		end

		if filter then
			self.Filter = filter
			self.HasFilter = true
		else
			self.HasFilter = false
		end

		return Super.UpdateAuras(self)
	end

	function CustomFilter(self, unit, index, filter)
		if not self.HasFilter then return false end

		if UnitIsUnit("player", unit) then
			local name, _, _, _, _, duration, _, caster, _, _, spellID = UnitAura(unit, index, filter)
			if name and duration > 0 and duration <= 60 then return true end
		else
			return true
		end
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iAuraPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.ColumnCount = 4
		self.RowCount = 3
		self.ElementWidth = 24
		self.ElementHeight = 24
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false
		self.LeftToRight = true
    end
endclass "iAuraPanel"

class "iNameLabel"
	inherit "Frame"
	extend "IFUnitName" "IFFaction" "IFUnitLevel"

	local function parseColor(str, r, g, b)
		local color = ("\124cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		return color .. str .. "|r"
	end

	function RefreshLabel(self)
		local unit = self.Unit
		if unit and UnitIsUnit("player", unit) then
			self.Visible = false
		else
			-- Parse Level
			local value = unit and (self.UnitLevel or UnitLevel(unit))
			local lvlText

			if value and value > 0 then
				if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
					local petLevel = UnitBattlePetLevel(unit)

					lvlText = parseColor(self.LevelFormat:format(petLevel), 1.0, 0.82, 0.0)
				else
					if UnitCanAttack("player", unit) then
						local color = GetQuestDifficultyColor(value)
						lvlText = parseColor(self.LevelFormat:format(value), color.r, color.g, color.b)
					else
						lvlText = parseColor(self.LevelFormat:format(value), 1.0, 0.82, 0.0)
					end
				end
			else
				lvlText = parseColor(self.LevelFormat:format("???") , 1.0, 0.82, 0.0)
			end

			-- Parse Name
			local nameText

			if unit then
				local name = GetUnitName(unit, self.WithServerName) or unit
				if self.UseTapColor and UnitIsTapDenied(unit) then
					nameText = parseColor(name, 0.5, 0.5, 0.5)
				elseif self.UseSelectionColor and not UnitIsPlayer(unit) then
					nameText = parseColor(name, UnitSelectionColor(unit))
				elseif self.UseClassColor then
					local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
					if color then
						nameText = parseColor(name, color.r, color.g, color.b)
					else
						nameText = parseColor(name, 1, 1, 1)
					end
				else
					nameText = parseColor(name, 1, 1, 1)
				end
			else
				nameText = parseColor(L"Unknown", 1, 1, 1)
			end

			self.Label.Text = lvlText .. " " .. nameText
			self.Visible = true
		end
	end

	function UpdateFaction(self)
		return RefreshLabel(self)
	end

	function SetUnitName(self, name)
		self.UnitName = name
		return RefreshLabel(self)
	end

	function SetUnitLevel(self, lvl)
		self.UnitLevel = lvl
		return RefreshLabel(self)
	end

	property "UnitName" { Type = String }
	property "UnitLevel" { Type = Number }
	property "LevelFormat" { Type = String, Default = "%s", Handler = RefreshLabel }

	function iNameLabel(self, ...)
		Super(self, ...)

		local label = FontString("Label", self, "ARTWORK")
		label:SetPoint("BOTTOM")
		label.FontObject = NAME_FONT
	end
endclass "iNameLabel"
