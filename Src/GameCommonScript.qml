import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    function init() {

        //读算法

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator +  "common_script.js";
        //let data = File.read(filePath);
        //console.debug("data", filePath, data)

        let data = FrameManager.sl_qml_ReadFile(filePath);
        //data = JSON.parse(data)["FightAlgorithm"];

        if(data) {
            FrameManager.setPlainText(notepadGameFightScriptScript.textDocument, data);
        }
        else {
            FrameManager.setPlainText(notepadGameFightScriptScript.textDocument, "

//注意：game.$globalLibraryJS

//.import 'level_chain.js' as JSLevelChain       //导入另一个js文件
//let jsLevelChain = JSLevelChain;    //让外部可访问



//配置
let $config = {
    //游戏
    $game: {
        $loadAllResources: 0,   //提前载入所有资源
    },
    //地图
    $map: {
        $opacity: 0.6,   //人物遮挡透明度
        $smooth: true,   //缩放是否平滑或点阵
    },
    //角色
    $role: {
        $smooth: true,   //缩放是否平滑或点阵
    },
    //特效
    $spriteEffect: {
        $smooth: true,   //缩放是否平滑或点阵
    },
    //摇杆
    $joystick: {
        //位置
        $left: 6,
        $bottom: 7,
        $size: 20,
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
            $clicked: function*() {
                //if(!game.$globalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return;

                game.$sys.interact();
            },
        },
        {
            $right: 16,
            $bottom: 8,
            $size: 6,
            $color: 'blue',
            $opacity: 0.6,
            $image: '',
            $clicked: function*() {
                //if(!game.$globalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return;

                game.window(1);
                //game.window(1, {MaskColor: '#00000000'});
            },
        },
        {
            $right: 10,
            $bottom: 10,
            $size: 6,
            $color: 'green',

            //按下事件
            $clicked: function*() {
                if(game.pause(null))
                    return;

                yield game.msg('自定义按键');
            },
        },
    ],
    //窗口
    $window: {
        //窗口显示事件
        $show: function(newFlags, windowFlags) {
            //if(newFlags & 0b1)
            //    game.showimage('FightScene2.jpg', {$width: -1, $height: -1}, 'aaa');
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

        $say: {
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 9,
            $fontColor: 'white',
        },
        $talk: {
            $name: true,
            $avatar: true,
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 16,
            $fontColor: 'white',
            $maskColor: 'transparent',
        },
        $msg: {
            $backgroundColor: '#BF6699FF',
            $borderColor: 'white',
            $fontSize: 16,
            $fontColor: 'white',
            $maskColor: '#7FFFFFFF',
            $type: 0b10,
        },
        $menu: {
            $maskColor: '#7FFFFFFF',
            $borderColor: 'white',
            $backgroundColor: '#CF6699FF',
            $itemHeight: 60,
            $titleHeight: 60,
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
            $backgroundColor: '#FFFFFF',
            $borderColor: '#60000000',
            $fontSize: 16,
            $fontColor: 'black',
            $titleBackgroundColor: '#EE00CC99',
            $titleBorderColor: 'white',
            $titleFontSize: 16,
            $titleFontColor: 'white',
            $maskColor: '#7FFFFFFF',
        },
        $fight_menu: {
            $borderColor: 'white',
            $backgroundColor: '#CF6699FF',
            $itemHeight: 60,
            $titleHeight: 60,
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
    //安卓配置
    $android: {
        //屏幕旋转规则
        $orient: 4,
    },
};



//游戏初始化（游戏开始和载入存档时调用）
function *$gameInit() {

    //每秒恢复
    function resumeEventScript(combatant) {

        if(combatant.$$propertiesWithExtra.HP[0] <= 0)
            return;

        game.addprops(combatant, {'HP': [2], 'MP': [2]});
    }

    //每秒恢复事件
    game.addtimer('resume_event', 1000, -1, true);
    game.gf['resume_event'] = function() {
        for(let h in game.gd['$sys_fight_heros']) {
            resumeEventScript(game.gd['$sys_fight_heros'][h]);
        }
    }


    //点击屏幕事件
    game.gf['$map_click'] = function(bx, by, x, y) {
        if(game.hero(0).nActionType !== -1) {
            let rolePos = game.hero(0).pos();
            //简单走
            //game.hero(0, {$action: 2, $targetBx: bx, $targetBy: by});
            //A*算法走
            game.hero(0, {$action: 2, $targetBlocks: game.$gameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [bx, by])});
        }
    }


    yield game.msg('合理安排时间');

    game.goon();

    return true;
}


//存档前调用
function *$beforeSave() {
    //game.gd['save_datetime'] = Date.now();
    return true;
}


//读档前调用
function *$beforeLoad() {
    return true;
}

//存档后调用
function *$afterSave() {
    return true;
}


//读档后调用
function *$afterLoad() {
    return true;
}



//战斗角色
function $Combatant(fightRoleRId, showName) {
    //console.debug('[FightScene]$Combatant');
    if(!fightRoleRId)
        fightRoleRId = '深林孤鹰';
    if(!showName)
        showName = fightRoleRId;


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
    this.$rid = fightRoleRId;
    //this.fightRoleRId = fightRoleRId;

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
            $index: -1,              //所在队伍下标
            $teamsID: [0, 1],         //0：我方；1：敌方；2：友军。下标：己方、对方、友方
            $teams: [],               //保存队伍对象。下标：己方、对方、友方
            $teamsSpriteEffect: [],
            $spriteEffect: null,

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

function 属性(p, n=0) {
    let ret;
    if(game.$globalLibraryJS.isValidNumber(n)) {
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
    if(game.$globalLibraryJS.isValidNumber(n)) {
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

//几种对象的根类

$Combatant.prototype = {$objectType: 1};

$Combatant.prototype.属性 = 属性;
$Combatant.prototype.附加属性 = 附加属性;


let $prototypeGoods = {$objectType: 2};
let $prototypeSkill = {$objectType: 3};
let $prototypeFightScript = {$objectType: 4};



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

let mappingSystemName = {
    'money': '金钱',
}

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
//flags：image、color、count分别表示是否显示图像、颜色和数量（数量只有可叠加的才显示）
let $showGoodsName = function(goods, flags=null) {
    let name = '';

    if(flags === undefined || flags === null)
        flags = {image: true, color: true, count: true};

    if(flags['image'] && goods.$image) {
        //let goodsPath = game.$projectpath + game.$gameMakerGlobal.separator + game.$config.strGoodsDirName + game.$gameMakerGlobal.separator;

        //game.$globalLibraryJS.showRichTextImage();
        name += ' <img src=\"%1\" width=\"%2\" height=\"%3\" style=\"vertical-align: top;\">  '.
            //arg(goodsPath + goods.$rid + game.$gameMakerGlobal.separator + goods.$image).
            arg(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(goods.$image))).
            arg(goods.$size[0]).
            arg(goods.$size[1]);
    }

    if(flags['color'] && goods.$color)
        name += `<font color=\"${goods.$color}\">`;

    name += goods.$name;

    if(flags['color'] && goods.$color)
        name += '</font>';

    if(flags['count'] && (goods.$stackable || goods.$count > 1))
        name += ` x${goods.$count}`;

    return name;
}

//显示的战斗人物名格式
//flags：avatar、color分别表示是否显示头像、颜色
let $showCombatantName = function(combatant, flags=null) {
    let name = '';
    let fightRolePath = game.$projectpath + game.$gameMakerGlobal.separator + game.$config.strFightRoleDirName + game.$gameMakerGlobal.separator;

    if(flags === undefined || flags === null)
        flags = {avatar: true, color: true};

    if(flags['avatar'] && combatant.$avatar) {
        //game.$globalLibraryJS.showRichTextImage();
        name += ' <img src=\"%1\" width=\"%2\" height=\"%3\" style=\"vertical-align: top;\">  '.
            //arg(fightRolePath + combatant.$rid + game.$gameMakerGlobal.separator + combatant.$avatar).
            arg(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(combatant.$avatar))).
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
function $refreshCombatant(combatant) {

    //只有我方战斗人物才可以升级
    if(combatant.$index >= 0)
        levelUp(combatant, 0, false);

    //战斗时，由于是脚本系统运行，所以必须放在最前才能使血量实时更新
    //game.run([function() {
        //计算新属性
        computeCombatantPropertiesWithExtra(combatant);
        //刷新战斗时人物数据
        fight.refreshCombatant(combatant);
    //}, 'refreshCombatant1'], 0);
}


//直接升level级；为0表示检测是否需要升级；
//  fighthero为下标，或战斗角色的name，或战斗角色对象；
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
    game.run([levelupscript(combatant), 'levelupscript']);

    //强制刷新
    if(refresh)
        game.run([function() {
            //计算新属性
            computeCombatantPropertiesWithExtra(combatant);
            //刷新战斗时人物数据
            fight.refreshCombatant(combatant);
        },'refreshCombatant2']);
}



//计算 combatant 装备后的属性 并返回
//$equipEffectAlgorithm为某道具装备脚本
function computeCombatantPropertiesWithExtra(combatant) {
    //累加装备、Buff后的属性
    combatant.$$propertiesWithExtra = game.$globalLibraryJS.deepCopyObject(combatant.$properties);

    //行走速度改变示例代码1/3
    //let 行走速度;
    //if(combatant.$index === 0)
    //    行走速度 = game.gd['$sys_main_roles'][0].MoveSpeed;

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
        //if(combatant.$index === 0 && combatant.$equipment[te].行走速度)
        //    行走速度 += combatant.$equipment[te].行走速度;

    }

    //行走速度改变示例代码3/3
    //if(combatant.$index === 0)
    //    game.hero(0, {$speed: 行走速度});



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

    /*for(let tg of combatant.holdsScript) {
        for(let te in tg.holdsScript) {
            combatant.$$propertiesWithExtra[te] += tg.holdsScript[te];
        }
    }*/

    //console.debug('combatant.$$propertiesWithExtra', combatant, combatant.$$fightData, combatant.$$propertiesWithExtra);


    return combatant.$$propertiesWithExtra;
}



//游戏结束脚本
function *$gameOverScript(params) {
    if(params === -1) {
        yield game.msg('游戏结束', 60, '', 0, 0b11);
        game.$sys.release(false);
        game.$sys.init(true, false);
    }
}



//通用逃跑算法（目前是整体逃跑，所以 index为 -1）
function $commonRunAwayAlgorithm(team, index) {
    return game.$globalLibraryJS.randTarget(1,2);
}


//一个大回合内，返回每次回合的战斗人物数组
//返回数字表示延迟多久ms再继续
//返回null表示大回合结束
function *$fightRolesRound(round) {
    //所有的战斗人物
    let arrTempLoopedAllFightHeros = fight.myCombatants.concat(fight.enemies);

    //计算 攻击 顺序
    arrTempLoopedAllFightHeros.sort(function(a, b) {
        if(a.$$propertiesWithExtra.speed > b.$$propertiesWithExtra.speed)return -1;
        if(a.$$propertiesWithExtra.speed < b.$$propertiesWithExtra.speed)return 1;
        if(a.$$propertiesWithExtra.speed === b.$$propertiesWithExtra.speed)return 0;
    });
    //console.debug('[FightScene]all', arrTempLoopedAllFightHeros.length, JSON.stringify(arrTempLoopedAllFightHeros));


    //循环每个战斗人物
    for(let c of arrTempLoopedAllFightHeros) {
        //如果在场且HP[0] > 0，则进行战斗人物回合
        if(c.$$fightData.$info.$index >= 0 && c.$$propertiesWithExtra.HP[0] > 0)
            yield [c];
    }

    //大回合结束
    return null;
}


//技能效果算法
function $skillEffectAlgorithm(combatant, targetCombatant, Params) {
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

//敌人选择技能算法
function $enemyChoiceSkillsAlgorithm(combatant) {
    //返回打乱后的所有技能
    let useSkills = game.$globalLibraryJS.disorderArray(fight.$sys.getCombatantSkills(combatant, [0, 1])[1]);
    return useSkills;
}



//combatant获得Buff
//buffCode：12345分别表示 毒乱封眠 属性，params是参数；
//  buffCode：
//    1毒：params有BuffName、Round、HarmType（1为直接减harmValue，2为剩余HP的harmValue倍）、HarmValue、Flags；
//    2乱、3封、4眠：BuffName、Round、Flags；
//    5属性：BuffName、Round、Properties、Flags；
//        Properties：[属性名, 值, type]：Type为0表示相加，Type为1表示 与属性相乘；
//      Flags：实质是决定什么时候运行脚本（见combatantRoundEffects），可表示 毒乱封眠属性 类型，也可以表示 buff类型；
//          比如 毒 是回合开始前执行 buffAnimationEffect，乱封眠 是 combatant 行动前执行 buffAnimationEffect。
//  params：
//      BuffName：存储的 Buff 名称，如果不同则插入，如果相同则会覆盖；
//      Override表示是否覆盖（如果不覆盖，则 Buff名 后加时间戳来防止重复）
function getBuff(combatant, buffCode, params={}) {
    let buffNameKey;
    let override = (params.Override === undefined ? true : false);
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
            buffAnimationEffect: function*(combatant, objBuff) {
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
            buffAnimationEffect: function*(combatant, objBuff) {
                //技能为普通攻击的第一个
                let skills = fight.$sys.getCombatantSkills(combatant, [0], 0b1)[1];
                combatant.$$fightData.$choice.$type = 3;
                combatant.$$fightData.$choice.$attack = skills[0];
                //目标为自己
                combatant.$$fightData.$lastChoice.$targets = [[combatant]];

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
            buffAnimationEffect: function*(combatant, objBuff) {
                //技能为 普通攻击 的最后一个
                let skills = fight.$sys.getCombatantSkills(combatant, [0])[1];
                combatant.$$fightData.$choice.$type = 3;
                combatant.$$fightData.$choice.$attack = skills.pop();
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
            buffAnimationEffect: function*(combatant, objBuff) {
                $fightCombatantSetChoice(combatant, 1, false);
                //combatant.$$fightData.$choice.$type = 1;
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
            buffAnimationEffect: function*(combatant, objBuff) {

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

    $refreshCombatant(combatant);
}



//每个战斗人物（我方、敌方）的回合脚本；
//round为回合数；
//stage：0为回合开始前；1为战斗人物行动前；2为战斗人物行动后；
//返回null表示跳过回合（stage为1时有效）
function $combatantRoundScript(combatant, round, stage) {
    switch(stage) {
    case 0:
        //下场 的或 没血的休息
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            $fightCombatantSetChoice(combatant, 1, false);
            //combatant.$$fightData.$choice.$type = 1;

            //去掉，则死亡后仍然有buff效果
            return null;
        }
        break;
    case 1:
        //跳过下场 的或 没血的
        if(combatant.$$fightData.$info.$index < 0 || combatant.$$propertiesWithExtra.HP[0] <= 0) {
            //console.debug('没血');
            return null;
        }
        break;
    }


    return combatantRoundEffects(combatant, round, stage);
}

//战斗人物回合脚本（主要是剧情和Buff），会在两个阶段分别执行一次；
//round为回合数；
//stage：0为回合开始前；1为战斗人物行动前；2为战斗人物行动后；
function *combatantRoundEffects(combatant, round, stage) {

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
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    --tbuff.round;

                    //毒 的 方法和参数
                    yield* tbuff.buffAnimationEffect(combatant, tbuff);
                }
            }
        }
        //乱
        if(tbuff.flags & 0b0100) {
            if(stage === 1) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //乱 的 方法和参数
                    yield* tbuff.buffAnimationEffect(combatant, tbuff);
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //封
        if(tbuff.flags & 0b0010) {
            if(stage === 1) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //封 的 方法和参数
                    yield* tbuff.buffAnimationEffect(combatant, tbuff);
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //眠
        if(tbuff.flags & 0b0001) {
            if(stage === 1) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //眠 的 方法和参数
                    yield* tbuff.buffAnimationEffect(combatant, tbuff);
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //其他
        if(tbuff.flags & 0b10000) {
            if(stage === 1) {
                if(combatant.$$fightData.$info.$index >= 0 && combatant.$$propertiesWithExtra.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //其他 的 方法和参数
                    yield* tbuff.buffAnimationEffect(combatant, tbuff);
                }
            }
            else if(stage === 2)
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
}



//检测 技能/攻击 是否可用（有4个阶段会调用：选择时、攻击时、敌人和我方遍历时）；
//返回：true表示可以使用；字符串表示不能使用并提示的信息（只有选择时）；
//stage为0表示选择技能时，为1表示技能步骤选择完毕，为10表示战斗时再判断一次；
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
        console.warn('[!GameMakerGlobal]commonCheckSkill:', choiceType);

    //return true;
}



//检测是否战斗完毕，扫描所有战斗角色并将死亡角色隐藏；
//返回：0为没有结束；1为胜利；-1为失败；
function $checkAllCombatants(myCombatants, myTeamSpriteEffect, enemies, enemyTeamSpriteEffect) {

    let nFlags = 0;

    for(let ti in myCombatants) {
        if(myCombatants[ti].$$fightData.$info.$index >= 0 && myCombatants[ti].$$propertiesWithExtra.HP[0] > 0) {
            nFlags |= 0b1;
            //break;
        }
        else {
            myTeamSpriteEffect.itemAt(ti).opacity = 0.5;
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
            enemyTeamSpriteEffect.itemAt(ti).opacity = 0;
            //repeaterEnemies.itemAt(ti).visible = false;

            //计算经验、金钱 和 道具
            totalEXP += enemies[ti].$EXP || 0;
            totalMoney += parseInt(enemies[ti].$money || 0);
            if(enemies[ti].$goods) {
                for(let goods of enemies[ti].$goods) {
                    /*let g;
                    if(game.$globalLibraryJS.isObject(teq)) { //如果直接是对象
                        g = {$rid: teq.RId};
                        game.$globalLibraryJS.copyPropertiesToObject(g, game.$sys.getGoodsResource(teq.RId).$properties);
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



    yield fight.msg('通用战斗初始化事件', 0);


    let fightInitScript = fightData.$commons.$fightInitScript || fightData.$commons.FightInitScript;
    if(fightInitScript)
        yield fight.run([fightInitScript, 'fight init2'], -2, teams, fightData);

    if(Object.keys(fightData).indexOf('FightInitScript') >= 0)
        yield fight.run([fightData.FightInitScript, 'fight init3'], -2, teams, fightData);
}

//战斗开始通用脚本；
function *$commonFightStartScript(teams, fightData) {
    //let game = this.game;
    //let fight = this.fight;

    yield fight.msg('战斗开始通用脚本', 0);



    //战斗开始脚本
    let fightStartScript = fightData.$commons.$fightStartScript || fightData.$commons.FightStartScript;
    if(fightStartScript)
        yield fight.run([fightStartScript, 'fight start2'], -2, teams, fightData);

    //fighting战斗的回调函数
    if(Object.keys(fightData).indexOf('FightStartScript') >= 0)
        yield fight.run([fightData.FightStartScript, 'fight start3'], -2, teams, fightData);

}

//战斗回合通用脚本；
//step：0，回合开始；1，选择完毕
//team：0下标为我方，1下标为敌方
function *$commonFightRoundScript(round, step, teams, fightData) {
    //let game = this.game;
    //let fight = this.fight;


    /*/战斗回合脚本
    let fightRoundScript = fightData.$commons.$fightRoundScript || fightData.$commons.FightRoundScript;
    if(fightRoundScript)
        yield fight.run([fightRoundScript, 'fight round2' + step], -2, round, step, teams, fightData);

    //fighting战斗的回调函数
    if(Object.keys(fightData).indexOf('FightRoundScript') >= 0)
        yield fight.run([fightData.FightRoundScript, 'fight round3' + step], -2, round, step, teams, fightData);
    */



    switch(step) {
    case 0:
        //teams = [...teams[0], ...teams[1]];

        //!!这个是放置类的自动战斗功能代码
        if(fight.nAutoAttack === 1) {
            //自动重复上次类型，也可以根据需要改写
            fight.loadLast();
            /*game.$globalLibraryJS.setTimeout(function() {
                    fight.continueFight();
                },0,root
            );*/
        }



        yield fight.msg('战斗回合通用脚本' + round, 0);
        break;
    case 1:
        break;
    }



    //战斗回合脚本
    let fightRoundScript = fightData.$commons.$fightRoundScript || fightData.$commons.FightRoundScript;
    if(fightRoundScript)
        yield fight.run([fightRoundScript, 'fight round2' + step], -2, round, step, teams, fightData);

    //fighting战斗的回调函数
    if(Object.keys(fightData).indexOf('FightRoundScript') >= 0)
        yield fight.run([fightData.FightRoundScript, 'fight round3' + step], -2, round, step, teams, fightData);

}

//战斗结束通用脚本；
function *$commonFightEndScript(r, teams, fightData) {
    //这里的r，可能会被 战斗脚本修改
    //r中包含：result（战斗结果）、money和exp

    //let game = this.game;
    //let fight = this.fight;


    //战斗结束脚本1
    let fightEndScript = fightData.$commons.$fightEndScript || fightData.$commons.FightEndScript;
    if(fightEndScript)
        yield fight.run([fightEndScript, 'fight end20'], -2, r, 0, teams, fightData);

    //fighting战斗的回调函数
    if(Object.keys(fightData).indexOf('FightEndScript') >= 0)
        yield fight.run([fightData.FightEndScript, 'fight end30'], -2, r, 0, teams, fightData);



    for(let tc of fight.myCombatants) {
        //fight.myCombatants[t].$properties.EXP += r.exp;
        game.addprops(tc, {'EXP': r.exp});

        /*/将血量设置为1
        if(tc.$properties.HP[1] <= 0)
            tc.$properties.HP[1] = 1;
        if(tc.$properties.HP[0] <= 0)
            tc.$properties.HP[0] = 1;
        */

        //去掉buffs
        //tc.$$fightData.$buffs = {};
    }

    let bGetGoods = false;
    let msgGoods = '获得道具：';
    for(let t of r.goods) {
        if(game.rnd(0,100) < 60) {
            msgGoods += ('<BR>' + t.$name);
            game.getgoods(t, 1);
            bGetGoods = true;
        }
    }

    game.money(r.money);


    if(r.result === 1) {
        yield fight.msg('战斗胜利<BR>获得  %1经验，%2金钱'.arg(r.exp).arg(r.money));
        //fight.run('');
    }
    else if(r.result === -1) {
        yield fight.msg('战斗失败<BR>获得  %1经验，%2金钱'.arg(r.exp).arg(r.money));
        //fight.run('fight.popmusic();s_FightOver();'.arg(r.exp).arg(r.money));
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



    //战斗结束脚本2
    if(fightEndScript)
        game.run([fightEndScript, 'fight end21'], -1, r, 1, teams, fightData);

    //fighting战斗的回调函数
    if(Object.keys(fightData).indexOf('FightEndScript') >= 0)
        game.run([fightData.FightEndScript, 'fight end31'], -1, r, 1, teams, fightData);



    fight.run(function() {
        fight.over();

        if(r.result === -1)
            game.gameover(-1);


        //返回地图代码
        //game.stage(0);
        //game.goon('$fight');

    });

    //console.debug(JSON.stringify(r), r.exp, r.money);
}



//获取 某战斗角色 中心位置
//teamID、index是战斗角色的；cols表示有几列（战场分布）；
function $fightCombatantPositionAlgorithm(teamID, index) {
    //let teamID = combatant.$$fightData.$info.$teamID[0];
    //let index = combatant.$$fightData.$info.$index;

    if(index === -1) {    //全体时的位置
        let cols = 3;
        if(teamID === 0)    //我方
            return Qt.point(fight.$sys.container.width / cols, fight.$sys.container.height / 2);
        else    //敌方
            return Qt.point(fight.$sys.container.width * (cols-1) / cols, fight.$sys.container.height / 2);
    }

    //单个人物位置
    let cols = 4;
    if(teamID === 0) {    //我方
        return Qt.point(fight.$sys.container.width / cols, fight.$sys.container.height * (index + 1) / (fight.myCombatants.length/*fight.$sys.components.spriteEffectMyCombatants.nCount*/ + 1));
    }
    else {  //敌方
        return Qt.point(fight.$sys.container.width * (cols-1) / cols, fight.$sys.container.height * (index + 1) / (fight.enemies.length/*fight.$sys.components.spriteEffectEnemies.nCount*/ + 1));
    }
}

//战斗角色近战 坐标
function $fightCombatantMeleePositionAlgorithm(combatant, targetCombatant) {
    let combatantSpriteEffect = combatant.$$fightData.$info.$spriteEffect;
    let targetCombatantSpriteEffect = targetCombatant.$$fightData.$info.$spriteEffect;

    //x偏移（targetCombatant的左或右边）
    let tx = combatantSpriteEffect.x < targetCombatantSpriteEffect.x ? -combatantSpriteEffect.width : combatantSpriteEffect.width;
    let position = combatantSpriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);

    return Qt.point(position.x + combatantSpriteEffect.x, position.y + combatantSpriteEffect.y);
}
//特效在战斗角色的 坐标
function $fightSkillMeleePositionAlgorithm(combatant, spriteEffect) {
    let combatantSpriteEffect = combatant.$$fightData.$info.$spriteEffect;

    //x偏移（spriteEffect的左或右边）
    let tx = spriteEffect.x < combatantSpriteEffect.x ? -spriteEffect.width : spriteEffect.width;
    let position = spriteEffect.mapFromItem(combatantSpriteEffect, tx, 0);

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
            combatant.$$fightData.$lastChoice.$type = 1;
            combatant.$$fightData.$lastChoice.$attack = undefined;
            combatant.$$fightData.$lastChoice.$targets = undefined;
        }
        break;
    }
}


//战斗菜单
let $fightMenu = {
    $menu: ['普通攻击', '技能', '物品', '信息', '休息'],
    $actions: [
        function(combatantIndex) {
            fight.$sys.showSkillsOrGoods(0);
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
            //combatant.$$fightData.$choice.$type = 1;
            //combatant.$$fightData.$choice.$attack = undefined;
            //combatant.$$fightData.$choice.$targets = undefined;
            //combatant.$$fightData.$lastChoice.$type = 1;
            //combatant.$$fightData.$lastChoice.$attack = undefined;
            //combatant.$$fightData.$lastChoice.$targets = undefined;



            fight.$sys.checkToFight();
        },
    ],
};



//装备预留槽位（会显示这些槽位，且按顺序排，不在里面的会追加在后面）；
let $equipReservedSlots = ['头戴', '身穿', '武器', '鞋子'];



//读取存档信息，返回数组
function $readSavesInfo(count=3) {
    let arrSave = [];
    for(let i = 0; i < count; ++i) {
        let ts = game.checksave('存档' + i);
        if(ts) {
            arrSave.push('存档%1：%2（%3）'.arg(i).arg(ts.Name).arg(ts.Time));
        }
        else
            arrSave.push('空');
    }
    return arrSave;
}

"
            );
        }

        notepadGameFightScriptScript.toBegin();
    }


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true

    color: Global.style.backgroundColor



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.fillWidth: true
                text: "游戏通用算法脚本"
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            Notepad {
                id: notepadGameFightScriptScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                textArea.text: ''
                textArea.placeholderText: "请输入脚本"

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: notepadGameFightScriptScript.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                    border.width: notepadGameFightScriptScript.textArea.focus ? 2 : 1
                }
            }

        }

        Button {
            id: buttonSave

            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            text: "保存"
            onClicked: {
                _private.save();
            }
        }

        /*RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "主角大小："
            }

            TextField {
                id: textMainRoleWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "50"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "X"
            }

            TextField {
                id: textMainRoleHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "80"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/
    }


    QtObject {
        id: _private


        function save() {
            let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(notepadGameFightScriptScript.textDocument), GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "common_script.js", 0);

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function(){
                    if(save())
                        s_close();
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    s_close();
                },
                OnDiscarded: ()=>{
                    dialogCommon.close();
                    root.forceActiveFocus();
                },
            });
        }
    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        _private.close();

        console.debug("[GameCommonScript]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug("[GameCommonScript]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[GameCommonScript]Keys.onPressed:", event.key);
    }
    Keys.onReleased: {
        console.debug("[GameCommonScript]Keys.onReleased:", event.key);
    }



    Component.onCompleted: {

    }
}
