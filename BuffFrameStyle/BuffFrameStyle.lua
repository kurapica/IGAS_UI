-----------------------------------------
-- BuffFrameStyle
-----------------------------------------
IGAS:NewAddon "IGAS_UI.BuffFrameStyle"

import "System.Widget"

_BorderTexture = [[Interface\Addons\IGAS_UI\Resource\border.tga]]

_Masked = {}

_M:SecureHook("BuffButton_OnLoad")
_M:SecureHook(_G.GameTooltip, "SetUnitAura", SetUnitAura)

function BuffButton_OnLoad(self)
	BuildStyle(self)
end

function BuildStyle(buff)
	if not _Masked[buff] then
		_Masked[buff] = true

		local mask = Texture("IGAS_UI_Mask", buff)
		mask:SetAllPoints()
		mask.DrawLayer = "OVERLAY"
		mask.TexturePath = _BorderTexture
		mask.VertexColor = Media.PLAYER_CLASS_COLOR

		local icon = _G[buff:GetName() .. "Icon"]
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", buff, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -2, 2)

		_M:SecureHook(icon, "SetTexture", HookSetTexture)
	end
end

function HookSetTexture(self, path)
	if path then
		self:SetTexCoord(0.06, 0.94, 0.06, 0.94)
	end
end

local _prev = GetTime()
local _DefaultColor = ColorType(1, 1, 1)

function SetUnitAura(self, unit, index, filter)
	if not unit or not index then return end

	if GetTime() == _prev then return end
	_prev = GetTime()

	local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

	if name then
		self:AddLine("    ")
		local casterName = caster and GetUnitName(caster)
		local casterCls = caster and RAID_CLASS_COLORS[select(2, UnitClass(caster))] or _DefaultColor
		self:AddDoubleLine("ID: " .. tostring(spellID), casterName or "", 1, 1, 1, casterCls.r, casterCls.g, casterCls.b)

		self:Show()
	end
end
