local L = IGAS:NewLocale("IGAS_UI", "zhTW")
if not L then return end

L["Change Log"] = "更新日誌"

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>2016/08/22 v97 : </lime>
</p><br/>
<p>
    1. 銀行視圖系統追加，工作方式類似背包視圖系統。
</p>
<p>
    2. 背包位可以顯示在銀行和背包視圖上，通過壹個三角形按鍵進行切換。
</p>
<p>
    3. 排序按鈕增加。
</p>
<br/><br/>
<p>
<lime>2016/08/14 v93 : </lime>
</p><br/>
<p>
    1. 你可以通過菜單修改所有元素的錨點，以此確保界面在所有分辨率下工作正常。
</p>
<p>
    2. 背包視圖模塊增加，你可以通過視圖管理器進行配置。
</p>
<br/><br/>
<p>
<lime>2016/08/02 v88 : </lime>
</p><br/>
<p>
    1. 使用Alt+鼠標右鍵點擊自動生成的物品按鈕，可以將物品加入黑名單，不再被自動生成。
</p>
<br/><br/>
<p>
<lime>2016/07/31 v82 : </lime>
</p><br/>
<p>
    1. 你可以解鎖小地圖，并且移動和調整它的大小。
</p>
<p>
    2. 姓名板相關的nameplateN，可以被團隊面板的單體監視面板使用，血量可以正常更新。
</p>
<p>
    3. 對應IGASv101版本。
</p>
<br/><br/>
<p>
<lime>2016/07/04 v63 : </lime>
</p><br/>
<p>
    1. 新的單體監視面板加入，可以監視類如target, focus之類的單體。
</p>
<p>
    2. 傷害和增益法術可以使用同一個按鍵，需要IGAS v93及以上版本支持。
</p>
<br/><br/>
<p>
<lime>2016/07/01 v62 : </lime>
</p><br/>
<p>
    1. 你可以調整任務列表的大小來修復移動任務列表后，無法顯示任務的問題。
</p>
<br/><br/>
<p>
<lime>2016/06/30 v61 : </lime>
</p><br/>
<p>
    1. "隱藏公共冷卻" 選項已被加入動作條系統。
</p>
<br/><br/>
<p>
<lime>2016/06/29 v60 : </lime>
</p><br/>
<p>
    1. 你可以在菜單中找到"使用冷卻標簽"，來給按鈕增加一個顯示冷卻時間的標簽。
</p>
<p>
    2. 你可以調整團隊面板中的增/減益圖標的大小。
</p>
<p>
    3. 團隊面板的設置調整爲按角色的專精保存。
</p>
<br/><br/>
<p>
<lime>2016/06/21 v59 : </lime>
</p><br/>
<p>
    1. 動作條菜單重新調整，便於使用。
</p>
<p>
    2. 你可以在菜單中找到"動作按鈕着色"，根據幾種情況調整按鈕顔色。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v58 : </lime>
</p><br/>
<p>
    1. 你可以使用相反的順序來自動生成物品列表。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v57 : </lime>
</p><br/>
<p>
    1. 現在你可以隨意移動任務面板。
</p>
<br/><br/>
<p>
<lime>2016/06/04 v50 : </lime>
</p><br/>
<p>
    1. 頭像系統也可以使用自動隱藏功能。
</p>
<p>
    2. 自動隱藏使用宏的條件進行判定，新的宏條件製作界面加入，通過點擊動作條或者頭像的菜單進入。
</p>
<p>
    3. 默認提供三個宏條件，第一個是"單人游戲并沒有目標也不在戰鬥"，第二個是"在寵物對戰中", 第三個是"在載具中"。更多宏條件可以自行配製。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v47 : </lime>
</p><br/>
<p>
    1. 現在可以隻保存單個動作條的樣式設定，也可以將該設定應用到其他單個動作條。
</p>
<br/><br/>
<p>
<lime>2016/03/08 v41 : </lime>
</p><br/>
<p>
    1. 在動作條菜單上增加"自動填充彈出動作條"選項，可以使用它對彈出條的根按鈕進行設定，比如自動生成藥劑列表。根按鈕必須是普通（沒有映射到系統動作條）的并帶有彈出按鈕。也可以綁定多個根按鈕到同一個動作列表，當這個動作列表更新時，會按照順序填充這些彈出動作條。
</p>
<p>
    2. 右鍵點擊彈出條根按鈕不會再觸發該動作.
</p>
<br/><br/>
<p>
<lime>2016/02/28 v40 : </lime>
</p><br/>
<p>
    1. 減少内存增長。
</p>
<p>
    2. 對聊天面板的簡單修改。
</p>
<br/><br/>
<p>
<lime>2014/04/02 v33 : </lime>
</p><br/>
<p>
    1. 包裹栏被替换，需要IGAS v71支持。
</p>
<p>
    2. 弹出条的显示时间可以在菜单中进行配置。
</p>
<br/><br/>
<p>
<lime>2014/04/02 v32 : </lime>
</p><br/>
<p>
    1. 使用Config文件來為團隊面板和頭像面板的所有面板元素提供底層配置。
</p>
<p>
    2. 現在你可以使用鼠標右鍵切換頭像面板的顯示／隱藏。
</p>
<br/><br/>
<p>
<lime>2013/11/8 v31 : </lime>
</p><br/>
<p>
    1. 新的團隊面板機能，右鍵點擊減益(Debuff)可以直接送入黑名單，可以至配置菜單關閉："單元配置" -> "右鍵點擊減益送至黑名單"。
</p><br/><p>
    2. 團隊面板的減益(Debuff)將從右下角開始顯示，而不是現在的左上角，顯示更加符合習慣，該功能需要IGAS v55版本，預計下禮拜發佈。
</p><br/><p>
    3. 顯示增益/減益的提示會阻止鼠標的操作，可以至配置菜單關閉："單元配置" -> "顯示增益/減益的提示".
</p>
<br/><br/>
<p>
<lime>2013/11/6 v30 : </lime>
</p><br/>
<p>
    1. 團隊面板的大量配置信息可以在配置菜單中找到，比如按職業色顯示，元素大小，隊伍過濾等。
</p><br/><p>
    1. 團隊面板會顯示你和你的團隊遭遇過的所有減益，可以在配置菜單中設置黑名單：單元配置 --> 減益過濾。
</p>
<br/><br/>
<p>
<lime>2013/10/20: v29 </lime>
</p><br/>
<p>
    1. 死者面板追加，僅顯示死亡的玩家，默認不使用，單獨的配置菜單提供。
</p>
</body>
</html>
]]

L["Unit List Info"] = [[
<html>
<body>
<p>
單體ID是玩家用于交互的標識符。比如"player"表示玩家目前的角色，"target"表示玩家的目標，而"targettarget"則表示目標的目標。
</p>
<br/>
<p><lime>基礎單體ID :</lime></p><br/>
<p><lightgreen>"arenaN"</lightgreen>第N個競技場對手 (1,2,3,4,5).</p>
<p><lightgreen>"arenapetN"</lightgreen>第N個競技場對手的寵物 (1,2,3,4,5).</p>
<p><lightgreen>"bossN"</lightgreen>當前的第N個boss級怪物 (1,2,3,4).</p>
<p><lightgreen>"focus"</lightgreen>玩家當前的焦點，利用/focus命令指定。</p>
<p><lightgreen>"partyN"</lightgreen>第N個隊友 (1,2,3,4).</p>
<p><lightgreen>"partypetN"</lightgreen>第N個隊友的寵物 (1,2,3,,4).</p>
<p><lightgreen>"pet"</lightgreen>玩家的寵物.</p>
<p><lightgreen>"player"</lightgreen>玩家本人.</p>
<p><lightgreen>"raidN"</lightgreen>第N個團隊成員(1,2,3,...,40).</p>
<p><lightgreen>"raidpetN"</lightgreen>第N個團隊成員的寵物 (1,2,3,...,40)</p>
<p><lightgreen>"target"</lightgreen>玩家的目標.</p>
<p><lightgreen>"vehicle"</lightgreen>玩家的載具.</p>
<br/><br/>
<p><lime>特別單體ID :</lime></p><br/>
<p><lightgreen>"maintank"</lightgreen> 主坦克.</p>
<p><lightgreen>"mainassist"</lightgreen> 助理，通常是副坦克.</p>
<p><lightgreen>"tank"</lightgreen> 坦克（可以是複數個）.</p>
<br/><br/>
<p><lime>目標擴展 :</lime></p><br/>
<p>
你可以在單體ID之後加上"target"後綴表示該單體的目標，比如"partypet2target"。你也可以爲特別單體ID加上該後綴，比如"maintanktarget"-主坦克的目標，會被相應的進行轉換。
</p>
</body>
</html>
]]

L["Close Menu"] = "關閉菜單"
L["Action Map"] = "動作條映射"
L["None"] = "(無)"
L["Main Bar"] = "主動作條"
L["Bar 1"] = "動作條1"
L["Bar 2"] = "動作條2"
L["Bar 3"] = "動作條3"
L["Bar 4"] = "動作條4"
L["Bar 5"] = "動作條5"
L["Bar 6"] = "動作條6"
L["Quest Bar"] = "任務物品欄"
L["Pet Bar"] = "寵物動作條"
L["Stance Bar"] = "姿態條"
L["Lock Action"] = "鎖定技能"
L["Scale"] = "縮放"
L["Horizontal Margin"] = "水平間距"
L["Vertical Margin"] = "垂直間距"
L["Auto Hide"] = "自動隱藏"
L["Out of combat"] = "脫離戰鬥時"
L["In petbattle"] = "寵物戰鬥中"
L["In vehicle"] = "載具內"
L["Use mouse down"] = "鼠標按下觸發"
L["Key Binding"] = "按鍵綁定"
L["Free Mode"] = "自由模式"
L["Manual Move&Resize"] = "手動調整位置"
L["Save Settings"] = "保存當前配置"
L["Load Settings"] = "讀取配置"
L["Save Layout"] = "保存佈局方案"
L["Load Layout"] = "讀取佈局方案"
L["Hidden MainMenuBar"] = "隱藏原始界面"
L["Delete Bar"] = "刪除動作條"
L["New Bar"] = "新建動作條"
L["Lock Action Bar"] = "鎖定動作條"
L["New Layout"] = "新佈局方案"
L["New Set"] = "新配置"
L["Reset"] = "重置"
L["Do you want use this bar to take place of the blizzard's main action buttons?"] = "你是否打算使用此動作條替代原始動作條?"
L["Please input the new layout name"] = "請輸入新佈局方案名稱"
L["Do you want overwrite the existed layout?"] = "是否確定覆蓋已有的佈局方案?"
L["Do you want reset the layout?"] = "是否確定重置當前佈局?"
L["Do you want load the layout?"] = "是否確定載入指定佈局方案?"
L["Please confirm to delete this action bar"] = "請確認是否刪除該動作條?"
L["Please confirm to create new action bar"] = "請確認是否新建動作條?"
L["Swap Pop-up action"] = "切替彈出條動作"
L["Please input the new set name"] = "請輸入新的配置名稱"
L["Do you want overwrite the existed set?"] = "是否確定覆蓋已有的配置?"
L["Do you want load the set?"] = "是否確定載入該配置?"
L["Always Show Grid"] = "總是顯示網格"
L["Popup Duration"] = "彈出條顯示時間"
L["Please input the popup's duration(0.1 - 5)"] = "請輸入彈出條顯示時間(0.1 - 5)"

L["Spell Binding"] = "技能綁定"
L["Lock Raid Panel"] = "鎖定團隊面板"
L["Indicator"] = "指示器"

L["%s is added to buff line."] = "%s 被加入增益監視列表。"
L["%s is added to spell cooldown line."] = "%s 被加入技能冷卻監視列表。"
L["%s is removed from spell cooldown line."] = "%s 被移出技能冷卻監視列表。"
L["%s is added to item cooldown line."] = "%s 被加入物品冷卻監視列表。"
L["%s is removed from item cooldown line."] = "%s 被移出物品冷卻監視列表。"

L["Lock Unit Frame"] = "鎖定人物面板"

L["Buff panel"] = "增益面板"
L["Disconnect indicator"] = "斷線指示"
L["Debuff panel"] = "減益面板"
L["Group Role indicator"] = "小隊角色指示"
L["My heal prediction"] = "玩家的提前治療量"
L["All heal prediction"] = "全部的提前治療量"
L["Total Absorb"] = "總吸收量"
L["Leader indicator"] = "隊長指示"
L["Target indicator"] = "玩家目標指示"
L["Resurrect indicator"] = "復活指示"
L["ReadyCheck indicator"] = "團隊檢查指示"
L["Raid/Group target indicator"] = "團隊/小隊目標指示"
L["Raid roster indicator"] = "團隊角色指示"
L["Power bar"] = "能力資源條"
L["Name indicator"] = "姓名指示"
L["Range indicator"] = "距離指示"
L["Heal Absorb"] = "治療吸收"

L["Raid panel"] = "團對面板"
L["Pet panel"] = "寵物面板"

L["Activated"] = "啟用"
L["Deactivate in raid"] = "團隊中禁用"

L["Location"] = "位置"
L["Right"] = "右側"
L["Bottom"] = "下側"

L["Show"] = "顯示面板"
L["Show in a raid"] = "在團隊中"
L["Show in a party"] = "在小隊中"
L["Show the player in party"] = "在小隊中顯示玩家"
L["Show when solo"] = "在單獨遊戲時"

L["Group By"] = "分組"
L["NONE"] = "無"
L["GROUP"] = "小組"
L["CLASS"] = "職業"
L["ROLE"] = "職責"
L["ASSIGNEDROLE"] = "分配職責"

L["Sort By"] = "排序"
L["INDEX"] = "順序"
L["NAME"] = "名字"

L["Orientation"] = "取向"
L["HORIZONTAL"] = "水平"
L["VERTICAL"] = "豎直"

L["Element Settings"] = "單元配置"
L["Please input the element's width(px)"] = "請設置每個單元的寬度(px)"
L["Please input the element's height(px)"] = "請設置每個單元的高度(px)"
L["Please input the power bar's height(px)"] = "請設置每個單元的法力條高度(px)"
L["Width : "] = "寬度: "
L["Height : "] = "高度: "
L["Power Height : "] = "法力條高度: "
L["Use Class Color"] = "使用職業色"

L["Filter"] = "過濾"

L["WARRIOR"] = "戰士"
L["PALADIN"] = "聖騎士"
L["HUNTER"] = "獵人"
L["ROGUE"] = "盜賊"
L["PRIEST"] = "牧師"
L["DEATHKNIGHT"] = "死亡騎士"
L["SHAMAN"] = "薩滿"
L["MAGE"] = "法師"
L["WARLOCK"] = "術士"
L["MONK"] = "武僧"
L["DRUID"] = "德魯伊"
L["DEMONHUNTER"] = "惡魔獵手"

L["MAINTANK"] = "主坦克"
L["MAINASSIST"] = "副坦克"
L["TANK"] = "坦克"
L["HEALER"] = "治療"
L["DAMAGER"] = "傷害"

L["Dead panel"] = "死者面板"

L["Debuff filter"] = "減益過濾"
L["Black list"] = "黑名單"
L["Double click to remove"] = "雙擊項目移除"

L["Right mouse-click send debuff to black list"] = "右鍵點擊減益送至黑名單"
L["Show buff/debuff tootip"] = "顯示增益/減益的提示"

L["Auto generate popup actions"] = "自動填充彈出動作條"
L["Please click the root button"] = "請點擊彈出條的根按鈕"
L["Auto Generate Pop-up Actions"] = "自動填充彈出動作條設定"
L["Apply"] = "適用"
L["Save"] = "保存"
L["Close"] = "關閉"
L["Action Type"] = "動作類型"
L["Item"] = "背包物品"
L["Toy"] = "玩具"
L["BattlePet"] = "寵物"
L["Mount"] = "坐騎"
L["EquipSet"] = "套裝"
L["Auto-generate buttons"] = "自動生成按鈕"
L["Use filter"] = "使用過濾代碼"
L["Only Favourite"] = "衹有最愛"
L["All"] = "所有"
L["Please input the auto aciton list's name"] = "請輸入自動動作列表的名字"
L["Are you sure to delete the auto action list?"] = "確認是否刪除該自動動作列表"

L["Save action bar's layout"] = "保存該動作條佈局"
L["Apply action bar's layout"] = "應用單獨的動作條佈局"

L["Macro Condition Editor"] = "宏條件編輯器"
L["Conditon Maker"] = "條件生成器"
L["Double-click items in the left list to select a condition.\nDoublc-click items in the bottom list to dis-select."] = "雙擊左邊的列表來選擇壹個條件。\n雙擊壹個下面的列表來移除壹個條件。"
L["Click the link to add or remove the conditions."] = "點擊鏈接來添加或者移除條件。"

L["Player is in a vehicle and can exit it at will."] = "玩家在壹個載具中並且可以正常退出。"
L["Player is in combat."] = "玩家在戰鬥中。"
L["Conditional target exists and is dead."] = "條件對象存在並且已死亡。"
L["Conditional target exists."] = "條件對象存在。"
L["The player can use a flying mount in this zone (though incorrect in Wintergrasp during a battle)."] = "玩家在當前地區可以飛行（盡管可能因為其它原因不能，比如冬擁湖戰鬥時）"
L["Mounted or in flight form AND in the air."] = "玩家飛行中。"
L["The player is in any form."] = "玩家處於任意姿態中。類似德魯伊的變身，戰士的防禦姿態等。"
L["The player is not in any form."] = "玩家不處於任意姿態中。"
L["The player is in form 1."] = "玩家處於第壹個姿態。"
L["The player is in form 2."] = "玩家處於第二個姿態。"
L["The player is in form 3."] = "玩家處於第三個姿態。"
L["The player is in form 4."] = "玩家處於第四個姿態。"
L["Player is in a party."] = "玩家在壹個隊伍中。"
L["Player is in a raid."] = "玩家在壹個團隊中。"
L["Conditional target exists and can be targeted by harmful spells (e.g.  [Fireball])."] = "條件對象存在並且可以被施以傷害法術。（例如火球術）"
L["Conditional target exists and can be targeted by helpful spells (e.g.  [Heal])."] = "條件對象存在並且可以被施以輔助法術（例如治療術）"
L["Player is indoors."] = "玩家在室內。"
L["Player is mounted."] = "玩家使用坐騎中。"
L["Player is outdoors."] = "玩家在室外。"
L["Conditional target exists and is in your party."] = "條件對象存在並且在玩家隊伍中。"
L["The player has a pet."] = "玩家帶有寵物。"
L["Currently participating in a pet battle."] = "玩家正在進行寵物對戰。"
L["Conditional target exists and is in your raid/party."] = "條件對象存在並且在玩家的團隊中。"
L["Player is currently resting."] = "玩家處於休息狀態。"
L["Player's active the first specialization group (spec, talents and glyphs)."] = "玩家的第壹個專精啟用中。"
L["Player's active the second specialization group (spec, talents and glyphs)."] = "玩家的第二個專精啟用中。"
L["Player is stealthed."] = "玩家處於潛行狀態。"
L["Player is swimming."] = "玩家處於潛水狀態。"
L["Player has vehicle UI."] = "玩家正在使用載具。"
L["Player currently has an extra action bar/button."] = "玩家目前有壹個額外動作條/按鈕。"
L["Player's main action bar is currently replaced by the override action bar."] = "玩家的主動作條正被override動作覆蓋。"
L["Player's main action bar is currently replaced by the possess action bar."] = "玩家的主動作條正被被控制者的動作條覆蓋。比如心靈控制"
L["Player's main action bar is currently replaced by a temporary shapeshift action bar."] = "玩家的動作條被壹個臨時變形動作條覆蓋。（玩家被boss變形後）"

L["The conditional target :"] = "條件對象："
L["The macro conditions :"] = "宏條件："
L["Solo no combat no target"] = "無隊友無目標無戰鬥"
L["In a vehicle"] = "載具中"
L["In a pet battle"] = "寵物對戰中"
L["Are you sure to delete the macro condition?"] = "您是否確定刪除這個宏條件？"

L["Lock Quest Tracker"] = "鎖定任務列表"

L["Use reverse order"] = "使用相反的順序"

L["Global Style"] = "全局樣式"
L["Bar Style"] = "動作條樣式"
L["Save & Load"] = "保存&加載"
L["Color the action button"] = "動作按鈕著色"
L["Enable"] = "啓用"
L["Disable"] = "停用"
L["Lack of resource"] = "缺乏資源"
L["Out of range"] = "距離過遠"
L["Unusable for other reason"] = "其他原因不可用"
L["Disable the feature would require reload, \ndo you continue?"] = "停用此功能需要重載游戲，\n是否繼續?"

L["Use cooldown label"] = "使用冷卻標簽"
L["Enable the feature would require reload, \ndo you continue?"] = "啓用此功能需要重載游戲，\n是否繼續?"

L["Aura Size : "] = "增/減益圖標大小"
L["Please input the aura's size(px)"] = "請輸入增/減益圖標大小(像素)"

L["Hide Global cooldown"] = "隱藏公共冷卻"

L["Unit watch panel"] = "單體監視面板"
L["Modify unit list"] = "修改單體列表"
L["Unit List"] = "單體列表"
L["Up"] = "上"
L["Down"] = "下"
L["Please input the unit id"] = "請輸入單體ID"
L["Are you sure to delete the unit id"] = "是否確認刪除該單體ID"
L["Auto layout"] = "自動布局"

L["Unknown"] = "未知目標"

L["Lock Minimap"] = "鎖定小地圖"

L["Show item black list"] = "顯示物品黑名單"
L["Auto-gen item black list"] = "自動生成物品黑名單"

L["Modify AnchorPoints"] = "修改錨點"

L["Lock Container Frame"] = "鎖定背包面板"
L["Show the view manager"] = "顯示視圖管理器"
L["Container View Rule Manager"] = "背包視圖規則管理器"
L["Container"] = "容器"
L["Rule"] = "規則"
L["Please input the container view's name"] = "請輸入背包視圖的名稱"
L["Do you want delete the container view?"] = "你確定刪除該背包視圖？"
L["Do you want delete the container?"] = "你確定刪除該容器？"
L["Do you want delete the contianer rule?"] = "你確定刪除該容器規則？"
L["[not]"] = "[非]"

L["Any"] = "任意"
L["No check, you should only use this for the last container of one view"] = "無檢查，你應當僅用于視圖的最後一個容器"
L["Backpack"] = "背包"
L["The slot is in the backpack"] = "物品槽在出生背包中"
L["Container1"] = "擴展背包1"
L["The slot is in the 1st container(from the right)"] = "物品槽在擴展背包1中(從右往左數)"
L["Container2"] = "擴展背包2"
L["The slot is in the 2nd container(from the right)"] = "物品槽在擴展背包2中(從右往左數)"
L["Container3"] = "擴展背包3"
L["The slot is in the 3rd container(from the right)"] = "物品槽在擴展背包3中(從右往左數)"
L["Container4"] = "擴展背包4"
L["The slot is in the 4th container(from the right)"] = "物品槽在擴展背包4中(從右往左數)"
L["HasItem"] = "含有物品"
L["The slot has item"] = "物品槽中有物品存在"
L["Readable"] = "可讀"
L["The slot has item, and the item is a readable item such as books or scrolls"] = "物品槽中有物品存在，並且該物品可讀，比如書籍或者卷軸"
L["Lootable"] = "可拾取"
L["The slot has item, and the item is a temporary container containing items that can be looted"] = "物品槽中有物品存在，並且該物品是可以被拾取的容器"
L["HasNoValue"] = "無價值"
L["The slot has item, and the item has no sale price"] = "物品槽中有物品存在，並且該物品沒有價值(不可銷售)"
L["IsQuestItem"] = "任務"
L["The slot has item, and the item is a quest item"] = "物品槽中有物品存在，並且該物品是任務物品"
L["IsEquipItem"] = "裝備"
L["The slot has item, and the item is an equipment"] = "物品槽中有物品存在，並且該物品是裝備物品"
L["IsStackableItem"] = "可堆疊"
L["The slot has item, and the item is stackable"] = "物品槽中有物品存在，並且該物品是可堆疊的"
L["IsUsableItem"] = "可使用"
L["The slot has item, and the item can be used by right-click."] = "物品槽中有物品存在，並且該物品是被右鍵使用的"
L["The slot has item, and the item is poor(color gray)"] = "物品槽中有物品存在，並且該物品是粗糙的(灰色)"
L["The slot has item, and the item is common(color white)"] = "物品槽中有物品存在，並且該物品是普通的(白色)"
L["The slot has item, and the item is uncommon(color green)"] = "物品槽中有物品存在，並且該物品是優秀的(綠色)"
L["The slot has item, and the item is rare(color blue)"] = "物品槽中有物品存在，並且該物品是精良的(藍色)"
L["The slot has item, and the item is epic(color purple)"] = "物品槽中有物品存在，並且該物品是史詩的(紫色)"
L["The slot has item, and the item is legendary(color orange)"] = "物品槽中有物品存在，並且該物品是傳說的(橙色)"
L["The slot has item, and the item is artifact(color golden yellow)"] = "物品槽中有物品存在，並且該物品是神器的(暗金色)"
L["The slot has item, and the item is heirloom(color light yellow)"] = "物品槽中有物品存在，並且該物品是傳家寶(淡金色)"
L["The slot has item, and the item is wow token(color light yellow)"] = "物品槽中有物品存在，並且該物品是魔獸徽章的(淡金色)"
L["The slot has item, and the item's class is "] = "物品槽中有物品存在，並且該物品的類型是"
L["The slot has item, and the item's sub-class is "] = "物品槽中有物品存在，並且該物品的子類型是"
L["Default"] = "默認"
L["All-In-One"] = "整合"
L[" and "] = " 并且 "
L["Reagent"] = "材料"
L["Drag item to the right panel"] = "拖拽物品到右側的面板"

L["InItemList"] = "物品列表中"
L["The slot has item, and the item is in the list (choose the view to show the item list panel, drag the item to it will add the item, click the link in the panel will remove it)"] = "物品槽中有物品存在，並且該物品屬于物品列表(選擇視圖來顯示物品列表面板，拖拽物品進入來添加，點擊物品鏈接來移除)"
L["Bank"] = "銀行"
L["The slot is in the bank"] = "物品槽在銀行中"
L["ReagentBank"] = "材料銀行"
L["The slot is in the reagent bank"] = "物品槽在材料銀行中"
L["BankBag1"] = "銀行擴展背包1"
L["The slot is in the 1st bank bag"] = "物品槽在銀行擴展背包1中"
L["BankBag2"] = "銀行擴展背包2"
L["The slot is in the 2nd bank bag"] = "物品槽在銀行擴展背包2中"
L["BankBag3"] = "銀行擴展背包3"
L["The slot is in the 3rd bank bag"] = "物品槽在銀行擴展背包3中"
L["BankBag4"] = "銀行擴展背包4"
L["The slot is in the 4th bank bag"] = "物品槽在銀行擴展背包4中"
L["BankBag5"] = "銀行擴展背包5"
L["The slot is in the 5th bank bag"] = "物品槽在銀行擴展背包5中"
L["BankBag6"] = "銀行擴展背包6"
L["The slot is in the 6th bank bag"] = "物品槽在銀行擴展背包6中"
L["BankBag7"] = "銀行擴展背包7"
L["The slot is in the 7th bank bag"] = "物品槽在銀行擴展背包7中"
L["IsNewItem"] = "新物品"
L["The slot has item, and the item is newly added."] = "物品槽中有物品存在，並且該物品是新加入的"

L["IsEquipSet"] = "裝備配置方案中"
L["The slot has item, and the item is in a equip set."] = "物品槽中有物品存在，並且該物品屬於某個裝備配置方案"