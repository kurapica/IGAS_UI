local L = IGAS:NewLocale("IGAS_UI", "zhCN")
if not L then return end

L["Change Log"] = "更新日志"

L["ChangeLog"] = [[
<html>
<body>
<p>
<lime>2016/06/21 v59 : </lime>
</p><br/>
<p>
    1. 动作条菜单重新调整，使用多级组织方便使用。
</p>
<p>
    2. 你可以在菜单中找到"动作按钮着色"，根据几种情况调整按钮颜色。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v58 : </lime>
</p><br/>
<p>
    1. 你可以使用相反的顺序来自动生成物品列表。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v57 : </lime>
</p><br/>
<p>
    1. 现在你可以随意移动任务面板。
</p>
<br/><br/>
<p>
<lime>2016/06/04 v50 : </lime>
</p><br/>
<p>
    1. 头像系统也可以使用自动隐藏功能。
</p>
<p>
    2. 自动隐藏功能替换为使用直接的宏条件，新的宏条件制作面板加入，你可以点击各个菜单中的"自动隐藏"来打开它。
</p>
<p>
    3. 默认提供三个宏条件，第一是"单人游戏且没有目标并不在战斗"，第二个是"宠物对战中"，第三个是"在载具中"，你可以自行添加更多的条件组合。
</p>
<br/><br/>
<p>
<lime>2016/06/01 v47 : </lime>
</p><br/>
<p>
    1. 现在可以保存单个动作条的样式，并将它应用到其他的单独动作条上。
</p>
<br/><br/>
<p>
<lime>2016/03/08 v41 : </lime>
</p><br/>
<p>
    1. 在动作条菜单上增加"自动填充弹出动作条"选项，可以使用它对弹出条的根按钮进行设定，比如自动生成药剂列表。根按钮必须是普通（没有映射到系统动作条）的并带有弹出按钮。也可以绑定多个根按钮到同一个动作列表，当这个动作列表更新时，会按照顺序填充这些弹出动作条。
</p>
<p>
    2. 右键点击弹出条根按钮不再触发动作.
</p>
<br/><br/>
<p>
<lime>2016/02/28 v40 : </lime>
</p><br/>
<p>
    1. 减少内存增长。
</p>
<p>
    2. 对聊天面板简单修改。
</p>
<br/><br/>
<p>
<lime>2014/04/02 v33 : </lime>
</p><br/>
<p>
    1. 包裹欄被替換，需要IGAS v71支持。
</p>
<p>
    2. 彈出條的顯示時間可以在菜單中進行配置。
</p>
<br/><br/>
<p>
<lime>2014/04/02 v32 : </lime>
</p><br/>
<p>
    1. 使用Config文件来为团队面板和头像面板的所有面板元素提供底层配置。
</p>
<p>
    2. 现在你可以使用鼠标右键切换头像面板的显示／隐藏。
</p>
<br/><br/>
<p>
<lime>2013/11/8 v31 : </lime>
</p><br/>
<p>
<lime>2013/11/8 v31 : </lime>
</p><br/>
<p>
    1. 新的团队面板机能，右键点击减益(Debuff)可以直接送入黑名单，可在配置菜单关闭："单元配置" -> "右键点击减益送至黑名单"
</p><br/><p>
    2. 团队面板的减益(Debuff)的刷新位置将从右下角开始，而不是现在的左上角，显示更加符合习惯，该功能需要IGAS v55版本，该版本预计下周发布。
</p><br/><p>
    3. 显示增益/减益的提示会阻挡鼠标操作，可在配置菜单关闭： "单元配置" -> "显示增益/减益的提示".
</p>
<br/><br/>
<p>
<lime>2013/11/6 v30 : </lime>
</p><br/>
<p>
    1. 团队面板的大量配置信息可以在配置菜单中找到，比如按职业颜色显示，元素大小，队伍过滤等。
</p><br/><p>
    2. 团队面板会显示你和你的团队遭遇过的所有减益，可以在配置菜单中设置黑名单 : "单元配置" -> "减益过滤".
</p>
<br/><br/>
<p>
<lime>2013/10/20: v29 </lime>
</p><br/>
<p>
	1. 死者面板增加，仅显示死亡的角色，默认不启用，单独的配置菜单提供。
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
L["Use mouse down"] = "鼠标按下触发"
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

L["MAINTANK"] = "主坦克"
L["MAINASSIST"] = "副坦克"
L["TANK"] = "坦克"
L["HEALER"] = "治疗"
L["DAMAGER"] = "伤害"

L["Dead panel"] = "死者面板"

L["Debuff filter"] = "减益过滤"
L["Black list"] = "黑名单"
L["Double click to remove"] = "双击项目移除"

L["Right mouse-click send debuff to black list"] = "右键点击减益送至黑名单"
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