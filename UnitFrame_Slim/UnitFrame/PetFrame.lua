-----------------------------------------
-- Pet Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmPet = iUnitFrame("IGAS_UI_PetFrame")
frmPet:SetPoint("TOPLEFT", 180, -50)
frmPet.Unit = "pet"

frmPet:SetSize(160, 36)

-- Buff Panel
frmPet:AddElement(iBuffPanel)
frmPet.iBuffPanel:SetPoint("BOTTOMLEFT", frmPet, "TOPLEFT")

-- Debuff Panel
frmPet:AddElement(iDebuffPanel)
frmPet.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmPet, "TOPRIGHT")
