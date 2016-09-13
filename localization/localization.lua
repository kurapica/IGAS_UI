local L = IGAS:NewLocale("IGAS_UI")

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>2016/09/13 v124 : </lime>
</p><br/>
<p>
    1. All player's buff would be shown on the raidpanel, you can right-click to send them to black list, just like the debuffs.
</p>
<br/><br/>
<p>
<lime>2016/08/30 v116 : </lime>
</p><br/>
<p>
    1. The cotnainer views would be automatically loaded with a delay with orders, so you won't suffer lag when you open them.
</p>
<p>
    2. A default container view is added, it can't be modified, and will be loaded when you entering the game, if will fix the problem that you can't use items when you entering the game with combat state.
</p>
<br/><br/>
<p>
<lime>2016/08/28 v114 : </lime>
</p><br/>
<p>
    1. 'Use Debuff Color' and 'Use Smoothing Color' is added to raidpanel's menu, so you don't need to change it in the config file.
</p>
<p>
    2. Fix the totembar on the player, the totems can be canceled now.
</p>
<br/><br/>
<p>
<lime>2016/08/24 v103 : </lime>
</p><br/>
<p>
    1. 'IsUnknownAppearance' rule added for container view to only show the items with unknow appearance that can be added to your wardrobe.
</p>
<br/><br/>
<p>
<lime>2016/08/22 v97 : </lime>
</p><br/>
<p>
    1. Bank view system added, works like the container view system.
</p>
<p>
    2. Bag slots for the container view and bank view are added, you can toggle them with a triangle button.
</p>
<p>
    3. Sort button added for the bank and container view.
</p>
<br/><br/>
<p>
<lime>2016/08/14 v93 : </lime>
</p><br/>
<p>
    1. You can modify the anchor point for every elements with the menu, so they'll fit to any resolution.
</p>
<p>
    2. Container View System is added, you can use the view manager to control how you display the slot in the bags.
</p>
<br/><br/>
<p>
<lime>2016/08/02 v88 : </lime>
</p><br/>
<p>
    1. Use alt+right-mouse on a auto-gen item button to add the item into the black list, so it won't be generated.
</p>
<br/><br/>
<p>
<lime>2016/07/31 v82 : </lime>
</p><br/>
<p>
    1. You can unlock the minimap and move/resize it.
</p>
<p>
    2. the namepalteN units can be displayed in the unit watch panel with correct health updating.
</p>
<p>
    3. Update for IGAS v101 version.
</p>
<br/><br/>
<p>
<lime>2016/07/04 v63 : </lime>
</p><br/>
<p>
    1. An unit watch panel is added to monitor units like target, focus and etc.
</p>
<p>
    2. Harmful and helpful spell can be binded with the same key, require IGAS v93 and more lastest versions.
</p>
<br/><br/>
<p>
<lime>2016/07/01 v62 : </lime>
</p><br/>
<p>
    1. You can resize the quest list to fix no quest displayed with QuestMover.
</p>
<br/><br/>
<p>
<lime>2016/06/30 v61 : </lime>
</p><br/>
<p>
    1. "Hide Global cooldown" option is added for action bar.
</p>
<br/><br/>
<p>
<lime>2016/06/29 v60 : </lime>
</p><br/>
<p>
    1. You can find 'Use cooldown label' in the menu to add a cooldown label.
</p>
<p>
    2. You can change the aura icon's size of the raid panel.
</p>
<p>
    3. The settings of the raid panel now follow the character's Specialization.
</p>
<br/><br/>
<p>
<lime>2016/06/21 v59 : </lime>
</p><br/>
<p>
    1. The menu of the action bar system is re-arranged.
</p>
<p>
    2. You can find 'Color the action button' in the menu to set color for the action buttons under several conditions.
</p>
<br/><br/>
<p>
<lime>2016/06/01 v58 : </lime>
</p><br/>
<p>
    1. You can choose the reversed order to generate the item list.
</p>
<br/><br/>
<p>
<lime>2016/06/01 v57 : </lime>
</p><br/>
<p>
    1. You can move the task list to anywhere now.
</p>
<br/><br/>
<p>
<lime>2016/06/04 v50 : </lime>
</p><br/>
<p>
    1. The unit frame system can use auto hide now.
</p>
<p>
    2. The auto hide for action bar and unit system now use macro conditions, a macro condition maker form is added, you can find it by click the 'Auto Hide' in the menus.
</p>
<p>
    3. Three default macro condition is applied, one is 'solo with no target no combat', the second is 'in pet battle' and the last is 'in the vehicle', more can added by yourself.
</p>
<br/><br/>
<p>
<lime>2016/06/01 v47 : </lime>
</p><br/>
<p>
    1. Single action bar's layout can be save now, also can be applied to other single action bars.
</p>
<br/><br/>
<p>
<lime>2016/03/08 v41 : </lime>
</p><br/>
<p>
    1. Add "Auto generate popup actions" in the action bar's menu. You can use it to config the root button of a popup-action button list, like auto-generte a list of potion items. The root button can only be normal button(not map to blizzard's action bar, and etc) with popup buttons. You can bind many root buttons to one action list, so the actions would be generated on those buttons with orders.
</p>
<p>
    2. Right-click popup-action root button wouldn't trigger the action now.
</p>
<br/><br/>
<p>
<lime>2016/02/28 v40 : </lime>
</p><br/>
<p>
    1. Reduce memory increasement.
</p>
<p>
    2. A simple change on chat frames.
</p>
<br/><br/>
<p>
<lime>2014/04/02 v33 : </lime>
</p><br/>
<p>
    1. The main menu bag slots are replaced, need IGAS v71.
</p>
<p>
    2. You can change the popup-actionbar's duration in the config menu.
</p>
<br/><br/>
<p>
<lime>2014/04/02 v32 : </lime>
</p><br/>
<p>
    1. Using config file to define what and how the elements should be shown on the screen for each unit frames in raidpanel and unitframe module.
</p>
<p>
    2. Now you can use right-click toggle show/hide the unit frames.
</p>
<br/><br/>
<p>
<lime>2013/11/8 v31 : </lime>
</p><br/>
<p>
    1. A new feature added for the raid panel, used to send debuff to black list when right-click on it, can be disabled in the "Element Settings" -> "Right mouse-click send debuff to black list".
</p><br/><p>
    2. Debuffs in raid panel will be started from bottom-right to top-left, supported by the IGAS lib v55 which would be released in the future week.
</p><br/><p>
    3. Enable the tooltip for buff/debuff will block the mouse action, so you can disabled it in "Element Settings" -> "Show buff/debuff tootip".
</p>
<br/><br/>
<p>
<lime>2013/11/6 v30 : </lime>
</p><br/>
<p>
    1. Lots configuration of the raid panel added to the config menu, like class color, size, group filter and etc.
</p><br/><p>
    2. Raid panel will show all debuffs that you and your team faced, can be send to black list in the config menu : "Element Settings" -> "Debuff filter".
</p>
<br/><br/>
<p>
<lime>2013/10/20: v29 </lime>
</p><br/>
<p>
	1. New Dead panel added to the RaidPanel, only show the dead players in the raid(party), default deactivated. Also a menu added to support it.
</p>
</body>
</html>
]]

L["Unit List Info"] = [[
<html>
<body>
<p>
The unit id is the identifier that is related to how the player is accessing the unit. like 'player' is the player itself, 'target' is the player's target, and 'targettarget' is the target's target.
</p>
<br/>
<p><lime>The base units :</lime></p><br/>
<p><lightgreen>"arenaN"</lightgreen> Opposing arena member with index N (1,2,3,4 or 5).</p>
<p><lightgreen>"arenapetN"</lightgreen>The pet of the Nth opposing arena member (N is 1,2,3,4 or 5).</p>
<p><lightgreen>"bossN"</lightgreen>The active bosses of the current encounter if available N (1,2,3 or 4).</p>
<p><lightgreen>"focus"</lightgreen>The current player's focus target as selected by the /focus command.</p>
<p><lightgreen>"partyN"</lightgreen>The Nth party member excluding the player (1,2,3 or 4).</p>
<p><lightgreen>"partypetN"</lightgreen>The pet of the Nth party member (N is 1,2,3, or 4).</p>
<p><lightgreen>"pet"</lightgreen>The current player's pet.</p>
<p><lightgreen>"player"</lightgreen>The current player.</p>
<p><lightgreen>"raidN"</lightgreen>The raid member with raidIndex N (1,2,3,...,40).</p>
<p><lightgreen>"raidpetN"</lightgreen>The pet of the raid member with raidIndex N (1,2,3,...,40)</p>
<p><lightgreen>"target"</lightgreen>The currently targeted unit.</p>
<p><lightgreen>"vehicle"</lightgreen>The current player's vehicle.</p>
<br/><br/>
<p><lime>Special units :</lime></p><br/>
<p><lightgreen>"maintank"</lightgreen> The main tank.</p>
<p><lightgreen>"mainassist"</lightgreen> The main assist, normally the off-tank.</p>
<p><lightgreen>"tank"</lightgreen> The tanks.</p>
<br/><br/>
<p><lime>Targets :</lime></p><br/>
<p>You can append the suffix target to any UnitId to get a UnitId which refers to that unit's target (e.g. "partypet2target"), you can aslo add target suffix to special unit like "maintanktarget", it'll be converted.</p>
</body>
</html>
]]