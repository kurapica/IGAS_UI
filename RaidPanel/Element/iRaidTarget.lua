-----------------------------------------
-- Raid Target Icon for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIRaidTarget
-- @type interface
-- @name IFIRaidTarget
-----------------------------------------------
interface "IFIRaidTarget"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIRaidTarget(self)
		self:AddElement(RaidTargetIcon)
		self.RaidTargetIcon:SetPoint("CENTER", self.RaidTargetIcon.Parent, "TOP")
    end
endinterface "IFIRaidTarget"

partclass "iRaidUnitFrame"
	extend "IFIRaidTarget"
endclass "iRaidUnitFrame"
