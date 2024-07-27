.pragma library


let data = (function() {

    //命令格式加入 type和param（比如可以选择路径、可以选择一些参数）
    //数据格式加入 enable 和 yield

    //命令格式：
    //  key: {
    //      command: [命令显示, 命令模板, 说明, 缩进空格数, 是否换行, 代码颜色, 按钮颜色, [联用命令列表], [编译运行函数]],
    //          编译运行函数的参数为：参数数组、tab个数、命令信息（包含command和params），如果为undefined或null则使用默认的处理方案（替换模板命令字符串的%n）；
    //      params: [[参数1说明, 类型, 是否必须（true为必填，false为编译缺省是空字符串，其他（包括undefined、null也为字符串）为编译时原值）, 输入类型, 输入参数, 颜色], 。。。]]
    //          其中：
    //              类型：string、number、bool、string|number、name、json、unformatted、text、code、label；
    //                  string、number、bool、string|number、name、json、unformatted、text、code 可以长按选择；
    //                  编译时，string、text 带引号；string|number表示如果可以转换为number，则不带引号，否则带引号；bool会自动转换；name是符合变量名的名称；json是符合转换json的数据；
    //                  text和code是Notepad类型，code带代码高亮、缩进功能；label 为Label提示框；其他都是TextField；
    //              输入类型：为0表示只给默认值（输入参数为默认值）；为1表示选择某目录下的文件夹，输入参数为目录路径；为2表示选择预选选项（输入参数为[[选项], [对应值], 默认值]）；为9表示固定值；
    //数据格式：
    //  [命令Key名, 额外设置（enabled为是否注释）, 参数值1, ...]
    let commandsInfo = ({
        '载入地图': {
            command: ['载入地图', 'yield game.loadmap(%1);', '载入一张地图', 0, true, 'red', 'white'],
            params: [
                ['*@地图资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator, 'green'],
                ['载入一张地图', 'label'],
            ],
        },
        '信息': {
            command: ['显示信息', 'yield game.msg(%1,%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
            params: [
                ['*@信息', 'string', true, 2, [['文字', '地图变量', '全局变量', '存档变量', '引擎变量', '普通变量'], ['', '${game.d["变量名1"]}', 'game.gf["变量名1"]', '${game.gd["变量名1"]}', 'game.cd["变量名1"]', '${变量名1}']], 'green'],
                ['文字间隔', 'number', '60', 0, '60', 'blue'],
                ['预定义文字', 'string', '``', 0, '', 'lightblue'],
                ['持续时间', 'number', '1000', 0, '', 'lightblue'],
                ['显示效果', 'number', '3', 2, [['固定大小', '自适应高度', '自适应宽度', '自适应宽高'], ['0', '2', '1', '3'], '3'], 'lightblue'],
                //['是否暂停游戏', 'bool', 'true', 0, '', 'darkblue'],
            ],
        },
        '多行文本信息': {
            command: ['显示多行文本信息', 'yield game.msg(GlobalLibraryJS.convertToHTML(%1, [" ", "\\n"]),%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
            params: [
                ['*@信息', 'text', true, 2, [['文字', '地图变量', '全局变量', '存档变量', '引擎变量', '普通变量'], ['', '${game.d["变量名1"]}', 'game.gf["变量名1"]', '${game.gd["变量名1"]}', 'game.cd["变量名1"]', '${变量名1}']], 'green'],
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
                ['*@信息', 'string', true, 2, [['文字', '地图变量', '全局变量', '存档变量', '引擎变量', '普通变量'], ['', '${game.d["变量名1"]}', 'game.gf["变量名1"]', '${game.gd["变量名1"]}', 'game.cd["变量名1"]', '${变量名1}']], 'green'],
                ['文字间隔', 'number', '60', 0, '', 'blue'],
                ['预定义文字', 'string', '``', 0, '', 'lightblue'],
                ['持续时间', 'number', '1000', 0, '', 'lightblue'],
                //['是否暂停游戏', 'bool', 'true', 2, [['是', '否'], ['true', 'false']], , 'darkblue'],
            ],
        },
        '说话': {
            command: ['说话', 'game.say(%1,%2,%3,%4,%5);', '', 0, true, 'red', 'white'],
            params: [
                ['*角色名/id', 'string', true, 0, '', 'darkgreen'],
                ['*@信息', 'string', true, 2, [['文字', '地图变量', '全局变量', '存档变量', '引擎变量', '普通变量'], ['', '${game.d["变量名1"]}', 'game.gf["变量名1"]', '${game.gd["变量名1"]}', 'game.cd["变量名1"]', '${变量名1}']], 'green'],
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
                ['菜单内容 是字符串数组；<br>命令返回的数据是 $index（选择的第几项，0起始） 和 $value（选择的值） 变量', 'label'],
            ],
        },
        '输入文本': {
            command: ['输入文本', 'var $value = yield game.input(%1,%2);', '输入文本', 0, true, 'red', 'white'],
            params: [
                ['标题', 'string', true, 0, '标题', 'green'],
                ['预设值', 'string', '', 0, '', 'blue'],
                //['@是否暂停游戏', 'bool', 'true', 2, [['是', '否'], ['true', 'false']], 'darkblue'],
                ['命令返回的文本是 $value 变量', 'label'],
            ],
        },
        '创建主角': {
            command: ['创建主角', 'game.createhero({RID:%1, $name:%2});', '创建主角', 0, true, 'red', 'white'],
            params: [
                ['*@角色资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, 'green'],
                ['主角名/id', 'string', undefined, 0, '', 'darkgreen'],
                ['主角名/id 为标识，操作和特定事件名使用，不可重复；如果省略，系统会自动使用随机标识；<br>命令返回主角组件对象', 'label'],
            ],
        },
        '主角对象': {
            command: ['主角对象', 'game.hero(%1)', '主角对象', 0, false, 'red', 'white'],
            params: [
                ['*@主角名/id', 'string|number', true, 2, [['全部', '角色名'], ['-1', ''], ''], 'green'],
                ['命令返回主角组件对象', 'label'],
            ],
        },
        '修改主角': {
            command: ['修改主角', 'game.hero(%1, %2);', '修改主角', 0, true, 'red', 'white'],
            params: [
                ['*@主角名/id', 'string', true, 2, [['角色名'], [''], ''], 'green'],
                ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                ['命令返回主角组件对象', 'label'],
            ],
        },
        '删除主角': {
            command: ['删除主角', 'game.delhero(%1);', '删除主角', 0, true, 'red', 'white'],
            params: [
                ['*@主角名/id', 'string|number', true, 2, [['全部', '角色名'], ['-1', ''], ''], 'green'],
            ],
        },
        '移动主角': {
            command: ['移动主角', 'game.hero(0, {$bx: %1, $by: %2,});', '移动主角', 0, true, 'red', 'white'],
            params: [
                ['*地图块x', 'number', true, 0, '0', 'green'],
                ['*地图块y', 'number', true, 0, '0', 'green'],
            ],
        },
        '创建NPC': {
            command: ['创建NPC', 'game.createrole({RID: %1, $id: %2, $name: %2, $bx: %3, $by: %4, $action: %5});', '', 0, true, 'red', 'white'],
            params: [
                ['*@角色资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, 'green'],
                ['NPC名/id', 'string', undefined, 0, '', 'darkgreen'],
                ['*地图块x', 'number', true, 0, '', 'blue'],
                ['*地图块y', 'number', true, 0, '', 'blue'],
                ['@动作', 'number', '1', 2, [['移动', '禁止'], ['1', '-1']], 'green'],
                ['NPC名/id 为标识，操作和特定事件名使用，不可重复；如果省略，系统会自动使用随机标识；<br>命令返回NPC组件对象', 'label'],
            ],
        },
        '移动NPC': {
            command: ['移动NPC', 'game.role(%1, {$bx: %2, $by: %3,});', '', 0, true, 'red', 'white'],
            params: [
                ['*NPC名/id', 'string', true, 0, '', 'green'],
                ['地图块x', 'number', undefined, 0, '', 'blue'],
                ['地图块y', 'number', undefined, 0, '', 'blue'],
            ],
        },
        'NPC对象': {
            command: ['NPC对象', 'game.role(%1)', 'NPC对象', 0, false, 'red', 'white'],
            params: [
                ['*@NPC名/id', 'string|number', true, 2, [['全部', 'NPC名'], ['-1', ''], ''], 'green'],
                ['命令返回NPC组件对象', 'label'],
            ],
        },
        '修改NPC': {
            command: ['修改NPC', 'game.role(%1,%2);', '修改NPC', 0, true, 'red', 'white'],
            params: [
                ['*@NPC名/id', 'string', true, 2, [['NPC名'], [''], ''], 'green'],
                ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
                ['命令返回NPC组件对象', 'label'],
            ],
        },
        '删除NPC': {
            command: ['删除NPC', 'game.delrole(%1);', '', 0, true, 'red', 'white'],
            params: [
                ['*@NPC名/id', 'string|number', true, 2, [['全部', 'NPC名'], ['-1', ''], ''], 'green'],
            ],
        },


        '播放音乐': {
            command: ['播放音乐', 'game.playmusic(%1);', '', 0, true, 'red', 'white'],
            params: [
                ['*@音乐资源名', 'string', true, 1, GameMakerGlobal.musicResourcePath(), 'green'],
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
            command: ['播放视频', 'yield game.playvideo(Object.assign({RID: %1}, %2));', '播放视频', 0, true, 'red', 'white'],
            params: [
                ['*@视频资源名', 'string', true, 1, GameMakerGlobal.videoResourcePath(), 'green'],
                ['属性', 'json', '{}', 0, '{}', 'darkgreen'],
            ],
        },

        '停止视频': {
           command: ['停止视频', 'game.stopvideo();', '停止视频', 0, true, 'red', 'white'],
           params: [
           ],
        },

        '显示图片': {
            command: ['显示图片', 'game.showimage(Object.assign({RID: %1, $id: %2, $x: %4, $y: %5, $width: %6, $height: %7, $parent: %3}, %8));', '', 0, true, 'red', 'white'],
            params: [
                ['*@图片资源名', 'string', true, 1, GameMakerGlobal.imageResourcePath(), 'green'],
                ['id', 'string', undefined, 0, '', 'green'],
                ['目标组件', 'string|number', undefined, 2, [['屏幕', '视窗', '场景', '地图', '地图地板', '角色'], ['0', '1', '2', '3', '4', '"角色名/id"'], ''], 'green'],
                ['x', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['y', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['宽', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['高', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['其他属性', 'json', '{}', 0, '{}', 'darkgreen'],
                [`1、id为标识（用来控制、删除和重用）<br>
2、目标组件：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；区别：<br>
a、屏幕（game.$sys.screen）：创建的组件位置和大小固定（包含所有系统组件，战斗场景、摇杆、消息框、对话框等）<br>
b、视窗（game.$sys.viewport）：创建的组件位置和大小固定<br>
c、场景（game.$sys.scene）：创建的组件位置和大小固定，但会被scale影响<br>
d、地图（game.$sys.map）：创建的组件会改变大小和随地图移动<br>
e、地图地板（game.$sys.ground），创建的组件会改变大小和随地图移动<br>
3、$x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）<br>
如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度；<br>
4、$width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）<br>
如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；<br>
`
, 'label'],
],
},

        '删除图片': {
            command: ['删除图片', 'game.delimage({$id: %1, $parent: %2});', '删除图片', 0, true, 'red', 'white'],
            params: [
                ['*id', 'string', true, 0, '', 'green'],
                ['目标组件', 'string|number', undefined, 2, [['屏幕', '视窗', '场景', '地图', '地图地板', '角色'], ['0', '1', '2', '3', '4', '"角色名/id"'], ''], 'green'],
            ],
        },

        '显示特效': {
            command: ['显示特效', 'game.showsprite(Object.assign({RID: %1, $id: %2, $x: %4, $y: %5, $width: %6, $height: %7, $parent: %3, $loops: %8}, %9));', '显示特效', 0, true, 'red', 'white'],
            params: [
                ['*@特效资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName, 'green'],
                ['id', 'string', undefined, 0, '', 'green'],
                ['目标组件', 'string|number', undefined, 2, [['屏幕', '视窗', '场景', '地图', '地图地板', '角色'], ['0', '1', '2', '3', '4', '"角色名/id"'], ''], 'green'],
                ['x', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['y', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['宽', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['高', 'unformatted', '-1', 0, '', 'darkgreen'],
                ['循环次数', 'number', '-1', 0, '', 'darkgreen'],
                ['其他属性', 'json', '{}', 0, '{}', 'darkgreen'],
                [`1、id为标识（用来控制、删除和重用）<br>
2、目标组件：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；区别：<br>
a、屏幕（game.$sys.screen）：创建的组件位置和大小固定（包含所有系统组件，战斗场景、摇杆、消息框、对话框等）<br>
b、视窗（game.$sys.viewport）：创建的组件位置和大小固定<br>
c、场景（game.$sys.scene）：创建的组件位置和大小固定，但会被scale影响<br>
d、地图（game.$sys.map）：创建的组件会改变大小和随地图移动<br>
e、地图地板（game.$sys.ground），创建的组件会改变大小和随地图移动<br>
3、$x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）<br>
如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度；<br>
4、$width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）<br>
如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；<br>
`
                , 'label'],
            ],
        },

        '删除特效': {
            command: ['删除特效', 'game.delsprite({$id: %1, $parent: %2});', '删除特效', 0, true, 'red', 'white'],
            params: [
                ['*id', 'string', true, 0, '', 'green'],
                ['目标组件', 'string|number', undefined, 2, [['屏幕', '视窗', '场景', '地图', '地图地板', '角色'], ['0', '1', '2', '3', '4', '"角色名/id"'], ''], 'green'],
            ],
        },

        '挂载动画': {
            command: ['挂载动画', 'Qt.createQmlObject(\`import QtQuick 2.14;PropertyAnimation {property: "%2";from: %3; to: %4; duration: %5; running: true; targets: %1; easing {type: %6; period: %7; amplitude:%8; overshoot: %9; bezierCurve: %10; } onStopped: this.destroy(); %11} \`, %1);', '挂载动画', 0, true, 'red', 'white'],
            params: [
                ['*父组件', 'name', true, 0, '', 'green'],
                ['*@动画属性', 'unformatted', true, 2, [['x', 'y', '宽', '高', '透明度', '缩放', '角度', '颜色',], ['x', 'y', 'width', 'height', 'opacity', 'scale', 'rotation', 'color',], ''], ''],
                ['*开始值', 'unformatted', true, 0, '', 'green'],
                ['*结束值', 'unformatted', true, 0, '', 'green'],
                ['*总时长', 'number', true, 0, '', 'green'],
                ['easing.type', 'unformatted', 'easing.type', 0, '', 'green'],
                ['easing.period', 'unformatted', 'easing.period', 0, '', 'green'],
                ['easing.amplitude', 'unformatted', 'easing.amplitude', 0, '', 'green'],
                ['easing.overshoot', 'unformatted', 'easing.overshoot', 0, '', 'green'],
                ['easing.bezierCurve', 'json', '[]', 0, '[]', 'green'],
                ['其他参数', 'code', '', 0, '', 'green'],
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
                ['暂停游戏主定时器', 'label'],
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
                ['只是延时事件队列', 'label'],
            ],
        },

        '游戏刷新率': {
            command: ['游戏刷新率', 'game.interval(%1);', '', 0, true, 'red', 'white'],
            params: [
                ['*刷新率', 'number', true, 0, '16', 'green'],
                ['刷新率只是参考值，并不是严格准确的（因为qml的定时器不准确）', 'label'],
            ],
        },
        '存档': {
            command: ['存档', 'yield game.save(%1,%2);', '', 0, true, 'red', 'white'],
            params: [
                ['文件名', 'string', '`autosave`', 0, '', 'green'],
                ['显示文字', 'string', '`存档`', 0, '', 'blue'],
            ],
        },
        '读档': {
            command: ['读档', 'yield game.load(%1);', '', 0, true, 'red', 'white'],
            params: [
                ['文件名', 'string', '`autosave`', 0, '', 'green'],
            ],
        },
        '游戏结束': {
            command: ['游戏结束', 'yield game.gameover(%1);', '', 0, true, 'red', 'white'],
            params: [
                ['参数', 'json', '{}', 0, '', 'green'],
            ],
        },


        '创建战斗主角': {
            command: ['创建战斗主角', 'game.createfighthero(%1);', '创建战斗主角', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName, 'green'],
            ],
        },
        '删除战斗主角': {
            command: ['删除战斗主角', 'game.delfighthero(%1);', '删除战斗主角', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）', '全部'], ['', '-1']], 'darkgreen'],
            ],
        },
        '战斗主角对象': {
            command: ['战斗主角对象', 'game.fighthero(%1,%2)', '战斗主角对象', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）', '全部'], ['', '-1']], 'darkgreen'],
                ['@方式', 'number', '0', 2, [['返回对象', '返回名字'], ['0', '1'], '0'], 'darkgreen'],
            ],
        },
        '获得技能': {
            command: ['获得技能', 'game.getskill(%1,%2,%3);', '获得技能', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@技能名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                ['*@位置', 'number', true, 2, [['追加', '替换(输入数字下标)'], ['-1', ''], '-1'], 'darkgreen'],
            ],
        },
        '移除技能': {
            command: ['移除技能', 'game.removeskill(%1,%2,%3);', '移除技能', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@技能名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                ['*@类型', 'json', true, 2, [['所有', '普通攻击', '技能'], ['{}', '{type: 0}', '{type: 1}'], '{}'], 'darkgreen'],
            ],
        },
        '技能对象': {
            command: ['技能对象', 'game.skill(%1,%2,%3)', '技能对象', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@技能资源名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, 'darkgreen'],
                ['*@类型', 'json', true, 2, [['所有', '普通攻击', '技能'], ['{}', '{type: 0}', '{type: 1}'], '{}'], 'darkgreen'],
                ['注意：命令返回的是所有为 技能资源名 的技能对象数组', 'label'],
            ],
        },
        '修改战斗角色属性': {
            command: ['修改战斗角色属性', 'game.addprops(%1,{"%2": %3},%4);', '修改战斗角色属性', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@属性', 'name', true, 2, [['一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力'], ['HP,0','HP,1','HP,2','MP,0','MP,1','attack','defense','speed','luck','power']], 'darkgreen'],
                ['*值', 'number', true, 0, undefined, 'darkgreen'],
                ['*@恢复方式', 'number', true, 2, [['增加数值', '倍率', '赋值', '满值（多段）'], ['1', '2', '3', '0'], '1'], 'darkgreen'],
            ],
        },
        '升级': {
            command: ['升级', 'game.$userscripts.levelup(%1,%2);', '升级', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*级别', 'number', true, 0, '1', 'darkgreen'],
            ],
        },

        '获得道具': {
            command: ['获得道具', 'game.getgoods(%1,%2);', '获得道具', 0, true, 'red', 'white'],
            params: [
                ['*@道具资源名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                ['*个数', 'number', true, 0, '1', 'darkgreen'],
                ['命令返回背包内此道具的总数', 'label'],
            ],
        },

        '移除道具': {
            command: ['移除道具', 'game.removegoods(%1,%2);', '移除道具', 0, true, 'red', 'white'],
            params: [
                ['*@道具资源名', 'string|number', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                ['*个数', 'number', true, 0, '1', 'darkgreen'],
            ],
        },

        '道具对象': {
            command: ['道具对象', 'game.goods(%1,%2)', '道具对象', 0, false, 'red', 'white'],
            params: [
                ['*@道具', 'string|number', true, 2, [['道具资源名或下标（数字）', '所有'], ['', '-1'], '-1'], 'darkgreen'],
                ['筛选', 'json', '{}', 0, '{}', 'darkgreen'],
                ['注意：命令返回的是道具对象数组', 'label'],
            ],
        },
        '道具个数': {
            command: ['道具个数', 'game.getgoods(%1,0)', '道具个数', 0, false, 'red', 'white'],
            params: [
                ['*@道具', 'string|number', true, 2, [['道具资源名或下标（数字）'], ['']], 'darkgreen'],
            ],
        },
        '使用道具': {
            command: ['使用道具', 'yield game.usegoods(%1,%2);', '使用道具', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@道具资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
                ['注意：只是调用道具的 $commons.$useScript 脚本', 'label'],
            ],
        },
        '装备道具': {
            command: ['装备道具', 'game.equip(%1,%2);', '装备道具', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@道具资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName, 'darkgreen'],
            ],
        },
        '卸下装备': {
            command: ['卸下装备', 'game.unload(%1,%2);', '卸下装备', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['*@部位', 'string', true, 2, [['武器', '头戴', '身穿', '鞋子'], ['武器', '头戴', '身穿', '鞋子']], 'darkgreen'],
            ],
        },
        '装备对象': {
            command: ['装备对象', 'game.equipment(%1,%2);', '装备对象', 0, true, 'red', 'white'],
            params: [
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
                ['@部位', 'string', '', 2, [['武器', '头戴', '身穿', '鞋子', '所有'], ['武器', '头戴', '身穿', '鞋子', '']], 'darkgreen'],
                ['命令返回 战斗角色 的 部位 的 装备；如果部位为空，则返回所有装备的数组', 'label'],
            ],
        },
        '交易': {
            command: ['交易', 'yield game.trade(%1,%2);', '交易', 0, true, 'red', 'white'],
            params: [
                ['*道具列表', 'json', true, 0, '[]', 'darkgreen'],
                ['回调函数', 'code', undefined, 0, 'function*(){}', 'darkgreen'],
                ['注意：道具列表 是道具资源名的数组（也可以是道具对象）', 'label'],
            ],
        },
        '获得金钱': {
            command: ['获得金钱', 'game.money(%1);', '获得金钱', 0, true, 'red', 'white'],
            params: [
                ['金钱', 'number', '0', 0, '', 'green'],
                ['命令返回金钱总数', 'label'],
            ],
        },

        '进入战斗': {
            command: ['进入战斗', 'fight.fighting({RID: %1, %2});', '进入战斗', 0, true, 'red', 'white'],
            params: [
                ['*@战斗脚本资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, 'darkgreen'],
                ['@参数', 'json', undefined, 2, [['战斗结束函数'], ['FightEndScript: 名称']], 'green'],
            ],
        },
        '开启随机战斗': {
            command: ['开启随机战斗', 'fight.fighton({RID: %1, %2},%3,%4);', '开启随机战斗', 0, true, 'red', 'white'],
            params: [
                ['*@战斗脚本资源名', 'string', true, 1, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, 'darkgreen'],
                ['@参数', 'json', undefined, 2, [['战斗结束函数'], ['FightEndScript: 名称']], 'green'],
                ['几率(百分之)', 'number', '5', 0, '5', 'darkgreen'],
                ['@方式', 'number', '3', 2, [['全部开启', '主角静止时遇敌', '主角行动时遇敌'], ['3', '2', '1'], '3'], 'darkgreen'],
            ],
        },
        '关闭随机战斗': {
            command: ['关闭随机战斗', 'fight.fightoff();', '关闭随机战斗', 0, true, 'red', 'white'],
            params: [
            ],
        },

        '添加地图定时器': {
            command: ['添加地图定时器', 'game.addtimer(%1,%2,%3,0b10);', '添加地图定时器', 0, true, 'red', 'white'],
            params: [
                ['*@名字', 'string', true, 2, [['定时器1', '定时器2', '定时器3'], ['定时器1', '定时器2', '定时器3'], ''], 'darkgreen'],
                ['间隔', 'number', '1000', 0, '1000', 'darkgreen'],
                ['次数', 'number', '-1', 0, '-1', 'darkgreen'],
            ],
        },
        '删除地图定时器': {
            command: ['删除地图定时器', 'game.deltimer(%1,0b10);', '删除地图定时器', 0, true, 'red', 'white'],
            params: [
                ['*@名字', 'string', true, 2, [['定时器1', '定时器2', '定时器3'], ['定时器1', '定时器2', '定时器3'], ''], 'darkgreen'],
            ],
        },
        '添加全局定时器': {
            command: ['添加全局定时器', 'game.addtimer(%1,%2,%3,0b11);', '添加全局定时器', 0, true, 'red', 'white'],
            params: [
                ['*@名字', 'string', true, 2, [['全局定时器1', '全局定时器2', '全局定时器3'], ['全局定时器1', '全局定时器2', '全局定时器3'], ''], 'darkgreen'],
                ['间隔', 'number', '1000', 0, '1000', 'darkgreen'],
                ['次数', 'number', '-1', 0, '-1', 'darkgreen'],
            ],
        },
        '删除全局定时器': {
            command: ['删除全局定时器', 'game.deltimer(%1,0b11);', '删除全局定时器', 0, true, 'red', 'white'],
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
        '跳出循环': {
            command: ['跳出循环', 'break;', '', 0, true, 'red', 'white'],
            params: [
            ],
        },
        '继续循环': {
            command: ['继续循环', 'continue;', '', 0, true, 'red', 'white'],
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
                ['*@变量名', 'string', true, 2, [['地图变量1', '地图变量2', '地图变量3', '地图变量4', '地图变量5', '地图变量6', '地图变量7', '地图变量8', '地图变量9'], ['地图变量名1', '地图变量名2', '地图变量名3', '地图变量名4', '地图变量名5', '地图变量名6', '地图变量名7', '地图变量名8', '地图变量名9']], 'green'],
            ],
        },
        '全局变量': {
            command: ['全局变量', 'game.gf[%1]', '全局变量', 0, false, 'red', 'white'],
            params: [
                ['*@变量名', 'string', true, 2, [['全局变量1', '全局变量2', '全局变量3', '全局变量4', '全局变量5', '全局变量6', '全局变量7', '全局变量8', '全局变量9'], ['全局变量名1', '全局变量名2', '全局变量名3', '全局变量名4', '全局变量名5', '全局变量名6', '全局变量名7', '全局变量名8', '全局变量名9']], 'green'],
            ],
        },
        '存档变量': {
            command: ['存档变量', 'game.gd[%1]', '存档变量', 0, false, 'red', 'white'],
            params: [
                ['*@变量名', 'string', true, 2, [['存档变量1', '存档变量2', '存档变量3', '存档变量4', '存档变量5', '存档变量6', '存档变量7', '存档变量8', '存档变量9'], ['存档变量名1', '存档变量名2', '存档变量名3', '存档变量名4', '存档变量名5', '存档变量名6', '存档变量名7', '存档变量名8', '存档变量名9']], 'green'],
            ],
        },
        '引擎变量': {
            command: ['引擎变量', 'game.cd[%2]', '引擎变量', 0, false, 'red', 'white'],
            params: [
                ['*@变量名', 'string', true, 2, [['引擎变量1', '引擎变量2', '引擎变量3', '引擎变量4', '引擎变量5', '引擎变量6', '引擎变量7', '引擎变量8', '引擎变量9'], ['引擎变量名1', '引擎变量名2', '引擎变量名3', '引擎变量名4', '引擎变量名5', '引擎变量名6', '引擎变量名7', '引擎变量名8', '引擎变量名9']], 'green'],
            ],
        },
        '判断': {
            command: ['判断', '%1 %2 %3', '判断', 0, false, 'red', 'white'],
            params: [
                ['@变量1', 'name', false, 2, [['地图变量1', '全局变量1', '存档变量1', '引擎变量1', '普通变量1', '当前地图名', '金钱'], ['game.d["变量名1"]', 'game.gf["变量名1"]', 'game.gd["变量名1"]', 'game.cd["变量名1"]', '变量名1', 'game.gd["$sys_map"].$name', 'game.money()']], 'green'],
                ['*@符号', 'name', true, 2, [['等于（及类型）', '不等于（及类型）', '等于', '不等于', '大于', '小于', '大于等于', '小于等于'], ['===', '!==', '==', '!=', '>', '<', '>=', '<=']], 'blue'],
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
        '运算': {
            command: ['运算', '%1 %2 %3 %4 %5', '运算', 0, true, 'red', 'white'],
            params: [
                //['@定义', 'name', '', 2, [['var（推荐）', 'let'], ['var', 'let']], 'green'],
                ['*@变量1', 'name', true, 2, [['地图变量（不用定义）', '全局变量（不用定义）', '存档变量（不用定义）', '引擎变量（不用定义）', '普通变量', '定义普通变量(var)', '定义普通变量(let)'], ['game.d["变量名1"]', 'game.gf["变量名1"]', 'game.gd["变量名1"]', 'game.cd["变量名1"]', '变量名1', 'var 变量名1', 'let 变量名1']], 'green'],
                ['*@符号', 'name', true, 2, [['赋值', '加赋值', '减赋值', '乘赋值', '除赋值', '取余赋值', '位与赋值', '位或赋值', '左移赋值', '右移赋值'], ['=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '%=', '<<=', '>>='], '='], 'black'],
                ['@变量2', 'name', '', 2, [['地图变量2', '全局变量2', '存档变量2', '引擎变量2', '普通变量2', '值', '字符串', '随机数'], ['game.d["变量名2"]', 'game.gf["变量名1"]', 'game.gd["变量名2"]', 'game.cd["变量名2"]', '变量名2', ' ', '``', 'game.rnd(m,n)']], 'green'],
                ['@运算符', 'name', '', 2, [['加', '减', '乘', '除', '取余', '位与', '位或', '左移位', '右移位'], ['+', '-', '*', '/', '%', '&', '|', '<<', '>>']], 'green'],
                ['@变量3', 'name', '', 2, [['地图变量3', '全局变量3', '存档变量3', '引擎变量3', '普通变量3', '值', '字符串', '随机数'], ['game.d["变量名3"]', 'game.gf["变量名1"]', 'game.gd["变量名3"]', 'game.cd["变量名3"]', '变量名3', ' ', '``', 'game.rnd(m,n)']], 'green'],
                [`<br>
<font color="red">地图变量</font>：整个地图中有效，切换地图后清空；<br>
<font color="red">全局变量</font>：游戏运行时有效，读档、退出游戏后无效；<br>
<font color="red">存档变量</font>：游戏运行时一直有效，且会存入存档，切换存档后无效；<br>
<font color="red">引擎变量</font>：游戏运行时一直有效，游戏退出自动保存，游戏开始自动载入，不会丢失且和存档读档无关；<br>
<font color="red">普通变量</font>：就是JS的var（函数作用域）和let（块作用域）变量；<br>
`
                , 'label'],
            ],
        },


        '函数/生成器{': {
            command: ['函数/生成器{', 'function %1(%2) {', '定义函数或生成器名', 4, true, 'red', 'white', ['块结束}']],
            params: [
                ['*@名称', 'name', true, 2, [['开始事件', '事件1', '事件2', '事件3', '事件4', '事件5', '事件6'], ['*$start', '*事件1', '*事件2', '*事件3', '*事件4', '*事件5', '*事件6']], 'green'],
                ['参数(,号分隔)', 'name', '', 0, '', 'blue'],
                [`<br>
<font color="red">$start</font>：表示载入事件（地图载入或游戏载入）；<br>
<font color="red">$end</font>：表示离开地图事件；<br>
<font color="red">$地图块事件名</font>：表示主角进入地图事件块时的事件（对应的角色脚本事件函数名是：$地图块事件名_map）；<br>
<font color="red">$地图块事件名_leave</font>：表示主角离开地图块事件时的事件（对应的角色脚本事件函数名是：$地图块事件名_map_leave）；<br>
<font color="red">$NPCid</font>：表示主角与NPC对话时的事件（对应的角色脚本事件函数名是$interactive）；<br>
<font color="red">$map_click</font>：地图点击事件；<br>
<font color="red">$角色id_click</font>：角色点击事件（对应的角色脚本事件函数名是$click）；<br>
<font color="red">$NPCid_collide</font>：NPC 与 主角/NPC 的触碰事件（对应的角色脚本事件函数名是$collide）；<br>
<font color="red">$角色id_collide_obstacle</font>：角色 与 地图障碍/边界 的碰撞事件（对应的角色脚本事件函数名是$collide_obstacle）；<br>
<font color="red">$角色id_arrive</font>：角色自动行走到达目的地时触发的事件（对应的角色脚本事件函数名是$arrive）；<br>
<font color="red">定时器名</font>：创建定时器后会自动调用定时器事件（包括全局和地图定时器）；<br>
`
                , 'label'],
            ],
        },
        '调用函数/生成器': {
            command: ['调用函数/生成器', 'game.run(%1,%2);', '调用函数/生成器', 0, true, 'red', 'white'],
            params: [
                ['*名称', 'name', true, 0, '名称', 'green'],
                ['优先级', 'number', '-1', 0, '-1', 'blue'],
                ['手动将一个 函数/生成器/生成器对象 放入事件队列中运行', 'label'],
            ],
        },
        '函数/生成器结束': {
            command: ['函数/生成器结束', 'return %1;', '函数/生成器结束', 0, true, 'red', 'white'],
            params: [
                ['值', 'name', undefined, 0, '', 'green'],
            ],
        },
        '生成器中断': {
            command: ['生成器中断', 'yield %1;', '生成器中断', 0, true, 'red', 'white'],
             params: [
                ['值', 'name', undefined, 0, '', 'green'],
            ],
        },
        '立即调用函数/生成器': {
            command: ['立即调用函数/生成器', 'game.run(%1,%2);', '立即调用函数/生成器', 0, true, 'red', 'white'],
            params: [
                ['*名称', 'name', true, 0, '名称', 'green'],
                ['立刻运行 函数/生成器/生成器对象（不会放入事件队列）；<br>注意：支持yield的6个命令必须调整一下，方法为：<br>a、将这6个命令的最后一个参数callback设置为0即可；<br>b、或者命令名+1（比如game.msg1），参数与原函数完全相同；', 'label'],
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
                ['*@战斗角色', 'string|number', true, 2, [['战斗角色游戏名或下标（数字）'], ['']], 'darkgreen'],
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
                ['*m（最小值，包含m）', 'number', true, 0, '', 'green'],
                ['*n（最大值，不包含n）', 'number', true, 0, '', 'green'],
                ['命令返回m到n之间的整数，可赋值给变量、参与运算或拼接字符串', 'label'],
            ],
        },

        '自定义': {
            command: ['自定义', '%1', '自定义指令', 0, false, 'red', 'white'],
            params: [
                ['*代码', 'code', true, 0, '', 'green'],
            ],
        },
    })

    let groupsInfo = [
        ['游戏命令', 'white', ['载入地图', '场景缩放', '暂停游戏', '继续游戏', '延时', '游戏刷新率', '存档', '读档', '游戏结束']],
        ['交互', '#FF7DF3AA', ['信息', '多行文本信息', '菜单', '输入文本', '对话', '说话', ]],
        ['地图角色', 'yellowgreen', ['创建主角', '移动主角', '主角对象', '修改主角', '删除主角', '创建NPC', '移动NPC', 'NPC对象', '修改NPC', '删除NPC', ]],
        ['战斗相关', 'yellow', ['创建战斗主角', '删除战斗主角', '战斗主角对象', '获得技能', '移除技能', '技能对象', '修改战斗角色属性', '升级', '进入战斗', '开启随机战斗', '关闭随机战斗', ]],
        ['媒体播放', '#FFFA98DA', ['播放音乐', '停止音乐', '暂停音乐', '继续播放音乐', '播放视频', '停止视频', '显示图片', '删除图片', '显示特效', '删除特效', '挂载动画', ]],
        ['道具装备', 'lightgreen', ['获得金钱', '获得道具', '移除道具', '道具对象', '使用道具', '装备道具', '卸下装备', '装备对象', '交易', ]],
        ['定时器', 'wheat', ['添加地图定时器', '删除地图定时器', '添加全局定时器', '删除全局定时器']],
        ['运算', 'lightpink', ['运算', '判断', '与或非', '运算符', '随机数']],
        ['条件', 'lightblue', ['条件(', '否则条件(', '否则']],
        ['循环', 'linen', ['循环(', '跳出循环', '继续循环']],
        ['函数/生成器', 'greenyellow', ['函数/生成器{', '调用函数/生成器', '函数/生成器结束', '立即调用函数/生成器', '生成器中断']],
        ['变量', 'gold', ['当前地图名', '金钱', '战斗角色属性', '道具个数', '地图变量', '全局变量', '存档变量', '引擎变量']],
        //['媒体', 'gold', []],
        ['其他', 'lightslategray', ['括号开始(', '括号结束)', '块开始{', '块结束}', '自定义']],
    ];



    return {commandsInfo, groupsInfo};

})();
