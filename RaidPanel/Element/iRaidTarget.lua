-----------------------------------------
-- Raid Target Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

interface "IFIRaidTarget"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIRaidTarget(self)
		self:AddElement(RaidTargetIcon)
		self.RaidTargetIcon:SetPoint("CENTER", self.RaidTargetIcon.Parent, "TOP")
    end
endinterface "IFIRaidTarget"

class "iRaidUnitFrame"
	extend "IFIRaidTarget"
endclass "iRaidUnitFrame"

AddType4Config(RaidTargetIcon, L"Raid/Group target indicator")