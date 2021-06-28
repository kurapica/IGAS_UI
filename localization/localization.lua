local L = IGAS:NewLocale("IGAS_UI")

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>Thanks for keeping use the IGAS_UI, but I'm sorry IGAS and IGAS_UI are officially abandoned. All replacements are done by now, they are more powerful and smoothing.</lime>
</p>
<br/>
<p>
<lightgreen>Action Bar</lightgreen> https://www.curseforge.com/wow/addons/ShadowDancer
</p>
<br/>
<p>
<lightgreen>Raid Panel</lightgreen> https://www.curseforge.com/wow/addons/AshToAsh
</p>
<br/>
<p>
<lightgreen>Nameplate</lightgreen> https://www.curseforge.com/wow/addons/Aim
</p>
<br/>
<p>
<lightgreen>Bag Container</lightgreen> https://www.curseforge.com/wow/addons/BagView
</p>
<br/>
<p>
<lightgreen>Unit Frame</lightgreen> https://github.com/kurapica/AshUnitFrame
</p>
<br/>
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