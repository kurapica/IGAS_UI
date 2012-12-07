-----------------------------------------
-- Target Frame
-----------------------------------------
IGAS:NewAddon "IGAS_UI.UnitFrame"

frmTarget = iUnitFrame("IGAS_UI_TargetFrame")
frmTarget:SetPoint("TOPLEFT", 240, 0)
frmTarget.Unit = "target"

-- Buff Panel
frmTarget:AddElement(iBuffPanel)
frmTarget.iBuffPanel:SetPoint("BOTTOMLEFT", frmTarget, "TOPLEFT", 0, 4)

-- Debuff Panel
frmTarget:AddElement(iDebuffPanel)
frmTarget.iDebuffPanel:SetPoint("BOTTOMRIGHT", frmTarget, "TOPRIGHT", 0, 4)

-- QuestBoss Icon
frmTarget:AddElement(QuestBossIcon)
frmTarget.QuestBossIcon:SetPoint("CENTER", frmTarget, "LEFT")
frmTarget.QuestBossIcon.Scale = 2

-- NameLabel
frmTarget.NameLabel.UseTapColor = true
frmTarget.NameLabel.UseSelectionColor = true