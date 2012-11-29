-----------------------------------------
-- Debuff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iDebuffPanel
-- @type class
-- @name iDebuffPanel
-----------------------------------------------
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
    function iDebuffPanel(...)
		local obj = Super(...)

		obj.Filter = "HARMFUL"
		obj.ColumnCount = 6
		obj.RowCount = 1
		obj.ElementWidth = 14
		obj.ElementHeight = 14
		obj.Orientation = Orientation.HORIZONTAL

		return obj
    end
endclass "iDebuffPanel"

-----------------------------------------------
--- IFIDebuffPanel
-- @type interface
-- @name IFIDebuffPanel
-----------------------------------------------
interface "IFIDebuffPanel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIDebuffPanel(self)
		self:AddElement(iDebuffPanel)

		self.iDebuffPanel:SetPoint("BOTTOMRIGHT")
    end
endinterface "IFIDebuffPanel"

partclass "iRaidUnitFrame"
	extend "IFIDebuffPanel"
endclass "iRaidUnitFrame"
