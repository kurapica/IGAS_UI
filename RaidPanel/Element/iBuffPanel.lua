-----------------------------------------
-- Buff Panel for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- iBuffPanel
-- @type class
-- @name iBuffPanel
-----------------------------------------------
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
    function iBuffPanel(...)
		local obj = Super(...)

		obj.Filter = "HELPFUL|PLAYER"
		obj.ColumnCount = 6
		obj.RowCount = 2
		obj.ElementWidth = 14
		obj.ElementHeight = 14
		obj.Orientation = Orientation.VERTICAL

		return obj
    end
endclass "iBuffPanel"

-----------------------------------------------
--- IFIBuffPanel
-- @type interface
-- @name IFIBuffPanel
-----------------------------------------------
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