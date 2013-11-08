-----------------------------------------
-- Debuff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

OnLoad = OnLoad + function(self)
	_DB = _Addon._DB.RaidPanel or {}
	_DB.DebuffSpellList = nil
	_DB.DebuffBlackList = _DB.DebuffBlackList or {}

	_DebuffBlackList = _DB.DebuffBlackList

	-- Default true
	if _DB.DebuffRightMouseRemove == nil then
		_DB.DebuffRightMouseRemove = true
	end

	mnuRaidPanelDebuffRightMouseRemove.Checked = _DB.DebuffRightMouseRemove
end

iDebuffFilter = Form("IGAS_UI_IDebuffFilter")
iDebuffFilter.Caption = L"Black list"
iDebuffFilter.Message = L"Double click to remove"
iDebuffFilter.Resizable = false
iDebuffFilter:SetSize(300, 400)
iDebuffFilter.Visible = false

iDebuffBlackList = List("BlackList", iDebuffFilter)
iDebuffBlackList:SetPoint("TOPLEFT", 4, -26)
iDebuffBlackList:SetPoint("BOTTOMRIGHT", -4, 26)
iDebuffBlackList.ShowTootip = true

function iDebuffFilter:OnShow()
	iDebuffBlackList:SuspendLayout()

    iDebuffBlackList:Clear()

    for spellID in pairs(_DebuffBlackList) do
        local name, _, icon = GetSpellInfo(spellID)

        iDebuffBlackList:AddItem(spellID, name, icon)
    end

    iDebuffBlackList:ResumeLayout()
end

function iDebuffBlackList:OnItemDoubleClick(spellID, name, icon)
    self:RemoveItem(spellID)
    _DebuffBlackList[spellID] = nil
end

function iDebuffBlackList:OnGameTooltipShow(GameTooltip, spellID)
    GameTooltip:SetSpellByID(spellID)
end

-- Menu Settings
mnuRaidPanelDebuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", L"Debuff filter")

function mnuRaidPanelDebuffFilter:OnClick()
	iDebuffFilter.Visible = true
end

mnuRaidPanelDebuffRightMouseRemove = raidPanelConfig:AddMenuButton(L"Element Settings", L"Right mouse-click send debuff to black list")
mnuRaidPanelDebuffRightMouseRemove.IsCheckButton = true

function mnuRaidPanelDebuffRightMouseRemove:OnCheckChanged()
	if raidPanelConfig.Visible then
		_DB.DebuffRightMouseRemove = self.Checked

		raidPanel:Each(function (self)
			self:GetElement(iDebuffPanel):Each("MouseEnabled", _DB.DebuffRightMouseRemove)
		end)
	end
end

class "iDebuffPanel"
	inherit "AuraPanel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
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
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, index, filter)

		if _DebuffBlackList[spellID] then return false end

		return true
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnMouseUp(self, button)
		if button == "RightButton" then
			local name, _, _, _, _, _, _, _, _, _, spellID = UnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)

			if name then
				_DebuffBlackList[spellID] = true

				return self.Parent:Refresh()
			end
		end
	end

	local function OnElementAdd(self, element)
		element.MouseEnabled = _DB.DebuffRightMouseRemove
		element.OnMouseUp = element.OnMouseUp + OnMouseUp
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(self)
		self.Filter = "HARMFUL"
		self.ColumnCount = 3
		self.RowCount = 2
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.Orientation = Orientation.HORIZONTAL
		self.TopToBottom = false
		self.LeftToRight = false

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
    end
endclass "iDebuffPanel"

interface "IFIDebuffPanel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIDebuffPanel(self)
		self:AddElement(iDebuffPanel)

		self.iDebuffPanel:SetPoint("BOTTOMRIGHT")
    end
endinterface "IFIDebuffPanel"

class "iRaidUnitFrame"
	extend "IFIDebuffPanel"
endclass "iRaidUnitFrame"

AddType4Config(iDebuffPanel, L"Debuff panel")