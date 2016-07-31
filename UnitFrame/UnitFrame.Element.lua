IGAS:NewAddon "IGAS_UI.UnitFrame"

--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "HealthBarFrequent"
	extend "iBorder" "iStatusBarStyle"
	extend "IFClassification"

	function SetClassification(self, classification)
		if self.Unit == "target" then
			if classification == "worldboss" or classification == "elite" then
				self.Back.BackdropBorderColor = Media.ELITE_BORDER_COLOR
			elseif classification == "rareelite" or classification == "rare" then
				self.Back.BackdropBorderColor = Media.RARE_BORDER_COLOR
			else
				self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
			end
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.UseClassColor = true
	end
endclass "iHealthBar"

class "iCastBar"
	inherit "Frame"
	extend "IFCast" "IFCooldownLabel" "IFCooldownStatus"

	_BackDrop = {
	    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
	    edgeSize = 2,
	}

	_DELAY_TEMPLATE = FontColor.RED .. "(%.1f)" .. FontColor.CLOSE

	-- Update SafeZone
	local function Status_OnValueChanged(self, value)
		local parent = self.Parent

		if parent.Unit ~= "player" then
			return
		end

		local _, _, _, latencyWorld = GetNetStats()

		if latencyWorld == parent.LatencyWorld then
			-- well, GetNetStats update every 30s, so no need to go on
			return
		end

		parent.LatencyWorld = latencyWorld

		if latencyWorld > 0 and parent.Duration and parent.Duration > 0 then
			parent.SafeZone.Visible = true

			local pct = latencyWorld / parent.Duration / 1000

			if pct > 1 then pct = 1 end

			parent.SafeZone.Width = self.Width * pct
		else
			parent.SafeZone.Visible = false
		end
	end

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetUpCooldownLabel(self, label)
		label:SetPoint("RIGHT")
		label.JustifyH = "RIGHT"
		label.FontObject = "TextStatusBarText"
	end

	function SetUpCooldownStatus(self, status)
		status:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT")
		status:SetPoint("BOTTOMRIGHT")
		status.StatusBarTexturePath = Media.STATUSBAR_TEXTURE_PATH
		status.StatusBarColor = Media.CASTBAR_COLOR
		status.MinMaxValue = MinMax(1, 100)
		status.Layer = "BORDER"

		status.OnValueChanged = status.OnValueChanged + Status_OnValueChanged
	end

	function Start(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(self.Unit)

		if not name then
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

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

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("RIGHT")
		self.SafeZone.Visible = false

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
		self.NameBack.SpellName.Text = name .. self.DelayFormatString:format(self.DelayTime)

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

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("LEFT", self.Icon, "RIGHT")
		self.SafeZone.Visible = false

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
		if self.DelayTime > 0 then
			self.NameBack.SpellName.Text = name .. self.DelayFormatString:format(self.DelayTime)
		end
		self:OnCooldownUpdate(startTime, self.Duration)
	end

	function ChannelStop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The delay time format string like "%.1f"]]
	property "DelayFormatString" { Type = String, Default = _DELAY_TEMPLATE }

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if self.Height > 0 then
			self.Icon.Width = self.Height
			self.NameBack.SpellName:SetFont(self.NameBack.SpellName:GetFont(), self.Height * 4 / 7, "OUTLINE")
		end
	end

	local function OnHide(self)
		self:OnCooldownUpdate()
		self.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iCastBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Height = 16
		self.Width = 200

		self.IFCooldownLabelUseDecimal = true
		self.IFCooldownLabelAutoColor = false

		-- Icon
		local icon = Frame("Icon", self)
		icon.FrameStrata = "LOW"
		icon.Backdrop = _BackDrop
		icon.BackdropBorderColor = Media.CASTBAR_BORDER_NORMAL_COLOR
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMLEFT")
		icon.Width = self.Height

		-- Icon
		local iconTxt = Texture("Texture", icon, "BACKGROUND")
		iconTxt:SetAllPoints()

		local nameBack = Frame("NameBack", self)
		nameBack:SetAllPoints()

		-- SpellName
		local text = FontString("SpellName", nameBack, "OVERLAY", "TextStatusBarText")
		text:SetPoint("LEFT", icon, "RIGHT")
		text.JustifyH = "LEFT"
		text:SetFont(text:GetFont(), self.Height * 4 / 7, "OUTLINE")

		-- SafeZone
		local safeZone = Texture("SafeZone", self, "ARTWORK")
		safeZone.Color = ColorType(1, 0, 0)
		safeZone.Visible = false

		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged
		self.OnHide = self.OnHide + OnHide
	end
endclass "iCastBar"
