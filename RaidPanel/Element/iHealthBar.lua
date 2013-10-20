-----------------------------------------
-- Health Bar for UnitFrame
-----------------------------------------

IGAS:NewAddon "IGAS_UI.RaidPanel"

class "iHealthBar"
	inherit "HealthBar"
	extend "iStatusBarStyle""iBorder"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function iHealthBar(self)
		self.UseDebuffColor = true
		if _DBChar.ElementUseClassColor then
			self.UseClassColor = true
		end
		self.FrameLevel = self.FrameLevel + 1
	end
endclass "iHealthBar"

interface "IFIHealthBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFIHealthBar(self)
		self:AddElement(iHealthBar, "rest")
		self:AddElement(MyHealPredictionBar)
		self:AddElement(AllHealPredictionBar)
		self:AddElement(TotalAbsorbBar)
		self:AddElement(HealAbsorbBar)

		self.MyHealPredictionBar.HealthBar = self.iHealthBar
		self.AllHealPredictionBar.HealthBar = self.iHealthBar
		self.TotalAbsorbBar.HealthBar = self.iHealthBar
		self.HealAbsorbBar.HealthBar = self.iHealthBar
    end
endinterface "IFIHealthBar"

partclass "iRaidUnitFrame"
	extend "IFIHealthBar"
endclass "iRaidUnitFrame"

interface "IFDeadHealthBar"
	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFDeadHealthBar(self)
		self:AddElement(iHealthBar, "rest")
    end
endinterface "IFDeadHealthBar"

partclass "iDeadUnitFrame"
	extend "IFDeadHealthBar"
endclass "iDeadUnitFrame"

AddType4Config(MyHealPredictionBar, L"My heal prediction")
AddType4Config(AllHealPredictionBar, L"All heal prediction")
AddType4Config(TotalAbsorbBar, L"Total Absorb")
AddType4Config(HealAbsorbBar, L"Heal Absorb")