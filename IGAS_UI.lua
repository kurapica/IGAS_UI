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