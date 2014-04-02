local L = IGAS:NewLocale("IGAS_UI", "zhCN")
if not L then return end

L["Change Log"] = "更新日志"

L["ChangeLog"] = [[
<html>
<body>
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

L["Spell Binding"] = "技能绑定"
L["Lock Raid Panel"] = "锁定团队面板"

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