.pragma library


let data = (function() {

    //命令格式加入 type和param（比如可以选择路径、可以选择一些参数）
    //数据格式加入 enable 和 yield

    //命令格式：
    //  key: {
    //      command: [命令显示, 命令模板, 说明, 缩进空格数, 是否换行, 代码颜色, 按钮颜色, [联用命令列表], 编译运行函数],
    //          编译运行函数的参数为：参数数组、tab个数、命令信息（包含command和params），如果为undefined或null则使用默认的处理方案（替换模板命令字符串的%n）；
    //      params: [[参数1说明, 类型, 是否必须（true为必填，false为编译缺省是空字符串，其他（包括undefined、null也为字符串）为编译时原值）, 输入类型, 输入参数, 颜色], 。。。]}
    //          其中：
    //              类型：string、number、bool、string|number、name、json、unformatted、code、label
    //                  string、number、bool、string|number、name、json、unformatted 可以长按选择；
    //                  编译时 string 带引号，bool会自动转换，string|number表示如果可以转换为number，则不带引号，否则带引号；
    //                  label 为增加一个提示框
    //              输入类型：为0表示只给默认值（输入参数为默认值）；为1表示选择某目录下的文件夹，输入参数为目录路径；为2表示选择预选选项（输入参数为[[选项], [对应值], 默认值]）；为9表示固定值；
    //数据格式：
    //  [命令Key名, 额外设置（enabled为是否注释）, 参数值1, ...]
    let sysCommands = ({
                                '载入地图': {
                                    command: ['载入地图', 'game.loadmap(%1);', '载入一张地图', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@地图名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator, 'green'],
                                        ['载入一张地图', 'label'],
                                    ],
                                },
                                '信息': {
                                    command: ['显示信息', 'yield game.msg(%1,%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@信息', 'string', true, 2, [['文字', '变量', '地图变量', '全局变量'], ['', '${变量1}', '${game.d["变量1"]}', '${game.gd["变量1"]}']], 'green'],
                                        ['文字间隔', 'number', '60', 0, '60', 'blue'],
                                        ['预定义文字', 'string', '``', 0, '', 'lightblue'],
                                        ['持续时间', 'number', '1000', 0, '', 'lightblue'],
                                        ['显示效果', 'number', '3', 2, [['固定大小', '自适应高度', '自适应宽度', '自适应宽高'], ['0', '2', '1', '3'], '3'], 'lightblue'],
                                        //['是否暂停游戏', 'bool', 'true', 0, '', 'darkblue'],
                                    ],
                                },
                                '对话': {
                                    command: ['对话', 'yield game.talk(%1,%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['角色名', 'string', undefined, 0, '', 'darkgreen'],
                                        ['*@信息', 'string', true, 2, [['文字', '变量', '地图变量', '全局变量'], ['', '${变量1}', '${game.d["变量1"]}', '${game.gd["变量1"]}']], 'green'],
                                        ['文字间隔', 'number', '60', 0, '', 'blue'],
                                        ['预定义文字', 'string', '``', 0, '', 'lightblue'],
                                        ['持续时间', 'number', '1000', 0, '', 'lightblue'],
                                        //['是否暂停游戏', 'bool', 'true', 2, [['是', '否'], ['true', 'false']], , 'darkblue'],
                                    ],
                                },
                                '说话': {
                                    command: ['说话', 'game.say(%1,%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['角色名', 'string', undefined, 0, '', 'darkgreen'],
                                        ['*@信息', 'string', true, 2, [['文字', '变量', '地图变量', '全局变量'], ['', '${变量1}', '${game.d["变量1"]}', '${game.gd["变量1"]}']], 'green'],
                                        ['文字间隔', 'number', '60', 0, '', 'blue'],
                                        ['预定义文字', 'string', '``', 0, '', 'lightblue'],
                                        ['持续时间', 'number', '1000', 0, '', 'lightblue'],
                                    ],
                                },
                                '菜单': {
                                    command: ['显示菜单', 'var $index = yield game.menu(%1,%2);var $value = %2[$index];', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['标题', 'string', '', 0, '标题', 'green'],
                                        ['*菜单内容', 'json', 'true', 0, '[]', 'blue'],
                                        //['@是否暂停游戏', 'bool', 'true', 2, [['是', '否'], ['true', 'false']], 'darkblue'],
                                    ],
                                },
                                '输入文本': {
                                    command: ['输入文本', 'var $value = yield game.input(%1,%2);', '输入文本', 0, true, 'red', 'white'],
                                    params: [
                                        ['标题', 'string', true, 0, '标题', 'green'],
                                        ['预设值', 'string', '', 0, '', 'blue'],
                                        //['@是否暂停游戏', 'bool', 'true', 2, [['是', '否'], ['true', 'false']], 'darkblue'],
                                    ],
                                },
                                '创建主角': {
                                    command: ['创建主角', 'game.createhero({RId:%1, $name:%2});', '创建主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@角色资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, 'green'],
                                        ['主角名', 'string', undefined, 0, '', 'darkgreen'],
                                    ],
                                },
                                '主角信息': {
                                    command: ['主角信息', 'game.hero(%1)', '主角信息', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@主角名', 'string|number', true, 2, [['全部', '角色名'], ['-1', ''], ''], 'green'],
                                    ],
                                },
                                '修改主角': {
                                    command: ['修改主角', 'game.hero(%1, %2);', '修改主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@主角名', 'string', true, 2, [['角色名'], [''], ''], 'green'],
                                        ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                    ],
                                },
                                '删除主角': {
                                    command: ['删除主角', 'game.delhero(%1);', '删除主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@主角名', 'string|number', true, 2, [['全部', '角色名'], ['-1', ''], ''], 'green'],
                                    ],
                                },
                                '移动主角': {
                                    command: ['移动主角', 'game.movehero(%1,%2);', '移动主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*地图块x', 'number', true, 0, '0', 'green'],
                                        ['*地图块y', 'number', true, 0, '0', 'green'],
                                    ],
                                },
                                '创建NPC': {
                                    command: ['创建NPC', 'game.createrole({RId: %1, $name: %2, $bx: %3, $by: %4, $action: %5});', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@角色资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, 'green'],
                                        ['NPC名', 'string', undefined, 0, '', 'darkgreen'],
                                        ['*地图块x', 'number', true, 0, '', 'blue'],
                                        ['*地图块y', 'number', true, 0, '', 'blue'],
                                        ['@动作（1为移动）', 'number', '1', 2, [['移动', '禁止'], ['1', '0']], 'green'],
                                    ],
                                },
                                '移动NPC': {
                                    command: ['移动NPC', 'game.moverole(%1,%2,%3);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*NPC名', 'string', true, 0, '', 'green'],
                                        ['地图块x', 'number', undefined, 0, '', 'blue'],
                                        ['地图块y', 'number', undefined, 0, '', 'blue'],
                                    ],
                                },
                                'NPC信息': {
                                    command: ['NPC信息', 'game.role(%1)', 'NPC信息', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@NPC名', 'string|number', true, 2, [['全部', 'NPC名'], ['-1', ''], ''], 'green'],
                                    ],
                                },
                                '修改NPC': {
                                    command: ['修改NPC', 'game.role(%1,%2);', '修改NPC', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@NPC名', 'string', true, 2, [['NPC名'], [''], ''], 'green'],
                                        ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                    ],
                                },
                                '删除NPC': {
                                    command: ['删除NPC', 'game.delrole(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@NPC名', 'string|number', true, 2, [['全部', 'NPC名'], ['-1', ''], ''], 'green'],
                                    ],
                                },


                                '播放音乐': {
                                    command: ['播放音乐', 'game.playmusic(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@音乐名', 'string', true, 1, GameMakerGlobal.musicResourceURL(), 'green'],
                                    ],
                                },
                                '停止音乐': {
                                    command: ['停止音乐', 'game.stopmusic();', '', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '暂停音乐': {
                                    command: ['暂停音乐', 'game.pausemusic();', '', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '继续播放音乐': {
                                    command: ['继续播放音乐', 'game.resumemusic();', '', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },

                                '播放视频': {
                                    command: ['播放视频', 'yield game.playvideo(%1, %2);', '播放视频', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@视频名', 'string', true, 1, GameMakerGlobal.videoResourceURL(), 'green'],
                                        ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                    ],
                                },

                                '停止视频': {
                                   command: ['停止视频', 'game.stopvideo();', '停止视频', 0, true, 'red', 'white'],
                                   params: [
                                   ],
                               },

                                '显示图片': {
                                    command: ['显示图片', 'game.showimage(%1,%2,%3);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@图片名', 'string', true, 1, GameMakerGlobal.imageResourceURL(), 'green'],
                                        ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                        ['id', 'string', undefined, 0, '', 'green'],
                                    ],
                                },

                                '删除图片': {
                                    command: ['删除图片', 'game.delimage(%1);', '删除图片', 0, true, 'red', 'white'],
                                    params: [
                                        ['*id', 'string', true, 0, '', 'green'],
                                    ],
                                },

                                '显示特效': {
                                    command: ['显示特效', 'game.showsprite(%1,%2,%3);', '显示特效', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@特效名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName, 'green'],
                                        ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                        ['id', 'string', undefined, 0, '', 'green'],
                                    ],
                                },

                                '删除特效': {
                                    command: ['删除特效', 'game.delsprite(%1);', '删除特效', 0, true, 'red', 'white'],
                                    params: [
                                        ['*id', 'string', true, 0, '', 'green'],
                                    ],
                                },


                                '场景缩放': {
                                    command: ['场景缩放', 'game.scale(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*倍数', 'number', true, 0, '1', 'green'],
                                    ],
                                },
                                '暂停游戏': {
                                    command: ['暂停游戏', 'game.pause();', '', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '继续游戏': {
                                    command: ['继续游戏', 'game.goon();', '', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },

                                '延时': {
                                    command: ['延时', 'yield game.wait(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*毫秒', 'number', true, 0, '', 'green'],
                                    ],
                                },

                                '游戏刷新率': {
                                    command: ['游戏刷新率', 'game.setinterval(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['*刷新率', 'number', true, 0, '16', 'green'],
                                    ],
                                },
                                '存档': {
                                    command: ['存档', 'game.save(%1,%2);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['文件名', 'string', '`autosave`', 0, '', 'green'],
                                        ['显示文字', 'string', '`存档`', 0, '', 'blue'],
                                    ],
                                },
                                '读档': {
                                    command: ['读档', 'game.load(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['文件名', 'string', '`autosave`', 0, '', 'green'],
                                    ],
                                },
                                '游戏结束': {
                                    command: ['游戏结束', 'game.gameover(%1);', '', 0, true, 'red', 'white'],
                                    params: [
                                        ['参数', 'json', '{}', 0, '', 'green'],
                                    ],
                                },


                                '创建战斗主角': {
                                    command: ['创建战斗主角', 'game.createfighthero(%1);', '创建战斗主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName, 'green'],
                                        //['战斗角色游戏名', 'string', undefined, 0, '', 'darkgreen'],
                                    ],
                                },
                                '删除战斗主角': {
                                    command: ['删除战斗主角', 'game.delfighthero(%1);', '删除战斗主角', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）', '全部'], ['', '-1']], 'darkgreen'],
                                    ],
                                },
                                '战斗主角信息': {
                                    command: ['战斗主角信息', 'game.fighthero(%1,%2)', '战斗主角信息', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）', '全部'], ['', '-1']], 'darkgreen'],
                                        ['@方式', 'number', '0', 2, [['返回对象', '返回名字'], ['0', '1'], '0'], 'darkgreen'],
                                    ],
                                },
                                '获得技能': {
                                    command: ['获得技能', 'game.getskill(%1,%2,%3);', '获得技能', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@技能名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                                        ['*@位置', 'number', true, 2, [['追加', '替换(输入数字下标)'], ['-1', ''], '-1'], 'darkgreen'],
                                    ],
                                },
                                '移除技能': {
                                    command: ['移除技能', 'game.removeskill(%1,%2,%3);', '移除技能', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@技能名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                                        ['*@类型', 'json', true, 2, [['所有', '普通攻击', '技能'], ['{}', '{type: 0}', '{type: 1}'], '{}'], 'darkgreen'],
                                    ],
                                },
                                '技能信息': {
                                    command: ['技能信息', 'game.skill(%1,%2,%3)', '技能信息', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@技能名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                                        ['*@类型', 'json', true, 2, [['所有', '普通攻击', '技能'], ['{}', '{type: 0}', '{type: 1}'], '{}'], 'darkgreen'],
                                    ],
                                },
                                '修改战斗角色属性': {
                                    command: ['修改战斗角色属性', 'game.addprops(%1,{"%2": %3},%4);', '修改战斗角色属性', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@属性', 'name', true, 2, [['一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力'], ['HP,0','HP,1','HP,2','MP,0','MP,1','attack','defense','speed','luck','power']], 'darkgreen'],
                                        ['*值', 'number', true, 0, undefined, 'darkgreen'],
                                        ['*@恢复方式', 'number', true, 2, [['增加数值', '倍率', '赋值', '满值（多段）'], ['1', '2', '3', '0'], '1'], 'darkgreen'],
                                    ],
                                },
                                '升级': {
                                    command: ['升级', 'game.$userscripts.levelup(%1,%2);', '升级', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*级别', 'number', true, 0, '1', 'darkgreen'],
                                    ],
                                },

                                '获得道具': {
                                    command: ['获得道具', 'game.getgoods(%1,%2);', '获得道具', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@道具资源名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                                        ['*个数', 'number', true, 0, '1', 'darkgreen'],
                                        //['新属性', 'json', '{}', 0, '{}', 'darkgreen'],
                                    ],
                                },

                                '移除道具': {
                                    command: ['移除道具', 'game.removegoods(%1,%2);', '移除道具', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@道具资源名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                                        ['*个数', 'number', true, 0, '1', 'darkgreen'],
                                    ],
                                },

                                '道具信息': {
                                    command: ['道具信息', 'game.goods(%1,%2)', '道具信息', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@道具资源名或下标或-1', 'string|number', true, 2, [['道具资源名或下标（数字）', '所有'], ['', '-1'], '-1'], 'darkgreen'],
                                        ['筛选', 'json', '{}', 0, '{}', 'darkgreen'],
                                    ],
                                },
                                '道具个数': {
                                    command: ['道具个数', 'game.getgoods(%1,0)', '道具个数', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@道具资源名或下标', 'string|number', true, 2, [['道具资源名或下标（数字）'], ['']], 'darkgreen'],
                                    ],
                                },
                                '使用道具': {
                                    command: ['使用道具', 'game.usegoods(%1,%2);', '使用道具', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@道具资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                                    ],
                                },
                                '装备道具': {
                                    command: ['装备道具', 'game.equip(%1,%2);', '装备道具', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@道具资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                                    ],
                                },
                                '卸下装备': {
                                    command: ['卸下装备', 'game.unload(%1,%2);', '卸下装备', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@部位', 'string', true, 2, [['武器', '头戴', '身穿', '鞋子'], ['武器', '头戴', '身穿', '鞋子']], 'darkgreen'],
                                    ],
                                },
                                '装备信息': {
                                    command: ['装备信息', 'game.equipment(%1,%2);', '装备信息', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['@部位', 'string', '', 2, [['武器', '头戴', '身穿', '鞋子', '所有'], ['武器', '头戴', '身穿', '鞋子', '']], 'darkgreen'],
                                    ],
                                },
                                '交易': {
                                    command: ['交易', 'game.trade(%1,%2);', '交易', 0, true, 'red', 'white'],
                                    params: [
                                        ['*道具列表', 'json', true, 0, '[]', 'darkgreen'],
                                        ['回调函数', 'code', undefined, 0, 'function*(){}', 'darkgreen'],
                                    ],
                                },
                                '获得金钱': {
                                    command: ['获得金钱', 'game.money(%1);', '获得金钱', 0, true, 'red', 'white'],
                                    params: [
                                        ['金钱', 'number', '0', 0, '', 'green'],
                                    ],
                                },

                                '进入战斗': {
                                    command: ['进入战斗', 'game.fighting({RId: %1, %2});', '进入战斗', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗脚本', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, 'darkgreen'],
                                        ['@参数', 'json', undefined, 2, [['战斗结束函数'], ['FightEndScript: 函数名']], 'green'],
                                    ],
                                },
                                '开启随机战斗': {
                                    command: ['开启随机战斗', 'game.fighton({RId: %1, %2},%3,%4);', '开启随机战斗', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@战斗脚本', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, 'darkgreen'],
                                        ['@参数', 'json', undefined, 2, [['战斗结束函数'], ['FightEndScript: 函数名']], 'green'],
                                        ['几率(百分之)', 'number', '5', 0, '5', 'darkgreen'],
                                        ['@方式', 'number', '3', 2, [['全部开启', '主角静止时遇敌', '主角行动时遇敌'], ['3', '2', '1'], '3'], 'darkgreen'],
                                    ],
                                },
                                '关闭随机战斗': {
                                    command: ['关闭随机战斗', 'game.fightoff();', '关闭随机战斗', 0, true, 'red', 'white'],
                                    params: [
                                    ],
                                },

                                '添加地图定时器': {
                                    command: ['添加地图定时器', 'game.addtimer(%1,%2,%3);', '添加地图定时器', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@名字', 'string', true, 2, [['定时器1', '定时器2', '定时器3'], ['定时器1', '定时器2', '定时器3'], ''], 'darkgreen'],
                                        ['间隔', 'number', '1000', 0, '1000', 'darkgreen'],
                                        ['次数', 'number', '-1', 0, '-1', 'darkgreen'],
                                    ],
                                },
                                '删除地图定时器': {
                                    command: ['删除地图定时器', 'game.deltimer(%1);', '删除地图定时器', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@名字', 'string', true, 2, [['定时器1', '定时器2', '定时器3'], ['定时器1', '定时器2', '定时器3'], ''], 'darkgreen'],
                                    ],
                                },
                                '添加全局定时器': {
                                    command: ['添加全局定时器', 'game.addtimer(%1,%2,%3,true);', '添加全局定时器', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@名字', 'string', true, 2, [['全局定时器1', '全局定时器2', '全局定时器3'], ['全局定时器1', '全局定时器2', '全局定时器3'], ''], 'darkgreen'],
                                        ['间隔', 'number', '1000', 0, '1000', 'darkgreen'],
                                        ['次数', 'number', '-1', 0, '-1', 'darkgreen'],
                                    ],
                                },
                                '删除全局定时器': {
                                    command: ['删除全局定时器', 'game.deltimer(%1,true);', '删除全局定时器', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@名字', 'string', true, 2, [['全局定时器1', '全局定时器2', '全局定时器3'], ['全局定时器1', '全局定时器2', '全局定时器3'], ''], 'darkgreen'],
                                    ],
                                },



                                '条件(': {
                                    command: ['条件(', 'if(', '条件(', 4, false, 'red', 'white', ['括号结束)', '块开始{', '块结束}']],
                                    params: [
                                    ],
                                },
                                '否则条件(': {
                                    command: ['否则条件(', 'else if(', '否则条件(', 4, false, 'red', 'white', ['括号结束)', '块开始{', '块结束}']],
                                    params: [
                                    ],
                                },
                                '否则': {
                                    command: ['否则', 'else', '否则', 0, true, 'red', 'white', ['块开始{', '块结束}']],
                                    params: [
                                    ],
                                },
                                '循环(': {
                                    command: ['循环(', 'for(', '循环(', 4, false, 'red', 'white', ['括号结束)', '块开始{', '块结束}']],
                                    params: [
                                    ],
                                },
                                '括号开始(': {
                                    command: ['括号开始(', '(', '括号开始(', 4, false, 'red', 'white', ['括号结束)']],
                                    params: [
                                    ],
                                },
                                '括号结束)': {
                                    command: ['括号结束)', ')', '括号结束)', -4, false, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '地图变量': {
                                    command: ['地图变量', 'game.d[%1]', '地图变量', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@变量名', 'string', true, 2, [['地图变量1', '地图变量2', '地图变量3', '地图变量4', '地图变量5', '地图变量6', '地图变量7', '地图变量8', '地图变量9'], ['地图变量1', '地图变量2', '地图变量3', '地图变量4', '地图变量5', '地图变量6', '地图变量7', '地图变量8', '地图变量9']], 'green'],
                                    ],
                                },
                                '全局变量': {
                                    command: ['全局变量', 'game.gd[%1]', '全局变量', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@变量名', 'string', true, 2, [['全局变量1', '全局变量2', '全局变量3', '全局变量4', '全局变量5', '全局变量6', '全局变量7', '全局变量8', '全局变量9'], ['全局变量1', '全局变量2', '全局变量3', '全局变量4', '全局变量5', '全局变量6', '全局变量7', '全局变量8', '全局变量9']], 'green'],
                                    ],
                                },
                                '判断': {
                                    command: ['判断', '%1 %2 %3', '判断', 0, false, 'red', 'white'],
                                    params: [
                                        //['符号', 'name', true, 2, [['等于', '==='], ['不等于', '!=='], ['大于', '>'], ['小于', '<'], ['大于等于', '>='], ['小于等于', '<=']], 'blue'],
                                        ['@变量1', 'name', false, 2, [['变量1', '地图变量1', '全局变量1', '当前地图名', '金钱'], ['变量1', 'game.d["变量1"]', 'game.gd["变量1"]', 'game.gd["$sys_map"].$name', 'game.money()']], 'green'],
                                        ['*@符号', 'name', true, 2, [['等于', '不等于', '大于', '小于', '大于等于', '小于等于'], ['===', '!==', '>', '<', '>=', '<=']], 'blue'],
                                        ['*@值/变量', 'name', true, 2, [['未定义', '空', '真', '假'], ['undefined', 'null', 'true', 'false']], 'green'],
                                    ],
                                },
                                '与或非': {
                                    command: ['与或非', '%1', '与或非', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@与或非', 'name', true, 2, [['与', '或', '非'], ['&&', '||', '!']], 'green'],
                                    ],
                                },
                                '运算符': {
                                    command: ['运算符', '%1', '运算符', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@运算符', 'name', true, 2, [['加', '减', '乘', '除', '取余', '取反', '赋值'], ['+', '-', '*', '/', '%', '~', '=']], 'green'],
                                    ],
                                },
                                //过期
                                '简易运算': {
                                    command: ['运算', '%1 %2 %3 %4 %5 %6', '运算', 0, true, 'red', 'white'],
                                    params: [
                                        ['@定义', 'name', '', 2, [['var（推荐）', 'let'], ['var', 'let']], 'green'],
                                        ['*@变量1', 'name', true, 2, [['地图变量（不用定义）', '全局变量（不用定义）', '变量（第一次使用必须定义）'], ['game.d["变量名1"]', 'game.gd["变量名1"]', '变量名1']], 'green'],
                                        ['*@符号', 'name', true, 2, [['赋值', '加赋值', '减赋值', '乘赋值', '除赋值', '取余赋值', '位与赋值', '位或赋值', '左移赋值', '右移赋值'], ['=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '%=', '<<=', '>>='], '='], 'black'],
                                        ['@变量2', 'name', '', 2, [['值', '字符串', '变量2', '地图变量1', '全局变量2', '随机数'], [' ', '``', '变量2', 'game.d["变量2"]', 'game.gd["变量2"]', 'game.rnd(m,n)']], 'green'],
                                        ['@运算符', 'name', '', 2, [['加', '减', '乘', '除', '取余', '位与', '位或', '左移位', '右移位'], ['+', '-', '*', '/', '%', '&', '|', '<<', '>>']], 'green'],
                                        ['@变量3', 'name', '', 2, [['值', '字符串', '变量3', '地图变量3', '全局变量3', '随机数'], [' ', '``', '变量3', 'game.d["变量3"]', 'game.gd["变量3"]', 'game.rnd(m,n)']], 'green'],
                                    ],
                                },
                                '运算': {
                                    command: ['运算', '%1 %2 %3 %4 %5 %6', '运算', 0, true, 'red', 'white'],
                                    params: [
                                        ['@定义', 'name', '', 2, [['var（推荐）', 'let'], ['var', 'let']], 'green'],
                                        ['*@变量1', 'name', true, 2, [['地图变量（不用定义）', '全局变量（不用定义）', '变量（第一次使用必须定义）'], ['game.d["变量名1"]', 'game.gd["变量名1"]', '变量名1']], 'green'],
                                        ['@符号', 'name', '', 2, [['赋值', '加赋值', '减赋值', '乘赋值', '除赋值', '取余赋值', '位与赋值', '位或赋值', '左移赋值', '右移赋值'], ['=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '%=', '<<=', '>>='], '='], 'black'],
                                        ['@变量2', 'name', '', 2, [['值', '字符串', '变量2', '地图变量1', '全局变量2', '随机数'], [' ', '``', '变量2', 'game.d["变量2"]', 'game.gd["变量2"]', 'game.rnd(m,n)']], 'green'],
                                        ['@运算符', 'name', '', 2, [['加', '减', '乘', '除', '取余', '位与', '位或', '左移位', '右移位', 'in（循环用）', 'of（循环用）'], ['+', '-', '*', '/', '%', '&', '|', '<<', '>>', 'in', 'of']], 'green'],
                                        ['@变量3', 'name', '', 2, [['值', '字符串', '变量3', '地图变量3', '全局变量3', '随机数'], [' ', '``', '变量3', 'game.d["变量3"]', 'game.gd["变量3"]', 'game.rnd(m,n)']], 'green'],
                                    ],
                                },


                                '函数/生成器{': {
                                    command: ['函数/生成器{', 'function %1(%2) {', '定义函数或生成器名', 4, true, 'red', 'white', ['块结束}']],
                                    params: [
                                        ['*@函数名', 'name', true, 2, [['开始事件', '事件1', '事件2', '事件3', '事件4', '事件5', '事件6'], ['*$start', '*事件1', '*事件2', '*事件3', '*事件4', '*事件5', '*事件6']], 'green'],
                                        ['参数(,号分隔)', 'name', '', 0, '', 'blue'],
                                    ],
                                },
                                   //      command: [命令显示, 命令, 说明, 缩进空格数, 是否换行, 代码颜色, 按钮颜色, [联用命令列表]],
                                   //      params: [[参数1说明, 类型, 是否必须（true为必填，false为编译缺省是空字符串，其他（包括undefined、null也为字符串）为编译时原值）, 输入类型, 输入参数, 颜色], 。。。]}
                                '调用函数/生成器': {
                                    command: ['调用函数/生成器', 'game.run(%1,%2);', '调用函数/生成器', 0, true, 'red', 'white'],
                                    params: [
                                        ['*@函数名', 'name', true, 0, '函数名', 'green'],
                                        ['优先级', 'number', '-1', 0, '-1', 'blue'],
                                    ],
                                },


                                '当前地图名': {
                                    command: ['当前地图名', 'game.gd["$sys_map"].$name', '当前地图名', 0, false, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '金钱': {
                                    command: ['金钱', 'game.money()', '金钱', 0, false, 'red', 'white'],
                                    params: [
                                    ],
                                },
                                '战斗角色属性': {
                                    command: ['战斗角色属性', 'game.fighthero(%1).$properties.%2', '战斗角色属性', 0, false, 'red', 'white'],
                                    params: [
                                        ['*@战斗角色游戏名', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                                        ['*@属性', 'name', true, 2, [['一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力'], ['HP[0]','HP[1]','HP[2]','MP[0]','MP[1]','attack','defense','speed','luck','power']], 'darkgreen'],
                                    ],
                                },


                                '块开始{': {
                                    command: ['块开始{', '{', '块开始{', 4, true, 'red', 'white', ['块结束}']],
                                    params: [
                                    ],
                                },
                                '块结束}': {
                                    command: ['块结束}', '}', '块结束}', -4, true, 'red', 'white'],
                                    params: [
                                    ],
                                },

                                '随机数': {
                                    command: ['随机数', 'game.rnd(%1,%2)', '随机数', 0, false, 'red', 'white'],
                                    params: [
                                        ['*m', 'number', true, 0, '', 'green'],
                                        ['*n', 'number', true, 0, '', 'green'],
                                    ],
                                },

                                '自定义': {
                                    command: ['自定义', '%1', '自定义指令', 0, false, 'red', 'white'],
                                    params: [
                                        ['*代码', 'code', true, 0, '', 'green'],
                                    ],
                                },
    })

    let sysCommandsTree = [
        ['游戏命令', 'white', ['载入地图', '场景缩放', '暂停游戏', '继续游戏', '延时', '游戏刷新率', '存档', '读档', '游戏结束']],
        ['交互', '#FF7DF3AA', ['信息', '菜单', '输入文本', '对话', '说话', ]],
        ['地图角色', 'yellowgreen', ['创建主角', '移动主角', '主角信息', '修改主角', '删除主角', '创建NPC', '移动NPC', 'NPC信息', '修改NPC', '删除NPC', ]],
        ['战斗相关', 'yellow', ['创建战斗主角', '删除战斗主角', '战斗主角信息', '获得技能', '移除技能', '技能信息', '修改战斗角色属性', '升级', '进入战斗', '开启随机战斗', '关闭随机战斗', ]],
        ['媒体播放', '#FFFA98DA', ['播放音乐', '停止音乐', '暂停音乐', '继续播放音乐', '播放视频', '停止视频', '显示图片', '删除图片', '显示特效', '删除特效', ]],
        ['道具装备', 'lightgreen', ['获得金钱', '获得道具', '移除道具', '道具信息', '使用道具', '装备道具', '卸下装备', '交易', ]],
        ['定时器', 'wheat', ['添加地图定时器', '删除地图定时器', '添加全局定时器', '删除全局定时器']],
        ['运算', 'lightpink', ['运算', '判断', '与或非', '运算符', '随机数']],
        ['条件', 'lightblue', ['条件(', '否则条件(', '否则']],
        ['循环', 'linen', ['循环(']],
        ['函数/生成器', 'greenyellow', ['函数/生成器{', '调用函数/生成器']],
        ['变量', 'gold', ['当前地图名', '金钱', '战斗角色属性', '道具个数', '地图变量', '全局变量']],
        //['媒体', 'gold', []],
        ['其他', 'lightslategray', ['括号开始(', '括号结束)', '块开始{', '块结束}', '自定义']],
    ];



    return {sysCommands, sysCommandsTree};

})();
