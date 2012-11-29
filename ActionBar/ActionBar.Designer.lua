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
	L"Quest Bar",
	L"Pet Bar",
	L"Stance Bar",
})
_ListActionMap.Width = 150
_ListActionMap.Height = 250
_ListActionMap.Visible = false
_MenuMap.DropDownList = _ListActionMap

_MenuLock = _Menu:AddMenuButton(L"Lock Action")
_MenuLock.IsCheckButton = true

_MenuScale = _Menu:AddMenuButton(L"Scale")
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

_MenuMarginX = _Menu:AddMenuButton(L"Horizontal Margin")
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

_MenuMarginY = _Menu:AddMenuButton(L"Vertical Margin")
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

_MenuAutoHide = _Menu:AddMenuButton(L"Auto Hide")
_MenuHideOutOfCombat = _MenuAutoHide:AddMenuButton(L"Out of combat")
_MenuHideInPetBattle = _MenuAutoHide:AddMenuButton(L"In petbattle")
_MenuHideInVehicle = _MenuAutoHide:AddMenuButton(L"In vehicle")
_MenuHideOutOfCombat.IsCheckButton = true
_MenuHideInPetBattle.IsCheckButton = true
_MenuHideInVehicle.IsCheckButton = true
_MenuAutoHide.DropDownList.MultiSelect = true

_MenuUseDown = _Menu:AddMenuButton(L"Use mouse down")
_MenuUseDown.IsCheckButton = true

_MenuKeyBinding = _Menu:AddMenuButton(L"Key Binding")

_MenuFreeMode = _Menu:AddMenuButton(L"Free Mode")
_MenuFreeMode.IsCheckButton = true

_MenuManual = _Menu:AddMenuButton(L"Manual Move&Resize")

_MenuSave = _Menu:AddMenuButton(L"Save Layout")
_ListSave = List("LstSave", _MenuSave)
_ListSave.Width = 150
_ListSave.Height = 250
_ListSave.Visible = false
_MenuSave.DropDownList = _ListSave

_MenuLoad = _Menu:AddMenuButton(L"Load Layout")
_ListLoad = List("LstLoad", _MenuLoad)
_ListLoad.Width = 150
_ListLoad.Height = 250
_ListLoad.Visible = false
_MenuLoad.DropDownList = _ListLoad

_MenuHideBlz = _Menu:AddMenuButton(L"Hidden MainMenuBar")
_MenuHideBlz.IsCheckButton = true

_MenuDelete = _Menu:AddMenuButton(L"Delete Bar")
_MenuDelete:ActiveThread("OnClick")

_MenuNew = _Menu:AddMenuButton(L"New Bar")
_MenuNew:ActiveThread("OnClick")
