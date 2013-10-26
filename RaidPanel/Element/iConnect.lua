-----------------------------------------
-- Connect Handler for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

interface "IFIConnect"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIConnect(self)
		self:AddElement(DisconnectIcon)
		self.DisconnectIcon:SetPoint("BOTTOMLEFT")
    end
endinterface "IFIConnect"

class "iRaidUnitFrame"
	extend "IFIConnect"
endclass "iRaidUnitFrame"

class "iDeadUnitFrame"
	extend "IFIConnect"
endclass "iDeadUnitFrame"

AddType4Config(DisconnectIcon, L"Disconnect indicator")