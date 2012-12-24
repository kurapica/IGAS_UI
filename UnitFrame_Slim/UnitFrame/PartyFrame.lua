-----------------------------------------
-- Party Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

for i = 1, 4 do
	frmParty = iUnitFrame("IGAS_UI_PartyFrame"..i)
	frmParty:SetPoint("TOPLEFT", 40, -60 - 64 * i)
	frmParty:SetSize(200, 36)
	frmParty.Unit = "party"..i

	-- Remove Cast Bar, enable if you want
	-- frmParty:RemoveElement(iCastBar)

	-- Debuff Panel
	frmParty:AddElement(iDebuffPanel)
	frmParty.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmParty, "TOPRIGHT", 0, 4)

	frmPartyPet = iSUnitFrame("IGAS_UI_PartyPetFrame"..i)
	frmPartyPet:SetPoint("BOTTOMLEFT", frmParty, "BOTTOMRIGHT")
	frmPartyPet:SetSize(160, 24)
	frmPartyPet.Unit = "partypet"..i
end