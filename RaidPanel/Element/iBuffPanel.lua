-----------------------------------------
-- Buff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iBuffPanel"
	inherit "AuraPanel"

	_SHOW_BUFF_SPEC = {
	}

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
		local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

		if name and caster == "player" and (_SHOW_BUFF_SPEC[spellID] or _IGASUI_HELPFUL_SPELL[spellID] or _IGASUI_HELPFUL_SPELL[name]) and duration > 0 and duration < 31 then
			return true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iBuffPanel(self)
		self.Filter = "HELPFUL|PLAYER"
		self.ColumnCount = 6
		self.RowCount = 2
		self.ElementWidth = 14
		self.ElementHeight = 14
		self.Orientation = Orientation.VERTICAL
    end
endclass "iBuffPanel"

interface "IFIBuffPanel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIBuffPanel(self)
		self:AddElement(iBuffPanel)

		self.iBuffPanel:SetPoint("LEFT")
    end
endinterface "IFIBuffPanel"

partclass "iRaidUnitFrame"
	extend "IFIBuffPanel"
endclass "iRaidUnitFrame"

AddType4Config(iBuffPanel, L"Buff panel")