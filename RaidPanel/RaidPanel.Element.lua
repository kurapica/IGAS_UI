IGAS:NewAddon "IGAS_UI.RaidPanel"

--==========================
-- Layout for RaidPanel
--==========================

import "System.Widget"
import "System.Widget.Unit"

--==========================
-- Global
--==========================
AuraCountFont_Buff = Font("IGAS_BuffCountFont")
AuraCountFont_Buff:CopyFontObject("NumberFontNormal")

AuraCountFont_Debuff = Font("IGAS_DebuffCountFont")
AuraCountFont_Debuff:CopyFontObject("NumberFontNormal")

AuraCountFont_ClassBuff = Font("IGAS_ClassBuffCountFont")
AuraCountFont_ClassBuff:CopyFontObject("NumberFontNormal")
--==========================
-- Elements
--==========================
class "iHealthBar"
	inherit "HealthBarFrequent"
	extend "iStatusBarStyle""iBorder"
	extend "IFTarget"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetTargetState(self, isTarget)
		if isTarget then
			self.Back.BackdropBorderColor = Media.ACTIVED_BORDER_COLOR
		else
			self.Back.BackdropBorderColor = Media.DEFAULT_BORDER_COLOR
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		local _db = _DBChar[GetSpecialization() or 1]

		if _db.ElementUseDebuffColor then
			self.UseDebuffColor = true
		end

		if _db.ElementUseClassColor then
			self.UseClassColor = true
		end

		if _db.ElementUseSmoothColor then
			self.UseSmoothColor = true
		end

		if _db.ElementSmoothUpdate then
			self.Smoothing = true
			self.SmoothDelay = _db.ElementSmoothUpdateDelay or 1
		end

		self.FrameLevel = self.FrameLevel + 1
	end
endclass "iHealthBar"

class "iNameLabel"
	inherit "FontString"
	extend "IFUnitName" "IFFaction" "IFThreat"

	local function OnHide(self)
		self.ThreatMarkLeft.Visible = false
		self.ThreatMarkRight.Visible = false
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetUnitName(self, name)
		self:SetText(name)
	end

	function UpdateFaction(self)
		self:SetTextColor(self:GetFactionColor())
	end

	function SetThreatLevel(self, lvl)
		if self.Unit and lvl >= 2 and not UnitCanAttack("player", self.Unit) then
			self.ThreatMarkLeft.Visible = true
			self.ThreatMarkRight.Visible = true
		else
			self.ThreatMarkLeft.Visible = false
			self.ThreatMarkRight.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iNameLabel(self, ...)
		Super(self, ...)

		self.UseClassColor = true
		self.UseSelectionColor = false
		self.UseTapColor = false
		self.DrawLayer = "BORDER"
		self.JustifyV = "MIDDLE"
		self.JustifyH = "CENTER"

		self:SetWordWrap(true)

		self.OnHide = self.OnHide + OnHide

		-- Threat mark
		local threatMarkLeft = FontString("ThreatMarkLeft", self.Parent)
		threatMarkLeft.Visible = false
		threatMarkLeft:SetPoint("RIGHT", self, "LEFT")
		threatMarkLeft:SetTextColor(1, 0, 0)
		threatMarkLeft.Text = ">>"
		self.ThreatMarkLeft = threatMarkLeft

		local threatMarkRight = FontString("ThreatMarkRight", self.Parent)
		threatMarkRight.Visible = false
		threatMarkRight:SetPoint("LEFT", self, "RIGHT")
		threatMarkRight:SetTextColor(1, 0, 0)
		threatMarkRight.Text = "<<"
		self.ThreatMarkRight = threatMarkRight
	end
endclass "iNameLabel"

class "iBuffPanel"
	inherit "AuraPanel"

	local min = math.min

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function UpdateAuras(self)
		local unit = self.Unit

		if unit then
			if UnitCanAttack("player", unit) then
				self.Filter = "HELPFUL"
				return Super.UpdateAuras(self)
			else
				self.Filter = "HELPFUL|PLAYER"
			end
		end

		local orderCache = _M._BuffOrderCache
		local orderBuffs = self.OrderBuffs
		wipe(orderBuffs)

		local index = 1
		local i = 0
		local name
		local filter = self.Filter

		if unit then
			if orderCache.MAX > 0 then
				local name, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)
				while name do
					if caster == "player" and orderCache[spellID] then
						local priority = orderCache[spellID]
						for j = i, 0, -1 do
							if j == 0 or orderCache[orderBuffs[j]] < priority then
								orderBuffs[j + 1] = spellID
								priority = false
								break
							else
								orderBuffs[j + 1] = orderBuffs[j]
							end
						end
						i = i + 1
					end

					index = index + 1
					name, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)
				end

				for j = 1, min(i, self.MaxCount) do orderBuffs[orderBuffs[j]] = j end

				index = 1
			end

			if i > 0 then
				local name, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)
				while name do
					if caster == "player" then
						if orderBuffs[spellID] then
							self.Element[orderBuffs[spellID]]:Refresh(unit, index, filter)
						elseif not _BuffBlackList[spellID] and i < self.MaxCount then
							i = i + 1
							self.Element[i]:Refresh(unit, index, filter)
						end
					end

					index = index + 1
					name, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)
				end
			else
				while i < self.MaxCount do
					local name, _, _, _, _, _, caster, _, _, spellID = UnitAura(unit, index, filter)

					if name then
						if caster == "player" and not _BuffBlackList[spellID] then
							i = i + 1
							self.Element[i]:Refresh(unit, index, filter)
						end
					else
						break
					end

					index = index + 1
				end
			end
		end

		while i < self.Count do
			i = i + 1
			self.Element[i].Visible = false
		end

		return self:UpdatePanelSize()
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnMouseUp(self, button)
		if IsAltKeyDown() and button == "RightButton" and _DBChar[GetSpecialization() or 1].BuffPanelSet.RightRemove and not UnitCanAttack("player", self.Parent.Unit) then
			local name, _, _, _, _, _, _, _, _, spellID = UnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)

			if name then
				_BuffBlackList[spellID] = true

				return self.Parent:Refresh()
			end
		end
	end

	local function OnElementAdd(self, element)
		element:GetChild("Count").FontObject = AuraCountFont_Buff

		element.ShowTooltip = _DBChar[GetSpecialization() or 1].BuffPanelSet.ShowTooltip
		element.MouseEnabled = _DBChar[GetSpecialization() or 1].BuffPanelSet.ShowTooltip or _DBChar[GetSpecialization() or 1].BuffPanelSet.RightRemove
		element.OnMouseUp = element.OnMouseUp + OnMouseUp
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iBuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HELPFUL|PLAYER"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.HORIZONTAL
		self.OrderBuffs = {}

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iBuffPanel"

class "iDebuffPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function UpdateAuras(self)
		local unit = self.Unit

		if unit then
			if UnitCanAttack("player", unit) then
				self.Filter = "HARMFUL|PLAYER"
			else
				self.Filter = "HARMFUL"
			end
		end

		return Super.UpdateAuras(self)
	end

	function CustomFilter(self, unit, index, filter)
		local name, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)

		if filter ~= "HARMFUL" then return caster == "player" end

		if _DebuffBlackList[spellID] then return false end

		return true
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnMouseUp(self, button)
		if IsAltKeyDown() and button == "RightButton" and _DBChar[GetSpecialization() or 1].DebuffPanelSet.RightRemove and not UnitCanAttack("player", self.Parent.Unit) then
			local name, _, _, _, _, _, _, _, _, spellID = UnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)

			if name then
				_DebuffBlackList[spellID] = true

				return self.Parent:Refresh()
			end
		end
	end

	local function OnElementAdd(self, element)
		element:GetChild("Count").FontObject = AuraCountFont_Debuff

		element.ShowTooltip = _DBChar[GetSpecialization() or 1].DebuffPanelSet.ShowTooltip
		element.MouseEnabled = _DBChar[GetSpecialization() or 1].DebuffPanelSet.ShowTooltip or _DBChar[GetSpecialization() or 1].DebuffPanelSet.RightRemove
		element.OnMouseUp = element.OnMouseUp + OnMouseUp
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HARMFUL"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.VERTICAL
		self.TopToBottom = false
		self.LeftToRight = false

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iDebuffPanel"

class "iRoleIcon"
	inherit "Texture"
	extend "IFGroupRole" "IFCombat"

	TANK_TEXTURE = [[Interface\Addons\IGAS_UI\Resource\tank.tga]]
	HEALER_TEXTURE = [[Interface\Addons\IGAS_UI\Resource\healer.tga]]
	DAMAGER_TEXTURE = [[Interface\Addons\IGAS_UI\Resource\dps.tga]]

	local function refreshRole(self)
		if self.InCombat == self.ShowInCombat and self.GroupRole ~= "NONE" then
			if self.GroupRole == "TANK" then
				self.TexturePath = TANK_TEXTURE
			elseif self.GroupRole == "HEALER" then
				self.TexturePath = HEALER_TEXTURE
			else
				self.TexturePath = DAMAGER_TEXTURE
			end
			self.Visible = true
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetCombatState(self, inCombat)
		self.InCombat = inCombat
		return refreshRole(self)
	end

	function SetGroupRole(self, role)
		self.GroupRole = role
		return refreshRole(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Handler__ (refreshRole)
	property "ShowInCombat" { Type = Boolean }
	property "InCombat" { Type = Boolean }
	property "GroupRole" { Type = String }

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iRoleIcon(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Height = 16
		self.Width = 16

		self.TexturePath = nil
	end
endclass "iRoleIcon"

class "iClassBuffPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function UpdateAuras(self)
		local index = 1
		local i = 0
		local name
		local unit = self.Unit
		local filter = self.Filter
		local maxCount = self.MaxCount

		if unit then
			if UnitCanAttack("player", unit) then
				-- So nothing should be shown
				self.Filter = "HELPFUL|PLAYER"
			else
				self.Filter = "HELPFUL"
			end
		end

		wipe(self.PriorityIndex)
		wipe(self.PriorityMap)

		if unit and ( unit ~= "player" or _DBChar[GetSpecialization() or 1].ClassBuffPanelSet.ShowOnPlayer ) then
			local priorityIndex = self.PriorityIndex
			local priorityMap = self.PriorityMap

			local name, _, _, _, _, _, caster, isStealable, _, spellID, _, isBossDebuff = UnitAura(unit, index, filter)

			while name and spellID do
				if _ClassBuffMap[name] or _ClassBuffMap[spellID] then
					local priority = _ClassBuffMap[name] or _ClassBuffMap[spellID]
					local placed = false

					for j = 1, i do
						if priorityMap[j] > priority then
							placed = true

							i = math.min(i + 1, self.MaxCount)

							for k = i, j + 1, -1 do
								priorityIndex[k] = priorityIndex[k-1]
								priorityMap[k] = priorityMap[k-1]
							end

							priorityIndex[j] = index
							priorityMap[j] = priority

							break
						end
					end

					if not placed and i < self.MaxCount then
						i = i + 1
						priorityIndex[i] = index
						priorityMap[i] = priority
					end
				end

				index = index + 1
				name, _, _, _, _, _, caster, isStealable, _, spellID, _, isBossDebuff = UnitAura(unit, index, filter)
			end

			for j = 1, i do
				self.Element[j]:Refresh(unit, priorityIndex[j], filter)
			end
		end

		i = i + 1
		while i <= self.Count do
			self.Element[i].Visible = false
			i = i + 1
		end

		self:UpdatePanelSize()
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnElementAdd(self, element)
		element:GetChild("Count").FontObject = AuraCountFont_ClassBuff

		element.ShowTooltip = _DBChar[GetSpecialization() or 1].ClassBuffPanelSet.ShowTooltip
		element.MouseEnabled = _DBChar[GetSpecialization() or 1].ClassBuffPanelSet.ShowTooltip
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iClassBuffPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Filter = "HELPFUL"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false

		self.PriorityIndex = {}
		self.PriorityMap = {}

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iClassBuffPanel"