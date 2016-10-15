-----------------------------------------
-- Designer for Manager
-----------------------------------------
IGAS:NewAddon "IGAS_UI.Manager"

import "System.Widget"

manager = Form("IGAS_UI_Manager")

manager:SetSize(200, 240)
manager:ClearAllPoints()
manager:SetPoint("LEFT")

manager.Caption = L"IGAS UI"
manager.DockMode = true
manager.HideForCombat = true
manager.Visible = false
manager.Resizable = false

TOP = 26

-- Modules
for _, subMdl in _Addon:GetModules() do
	if subMdl ~= _M and subMdl.Toggle then
		local toggle = subMdl.Toggle
		local chkToggle = CheckBox("Toggle_"..subMdl._Name, manager)

		chkToggle:SetPoint("TOP", 0, - TOP)
		chkToggle:SetPoint("LEFT", 2)
		chkToggle.Text = toggle.Message
		chkToggle.OnClick:Clear()

		function chkToggle:OnClick()
			toggle.Set(not self.Checked)
		end

		function chkToggle:OnShow()
			self.Checked = toggle.Get()
		end

		function toggle.Update()
			chkToggle.Checked = toggle.Get()
		end

		TOP = TOP + chkToggle.Height
	end
end

manager.Height = TOP