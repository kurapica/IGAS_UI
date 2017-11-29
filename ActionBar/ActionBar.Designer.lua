-----------------------------------------
-- Designer for Action Bar
-----------------------------------------

IGAS:NewAddon "IGAS_UI.ActionBar"

_HeadList = Array()

-----------------------------------------
-- Menu
-----------------------------------------
_Menu = DropDownList("Menu", IGAS.UIParent.IGAS_IFActionHandler_Manager)
_Menu.MultiSelect = true

_MenuClose = _Menu:AddMenuButton(L"Close Menu")

_MenuMap = _Menu:AddMenuButton(L"Action Map")
_ListActionMap = List("LstActionMap", _MenuMap)
_ListActionMap:SetList({
	L"None",
	L"Main Bar",
	L"Bar 1",
	L"Bar 2",
	L"Bar 3",
	L"Bar 4",
	L"Bar 5",
	L"Bar 6",
	L"Pet Bar",
	L"Stance Bar",
	L"World Mark",
	L"Raid Target",
})
_ListActionMap.Width = 150
_ListActionMap.Height = 250
_ListActionMap.Visible = false
_MenuMap.DropDownList = _ListActionMap

_MenuLock = _Menu:AddMenuButton(L"Global Style", L"Lock Action")
_MenuLock.IsCheckButton = true

_MenuScale = _Menu:AddMenuButton(L"Bar Style", L"Scale")
_ListScale = List("LstScale", _MenuScale)
local key, item = {}, {}
for i = 1, 20 do
	key[i] = i/10
	item[i] = tostring(key[i])
end
_ListScale.Keys = key
_ListScale.Items = item
_ListScale.Width = 150
_ListScale.Height = 250
_ListScale.Visible = false
_MenuScale.DropDownList = _ListScale

_MenuMarginX = _Menu:AddMenuButton(L"Bar Style", L"Horizontal Margin")
_ListMarginX = List("LstMarginX", _MenuMarginX)
local key, item = {}, {}
for i = 1, 33 do
	key[i] = 17 - i
	item[i] = tostring(key[i])
end
_ListMarginX.Keys = key
_ListMarginX.Items = item
_ListMarginX.Width = 150
_ListMarginX.Height = 250
_ListMarginX.Visible = false
_MenuMarginX.DropDownList = _ListMarginX

_MenuMarginY = _Menu:AddMenuButton(L"Bar Style", L"Vertical Margin")
_ListMarginY = List("LstMarginY", _MenuMarginY)
local key, item = {}, {}
for i = 1, 33 do
	key[i] = 17 - i
	item[i] = tostring(key[i])
end
_ListMarginY.Keys = key
_ListMarginY.Items = item
_ListMarginY.Width = 150
_ListMarginY.Height = 250
_ListMarginY.Visible = false
_MenuMarginY.DropDownList = _ListMarginY

_MenuAutoHide = _Menu:AddMenuButton(L"Bar Style", L"Auto Hide")
_MenuAutoHide:ActiveThread("OnClick")

_MenuAutoFadeOut = _Menu:AddMenuButton(L"Bar Style", L"Auto Fade Out")
_MenuAutoFadeOut.IsCheckButton = true

_MenuMaxAlpha = _Menu:AddMenuButton(L"Bar Style", L"Max Opacity")
_MenuMaxAlpha:ActiveThread("OnClick")

_MenuMinAlpha = _Menu:AddMenuButton(L"Bar Style", L"Min Opacity")
_MenuMinAlpha:ActiveThread("OnClick")

_MenuAlwaysShowGrid = _Menu:AddMenuButton(L"Bar Style", L"Always Show Grid")
_MenuAlwaysShowGrid.IsCheckButton = true

_MenuUseDown = _Menu:AddMenuButton(L"Global Style", L"Press down trigger")
_MenuUseDown.IsCheckButton = true

_MenuPopupDuration = _Menu:AddMenuButton(L"Global Style", L"Popup Duration")
_MenuPopupDuration:ActiveThread("OnClick")

_MenuKeyBinding = _Menu:AddMenuButton(L"Key Binding")

_MenuFreeMode = _Menu:AddMenuButton(L"Bar Style", L"Free Mode")
_MenuFreeMode.IsCheckButton = true

_MenuFreeSquare = _Menu:AddMenuButton(L"Bar Style", L"Free Mode", L"Square Layout")
_MenuFreeSquare:ActiveThread("OnClick")
_MenuFreeCircle = _Menu:AddMenuButton(L"Bar Style", L"Free Mode", L"Circle Layout")
_MenuFreeCircle:ActiveThread("OnClick")

_MenuManual = _Menu:AddMenuButton(L"Manual Move&Resize")

_MenuSwap = _Menu:AddMenuButton(L"Bar Style", L"Swap Pop-up action")
_MenuSwap.IsCheckButton = true

_MenuAutoGenerate = _Menu:AddMenuButton(L"Auto generate popup actions")
_MenuAutoGenerate:ActiveThread("OnClick")

_MenuSaveSet = _Menu:AddMenuButton(L"Save & Load", L"Save Settings")
_ListSaveSet = List("LstSaveSet", _MenuSaveSet)
_ListSaveSet.Width = 150
_ListSaveSet.Height = 250
_ListSaveSet.Visible = false
_MenuSaveSet.DropDownList = _ListSaveSet

_MenuLoadSet = _Menu:AddMenuButton(L"Save & Load", L"Load Settings")
_ListLoadSet = List("LstLoadSet", _MenuLoadSet)
_ListLoadSet.Width = 150
_ListLoadSet.Height = 250
_ListLoadSet.Visible = false
_MenuLoadSet.DropDownList = _ListLoadSet

_MenuSave = _Menu:AddMenuButton(L"Save & Load", L"Save Layout")
_ListSave = List("LstSave", _MenuSave)
_ListSave.Width = 150
_ListSave.Height = 250
_ListSave.Visible = false
_MenuSave.DropDownList = _ListSave

_MenuLoad = _Menu:AddMenuButton(L"Save & Load", L"Load Layout")
_ListLoad = List("LstLoad", _MenuLoad)
_ListLoad.Width = 150
_ListLoad.Height = 250
_ListLoad.Visible = false
_MenuLoad.DropDownList = _ListLoad

_MenuBarSave = _Menu:AddMenuButton(L"Save & Load", L"Save action bar's layout")
_ListBarSave = List("LstBarSave", _MenuBarSave)
_ListBarSave.Width = 150
_ListBarSave.Height = 250
_ListBarSave.Visible = false
_MenuBarSave.DropDownList = _ListBarSave

_MenuBarLoad = _Menu:AddMenuButton(L"Save & Load", L"Apply action bar's layout")
_ListBarLoad = List("LstBarLoad", _MenuBarLoad)
_ListBarLoad.Width = 150
_ListBarLoad.Height = 250
_ListBarLoad.Visible = false
_MenuBarLoad.DropDownList = _ListBarLoad

_MenuBarContentSave = _Menu:AddMenuButton(L"Save & Load", L"Save action bar's settings")
_ListBarContentSave = List("LstBarSave", _MenuBarContentSave)
_ListBarContentSave.Width = 150
_ListBarContentSave.Height = 250
_ListBarContentSave.Visible = false
_MenuBarContentSave.DropDownList = _ListBarContentSave

_MenuBarContentLoad = _Menu:AddMenuButton(L"Save & Load", L"Apply action bar's settings")
_ListBarContentLoad = List("LstBarLoad", _MenuBarContentLoad)
_ListBarContentLoad.Width = 150
_ListBarContentLoad.Height = 250
_ListBarContentLoad.Visible = false
_MenuBarContentLoad.DropDownList = _ListBarContentLoad

_MenuHideBlz = _Menu:AddMenuButton(L"Global Style", L"Hidden MainMenuBar")
_MenuHideBlz.IsCheckButton = true

_MenuDelete = _Menu:AddMenuButton(L"Delete Bar")
_MenuDelete:ActiveThread("OnClick")

_MenuNew = _Menu:AddMenuButton(L"New Bar")
_MenuNew:ActiveThread("OnClick")

_MenuNoGCD = _Menu:AddMenuButton(L"Global Style", L"Hide Global cooldown")
_MenuNoGCD.IsCheckButton = true

_MenuColorBar = _Menu:AddMenuButton(L"Global Style", L"Color the action button")

_MenuColorToggle = _MenuColorBar:AddMenuButton(L"Enable")
_MenuColorToggle:ActiveThread("OnClick")

_MenuColorOOM = _MenuColorBar:AddMenuButton(L"Lack of resource")
_MenuColorOOM.IsColorPicker = true

_MenuColorOOR = _MenuColorBar:AddMenuButton(L"Out of range")
_MenuColorOOR.IsColorPicker = true

_MenuColorUnusable = _MenuColorBar:AddMenuButton(L"Unusable for other reason")
_MenuColorUnusable.IsColorPicker = true

_MenuCDLabel = _Menu:AddMenuButton(L"Global Style", L"Use cooldown label")

_MenuCDLabelToggle = _MenuCDLabel:AddMenuButton(L"Enable")
_MenuCDLabelToggle:ActiveThread("OnClick")

_MenuSowAutoGenBlackList = _Menu:AddMenuButton(L"Global Style", L"Show item black list")

_MenuModifyAnchorPoints = _Menu:AddMenuButton(L"Bar Style", L"Modify AnchorPoints")
_MenuModifyAnchorPoints:ActiveThread("OnClick")

-----------------------------------
-- Auto-gen Item Black List
-----------------------------------
_AutoGenBlackListForm = Form("IGAS_UI_AutoGen_Black_List")
_AutoGenBlackListForm.Caption = L"Auto-gen item black list"
_AutoGenBlackListForm.Message = L"Double click to remove"
_AutoGenBlackListForm:SetSize(300, 400)
_AutoGenBlackListForm:Hide()

_AutoGenBlackListList = List("List", _AutoGenBlackListForm)
_AutoGenBlackListList:SetPoint("TOPLEFT", 4, -26)
_AutoGenBlackListList:SetPoint("BOTTOMRIGHT", -4, 26)
_AutoGenBlackListList.ShowTooltip = true


-----------------------------------
-- Free (Square|Circle) Mask
-----------------------------------
_FreeMask = Mask("IGAS_UI_Free_Mask")
_FreeMask.AsMove = true
_FreeMask:ActiveThread("OnMoveStarted")
_FreeMask:ActiveThread("OnMoveFinished")

function _FreeMask:OnMoveStarted()
	self.FreeMoving = true

	local bar = self.Parent.Root
	local branch = bar.Branch
	local count = 0

	while branch do
		count = count + 1
		branch = branch.Branch
	end

	self.BranchCount = count

	Task.Next()

	while self.Visible and self.FreeMoving and not InCombatLockdown() do
		RefreshPopupBarLayout(bar, self.Mode, count)

		Task.Next()
	end
end

function _FreeMask:OnMoveFinished()
	self.FreeMoving = false

	Task.Next() Task.Next()

	if self.Parent then
		RefreshPopupBarLayout(self.Parent.Root, self.Mode, self.BranchCount, true)
	end
end

function RefreshPopupBarLayout(self, mode, count, fix)
	local branch = self.Branch

	local sx, sy = self:GetCenter()
	local x, y = branch:GetCenter()

	x = x - sx
	y = y - sy

	if mode == "Circle" then
		local pangle = math.floor(360 / count)
		local sangle

		if x == 0 then
			if y > 0 then
				sangle = 90
			else
				sangle = 270
			end
		else
			sangle = math.atan(y / x) / math.pi * 180

			if y > 0 and x < 0 then
				sangle = sangle + 180
			elseif y < 0 and x < 0 then
				sangle = sangle + 180
			elseif y < 0 and x > 0 then
				sangle = sangle + 360
			end
		end

		if fix then
			if sangle > math.floor(sangle / 10) * 10 + 5 then
				sangle = math.ceil(sangle / 10) * 10
			else
				sangle = math.floor(sangle / 10) * 10
			end
		end

		local radius 	= math.floor(math.sqrt(x ^ 2 + y ^ 2))

		for i = fix and 0 or 1, count - 1 do
			if i > 0 then
				sangle = sangle - pangle
				branch = branch.Branch
			end

			if sangle < 0 then sangle = sangle + 360 end

			x = radius * math.cos(sangle / 180 * math.pi)
			y = radius * math.sin(sangle / 180 * math.pi)

			branch:ClearAllPoints()
			branch:SetPoint("CENTER", self, "CENTER", x, y)
		end
	elseif mode == "Square" then
		local size 		= math.max(math.abs(x), math.abs(y))
		local pdis  	= size * 8 / count
		local sp

		if x == - size then
			sp = y + size
		elseif x == size then
			sp = size * 5 - y
		elseif y == size then
			sp = size * 3 + x
		else
			sp = size * 7 - x
		end

		for i = 1, count - 1 do
			branch = branch.Branch

			sp = (sp + pdis) % (size * 8)

			if sp <= 2 * size then
				x = - size
				y = sp - size
			elseif sp <= 4 * size then
				y = size
				x = sp - 3 * size
			elseif sp <= 6 * size then
				x = size
				y = size - (sp - 4 * size)
			else
				y = - size
				x = size - (sp - 6 * size)
			end

			branch:ClearAllPoints()
			branch:SetPoint("CENTER", self, "CENTER", x, y)
		end
	end
end