-----------------------------------------
-- Debuff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iDebuffPanel"
	inherit "AuraPanel"

	_DebuffSpellList = {
		[6788] = true,	-- Weakened soul
		[25771] = true, -- Forbearance
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

		if name and _DebuffSpellList[spellID] then
			return true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function iDebuffPanel(self)
		self.Filter = "HARMFUL"
		self.ColumnCount = 6
		self.RowCount = 1
		self.ElementWidth = 14
		self.ElementHeight = 14
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