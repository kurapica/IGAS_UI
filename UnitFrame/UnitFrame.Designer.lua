IGAS:NewAddon "IGAS_UI.UnitFrame"

arUnit = Array(iUnitFrame)

--==========================
-- Generate unit frames based on Config.Units
--==========================
for _, unitset in ipairs(Config.Units) do
	for i = 1, unitset.Max or 1 do
		local unit = unitset.Unit:format(i)

		local frm = iUnitFrame("IGAS_UI_" .. unit:gsub("^%a", strupper) .. "Frame")
		if unitset.Size then frm.Size = unitset.Size end
		if unitset.Location then
			for _, loc in ipairs(unitset.Location) do
				local relativeTo

				if type(loc.relativeTo) == "string" then
					relativeTo = loc.relativeTo:format(i)

					for _, ufrm in ipairs(arUnit) do
						if ufrm.Unit == relativeTo then
							relativeTo = ufrm
							break
						end
					end
				else
					relativeTo = loc.relativeTo or UIParent
				end

				if i > 1 and (unitset.DX or unitset.DY) then
					loc.xOffset = loc.xOffset + unitset.DX or 0
					loc.yOffset = loc.yOffset + unitset.DY or 0
				end

				frm:SetPoint(loc.point, relativeTo, loc.relativePoint or loc.point, loc.xOffset or 0, loc.yOffset or 0)
			end
		end

		frm.Unit = unit

		if type(unitset.Init) == "function" then
			pcall(unitset.Init, frm)
		end

		frm:ApplyConfig(unitset.Elements)

		if type(unitset.Loaded) == "function" then
			pcall(unitset.Loaded, frm)
		end

		if unit == "player" then frmPlayer = frm end
	end
end