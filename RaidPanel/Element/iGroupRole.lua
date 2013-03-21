-----------------------------------------
-- Group Role Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

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

AddType4Config(RoleIcon, L"Group Role indicator")