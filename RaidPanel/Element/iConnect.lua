-----------------------------------------
-- Connect Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

-----------------------------------------------
--- IFIConnect
-- @type interface
-- @name IFIConnect
-----------------------------------------------
interface "IFIConnect"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIConnect(self)
		self:AddElement(DisconnectIcon)
		self.DisconnectIcon:SetPoint("BOTTOMLEFT")
    end
endinterface "IFIConnect"

partclass "iRaidUnitFrame"
	extend "IFIConnect"
endclass "iRaidUnitFrame"
