IGAS:NewAddon "IGAS_UI"

--==========================
-- Main settings
--==========================

import "System"
import "System.Widget"
import "System.Widget.Unit"

-- Localization
L = Locale(_Name)

-- Logger
Log = Logger(_Name)

Log.LogLevel = 2

Log:SetPrefix(1, FontColor.Gray .. "[".. _Name .."]" .. FontColor.Normal, "Debug")
Log:SetPrefix(2, FontColor.Green .. "[".. _Name .."]" .. FontColor.Normal, "Info")
Log:SetPrefix(3, FontColor.Red .. "[".. _Name .."]" .. FontColor.Normal, "Warn")

Log:AddHandler(print)

RAID_CLASS_COLORS = {
	["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
	["WARLOCK"] = { r = 0.53, g = 0.53, b = 0.93, colorStr = "ff8788ee" },
	["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, colorStr = "ffffffff" },
	["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
	["MAGE"] = { r = 0.25, g = 0.78, b = 0.92, colorStr = "ff3fc7eb" },
	["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, colorStr = "fffff569" },
	["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
	["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, colorStr = "ff0070de" },
	["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23, colorStr = "ffc41f3b" },
	["MONK"] = { r = 0.0, g = 1.00 , b = 0.59, colorStr = "ff00ff96" },
	["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79, colorStr = "ffa330c9" },
}

PowerBarColor = {}
PowerBarColor["MANA"] = { r = 0.00, g = 0.00, b = 1.00 }
PowerBarColor["RAGE"] = { r = 1.00, g = 0.00, b = 0.00, fullPowerAnim=true }
PowerBarColor["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25, fullPowerAnim=true }
PowerBarColor["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00, fullPowerAnim=true }
PowerBarColor["COMBO_POINTS"] = { r = 1.00, g = 0.96, b = 0.41 }
PowerBarColor["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 }
PowerBarColor["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 }
PowerBarColor["SOUL_SHARDS"] = { r = 0.50, g = 0.32, b = 0.55 }
PowerBarColor["LUNAR_POWER"] = { r = 0.30, g = 0.52, b = 0.90, atlas="_Druid-LunarBar" }
PowerBarColor["HOLY_POWER"] = { r = 0.95, g = 0.90, b = 0.60 }
PowerBarColor["MAELSTROM"] = { r = 0.00, g = 0.50, b = 1.00, atlas = "_Shaman-MaelstromBar", fullPowerAnim=true }
PowerBarColor["INSANITY"] = { r = 0.40, g = 0, b = 0.80, atlas = "_Priest-InsanityBar"}
PowerBarColor["CHI"] = { r = 0.71, g = 1.0, b = 0.92 }
PowerBarColor["ARCANE_CHARGES"] = { r = 0.1, g = 0.1, b = 0.98 }
PowerBarColor["FURY"] = { r = 0.788, g = 0.259, b = 0.992, atlas = "_DemonHunter-DemonicFuryBar", fullPowerAnim=true }
PowerBarColor["PAIN"] = { r = 255/255, g = 156/255, b = 0, atlas = "_DemonHunter-DemonicPainBar", fullPowerAnim=true }
-- vehicle colors
PowerBarColor["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 }
PowerBarColor["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 }
PowerBarColor["STAGGER"] = { {r = 0.52, g = 1.0, b = 0.52}, {r = 1.0, g = 0.98, b = 0.72}, {r = 1.0, g = 0.42, b = 0.42},}

PowerBarColor[0] = PowerBarColor["MANA"]
PowerBarColor[1] = PowerBarColor["RAGE"]
PowerBarColor[2] = PowerBarColor["FOCUS"]
PowerBarColor[3] = PowerBarColor["ENERGY"]
PowerBarColor[4] = PowerBarColor["COMBO_POINTS"]
PowerBarColor[5] = PowerBarColor["RUNES"]
PowerBarColor[6] = PowerBarColor["RUNIC_POWER"]
PowerBarColor[7] = PowerBarColor["SOUL_SHARDS"]
PowerBarColor[8] = PowerBarColor["LUNAR_POWER"]
PowerBarColor[9] = PowerBarColor["HOLY_POWER"]
PowerBarColor[10] = PowerBarColor["ALTERNATE_POWER"]
PowerBarColor[11] = PowerBarColor["MAELSTROM"]
PowerBarColor[12] = PowerBarColor["CHI"]
PowerBarColor[13] = PowerBarColor["INSANITY"]
PowerBarColor[14] = PowerBarColor["OBSOLETE"]
PowerBarColor[15] = PowerBarColor["OBSOLETE2"]
PowerBarColor[16] = PowerBarColor["ARCANE_CHARGES"]
PowerBarColor[17] = PowerBarColor["FURY"]
PowerBarColor[18] = PowerBarColor["PAIN"]

--==========================
-- Load saved variables
--==========================
function OnLoad(self)
	-- SavedVariables
	_DB = self:AddSavedVariable("IGAS_UI_DB")
	_DBChar = self:AddSavedVariable("IGAS_UI_DB_Char")

	if not _DB.UpdateForNewVersion then
		wipe(_DB)
		_DB.UpdateForNewVersion = 70000
	end

	if not _DBChar.UpdateForNewVersion then
		wipe(_DBChar)
		_DBChar.UpdateForNewVersion = 70000
	end

	-- Log Level
	if type(_DB.LogLevel) == "number" then
		Log.LogLevel = _DB.LogLevel
	end

	-- Slash command
	self:AddSlashCmd("/igasui", "/iu")

	OnLoad = nil
end

--==========================
-- Show the change log
--==========================
function OnEnable(self)
	Task.NoCombatCall(function()
		local version = tonumber(GetAddOnMetadata(_Name, "Version"):match("%d+"))

		if not _DB.VERSION or _DB.VERSION < version then
			_DB.VERSION = version

			local frm = Form("IGAS_UI_ChangeLog")
			frm.Caption = "IGAS_UI - " .. L"Change Log"
			frm.Resizable = false
			frm.Visible = false

			local html = HTMLViewer("HTMLViewer", frm)
			html:SetPoint("TOPLEFT", 4, -26)
			html:SetPoint("BOTTOMRIGHT", -4, 56)
			html:SetBackdrop(nil)

			local btn = NormalButton("OkayOnly", frm)
			btn.Style = "Classic"
			btn:SetSize(100, 26)
			btn:SetPoint("BOTTOMRIGHT", -4, 6)
			btn.Text = L"Okay"

			btn.OnClick = function() return frm:Hide() end
			frm.OnHide = function() return frm:Dispose() end
			frm:ActiveThread("OnShow")
			frm.OnShow = function() Task.Delay(0.1) html.Text = L"ChangeLog" end

			return frm:Show()
		end
	end)

	OnEnable = nil
end

--==========================
-- Slash command handler
--==========================
function OnSlashCmd(self, option, info)
	if option and option:lower() == "log" and tonumber(info) then
		Log.LogLevel = tonumber(info)
		_DB.LogLevel = Log.LogLevel

		Log(2, "%s's LogLevel is switched to %d.", _Name, Log.LogLevel)
	end

	IGAS.UIParent.IGAS_UI_Manager.Visible = true
end

--==========================
-- Helper
--==========================
function mround(v)
	local a = math.abs(v)
	local f = math.floor(v)
	if (a-f) >= 0.5 then f = f + 1 end
	if v < 0 then return -f end
	return f
end