IGAS:NewAddon "IGAS_UI.UnitFrame"

arUnit = Array(iUnitFrame)

--==========================
-- Player
--==========================
frmPlayer = iUnitFrame("IGAS_UI_PlayerFrame")
frmPlayer:SetPoint("TOPLEFT", 40, 0)
frmPlayer:SetSize(200, 36)
frmPlayer.Unit = "player"

frmPlayer:ApplyConfig()

--==========================
-- Pet
--==========================
local frmPet = iUnitFrame("IGAS_UI_PetFrame")
frmPet:SetPoint("TOPLEFT", 180, -40)
frmPet:SetSize(160, 24)
frmPet.Unit = "pet"

frmPet:ApplyConfig()

--==========================
-- Target
--==========================
local frmTarget = iUnitFrame("IGAS_UI_TargetFrame")
frmTarget:SetPoint("TOPLEFT", 280, 0)
frmTarget:SetSize(200, 36)
frmTarget.Unit = "target"

frmTarget:ApplyConfig()

--==========================
-- TargetTarget
--==========================
local frmTargetTarget = iUnitFrame("IGAS_UI_TargetTargetFrame")
frmTargetTarget:SetPoint("TOPLEFT", 420, -40)
frmTargetTarget:SetSize(160, 24)
frmTargetTarget.Unit = "targettarget"

frmTargetTarget:ApplyConfig()

--==========================
-- Focus
--==========================
local frmFocus = iUnitFrame("IGAS_UI_FocusFrame")
frmFocus:SetPoint("TOPLEFT", 20, -40)
frmFocus:SetSize(160, 24)
frmFocus.Unit = "focus"

frmFocus:SetAttribute("shift-type1", "macro")
frmFocus:SetAttribute("shift-macrotext1", "/clearfocus")
frmFocus:ApplyConfig()

--==========================
-- Boss
--==========================
for i = 1, 5 do
	local frmBoss = iUnitFrame("IGAS_UI_BossFrame"..i)
	frmBoss:SetPoint("TOPLEFT", 600, - 64 * i)
	frmBoss:SetSize(200, 36)
	frmBoss.Unit = "boss"..i

	frmBoss:ApplyConfig()
end

--==========================
-- Party
--==========================
for i = 1, 4 do
	local frmParty = iUnitFrame("IGAS_UI_PartyFrame"..i)
	frmParty:SetPoint("TOPLEFT", 40, -60 - 64 * i)
	frmParty:SetSize(200, 36)
	frmParty.Unit = "party"..i

	frmParty:ApplyConfig()

	local frmPartyPet = iUnitFrame("IGAS_UI_PartyPetFrame"..i)
	frmPartyPet:SetPoint("BOTTOMLEFT", frmParty, "BOTTOMRIGHT")
	frmPartyPet:SetSize(160, 24)
	frmPartyPet.Unit = "partypet"..i

	frmPartyPet:ApplyConfig()
end

--==========================
-- FocusTarget
--==========================
local frmFocusTarget = iUnitFrame("IGAS_UI_FocusTargetFrame")
frmFocusTarget:SetPoint("TOPLEFT", 20, -70)
frmFocusTarget:SetSize(160, 24)
frmFocusTarget.Unit = "focustarget"

frmFocusTarget:ApplyConfig()