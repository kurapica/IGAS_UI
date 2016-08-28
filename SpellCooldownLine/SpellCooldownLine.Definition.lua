-----------------------------------------
-- Definition for Spell cooldown line
-----------------------------------------

IGAS:NewAddon "IGAS_UI.SpellCooldownLine"

-----------------------------------------------
--- SpellIcon
-- @type class
-- @name SpellIcon
-----------------------------------------------
class "SpellIcon"
    inherit "Frame"

    _Full_Alpha = 0.8

    local GetTime = GetTime
    local random = math.random

    ------------------------------------------------------
    -- Event
    ------------------------------------------------------
    event "OnFinished"

    ------------------------------------------------------
    -- Method
    ------------------------------------------------------
    ------------------------------------
    --- Start for spell
    -- @name Start
    -- @type function
    -- @param spell
    -- @param start
    -- @param duration
    -- @return nil
    ------------------------------------
    function Start(self, type, spell, start, duration, time)
        self[type] = spell

        self.__Start = start
        self.__Duration = duration

        time = time or GetTime()

        local posx, posy = GetPosition(start, duration), 60 - random(120)
        self:SetPoint("CENTER", posx, posy)

        local posxNext = GetPosition(start, duration, time + self.agInLine.trans.Duration)
        self.agInLine.trans:SetOffset(posxNext - posx, - posy + self.OffsetY)

        self.agInLine.Playing = true
    end

    ------------------------------------
    --- Refresh the spell icon's animation system
    -- @name Refresh
    -- @type function
    -- @param start
    -- @param duration
    -- @return nil
    ------------------------------------
    function Refresh(self, start, duration, time)
        if start and duration then
            if start ~= self.__Start or duration ~= self.__Duration then
                self.__Start = start
                self.__Duration = duration

                time = time or GetTime()

                if self.__Start + self.__Duration <= time then
                    if self.agInLine.Playing or self.agTrans.Playing then
                        self.agInLine.Playing = false
                        self.agTrans.Playing = false
                        self:SetPoint("CENTER", 0, self.OffsetY)
                        self.agFinal.Playing = true
                    end
                elseif self.agFinal.Playing then
                    -- Another triggered
                    self.agFinal.Playing = false
                    return self:Refresh()
                else
                    -- pass
                end
            else
                -- Wait self call
                return
            end
        end

        local now = GetTime()

        if self.__Start + self.__Duration > now then
            local posx, posxN, dura = GetPosition(self.__Start, self.__Duration, now)

            self.agTrans.Playing = false

            self:SetPoint("CENTER", posx, self.OffsetY)
            self.agTrans.trans:SetOffset(posxN - posx, 0)
            self.agTrans.trans.Duration = dura

            self.agTrans.Playing = true
        else
            self:SetPoint("CENTER", 0, self.OffsetY)
            self.agFinal.Playing = true
        end
    end

    ------------------------------------------------------
    -- Property
    ------------------------------------------------------
    -- Spell
    property "Spell" {
        Handler = function(self, value)
            self.Icon.TexturePath = value and GetSpellTexture(value)
            if value then
                self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end,
        Type = StringNumber,
    }
    -- Item
    property "Item" {
        Handler = function(self, value)
            self.Icon.TexturePath = value and GetItemIcon(value)
            if value then
                self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end,
        Type = StringNumber,
    }
    -- Buff
    property "Buff" {
        Handler = function(self, value)
            self.Icon.TexturePath = value and GetSpellTexture(value)
            if value then
                self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end,
        Type = StringNumber,
    }
    -- OffsetY
    property "OffsetY" { Type = Number }

    ------------------------------------------------------
    -- Script handler
    ------------------------------------------------------
    local function agInLine_OnPlay(self)
        self.Parent.Visible = true
        self.Parent.Alpha = 0
    end

    local function agInLine_OnFinished(self)
        self.Parent:Refresh()
        self.Parent.Alpha = _Full_Alpha
    end

    local function agTrans_OnFinished(self)
        self.Parent:Refresh()
    end

    local function agFinal_OnFinished(self)
        self.Parent.Visible = false
        return self.Parent:Fire("OnFinished")
    end

    ------------------------------------------------------
    -- Constructor
    ------------------------------------------------------
    function SpellIcon(self, name, parent, ...)
        Super(self, name, parent, ...)

        local icon = Texture("Icon", self, "BACKGROUND")
        icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)

        local mask = Texture("mask", self)
        mask:SetAllPoints()
        mask.DrawLayer = "OVERLAY"
        mask.TexturePath = Media.BORDER_TEXTURE_PATH
        mask.VertexColor = Media.PLAYER_CLASS_COLOR

        self.Width = parent.Width
        self.Height = parent.Height

        -- Inline Animation
        local agInLine = AnimationGroup("agInLine", self)
        agInLine.OnPlay = agInLine_OnPlay
        agInLine.OnFinished = agInLine_OnFinished

        local alphaInLine = Alpha("alpha", agInLine)
        alphaInLine.Order = 1
        alphaInLine.FromAlpha = 0
        alphaInLine.ToAlpha = _Full_Alpha
        alphaInLine.Duration = 1

        local tranInLine = Translation("trans", agInLine)
        tranInLine.Order = 1
        tranInLine.Duration = 1

        -- Moving Animation
        local agTrans = AnimationGroup("agTrans", self)
        agTrans.OnFinished = agTrans_OnFinished

        local trans = Translation("trans", agTrans)
        trans.Order = 1

        -- Scale Animation
        local agFinal = AnimationGroup("agFinal", self)
        agFinal.OnFinished = agFinal_OnFinished

        local scale = Scale("scale", agFinal)
        scale.Order = 1
        scale.Duration = 1
        scale.Scale = Dimension(2, 2)

        local scale2 = Scale("scale2", agFinal)
        scale2.Order = 2
        scale2.Duration = 0.4
        scale2.Scale = Dimension(0.4, 0.4)

        local alphaScale = Alpha("alpha", agFinal)
        alphaScale.Order = 2
        alphaScale.Duration = 0.4
        alphaScale.FromAlpha = _Full_Alpha
        alphaScale.ToAlpha = 0
    end
endclass "SpellIcon"
