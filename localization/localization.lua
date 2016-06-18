local L = IGAS:NewLocale("IGAS_UI")

L["ChangeLog"] = [[
<html>
<body>
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