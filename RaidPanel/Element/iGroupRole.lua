-----------------------------------------
-- Group Role Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIGroupRole
-- @type interface
-- @name IFIGroupRole
-----------------------------------------------
interface "IFIGroupRole"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIGroupRole(self)
		self:AddElement(RoleIcon)
		self.RoleIcon:SetPoint("TOPRIGHT")
		--self.RoleIcon.ShowInCombat = true
    end
endinterface "IFIGroupRole"

partclass "iRaidUnitFrame"
	extend "IFIGroupRole"
endclass "iRaidUnitFrame"
