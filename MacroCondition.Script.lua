-----------------------------------------
-- Script for MacroCondition
-----------------------------------------
IGAS:NewAddon "IGAS_UI.MacroCondition"

local _Thread = System.Threading.Thread()

HTML_TEMPLATE = [[
<html>
<body>
%s
</body>
</html>
]]

HTML_HREF_TEMPLATE = [[<a href="%s">%s</a>]]

HTML_CONDITION = [[
<p><cyan>%s</cyan></p>
%s
<br/>
<p><cyan>%s</cyan></p>
%s
]]

HTML_RESULT = [[
<p>[%s]</p>
]]

targetData = {
	"target",
	"pet",
	"vehicle",
	"focus",
	"mouseover",
	"targettarget",
	"focustarget",
	"boss1",
	"arena1",
	"party1",
	"raid1",
}

condtionData = {
	{
		Condition = "canexitvehicle",
		Text = L"Player is in a vehicle and can exit it at will.",
		ForPlayer = true,
	},
	{
		Condition = "combat",
		Text = L"Player is in combat.",
		ForPlayer = true,
	},
	{
		Condition = "dead",
		Text = L"Conditional target exists and is dead.",
	},
	{
		Condition = "exists",
		Text = L"Conditional target exists.",
	},
	{
		Condition = "flyable",
		Text = L"The player can use a flying mount in this zone (though incorrect in Wintergrasp during a battle).",
		ForPlayer = true,
	},
	{
		Condition = "flying",
		Text = L"Mounted or in flight form AND in the air.",
		ForPlayer = true,
	},
	{
		Condition = "form",
		Text = L"The player is in any form.",
		ForPlayer = true,
	},
	{
		Condition = "form:0",
		Text = L"The player is not in any form.",
		ForPlayer = true,
	},
	{
		Condition = "form:1",
		Text = L"The player is in form 1." .. (GetShapeshiftFormInfo(1) and GetSpellLink(select(5, GetShapeshiftFormInfo(1))) or ""),
		ForPlayer = true,
	},
	{
		Condition = "form:2",
		Text = L"The player is in form 2." .. (GetShapeshiftFormInfo(2) and GetSpellLink(select(5, GetShapeshiftFormInfo(2))) or ""),
		ForPlayer = true,
	},
	{
		Condition = "form:3",
		Text = L"The player is in form 3." .. (GetShapeshiftFormInfo(3) and GetSpellLink(select(5, GetShapeshiftFormInfo(3))) or ""),
		ForPlayer = true,
	},
	{
		Condition = "form:4",
		Text = L"The player is in form 4." .. (GetShapeshiftFormInfo(4) and GetSpellLink(select(5, GetShapeshiftFormInfo(4))) or ""),
		ForPlayer = true,
	},
	{
		Condition = "group",
		Text = L"Player is in a party.",
		ForPlayer = true,
	},
	{
		Condition = "group:raid",
		Text = L"Player is in a raid.",
		ForPlayer = true,
	},
	{
		Condition = "harm",
		Text = L"Conditional target exists and can be targeted by harmful spells (e.g.  [Fireball]).",
	},
	{
		Condition = "help",
		Text = L"Conditional target exists and can be targeted by helpful spells (e.g.  [Heal]).",
	},
	{
		Condition = "indoors",
		Text = L"Player is indoors.",
		ForPlayer = true,
	},
	{
		Condition = "mounted",
		Text = L"Player is mounted.",
		ForPlayer = true,
	},
	{
		Condition = "outdoors",
		Text = L"Player is outdoors.",
		ForPlayer = true,
	},
	{
		Condition = "party",
		Text = L"Conditional target exists and is in your party.",
	},
	{
		Condition = "pet",
		Text = L"The player has a pet.",
		ForPlayer = true,
	},
	{
		Condition = "petbattle",
		Text = L"Currently participating in a pet battle.",
		ForPlayer = true,
	},
	{
		Condition = "raid",
		Text = L"Conditional target exists and is in your raid/party.",
	},
	{
		Condition = "resting",
		Text = L"Player is currently resting.",
		ForPlayer = true,
	},
	{
		Condition = "spec:1",
		Text = L"Player's active the first specialization group (spec, talents and glyphs).",
		ForPlayer = true,
	},
	{
		Condition = "spec:2",
		Text = L"Player's active the second specialization group (spec, talents and glyphs).",
		ForPlayer = true,
	},
	{
		Condition = "stealth",
		Text = L"Player is stealthed.",
		ForPlayer = true,
	},
	{
		Condition = "swimming",
		Text = L"Player is swimming.",
		ForPlayer = true,
	},
	{
		Condition = "vehicleui",
		Text = L"Player has vehicle UI.",
		ForPlayer = true,
	},
	{
		Condition = "extrabar",
		Text = L"Player currently has an extra action bar/button.",
		ForPlayer = true,
	},
	{
		Condition = "overridebar",
		Text = L"Player's main action bar is currently replaced by the override action bar.",
		ForPlayer = true,
	},
	{
		Condition = "possessbar",
		Text = L"Player's main action bar is currently replaced by the possess action bar.",
		ForPlayer = true,
	},
	{
		Condition = "shapeshift",
		Text = L"Player's main action bar is currently replaced by a temporary shapeshift action bar.",
		ForPlayer = true,
	},
	{
		Condition = "mod:shift",
		Text = L"Player's holding the shift key",
		ForPlayer = true,
	},
	{
		Condition = "mod:ctrl",
		Text = L"Player's holding the ctrl key",
		ForPlayer = true,
	},
	{
		Condition = "mod:alt",
		Text = L"Player's holding the alt key",
		ForPlayer = true,
	},
	{
		Condition = "cursor",
		Text = L"Player's mouse cursor is currently holding an item/ability/macro/etc",
		ForPlayer = true,
	},
}

local targets = {}

for _, tar in ipairs(targetData) do
	tinsert(targets, HTML_HREF_TEMPLATE:format("@" .. tar, "[" .. L[tar] .. "]"))
end

local conditions = {}

for _, cond in ipairs(condtionData) do
	local text = "<p>"
	text = text .. HTML_HREF_TEMPLATE:format("no" .. cond.Condition, "[no]")
	text = text .. HTML_HREF_TEMPLATE:format(cond.Condition, "[" .. cond.Condition .. "]")
	text = text .. " - " .. cond.Text .. "</p>"

	tinsert(conditions, text)
end

local conditionHtml = HTML_TEMPLATE:format(
	HTML_CONDITION:format(
		L"The conditional target :",
		"<p>" .. table.concat( targets, ", " ) .. "</p>",
		L"The macro conditions :",
		table.concat( conditions, "" )
	)
)

local conditionSelect

function OnLoad(self)
	_DB = _Addon._DB.MacroConditions or {}
	_Addon._DB.MacroConditions = _DB

	if not _DB.Keys then
		-- Init with default settings
		_DB.Keys = {
			"[@target,noexists,nocombat,nogroup]",
			"[vehicleui]",
			"[petbattle]",
		}
		_DB.Items = {
			L"Solo no combat no target",
			L"In a vehicle",
			L"In a pet battle",
		}
	end

	autoHideList.Keys = _DB.Keys
	autoHideList.Items = _DB.Items
end

function htmlCondition:OnShow()
	txtDesc.Text = ""
	htmlResult.Text = ""
	htmlCondition.Text = conditionHtml
	conditionSelect = { "@player" }
	btnSaveCondition.Enabled = false
end

function htmlCondition:OnHyperlinkClick(data)
	if data:match("^@") then
		-- conditional target
		conditionSelect[1] = data
	else
		local negData
		local matched = false
		if data:match("^no") then
			negData = data:sub(3, -1)
		else
			negData = "no" .. data
		end
		if data:match("form") then
			for i, v in ipairs(conditionSelect) do
				if v:match("form") then
					matched = true
					if data == "form" or data == "noform" then
						conditionSelect[i] = data
					else
						local forms
						if v == "noform" then
							forms = {[0] = true, false, false, false, false}
						elseif v == "form" then
							forms = {[0] = false, true, true, true, true}
						elseif v:match("^no") then
							forms = {[0] = true, true, true, true, true}
							v:gsub("%d+", function(num) forms[tonumber(num)] = false end)
						else
							forms = {[0] = false, false, false, false, false}
							v:gsub("%d+", function(num) forms[tonumber(num)] = true end)
						end
						if data:match("^no") then
							data:gsub("%d+", function(num) forms[tonumber(num)] = false end)
						else
							data:gsub("%d+", function(num) forms[tonumber(num)] = true end)
						end
						local cnt = 0
						for j = 1, #forms do if forms[j] then cnt = cnt + 1 end end
						if cnt == 0 then
							conditionSelect[i] = "noform"
						elseif cnt == #forms then
							conditionSelect[i] = "form"
						elseif cnt <= 2 then
							data = ""
							for j = 0, #forms do
								if forms[j] then
									if data ~= "" then
										data = data .. "/" .. j
									else
										data = data .. j
									end
								end
							end
							conditionSelect[i] = "form:" .. data
						else
							data = ""
							for j = 0, #forms do
								if not forms[j] then
									if data ~= "" then
										data = data .. "/" .. j
									else
										data = data .. j
									end
								end
							end
							conditionSelect[i] = "noform:" .. data
						end
					end
					break
				end
			end
		else
			for i, v in ipairs(conditionSelect) do
				if v == data then
					return
				elseif v == negData then
					matched = true
					conditionSelect[i] = data
				end
			end
		end
		if not matched then
			tinsert(conditionSelect, data)
		end
	end

	htmlResult.Text = HTML_TEMPLATE:format( HTML_RESULT:format(buildResult()) )
end

function htmlResult:OnHyperlinkClick(data)
	for i, v in ipairs(conditionSelect) do
		if data == v then
			if i == 1 then
				conditionSelect[i] = "@player"
			else
				tremove(conditionSelect, i)
			end
			break
		end
	end

	Task.Next()

	htmlResult.Text = HTML_TEMPLATE:format( HTML_RESULT:format(buildResult()) )
end

function buildResult()
	local text = ""
	for i, v in ipairs(conditionSelect) do
		if i == 1 then
			if v ~= "@player" then
				text = HTML_HREF_TEMPLATE:format(v, v)
			end
		else
			text = text .. (text ~= "" and ", " or "") .. HTML_HREF_TEMPLATE:format(v, v)
		end
	end
	btnSaveCondition.Enabled = #conditionSelect > 1
	return text
end

function btnAdd:OnClick()
	macroMaker:Show()
end

function btnRemove:OnClick()
	local name = autoHideList:GetSelectedItemValue()
	if name and IGAS:MsgBox(L"Are you sure to delete the macro condition?", "n") then
		autoHideList:RemoveItem(name)
	end
end

function btnClose:OnClick()
	macroCondition:Hide()
end

function btnCloseCondition:OnClick()
	macroMaker:Hide()
end

function btnSaveCondition:OnClick()
	local text = ""
	for i, v in ipairs(conditionSelect) do
		if i == 1 then
			if v ~= "@player" then
				text = v
			end
		else
			text = text .. (text ~= "" and "," or "") .. v
		end
	end
	text = "[" .. text .. "]"
	local desc = (txtDesc.Text or ""):gsub("^%s*(.-)%s*$", "%1")
	if desc == "" then desc = text end

	autoHideList:SetItem(text, desc)

	macroMaker:Hide()
end

function btnSave:OnClick()
	macroCondition.Saved = true
	macroCondition:Hide()
end

function macroCondition:OnHide()
	return _Thread:Resume()
end

function autoHideList:OnItemDoubleClick(key, item)
	enableList:SetItem(key, item .. " - " .. key)
end

function enableList:OnItemDoubleClick(key, item)
	enableList:RemoveItem(key)
end

function _Addon:SelectMacroCondition(data)
	if data then
		enableList:SetList(data)
	else
		enableList:Clear()
	end
	macroCondition.Saved = false
	macroCondition:Show()

	_Thread:Yield()

	if macroCondition.Saved then
		local keys = enableList.Keys
		local items = enableList.Items

		data = {}

		for i = 1, #keys do
			data[keys[i]] = items[i]
		end

		return data
	end
end