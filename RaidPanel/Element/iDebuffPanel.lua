-----------------------------------------
-- Debuff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

OnLoad = OnLoad + function(self)
	_DB = _Addon._DB.RaidPanel or {}
	_DB.DebuffSpellList =  _DB.DebuffSpellList or {}
	_DB.DebuffBlackList = _DB.DebuffBlackList or {}

	_DebuffSpellList = _DB.DebuffSpellList
	_DebuffBlackList = _DB.DebuffBlackList
end

iDebuffFilter = Form("IGAS_UI_IDebuffFilter")
iDebuffFilter.Caption = L"Debuff list --> Black list"
iDebuffFilter.Message = L"Double click item to add/remove to the black list"
iDebuffFilter.Resizable = false
iDebuffFilter.Layout = DockLayoutPanel
iDebuffFilter.Visible = false

iDebuffScanList = List("ScanList", iDebuffFilter)
iDebuffFilter:AddWidget(iDebuffScanList, "west", 49, "pct")
iDebuffScanList.ShowTootip = true

iDebuffBlackList = List("BlackList", iDebuffFilter)
iDebuffFilter:AddWidget(iDebuffBlackList, "east", 49, "pct")
iDebuffBlackList.ShowTootip = true

function iDebuffFilter:OnShow()
	iDebuffScanList:SuspendLayout()

    iDebuffScanList:Clear()

    for spellID in pairs(_DebuffSpellList) do
        local name, _, icon = GetSpellInfo(spellID)

        iDebuffScanList:AddItem(spellID, name, icon)
    end

    iDebuffScanList:ResumeLayout()

    iDebuffBlackList:SuspendLayout()

    iDebuffBlackList:Clear()

    for spellID in pairs(_DebuffBlackList) do
        local name, _, icon = GetSpellInfo(spellID)

        iDebuffBlackList:AddItem(spellID, name, icon)
    end

    iDebuffBlackList:ResumeLayout()
end

function iDebuffScanList:OnItemDoubleClick(spellID, name, icon)
    self:RemoveItem(spellID)
    iDebuffBlackList:SetItem(spellID, name, icon)
    _DebuffSpellList[spellID] = nil
    _DebuffBlackList[spellID] = true
end

function iDebuffBlackList:OnItemDoubleClick(spellID, name, icon)
    self:RemoveItem(spellID)
    iDebuffScanList:SetItem(spellID, name, icon)
    _DebuffSpellList[spellID] = true
    _DebuffBlackList[spellID] = nil
end

function iDebuffScanList:OnGameTooltipShow(GameTooltip, spellID)
    GameTooltip:SetSpellByID(spellID)
end

function iDebuffBlackList:OnGameTooltipShow(GameTooltip, spellID)
    GameTooltip:SetSpellByID(spellID)
end

-- Menu Settings
mnuRaidPanelDebuffFilter = raidPanelConfig:AddMenuButton(L"Element Settings", L"Debuff filter")

function mnuRaidPanelDebuffFilter:OnClick()
	iDebuffFilter.Visible = true
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

		if not _DebuffSpellList[spellID] then
			_DebuffSpellList[spellID] = true
		end

		return true
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