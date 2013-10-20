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

interface "IFDeadGroupRole"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFDeadGroupRole(self)
		self:AddElement(RoleIcon)
		self.RoleIcon:SetPoint("TOPRIGHT")
		self.RoleIcon.ShowInCombat = true
    end
endinterface "IFDeadGroupRole"

partclass "iDeadUnitFrame"
	extend "IFDeadGroupRole"
endclass "iDeadUnitFrame"

AddType4Config(RoleIcon, L"Group Role indicator")