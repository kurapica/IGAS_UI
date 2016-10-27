-----------------------------------------
-- Script for Info Bar
-----------------------------------------
IGAS:NewAddon "IGAS_UI.InfoBar"

_FullColor = ColorType(1, 1, 1, 1)
_NoColor = ColorType(1, 1, 1, 0)

PERFORMANCEBAR_LOW_LATENCY = 300
PERFORMANCEBAR_MEDIUM_LATENCY = 600
MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

XP_TEXT = "|cffffd200XP: +%s|r\n";
EXHAUST_TOOLTIP1 = EXHAUST_TOOLTIP1
EXHAUST_TOOLTIP2 = EXHAUST_TOOLTIP2
EXHAUST_TOOLTIP3 = EXHAUST_TOOLTIP3
EXHAUST_TOOLTIP4 = EXHAUST_TOOLTIP4
MAINMENUBAR_LATENCY_LABEL = MAINMENUBAR_LATENCY_LABEL
MAINMENUBAR_PROTOCOLS_LABEL = MAINMENUBAR_PROTOCOLS_LABEL
UNKNOWN = UNKNOWN
MAINMENUBAR_FPS_LABEL = MAINMENUBAR_FPS_LABEL
MAINMENUBAR_BANDWIDTH_LABEL = MAINMENUBAR_BANDWIDTH_LABEL
MAINMENUBAR_DOWNLOAD_PERCENT_LABEL = MAINMENUBAR_DOWNLOAD_PERCENT_LABEL
CINEMATICS = CINEMATICS
CINEMATIC_DOWNLOAD_FORMAT = CINEMATIC_DOWNLOAD_FORMAT
TOTAL_MEM_MB_ABBR = TOTAL_MEM_MB_ABBR
TOTAL_MEM_KB_ABBR = TOTAL_MEM_KB_ABBR
ADDON_MEM_MB_ABBR = ADDON_MEM_MB_ABBR
ADDON_MEM_KB_ABBR = ADDON_MEM_KB_ABBR

GameTooltip = _G.GameTooltip

NUM_ADDONS_TO_DISPLAY = 5;
topAddOns = {}
for i=1, NUM_ADDONS_TO_DISPLAY do
	topAddOns[i] = { value = 0, name = "" };
end

-- These are movieID from the MOVIE database file.
MovieList = {
  -- Movie sequence 1 = Wow Classic
  { 1, 2 },
  -- Movie sequence 2 = BC
  { 27 },
  -- Movie sequence 3 = LK
  { 18 },
  -- Movie sequence 4 = CC
  { 23 },
  -- Movie sequence 5 = MP
  { 115 },
}

function InfoBar_GetMovieDownloadProgress(id)
	local movieList = MovieList[id];
	if (not movieList) then return; end

	local anyInProgress = false;
	local allDownloaded = 0;
	local allTotal = 0;
	for _, movieId in ipairs(movieList) do
		local inProgress, downloaded, total = GetMovieDownloadProgress(movieId);
		anyInProgress = anyInProgress or inProgress;
		allDownloaded = allDownloaded + downloaded;
		allTotal = allTotal + total;
	end

	return anyInProgress, allDownloaded, allTotal;
end

-- We want to save which movies were downloading when the player logged in so that we can continue to show
-- those movies after the download finishes
for i, movieList in next, MovieList do
	local inProgress = InfoBar_GetMovieDownloadProgress(i);
	movieList.inProgress = inProgress;
end

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
	_DBChar = _Addon._DBChar.InfoBar or {}

	_Addon._DBChar.InfoBar = _DBChar

	if _DBChar.Location then
		_Status.Location = _DBChar.Location
	end
	if _DBChar.Size then
		_Status.Size = _DBChar.Size
	end

	local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))] or NORMAL_FONT_COLOR

	_Text:SetTextColor(classColor.r, classColor.g, classColor.b)

	UpdateColor()
end

function UpdateColor()
	if _DBChar.StartColor and _DBChar.EndColor then
        _LeftTexture.Color = _FullColor
        _LeftTexture:SetGradientAlpha("HORIZONTAL",
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0,
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1
        )
        _RightTexture.Color = _FullColor
        _RightTexture:SetGradientAlpha("HORIZONTAL",
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1,
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0
        )
	else
        _LeftTexture.Color = _NoColor
        _RightTexture.Color = _NoColor
	end
end

ipTypes = { "IPv4", "IPv6" }

function UpdateGameTooltip()
	local string = "";
	local i, j, k = 0, 0, 0;

    GameTooltip:SetOwner(_Status, "ANCHOR_NONE")
    GameTooltip:ClearAllPoints()
	if select(2, _Status:GetCenter()) > GetScreenHeight() / 2 then
        GameTooltip:SetPoint("TOP", _Status, "BOTTOM")
	else
        GameTooltip:SetPoint("BOTTOM", _Status, "TOP")
	end

	-- Rest xp
	local exhaustionThreshold = GetXPExhaustion();

	local XPText = format( XP_TEXT, BreakUpLargeNumbers((exhaustionThreshold or 0)/2));

	GameTooltip:SetText(XPText);

	-- latency
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats();
	string = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld);
	--GameTooltip:AddLine(" ");
	GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
	GameTooltip:AddLine(" ");

	-- protocol types
	if GetCVarBool("useIPv6") then
		local ipTypeHome, ipTypeWorld = GetNetIpTypes();
		string = format(MAINMENUBAR_PROTOCOLS_LABEL, ipTypes[ipTypeHome or 0] or UNKNOWN, ipTypes[ipTypeWorld or 0] or UNKNOWN);
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
		GameTooltip:AddLine(" ");
	end

	-- framerate
	string = format(MAINMENUBAR_FPS_LABEL, GetFramerate());
	GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
	GameTooltip:AddLine(" ");

	string = format(MAINMENUBAR_BANDWIDTH_LABEL, GetAvailableBandwidth());
	GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
	GameTooltip:AddLine(" ");

	local percent = floor(GetDownloadedPercentage()*100+0.5);
	string = format(MAINMENUBAR_DOWNLOAD_PERCENT_LABEL, percent);
	GameTooltip:AddLine(string, 1.0, 1.0, 1.0);

	-- Downloaded cinematics
	local firstMovie = true;
	for i, movieList in next, MovieList do
		if (movieList.inProgress) then
			if (firstMovie) then
				GameTooltip:AddLine("   "..CINEMATICS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
				firstMovie = false;
			end
			local inProgress, downloaded, total = InfoBar_GetMovieDownloadProgress(i);
			if (inProgress) then
				GameTooltip:AddLine("   "..format(CINEMATIC_DOWNLOAD_FORMAT, _G["CINEMATIC_NAME_"..i], downloaded/total*100), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
			else
				GameTooltip:AddLine("   "..format(CINEMATIC_DOWNLOAD_FORMAT, _G["CINEMATIC_NAME_"..i], downloaded/total*100), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1);
			end
		end
	end

	-- AddOn mem usage
	for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
		topAddOns[i].value = 0;
	end

	UpdateAddOnMemoryUsage();
	local totalMem = 0;

	for i=1, GetNumAddOns(), 1 do
		local mem = GetAddOnMemoryUsage(i);
		totalMem = totalMem + mem;
		for j=1, NUM_ADDONS_TO_DISPLAY, 1 do
			if(mem > topAddOns[j].value) then
				for k=NUM_ADDONS_TO_DISPLAY, 1, -1 do
					if(k == j) then
						topAddOns[k].value = mem;
						topAddOns[k].name = GetAddOnInfo(i);
						break;
					elseif(k ~= 1) then
						topAddOns[k].value = topAddOns[k-1].value;
						topAddOns[k].name = topAddOns[k-1].name;
					end
				end
				break;
			end
		end
	end

	if ( totalMem > 0 ) then
		if ( totalMem > 1000 ) then
			totalMem = totalMem / 1000;
			string = format(TOTAL_MEM_MB_ABBR, totalMem);
		else
			string = format(TOTAL_MEM_KB_ABBR, totalMem);
		end

		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(string, 1.0, 1.0, 1.0);

		local size;
		for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
			if ( topAddOns[i].value == 0 ) then
				break;
			end
			size = topAddOns[i].value;
			if ( size > 1000 ) then
				size = size / 1000;
				string = format(ADDON_MEM_MB_ABBR, size, topAddOns[i].name);
			else
				string = format(ADDON_MEM_KB_ABBR, size, topAddOns[i].name);
			end
			GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
		end
	end

	GameTooltip:Show();
end

--------------------
-- Script Handler
--------------------
function _Status:OnMouseWheel(wheel)
    if wheel > 0 then
        _DBChar.StartColor = ColorType(random(100)/100, random(100)/100, random(100)/100)
        _DBChar.EndColor = ColorType(random(100)/100, random(100)/100, random(100)/100)
    else
        _DBChar.StartColor = nil
        _DBChar.EndColor = nil
    end
    UpdateColor()
end

function _Status:OnMouseDown()
    local l, b, w, h = self:GetRect()
    local e = self:GetEffectiveScale()
    local x, y = GetCursorPosition()

    x, y = x / e, y /e
    if x - l > w * 3 /4 then
        self:StartSizing("BOTTOMRIGHT")
    else
        self:StartMoving()
    end
end

function _Status:OnMouseUp()
    self:StopMovingOrSizing()

    _DBChar.Size = self.Size
    _DBChar.Location = self.Location
end

function _Status:OnEnter()
	self.Hover = true
	UpdateGameTooltip()
end

function _Status:OnLeave()
	self.Hover = false
	GameTooltip:Hide()
end

function _Timer:OnTimer()
	-- mail stuff
	if HasNewMail() then
		mail = "|c00FA58F4new!|r "
	else
		mail = ""
	end

	-- date thing
	local ticktack = date("%H:%M")
	ticktack = "|c00786857"..ticktack.."|r"

	-- fps crap
	local fps = GetFramerate()
	fps = "|c00786857"..floor(fps).."|rfps  "

	-- lag
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = latencyHome > latencyWorld and latencyHome or latencyWorld

	if (latency > PERFORMANCEBAR_MEDIUM_LATENCY) then
		latency = "|c00ff0000"..latency.."|rms  "
	elseif (latency > PERFORMANCEBAR_LOW_LATENCY) then
		latency = "|c00ffff00"..latency.."|rms  "
	else
		latency = "|c0000ff00"..latency.."|rms  "
	end

	-- xp stuff
	local xp_cur = UnitXP("player")
	local xp_max = UnitXPMax("player")
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		ep = "|c00786857"..floor(xp_max - xp_cur).."|rxp  "
	else
		ep = ""
	end

    -- get player x,y
    local x, y = GetPlayerMapPosition("player")
   	x = x or 0
   	y = y or 0
    -- if x and y 0 then boo
    if(x == 0 and y == 0) then
        coords = "";
    else
        coords = "(".."|c00786857"..format("%.2d,%.2d".."|r)  ",x*100,y*100)
    end

    -- Artifact xp
    local artifactXP = ""
    if HasArtifactEquipped() then
    	local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo();

		local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP);

		artifactXP = xp .. "/" .. xpForNextPoint.."  "
	end

	-- Refresh
	_Text:SetText(fps..latency..ep..artifactXP..mail..coords..ticktack)

	if _Status.Hover then
		UpdateGameTooltip()
	end
end