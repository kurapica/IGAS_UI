---------------------------------------------------------------------------------------------------
-- IGAS_UI Main
---------------------------------------------------------------------------------------------------

-- Addon Initialize
IGAS:NewAddon("IGAS_UI")

import "System"
import "System.Widget"
import "System.Widget.Unit"

-- Localization
L = Locale(_Name)

-- Logger
Log = Logger(_Name)

Log.LogLevel = 2

Log:SetPrefix(1, FontColor.Gray .. "[".. _Name .."]" .. FontColor.Normal)
Log:SetPrefix(2, FontColor.Green .. "[".. _Name .."]" .. FontColor.Normal)
Log:SetPrefix(3, FontColor.Red .. "[".. _Name .."]" .. FontColor.Normal)

Log:AddHandler(print)

function OnLoad(self)
	-- SavedVariables
	_DB = self:AddSavedVariable("IGAS_UI_DB")
	_DBChar = self:AddSavedVariable("IGAS_UI_DB_Char")

	-- Log Level
	if type(_DB.LogLevel) == "number" then
		Log.LogLevel = _DB.LogLevel
	end

	-- Slash command
	self:AddSlashCmd("/igasui", "/iu")
end

function OnSlashCmd(self, option, info)
	if option and option:lower() == "log" and tonumber(info) then
		Log.LogLevel = tonumber(info)
		_DB.LogLevel = Log.LogLevel

		Log(2, "%s's LogLevel is switched to %d.", _Name, Log.LogLevel)
	end

	IGAS.UIParent.IGAS_UI_Manager.Visible = true
end