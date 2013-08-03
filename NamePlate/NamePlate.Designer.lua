-----------------------------------------
-- Designer for NamePlate
-----------------------------------------
IGAS:NewAddon "IGAS_UI.NamePlate"

NamePlateArray = Array(NamePlateMask)

TargetDebuffPanel = iDebuffPanel("IGAS_UI_TargetDebuffPanel")
TargetDebuffPanel.Unit = "target"

_Scan = Frame("IGAS_UI_NamePlateScan", WorldFrame)
_Scan.Visible = false
