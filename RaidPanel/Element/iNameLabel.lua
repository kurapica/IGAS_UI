-----------------------------------------
-- Name Label for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iNameLabel"
	inherit "NameLabel"
	extend "IFThreat"

	_TARGET_TEMPLATE = FontColor.RED .. ">>" .. FontColor.CLOSE .. "%s" .. FontColor.RED .. "<<" .. FontColor.CLOSE

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetText(self, text)
		self.__iNameLabelText = text or ""
		UpdateText(self)
	end

	function GetText(self)
		return self.__iNameLabelText
	end

	function UpdateText(self)
		if self.ThreatLevel >=2 then
			Super.SetText(self, _TARGET_TEMPLATE:format(self.__iNameLabelText or ""))
		else
			Super.SetText(self, self.__iNameLabelText)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ThreatLevel
	property "ThreatLevel" {
		Set = function(self, value)
			self.__iNameLabelThreatLevel = value
			UpdateText(self)
		end,
		Get = function(self)
			return self.__iNameLabelThreatLevel or 0
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "iNameLabel"

interface "IFINameLabel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFINameLabel(self)
		self:AddElement(iNameLabel)
		self.iNameLabel:SetPoint("TOPLEFT", 2, -2)
		self.iNameLabel:SetPoint("TOPRIGHT", -2, -2)

		self.iNameLabel.UseClassColor = true
		self.iNameLabel.DrawLayer = "BORDER"
    end
endinterface "IFINameLabel"

class "iRaidUnitFrame"
	extend "IFINameLabel"
endclass "iRaidUnitFrame"

interface "IFDeadNameLabel"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFDeadNameLabel(self)
		self:AddElement(NameLabel)
		self.NameLabel:SetPoint("TOPLEFT", 2, -2)
		self.NameLabel:SetPoint("TOPRIGHT", -2, -2)

		self.NameLabel.UseClassColor = true
		self.NameLabel.DrawLayer = "BORDER"
    end
endinterface "IFDeadNameLabel"

class "iDeadUnitFrame"
	extend "IFDeadNameLabel"
endclass "iDeadUnitFrame"

AddType4Config(iNameLabel, L"Name indicator")