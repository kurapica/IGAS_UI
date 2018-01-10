local L = IGAS:NewLocale("IGAS_UI")

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>2018/01/10 v216 : </lime>
</p><br/>
<p>
    1. "As Global" menu added for the action bar, so the action bar should be used by all characters and all specialization.
</p>
<br/><br/>
<p>
<lime>2017/11/29 v205 : </lime>
</p><br/>
<p>
    1. The action bar support Masque now.
</p>
<p>
    2. If an action bar has only one button with its branches, you can use "Square Layout" or "Circle Layout" to change their locations with more easy ways.
</p>
<p>
    3. Two new action map : World Markder, Raid target.
</p>
<br/><br/>
<p>
<lime>2017/10/31 v204 : </lime>
</p><br/>
<p>
    1. You can save or load the action bar's layout with the contents.
</p>
<br/><br/>
<p>
<lime>2017/08/14 v190 : </lime>
</p><br/>
<p>
    1. Max opacity and min opacity settings are added for the action bar system.
</p>
<br/><br/>
<p>
<lime>2017/05/05 v184 : </lime>
</p><br/>
<p>
    1. A macro binding editor is added for raid panel, so now you can bind keys for macros.
</p>
<p>
    2. You can give order to buffs now, so important buffs would be shown in the first place.
</p>
<br/><br/>
<p>
<lime>2017/04/29 v182 : </lime>
</p><br/>
<p>
    1. "Smoothing updating" added for raid panel, it'll smooth the updating of the healthbar, you also can modify the smoothing delay.
</p>
<br/><br/>
<p>
<lime>2017/03/27 v172 : </lime>
</p><br/>
<p>
    1. A menu "Press down trigger" added for raid panel, so you can cast spell by press down the button directly.
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