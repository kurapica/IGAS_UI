-----------------------------------------
-- Definition for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

import "System"
import "System.Widget"
import "System.Widget.Action"

_IGASUI_ACTIONBAR_GROUP = "IActionButton"

_M:RegisterEvent("SPELL_FLYOUT_UPDATE")
_M:RegisterEvent("ACTIONBAR_SHOWGRID")
_M:RegisterEvent("ACTIONBAR_HIDEGRID")
_M:RegisterEvent("PET_BAR_SHOWGRID")
_M:RegisterEvent("PET_BAR_HIDEGRID")

_SpellFlyoutMap = {}

function SPELL_FLYOUT_UPDATE(self)
	for root in pairs(_SpellFlyoutMap) do
		root:RegenerateFlyout()
	end
end

_BlockGridUpdatingBar = {}

function ACTIONBAR_SHOWGRID(self)
	for btn, flag in pairs(_BlockGridUpdatingBar) do
		if flag and not btn.PetBar and not btn.StanceBar then
			btn.ShowGrid = true
			btn.FadeAlpha = 1
		end
	end
end

function ACTIONBAR_HIDEGRID(self)
	for btn, flag in pairs(_BlockGridUpdatingBar) do
		if flag and not btn.PetBar and not btn.StanceBar then
			btn.ShowGrid = btn.AlwaysShowGrid or not btn.LockMode
			btn:OnLeave()
		end
	end
end

function PET_BAR_SHOWGRID(self)
	for btn, flag in pairs(_BlockGridUpdatingBar) do
		if flag and btn.PetBar then
			while btn do
				btn:SetAlpha(1)
				local branch = btn.Branch
				while branch do
					branch:SetAlpha(1)
					branch = branch.Branch
				end
				btn = btn.Brother
			end
		end
	end
end

function PET_BAR_HIDEGRID(self)
	for btn, flag in pairs(_BlockGridUpdatingBar) do
		if flag and btn.PetBar then
			btn:OnLeave()
		end
	end
end

------------------------------------------------------
-- Class
------------------------------------------------------
class "IActionButton"
	inherit "ActionButton"
	extend "IFMovable" "IFResizable"
	extend "IFStyle"

	_MaxBrother = 12
	_TempActionBrother = {}
	_TempActionBranch = {}

	-- Manager Frame
	_ManagerFrame = SecureFrame("IGASUI_IActionButton_Manager", IGAS.UIParent, "SecureHandlerStateTemplate")
	_ManagerFrame.Visible = false

	-- Init manger frame's enviroment
	Task.NoCombatCall(function ()
		_ManagerFrame:Execute[[
			Manager = self

			BranchMap = newtable()
			HeaderMap = newtable()
			BranchHeader = newtable()
			RootExpansion = newtable()
			HideBranchList = newtable()
			State = newtable()
			StanceBar = newtable()
			AutoHideMap = newtable()
			AutoFadeMap = newtable()
			PetHeader = newtable()
			AutoSwapHeader = newtable()

			ShowBrother = [==[
				local header = HeaderMap[self] or self

				if StanceBar[1] == header then
					for btn, hd in pairs(HeaderMap) do
						if hd == header then
							if btn:GetAttribute("spell") then
								btn:Show()
							end
						end
					end
				else
					for btn, hd in pairs(HeaderMap) do
						if hd == header then
							if not BranchMap[btn] or RootExpansion[ BranchMap[btn] ] then
								btn:Show()
							end
						end
					end
				end
			]==]

			HideBrother = [==[
				local header = HeaderMap[self] or self

				for btn, hd in pairs(HeaderMap) do
					if hd == header then
						btn:Hide()
					end
				end
			]==]

			ShowBranch = [==[
				local branch = BranchMap[self] or self
				local needHide = not RootExpansion[branch]
				local regBtn

				for btn, root in pairs(BranchMap) do
					if root == branch then
						btn:Show()
						if needHide then
							if not regBtn then
								regBtn = branch
								regBtn:RegisterAutoHide(Manager:GetAttribute("PopupDuration") or 0.25)
							end
							regBtn:AddToAutoHide(btn)
						end
					end
				end

				if regBtn then
					HideBranchList[regBtn] = true
				end
			]==]

			HideBranch = [==[
				local branch = BranchMap[self] or self

				for btn, root in pairs(BranchMap) do
					if root == branch then
						btn:Hide()
					end
				end
			]==]

			UpdatePetHeader = [=[
				if State["pet"] then
					for btn in pairs(PetHeader) do
						if not btn:IsShown() then
							if not AutoHideMap[btn] or State[btn] then
								btn:Show()
							end
						elseif AutoHideMap[btn] and not State[btn] then
							btn:Hide()
						end
					end
				else
					for btn in pairs(PetHeader) do
						if btn:IsShown() then
							btn:Hide()
						end
					end
				end
			]=]
		]]

		_ManagerFrame:SetAttribute("_onstate-pet", [=[
			State["pet"] = newstate == "pet"
			Manager:Run(UpdatePetHeader)
		]=])
		_ManagerFrame:RegisterStateDriver("pet", "[pet]pet;nopet;")

		_ManagerFrame:Execute(("State['pet'] = '%s' == 'pet'"):format(SecureCmdOptionParse("[pet]pet;nopet;")))
	end)

	_IActionButton_UpdateExpansion = [[
		local root = Manager:GetFrameRef("ExpansionButton")
		RootExpansion[root] = %s and BranchHeader[root] or nil
		if BranchHeader[root] then
			if RootExpansion[root] then
				Manager:RunFor(root, ShowBranch)
			else
				Manager:RunFor(root, HideBranch)
			end
		end
	]]

	_IActionButton_WrapClickPre = [[
		if button == "RightButton" then
			if IsAltKeyDown() then
				if self:GetAttribute("AutoGenerated") then
					self:CallMethod("IActionHandler_SendToBlackList")
				end
			else
				if RootExpansion[self] then
					RootExpansion[self] = nil
					self:CallMethod("IActionHandler_UpdateExpansion", nil)
				elseif not RootExpansion[self] then
					if BranchHeader[self] then
						RootExpansion[self] = true
						Manager:RunFor(self, ShowBranch)
						self:CallMethod("IActionHandler_UpdateExpansion", true)
					end
				end
			end
		end
		return button, BranchMap[self] and "togglebranch" or BranchHeader[self] and "togglebranch" or nil
	]]

	_IActionButton_WrapClickPost = [=[
		local root = BranchMap[self] or self
		if BranchHeader[root] and not RootExpansion[root] then
			Manager:RunFor(self, HideBranch)
		end
		if AutoSwapHeader[root] and root ~= self and not root:GetAttribute("isflyoutspell") then
			self:SetAttribute("frameref-SwapTarget", root)
			return self:RunAttribute("SwapAction")
		end
	]=]

	_IActionButton_WrapEnter = [[
		if BranchHeader[self] and not RootExpansion[self] then
			Manager:RunFor(self, ShowBranch)
		end
	]]

	_IActionButton_WrapAttribute = [[
		if name == "statehidden" then
			if value then
				if HideBranchList[self] then
					self:Show()
					if RootExpansion[self] then return end
					Manager:RunFor(self, HideBranch)
				elseif not HeaderMap[self] then
					Manager:RunFor(self, HideBrother)
				elseif BranchHeader[self] then
					Manager:RunFor(self, HideBranch)
				end
			else
				if HideBranchList[self] then
					HideBranchList[self] = nil
				elseif not HeaderMap[self] then
					Manager:RunFor(self, ShowBrother)
				end
			end
		end
	]]

	local function RegisterPetAction(self)
		_ManagerFrame:SetFrameRef("StateButton", self)
		_ManagerFrame:Execute[[
			local btn = Manager:GetFrameRef("StateButton")
			PetHeader[btn] = true
			Manager:Run(UpdatePetHeader)
		]]
	end

	local function UnregisterPetAction(self)
		_ManagerFrame:SetFrameRef("StateButton", self)
		_ManagerFrame:Execute[[
			local btn = Manager:GetFrameRef("StateButton")
			PetHeader[btn] = nil
			if not btn:IsShown() then
				btn:Show()
			end
		]]
	end

	local function RegisterAutoHide(self, cond, autofade)
		self.AutoHideState = "autohide" .. self.Name

		_ManagerFrame:SetFrameRef("StateButton", self)
		_ManagerFrame:Execute(([[
			local name = "%s"
			local bar = Manager:GetFrameRef("StateButton")
			AutoHideMap[name] = bar
			AutoHideMap[bar] = name
			AutoFadeMap[name] = %s
			bar:SetAttribute("autofadeout", false)
		]]):format(self.AutoHideState, tostring(autofade or false)))

		_ManagerFrame:RegisterStateDriver(self.AutoHideState, cond)
		_ManagerFrame:SetAttribute("_onstate-" .. self.AutoHideState, ([[
			local name = "%s"
			local bar = AutoHideMap[name]
			if not bar then return end
			local autofade = AutoFadeMap[name]

			State[bar] = newstate ~= "hide"

			if newstate == "hide" then
				if autofade then
					bar:SetAttribute("autofadeout", true)
					Manager:CallMethod("StartAutoFadeOut", bar:GetName())
				else
					-- Unregister HideBranch
					for root in pairs(HideBranchList) do
						if root == bar or HeaderMap[root] == bar then
							root:UnregisterAutoHide()
							HideBranchList[root] = nil
						end
					end
					if bar:IsShown() then
						bar:Hide()
					end
				end
			else
				if PetHeader[bar] and not State["pet"] then
					if bar:IsShown() then bar:Hide() end
				elseif StanceBar[1] == bar and not bar:GetAttribute("spell") then
					if bar:IsShown() then bar:Hide() end
				elseif not bar:IsShown() then
					bar:Show()
				end
				if autofade then
					bar:SetAttribute("autofadeout", false)
					Manager:CallMethod("StopAutoFadeOut", bar:GetName())
				end
			end
		]]):format(self.AutoHideState))
		_ManagerFrame:SetAttribute("state-" .. self.AutoHideState, nil)
	end

	local function SetBlockGridUpdating(self, value)
		_BlockGridUpdatingBar[self] = value or nil

		while self do
			self.BlockGridUpdating = value
			local branch = self.Branch
			while branch do
				branch.BlockGridUpdating = value
				branch = branch.Branch
			end
			self = self.Brother
		end
	end

	IGAS:GetUI(_ManagerFrame).StartAutoFadeOut = function(self, name)
		local header = IGAS:GetWrapper(_G[name])
		SetBlockGridUpdating(header, true)
		header:OnLeave()
	end

	IGAS:GetUI(_ManagerFrame).StopAutoFadeOut = function(self, name)
		local header = IGAS:GetWrapper(_G[name])
		SetBlockGridUpdating(header, false)
	end

	local function UnregisterAutoHide(self)
		if self.AutoHideState then
			_ManagerFrame:UnregisterStateDriver(self.AutoHideState)

			_ManagerFrame:SetFrameRef("StateButton", self)
			_ManagerFrame:Execute(([[
				local name = "%s"
				local bar = Manager:GetFrameRef("StateButton")
				AutoHideMap[name] = nil
				AutoHideMap[bar] = nil
				AutoFadeMap[name] = nil
				State[bar] = nil

				if not PetHeader[bar] or State["pet"] then
					bar:Show()
				else
					bar:Hide()
				end
			]]):format(self.AutoHideState))
			_ManagerFrame:SetAttribute("state-" .. self.AutoHideState, nil)

			self.AutoHideState = nil
		end
	end

	local function RegisterAutoSwap(self)
		_ManagerFrame:SetFrameRef("AutoSwapButton", self)
		_ManagerFrame:Execute[[
			local btn = Manager:GetFrameRef("AutoSwapButton")
			AutoSwapHeader[btn] = true
		]]
	end

	local function UnregisterAutoSwap(self)
		_ManagerFrame:SetFrameRef("AutoSwapButton", self)
		_ManagerFrame:Execute[[
			local btn = Manager:GetFrameRef("AutoSwapButton")
			AutoSwapHeader[btn] = nil
		]]
	end

	local function RegisterBrother(brother, header)
		_ManagerFrame:SetFrameRef("BrotherButton", brother)
		_ManagerFrame:SetFrameRef("HeaderButton", header)
		_ManagerFrame:Execute[[
			local brother, header = Manager:GetFrameRef("BrotherButton"), Manager:GetFrameRef("HeaderButton")
			HeaderMap[brother] = header
		]]
	end

	local function RemoveBrother(brother)
		_ManagerFrame:SetFrameRef("BrotherButton", brother)
		_ManagerFrame:Execute[[
			local brother = Manager:GetFrameRef("BrotherButton")
			HeaderMap[brother] = nil
		]]
	end

	local function RegisterStanceBar(self)
		_ManagerFrame:SetFrameRef("StanceHeader", self)
		_ManagerFrame:Execute[[
			StanceBar[1] = Manager:GetFrameRef("StanceHeader")
		]]
	end

	local function UnregisterStanceBar(self)
		_ManagerFrame:SetFrameRef("StanceHeader", self)
		_ManagerFrame:Execute[[
			if StanceBar[1] == Manager:GetFrameRef("StanceHeader") then
				StanceBar[1] = nil
			end
		]]
	end

	local function RegisterBranch(button, root)
		_ManagerFrame:SetFrameRef("BranchButton", button)
		_ManagerFrame:SetFrameRef("RootButton", root)
		_ManagerFrame:Execute[[
			local branch, root = Manager:GetFrameRef("BranchButton"), Manager:GetFrameRef("RootButton")
			BranchMap[branch] = root
			BranchHeader[root] = true
		]]
	end

	local function RemoveBranch(button)
		_ManagerFrame:SetFrameRef("BranchButton", button)
		_ManagerFrame:Execute[[
			local branch = Manager:GetFrameRef("BranchButton")
			local root = BranchMap[branch]
			BranchMap[branch] = nil
			local chk = false

			if root then
				for btn, rt in pairs(BranchMap) do
					if rt == root then
						chk = true
						break
					end
				end
				if not chk then
					BranchHeader[root] = nil
				end
			end
		]]
	end

	local function SetupActionButton(self)
		_ManagerFrame:WrapScript(self, "OnEnter", _IActionButton_WrapEnter)
		_ManagerFrame:WrapScript(self, "OnClick", _IActionButton_WrapClickPre, _IActionButton_WrapClickPost)
		_ManagerFrame:WrapScript(self, "OnAttributeChanged", _IActionButton_WrapAttribute)
	end

	local function UpdateExpansion(self, flag)
		_ManagerFrame:SetFrameRef("ExpansionButton", self)
		_ManagerFrame:Execute(_IActionButton_UpdateExpansion:format(tostring(flag)))
	end

	local function IActionHandler_UpdateExpansion(self, flag)
		IGAS:GetWrapper(self).__Expansion = flag and true or false
	end

	local function IActionHandler_SendToBlackList(self)
		self = IGAS:GetWrapper(self)

		if self.Item and self.Root.AutoActionTask then
			_AutoGenItemBlackList[self.Item] = true
			self.Root.AutoActionTask:RestartTask()
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function GenerateBrother(self, row, col, force)
		row = row or self.RowCount
		col = col or self.ColCount

		if row <= 1 then row = 1 end
		if col <= 1 then col = 1 end
		if row > ceil(_MaxBrother / col) then row = ceil(_MaxBrother / col) end

		--if self.Header == self and not self.FreeMode then
		if self.Header == self then
			if force or self.RowCount ~= row or self.ColCount ~= col then
				local w, h, marginX, marginY, index, brother, last = self.Width, self.Height, self.MarginX, self.MarginY, 1, self
				local tail

				for i = 1, row do
					if index > _MaxBrother then break end
					for j = 1, col do
						if index > _MaxBrother then break end

						if index > 1 then
							if not brother.Brother then
								brother.Brother = _Recycle_IButtons()
							end
							brother = brother.Brother
							brother:ClearAllPoints()
							brother:SetPoint("TOPLEFT", self, "TOPLEFT", (w + marginX) * (j-1), - (h + marginY) * (i-1))
						end

						if brother.ITail then
							tail = brother.ITail
						end

						index = index + 1
					end
				end

				-- Recycle useless button
				last = brother.Brother
				brother.Brother = nil

				while last do
					if last.ITail then
						tail = last.ITail
					end
					tinsert(_TempActionBrother, last)
					last = last.Brother
				end

				if tail then
					tail.ActionButton = brother
				end

				for i = #_TempActionBrother, 1, -1 do
					_TempActionBrother[i]:GenerateBranch(0)
				end

				for i = #_TempActionBrother, 1, -1 do
					_Recycle_IButtons(_TempActionBrother[i])
				end

				wipe(_TempActionBrother)

				self.RowCount, self.ColCount = row, col

				return brother
			end
		end
	end

	function GenerateBranch(self, num, force)
		num = num or self.BranchCount

		local blockGridUpdating = self.BlockGridUpdating

		if self.Root == self and not InCombatLockdown() then
			if force or self.BranchCount ~= num then
				local w, h, marginX, marginY, branch, last = self.Width, self.Height, self.MarginX, self.MarginY, self
				local dir = self.FlyoutDirection

				for i = 1, num do
					if not branch.Branch then
						branch.Branch = _Recycle_IButtons()
					end
					branch = branch.Branch
					branch:ClearAllPoints()
					branch.BlockGridUpdating = blockGridUpdating

					if dir == FlyoutDirection.LEFT then
						branch:SetPoint("LEFT", self, "LEFT", -(w + marginX) * i, 0)
					elseif dir == FlyoutDirection.RIGHT then
						branch:SetPoint("LEFT", self, "LEFT", (w + marginX) * i, 0)
					elseif dir == FlyoutDirection.UP then
						branch:SetPoint("TOP", self, "TOP", 0, (h + marginY) * i)
					elseif dir == FlyoutDirection.DOWN then
						branch:SetPoint("TOP", self, "TOP", 0, -(h + marginY) * i)
					end
				end

				-- Recycle useless button
				last = branch.Branch
				branch.Branch = nil

				while last do
					tinsert(_TempActionBranch, last)
					last = last.Branch
				end

				for i = #_TempActionBranch, 1, -1 do
					_Recycle_IButtons(_TempActionBranch[i])
				end

				wipe(_TempActionBranch)

				self.BranchCount = num
				self.ShowFlyOut = num > 0 and (not self.LockMode or not self.FreeMode)
				if num == 0 and self.AutoActionTask then
					self.AutoActionTask:RemoveRoot(self)
					self.AutoActionTask = nil
					self:SetAutoGenAction(nil)
				end
				if num > 0 then
					self:SetAttribute("type2", "custom")
				else
					self:SetAttribute("type2", nil)
				end
			end
		end
		return UpdateExpansion(self, self.Expansion)
	end

	function RegenerateFlyout(self)
		local flyoutID = self.ActionTarget
		local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID)

		if numSlots and numSlots > 0 and isKnown then
			local changed = false

			if not _SpellFlyoutMap[self] then
				changed = true
				_SpellFlyoutMap[self] = {}
			end

			local map = _SpellFlyoutMap[self]

			local j = 1
			for i = 1, numSlots do
				local spellID, _, isKnown = GetFlyoutSlotInfo(flyoutID, i)
				if isKnown then
					if changed then
						map[j] = spellID
					elseif map[j] ~= spellID then
						changed = true
						map[j] = spellID
					end
					j = j + 1
				end
			end

			for i = #map, j, -1 do
				tremove(map)
				changed = true
			end

			if changed then
				if not self.FreeMode then
					self:GenerateBranch(#map)
					for i = 1, #map do
						self = self.Branch
						self.Spell = map[i]
					end
				else
					self = self.Branch
					local i = 1
					while self do
						if map[i] then
							self.Spell = map[i]
						else
							self:SetAction(nil)
						end

						i = i + 1
						self = self.Branch
					end
				end
			end
		else
			self:ClearFlyout()
		end
	end

	function ClearFlyout(self)
		if _SpellFlyoutMap[self] then
			_SpellFlyoutMap[self] = nil

			if not self.FreeMode then
				self:GenerateBranch(0)
			else
				self = self.Branch
				while self do
					self:SetAction(nil)
					self = self.Branch
				end
			end
		end
	end

	function UpdateAction(self)
		if self.ActionType == "flyout" then
			if self.Root ~= self then
				return Task.NoCombatCall(function ()
					self:SetAction(nil)
				end)
			else
				Task.NoCombatCall(function()
					self:SetAttribute("isflyoutspell", true)
					self:SetAttribute("type1", "custom")
					self:RegenerateFlyout()
				end)
			end
		elseif self:GetAttribute("isflyoutspell") then
			Task.NoCombatCall(function()
				self:SetAttribute("type1", nil)
				self:SetAttribute("isflyoutspell", nil)
				self:ClearFlyout()
			end)
		end
		if self.UseBlizzardArt then
			return Super.UpdateAction(self)
		end
	end

	function SetAutoGenAction(self, kind, ...)
		if kind then
			self:SetAttribute("AutoGenerated", true)
			self:SetAttribute("alt-type2", "custom")
		else
			self:SetAttribute("AutoGenerated", nil)
			self:SetAttribute("alt-type2", nil)
		end
		return self:SetAction(kind, ...)
	end

	function SetUpCooldownIndicator(self, indicator)
		indicator:SetHideCountdownNumbers(true)
		indicator:SetPoint("TOPLEFT", 2, -2)
		indicator:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	------------------------------------------------------
	-- Static Property
	------------------------------------------------------
	__Static__() __Handler__(function (self, value)
		Task.NoCombatCall(function ()
			_ManagerFrame:SetAttribute("PopupDuration", value)
		end)
	end)
	property "PopupDuration" { Type = NumberNil, Default = 0.25 }

	------------------------------------------------------
	-- Interface Property
	------------------------------------------------------
	property "IFMovingGroup" { Set = false, Default = _IGASUI_ACTIONBAR_GROUP }
	property "IFResizingGroup" { Set = false, Default = _IGASUI_ACTIONBAR_GROUP }
	property "IFActionHandlerGroup" { Set = false, Default = _IGASUI_ACTIONBAR_GROUP }

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "RowCount" { Type = Number, Default = 1 }
	property "ColCount" { Type = Number, Default = 1 }
	property "BranchCount" { Type = Number }

	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
			if value then
				self:GetChild("Icon"):SetTexCoord(0.06, 0.94, 0.06, 0.94)
			end
		end,
		Type = String+Number,
	}

	property "Visible" {
		Get = function(self)
			return self:IsShown() and true or false
		end,
		Set = function(self, value)
			if self.Visible ~= value then
				if value then
					self:Show()
					if self.StanceBar then
						local btn = self.Brother
						while btn and btn.Spell do
							btn:Show()
							btn = btn.Brother
						end
						return
					end
				else
					self:Hide()
				end
				if self.Brother then
					self.Brother.Visible = value
				end
				if not value and self.Branch then
					self.Branch.Visible = value
				end
			end
		end,
		Type = Boolean,
	}

	property "Expansion" {
		Handler = function (self, value)
			return Task.NoCombatCall(UpdateExpansion, self, value)
		end,
		Field = "__Expansion",
		Type = Boolean,
	}

	property "Brother" {
		Handler = function (self, value)
			if value then
				value.Header = self.Header
				value.FreeMode = self.FreeMode
				value.Scale = self.Scale
				value.ID = self.ID + 1
				value.ActionBar = self.ActionBar
				value.MainBar = self.MainBar
				value.LockMode = self.LockMode
				value.AutoSwapRoot = self.AutoSwapRoot
				value:SetSize(self:GetSize())

				if self.ITail then
					self.ITail.ActionButton = value
				end
			end
		end,
		Type = IActionButton,
	}

	property "Branch" {
		Handler = function (self, value)
			if value then
				value.Root = self.Root
				value.Header = self.Header
				value.FreeMode = self.FreeMode
				value.Scale = self.Scale
				value.LockMode = self.LockMode
				value:SetSize(self:GetSize())
			end
		end,
		Type = IActionButton,
	}

	property "Header" {
		Get = function(self)
			return self.__Header or self
		end,
		Set = function(self, value)
			if value == self then value = nil end

			if self.__Header ~= value then
				self.__Header = value
				if value then
					RegisterBrother(self, value)
				else
					RemoveBrother(self)
				end
			end
		end,
		Type = IActionButton,
	}

	property "Root" {
		Get = function(self)
			return self.__Root or self
		end,
		Set = function(self, value)
			if value == self then value = nil end

			if self.__Root ~= value then
				self.__Root = value
				if value then
					RegisterBranch(self, value)
				else
					RemoveBranch(self)
				end
			end
		end,
		Type = IActionButton,
	}

	property "ActionBar" {
		Get = function(self)
			return self.ActionPage
		end,
		Set = function(self, value)
			if self.ActionBar ~= value then
				self.ActionPage = value
				if self.Brother then
					self.Brother.ActionBar = value
				end
			end
		end,
		Type = NumberNil,
	}

	property "MainBar" {
		Get = function(self)
			return self.MainPage
		end,
		Set = function(self, value)
			if self.MainBar ~= value then
				self.MainPage = value
				if self.Brother then
					self.Brother.MainBar = value
				end
			end
		end,
		Type = Boolean,
	}

	property "PetBar" {
		Handler = function (self, value)
			if value and self.ReplaceBlzMainAction then return end

			if value then
				Task.NoCombatCall(function()
					self:GenerateBrother(1, _G.NUM_PET_ACTION_SLOTS)
					local brother = self
					while brother do
						brother:GenerateBranch(0)
						brother:SetAction("pet", brother.ID)
						brother = brother.Brother
					end
					RegisterPetAction(self)
				end)
			else
				Task.NoCombatCall(function()
					UnregisterPetAction(self)
					self:GenerateBrother(1, 1)
					self:SetAction(nil)
				end)
			end
		end,
		Type = Boolean,
	}

	property "StanceBar" {
		Handler = function (self, value)
			if value and self.ReplaceBlzMainAction then return end

			if value then
				Task.NoCombatCall(function()
					self:GenerateBrother(1, _G.NUM_STANCE_SLOTS)
					self:GenerateBranch(0)
					RegisterStanceBar(self)
				end)
			else
				Task.NoCombatCall(function()
					UnregisterStanceBar(self)
					self:GenerateBrother(1, 1)
					self:GenerateBranch(0)
					self:SetAction(nil)
				end)
			end
		end,
		Type = Boolean,
	}

	local function HandlerAutoHide(self)
		if self.Root.Header == self then
			if self.AutoHideCondition and next(self.AutoHideCondition) then
				local cond = ""
				for k in pairs(self.AutoHideCondition) do cond = cond .. k .. "hide;" end
				cond = cond .. "show;"
				RegisterAutoHide(self, cond, self.AutoFadeOut)
				if not self.AutoFadeOut then
					SetBlockGridUpdating(self, false)
					self.FadeAlpha = 1
				end
			else
				UnregisterAutoHide(self)

				self:SetAttribute("autofadeout", self.AutoFadeOut)
				if self.AutoFadeOut then self:OnLeave() end
				SetBlockGridUpdating(self, self.AutoFadeOut)
			end
		end
	end

	property "AutoHideCondition" {
		Handler = HandlerAutoHide,
		Type = Table,
	}

	property "AutoFadeOut" {
		Handler = HandlerAutoHide,
		Type = Boolean,
	}

	property "AutoSwapRoot" {
		Handler = function (self, value)
			if value then
				Task.NoCombatCall(RegisterAutoSwap, self)
			else
				Task.NoCombatCall(UnregisterAutoSwap, self)
			end

			if self.Brother then
				self.Brother.AutoSwapRoot = value
			end
		end,
		Type = Boolean,
	}

	property "Parent" {
		Get = function(self)
			return self:GetParent()
		end,
		Set = function(self, parent)
			self:SetParent(parent)
			if self.Brother then
				self.Brother.Parent = parent
			end
			if self.Branch then
				self.Branch.Parent = parent
			end
		end,
		Type = UIObject,
	}

	property "FrameLevel" {
		Get = function(self)
			return self:GetFrameLevel()
		end,
		Set = function(self, level)
			self:SetFrameLevel(level)
			if self.Brother then
				self.Brother.FrameLevel = level
			end
			if self.Branch then
				self.Branch.FrameLevel = level
			end
		end,
		Type = Number,
	}

	property "FreeMode" {
		Get = function(self)
			return self.IFMovable or self.IFResizable
		end,
		Set = function(self, value)
			if self.FreeMode == value then return end
			if value and self.ReplaceBlzMainAction then return end

			self.IFMovable = value
			self.IFResizable = value

			if not value then
				self:SetSize(36, 36)
			end

			if self.Header == self then
				self:GenerateBrother(nil, nil, true)
			end
			if self.Root == self and not value then
				self:GenerateBranch(nil, true)
			end
			if self.Brother then
				self.Brother.FreeMode = value
			end
			if self.Branch then
				self.Branch.FreeMode = value
			end
			if self.ITail then
				self.ITail.Visible = not self.LockMode and not self.FreeMode
			end

			self.ShowFlyOut = self.BranchCount > 0 and (not self.LockMode or not self.FreeMode)
		end,
		Type = Boolean,
	}

	property "LockMode" {
		Field = "__LockMode",
		Set = function(self, value)
			if not value and self.ReplaceBlzMainAction then return end
			self.__LockMode = value
			self.ShowGrid = self.AlwaysShowGrid or not value
			if self.Brother then
				self.Brother.LockMode = value
			end
			if self.Branch then
				self.Branch.LockMode = value
			end
			if self.IHeader then
				self.IHeader.Checked = value
			end
			if self.ITail then
				self.ITail.Visible = not self.LockMode and not self.FreeMode
			end

			self.ShowFlyOut = self.BranchCount > 0 and (not self.LockMode or not self.FreeMode)
		end,
		Type = Boolean,
	}

	property "AlwaysShowGrid" {
		Field = "__AlwaysShowGrid",
		Set = function(self, value)
			self.__AlwaysShowGrid = value
			self.ShowGrid = value or not self.LockMode
			if self.Brother then
				self.Brother.AlwaysShowGrid = value
			end
			if self.Branch then
				self.Branch.AlwaysShowGrid = value
			end
		end,
		Type = Boolean,
	}

	property "MarginX" {
		Get = function(self)
			if self.Header == self then
				return self.__MarginX or 0
			else
				return self.Header.MarginX
			end
		end,
		Set = function(self, value)
			if self.Header == self and self.__MarginX ~= value then
				self.__MarginX = value
				self:GenerateBrother(nil, nil, true)
				while self do
					self:GenerateBranch(nil, true)
					self = self.Brother
				end
			end
		end,
		Type = Number,
	}

	property "MarginY" {
		Get = function(self)
			if self.Header == self then
				return self.__MarginY or 0
			else
				return self.Header.MarginY
			end
		end,
		Set = function(self, value)
			if self.Header == self and self.__MarginY ~= value then
				self.__MarginY = value
				self:GenerateBrother(nil, nil, true)
				while self do
					self:GenerateBranch(nil, true)
					self = self.Brother
				end
			end
		end,
		Type = Number,
	}

	property "Scale" {
		Get = function(self)
			return self:GetScale()
		end,
		Set = function(self, scale)
			self:SetScale(scale)
			if self.Brother then
				self.Brother.Scale = scale
			end
			if self.Branch then
				self.Branch.Scale = scale
			end
		end,
		Type = Number,
	}

	property "ReplaceBlzMainAction" {
		Get = function(self)
			if self.Header == self then
				return self.__ReplaceBlzMainAction or false
			else
				return self.Header.ReplaceBlzMainAction
			end
		end,
		Set = function(self, value)
			if self.Header == self and self.ReplaceBlzMainAction ~= value then
				self.__ReplaceBlzMainAction = value
				if value then
					Task.NoCombatCall(function()
						self.FreeMode = false
						self.LockMode = true
						self.HideOutOfCombat = false
						self.HideInPetBattle = false
						self.HideInVehicle = false
						self:GenerateBrother(1, 12)
						self:ClearAllPoints()
						self:SetPoint("BOTTOMLEFT", IGAS.MainMenuBarArtFrame, "BOTTOMLEFT", 8, 4)
						self.Parent = IGAS.MainMenuBarArtFrame
						self.FrameLevel = _G["ActionButton1"]:GetFrameLevel() + 1
						local btn
						for i = 1, 12 do
							_G["ActionButton"..i]:SetAlpha(0)
						end
					end)
				else
					Task.NoCombatCall(function()
						self.LockMode = false
						self:ClearAllPoints()
						self.Parent = IGAS.UIParent
						self:SetPoint("CENTER")
						local btn
						for i = 1, 12 do
							_G["ActionButton"..i]:SetAlpha(1)
						end
					end)
				end
			end
		end,
		Type = Boolean,
	}

	property "FadeAlpha" {
		Get = function(self)
			return self:GetAlpha()
		end,
		Set = function(self, alpha)
			if self.Root.Header == self then
				if self.ShowGrid then
					while self do
						self:SetAlpha(alpha)
						local branch = self.Branch
						while branch do
							branch:SetAlpha(alpha)
							branch = branch.Branch
						end
						self = self.Brother
					end
				else
					while self do
						self:SetAlpha( self:HasAction() and alpha or 0 )
						local branch = self.Branch
						while branch do
							branch:SetAlpha( branch:HasAction() and alpha or 0 )
							branch = branch.Branch
						end
						self = self.Brother
					end
				end
			else
				self:SetAlpha(alpha)
			end
		end,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnMouseDown(self)
		if not InCombatLockdown() and IsAltKeyDown() and not self.Branch then
			return self.Root:ThreadCall(function(self)
				local l, b, w, h = self:GetRect()
				local e = self:GetEffectiveScale()
				local x, y, num

				while IsMouseButtonDown("LeftButton") and not InCombatLockdown() and IsAltKeyDown() do
					Threading.Sleep(0.1)

					x, y = GetCursorPosition()
					x, y = x / e, y /e

					row = floor((b + h - y) / h)
					col = floor((x - l) / w)

					if abs(col) >= abs(row) then
						num = abs(col)
						if col >= 0 then
							self.FlyoutDirection = "RIGHT"
						else
							num = num - 1
							self.FlyoutDirection = "LEFT"
						end
					else
						num = abs(row)
						if row >= 0 then
							self.FlyoutDirection = "DOWN"
						else
							num = num - 1
							self.FlyoutDirection = "UP"
						end
					end

					if not self.FlytoutID then
						self:GenerateBranch(num)
					end
				end
			end)
		end
	end

	local function OnEnter(self)
		if not InCombatLockdown() then
			if self.IHeader then
				self.IHeader.Visible = not _DBChar.LockBar
			end
			if self.ITail then
				self.ITail.Visible = not self.LockMode and not self.FreeMode
			end
		end
		self = self.Root.Header
		if self.AutoFadeOut then
			self.__AutoFadeOutStart = false
			self.FadeAlpha = 1
		end
	end

	local function OnLeave(self)
		self = self.Root.Header

		if self:GetAttribute("autofadeout") then
			self.__AutoFadeOutStart = true
			Task.ThreadCall(function(self)
				local st = GetTime()
				local sta = self:GetAlpha() or 1
				while self.__AutoFadeOutStart and self:GetAttribute("autofadeout") do
					local alpha = (GetTime() - st) * 1.0 / 2
					if alpha >= sta then
						self.FadeAlpha = 0
						return
					end
					self.FadeAlpha = sta - alpha
					Task.Next()
				end
			end, self)
		end
	end

	local function OnCooldownUpdate(self, start, duration)
		if start and duration and _ActionBarHideGlobalCD.ENABLE then
			if duration >= 1.6 then
				-- Record the end time for check
				self._CooldownStopTime = start + duration
			else
				-- maybe GCD or active spell
				if self._CooldownStopTime and self._CooldownStopTime > GetTime() then
					-- Active spell
					self._CooldownStopTime = false
					return
				else
					self._CooldownStopTime = false
					return true
				end
			end
		end
	end

	local function OnSizeChanged(self)
		local width, height = self:GetSize()
		if math.abs(width-height) > 0.1 then
			local size = math.floor(math.min(width, height))
			self:SetSize(size, size)
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function RefreshForAutoHide(self)
		if self.AutoHideState then
			_ManagerFrame:SetAttribute("state-" .. self.AutoHideState, nil)
		elseif self.AutoFadeOut then
			self:OnLeave()
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function IActionButton(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.FrameLevel = 2
		self.Height = 36
		self.Width = 36

		self.IFMovable = false
		self.IFResizable = false
		self.ShowGrid = true
		self.ID = 1

		self.MarginX = 2
		self.MarginY = 2

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
		self.OnMouseDown = self.OnMouseDown + OnMouseDown
		self.OnCooldownUpdate = self.OnCooldownUpdate + OnCooldownUpdate
		self.OnSizeChanged = self.OnSizeChanged + OnSizeChanged

		-- callback from RestrictedEnvironment, maybe add some mechanism solve this later
		IGAS:GetUI(self).IActionHandler_UpdateExpansion = IActionHandler_UpdateExpansion
		IGAS:GetUI(self).IActionHandler_SendToBlackList = IActionHandler_SendToBlackList

		Task.NoCombatCall(SetupActionButton, self)

		self.UseBlizzardArt = true
    end
endclass "IActionButton"

class "IHeader"
	inherit "Button"

	_ClickCheckTime = 0.2

	_BackDrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\ChatFrame\\CHATFRAMEBACKGROUND",
        tile = true, tileSize = 16, edgeSize = 1,
	}
	_CheckedColor = ColorType(1, 1, 1)
	_UnCheckedColor = ColorType(0, 0, 0)


	------------------------------------------------------
	-- Event
	------------------------------------------------------
	event "OnPositionChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ActionButton
	property "ActionButton" {
		Get = function(self)
			return self.Parent
		end,
		Set = function(self, value)
			if value then
				self.Parent = value
				self:SetPoint("BOTTOMRIGHT", value, "TOPLEFT")
				self.Visible = true
				self.Checked = value.LockMode
			else
				self.Parent = nil
				self:ClearAllPoints()
				self.Visible = false
			end
		end,
		Type = Frame,
	}
	-- Checked
	property "Checked" {
		Get = function(self)
			return self.CheckedTexture.Visible
		end,
		Set = function(self, value)
			self.CheckedTexture.Visible = value
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnMouseDown(self, button)
		self.__MouseDown = GetTime()
		if button == "LeftButton" and not self.Checked and not InCombatLockdown() then
			local parent = self.Parent
			local _orgLocation = parent.Location

			Task.ThreadCall(function()
				local e = parent:GetEffectiveScale()
				local x, y

				Task.Delay(_ClickCheckTime)

				while IsMouseButtonDown("LeftButton") and not InCombatLockdown() do
					x, y = GetCursorPosition()
					x = x + self.Width * e / 2
					y = y - self.Height * e / 2

					parent:ClearAllPoints()
					parent:SetPoint("TOPLEFT", IGAS.UIParent, "BOTTOMLEFT", x / e , y /e)

					Task.Next()
				end

				parent:UpdateWithAnchorSetting(_orgLocation)

				return self:Fire("OnPositionChanged")
			end)
		end
	end

	local function OnMouseUp(self, button)
		if button == "LeftButton" then
			self.Parent:StopMovingOrSizing()
			self:Fire("OnPositionChanged")
		end
	end

	local function OnClick(self, button)
		if not self.Parent:IsClass(IActionButton) then return end
		if button == "RightButton" and not InCombatLockdown() then
			_Menu.Parent = self.Parent
			_Menu.Visible = true
		--[[elseif button == "LeftButton" then
			if (GetTime() - self.__MouseDown or 0) < _ClickCheckTime then
				self.Parent.LockMode = not self.Parent.LockMode
			end--]]
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function IHeader(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Parent = nil
		self.Name = "IHeader"
		self.Visible = false
		self.Width = 24
		self.Height = 24
		self.MouseEnabled = true
		self:RegisterForClicks("AnyUp")

		self:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
		self:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])

		local txtCheck = Texture("CheckedTexture", self)
		txtCheck.TexturePath = [[Interface\Buttons\UI-CheckBox-Check]]
		txtCheck:SetAllPoints()
		txtCheck.Visible = false

		--self.OnMouseUp = self.OnMouseUp + OnMouseUp
		self.OnMouseDown = self.OnMouseDown + OnMouseDown
		self.OnClick = self.OnClick + OnClick
    end
endclass "IHeader"

class "ITail"
	inherit "Button"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "ActionButton" {
		Get = function(self)
			return self.Parent
		end,
		Set = function(self, value)
			if value then
				self.Parent = value
				self:SetPoint("BOTTOMRIGHT", value, "BOTTOMRIGHT")
				self.Visible = not self.Parent.FreeMode and not self.Parent.LockMode
			else
				self.Parent = nil
				self:ClearAllPoints()
				self.Visible = false
			end
		end,
		Type = IActionButton,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnMouseDown(self)
		if not self.Parent.LockMode and not InCombatLockdown() then
			self:ThreadCall(function(self)
				local header = self.Parent.Header
				local l, b, w, h = header:GetRect()
				local e = header:GetEffectiveScale()
				local x, y, row, col
				local last

				while IsMouseButtonDown("LeftButton") and not InCombatLockdown() do
					Threading.Sleep(0.1)

					x, y = GetCursorPosition()
					x, y = x / e, y /e

					row = ceil((b + h - y) / h)
					col = ceil((x - l) / w)

					last = header:GenerateBrother(row, col)
					if last then
						self.ActionButton = last
					end
				end
			end)
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function ITail(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Parent = nil
		self.Name = "ITail"
		self.Visible = false
		self.Width = 16
		self.Height = 16
		self.MouseEnabled = true

		self.NormalTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]
		self.HighlightTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]]
		self.PushedTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]]

		self.OnMouseDown = self.OnMouseDown + OnMouseDown
    end
endclass "ITail"

class "AutoPopupMask"
	inherit "Button"

	_FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 8,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetParent(self, parent)
		Super.SetParent(self, parent)
		if parent then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT")
			self.Width = parent.Width
			self.Height = parent.Height
		else
			self:ClearAllPoints()
		end
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnShow(self)
		if not self.Parent then
			self.Visible = false
			return
		end
		self.Width = self.Parent.Width
		self.Height = self.Parent.Height
	end

	local function OnClick(self, button)
		autoGenerateForm.RootActionButton = self.Parent

		local pd = PopupDialog("IGAS_GUI_MSGBOX", UIParent)
		if pd.Visible then pd:GetChild("OkayBtn"):Click() end

		autoGenerateForm.Visible = true
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function AutoPopupMask(self, name, parent, ...)
    	Super(self, name, parent, ...)

		self.Visible = false

		self:SetPoint("BOTTOMLEFT")

		self.TopLevel = true
		self.FrameStrata = "TOOLTIP"
		self.MouseEnabled = true
		self:RegisterForClicks("AnyUp")

		self.Backdrop = _FrameBackdrop
		self.BackdropColor = ColorType(1, 1, 1, 1)

		self.OnShow = self.OnShow + OnShow
		self.OnClick = self.OnClick + OnClick
	end
endclass "AutoPopupMask"

class "AutoActionTask"
	enum "AutoActionTaskType" {
		"Item",
		"Toy",
		"BattlePet",
		"Mount",
		"EquipSet",
	}

	local yield = coroutine.yield
	local resume = coroutine.resume
	local running = coroutine.running
	local tpairs = Threading.Iterator
	local tconcat = table.concat

	local NUM_BAG_FRAMES = _G.NUM_BAG_FRAMES
	local _ContainerItemList = {}
	local _ContainerItemCache = {}
	local _ContainerTaskStart = 1
	local _ContainerTaskEnd = 0
	local _ContainerItemChangeTask = {}
	local _ItemMark = 0
	local _ScanTaskStarted = false

	local _ItemTaskListWithFilter = {}
	local _ItemTaskListNoFilter = {}

	local _ItemFillIter = function() end

	_GameTooltip = CreateFrame("GameTooltip", "IGAS_UI_ActionBar_Tooltip", UIParent, "GameTooltipTemplate")

	local function matchText(txt, lst)
		for _, v in ipairs(lst) do
			if txt:match(v) then
				return true
			end
		end
		return false
	end

	local function BuildFillRules()
		local defines = {}
		local scanConds = {}
		local scanCodes = {}
		local codes = {}
		local filterList = {}

		for i, task in ipairs(_ItemTaskListWithFilter) do
			local filter = {}

			task.TipFilter:gsub("[^;]+", function(w)
				w = strtrim(w)
				if w ~= "" then
					tinsert(filter, w)
				end
			end)
			filterList[i] = filter

			local cond = task.ItemSubClass and
				("cls==%q and subclass==%q"):format(GetItemClassInfo(task.ItemClass), GetItemSubClassInfo(task.ItemClass, task.ItemSubClass)) or
				("cls==%q"):format(GetItemClassInfo(task.ItemClass))

			tinsert(defines, ("local isTask%d= (%s)\nlocal isFilterMatch%d=false"):format(i, cond, i))
			tinsert(scanConds, ("isTask%d"):format(i))
			tinsert(scanCodes, ("isFilterMatch%d=isFilterMatch%d or matchText(tipText,filterList[%d])"):format(i,i,i))

			tinsert(codes, ("if isTask%d and isFilterMatch%d then yield(%d, itemID, true) else"):format(i,i,i))
		end

		local filterCnt = #_ItemTaskListWithFilter

		for i, task in ipairs(_ItemTaskListNoFilter) do
			local cond = task.ItemSubClass and
				("cls==%q and subclass==%q"):format(GetItemClassInfo(task.ItemClass), GetItemSubClassInfo(task.ItemClass, task.ItemSubClass)) or
				("cls==%q"):format(GetItemClassInfo(task.ItemClass))

			tinsert(defines, ("local isTask%d=(%s)"):format(i+filterCnt, cond))

			tinsert(codes, ("if isTask%d then yield(%d, itemID, false) else"):format(i+filterCnt,i))
		end

		if #codes == 0 then
			return function() end
		else
			tinsert(codes, " end")
		end

		codes = tconcat(codes, "") or "if true then return end"

		codes = ([[
			local _ContainerItemList, _ItemTaskListWithFilter, _ItemTaskListNoFilter, filterList, matchText = ...
			local GetItemInfo = GetItemInfo
			local GameTooltip = IGAS_UI_ActionBar_Tooltip
			local yield = coroutine.yield
			local ipairs = ipairs
			local pcall = pcall
			local SetInventoryItem = GameTooltip.SetInventoryItem
			local SetItemByID = GameTooltip.SetItemByID

			return function()
				for _, itemID in ipairs(_ContainerItemList) do
					local name, _, _, iLevel, reqLevel, cls, subclass, maxStack, equipSlot, _, vendorPrice = GetItemInfo(itemID)

					%s

					if %s then
						local ok, msg

						GameTooltip:SetOwner(UIParent)
						ok, msg = pcall(SetItemByID, GameTooltip, itemID)

						if ok then
							local i = 1
							local t = _G["IGAS_UI_ActionBar_TooltipTextLeft"..i]

							while t and t:IsShown() do
								local tipText = t:GetText()
								if tipText and tipText ~= "" then
									%s
								end

								i = i + 1
								t = _G["IGAS_UI_ActionBar_TooltipTextLeft"..i]
							end
						end
						GameTooltip:Hide()
					end

					%s
				end
			end
		]]):format(tconcat(defines, "\n"), #scanConds>0 and tconcat(scanConds, " or ") or "false", tconcat(scanCodes, "\n"), codes)

		return loadstring(codes)(_ContainerItemList, _ItemTaskListWithFilter, _ItemTaskListNoFilter, filterList, matchText)
	end

	local function AutoGenForItems()
		-- Clear to go
		for _, task in ipairs(_ItemTaskListWithFilter) do task.rIdx = 1 task.curBtn = nil task.curCnt = 0 end
		for _, task in ipairs(_ItemTaskListNoFilter) do task.rIdx = 1 task.curBtn = nil task.curCnt = 0 end

		-- Generate buttons
		for i, itemID, isFilter in tpairs(_ItemFillIter) do
			local self = isFilter and _ItemTaskListWithFilter[i] or _ItemTaskListNoFilter[i]
			local root = self.Roots[self.rIdx]

			while root do
				local autoGen = self.AutoGenerate and not root.FreeMode
				local maxAction = autoGen and self.MaxAction or 24
				local btn = self.curBtn or root

				if self.curCnt < maxAction then
					if self.curCnt > 0 then
						if not btn.Branch then
							if autoGen then
								root:GenerateBranch(self.curCnt)
								btn.Branch.Visible = btn.Visible
								btn = btn.Branch
								btn:SetAutoGenAction("item", itemID)
								self.curCnt = self.curCnt + 1
								self.curBtn = btn
								break
							end
						else
							btn = btn.Branch
							btn:SetAutoGenAction("item", itemID)
							self.curCnt = self.curCnt + 1
							self.curBtn = btn
							break
						end
					else
						btn:SetAutoGenAction("item", itemID)
						self.curCnt = self.curCnt + 1
						self.curBtn = btn
						break
					end
				end

				if autoGen then
					root:GenerateBranch(self.curCnt > 1 and self.curCnt - 1 or 1)
				end

				self.rIdx = self.rIdx + 1
				root = self.Roots[self.rIdx]
				self.curCnt = 0
				self.curBtn = nil
			end
		end

		-- Clear buttons
		for _, task in ipairs(_ItemTaskListWithFilter) do
			local root = task.Roots[task.rIdx]
			if root then
				local autoGen = task.AutoGenerate and not root.FreeMode
				local maxAction = autoGen and task.MaxAction or 24
				local btn = task.curBtn or root

				if autoGen then
					root = btn.Root
					root:GenerateBranch(task.curCnt > 1 and task.curCnt - 1 or 1)
					if task.curCnt <= 1 then root.Branch:SetAutoGenAction(nil) end
					if task.curCnt <= 0 then root:SetAutoGenAction(nil) end
				else
					btn = btn.Branch
					while btn do
						btn:SetAutoGenAction(nil)
						btn = btn.Branch
					end
				end
			end

			-- Clear
			for idx = task.rIdx + 1, #task.Roots do
				local root = task.Roots[idx]
				local autoGen = task.AutoGenerate and not root.FreeMode

				if autoGen then
					root:GenerateBranch(1)
					root.Branch:SetAutoGenAction(nil)
					root:SetAutoGenAction(nil)
				else
					while root do
						root:SetAutoGenAction(nil)
						root = root.Branch
					end
				end
			end
		end

		for _, task in ipairs(_ItemTaskListNoFilter) do
			local root = task.Roots[task.rIdx]
			if root then
				local autoGen = task.AutoGenerate and not root.FreeMode
				local maxAction = autoGen and task.MaxAction or 24
				local btn = task.curBtn or root

				if autoGen then
					root = btn.Root
					root:GenerateBranch(task.curCnt > 1 and task.curCnt - 1 or 1)
					if task.curCnt <= 1 then root.Branch:SetAutoGenAction(nil) end
					if task.curCnt <= 0 then root:SetAutoGenAction(nil) end
				else
					btn = btn.Branch
					while btn do
						btn:SetAutoGenAction(nil)
						btn = btn.Branch
					end
				end
			end

			-- Clear
			for idx = task.rIdx + 1, #task.Roots do
				local root = task.Roots[idx]
				local autoGen = task.AutoGenerate and not root.FreeMode

				if autoGen then
					root:GenerateBranch(1)
					root.Branch:SetAutoGenAction(nil)
					root:SetAutoGenAction(nil)
				else
					while root do
						root:SetAutoGenAction(nil)
						root = root.Branch
					end
				end
			end
		end
	end

	local function ScanContainerItems()
		while true do
			if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
			while InCombatLockdown() do Task.Delay(0.1) end

			local index = 0
			local itemChanged = false
			_ItemMark = _ItemMark + 1

			for bag = 0, NUM_BAG_FRAMES do
				for slot = 1, GetContainerNumSlots(bag) do
					local itemID = GetContainerItemID(bag, slot)
					if itemID and GetItemSpell(itemID) and not _AutoGenItemBlackList[itemID] and _ContainerItemCache[itemID] ~= _ItemMark then
						-- Cache the item with mark
						_ContainerItemCache[itemID] = _ItemMark

						index = index + 1

						if _ContainerItemList[index] ~= itemID then
							-- Item list changed
							itemChanged = true
							_ContainerItemList[index] = itemID
						end
					end
				end
			end

			for i = #_ContainerItemList, index+1, -1 do
				itemChanged = true
				_ContainerItemList[i] = nil
			end

			if itemChanged then
				Debug("Container items changed, start updating")

				AutoGenForItems()

				--[[local startp, endp = _ContainerTaskStart, _ContainerTaskEnd
				_ContainerTaskStart = _ContainerTaskEnd + 1
				for i = startp, endp do
					local th = _ContainerItemChangeTask[i]
					_ContainerItemChangeTask[i] = nil
					resume(th)
				end--]]
			else
				Debug("Container items nochange")
			end

			Task.Event("BAG_UPDATE_DELAYED")
			Task.Next()
		end
	end

	local function getItem(self)
		local itemCls = self.ItemClass
		local itemSubCls = self.ItemSubClass

		for _, itemID in ipairs(_ContainerItemList) do
			if not _AutoGenItemBlackList[itemID] then
				local pass = true
				if itemCls then
					local cls, subclass = select(12, GetItemInfo(itemID))
					pass = itemCls == cls and (not itemSubCls or subclass == itemSubCls)
				end
				if pass then
					yield("item", itemID)
				end
			end
		end
	end

	local function getToy(self)
		local onlyFavourite = self.OnlyFavourite
		for i = 1, C_ToyBox.GetNumToys() do
			local index = C_ToyBox.GetToyFromIndex(i)
			if index > 0 then
				local item = C_ToyBox.GetToyInfo(index)
				if item and PlayerHasToy(item) and C_ToyBox.IsToyUsable(item) and (GetItemCooldown(item) or 0) == 0 then
					if not onlyFavourite or C_ToyBox.GetIsFavorite(item) then
						yield("item", item)
					end
				end
			end
		end
	end

	local function getBattlePet(self)
		local onlyFavourite = self.OnlyFavourite
		local generated = {}
		for index = 1, C_PetJournal.GetNumPets() do
			local petID, speciesID, isOwned, _, _, favorite = C_PetJournal.GetPetInfoByIndex(index)
			if isOwned and not generated[speciesID] and (not onlyFavourite or favorite) then
				generated[speciesID] = true
				yield("battlepet", petID)
			end
		end
		generated = nil
	end

	local mountIDS

	local function getMount(self)
		mountIDS = mountIDS or C_MountJournal.GetMountIDs()

		local onlyFavourite = self.OnlyFavourite
		for _, id in ipairs(mountIDS) do
			local creatureName, creatureID, _, _, summonable, _, isFavorite, _, _, _, owned = C_MountJournal.GetMountInfoByID(id)
			if owned and summonable then
				if not onlyFavourite or isFavorite then
					yield("mount", id)
				end
			end
		end
	end

	local function getEquipSet(self)
		local index = 1
		local name = GetEquipmentSetInfo(index)
		while name do
			yield("equipmentset", name)

			index = index + 1
			name = GetEquipmentSetInfo(index)
		end
	end

	local function generateByTask(self, iter)
		local roots = self.Roots
		local rIdx = 1
		local root = roots[rIdx]
		if not root then return true end
		local btn = root
		local cnt = 0
		local autoGen = self.AutoGenerate and not root.FreeMode
		local maxAction = autoGen and self.MaxAction or 24

		for ty, target, detail in tpairs(iter), self do
			while root do
				if cnt < maxAction then
					if cnt > 0 then
						if not btn.Branch then
							if autoGen then
								root:GenerateBranch(cnt)
								btn.Branch.Visible = btn.Visible
								btn = btn.Branch
								btn:SetAutoGenAction(ty, target, detail)
								cnt = cnt + 1
								break
							end
						else
							btn = btn.Branch
							btn:SetAutoGenAction(ty, target, detail)
							cnt = cnt + 1
							break
						end
					else
						btn:SetAutoGenAction(ty, target, detail)
						cnt = cnt + 1
						break
					end
				end

				if autoGen then
					root:GenerateBranch(cnt > 1 and cnt - 1 or 1)
				end

				rIdx = rIdx + 1
				root = roots[rIdx]
				if root then
					btn = root
					cnt = 0
					autoGen = self.AutoGenerate and not root.FreeMode
					maxAction = autoGen and self.MaxAction or 24
				end
			end
		end

		if autoGen then
			root = btn.Root
			root:GenerateBranch(cnt > 1 and cnt - 1 or 1)
			if cnt <= 1 then root.Branch:SetAutoGenAction(nil) end
			if cnt <= 0 then root:SetAutoGenAction(nil) end
		else
			btn = btn.Branch
			while btn do
				btn:SetAutoGenAction(nil)
				btn = btn.Branch
			end
		end

		-- Clear
		for rIdx = rIdx + 1, #self.Roots do
			root = roots[rIdx]
			autoGen = self.AutoGenerate and not root.FreeMode

			if autoGen then
				root:GenerateBranch(1)
				root.Branch:SetAutoGenAction(nil)
				root:SetAutoGenAction(nil)
			else
				while root do
					root:SetAutoGenAction(nil)
					root = root.Branch
				end
			end
		end
	end

	local function itemTask(self, iter)
		local mark = self.TaskMark
		local thread = running()

		while self.TaskMark and mark == self.TaskMark do
			if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
			while InCombatLockdown() do Task.Delay(0.1) end
			if not self.TaskMark or mark ~= self.TaskMark then break end

			Log(1, "Process auto-gen [%s] %s @pid %d", self.Type, self.Name, mark)

			if generateByTask(self, iter) then break end

			_ContainerTaskEnd = _ContainerTaskEnd + 1
			_ContainerItemChangeTask[_ContainerTaskEnd] = thread

			yield() -- Wait until item list changed
		end

		Log(1, "Stop auto-gen [%s] %s @pid %d", self.Type, self.Name, mark)
	end

	local function task(self, iter, ...)
		local mark = self.TaskMark

		while self.TaskMark and mark == self.TaskMark do
			if InCombatLockdown() then Task.Event("PLAYER_REGEN_ENABLED") end
			while InCombatLockdown() do Task.Delay(0.1) end
			if not self.TaskMark or mark ~= self.TaskMark then break end

			Log(1, "Process auto-gen [%s] %s @pid %d", self.Type, self.Name, mark)

			if generateByTask(self, iter) then break end

			Task.Wait(...)
			Task.Delay(0.1) --Use delay to block too many BAG_UPDATE at a same time
		end

		Log(1, "Stop auto-gen [%s] %s @pid %d", self.Type, self.Name, mark)
	end

	function AddRoot(self, root)
		self.Roots = self.Roots or {}
		if root.AutoActionTask == self then return end
		for _, r in ipairs(self.Roots) do if r == root then return end end
		if root.AutoActionTask then root.AutoActionTask:RemoveRoot(root) end
		tinsert(self.Roots, root)
		root.AutoActionTask = self
		return self:RestartTask()
	end

	function RemoveRoot(self, root)
		if self.Roots then
			for i, r in ipairs(self.Roots) do
				if r == root then
					tremove(self.Roots, i)
					root.AutoActionTask = nil

					return self:RestartTask()
				end
			end
		end
	end

	function RestartTask(self)
		self:StopTask()

		if self.Roots and #self.Roots > 0 then
			return self:StartTask()
		end
	end

	__Static__()
	__Arguments__{ AutoActionTaskType }
	function RestartAllTaskByType(type)
		for k, task in pairs(_AutoActionTask) do
			if task.Type == type then
				task:RestartTask()
			end
		end
	end

	function StartTask(self)
		self.TaskMark = self.TaskMark or 0

		if self.Type == AutoActionTaskType.Item then
			if not _ScanTaskStarted then _ScanTaskStarted = true Task.ThreadCall(ScanContainerItems) end

			if self.TipFilter then
				local existed = false
				for i, task in ipairs(_ItemTaskListWithFilter) do
					if task == self then existed = true break end
				end
				if not existed then
					for i, task in ipairs(_ItemTaskListNoFilter) do
						if task == self then
							tremove(_ItemTaskListNoFilter, i)
							break
						end
					end

					tinsert(_ItemTaskListWithFilter, self)
				end
			else
				local existed = false
				for i, task in ipairs(_ItemTaskListNoFilter) do
					if task == self then existed = true break end
				end
				if not existed then
					for i, task in ipairs(_ItemTaskListWithFilter) do
						if task == self then
							tremove(_ItemTaskListWithFilter, i)
							break
						end
					end

					tinsert(_ItemTaskListNoFilter, self)
				end
			end

			_ItemFillIter = BuildFillRules()

			return Task.NoCombatCall(AutoGenForItems)

			-- return Task.ThreadCall(itemTask, self, getItem)
		elseif self.Type == AutoActionTaskType.Toy then
			return Task.ThreadCall(task, self, getToy, "TOYS_UPDATED", "SPELL_UPDATE_COOLDOWN")
		elseif self.Type == AutoActionTaskType.BattlePet then
			return Task.ThreadCall(task, self, getBattlePet, "PET_JOURNAL_LIST_UPDATE", "PET_JOURNAL_PET_DELETED")
		elseif self.Type == AutoActionTaskType.Mount then
			return Task.ThreadCall(task, self, getMount, "COMPANION_LEARNED", "COMPANION_UNLEARNED", "MOUNT_JOURNAL_USABILITY_CHANGED", "COMPANION_UPDATE")
		elseif self.Type == AutoActionTaskType.EquipSet then
			return Task.ThreadCall(task, self, getEquipSet, "EQUIPMENT_SETS_CHANGED")
		end
	end

	function StopTask(self)
		self.TaskMark = (self.TaskMark or 0) + 1

		local removed = false

		if self.Type == AutoActionTaskType.Item then
			for i, task in ipairs(_ItemTaskListNoFilter) do
				if task == self then
					removed = true
					tremove(_ItemTaskListNoFilter, i)
					break
				end
			end

			for i, task in ipairs(_ItemTaskListWithFilter) do
				if task == self then
					removed = true
					tremove(_ItemTaskListWithFilter, i)
					break
				end
			end

			if removed then
				_ItemFillIter = BuildFillRules()

				return Task.NoCombatCall(AutoGenForItems)
			end
		end
	end

	property "Name" { Type = String }

	__Handler__(RestartTask)
	property "Type" { Type = AutoActionTaskType }

	property "OnlyFavourite" { Type = Boolean }

	property "AutoGenerate" { Type = Boolean }

	property "MaxAction" { Type = NaturalNumber }

	property "ItemClass" { Type = Number }

	property "ItemSubClass" { Type = NumberNil }

	property "TipFilter" { Type = String }

	_AutoActionTask = {}

	function Dispoe(self)
		self:StopTask()
		if self.Roots then for _, root in ipairs(self.Roots) do root.AutoActionTask = nil end end
		self.Roots = nil
		_AutoActionTask[self.Name] = nil
	end

	function AutoActionTask(self, name)
		_AutoActionTask[name] = self

		self.Name = name
		self.Type = _DBAutoPopupList[name].Type
		self.OnlyFavourite = _DBAutoPopupList[name].OnlyFavourite
		self.AutoGenerate = _DBAutoPopupList[name].AutoGenerate
		self.MaxAction = _DBAutoPopupList[name].MaxAction
		self.ItemClass = _DBAutoPopupList[name].ItemClass
		self.ItemSubClass = _DBAutoPopupList[name].ItemSubClass
		self.TipFilter = _DBAutoPopupList[name].TipFilter
	end

	function __exist(name) return _AutoActionTask[name] end
endclass "AutoActionTask"

------------------------------------------------------
-- Recycle
------------------------------------------------------
_Recycle_IButtons = Recycle(IActionButton, "IActionButton%d", UIParent)
_Recycle_IHeaders = Recycle(IHeader, "IHeader%d", UIParent)
_Recycle_ITails = Recycle(ITail, "ITail%d", UIParent)
_Recycle_AutoPopupMask = Recycle(AutoPopupMask, "AutoPopupMask%d", UIParent)

function _Recycle_IButtons:OnPop(btn)
	btn.ShowGrid = true
	btn:Show()
end

function _Recycle_IButtons:OnPush(btn)
	btn:ClearAllPoints()
	btn:SetAutoGenAction(nil)
	btn.Brother = nil
	btn.Branch = nil
	btn.Header = nil
	btn.Root = nil
	btn.Expansion = false
	btn.ID = 1
	btn.ActionBar = nil
	btn.MainBar = false
	btn.PetBar = false
	btn.StanceBar = false
	btn.HideOutOfCombat = false
	btn.HideInPetBattle = false
	btn.HideInVehicle = false
	btn.AutoSwapRoot = false
	btn:Hide()
	btn:SetSize(36, 36)
	btn:ClearBindingKey()
end

function _Recycle_IHeaders:OnInit(btn)
end

function _Recycle_IHeaders:OnPush(btn)
	btn.ActionButton = nil
end

function _Recycle_ITails:OnPop(btn)

end

function _Recycle_ITails:OnPush(btn)
	btn.ActionButton = nil
end

function _Recycle_AutoPopupMask:OnPush(mask)
	mask.Parent = nil
	mask.Visible = false
end