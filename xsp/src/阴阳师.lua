screen.init(2)
function _Do(_tab)
	
	-- 判断是否传入的是正确内容
	local check_table
	check_table = function(t)
		if type(t) ~= 'table' then error('传入非table内容',3) end
		if #t == 0 then error('传入table无数据',3) end
		if not (type(t.csim) == 'number' or type(t.csim) == 'nil') then error('相似度数值不正确',3) end
		
		if not (
			(
				type(t.Repeat) == 'table' and
				type(t.Repeat.n) == 'number' and
				type(t.Repeat.Run) == 'function'
			) or
			type(t.Repeat) == 'nil'
			) then
			error('重复检测参数不正确',3)
		end
		
		if not (
			(
				type(t.timeout) == 'table' and
				type(t.timeout.n) == 'number' and
				type(t.timeout.Run) == 'function'
			) or
			type(t.timeout) == 'nil'
			) then
			error('超时参数不正确',3)
		end
		
		for n, v in ipairs(t) do
			if not (
				type(v.Color) == 'table' and 
				type(v.Run) == 'function' and
				(type(v.csim) == 'number' or type(v.csim) == 'nil') and
				(type(v.layer) == 'table' or type(v.layer) == 'nil')
				) then
				error(
					string.format(
						"传入table第%d项不正确",
						n
					),
					3
				)
			else
				for _n, _v in ipairs(v.Color) do
					if not (
						type(_v[1]) == 'number' and
						type(_v[2]) == 'number' and
						type(_v[3]) == 'number'
						) then
						error(
							string.format(
								"传入table第%d项内点色第%d项不正确",
								n,
								_n
							),
							3
						)
					end
				end
				if type(v.layer) == 'table' then
					check_table(v.layer)
				end
			end
		end
	end
	check_table(_tab)
	if _G.DoName then table.insert(DoName,_tab.Name) else _G.DoName = {_tab.Name} end
	local _now = os.time()
	local _break = false
	local _Repeat = false
	for _key,_value in ipairs(_tab) do _value.RepeatTime = os.time() end
	if _tab.Begin then _tab.Begin() end
	while true do
		local _States = {}
		
		--寻找满足状态的项
		screen.keep()
		for _key,_value in ipairs(_tab) do
			if screen.is_colors(_value.Color, _value.csim or _tab.csim) then
				table.insert(_States,_key)
				if _tab.Repeat then
					if os.time() - _value.RepeatTime >= _tab.Repeat.n then
						_value.RepeatTime = os.time()
						if not _value.NoRepeat then _Repeat = true;nLog(_value.Name..' 重复') end
					end
				end
			else
				_value.RepeatTime = os.time()
			end
		end
		screen.unkeep()
		
		--超时判断
		if #_States == 0 then
			if _tab.timeout then
				if os.time() - _now >= _tab.timeout.n then
					nLog('超时')
					local _Back = _tab.timeout.Run()
					if _Back then return end
					if _tab.timeout.layer then _Do(_tab.timeout.layer) end
					_now = os.time()
				end
			end
		else
			--执行满足状态的项
			for _key,_value in ipairs(_States) do
				local _Handle = _tab[_value]
				nLog(_Handle.Name)
				if _Handle.Run then if _Handle.Run() then _break = true end end
				if _Handle.layer then _Do(_Handle.layer) end
				_now = os.time()
			end
			if _break then break end
			if _Repeat then if _tab.Repeat.Run() then return end
				_Repeat=false
			end
		end
		
		sys.msleep(_tab.sleep or 500)
	end
	if _tab.End then _tab.End() end
	if type(_G.DoName) == 'table' then
		if #(_G.DoName) > 0 then
			table.remove(_G.DoName,#DoName)
		end
	end
end

local confirm, selects = dialog()
	:add_label('阴阳师 - 桃')
	:add_switch('好友邀请', true)
	:add_picker('操作', {'觉醒业火轮','觉醒风转符','觉醒水灵鲤','觉醒天雷鼓','御魂','妖气封印','附近妖怪','结界突破'})
	:add_label('此脚本需要进入游戏后启动')
	:add_label('进入战斗页面需要启动自动')
	:show()

if not confirm then os.exit() end

sys.sleep(3)

yys = {	Name = '阴阳师',
	{	Name = '探索页面',
		Color = {
			{45,34,0xa0b6ea},
			{51,50,0x6786e5},
			{51,60,0xe3eef9},
			{46,53,0xe9f1fa},
			{71,50,0x24306f},
			{84,591,0x4777e3},
			{183,604,0x221913},
			{255,600,0x2c2118}
		},
		Run = (function()
			touch.tap(50,53)
		end),
	},
	{	Name = '庭院-折叠卷轴',
		Color = {
			{   87,    5, 0x6c3c3f},
			{   86,   10, 0x3c1e1b},
			{  375,    5, 0x3f3126},
			{  375,    8, 0xa88457},
			{  374,   10, 0x5d4537},
			{ 1037,   18, 0xb3792f},
			{ 1037,   24, 0xd6c4a1},
			{ 1098,   18, 0xae782f},
			{ 1092,   27, 0xd6c4a1},
			
			{ 1102,  514, 0x752e1f},
			{ 1084,  520, 0x8a573c},
			{ 1079,  529, 0xe0975a},
			{ 1080,  541, 0x795750},
			{ 1083,  541, 0x962a24},
			{ 1053,  587, 0xd9cbc4},
			{ 1048,  594, 0xaf7355},
			{ 1054,  588, 0xd9cbc4},
		},
		Run = (function()
			touch.tap(1072,565)
		end),
	},
	{	Name = '庭院-展开卷轴',
		Color = {
			{   87,    5, 0x6c3c3f},
			{   86,   10, 0x3c1e1b},
			{  375,    5, 0x3f3126},
			{  375,    8, 0xa88457},
			{  374,   10, 0x5d4537},
			{ 1037,   18, 0xb3792f},
			{ 1037,   24, 0xd6c4a1},
			{ 1098,   18, 0xae782f},
			{ 1092,   27, 0xd6c4a1},
			
			{ 1116,  505, 0x833924},
			{ 1114,  532, 0xc3996c},
			{ 1114,  537, 0xfac17a},
			{ 1108,  559, 0xd6c7bf},
			{ 1125,  599, 0x967b77},
			{ 1101,  624, 0x520b18},
		},
		Run = (function()
			touch.tap(219,578)
		end),
	},
	{	Name = '好友邀请',
		Color = {
			{417,361,0x83244a},
			{418,371,0xdf6851},
			{420,391,0xdf6851},
			{420,404,0x852749},
			{536,396,0xcbb59c},
			{487,371,0xd2634e},
			{629,367,0xf3b25e},
			{630,394,0xf3b25e},
			{653,398,0xf3b25e}
		},
		Run = (function()
			if selects['好友邀请'] then
				touch.tap(667,381,30,500)
			else
				touch.tap(667,381,30,500)
			end
		end),
	},
	{	Name = '准备',
		Color = {
			{816,586,0x493433},
			{823,607,0x2e2330},
			{869,608,0x251c2b},
			{975,601,0xddc597},
			{996,616,0xdcb276},
			{1035,600,0xe5c48d},
			{1078,610,0xe1b97e},
			{973,563,0x691007}
		},
		Run = (function()
			touch.tap(1036,492,30,500)
		end),
	},
	{	Name = '胜利',
		Color = {
			{404,130,0x71160f},
			{406,162,0x9d2a1c},
			{406,177,0x991c12},
			{451,159,0xb37e6c},
			{564,150,0x77572c},
			{669,146,0xdac494},
			{669,156,0xcdb480}
		},
		Run = (function()
			touch.tap(577,583,30,500)
		end),
	},
	{	Name = '失败',
		Color = {
			{394,127,0x4d4555},
			{392,143,0xaf9a83},
			{393,169,0x5f566a},
			{445,163,0x5a5164},
			{447,143,0xaa957e},
			{558,163,0x493c2c},
			{540,178,0x918264},
			{517,186,0x2d261d}
		},
		Run = (function()
			touch.tap(577,583,30,500)
		end),
	},
	{	Name = '开箱子',
		Color = {
			{554,232,0xca5a2d},
			{583,231,0xbe3d21},
			{591,226,0xbe3d21},
			{521,335,0xba401b},
			{600,338,0xbb461a},
			{473,420,0x6f290b},
			{634,425,0x340204}
		},
		Run = (function()
			touch.tap(562,367,30,500)
		end),
	},
	{	Name = '领取成功',
		Color = {
			{501,403,0xdd8b1a},
			{513,452,0xb33c1b},
			{531,478,0x151413},
			{596,433,0x3a486a},
			{630,420,0xe39b18},
			{632,458,0xc06e12},
			{605,488,0x5e0c0d},
			{587,485,0x070301}
		},
		Run = (function()
			touch.tap(562,367,30,500)
		end),
	},
	{	Name = '队伍页面',
		Color = {
			{176,30,0x392a1e},
			{181,61,0x463424},
			{189,101,0xc1b8ae},
			{183,108,0xc1b8ae},
			{157,101,0xad4e2b},
			{142,105,0xc0b3a7},
			{144,111,0xa9370f},
			{743,516,0xf3b25e},
			{705,552,0x973c2e},
			{802,547,0xf3b25e}
		},
		Run = (function()
			local select_mode = {
				['觉醒业火轮'] = {false, {160, 222}},
				['觉醒风转符'] = {false, {158, 281}},
				['觉醒水灵鲤'] = {false, {157, 342}},
				['觉醒天雷鼓'] = {false, {154, 403}},
				['御魂'] = {false, {154, 459}},
				['妖气封印'] = {true, {156, 312}},
				['附近妖怪'] = {true, {156, 374}},
				['结界突破'] = {true, {161, 431}}
			}
			local s = select_mode[selects['操作']]
			if s[1] then
				touch.on(232,449):step_len(2):step_delay(0):move(230,198):delay(500):off()
				sys.sleep(2)
			end
			touch.tap(s[2][1],s[2][2],30,500)
			while true do
				local pos_list = {{889,185,0xf3b25e},
				{890,288,0xf3b25e},
				{890,395,0xf3b25e},
				{892,483,0xf3b25e}}
				local find_pos = nil
				for _, pos in ipairs(pos_list) do
					if screen.is_colors({pos}) then
						touch.tap(pos[1],pos[2],30,500)
						break
					end
				end
				if not screen.is_colors({
	{  709,  511, 0x973b2e},
	{  714,  522, 0xf3b25e},
	{  706,  552, 0xb6643e},
	{  765,  551, 0xf3b25e},
	{  811,  558, 0xd48030},
	{  812,  515, 0x9a3f2e},
	{  796,  528, 0xf3b25e},
}) then
					break
				else
					touch.tap(755,533,30,500)
				end
			end
		end),
	},
	sleep = 1000,
	csim = 75
}
_Do(yys)