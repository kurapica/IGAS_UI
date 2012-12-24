-----------------------------------------
-- Pet Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPet = iUnitFrame("IGAS_UI_PetFrame")
frmPet:SetPoint("TOPLEFT", 180, -40)
frmPet:SetSize(160, 24)
frmPet.Unit = "pet"

-- Buff Panel
frmPet:AddElement(iBuffPanel)
frmPet.iBuffPanel:SetPoint("BOTTOMLEFT", frmPet, "TOPLEFT", 0, 4)

-- Debuff Panel
frmPet:AddElement(iDebuffPanel)
frmPet.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmPet, "TOPRIGHT", 0, 4)
