-----------------------------------------
-- Script for Spell cooldown line
-----------------------------------------

IGAS:NewAddon "IGAS_UI.SpellCooldownLine"

_UsingSpellIcon = 0

_SpellIconArray = {}
_ItemIconArray = {}
_BuffIconArray = {}
_BuffCache = {}
_RecycleIcon = Recycle(SpellIcon, "SpellIcon%d", btnHandler)
_FullColor = ColorType(1, 1, 1, 1)
_NoColor = ColorType(1, 1, 1, 0)
log = math.log
abs = math.abs

enum "Mode"{
    "Normal",
    "Buff",
    "Hidden",
}

------------------------------------------------------
-- Help functions
--
-- GetPosition(start, duration, time) : posx, nextPos, duration
------------------------------------------------------
do
    _TimeLine = {
        [0] = 0,
    }

    for i = 1, _MAX_FRAG do
        _TimeLine[i] = 2^i
    end

    function UpdateLine()
        if not btnHandler:GetCenter() then
            btnHandler.Width = 48
            btnHandler.Height = 48
            btnHandler:ClearAllPoints()
            btnHandler:SetPoint("BOTTOMLEFT", 450, 300)

            _DBChar.SpellCooldownHandlerLocation = btnHandler.Location
            _DBChar.SpellCooldownHandlerSize = btnHandler.Size
        end
        local length = abs(GetScreenWidth() - btnHandler:GetCenter() * 2)

        if btnHandler:GetCenter() < GetScreenWidth()/2 then
            lineCooldown:ClearAllPoints()
            lineCooldown:SetPoint("BOTTOMLEFT", 0, 2)

            lineBuff:ClearAllPoints()
            lineBuff:SetPoint("BOTTOMLEFT", btnHandler, "TOPLEFT", 0, 2)
        else
            lineCooldown:ClearAllPoints()
            lineCooldown:SetPoint("BOTTOMRIGHT", 0, 2)

            lineBuff:ClearAllPoints()
            lineBuff:SetPoint("BOTTOMRIGHT", btnHandler, "TOPRIGHT", 0, 2)
        end
        lineCooldown.Height = btnHandler.Height - 4
        lineCooldown.Width = abs(GetScreenWidth() - btnHandler:GetCenter() * 2)
        lineBuff.Height = btnHandler.Height - 4
        lineBuff.Width = abs(GetScreenWidth() - btnHandler:GetCenter() * 2)

        for i = 1, _MAX_FRAG do
            lineCooldown[i]:ClearAllPoints()
            lineCooldown[i]:SetPoint("CENTER", GetPosition(0, 2^i, 0), 0)
            lineBuff[i]:ClearAllPoints()
            lineBuff[i]:SetPoint("CENTER", GetPosition(0, 2^i, 0), btnHandler.Height+2)
        end
    end

    function GetPosition(start, duration, time)
        local length = GetScreenWidth() - btnHandler:GetCenter() * 2

        time = time or GetTime()

        duration = start + duration - time

        local nextMark = #_TimeLine

        for i, v in ipairs(_TimeLine) do
            if duration <= v then
                nextMark = i - 1
                break
            end
        end

        return log(duration)/log(2) * length / _MAX_FRAG, nextMark * length / _MAX_FRAG, duration - _TimeLine[nextMark]
    end

    function UpdateMode()
        if SpellBookFrame.Visible then
            btnHandler.Backdrop = _Backdrop
            btnHandler.MouseEnabled = true
            sizer_se.Visible = true
        else
            if btnHandler.Mode == Mode.Normal then
                btnHandler.Backdrop = _Backdrop
                btnHandler.MouseEnabled = true
                sizer_se.Visible = true
                lstWhite.Visible = false
                lstBlack.Visible = false

                lineCooldown.Visible = true
                lineBuff.Visible = true
                for i = 1, _MAX_FRAG do
                    lineCooldown[i].Visible = true
                    lineBuff[i].Visible = true
                end
            elseif btnHandler.Mode == Mode.Buff then
                btnHandler.Backdrop = _Backdrop
                btnHandler.MouseEnabled = true
                sizer_se.Visible = true
                FillBuffList()
                FillBlackList()
                lstWhite.Visible = true
                lstBlack.Visible = true
                if _UsingSpellIcon == 0 then
                    lineCooldown.Visible = false
                    lineBuff.Visible = false
                    for i = 1, _MAX_FRAG do
                        lineCooldown[i].Visible = false
                        lineBuff[i].Visible = false
                    end
                end
            elseif btnHandler.Mode == Mode.Hidden then
                btnHandler.Backdrop = _BackdropEmpty
                btnHandler.MouseEnabled = false
                sizer_se.Visible = false
                lstWhite.Visible = false
                lstBlack.Visible = false
                if _UsingSpellIcon == 0 then
                    lineCooldown.Visible = false
                    lineBuff.Visible = false
                    for i = 1, _MAX_FRAG do
                        lineCooldown[i].Visible = false
                        lineBuff[i].Visible = false
                    end
                end
            end
        end
    end

    function FillBuffList()
        lstWhite:SuspendLayout()

        lstWhite:Clear()

        local name, _, icon

        for spellID in pairs(_BuffList) do
            name, _, icon = GetSpellInfo(spellID)

            lstWhite:AddItem(spellID, name, icon)
        end

        lstWhite:ResumeLayout()
    end

    function FillBlackList()
        lstBlack:SuspendLayout()

        lstBlack:Clear()

        local name, _, icon

        for spellID in pairs(_BlackList) do
            name, _, icon = GetSpellInfo(spellID)

            lstBlack:AddItem(spellID, name, icon)
        end

        lstBlack:ResumeLayout()
    end
end

------------------------------------------------------
-- Module Script Handler
------------------------------------------------------
function OnLoad(self)
    _DBChar.SpellCooldownLine = _DBChar.SpellCooldownLine or {}

    _DBChar = _DBChar.SpellCooldownLine

    _DBChar.SpellCooldownList = _DBChar.SpellCooldownList or {}
    _DBChar.ItemCooldownList = _DBChar.ItemCooldownList or {}
    _DBChar.BuffCooldownList = _DBChar.BuffCooldownList or {}
    _DBChar.BuffBlackCooldownList = _DBChar.BuffBlackCooldownList or {}

    _SpellList = _DBChar.SpellCooldownList
    _ItemList = _DBChar.ItemCooldownList
    _BuffList = _DBChar.BuffCooldownList
    _BlackList = _DBChar.BuffBlackCooldownList

    if _DBChar.SpellCooldownHandlerLocation then
        btnHandler.Location = _DBChar.SpellCooldownHandlerLocation
    end
    if _DBChar.SpellCooldownHandlerSize then
        btnHandler.Size = _DBChar.SpellCooldownHandlerSize
    end

    UpdateLine()

    if _DBChar.StartColor then
        lineCooldown.Color = _FullColor
        lineCooldown:SetGradientAlpha("HORIZONTAL",
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1,
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0
        )
        lineBuff.Color = _FullColor
        lineBuff:SetGradientAlpha("HORIZONTAL",
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1,
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0
        )
    else
        lineCooldown.Color = _NoColor
        lineBuff.Color = _NoColor
    end

    btnHandler.Mode = _DBChar.SpellCooldownHandlerMode or Mode.Normal
    UpdateMode()

    if next(_SpellList) then
        _M:RegisterEvent"SPELL_UPDATE_COOLDOWN"

        SPELL_UPDATE_COOLDOWN(self)
    else
        _M:UnregisterEvent"SPELL_UPDATE_COOLDOWN"
    end

    if next(_ItemList) then
        _M:RegisterEvent"BAG_UPDATE_COOLDOWN"

        BAG_UPDATE_COOLDOWN(self)
    else
        _M:UnregisterEvent"BAG_UPDATE_COOLDOWN"
    end

    _M:RegisterEvent"UNIT_AURA"
end

function OnEnable(self)
    function SpellBookFrame:OnShow()
        if InCombatLockdown() then
            return
        end
        UpdateMode()
        if btnHandler:GetLeft() < self:GetRight() then
            btnHandler._OldLocation = btnHandler.Location

            btnHandler:ClearAllPoints()
            btnHandler:SetPoint("BOTTOMLEFT", UIParent, self:GetRight() + 40, btnHandler:GetBottom())
        end
    end

    function SpellBookFrame:OnHide()
        UpdateMode()

        if btnHandler._OldLocation then
            btnHandler.Location = btnHandler._OldLocation
            btnHandler._OldLocation = nil
        end
    end
end

function SPELL_UPDATE_COOLDOWN(self)
    local start, duration, now

    for spell in pairs(_SpellList) do
        start, duration = GetSpellCooldown(spell)
        now = GetTime()

        if start and start > 0 and duration and duration > _GLOBAL_COOLDOWN then
            if not _SpellIconArray[spell] then
                _SpellIconArray[spell] = _RecycleIcon()
                _SpellIconArray[spell].OffsetY = 0
                _SpellIconArray[spell]:Start("Spell", spell, start, duration, now)
            else
                _SpellIconArray[spell]:Refresh(start, duration, now)
            end
        elseif _SpellIconArray[spell] then
            -- Clear for accident
            _SpellIconArray[spell]:Refresh(0, 0)
        end
    end
end

function BAG_UPDATE_COOLDOWN(self)
    local start, duration, now

    for item in pairs(_ItemList) do
        start, duration = GetItemCooldown(item)
        now = GetTime()

        if start and start > 0 and duration and duration > _GLOBAL_COOLDOWN then
            if not _ItemIconArray[item] then
                _ItemIconArray[item] = _RecycleIcon()
                _ItemIconArray[item].OffsetY = 0
                _ItemIconArray[item]:Start("Item", item, start, duration, now)
            else
                _ItemIconArray[item]:Refresh(start, duration, now)
            end
        elseif _ItemIconArray[item] then
            -- Clear for accident
            _ItemIconArray[item]:Refresh(0, 0)
        end
    end
end

function UNIT_AURA(self, unitID)
    if unitID ~= "player" then
        return
    end

    local index  = 1

    local _, duration, expires, caster, spellID, now

    now = GetTime()

    wipe(_BuffCache)

    for spellID in pairs(_BuffIconArray) do
        _BuffCache[spellID] = true
    end

    while true do
        _, _, _, _, _, duration, expires, caster, _, _, spellID = UnitBuff("player", index)

        if not spellID then
            break
        end

        _BuffCache[spellID] = nil

        if _BlackList[spellID] then
            -- pass
        else
            if not _BuffList[spellID] and expires > 0 and duration > 0 and duration < _BUFF_MAXDURATION then
                _BuffList[spellID] = true
                if lstWhite.Visible then
                    local name, _, icon = GetSpellInfo(spellID)
                    lstWhite:AddItem(spellID, name, icon)
                end
                Log(2, L"%s is added to buff line.", GetSpellLink(spellID))
            end

            if _BuffList[spellID] then
                if expires > now then
                    if not _BuffIconArray[spellID] then
                        _BuffIconArray[spellID] = _RecycleIcon()
                        _BuffIconArray[spellID].OffsetY = btnHandler.Height
                        _BuffIconArray[spellID]:Start("Buff", spellID, expires-duration, duration, now)
                    else
                        _BuffIconArray[spellID]:Refresh(expires-duration, duration, now)
                    end
                elseif _BuffIconArray[spellID] then
                    -- Clear for accident
                    _BuffIconArray[spellID]:Refresh(0, 0)
                end
            end
        end

        index = index + 1
    end

    for spellID in pairs(_BuffCache) do
        _BuffIconArray[spellID]:Refresh(0, 0)
    end
end

--------------------
-- Script Handler
--------------------
function SpellIcon_OnFinished(self)
    if self.Spell then
        _SpellIconArray[self.Spell] = nil
    end
    if self.Item then
        _ItemIconArray[self.Item] = nil
    end
    if self.Buff then
        _BuffIconArray[self.Buff] = nil
    end
    _RecycleIcon(self)
    self.Spell = nil
    self.Item = nil
    self.Buff = nil
end

function _RecycleIcon:OnInit(obj)
    obj.OnFinished = SpellIcon_OnFinished
    Log(1, "RecycleIcon Init %s.", obj.Name)
end

function _RecycleIcon:OnPop(obj)
    obj.Width = btnHandler.Width
    obj.Height = btnHandler.Height
    _UsingSpellIcon = _UsingSpellIcon + 1
    if _UsingSpellIcon == 1 then
        lineCooldown.Visible = true
        lineBuff.Visible = true
        for i = 1, _MAX_FRAG do
            lineCooldown[i].Visible = true
            lineBuff[i].Visible = true
        end
    end
end

function _RecycleIcon:OnPush(obj)
    _UsingSpellIcon = _UsingSpellIcon - 1
    if _UsingSpellIcon == 0 then
        if btnHandler.Mode ~= Mode.Normal then
            lineCooldown.Visible = false
            lineBuff.Visible = false
            for i = 1, _MAX_FRAG do
                lineCooldown[i].Visible = false
                lineBuff[i].Visible = false
            end
        end
    end
end

function sizer_se:OnMouseDown()
    if not self.Parent.InDesignMode and self.Parent.Resizable then
        self.Parent:StartSizing("BOTTOMRIGHT")
    end
end

function sizer_se:OnMouseUp()
    self.Parent:StopMovingOrSizing()
    local min = self.Parent.Height
    if self.Parent.Width < min then
        min = self.Parent.Width
    end
    self.Parent:SetSize(min, min)
    _DBChar.SpellCooldownHandlerSize = self.Parent.Size
    UpdateLine()
end

function btnHandler:OnMouseWheel(wheel)
    if wheel > 0 then
        _DBChar.StartColor = ColorType(random(100)/100, random(100)/100, random(100)/100)
        _DBChar.EndColor = ColorType(random(100)/100, random(100)/100, random(100)/100)

        lineCooldown.Color = _FullColor
        lineCooldown:SetGradientAlpha("HORIZONTAL",
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1,
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0
        )
        lineBuff.Color = _FullColor
        lineBuff:SetGradientAlpha("HORIZONTAL",
            _DBChar.StartColor.r, _DBChar.StartColor.g, _DBChar.StartColor.b, 1,
            _DBChar.EndColor.r, _DBChar.EndColor.g, _DBChar.EndColor.b, 0
        )
    else
        lineCooldown.Color = _NoColor
        lineBuff.Color = _NoColor

        _DBChar.StartColor = nil
        _DBChar.EndColor = nil
    end
end

function btnHandler:OnMouseDown(button)
    local kind, value, subtype, detail = GetCursorInfo()

    if kind then
        return btnHandler:OnReceiveDrag()
    end

    if button == "LeftButton" then
        self:StartMoving()
    end
end

function btnHandler:OnMouseUp(button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()
        self._OldLocation = nil

        _DBChar.SpellCooldownHandlerLocation = btnHandler.Location
        UpdateLine()
    elseif button == "MiddleButton" then
        self.Mode = self.Mode == Mode.Normal and Mode.Buff
                    or self.Mode == Mode.Buff and Mode.Normal

        _DBChar.SpellCooldownHandlerMode = self.Mode

        UpdateMode()
    elseif button == "RightButton" then
        self.Mode = self.Mode == Mode.Normal and Mode.Hidden
                    or self.Mode == Mode.Hidden and Mode.Normal

        _DBChar.SpellCooldownHandlerMode = self.Mode

        UpdateMode()
    end
end

function btnHandler:OnReceiveDrag()
    local type, index, subType, data = GetCursorInfo()

    if type == "spell" and index and subType then
        data = tonumber(GetSpellLink(index, subType):match("spell:(%d+)"))
        Log(1, "SPELL ID %d", data)

        if not _SpellList[data] then
            _SpellList[data] = true
            Log(2, L"%s is added to spell cooldown line.", GetSpellLink(data))
        else
            _SpellList[data] = nil
            Log(2, L"%s is removed from spell cooldown line.", GetSpellLink(data))
        end
        if next(_SpellList) then
            _M:RegisterEvent"SPELL_UPDATE_COOLDOWN"

            SPELL_UPDATE_COOLDOWN(_M)
        else
            _M:UnregisterEvent"SPELL_UPDATE_COOLDOWN"
        end
    elseif type == "item" and index then
        data = index
        Log(1, "ITEM ID %d", data)

        if GetItemSpell(data) then
            if not _ItemList[data] then
                _ItemList[data] = true
                Log(2, L"%s is added to item cooldown line.", select(2, GetItemInfo(data)))
            else
                _ItemList[data] = nil
                Log(2, L"%s is removed from item cooldown line.", select(2, GetItemInfo(data)))
            end
            if next(_ItemList) then
                _M:RegisterEvent"BAG_UPDATE_COOLDOWN"

                BAG_UPDATE_COOLDOWN(_M)
            else
                _M:UnregisterEvent"BAG_UPDATE_COOLDOWN"
            end
        end
    end

    ClearCursor()
end

function lstWhite:OnItemDoubleClick(spellID, name, icon)
    self:RemoveItem(spellID)
    lstBlack:SetItem(spellID, name, icon)
    _BuffList[spellID] = nil
    _BlackList[spellID] = true
end

function lstBlack:OnItemDoubleClick(spellID, name, icon)
    self:RemoveItem(spellID)
    lstWhite:SetItem(spellID, name, icon)
    _BuffList[spellID] = true
    _BlackList[spellID] = nil
end

function lstWhite:OnGameTooltipShow(GameTooltip, spellID)
    GameTooltip:SetSpellByID(spellID)
end

function lstBlack:OnGameTooltipShow(GameTooltip, spellID)
    GameTooltip:SetSpellByID(spellID)
end