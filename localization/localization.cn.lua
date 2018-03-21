local L = IGAS:NewLocale("IGAS_UI", "zhCN")
if not L then return end

L["Change Log"] = "更新日志"

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>2018/02/02 v217 : </lime>
</p><br/>
<p>
    1. 当需要给目标补减益时，动作条会高亮提示。
</p>
<br/><br/>
<p>
<lime>2018/01/10 v216 : </lime>
</p><br/>
<p>
    1. "全账号通用"菜单项加入，被指定的动作条将被所有角色和专精使用，比如宠物坐骑动作条之类，无需再自行同步内容。
</p>
<br/><br/>
<p>
<lime>2017/11/29 v205 : </lime>
</p><br/>
<p>
    1. 动作条现在开始支持Masque皮肤插件。
</p>
<p>
    2. 如果一个动作条只含有一个按钮(该按钮有弹出动作条)，那么可以使用"方形布局"或者"圆形布局"来快速进行布局。
</p>
<p>
    3. 新的动作条映射: 世界标记，团队标记。
</p>
<br/><br/>
<p>
<lime>2017/10/31 v204 : </lime>
</p><br/>
<p>
    1. 现在你可以保存和加载特定动作条的布局和内容。
</p>
<br/><br/>
<p>
<lime>2017/08/14 v190 : </lime>
</p><br/>
<p>
    1. 动作条系统添加了最大和最小不透明度选项。可用来调整透明度。
</p>
<br/><br/>
<p>
<lime>2017/05/05 v184 : </lime>
</p><br/>
<p>
    1. 团队面板新增宏绑定工具，用户可以直接绑定按键到指定的宏(文本)。
</p>
<p>
    2. 用户可以为部分增益指定顺序，这些特殊增益将被按顺序优先显示。
</p>
<br/><br/>
<p>
<lime>2017/04/29 v182 : </lime>
</p><br/>
<p>
    1. 团队面板提供"平滑血条更新"选项，同时也可以修改平滑更新的延迟。
</p>
<br/><br/>
<p>
<lime>2017/03/27 v172 : </lime>
</p><br/>
<p>
    1. 团队面板加入了“按下即触发”菜单项，勾选时，动作按下时就会触发施法。
</p>
</body>
</html>
]]

L["Unit List Info"] = [[
<html>
<body>
<p>
单体ID是玩家用于交互的标识符。比如"player"表示玩家目前的角色，"target"表示玩家的目标，而"targettarget"则表示目标的目标。
</p>
<br/>
<p><lime>基础单体ID :</lime></p><br/>
<p><lightgreen>"arenaN"</lightgreen>第N个竞技场对手 (1,2,3,4,5).</p>
<p><lightgreen>"arenapetN"</lightgreen>第N个竞技场对手的宠物 (1,2,3,4,5).</p>
<p><lightgreen>"bossN"</lightgreen>当前的第N个boss级怪物 (1,2,3,4).</p>
<p><lightgreen>"focus"</lightgreen>玩家当前的焦点，利用/focus命令指定。</p>
<p><lightgreen>"partyN"</lightgreen>第N个队友 (1,2,3,4).</p>
<p><lightgreen>"partypetN"</lightgreen>第N个队友的宠物 (1,2,3,,4).</p>
<p><lightgreen>"pet"</lightgreen>玩家的宠物.</p>
<p><lightgreen>"player"</lightgreen>玩家本人.</p>
<p><lightgreen>"raidN"</lightgreen>第N个团队成员(1,2,3,...,40).</p>
<p><lightgreen>"raidpetN"</lightgreen>第N个团队成员的宠物 (1,2,3,...,40)</p>
<p><lightgreen>"target"</lightgreen>玩家的目标.</p>
<p><lightgreen>"vehicle"</lightgreen>玩家的载具.</p>
<br/><br/>
<p><lime>特别单体ID :</lime></p><br/>
<p><lightgreen>"maintank"</lightgreen> 主坦克.</p>
<p><lightgreen>"mainassist"</lightgreen> 助理，通常是副坦克.</p>
<p><lightgreen>"tank"</lightgreen> 坦克（可以是复数个）.</p>
<br/><br/>
<p><lime>目标扩展 :</lime></p><br/>
<p>
你可以在单体ID之后加上"target"后缀表示该单体的目标，比如"partypet2target"。你也可以为特别单体ID加上该后缀，比如"maintanktarget"-主坦克的目标，会被相应的进行转换。
</p>
</body>
</html>
]]

L["Close Menu"] = "关闭菜单"
L["Action Map"] = "动作条映射"
L["None"] = "(无)"
L["Main Bar"] = "主动作条"
L["Bar 1"] = "动作条1"
L["Bar 2"] = "动作条2"
L["Bar 3"] = "动作条3"
L["Bar 4"] = "动作条4"
L["Bar 5"] = "动作条5"
L["Bar 6"] = "动作条6"
L["Quest Bar"] = "任务物品栏"
L["Pet Bar"] = "宠物动作条"
L["Stance Bar"] = "姿态条"
L["Lock Action"] = "锁定技能"
L["Scale"] = "缩放"
L["Horizontal Margin"] = "水平间距"
L["Vertical Margin"] = "垂直间距"
L["Auto Hide"] = "自动隐藏"
L["Out of combat"] = "脱离战斗时"
L["In petbattle"] = "宠物战斗中"
L["In vehicle"] = "载具内"
L["Press down trigger"] = "按下即触发"
L["Key Binding"] = "按键绑定"
L["Free Mode"] = "自由模式"
L["Manual Move&Resize"] = "手动调整位置"
L["Save Settings"] = "保存当前配置"
L["Load Settings"] = "读取配置"
L["Save Layout"] = "保存布局方案"
L["Load Layout"] = "读取布局方案"
L["Hidden MainMenuBar"] = "隐藏原始界面"
L["Delete Bar"] = "删除动作条"
L["New Bar"] = "新建动作条"
L["Lock Action Bar"] = "锁定动作条"
L["New Layout"] = "新布局方案"
L["New Set"] = "新配置"
L["Reset"] = "重置"
L["Do you want use this bar to take place of the blizzard's main action buttons?"] = "你是否打算使用此动作条替代原始主动作条?"
L["Please input the new layout name"] = "请输入新布局方案名称"
L["Do you want overwrite the existed layout?"] = "是否确定覆盖已有的布局方案?"
L["Do you want reset the layout?"] = "是否确定重置当前布局?"
L["Do you want load the layout?"] = "是否确定载入指定布局方案?"
L["Please confirm to delete this action bar"] = "请确认是否删除这个动作条?"
L["Please confirm to create new action bar"] = "请确认是否新建动作条?"
L["Swap Pop-up action"] = "切换弹出条动作"
L["Please input the new set name"] = "请输入新的配置名称"
L["Do you want overwrite the existed set?"] = "是否覆盖已有的配置?"
L["Do you want load the set?"] = "是否确定载入该配置?"
L["Always Show Grid"] = "总是显示网格"
L["Popup Duration"] = "弹出条显示时间"
L["Please input the popup's duration(0.1 - 5)"] = "请输入弹出条显示时间(0.1 - 5)"

L["Spell Binding"] = "技能绑定"
L["Lock Raid Panel"] = "锁定团队面板"
L["Indicator"] = "指示器"

L["%s is added to buff line."] = "%s 被加入增益监视列表。"
L["%s is added to spell cooldown line."] = "%s 被加入技能冷却监视列表。"
L["%s is removed from spell cooldown line."] = "%s 被移出技能冷却监视列表"
L["%s is added to item cooldown line."] = "%s 被加入物品冷却监视列表。"
L["%s is removed from item cooldown line."] = "%s 被移出物品冷却监视列表。"

L["Lock Unit Frame"] = "锁定人物面板"

L["Buff panel"] = "增益面板"
L["Disconnect indicator"] = "断线指示"
L["Debuff panel"] = "减益面板"
L["Group Role indicator"] = "小队角色指示"
L["My heal prediction"] = "玩家的提前治疗量"
L["All heal prediction"] = "全部的提前治疗量"
L["Total Absorb"] = "总吸收量"
L["Leader indicator"] = "队长指示"
L["Target indicator"] = "玩家目标指示"
L["Resurrect indicator"] = "复活指示"
L["ReadyCheck indicator"] = "团队检查指示"
L["Raid/Group target indicator"] = "团队/小队目标指示"
L["Raid roster indicator"] = "团队角色指示"
L["Power bar"] = "能力资源条"
L["Name indicator"] = "姓名指示"
L["Range indicator"] = "距离指示"
L["Heal Absorb"] = "治疗吸收"
L["Health Percent"] = "血量百分比"

L["Raid panel"] = "团队面板"
L["Pet panel"] = "宠物面板"

L["Activated"] = "启用"
L["Deactivate in raid"] = "团队中禁用"

L["Location"] = "位置"
L["Right"] = "右侧"
L["Bottom"] = "下侧"

L["Show"] = "显示面板"
L["Show in a raid"] = "在团队中"
L["Show in a party"] = "在小队中"
L["Show the player in party"] = "在小队中显示玩家"
L["Show when solo"] = "在单独游戏时"

L["Group By"] = "分组"
L["NONE"] = "无"
L["GROUP"] = "小组"
L["CLASS"] = "职业"
L["ROLE"] = "职责"
L["ASSIGNEDROLE"] = "分配职责"

L["Sort By"] = "排序"
L["INDEX"] = "顺序"
L["NAME"] = "名字"

L["Orientation"] = "取向"
L["HORIZONTAL"] = "水平"
L["VERTICAL"] = "竖直"

L["Element Settings"] = "单元配置"
L["Please input the element's width(px)"] = "请设置每个单元的宽度(px)"
L["Please input the element's height(px)"] = "请设置每个单元的高度(px)"
L["Please input the power bar's height(px)"] = "请设置每个单元的法力条高度(px)"
L["Width : "] = "宽度: "
L["Height : "] = "高度: "
L["Power Height : "] = "法力条高度: "
L["Use Class Color"] = "使用职业色"
L["Use Debuff Color"] = "使用减益颜色"
L["Use Smoothing Color"] = "使用平滑颜色"

L["Filter"] = "过滤"

L["WARRIOR"] = "战士"
L["PALADIN"] = "圣骑士"
L["HUNTER"] = "猎人"
L["ROGUE"] = "游荡者"
L["PRIEST"] = "牧师"
L["DEATHKNIGHT"] = "死亡骑士"
L["SHAMAN"] = "萨满"
L["MAGE"] = "法师"
L["WARLOCK"] = "术士"
L["MONK"] = "武僧"
L["DRUID"] = "德鲁伊"
L["DEMONHUNTER"] = "恶魔猎手"

L["MAINTANK"] = "主坦克"
L["MAINASSIST"] = "副坦克"
L["TANK"] = "坦克"
L["HEALER"] = "治疗"
L["DAMAGER"] = "伤害"

L["Dead panel"] = "死者面板"

L["Debuff filter"] = "减益过滤"
L["Buff filter"] = "增益过滤"
L["Black list"] = "黑名单"
L["Double click to remove"] = "双击项目移除"

L["Right mouse-click send buff/debuff to black list"] = "右键点击增益/减益送至黑名单"
L["Show buff/debuff tootip"] = "显示增益/减益的提示"

L["Auto generate popup actions"] = "自动填充弹出动作条"
L["Please click the root button"] = "请点击弹出条的根按钮"
L["Auto Generate Pop-up Actions"] = "自动填充弹出动作条设定"
L["Apply"] = "适用"
L["Save"] = "保存"
L["Close"] = "关闭"
L["Action Type"] = "动作类型"
L["Item"] = "背包物品"
L["Toy"] = "玩具"
L["BattlePet"] = "宠物"
L["Mount"] = "坐骑"
L["EquipSet"] = "套装"
L["Auto-generate buttons"] = "自动生成按钮"
L["Use filter"] = "使用过滤代码"
L["Only Favourite"] = "只有最爱"
L["All"] = "所有"
L["Please input the auto aciton list's name"] = "请输入自动动作列表的名字"
L["Are you sure to delete the auto action list?"] = "确认是否删除该自动动作列表"

L["Save action bar's layout"] = "保存该动作条布局"
L["Apply action bar's layout"] = "应用单独的动作条布局"

L["Macro Condition Editor"] = "宏条件编辑器"
L["Conditon Maker"] = "条件生成器"
L["Double-click items in the left list to select a condition.\nDoublc-click items in the bottom list to dis-select."] = "双击左边的列表来选择一个条件。\n双击一个下面的列表来移除一个条件。"
L["Click the link to add or remove the conditions."] = "点击链接来添加或者移除条件。"

L["Player is in a vehicle and can exit it at will."] = "玩家在一个载具中并且可以正常退出。"
L["Player is in combat."] = "玩家在战斗中。"
L["Conditional target exists and is dead."] = "条件对象存在并且已死亡。"
L["Conditional target exists."] = "条件对象存在。"
L["The player can use a flying mount in this zone (though incorrect in Wintergrasp during a battle)."] = "玩家在当前地区可以飞行（尽管可能因为其它原因不能，比如冬拥湖战斗时）"
L["Mounted or in flight form AND in the air."] = "玩家飞行中。"
L["The player is in any form."] = "玩家处于任意姿态中。类似德鲁伊的变身，战士的防御姿态等。"
L["The player is not in any form."] = "玩家不处于任意姿态中。"
L["The player is in form 1."] = "玩家处于第一个姿态。"
L["The player is in form 2."] = "玩家处于第二个姿态。"
L["The player is in form 3."] = "玩家处于第三个姿态。"
L["The player is in form 4."] = "玩家处于第四个姿态。"
L["Player is in a party."] = "玩家在一个队伍中。"
L["Player is in a raid."] = "玩家在一个团队中。"
L["Conditional target exists and can be targeted by harmful spells (e.g.  [Fireball])."] = "条件对象存在并且可以被施以伤害法术。（例如火球术）"
L["Conditional target exists and can be targeted by helpful spells (e.g.  [Heal])."] = "条件对象存在并且可以被施以辅助法术（例如治疗术）"
L["Player is indoors."] = "玩家在室内。"
L["Player is mounted."] = "玩家使用坐骑中。"
L["Player is outdoors."] = "玩家在室外。"
L["Conditional target exists and is in your party."] = "条件对象存在并且在玩家队伍中。"
L["The player has a pet."] = "玩家带有宠物。"
L["Currently participating in a pet battle."] = "玩家正在进行宠物对战。"
L["Conditional target exists and is in your raid/party."] = "条件对象存在并且在玩家的团队中。"
L["Player is currently resting."] = "玩家处于休息状态。"
L["Player's active the first specialization group (spec, talents and glyphs)."] = "玩家的第一个专精启用中。"
L["Player's active the second specialization group (spec, talents and glyphs)."] = "玩家的第二个专精启用中。"
L["Player is stealthed."] = "玩家处于潜行状态。"
L["Player is swimming."] = "玩家处于潜水状态。"
L["Player has vehicle UI."] = "玩家正在使用载具。"
L["Player currently has an extra action bar/button."] = "玩家目前有一个额外动作条/按钮。"
L["Player's main action bar is currently replaced by the override action bar."] = "玩家的主动作条正被override动作覆盖。"
L["Player's main action bar is currently replaced by the possess action bar."] = "玩家的主动作条正被被控制者的动作条覆盖。比如心灵控制"
L["Player's main action bar is currently replaced by a temporary shapeshift action bar."] = "玩家的动作条被一个临时变形动作条覆盖。（玩家被boss变形后）"

L["The conditional target :"] = "条件对象："
L["The macro conditions :"] = "宏条件："
L["Solo no combat no target"] = "无队友无目标无战斗"
L["In a vehicle"] = "载具中"
L["In a pet battle"] = "宠物对战中"
L["Are you sure to delete the macro condition?"] = "您是否确定删除这个宏条件？"

L["Lock Quest Tracker"] = "锁定任务列表"
L["Use reverse order"] = "使用相反的顺序"

L["Global Style"] = "全局样式"
L["Bar Style"] = "动作条样式"
L["Save & Load"] = "保存&加载"
L["Color the action button"] = "动作按钮着色"
L["Enable"] = "启用"
L["Disable"] = "停用"
L["Lack of resource"] = "缺乏资源"
L["Out of range"] = "距离过远"
L["Unusable for other reason"] = "其他原因不可用"
L["Disable the feature would require reload, \ndo you continue?"] = "停用此功能需要重载游戏，\n是否继续？"

L["Use cooldown label"] = "使用冷却标签"
L["Enable the feature would require reload, \ndo you continue?"] = "启用此功能需要重载游戏，\n是否继续？"

L["Aura Size : "] = "增/减益图标大小 : "
L["Please input the aura's size(px)"] = "请输入增/减益图标大小(像素)"

L["Hide Global cooldown"] = "隐藏公共冷却"

L["Unit watch panel"] = "单体监视面板"
L["Modify unit list"] = "修改单体列表"
L["Unit List"] = "单体列表"
L["Up"] = "上"
L["Down"] = "下"
L["Please input the unit id"] = "请输入单体ID"
L["Are you sure to delete the unit id"] = "是否确认删除该单体ID"
L["Auto layout"] = "自动布局"

L["Unknown"] = "未知目标"

L["Lock Minimap"] = "锁定小地图"

L["Show item black list"] = "显示物品黑名单"
L["Auto-gen item black list"] = "自动生成物品黑名单"

L["Modify AnchorPoints"] = "修改锚点"

L["Lock Container Frame"] = "锁定背包面板"
L["Show the view manager"] = "显示视图管理器"
L["Container View Rule Manager"] = "背包视图规则管理器"
L["Container"] = "容器"
L["Rule"] = "规则"
L["Please input the container view's name"] = "请输入背包视图的名称"
L["Do you want delete the container view?"] = "你确定删除该背包视图？"
L["Do you want delete the container?"] = "你确定删除该容器？"
L["Do you want delete the contianer rule?"] = "你确定删除该容器规则？"
L["[not]"] = "[非]"

L["Any"] = "任意"
L["No check, you should only use this for the last container of one view"] = "无检查，你应当仅用于视图的最后一个容器"
L["Backpack"] = "背包"
L["The slot is in the backpack"] = "物品槽在出生背包中"
L["Container1"] = "扩展背包1"
L["The slot is in the 1st container(from the right)"] = "物品槽在扩展背包1中(从右往左数)"
L["Container2"] = "扩展背包2"
L["The slot is in the 2nd container(from the right)"] = "物品槽在扩展背包2中(从右往左数)"
L["Container3"] = "扩展背包3"
L["The slot is in the 3rd container(from the right)"] = "物品槽在扩展背包3中(从右往左数)"
L["Container4"] = "扩展背包4"
L["The slot is in the 4th container(from the right)"] = "物品槽在扩展背包4中(从右往左数)"
L["HasItem"] = "含有物品"
L["The slot has item"] = "物品槽中有物品存在"
L["Readable"] = "可读"
L["The slot has item, and the item is a readable item such as books or scrolls"] = "物品槽中有物品存在，并且该物品可读，比如书籍或者卷轴"
L["Lootable"] = "可拾取"
L["The slot has item, and the item is a temporary container containing items that can be looted"] = "物品槽中有物品存在，并且该物品是可以被拾取的容器"
L["HasNoValue"] = "无价值"
L["The slot has item, and the item has no sale price"] = "物品槽中有物品存在，并且该物品没有价值(不可销售)"
L["IsQuestItem"] = "任务"
L["The slot has item, and the item is a quest item"] = "物品槽中有物品存在，并且该物品是任务物品"
L["IsEquipItem"] = "装备"
L["The slot has item, and the item is an equipment"] = "物品槽中有物品存在，并且该物品是装备物品"
L["IsStackableItem"] = "可堆叠"
L["The slot has item, and the item is stackable"] = "物品槽中有物品存在，并且该物品是可堆叠的"
L["IsUsableItem"] = "可使用"
L["The slot has item, and the item can be used by right-click."] = "物品槽中有物品存在，并且该物品是被右键使用的"
L["The slot has item, and the item is poor(color gray)"] = "物品槽中有物品存在，并且该物品是粗糙的(灰色)"
L["The slot has item, and the item is common(color white)"] = "物品槽中有物品存在，并且该物品是普通的(白色)"
L["The slot has item, and the item is uncommon(color green)"] = "物品槽中有物品存在，并且该物品是优秀的(绿色)"
L["The slot has item, and the item is rare(color blue)"] = "物品槽中有物品存在，并且该物品是精良的(蓝色)"
L["The slot has item, and the item is epic(color purple)"] = "物品槽中有物品存在，并且该物品是史诗的(紫色)"
L["The slot has item, and the item is legendary(color orange)"] = "物品槽中有物品存在，并且该物品是传说的(橙色)"
L["The slot has item, and the item is artifact(color golden yellow)"] = "物品槽中有物品存在，并且该物品是神器的(暗金色)"
L["The slot has item, and the item is heirloom(color light yellow)"] = "物品槽中有物品存在，并且该物品是传家宝(淡金色)"
L["The slot has item, and the item is wow token(color light yellow)"] = "物品槽中有物品存在，并且该物品是魔兽徽章的(淡金色)"
L["The slot has item, and the item's class is "] = "物品槽中有物品存在，并且该物品的类型是"
L["The slot has item, and the item's sub-class is "] = "物品槽中有物品存在，并且该物品的子类型是"
L["Default"] = "默认"
L["All-In-One"] = "整合"
L[" and "] = " 并且 "
L["Reagent"] = "材料"
L["Drag item to the right panel"] = "拖拽物品到右侧的面板"

L["InItemList"] = "物品列表中"
L["The slot has item, and the item is in the list (choose the view to show the item list panel, drag the item to it will add the item, click the link in the panel will remove it)"] = "物品槽中有物品存在，并且该物品属于物品列表(选择视图来显示物品列表面板，拖拽物品进入来添加，点击物品链接来移除)"
L["Bank"] = "银行"
L["The slot is in the bank"] = "物品槽在银行中"
L["ReagentBank"] = "材料银行"
L["The slot is in the reagent bank"] = "物品槽在材料银行中"
L["BankBag1"] = "银行扩展背包1"
L["The slot is in the 1st bank bag"] = "物品槽在银行扩展背包1中"
L["BankBag2"] = "银行扩展背包2"
L["The slot is in the 2nd bank bag"] = "物品槽在银行扩展背包2中"
L["BankBag3"] = "银行扩展背包3"
L["The slot is in the 3rd bank bag"] = "物品槽在银行扩展背包3中"
L["BankBag4"] = "银行扩展背包4"
L["The slot is in the 4th bank bag"] = "物品槽在银行扩展背包4中"
L["BankBag5"] = "银行扩展背包5"
L["The slot is in the 5th bank bag"] = "物品槽在银行扩展背包5中"
L["BankBag6"] = "银行扩展背包6"
L["The slot is in the 6th bank bag"] = "物品槽在银行扩展背包6中"
L["BankBag7"] = "银行扩展背包7"
L["The slot is in the 7th bank bag"] = "物品槽在银行扩展背包7中"
L["IsNewItem"] = "新物品"
L["The slot has item, and the item is newly added."] = "物品槽中有物品存在，并且该物品是新加入的"

L["IsEquipSet"] = "装备配置方案中"
L["The slot has item, and the item is in a equip set."] = "物品槽中有物品存在，并且该物品属于某个装备配置方案"

L["Tooltip Filter(Use ';' to seperate)"] = "鼠标提示信息过滤(使用';'号来间隔)"

L["Class Buff indicator"] = "职业增益指示器"
L["Buff Panel"] = "增益面板"
L["Debuff Panel"] = "减益面板"
L["Class Buff Panel"] = "职业增益面板"
L["Column Count"] = "列数"
L["Row Count"] = "行数"

L["TOPLEFT"] = "左上角"
L["TOPRIGHT"] = "右上角"
L["BOTTOMLEFT"] = "左下角"
L["BOTTOMRIGHT"] = "右下角"
L["TOP"] = "上侧"
L["BOTTOM"] = "下侧"
L["LEFT"] = "左侧"
L["RIGHT"] = "右侧"
L["CENTER"] = "中间"

L["Top to Bottom"] = "从上到下"
L["Left to Right"] = "从左到右"
L["Show tooltip"] = "显示提示信息"
L["Alt+Right-click to black list"] = "Alt+右键送至黑名单"
L["Show on player"] = "显示玩家自身"
L["Black List"] = "黑名单"
L["ClassBuff List"] = "职业增益列表"
L["The buff would be shown follow the order"] = "增益将按照顺序显示"
L["Please input the class buff's id or name"] = "请输入职业增益的id或者名字"
L["Are you sure to delete the class buff"] = "是否确定删除该职业增益"
L["Export"] = "导出"
L["Import"] = "导入"

L["Tooltip filter(Like 'Artifact Power', use ';' to seperate)"] = "提示信息过滤(比如'神器能量'，使用';'号间隔)"

L["Show the token watch list"] = "显示代币监视列表"
L["Token Watch List Manager"] = "代币监视列表管理器"
L["Double click to add or remove token"] = "双击代币来添加或者移除监视"

L["Please input the container's name"] = "请输入背包的名称"

L["Auto Fade Out"] = "自动渐隐"

L["Lock Micro Menu"] = "锁定微菜单"
L["Lock Extra Action Bar"] = "锁定额外动作条"

L["Auto Repair"] = "自动修理"
L["Check Reputation"] = "检查声望"
L["Auto Sell"] = "自动贩卖"
L["Auto Split"] = "自动分割"
L["Auto"] = "自动"
L["[AutoRepair] No enough money to repair."] = "[自动修理]没有足够的钱进行修理。"
L["[AutoRepair] Cost [Guild] %s."] = "[自动修理]消耗[工会] %s."
L["[AutoRepair] Cost %s."] = "[自动修理]消耗 %s."
L["[AutoSell] Item List:"] = "[自动贩卖]物品列表:"
L["[AutoSell] Total : %s."] = "[自动贩卖]总计 : %s."
L["[AutoSell] Buy back item if you don't want auto sell it."] = "[自动贩卖]买回的物品不会再自动贩卖。"
L["[AutoSell] Alt+Right-Click to mark item as auto sell."] = "[自动贩卖]Alt+鼠标右键标记该物品自动贩卖。"
L["[AutoSplit] You also can use Alt+Left-Click to push items together."] = "[自动分割]你可以使用Alt+鼠标点击物品来进行合并。"

L["Auto Quest"] = "自动任务"

L["Smoothing updating"] = "平滑血条更新"
L["Smoothing delay"] = "平滑更新延迟"
L["Please input the smoothing update delay(s)"] = "请输入平滑更新延迟(s)"

L["Macro Bindings"] = "宏绑定编辑器"
L["Use '%unit' in macro as spell target"] = "在宏中使用%unit来替代动作目标"
L["You can drag spell into the edit box"] = "你可以拖拽技能放入输入框"

L["Buff Order List"] = "增益显示顺序"
L["Please input the buff's spell id(you can get it in the game tip)"] = "请输入增益的技能ID(你可以在鼠标提示中找到)"

L["Max Opacity"] = "最大不透明度"
L["Min Opacity"] = "最小不透明度"
L["Please input the max opacity(0 - 1)"] = "请输入最大不透明度(0 - 1)"
L["The min opacity can't be greater than the max opacity"] = "最小不透明度不能大于最大不透明度"
L["Please input the min opacity(0 - 1)"] = "请输入最小不透明度(0 - 1)"

L["Please input the scale number [0.5-3]"] = "请输入缩放的比例值[0.5-3]"

L["Save action bar's settings"] = "保存该动作条布局及内容"
L["Apply action bar's settings"] = "载入动作条布局及内容"

L["World Mark"] = "世界标记"
L["Raid Target"] = "团队标记"
L["Square Layout"] = "方形布局"
L["Circle Layout"] = "圆形布局"
L["Drag the masked button to modify the layout."] = "移动被选中的按钮来修改布局。"

L["Player's holding the shift key"] = "玩家按住了shift键"
L["Player's holding the ctrl key"] = "玩家按住了ctrl键"
L["Player's holding the alt key"] = "玩家按住了alt键"
L["Player's mouse cursor is currently holding an item/ability/macro/etc"] = "玩家的鼠标上有物品/技能/宏等"

L["Only Enemy"] = "只显示敌人"
L["As Global"] = "全账号通用"

L["Debuff Record Min Threshold"] = "减益最小监控时间"
L["Debuff Alert Threshold"] = "减益最大警告时间"
L["Please input the debuff alert threshold(0 - 10)"] = "请输入减益剩余多少时间时发起警告(0-10)"
L["Please input the debuff record min threshold(0 - 10)"] = "请输入最小多少持续时间的减益被监视(0-10)"