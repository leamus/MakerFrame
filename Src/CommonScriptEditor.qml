import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


import './Core'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: root


    signal sg_close(bool saved)



    function init() {
        let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;

        console.debug('[CommonScriptEditor]filePath:', path);

        const defaultCode = "
//注意：game.$globalLibraryJS

//.import 'level_chain.js' as JSLevelChain       //导入另一个js文件
//let jsLevelChain = JSLevelChain;    //让外部可访问



//配置
//  注意：
//    1、fontSize为正数，表示用pointSize；为负数，表示用pixelSize；
//    2、$minHeight和$maxHeight；>0且<1，表示高度为 值*屏幕大小；为小数（包括字符串）表示 值*行数；为整数表示像素；null表示默认；
let $config = {
    //游戏
    $game: {
        $loadAllResources: 0,   //提前载入所有资源
        $walkAllDirections: true,   //主角可多方向行走（否则4方向）
        $changeMapStopAction: true,   //切换地图后停止主角动作
    },
    //地图
    $map: {
        $opacity: 0.6,   //人物遮挡透明度
        $smooth: true,   //缩放是否平滑或点阵
    },
    //角色
    $role: {
        $smooth: true,   //缩放是否平滑或点阵
        $say: {
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 12,
            $fontColor: 'white',
        },
        $name: {
            $backgroundColor: '#7F000000',
            $borderColor: '#00000000',
            $fontSize: 12,
            $fontColor: 'white',
        },
    },
    //特效
    $spriteEffect: {
        $smooth: true,   //缩放是否平滑或点阵
    },
    //图片
    $image: {
        $smooth: true,   //缩放是否平滑或点阵
    },
    //摇杆
    $joystick: {
        //位置和大小
        $left: 6,
        $bottom: 7,
        $size: 20,
        $opacity: 0.6,
        $image: '',
        $backgroundImage: '',
        $joystickMinimumProportion: 0.2,    //使能最低的比例
    },
    //按钮（数组，前两个是系统的必有）
    $buttons: [
        {
            //位置、颜色
            $right: 10,
            $bottom: 16,
            $size: 6,
            $color: 'red',
            $opacity: 0.6,
            $image: '',
            $pressed: function*() {
                this.scale = 0.9;

                //if(!game.$globalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return null;

                game.$sys.interact();
                return null;
            },
            $released: function*() {
                this.scale = 1;
            },
        },
        {
            $right: 16,
            $bottom: 8,
            $size: 6,
            $color: 'blue',
            $opacity: 0.6,
            $image: '',
            $pressed: function*() {
                this.scale = 0.9;

                //if(!game.$globalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return null;

                game.window(1);
                //game.window(1, {MaskColor: 'transparent'});
                return null;
            },
            $released: function*() {
                this.scale = 1;
            },
        },
        {
            $right: 10,
            $bottom: 10,
            $size: 6,
            $color: 'green',

            //按下事件
            $pressed: function*() {
                this.scale = 0.9;

                if(game.pause(null))
                    return null;

                yield game.msg('自定义按键');
            },
            $released: function*() {
                this.scale = 1;
            },
        },
    ],
    //按键函数（press为true表示按下，为false表示弹起）
    $keys: {
        [Qt.Key_Escape]: (pressed, event)=>{
            if(pressed)
                game.$sys.showExitDialog();
        },
        [Qt.Key_Back]: (pressed, event)=>{
            if(pressed)
                game.$sys.showExitDialog();
        },
    },
    //窗口
    $window: {
        //窗口显示事件
        $show: function(newFlags, windowFlags) {
            //if(newFlags & 0b1)
            //    game.showimage(, {RID: 'FightScene2.jpg', $width: -1, $height: -1}, 'aaa');
        },
        //窗口隐藏事件
        $hide: function(newFlags, windowFlags) {
            //if(newFlags & 0b1)
            //    game.delimage('aaa');
        },
    },
    $styles: {
        //主菜单窗口
        $main: {
            $maskColor: '#7FFFFFFF',
            $borderColor: 'white',
            $backgroundColor: '#CF6699FF',
            $itemFontSize: 16,
            $itemFontColor: 'white',
            $itemBackgroundColor1: '#00FFFFFF',
            $itemBackgroundColor2: '#66FFFFFF',
            $titleFontSize: 16,
            $titleBackgroundColor: '#66FFFFFF',
            $titleFontColor: 'white',
            $itemBorderColor: '#60FFFFFF',
            $titleText: '',
        },
        //系统
        $system: {
            $maskColor: '#7FFFFFFF',
            $borderColor: 'white',
            $backgroundColor: '#CF6699FF',
            $itemFontSize: 16,
            $itemFontColor: 'white',
            $itemBackgroundColor1: '#00FFFFFF',
            $itemBackgroundColor2: '#66FFFFFF',
            $titleFontSize: 16,
            $titleBackgroundColor: '#66FFFFFF',
            $titleFontColor: 'white',
            $itemBorderColor: '#60FFFFFF',
            $titleText: '',
        },

        $talk: {
            $name: true,
            $avatar: true,
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 19,
            $fontColor: 'white',
            $maskColor: '#01000000',
            $minWidth: null,
            $maxWidth: null,
            $minHeight: null,
            $maxHeight: null,
            //$maskColor: '#00000000',  //全0会隐藏Mask，导致只能点击消息框才能有效
        },
        $msg: {
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 19,
            $fontColor: 'white',
            $maskColor: '#7FFFFFFF',
            $minWidth: null,
            $maxWidth: null,
            $minHeight: null,
            $maxHeight: null,
        },
        $menu: {
            $maskColor: '#7FFFFFFF',
            $borderColor: 'white',
            $backgroundColor: '#CF6699FF',
            $itemHeight: 60,
            $titleHeight: 39,
            $itemFontSize: 16,
            $itemFontColor: 'white',
            $itemBackgroundColor1: '#00FFFFFF',
            $itemBackgroundColor2: '#66FFFFFF',
            $titleFontSize: 16,
            $titleBackgroundColor: '#EE00CC99',
            $titleFontColor: 'white',
            $itemBorderColor: '#60FFFFFF',
        },
        $input: {
            $backgroundColor: 'black',
            $borderColor: '#FFFFFF',
            $titleHeight: undefined,
            $fontSize: 16,
            $fontColor: 'white',
            $titleBackgroundColor: '#FF0035A8',
            $titleBorderColor: 'transparent',
            $titleFontSize: 16,
            $titleFontColor: 'white',
            $maskColor: '#7FFFFFFF',
        },
    },
    //系统组件的一些名称
    $names: {
        $money: '金钱',
        //装备预留槽位（会显示这些槽位，且按顺序排，不在里面的会追加在后面）；
        $equipReservedSlots: ['头戴', '身穿', '武器', '鞋子'],
    },
    //战斗场景
    $fight: {
        $styles: {
            $menu: {
                $borderColor: 'white',
                $backgroundColor: '#CF6699FF',
                $itemHeight: 60,
                $titleHeight: 39,
                $itemFontSize: 16,
                $itemFontColor: 'white',
                $itemBackgroundColor1: '#00FFFFFF',
                $itemBackgroundColor2: '#66FFFFFF',
                $titleFontSize: 16,
                $titleBackgroundColor: '#EE00CC99',
                $titleFontColor: 'white',
                $itemBorderColor: '#60FFFFFF',
            },
        },

        //战斗人物额外组件条
        $combatant_bars: [
            {$type: 1, $property: ['$name'], $spacing: 6, }, //显示文字，属性为姓名
            {$type: 2, $property: ['$$propertiesWithExtra', 'HP'], $height: 6, $spacing: 6, $colors: ['yellow', 'red', '#800080']}, //显示数据条，属性为HP
            {$type: 2, $property: ['$$propertiesWithExtra', 'MP'], $height: 6, $spacing: 6, $colors: ['blue', 'black']}, //显示数据条，属性为HP
        ],
    },
    //安卓配置
    $android: {
        //屏幕旋转规则
        $orient: 4,
    },
    //4个对象的根prototype对象，$objectType为对象类型
    $protoObjects: {
        $fightRole: {$objectType: 1},
        $goods: {$objectType: 2},
        $skill: {$objectType: 3},
        $fightScript: {$objectType: 4},
    },
};



//游戏初始化（游戏开始和载入存档时调用）
function *$gameInit(newGame) {
    game.gf.$plugins = {};

    //载入项目的 game.js 的所有变量和函数复制给 game.gf，并调用其 $init
    if(FrameManager.sl_fileExists(game.$globalJS.toPath(game.$projectpath + game.$gameMakerGlobal.separator + 'game.js'))) {
        let gameJS = game.$sys.caches.jsEngine.load(game.$globalJS.toURL(game.$projectpath + game.$gameMakerGlobal.separator + 'game.js'));
        if(gameJS) {
            Object.assign(game.gf, gameJS);
            if(gameJS.$init) {
                let r = gameJS.$init(newGame);
                if(game.$globalLibraryJS.isGenerator(r))yield* r;
                //game.run(gameJS.$init(newGame) ?? null);
            }
        }
    }
    /*/载入所有插件的 game.js 的所有变量和函数复制给 game.gf.$plugins[tp0][tp1]，并调用其 $init
    let plugins = yield game.plugin();
    for(let tp0 in plugins) {
        game.gf.$plugins[tp0] = {};
        for(let tp1 in plugins[tp0]) {
            game.gf.$plugins[tp0][tp1] = {};
            let gameJSPath = game.$projectpath + game.$gameMakerGlobal.separator + 'Plugins' + game.$gameMakerGlobal.separator + tp0 + game.$gameMakerGlobal.separator + tp1 + game.$gameMakerGlobal.separator + 'Components';
            if(FrameManager.sl_fileExists(game.$globalJS.toPath(gameJSPath + game.$gameMakerGlobal.separator + 'game.js'))) {
                let gameJS = game.$sys.caches.jsEngine.load(game.$globalJS.toURL(gameJSPath + game.$gameMakerGlobal.separator + 'game.js'));
                if(gameJS) {
                    Object.assign(game.gf.$plugins[tp0][tp1], gameJS);
                    if(gameJS.$init) {
                        let r = gameJS.$init(newGame);
                        if(game.$globalLibraryJS.isGenerator(r))yield* r;
                        //game.run(gameJS.$init(newGame) ?? null);
                    }
                }
            }
        }
    }
    */


    //每秒恢复事件
    game.addtimer('resume_event', 1000, -1, true);
    game.gf['resume_event'] = function() {
        for(let combatant of game.gd['$sys_fight_heros']) {
            if(combatant.$$propertiesWithExtra.HP[0] > 0)
                game.addprops(combatant, {'HP': [2], 'MP': [2]});
        }
    }


    //点击屏幕事件
    game.gf['$map_click'] = function(bx, by, x, y) {
        let hero = game.hero(0);
        if(hero && hero.$$nActionType !== -1) {
            let rolePos = hero.pos();
            //简单走
            //game.hero(0, {$action: 2, $targetBx: bx, $targetBy: by});
            //A*算法走
            game.hero(hero, {$action: 2, $targetBlocks: game.$gameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [bx, by])});
        }
        return null;
    }


    if(newGame)
        yield game.msg('合理安排时间');


    game.goon();


    return null;
}

//游戏退出
function *$gameRelease(gameExit) {
    //调用项目的 game.js 的 $release
    if(game.gf.$release) {
        let r = game.gf.$release(gameExit);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //game.run(game.gf.$release(gameExit) ?? null);
    }

    /*/载入所有插件的 game.js 的 $release
    let plugins = yield game.plugin();
    for(let tp0 in game.gf.$plugins) {
        for(let tp1 in game.gf.$plugins[tp0]) {
            if(game.gf.$plugins[tp0][tp1].$release) {
                let r = game.gf.$plugins[tp0][tp1].$release(gameExit);
                if(game.$globalLibraryJS.isGenerator(r))yield* r;
                //game.run(game.gf.$plugins[tp0][tp1].$release(gameExit) ?? null);
            }
        }
    }
    */


    if(gameExit)
        if(game.gd['$sys_map'].$name)
            yield game.save();  //自动存档

    return null;
}


//存档前调用
function *$beforeSave() {
    //game.gd['save_datetime'] = Date.now();
    return null;
}

//读档前调用
function *$beforeLoad() {
    return null;
}

//存档后调用
function *$afterSave() {
    return null;
}

//读档后调用
function *$afterLoad() {
    return null;
}


//打开地图前调用
function *$beforeLoadmap(mapName, userData) {
    /*if(game.$globalLibraryJS.isArray(game.gd['$sys_before_loadmap'])) {
        for(let ts of game.gd['$sys_before_loadmap'])
            game.run(ts(mapName) ?? null, {Priority: -3, Type: 0, Running: 0, Tips: 'beforeLoadmap'});
    }
    */
    //game.run(function*(){yield game.msg(game.d['$sys_map'].$name);});

    return null;
}

//打开地图后调用
function *$afterLoadmap(mapName, userData) {
    /*if(game.$globalLibraryJS.isArray(game.gd['$sys_after_loadmap'])) {
        for(let ts of game.gd['$sys_after_loadmap'])
            game.run(ts(mapName) ?? null, {Priority: -1, Type: 0, Running: 0, Tips: 'afterLoadmap'});
    }
    */

    return null;
}



//战斗角色
function $Combatant(fightRoleRID, showName) {
    //console.debug('$Combatant');
    if(!fightRoleRID)
        fightRoleRID = '深林孤鹰';
    if(!showName)
        showName = fightRoleRID;


    //属性定义
    let properties = {
        HP: [200, 200, 200],
        //healthHP: 200,
        //remainHP: 200,


        MP: [200, 200],
        //remainMP: 200,

        attack: 50,
        defense: 50,

        //其他属性
        power: 50,
        luck: 50,
        speed: 50,

        EXP: 0,     //经验
        level: 0,   //级别

    };


    //战斗角色名（包含特效）
    this.$rid = fightRoleRID;
    //this.fightRoleRID = fightRoleRID;

    this.$name = showName;     //游戏显示名
    this.$index = -1;  //序号（敌人为-1）

    this.$avatar = '';
    this.$size = [50, 50];
    this.$color = 'white';

    //所有属性
    this.$properties = properties;

    //this.fightSkill = null;   //普通攻击
    this.$skills = [];       //普通攻击 和 技能/魔法 的对象，可以加入其他字段（比如级别，这些字段会覆盖原有的属性）
    //this.$goods = [];      //携带道具 的（只有敌人有） 对象
    this.$equipment = {};    //装备；key为position，value为 道具对象，可以加入其他（比如破损率，这些字段会覆盖原有的属性）



    //this.hide = false;        //是否隐藏


    //战斗属性+道具属性（动态计算），不会存档
    this.$$propertiesWithExtra = game.$globalLibraryJS.deepCopyObject(properties);


    //战斗属性，不会保存
    //注意：这里只是显示需要用到的字段，实际会在fight前重新初始化!!!
    this.$$fightData = {
        //这个info不要用，系统会战斗时自动初始化
        $info: {
            $index: -1,              //所在队伍下标；-1为没上场；
            $teamsID: [0, 1],         //0：我方；1：敌方；2：友军。下标：己方、对方、友方
            $teams: [],               //保存队伍对象。下标：己方、对方、友方

            //Game组件：
            //$teamsComp: [],
            //$comp: null,
            //$spriteEffect: null,

        },


        //战斗选择
        $choice: {
            $type: -1,  //选择的类型（主要是这个来判断!!）。0，；1，休息；2，道具；3，技能；4，（逃跑）；-1为没选择；-2为随机选择普通攻击（倒序开始）
            $attack: undefined, //攻击选择的技能或道具    //（-1为获得普通攻击（倒序），-2为休息，undefined为没选择）
            $targets: undefined, //技能的每个选择步骤值数组，值类型：战斗人物数组[FightRole]或-1（全部）；菜单选项下标；
        },
        //保存上次选择
        $lastChoice: {},


        //$actionData: ({}),   //动作数据；key为动作名，value为特效名



        $buffs: ({}),        //buffs

        //defenseSkill: '',    //防御选择
        //lastDefenseSkill: '',
    };
}
$Combatant.prototype = $config.$protoObjects.$fightRole;



function 属性(p, n=0) {
    let ret;
    if(game.$globalLibraryJS.isValidNumber(n, 0b1)) {
        n = Number(n);
        if(game.$globalLibraryJS.isString(mappingCombatantProperty[p])) {
            this.$properties[mappingCombatantProperty[p]] += n;
            ret = this.$properties[mappingCombatantProperty[p]];
        }
        else if(game.$globalLibraryJS.isArray(mappingCombatantProperty[p])) {
            this.$properties[mappingCombatantProperty[p][0]][mappingCombatantProperty[p][1]] += n;
            ret = this.$properties[mappingCombatantProperty[p][0]][mappingCombatantProperty[p][1]];
        }
    }
    return ret;
}

function 附加属性(p, n=0) {
    let ret;
    if(game.$globalLibraryJS.isValidNumber(n, 0b1)) {
        n = Number(n);
        if(game.$globalLibraryJS.isString(mappingCombatantProperty[p])) {
            this.$$propertiesWithExtra[mappingCombatantProperty[p]] += n;
            ret = this.$$propertiesWithExtra[mappingCombatantProperty[p]];
        }
        else if(game.$globalLibraryJS.isArray(mappingCombatantProperty[p])) {
            this.$$propertiesWithExtra[mappingCombatantProperty[p][0]][mappingCombatantProperty[p][1]] += n;
            ret = this.$$propertiesWithExtra[mappingCombatantProperty[p][0]][mappingCombatantProperty[p][1]];
        }
    }
    return ret;
}

$Combatant.prototype.属性 = 属性;
$Combatant.prototype.附加属性 = 附加属性;


//系统显示 和 真实属性 对应
//中文属性索引
let mappingCombatantProperty = {
    //系统用到的
    '血量': ['HP', 2],
    '血量1': ['HP', 1],
    '血量2': ['HP', 0],


    //其他
    '魔法': ['MP', 1],
    '魔法2': ['MP', 0],

    '攻击': 'attack',
    '防御': 'defense',
    '灵力': 'power',
    '幸运': 'luck',
    '速度': 'speed',

    '经验': 'EXP',
    '级别': 'level',
};



//显示战斗人物详细信息
let $combatantInfo = function(combatant) {
    let tinfo = '';
    for(let tp in mappingCombatantProperty) {
        //多段值
        if(game.$globalLibraryJS.isArray(mappingCombatantProperty[tp])) {
            tinfo += (tp + ':' + combatant.$$propertiesWithExtra[mappingCombatantProperty[tp][0]][mappingCombatantProperty[tp][1]] + ' ');
        }
        //单值
        else {
            tinfo += (tp + ':' + combatant.$$propertiesWithExtra[mappingCombatantProperty[tp]] + ' ');
        }
    }

    return tinfo;
}

//显示的道具名格式
//flags：Image、Color、Count、Price分别表示是否显示图像、颜色和数量（数量只有可叠加的才显示）、价格（0、1、2）；
let $showGoodsName = function(goods, flags=null) {
    if(flags === undefined || flags === null)
        flags = {Image: true, Color: true, Count: true, Price: 0};


    let tstr = '';
    let name = '<table width=100% height=100%><td width=0% style=\"vertical-align:middle;\">%1</td><td width=100% style=\"text-align:center;vertical-align:middle;\">%2</td><td width=0% style=\"text-align:right;vertical-align:middle;\"><font color=\"yellow\">%3</font></td></table>';


    if(flags['Image'] && goods.$image) {
        //let goodsPath = game.$globalJS.toPath(game.$projectpath + game.$gameMakerGlobal.separator + game.$config.strGoodsDirName) + game.$gameMakerGlobal.separator;

        //game.$globalLibraryJS.showRichTextImage();
        tstr = ' <img src=\"%1\" width=\"%2\" height=\"%3\" style=\"vertical-align: top;\">  '.
            //arg(goodsPath + goods.$rid + game.$gameMakerGlobal.separator + goods.$image).
            arg(game.$gameMakerGlobal.imageResourceURL(goods.$image)).
            arg(goods.$size[0]).
            arg(goods.$size[1]);
    }

    name = name.arg(tstr);


    tstr = '';

    if(flags['Color'] && goods.$color)
        tstr = `<font color=\"${goods.$color}\">`;

    tstr += goods.$name;

    if(flags['Color'] && goods.$color)
        tstr += '</font>';


    if(flags['Count'] && (goods.$stackable || goods.$count > 1))
        tstr += ` x${goods.$count}`;

    name = name.arg(tstr);


    tstr = '';

    if(flags['Price'] !== undefined) {
        if(GlobalLibraryJS.isArray(goods.$price))
            tstr = ' ￥' + goods.$price[flags['Price']];
        else
            tstr = ' ￥?';
    }

    name = name.arg(tstr);


    return name;
}

//显示的战斗人物名格式
//flags：avatar、color分别表示是否显示头像、颜色
let $showCombatantName = function(combatant, flags=null) {
    let name = '';
    //let fightRolePath = game.$globalJS.toPath(game.$projectpath + game.$gameMakerGlobal.separator + game.$config.strFightRoleDirName) + game.$gameMakerGlobal.separator;

    if(flags === undefined || flags === null)
        flags = {avatar: true, color: true};

    if(flags['avatar'] && combatant.$avatar) {
        //game.$globalLibraryJS.showRichTextImage();
        name += ' <img src=\"%1\" width=\"%2\" height=\"%3\" style=\"vertical-align: top;\">  '.
            //arg(fightRolePath + combatant.$rid + game.$gameMakerGlobal.separator + combatant.$avatar).
            arg(game.$gameMakerGlobal.imageResourceURL(combatant.$avatar)).
            arg(combatant.$size[0]).
            arg(combatant.$size[1]);
    }

    if(flags['color'] && combatant.$color)
        name += `<font color=\"${combatant.$color}\">`;

    name += combatant.$name;

    if(flags['color'] && combatant.$color)
        name += '</font>';

    return name;
}


//刷新战斗人物
function $refreshCombatant(combatant, checkLevel=true) {

    //只有我方战斗人物才可以升级
    if(checkLevel && combatant.$index >= 0)
        levelUp(combatant, 0, false);

    //战斗时，由于是脚本系统运行，所以必须放在最前才能使血量实时更新
    //game.run(function() {
        //计算新属性
        computeCombatantPropertiesWithExtra(combatant);
        //刷新战斗时人物数据
        //fight.$sys.refreshCombatant(combatant);
    //}, {Priority: 0, Tips: 'refreshCombatant1'});
}


//直接升level级；为0表示检测是否需要升级；
//  combatant是战斗角色对象；
function levelUp(combatant, level=0, refresh=true) {

    //优先载入战斗角色自己的升级链，如果没有则载入系统的
    let levelupscript;
    let levelalgorithm;
    if(combatant.$commons) {
        levelupscript = combatant.levelUpScript;
        levelalgorithm = combatant.levelAlgorithm;
    }

    if(!levelupscript) {
        try {
            levelupscript = JSLevelChain.commonLevelUpScript;
        }
        catch(e) {
            levelupscript = game.$gameMakerGlobalJS.commonLevelUpScript;
        }
    }

    if(!levelalgorithm) {
        try {
            levelalgorithm = JSLevelChain.commonLevelAlgorithm;
        }
        catch(e) {
            levelalgorithm = game.$gameMakerGlobalJS.commonLevelAlgorithm;
        }
    }



    //如果需要升级，则计算升级所需要的条件，然后直接达到即可（只增不减）；
    if(level > 0) {
        //game.run(function() {
            let result = levelalgorithm(combatant, combatant.$properties.level + level);
            for(let r in result) {  //提取所有条件并设置为满足
                //只增不减
                if(combatant.$properties[r] < result[r])
                    combatant.$properties[r] = result[r];
            }
        //});
    }

    //检测升级
    game.run(levelupscript(combatant), 'levelupscript');

    //强制刷新
    if(refresh)
        game.run(function() {
            //计算新属性
            computeCombatantPropertiesWithExtra(combatant);
            //刷新战斗时人物数据
            //fight.$sys.refreshCombatant(combatant);
        }, 'refreshCombatant2');
}



//计算 combatant 装备后的属性 并返回
//$equipEffectAlgorithm为某道具装备脚本
function computeCombatantPropertiesWithExtra(combatant) {
    //累加装备、Buff后的属性
    combatant.$$propertiesWithExtra = game.$globalLibraryJS.deepCopyObject(combatant.$properties);

    //行走速度改变示例代码1/3
    let 行走速度 = 0;
    if(combatant.$index === 0 && game.hero(0))
        //行走速度 = game.gd['$sys_main_roles'][0].$speed;
        行走速度 = game.hero(0).$data.$speed;
        //行走速度 = game.hero(0).$data.__proto__.MoveSpeed;

    //循环装备
    for(let te in combatant.$equipment) {
        //跳过为空的
        if(!combatant.$equipment[te])
            continue;

        //let goodsInfo = game.$sys.getGoodsResource(combatant.$equipment[te].$rid);
        //计算新属性
        if(combatant.$equipment[te].$equipEffectAlgorithm)
            combatant.$equipment[te].$equipEffectAlgorithm(combatant.$equipment[te], combatant);


        //这里可以添加判断相关套装和增加的额外属性代码


        //行走速度改变示例代码2/3
        if(combatant.$index === 0 && combatant.$equipment[te].行走速度)
            行走速度 += combatant.$equipment[te].行走速度;

    }

    //行走速度改变示例代码3/3
    if(combatant.$index === 0 && game.hero(0))
        //game.hero(0, {$speed: 行走速度});
        game.hero(0).$$speed = 行走速度;



    //遍历所有的buff
    if(combatant.$$fightData && combatant.$$fightData.$buffs) {
        let buffs = combatant.$$fightData.$buffs;
        for(let tbuffsIndex in buffs) {
            let tbuff = buffs[tbuffsIndex];

            if(tbuff.buffPropertiesEffect) {
                tbuff.buffPropertiesEffect(combatant, tbuff);
            }
        }
    }



    //越界调整
    (combatant.$$propertiesWithExtra.HP[1] > combatant.$$propertiesWithExtra.HP[2]) ? combatant.$$propertiesWithExtra.HP[1] = combatant.$$propertiesWithExtra.HP[2] : null;
    (combatant.$$propertiesWithExtra.HP[0] > combatant.$$propertiesWithExtra.HP[1]) ? combatant.$$propertiesWithExtra.HP[0] = combatant.$$propertiesWithExtra.HP[1] : null;
    (combatant.$$propertiesWithExtra.MP[0] > combatant.$$propertiesWithExtra.MP[1]) ? combatant.$$propertiesWithExtra.MP[0] = combatant.$$propertiesWithExtra.MP[1] : null;



    //console.debug('combatant.$$propertiesWithExtra', combatant, combatant.$$fightData, combatant.$$propertiesWithExtra);

    return combatant.$$propertiesWithExtra;
}

//战斗人物是否可用（上场且活着）
function $combatantIsValid(combatant) {
    if(combatant.$$fightData.$info && combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0)
        return true;
    return false;
}



//游戏结束脚本
function *$gameOverScript(params) {
    if(params === -1) {
        yield game.msg('游戏结束', 60, '', 0, 0b11);
        yield* game.$sys.release(false);
        //yield* game.$sys.init(true, false);
        game.run(function*(){yield* game.$sys.init(true, false);}, {Priority: -2, Type: 0, Running: 0, Tips: '$gameOverScript'});
    }

    return null;
}



//通用逃跑算法（目前是整体逃跑，所以 index为 -1）
function $commonRunAwayAlgorithm(team, index) {
    return game.$globalLibraryJS.randTarget(1,2);
}


//一个战斗回合内，返回每次回合的战斗人物数组
//返回数字表示延迟多久ms再继续
//返回null表示战斗回合结束
function *$fightRolesRound(round) {
    //使用按某属性的比率来进行战斗人物回合（取消了大回合和回合事件）
    //yield* game.$gameMakerGlobalJS.fightRolesRound1(round, '$speed');


    //所有的战斗人物
    let arrTempLoopedAllFightRoles = fight.myCombatants.concat(fight.enemies);

    //计算 攻击 顺序
    arrTempLoopedAllFightRoles.sort(function(a, b) {
        if(a.$$propertiesWithExtra.speed > b.$$propertiesWithExtra.speed)return -1;
        if(a.$$propertiesWithExtra.speed < b.$$propertiesWithExtra.speed)return 1;
        if(a.$$propertiesWithExtra.speed === b.$$propertiesWithExtra.speed)return 0;
    });
    //console.debug('all', arrTempLoopedAllFightRoles.length, JSON.stringify(arrTempLoopedAllFightRoles));


    //循环每个战斗人物
    for(let c of arrTempLoopedAllFightRoles) {
        //如果在场且HP[0] > 0，则进行战斗人物回合
        if(c.$$fightData.$info.$index >= 0 && c.$$propertiesWithExtra.HP[0] > 0)
            yield [c];
    }

    //战斗回合结束
    return null;
}


//战斗技能算法（可以实现其他功能并返回一个值，比如显示战斗文字、返回通用伤害值等）
function $fightSkillAlgorithm(combatant, targetCombatant, Params) {
    //if(!Params)
    //    return;
    //if(Params.Skill === 0)
    //    return;

    //let role1 = combatant;
    //let role2 = targetCombatant;
    //let role1Props = $computeCombatantPropertiesWithExtra(role1);
    //let role2Props = $computeCombatantPropertiesWithExtra(role2);
    let combatant1Props = combatant.$$propertiesWithExtra;
    let combatant2Props = targetCombatant.$$propertiesWithExtra;
    let skill = combatant.$$fightData.$choice.$attack;
    //let skill2 = targetCombatant.$$fightData.$choice.$attack;

    //这里可以用：combatant.属性('血量'),、targetCombatant.附加属性('防御')  这些中文来编程
    //属性表示人物原来属性，附加属性表示人物加上装备和Buff的某个最终属性



    //伤害
    let harm, t;

    if(game.$globalLibraryJS.randTarget(combatant2Props.luck / 5 + combatant2Props.speed / 5)) {  //miss各占%20
        return [{'HP': [0, 0], Target: targetCombatant}];
    }

    //计算攻击：攻击-防御
    harm = combatant1Props.attack - combatant2Props.defense;


    t = combatant1Props.attack;
    t = t * game.$globalLibraryJS.random(combatant1Props.power, combatant1Props.power*2) / 1000; //灵力1~2倍 //攻击+灵力效果
    harm = harm + t;
    t = combatant1Props.attack;
    t = t * game.$globalLibraryJS.random(10, combatant1Props.luck/10+1) / 1000 ; //吉运效果 千分之一到十分之一
    harm = harm + t;
    t = combatant2Props.defense;
    t = t * game.$globalLibraryJS.random(combatant2Props.power/2, combatant2Props.power) / 1000; //防御+灵力效果
    harm = harm - t;
    t = combatant2Props.defense;
    t = t * game.$globalLibraryJS.random(10, combatant2Props.luck/10+1) / 1000; //吉运效果
    harm = harm - t;


    harm = Math.floor(harm);
    if(harm <= 0)harm = game.$globalLibraryJS.random(0, 10);

    //targetCombatant.$properties.healthHP -= Math.floor(harm / 4);
    //targetCombatant.$properties.remainHP -= harm;

    //console.debug('damage1');
    return [{'HP': [harm, Math.floor(harm / 4)], Target: targetCombatant}];
}



//战斗人物选择技能或道具算法（战斗人物回合开始时调用，对我方使用的技能进行检测，对敌方使用的技能进行算法使用）；
//返回倒序使用的技能数组；
//返回true表示不做 技能或道具的 使用和检查处理（比如乱）；
function $fightRoleChoiceSkillsOrGoodsAlgorithm(combatant) {
    let useSkillsOrGoods = [];

    let buffFlags = 0;
    let buffs = combatant.$$fightData.$buffs;
    for(let tbuffsIndex in buffs) {
        let tbuff = buffs[tbuffsIndex];
        //乱
        if(tbuff.flags & 0b0100) {
            buffFlags |= 0b0100;
            return true;
        }
        //封
        if(tbuff.flags & 0b0010) {
            buffFlags |= 0b0010;
        }
    }



    //我方
    if(combatant.$$fightData.$info.$teamsID[0] === 0) {
        //检查技能

        //所有普通技能作为备选
        useSkillsOrGoods = fight.$sys.getCombatantSkills(combatant, [0])[1];

        //普通攻击或技能
        if(combatant.$$fightData.$choice.$type === 3) {
            //如果被封
            if(buffFlags & 0b0010)
                return useSkillsOrGoods;


            //判断技能是否可用，不能用则 $choice.$type = -2 随机选择
            do {
                //是否有这个技能
                let bFind = false;
                let allSkills = fight.$sys.getCombatantSkills(combatant)[1];
                for(let ts of allSkills) {
                    if(ts.$rid === combatant.$$fightData.$choice.$attack.$rid) {
                        bFind = true;
                        break;
                    }
                }
                //如果没这个技能，则不能用
                //if(!game.skill(combatant, combatant.$$fightData.$choice.$attack))
                if(!bFind)
                    break;

                //如果技能可用
                //不是 普通技能，放在最后（第一次进行使用判断）
                //if(combatant.$$fightData.$choice.$attack.$type !== 0)
                    useSkillsOrGoods.push(combatant.$$fightData.$choice.$attack);

            } while(0);

        }
        //道具
        else if(combatant.$$fightData.$choice.$type === 2) {

            //判断道具是否可用，不能用则 $choice.$type = -2 随机选择
            let goods = combatant.$$fightData.$choice.$attack;
            //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
            do {
                //如果没这个道具，则不能用
                if(!game.goods(goods))
                    break;

                //如果道具可用
                //放在最后
                useSkillsOrGoods.push(combatant.$$fightData.$choice.$attack);

            } while(0);
        }
        //其他类型（-1和-2）
        else {
            combatant.$$fightData.$choice.$type = -2;
            //combatant.$$fightData.$choice.$attack = -1;
            //console.warn('[!CommonScriptEditor]', combatant.$$fightData.$choice.$type)
        }

    }

    //敌人
    else if(combatant.$$fightData.$info.$teamsID[0] === 1) {
        //敌人 选择技能
        //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击：OK

        //如果被封
        if(buffFlags & 0b0010)
            return game.$globalLibraryJS.disorderArray(fight.$sys.getCombatantSkills(combatant, [0])[1]);


        //返回打乱后的所有技能
        useSkillsOrGoods = game.$globalLibraryJS.disorderArray(fight.$sys.getCombatantSkills(combatant, [0, 1])[1]);


        //普通攻击或技能或道具（敌人被乱？？？）；鹰：感觉这句没用，像是如果选择了按上次的选择来
        if(combatant.$$fightData.$choice.$type === 3 || combatant.$$fightData.$choice.$type === 2) {
            useSkillsOrGoods.push(combatant.$$fightData.$choice.$attack);
        }
    }

    return useSkillsOrGoods;
}



//combatant获得Buff
//buffCode：12345分别表示 毒乱封眠 属性，params是参数；
//  buffCode：
//    1毒：params有BuffName、Round、HarmType（1为直接减harmValue，2为剩余HP的harmValue倍）、HarmValue、Flags；
//    2乱、3封、4眠：BuffName、Round、Flags；
//    5属性：BuffName、Round、Properties、Flags；
//        Properties：[属性名, 值, type]：Type为0表示相加，Type为1表示 与属性相乘；
//      Flags：实质是决定什么时候运行脚本（见combatantRoundEffects），可表示 毒乱封眠属性 类型，也可以表示 buff类型；
//          比如 毒 是回合开始前执行 buffScript，乱封眠 是 combatant 行动前执行 buffScript。
//  params：
//      BuffName：存储的 Buff 名称，如果不同则插入，如果相同则会覆盖；
//      Override表示是否覆盖（如果不覆盖，则 Buff名 后加时间戳来防止重复），注意Properties的Buff是1个，如果需要按属性类型来覆盖，得自己定义BuffName；
function getBuff(combatant, buffCode, params={}) {
    let buffNameKey;
    let override = params.Override ?? true;
    let round = params.Round || 5;
    let flags = params.Flags;

    switch(buffCode) {
    //毒
    case 1:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Poison';
        buffNameKey = params.BuffName;
        if(!override)
            buffNameKey += new Date().getTime();

        combatant.$$fightData.$buffs[buffNameKey] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffScript: function*(combatant, objBuff) {
                //结算
                let harm = 10;
                //伤害类型：直接减
                if(params.HarmType === 1) {
                    harm = params.HarmValue;
                }
                //伤害类型：剩余HP的多少倍
                else if(params.HarmType === 2) {
                    harm = combatant.$$propertiesWithExtra.HP[0] * params.HarmValue;
                }
                harm = Math.round(harm);

                game.addprops(combatant, {'HP': [-harm, -Math.floor(harm / 4)]});
                //刷新人物信息
                yield ({Type: 1});
                //显示伤害血量
                yield ({Type: 30, Interval: 0, Color: 'green', Text: params.BuffName + (-harm), FontSize: 20, Combatant: combatant, Position: undefined});
            },
            //标记（毒乱封眠 类型，也可以表示buff名，其实就是决定什么时候运行脚本）
            flags: flags || 0b1000,
            //buff属性效果（只有属性buff有）
            buffPropertiesEffect: false,    //function (combatant, objBuff){}
        }
        break;

    //乱
    case 2:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Confusion';
        buffNameKey = params.BuffName;
        if(!override)
            buffNameKey += new Date().getTime();

        combatant.$$fightData.$buffs[buffNameKey] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffScript: function*(combatant, objBuff) {
                //技能为普通攻击的第一个
                let skills = fight.$sys.getCombatantSkills(combatant, [0], 0b1)[1];
                combatant.$$fightData.$choice.$type = 3;
                combatant.$$fightData.$choice.$attack = skills[0];
                //目标为自己
                combatant.$$fightData.$choice.$targets = [[combatant]];

                //显示
                yield ({Type: 30, Interval: 0, Color: 'yellow', Text: params.BuffName, FontSize: 20, Combatant: combatant, Position: undefined});
            },
            //标记（毒乱封眠 类型，也可以表示buff名，其实就是决定什么时候运行脚本）
            flags: flags || 0b0100,
            //buff属性效果（只有属性buff有）
            buffPropertiesEffect: false,    //function (combatant, objBuff){}
        }
        break;

    //封
    case 3:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Sealing';
        buffNameKey = params.BuffName;
        if(!override)
            buffNameKey += new Date().getTime();

        combatant.$$fightData.$buffs[buffNameKey] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffScript: function*(combatant, objBuff) {
                //技能为 普通攻击 的最后一个
                //let skills = fight.$sys.getCombatantSkills(combatant, [0])[1];
                //combatant.$$fightData.$choice.$type = 3;
                //combatant.$$fightData.$choice.$attack = skills.pop();
                //combatant.$$fightData.$choice.$targets = undefined;

                //显示
                yield ({Type: 30, Interval: 0, Color: 'yellow', Text: params.BuffName, FontSize: 20, Combatant: combatant, Position: undefined});
            },
            //标记（毒乱封眠 类型，也可以表示buff名，其实就是决定什么时候运行脚本）
            flags: flags || 0b0010,
            //buff属性效果（只有属性buff有）
            buffPropertiesEffect: false,    //function (combatant, objBuff){}
        }
        break;

    //眠
    case 4:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Sleep';
        buffNameKey = params.BuffName;
        if(!override)
            buffNameKey += new Date().getTime();

        combatant.$$fightData.$buffs[buffNameKey] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffScript: function*(combatant, objBuff) {
                $fightCombatantSetChoice(combatant, 1, false);
                ///combatant.$$fightData.$choice.$type = 1;
                ////combatant.$$fightData.$choice.$targets = -2;

                //显示
                yield ({Type: 30, Interval: 0, Color: 'yellow', Text: params.BuffName, FontSize: 20, Combatant: combatant, Position: undefined});
            },
            //标记（毒乱封眠 类型，也可以表示buff名，其实就是决定什么时候运行脚本）
            flags: flags || 0b0001,
            //buff属性效果（只有属性buff有）
            buffPropertiesEffect: false,    //function (combatant, objBuff){}
        }
        break;

    //属性
    case 5:
    default:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Properties';
        buffNameKey = params.BuffName;
        if(!override)
            buffNameKey += new Date().getTime();

        combatant.$$fightData.$buffs[buffNameKey] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffScript: function*(combatant, objBuff) {

                //显示
                yield ({Type: 30, Interval: 0, Color: 'yellow', Text: params.BuffName, FontSize: 20, Combatant: combatant, Position: undefined});
            },
            //标记（毒乱封眠 类型，也可以表示buff名，其实就是决定什么时候运行脚本）
            flags: flags || 0b10000,
            //buff属性效果（只有属性buff有）
            buffPropertiesEffect: function (combatant, objBuff) {
                let properties = combatant.$properties;
                let propertiesWithExtra = combatant.$$propertiesWithExtra;
                for(let tp of params.Properties) {
                    //如果提升值为百分之
                    if(tp[2] === 2)
                        propertiesWithExtra[tp[0]] += (properties[tp[0]] * tp[1]);
                    //直接加
                    //if(tp[2] === 1)
                    else
                        propertiesWithExtra[tp[0]] += tp[1];
                }
            }
        }
        break;
    }

    fight.$sys.refreshCombatant(combatant);
}



//每个战斗人物（我方、敌方）的回合脚本；
//round为回合数；
//stage：0为回合开始前；1为战斗人物行动前(我方选择完毕）；2为战斗人物行动前（我方和敌方选择和验证完毕）；3为战斗人物行动后；
//返回null表示跳过回合（stage为1时有效）
function $combatantRoundScript(combatant, round, stage) {
    switch(stage) {
    case 0:
        //跳过下场 的或 没血的
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            $fightCombatantSetChoice(combatant, 1, false);
            ///combatant.$$fightData.$choice.$type = 1;

            //去掉，则死亡后仍然有buff效果
            return null;
        }
        break;
    case 1:
        //跳过下场 的或 没血的
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            $fightCombatantSetChoice(combatant, 1, false);
            ///combatant.$$fightData.$choice.$type = 1;

            //去掉，则死亡后仍然有buff效果
            return null;
        }
        break;
    case 2:
        //跳过下场 的或 没血的
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            $fightCombatantSetChoice(combatant, 1, false);
            ///combatant.$$fightData.$choice.$type = 1;

            //去掉，则死亡后仍然有buff效果
            return null;
        }
        break;
    case 3:
        //跳过下场 的或 没血的
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            $fightCombatantSetChoice(combatant, 1, false);
            ///combatant.$$fightData.$choice.$type = 1;

            //去掉，则死亡后仍然有buff效果
            return null;
        }
        //如果没有回合，则加这句清空此次的战斗选择数据
        //else
        //    $fightCombatantSetChoice(combatant, -1, false);
        //    //fight.$sys.loadLast(combatant);
        break;
    }


    return combatantRoundEffects(combatant, round, stage);
}

//战斗人物回合脚本（主要是剧情和Buff）；
//参数同 $combatantRoundScript；
function *combatantRoundEffects(combatant, round, stage) {
    /*/可以加一些东西，比如加气血等
    if(stage === 1) {
        game.addprops(combatant, {'HP,0': 10, 'MP,0': 10});
    }
    */

    let buffs = combatant.$$fightData.$buffs;
    /*if(buffs['$$Sleep']) {
        return {success: false, msg: '你已经被[眠]'};
    }

    if(buffs['$$Sealing'] && fightSkillData.$type === 1) {
        return {success: false, msg: '你已经被[封]'};
    }

    if(buffs['$$Confusion']) {
        return {success: false, msg: '你已经被[乱]', change: {skill: 0b01, target: [[team1, team2], [-1, -1]]}};
    }*/


    //遍历所有的buff，每个-1回合
    for(let tbuffsIndex in buffs) {
        let tbuff = buffs[tbuffsIndex];



        //如果是 毒乱封眠（毒在 回合开始前 运行，乱封眠 在 行动开始前运行）

        //毒
        if(tbuff.flags & 0b1000) {
            if(stage === 0) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffScript) {
                    --tbuff.round;

                    //毒 的 方法和参数
                    yield* tbuff.buffScript(combatant, tbuff);
                }
            }
        }
        //乱
        if(tbuff.flags & 0b0100) {
            if(stage === 2) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffScript) {
                    //乱 的 方法和参数
                    yield* tbuff.buffScript(combatant, tbuff);
                }
            }
            else if(stage === 3)
                --tbuff.round;
        }
        //封
        if(tbuff.flags & 0b0010) {
            if(stage === 2) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffScript) {
                    //封 的 方法和参数
                    yield* tbuff.buffScript(combatant, tbuff);
                }
            }
            else if(stage === 3)
                --tbuff.round;
        }
        //眠
        if(tbuff.flags & 0b0001) {
            if(stage === 1) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffScript) {
                    //眠 的 方法和参数
                    yield* tbuff.buffScript(combatant, tbuff);
                }
            }
            else if(stage === 3)
                --tbuff.round;
        }
        //其他
        if(tbuff.flags & 0b10000) {
            if(stage === 2) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffScript) {
                    //其他 的 方法和参数
                    yield* tbuff.buffScript(combatant, tbuff);
                }
            }
            else if(stage === 3)
                --tbuff.round;
        }



        //回合-1
        //if(stage === 0)
        //    --tbuff.round;
        //如果完毕，删除
        if(tbuff.round <= 0) {
            delete buffs[tbuffsIndex]; //删除
        }
    }

    return null;
}



//检查技能、道具是否可在战斗中使用（有4个阶段会调用：见stage）；
//返回：true表示可以使用；字符串和数组表示不能使用并提示的信息（只有选择时）；
//stage为0表示我方刚选择技能时，为1表示我方选择技能的步骤完毕，为10表示战斗中我方或敌方刚选择技能时，为11表示战斗中我方或敌方选择技能的步骤完毕（可在阶段11减去MP，道具的技能可单独设置）；
//会检测技能、道具的相关函数并调用返回；
function $commonCheckSkill(fightSkillOrGoods, combatant, stage) {
    let choiceType = combatant.$$fightData.$choice.$type;//choiceType为3、2分别表示使用技能和道具（此时相应的fightSkill也为道具）；
    //let targetCombatants = combatant.$$fightData.$choice.$targets[0];
    let goods = null;
    let fightSkill = null;

    //如果选择的是技能
    if(choiceType === 3) {
        fightSkill = fightSkillOrGoods;
        //skill = combatant.$$fightData.$choice.$attack;
    }
    //如果选择的是道具
    else if(choiceType === 2) {
        goods = fightSkillOrGoods;
        fightSkill = fightSkillOrGoods.$fight[0];
    }


    let buffs = combatant.$$fightData.$buffs;
    /*if(buffs['$$Sleep']) {
        return 你已经被[眠]';
    }

    if(buffs['$$Sealing'] && fightSkill.$type === 1) {
        return '你已经被[封]';
    }

    if(buffs['$$Confusion']) {
        return '你已经被[乱]';
    }*/


    //遍历所有的buff
    for(let tbuffsIndex in buffs) {
        let tbuff = buffs[tbuffsIndex];
        //如果是 毒乱封眠
        if(tbuff.flags & 0b0001) {
            //if(stage === 1)
                return '你已经被[眠]';
        }
        else if((tbuff.flags & 0b0010) && choiceType === 3 && fightSkill.$type === 1) {   //选择的是 技能
            return '你已经被[封]';
        }
        else if(tbuff.flags & 0b0100) {
            if((stage === 0 || stage === 1) && fightSkill.$type === 1)   //只能选择 普通攻击
                return '你已经被[乱]';
        }
    }


    //使用技能的check
    let useSkillCheck = false;
    //如果选择的是道具
    if(choiceType === 2) {
        //如果都有定义
        if(game.$globalLibraryJS.isObject(goods.$fightScript) && goods.$fightScript.$check !== undefined) {
            if(game.$globalLibraryJS.isFunction(goods.$fightScript.$check)) {
                return goods.$fightScript.$check(goods, combatant, stage);
            }
            else
                return goods.$fightScript.$check;
        }
        //!!兼容旧代码
        else if(game.$globalLibraryJS.isArray(goods.$fightScript) && goods.$fightScript[1] !== undefined) {
            if(game.$globalLibraryJS.isFunction(goods.$fightScript[1])) {
                return goods.$fightScript[1](goods, combatant, stage);
            }
            else
                return goods.$fightScript[1];
        }
        //没定义，则按skill的check来
        else if(fightSkill)
            useSkillCheck = true;
        else
            return undefined;

    }
    //如果选择的是技能
    if(useSkillCheck || choiceType === 3) {
        if(game.$globalLibraryJS.isFunction(fightSkill.$check)) {
            return fightSkill.$check(fightSkill, combatant, stage);
        }
        else
            return fightSkill.$check;
    }
    else
        console.warn('[!CommonScriptEditor]commonCheckSkill:', choiceType);

    //return true;
}



//检测是否战斗完毕，扫描所有战斗角色并将死亡角色隐藏；
//返回：0为没有结束；1为胜利；-1为失败；
function $checkAllCombatants(myCombatants, myCombatantsComp, enemies, enemiesComp) {

    let nFlags = 0;

    for(let ti in myCombatants) {
        if(myCombatants[ti].$$fightData.$info.$index >= 0 && myCombatants[ti].$$propertiesWithExtra.HP[0] > 0) {
            nFlags |= 0b1;
            //break;
        }
        else {
            myCombatantsComp.itemAt(ti).opacity = 0.5;
            //repeaterMyCombatants.itemAt(ti).visible = false;
        }
    }


    let totalEXP = 0;
    let totalMoney = 0;
    let totalGoods = [];

    for(let ti in enemies) {
        if(enemies[ti].$$fightData.$info.$index >= 0 && enemies[ti].$$propertiesWithExtra.HP[0] > 0) {
            nFlags |= 0b10;
            //break;
        }
        else {
            //隐藏
            enemiesComp.itemAt(ti).opacity = 0;
            //repeaterEnemies.itemAt(ti).visible = false;

            //计算经验、金钱 和 道具
            totalEXP += enemies[ti].$EXP || 0;
            totalMoney += parseInt(enemies[ti].$money || 0);
            if(enemies[ti].$goods) {
                for(let goods of enemies[ti].$goods) {
                    /*let g;
                    if(game.$globalLibraryJS.isObject(teq)) { //如果直接是对象
                        g = {$rid: teq.RID};
                        game.$globalLibraryJS.copyPropertiesToObject(g, game.$sys.getGoodsResource(teq.RID).$properties);
                        game.$globalLibraryJS.copyPropertiesToObject(g, teq);
                    }
                    else if(game.$globalLibraryJS.isString(teq)) { //
                        g = {$rid: teq};
                        game.$globalLibraryJS.copyPropertiesToObject(g, game.$sys.getGoodsResource(teq).$properties);
                    }*/
                    totalGoods.push(goods);
                }
                //totalGoods.push(...enemies[ti].$goods);
            }
            //for(let teq in enemies[ti].$equipment) {
            //    totalGoods.push(enemies[ti].$equipment[teq]);
            //}
        }
    }
    let result;

    if((nFlags & 0b10) === 0)
        result = 1;
    else if((nFlags & 0b1) === 0)
        result = -1;
    else
        result = 0;

    return {result: result, exp: totalEXP, money: totalMoney, goods: totalGoods};
}


//下面4个函数的teams：teams[0]表示我方队伍，teams[1]表示敌方队伍

//战斗初始化脚本；
function *$commonFightInitScript(teams, fightData) {

    //game.pause('$fight');
    //game.stage(1);


    if(fightData.$backgroundImage) {
        fight.background(fightData.$backgroundImage);
    }

    if(fightData.$music === true) {
    }
    else if(game.$globalLibraryJS.isString(fightData.$music)) {
        game.pushmusic();
        game.playmusic(fightData.$music);
    }
    else {
        game.pushmusic();
    }


    /*/选择上场战斗人物代码

    //我方最多上场人数
    let maxCount = -1;
    //临时存放到myCombatants
    let myCombatants = [...teams[0]];
    teams[0].length = 0;
    //循环选择
    while(1) {
        //选择列表
        let arrList = [];
        if(teams[0].length === 0)
            arrList.push('全部');
        else
            arrList.push('取消');
        //剩下的每个名字
        for(let tc of myCombatants) {
            arrList.push(tc.$name);
        }
        let c = yield fight.menu('请选择战斗角色', arrList);
        //选择全部 或 取消
        if(c === 0) {
            //全部
            if(teams[0].length === 0) {
                if(maxCount <= 0)
                    teams[0].push(...myCombatants);
                else
                    teams[0].push(...myCombatants.splice(0, maxCount));
            }
            break;
        }
        else {
            teams[0].push(...myCombatants.splice(c - 1, 1));
        }
        //选空了
        if(myCombatants.length === 0)
            break;
        if(maxCount > 0 && teams[0].length >= maxCount)
            break;
    }*/



    yield fight.msg('通用战斗初始化事件', 0, '', 500);


    let fightInitScript = fightData.$commons.$fightInitScript/* || fightData.$commons.FightInitScript*/;
    if(fightInitScript) {
        let r = fightInitScript(teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightInitScript(teams, fightData) ?? null, {Priority: -2, Tips: 'fight init2'});
    }

    //if('FightInitScript' in fightData)
    if(Object.keys(fightData).indexOf('FightInitScript') >= 0) {
        let r = fightData.FightInitScript(teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightData.FightInitScript(teams, fightData) ?? null, {Priority: -2, Tips: 'fight init3'});
    }


    return null;
}

//战斗开始通用脚本；
function *$commonFightStartScript(teams, fightData) {
    //let game = this.game;
    //let fight = this.fight;

    yield fight.msg('战斗开始通用脚本', 0, '', 500);



    //战斗开始脚本
    let fightStartScript = fightData.$commons.$fightStartScript/* || fightData.$commons.FightStartScript*/;
    if(fightStartScript) {
        let r = fightStartScript(teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightStartScript(teams, fightData) ?? null, {Priority: -2, Tips: 'fight start2'});
    }

    //fighting战斗的回调函数
    //if('FightStartScript' in fightData)
    if(Object.keys(fightData).indexOf('FightStartScript') >= 0) {
        let r = fightData.FightStartScript(teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightData.FightStartScript(teams, fightData) ?? null, {Priority: -2, Tips: 'fight start3'});
    }


    return null;
}

//战斗回合通用脚本；
//step：0，回合开始；1，选择完毕
//team：0下标为我方，1下标为敌方
function *$commonFightRoundScript(round, step, teams, fightData) {
    //let game = this.game;
    //let fight = this.fight;


    /*/战斗回合脚本
    let fightRoundScript = fightData.$commons.$fightRoundScript/* || fightData.$commons.FightRoundScript* /;
    if(fightRoundScript) {
        let r = fightRoundScript(round, step, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightRoundScript(round, step, teams, fightData) ?? null, {Priority: -2, Tips: 'fight round2:' + step});
    }

    //fighting战斗的回调函数
    //if('FightRoundScript' in fightData)
    if(Object.keys(fightData).indexOf('FightRoundScript') >= 0) {
        let r = fightData.FightRoundScript(round, step, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightData.FightRoundScript(round, step, teams, fightData) ?? null, {Priority: -2, Tips: 'fight round3:' + step});
    }
    */



    switch(step) {
    case 0:
        //teams = [...teams[0], ...teams[1]];

        //!!这个是放置类的自动战斗功能代码
        if(fight.$sys.autoAttack() === 1) {
            //自动重复上次类型，也可以根据需要改写
            fight.$sys.loadLast();
            /*game.$globalLibraryJS.runNextEventLoop(function() {
                    fight.$sys.continueFight();
                },
            );*/
        }



        yield fight.msg('战斗回合通用脚本' + round, 0, '', 500);
        break;
    case 1:
        break;
    }



    //战斗回合脚本
    let fightRoundScript = fightData.$commons.$fightRoundScript/* || fightData.$commons.FightRoundScript*/;
    if(fightRoundScript) {
        let r = fightRoundScript(round, step, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightRoundScript(round, step, teams, fightData) ?? null, {Priority: -2, Tips: 'fight round2:' + step});
    }

    //fighting战斗的回调函数
    //if('FightRoundScript' in fightData)
    if(Object.keys(fightData).indexOf('FightRoundScript') >= 0) {
        let r = fightData.FightRoundScript(round, step, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightData.FightRoundScript(round, step, teams, fightData) ?? null, {Priority: -2, Tips: 'fight round3:' + step});
    }


    return null;
}

//战斗结束通用脚本；
//res中包含：result（战斗结果（0平1胜-1败-2逃跑））、money、exp、goods
function *$commonFightEndScript(res, teams, fightData) {
    //这里的res，可能会被 战斗脚本修改
    //res中包含：result（战斗结果）、money和exp

    //let game = this.game;
    //let fight = this.fight;


    //战斗结束脚本1
    let fightEndScript = fightData.$commons.$fightEndScript/* || fightData.$commons.FightEndScript*/;
    if(fightEndScript) {
        let r = fightEndScript(res, 0, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightEndScript(res, 0, teams, fightData) ?? null, {Priority: -2, Tips: 'fight end20'});
    }

    //fighting战斗的回调函数
    //if('FightEndScript' in fightData)
    if(Object.keys(fightData).indexOf('FightEndScript') >= 0) {
        let r = fightData.FightEndScript(res, 0, teams, fightData);
        if(game.$globalLibraryJS.isGenerator(r))yield* r;
        //yield fight.run(fightData.FightEndScript(res, 0, teams, fightData) ?? null, {Priority: -2, Tips: 'fight end30'});
    }



    let bGetGoods = false;
    let msgGoods = '获得道具：';
    for(let t of res.goods) {
        if(game.rnd(0,100) < 60) {
            msgGoods += ('<BR>' + t.$name);
            game.getgoods(t, 1);
            bGetGoods = true;
        }
    }

    game.money(res.money);


    if(res.result === 1) {
        yield fight.msg('战斗胜利<BR>获得  %1经验，%2金钱'.arg(res.exp).arg(res.money));
    }
    else if(res.result === -1) {
        yield fight.msg('战斗失败<BR>获得  %1经验，%2金钱'.arg(res.exp).arg(res.money));
    }
    if(bGetGoods)
        yield fight.msg(msgGoods);


    if(fightData.$music === true) {
    }
    else if(game.$globalLibraryJS.isString(fightData.$music)) {
        game.popmusic();
    }
    else {
        game.popmusic();
    }



    //返回地图代码
    game.run(function*() {
        fight.over();


        //战斗结束脚本2
        if(fightEndScript) {
            let r = fightEndScript(res, 1, teams, fightData);
            if(game.$globalLibraryJS.isGenerator(r))yield* r;
            //game.run(fightEndScript, {Tips: 'fight end21'}, res, 1, teams, fightData);
        }

        //fighting战斗的回调函数
        //if('FightEndScript' in fightData)
        if(Object.keys(fightData).indexOf('FightEndScript') >= 0) {
            let r = fightData.FightEndScript(res, 1, teams, fightData);
            if(game.$globalLibraryJS.isGenerator(r))yield* r;
            //game.run(fightData.FightEndScript, {Tips: 'fight end31'}, res, 1, teams, fightData);
        }


        //增加经验
        for(let tc of fight.myCombatants) {
            //fight.myCombatants[t].$properties.EXP += res.exp;
            game.addprops(tc, {'EXP': res.exp});

            /*/将血量设置为1
            if(tc.$properties.HP[1] <= 0)
                tc.$properties.HP[1] = 1;
            if(tc.$properties.HP[0] <= 0)
                tc.$properties.HP[0] = 1;
            */

            //去掉buffs
            //tc.$$fightData.$buffs = {};
        }


        if(res.result === -1)
            yield game.gameover(-1);

        //game.stage(0);
        //game.goon('$fight');

        return null;
    }());

    //console.debug(JSON.stringify(res), res.exp, res.money);


    return null;
}



//获取 某战斗角色 中心位置
//teamID、index是战斗角色的；
function $fightCombatantPositionAlgorithm(teamID, index) {
    //let teamID = combatant.$$fightData.$info.$teamsID[0];
    //let index = combatant.$$fightData.$info.$index;

    //cols表示有几列（战场分布）；
    if(index === -1) {    //全体时的位置
        let cols = 3;
        if(teamID === 0)    //我方
            return Qt.point(fight.$sys.scene.width / cols, fight.$sys.scene.height / 2);
        else    //敌方
            return Qt.point(fight.$sys.scene.width * (cols-1) / cols, fight.$sys.scene.height / 2);
    }

    //单个人物位置
    //默认：/我方所有x坐标 = 屏幕宽 / 4。我方a的y坐标 = 屏幕高 * (a+1) / (我方人数+1)。
    let cols = 4;
    if(teamID === 0) {    //我方
        return Qt.point(fight.$sys.scene.width / cols, fight.$sys.scene.height * (index + 1) / (fight.myCombatants.length/*fight.$sys.components.spriteEffectMyCombatants.nCount*/ + 1));
    }
    else {  //敌方
        return Qt.point(fight.$sys.scene.width * (cols-1) / cols, fight.$sys.scene.height * (index + 1) / (fight.enemies.length/*fight.$sys.components.spriteEffectEnemies.nCount*/ + 1));
    }
}

//战斗角色近战 坐标
function $fightCombatantMeleePositionAlgorithm(combatant, targetCombatant) {
    let combatantComp = combatant.$$fightData.$info.$comp;
    let targetCombatantComp = targetCombatant.$$fightData.$info.$comp;

    //x偏移（targetCombatant的左或右边）
    let tx = combatantComp.x < targetCombatantComp.x ? -combatantComp.width : combatantComp.width;
    let position = combatantComp.mapFromItem(targetCombatantComp, tx, 0);

    return Qt.point(position.x + combatantComp.x, position.y + combatantComp.y);
}
//特效在战斗角色的 坐标
function $fightSkillMeleePositionAlgorithm(combatant, spriteEffect) {
    let combatantComp = combatant.$$fightData.$info.$comp;

    //x偏移（spriteEffect的左或右边）
    let tx = spriteEffect.x < combatantComp.x ? -spriteEffect.width : spriteEffect.width;
    let position = spriteEffect.mapFromItem(combatantComp, tx, 0);

    return Qt.point(position.x + spriteEffect.x, position.y + spriteEffect.y);
}


//设置 战斗人物的 初始化 或 休息
function $fightCombatantSetChoice(combatant, type, bSaveLast) {
    switch(type) {
    case -1:    //未选择
        combatant.$$fightData.$choice.$type = -1;
        combatant.$$fightData.$choice.$attack = undefined;
        combatant.$$fightData.$choice.$targets = undefined;
        if(bSaveLast) {
            //fight.$sys.saveLast(combatant);
            combatant.$$fightData.$lastChoice.$type = -1;
            combatant.$$fightData.$lastChoice.$attack = undefined;
            combatant.$$fightData.$lastChoice.$targets = undefined;
        }
        break;
    case 1:     //休息
        combatant.$$fightData.$choice.$type = 1;
        combatant.$$fightData.$choice.$attack = undefined;
        combatant.$$fightData.$choice.$targets = undefined;
        if(bSaveLast) {
            //fight.$sys.saveLast(combatant);
            combatant.$$fightData.$lastChoice.$type = 1;
            combatant.$$fightData.$lastChoice.$attack = undefined;
            combatant.$$fightData.$lastChoice.$targets = undefined;
        }
        break;
    }
}


//战斗菜单
let $fightMenus = {
    $menus: ['普通攻击', '技能', '物品', '信息', '休息'],
    $actions: [
        function(combatantIndex) {
            fight.$sys.showSkillsOrGoods(0, -1);
        },
        function(combatantIndex) {
            fight.$sys.showSkillsOrGoods(1);
        },
        function(combatantIndex) {
            fight.$sys.showSkillsOrGoods(2);
        },
        function(combatantIndex) {
            fight.$sys.showFightRoleInfo(fight.myCombatants[combatantIndex].$index);
        },
        function(combatantIndex) {
            let combatant = fight.myCombatants[combatantIndex];

            $fightCombatantSetChoice(combatant, 1, true);
            ///combatant.$$fightData.$choice.$type = 1;
            //combatant.$$fightData.$choice.$attack = undefined;
            //combatant.$$fightData.$choice.$targets = undefined;
            //combatant.$$fightData.$lastChoice.$type = 1;
            //combatant.$$fightData.$lastChoice.$attack = undefined;
            //combatant.$$fightData.$lastChoice.$targets = undefined;



            fight.$sys.checkToFight();
        },
    ],
};

//战斗按钮
let $fightButtons = [
    {
        $text: '重复上次',
        $colors: ['lightgreen', 'lightblue', 'lightsteelblue'],
        $clicked: function(button) {
            if(fight.$sys.stage() === 2) {
                fight.$sys.resetFightScene();

                fight.$sys.loadLast(true, 0);
                fight.$sys.continueFight();
            }
            else if(fight.$sys.stage() === 3) {
                //return null;
            }

            return null;
        },
        //其他属性
        $properties: {
        },
    },
    {
        $text: '逃跑',
        $colors: ['lightyellow', 'lightblue', 'lightsteelblue'],
        $clicked: function(button) {
            //逃跑次数，0为不逃跑，-1为一直逃跑
            if(fight.$sys.runAwayFlag() === -1) {
                button.text = '逃跑';
                fight.$sys.runAwayFlag(0);
            }
            else {
                button.text = '逃跑中';
                fight.$sys.runAwayFlag(-1);

                if(fight.$sys.stage() === 2) {
                    fight.$sys.resetFightScene();

                    fight.$sys.continueFight();
                }
            }

            return null;
        },
        //其他属性
        $properties: {
        },
    },
    {
        $text: '手动攻击',
        $colors: ['lightgreen', 'lightblue', 'lightsteelblue'],
        $clicked: function(button) {
            if(fight.$sys.autoAttack() === 0) {
                button.text = '自动攻击';
                fight.$sys.autoAttack(1);

                if(fight.$sys.stage() === 2) {
                    fight.$sys.loadLast(true, 1);
                    fight.$sys.continueFight();
                }
            }
            else {
                button.text = '手动攻击';
                fight.$sys.autoAttack(0);
            }

            return null;
        },
        //其他属性
        $properties: {
        },
    },
];



//读取存档信息，返回数组
function $readSavesInfo(count=3) {
    let arrSave = [];
    for(let i = 0; i < count; ++i) {
        let ts = game.checksave('存档' + i);
        if(ts) {
            arrSave.push('%1：%2（%3）'.arg(i).arg(ts.Name).arg(ts.Time));
        }
        else
            arrSave.push('空');
    }
    return arrSave;
}

";


        scriptEditor.init({
            BasePath: path,
            RelativePath: 'common_script.js',
            ChoiceButton: 0b0,
            PathText: 0b0,
            Default: defaultCode,
        });

        scriptEditor.forceActiveFocus();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true

    //color: Global.style.backgroundColor



    ScriptEditor {
        id: scriptEditor

        visible: true
        focus: true
        anchors.fill: parent


        strTitle: '游戏通用算法脚本'
        /*fnAfterCompile: function(code) {return code;}*/

        visualScriptEditor.strTitle: strTitle

        visualScriptEditor.strSearchPath: GameMakerGlobal.config.strProjectRootPath + Platform.sl_separator(true) + GameMakerGlobal.config.strCurrentProjectName
        visualScriptEditor.nLoadType: 1

        visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        visualScriptEditor.defaultCommandTemplate: [{'command':'函数/生成器{','params':['*$start',''],'status':{'enabled':true}},{'command':'块结束}','params':[],'status':{'enabled':true}}]


        onSg_close: function(saved) {
            root.sg_close(saved);
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private
    }



    //Keys.forwardTo: []
    /*Keys.onEscapePressed: {
        _private.close();

        console.debug('[CommonScriptEditor]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[CommonScriptEditor]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[CommonScriptEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[CommonScriptEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[CommonScriptEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[CommonScriptEditor]Component.onDestruction');
    }
    */
}
