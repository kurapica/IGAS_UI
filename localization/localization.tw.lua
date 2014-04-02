local L = IGAS:NewLocale("IGAS_UI", "zhTW")
if not L then return end

L["Change Log"] = "更新日誌"

L["ChangeLog"] = [[
<html>
<body>
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

L["Spell Binding"] = "技能綁定"
L["Lock Raid Panel"] = "鎖定團隊面板"

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