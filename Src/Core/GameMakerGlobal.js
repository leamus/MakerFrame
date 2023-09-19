.pragma library

//.import 'qrc:/QML/GlobalLibraryJS.js' as GlobalLibraryJS

//.import 'level_chain.js' as JSLevelChain       //导入另一个js文件
//let jsLevelChain = JSLevelChain;    //让外部可访问



/*/创建战斗角色
function $createCombatant(fightRoleRId, showName) {
    //console.debug('[FightScene]createCombatant');
    if(!fightRoleRId)
        fightRoleRId = '深林孤鹰';
    if(!showName)
        showName = fightRoleRId;


    //属性定义
    let properties = {
        HP: 200,
        healthHP: 200,
        remainHP: 200,
        MP: 200,
        remainMP: 200,

        attack: 50,
        defense: 50,

        EXP: 0,     //经验
        level: 0,   //级别

        //其他属性
        power: 50,
        luck: 50,
        speed: 50,

    };



    return {
        $rid: fightRoleRId,  //战斗角色名（包含特效）

        name: showName,     //游戏显示名
        index: -1,  //序号

        //所有属性
        properties: properties,

        //fightSkill: null,   //普通攻击
        skills: [],     //普通攻击 和 技能/魔法 的对象，可以加入其他字段（比如级别，这些字段会覆盖原有的属性）
        //goods: [],      //携带道具 的（只有敌人有） 对象
        equipment: {}, //装备；key为position，value为 道具对象，可以加入其他（比如破损率，这些字段会覆盖原有的属性）



        //hide: false,        //是否隐藏


        //战斗属性+道具属性（动态计算），不会存档
        $$propertiesWithExtra: properties,


        //战斗属性，不会保存
        //注意：这里只是显示需要用到的字段，实际会在fight前重新初始化!!!
        $$fightData: {
            $index: -1,              //所在队伍下标
            $teamID: 0,              //0：我方；1：敌人；2：友军
            $team: null,             //保存队伍对象

            //actionData: ({}),   //动作数据；key为动作名，value为特效名

            $buffs: ({}),        //buffs


            $target: -2,         //战斗目标（-1为全部，-2为休息）
            $lastTarget: -2,     //上次目标

            $attackSkill: undefined,        //攻击选择的技能名称（-1为获得普通攻击（倒序），-2为休息，undefined为没选择）
            $lastAttackSkill: undefined,    //上次技能

            //$defenseSkill: '',    //防御选择
            //$lastDefenseSkill: '',
        },

        属性: 属性,
        附加属性: 附加属性,
    };
}*/



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
                //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
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
                //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
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
            $teamID: [0, 1],         //0：我方；1：敌人；2：友军。下标：我方、对方、友方
            $team: [],               //保存队伍对象。下标：己方、对方、友方
            $teamSpriteEffect: [],
            $spriteEffect: null,

        },


        $choiceType: -1,         //选择的类型（主要是这个来判断!!）。0，普通攻击；1，技能；2，道具；3，休息；4，逃跑；-1为没选择；-2为随机选择普通攻击（倒序开始）
        $lastChoiceType: -1,

        $attackSkill: undefined,        //攻击选择的技能名称（-1为获得普通攻击（倒序），-2为休息，undefined为没选择）
        $lastAttackSkill: undefined,    //上次技能

        $target: undefined,         //战斗目标数组[FightRole]（-1为全部）；
        $lastTarget: undefined,     //上次目标


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
        name += ' <img src="%1" width="%2" height="%3" style="vertical-align: top;">  '.
            //arg(goodsPath + goods.$rid + game.$gameMakerGlobal.separator + goods.$image).
            arg(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(goods.$image))).
            arg(goods.$size[0]).
            arg(goods.$size[1]);
    }

    if(flags['color'] && goods.$color)
        name += `<font color="${goods.$color}">`;

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
        name += ' <img src="%1" width="%2" height="%3" style="vertical-align: top;">  '.
            //arg(fightRolePath + combatant.$rid + game.$gameMakerGlobal.separator + combatant.$avatar).
            arg(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(combatant.$avatar))).
            arg(combatant.$size[0]).
            arg(combatant.$size[1]);
    }

    if(flags['color'] && combatant.$color)
        name += `<font color="${combatant.$color}">`;

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
            levelupscript = commonLevelUpScript;
        }
    }

    if(!levelalgorithm) {
        try {
            levelalgorithm = JSLevelChain.commonLevelAlgorithm;
        }
        catch(e) {
            levelalgorithm = commonLevelAlgorithm;
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
    for(let tg in combatant.$equipment) {
        //跳过为空的
        if(!combatant.$equipment[tg])
            continue;

        //let goodsInfo = game.$sys.resources.goods[combatant.$equipment[tg].$rid];
        //计算新属性
        if(combatant.$equipment[tg].$equipEffectAlgorithm)
            combatant.$equipment[tg].$equipEffectAlgorithm(combatant.$equipment[tg], combatant);


        //这里可以添加判断相关套装和增加的额外属性代码


        //行走速度改变示例代码2/3
        //if(combatant.$index === 0 && combatant.$equipment[tg].行走速度)
        //    行走速度 += combatant.$equipment[tg].行走速度;

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


//战斗人物排序算法
function $sortFightAlgorithm(a, b) {
    if(a.$$propertiesWithExtra.speed > b.$$propertiesWithExtra.speed)return -1;
    if(a.$$propertiesWithExtra.speed < b.$$propertiesWithExtra.speed)return 1;
    if(a.$$propertiesWithExtra.speed === b.$$propertiesWithExtra.speed)return 0;
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
    let skill = combatant.$$fightData.$attackSkill;
    //let skill2 = targetCombatant.$$fightData.$attackSkill;

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
function $enemyChoiceSkillAlgorithm(combatant) {

    //随机选择技能
    let tSkillIndexArray = game.$globalLibraryJS.GetDifferentNumber(0, combatant.$skills.length);
    for(let tSkillIndex in tSkillIndexArray) {
        let skill = combatant.$skills[tSkillIndexArray[tSkillIndex]];

        /*let attackSkill;
        if(game.$globalLibraryJS.isString(skill)) {
            attackSkill = {$rid: skill};
            game.$globalLibraryJS.copyPropertiesToObject(attackSkill, game.$sys.resources.skills[skill].$properties);
        }
        else {
            attackSkill = {$rid: skill.RId};
            game.$globalLibraryJS.copyPropertiesToObject(attackSkill, game.$sys.resources.skills[skill.RId].$properties);
            game.$globalLibraryJS.copyPropertiesToObject(attackSkill, skill);
        }*/

        //let checkSkill = game.$sys.resources.commonScripts['common_check_skill'](skill, combatant, 1);
        let checkSkill = $commonCheckSkill(skill, combatant, null, 1, (skill.$type === 0 ? 0 : 1));
        if(checkSkill === true) {   //如果技能符合可用
            combatant.$$fightData.$choiceType = (skill.$type === 0 ? 0 : 1);
            combatant.$$fightData.$attackSkill = skill;

            return true;
        }
    }
    return false;
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
    let buffName;
    let override = (params.Override === undefined ? true : false);
    let round = params.Round || 5;
    let flags = params.Flags;

    switch(buffCode) {
    //毒
    case 1:
        if(!game.$globalLibraryJS.isString(params.BuffName))
            params.BuffName = '$$Poison';
        buffName = params.BuffName;
        if(!override)
            buffName += new Date().getTime();

        combatant.$$fightData.$buffs[buffName] = {
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
                    harm = combatant.$properties.HP[0] * params.HarmValue;
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
        buffName = params.BuffName;
        if(!override)
            buffName += new Date().getTime();

        combatant.$$fightData.$buffs[buffName] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffAnimationEffect: function*(combatant, objBuff) {
                //技能为普通攻击的第一个
                let skills = fight.$sys.getCombatantSkills(combatant, [0], 0b1)[1];
                combatant.$$fightData.$attackSkill = skills[0];
                //目标为自己
                combatant.$$fightData.$target = [combatant];

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
        buffName = params.BuffName;
        if(!override)
            buffName += new Date().getTime();

        combatant.$$fightData.$buffs[buffName] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffAnimationEffect: function*(combatant, objBuff) {
                //技能为 普通攻击 的最后一个
                let skills = fight.$sys.getCombatantSkills(combatant, [0])[1];
                combatant.$$fightData.$attackSkill = skills.pop();
                combatant.$$fightData.$target = null;

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
        buffName = params.BuffName;
        if(!override)
            buffName += new Date().getTime();

        combatant.$$fightData.$buffs[buffName] = {
            //回合数
            round: round || 5,
            //执行脚本，objBuff为 本buff对象
            buffAnimationEffect: function*(combatant, objBuff) {
                combatant.$$fightData.$choiceType = 3;
                //combatant.$$fightData.$target = -2;

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
        buffName = params.BuffName;
        if(!override)
            buffName += new Date().getTime();

        combatant.$$fightData.$buffs[buffName] = {
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
    if(stage === 0) {
        //没血的休息
        if(combatant.$properties.HP[0] <= 0) {
            combatant.$$fightData.$choiceType = 3;
        }
    }

    if(stage === 1) {
        //跳过没血的
        if(combatant.$properties.HP[0] <= 0) {
            //console.debug('没血');
            return null;
        }
    }

    return combatantRoundEffects(combatant, round, stage);
}

//战斗人物回合脚本（主要是剧情和Buff），会在两个阶段分别执行一次；
//round为回合数；
//stage：0为回合开始前；1为战斗人物行动前；
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
                if(combatant.$properties.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    --tbuff.round;

                    //毒 的 方法和参数
                    let gen = tbuff.buffAnimationEffect(combatant, tbuff);
                    for(let tg of gen)
                        yield tg;
                }
            }
        }
        //乱
        if(tbuff.flags & 0b0100) {
            if(stage === 1) {
                if(combatant.$properties.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //乱 的 方法和参数
                    let gen = tbuff.buffAnimationEffect(combatant, tbuff);
                    for(let tg of gen)
                        yield tg;
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //封
        if(tbuff.flags & 0b0010) {
            if(stage === 1) {
                if(combatant.$properties.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //封 的 方法和参数
                    let gen = tbuff.buffAnimationEffect(combatant, tbuff);
                    for(let tg of gen)
                        yield tg;
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //眠
        if(tbuff.flags & 0b0001) {
            if(stage === 1) {
                if(combatant.$properties.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //眠 的 方法和参数
                    let gen = tbuff.buffAnimationEffect(combatant, tbuff);
                    for(let tg of gen)
                        yield tg;
                }
            }
            else if(stage === 2)
                --tbuff.round;
        }
        //其他
        if(tbuff.flags & 0b10000) {
            if(stage === 1) {
                if(combatant.$properties.HP[0] > 0 && tbuff.buffAnimationEffect) {
                    //其他 的 方法和参数
                    let gen = tbuff.buffAnimationEffect(combatant, tbuff);
                    for(let tg of gen)
                        yield tg;
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
//stage为0表示选择时，为1表示选择某战斗角色（我方或敌方，此时targetCombatant不为null，其他情况为null），为10表示战斗中；
//type为0、1、2分别表示使用普通攻击、技能和道具（此时相应的fightSkill也为道具）；
function $commonCheckSkill(fightSkill, combatant, targetCombatant, stage, type) {
    let goods = null;

    //如果选择的是技能
    if(type === 0 || type === 1) {
        //skill = combatant.$$fightData.$attackSkill;
    }
    //如果选择的是道具
    else if(type === 2) {
        goods = fightSkill;
        fightSkill = goods.$fight[0];
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


    //遍历所有的buff，每个-1回合
    for(let tbuffsIndex in buffs) {
        let tbuff = buffs[tbuffsIndex];
        //如果是 毒乱封眠
        if(tbuff.flags & 0b0001) {
            if(stage === 1)
                return '你已经被[眠]';
        }
        else if((tbuff.flags & 0b0010) && goods === null && fightSkill.$type === 1) {   //选择的是 技能
            return '你已经被[封]';
        }
        else if(tbuff.flags & 0b0100) {
            if(stage === 1 && fightSkill.$type === 1)   //只能选择 普通攻击
                return '你已经被[乱]';
        }
    }


    //如果选择的是道具
    if(type === 2) {
        //如果都有定义
        if(GlobalLibraryJS.isObject(goods.$fightScript) && goods.$fightScript.$check !== undefined) {
            if(GlobalLibraryJS.isFunction(goods.$fightScript.$check)) {
                return goods.$fightScript.$check(goods, combatant, targetCombatant, stage);
            }
            else
                return goods.$fightScript.$check;
        }
        //没定义，则按skill的check来
        else if(fightSkill)
            type = (fightSkill.$type === 0 ? 0 : 1);
        else
            return undefined;

    }
    //如果选择的是技能
    if(type === 0 || type === 1) {
        if(GlobalLibraryJS.isFunction(fightSkill.$check)) {
            return fightSkill.$check(fightSkill, combatant, targetCombatant, stage);
        }
        else
            return fightSkill.$check;
    }
    else
        console.warn('commonCheckSkill:', type);

    //return true;
}



//检测是否战斗完毕，扫描所有战斗角色并将死亡角色隐藏；
//返回：0为没有结束；1为胜利；-1为失败；
function $checkAllCombatants(myCombatants, myTeamSpriteEffect, enemies, enemyTeamSpriteEffect) {

    let nFlags = 0;

    for(let ti in myCombatants) {
        if(myCombatants[ti].$properties.HP[0] > 0) {
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
        if(enemies[ti].$properties.HP[0] > 0) {
            nFlags |= 0b10;
            //break;
        }
        else {
            //隐藏
            enemyTeamSpriteEffect.itemAt(ti).opacity = 0;
            //repeaterEnemies.itemAt(ti).visible = false;

            //计算经验、金钱 和 道具
            totalEXP += enemies[ti].$EXP;
            totalMoney += parseInt(enemies[ti].$money);
            if(enemies[ti].$goods) {
                for(let goods of enemies[ti].$goods) {
                    /*let g;
                    if(game.$globalLibraryJS.isObject(teq)) { //如果直接是对象
                        g = {$rid: teq.RId};
                        game.$globalLibraryJS.copyPropertiesToObject(g, game.$sys.resources.goods[teq.RId].$properties);
                        game.$globalLibraryJS.copyPropertiesToObject(g, teq);
                    }
                    else if(game.$globalLibraryJS.isString(teq)) { //
                        g = {$rid: teq};
                        game.$globalLibraryJS.copyPropertiesToObject(g, game.$sys.resources.goods[teq].$properties);
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

        //将血量设置为1
        if(tc.$properties.HP[1] <= 0)
            tc.$properties.HP[1] = 1;
        if(tc.$properties.HP[0] <= 0)
            tc.$properties.HP[0] = 1;

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

        //game.stage(0);
        //game.goon('$fight');

        if(r.result === -1)
            game.gameover(-1);
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
        return Qt.point(fight.$sys.container.width / cols, fight.$sys.container.height * (index + 1) / (fight.$sys.components.spriteEffectMyCombatants.nCount + 1));
    }
    else {  //敌方
        return Qt.point(fight.$sys.container.width * (cols-1) / cols, fight.$sys.container.height * (index + 1) / (fight.$sys.components.spriteEffectEnemies.nCount + 1));
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
    let targetCombatantSpriteEffect = combatant.$$fightData.$info.$spriteEffect;

    //x偏移（spriteEffect的左或右边）
    let tx = spriteEffect.x < targetCombatantSpriteEffect.x ? -spriteEffect.width : spriteEffect.width;
    let position = spriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);

    return Qt.point(position.x + spriteEffect.x, position.y + spriteEffect.y);
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
            combatant.$$fightData.$target = undefined;
            combatant.$$fightData.$attackSkill = undefined;
            combatant.$$fightData.$choiceType = 3;

            combatant.$$fightData.$lastTarget = undefined;
            combatant.$$fightData.$lastAttackSkill = undefined;
            combatant.$$fightData.$lastChoiceType = 3;



            fight.$sys.checkToFight();
        },
    ],
};



/*/得到道具通用脚本
function *commonGetGoodsScript(goodsName) {
    //let game = this.game;

    //yield game.msg('得到【%1】'.arg(game.$sys.resources.goods[goodsRId].$properties.$name), 100, true);
    yield game.msg('得到【%1】'.arg(goodsName), 100, true);
}


//使用道具通用脚本
function *commonUseGoodsScript(goodsName, type) {
    //let game = this.game;

    switch(type) {
    case 0:
        //yield game.msg('不能使用【%1】'.arg(game.$sys.resources.goods[goodsRId].$properties.$name), 100, true);
        yield game.msg('得到【%1】'.arg(goodsName), 100, true);
        break;
    default:
    }
}
*/



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







//升级脚本
function *commonLevelUpScript(combatant) {

    let level = 0;  //当前经验可达到的级别
    let nextExp = 10;   //下一级别的经验


    //升级条件
    while(nextExp <= combatant.$properties.EXP) {
        nextExp = nextExp * 2;
        ++level;
    }


    //升级结果
    while(level > combatant.$properties.level) {

        ++combatant.$properties.level;

        combatant.$properties.HP[0] = combatant.$properties.HP[1] = combatant.$properties.HP[2] = parseInt(combatant.$properties.HP[2] * 1.1);
        combatant.$properties.MP[0] = combatant.$properties.MP[1] = parseInt(combatant.$properties.MP[1] * 1.1);
        combatant.$properties.attack = parseInt(combatant.$properties.attack * 1.1);
        combatant.$properties.defense = parseInt(combatant.$properties.defense * 1.1);
        combatant.$properties.power = parseInt(combatant.$properties.power * 1.1);
        combatant.$properties.luck = parseInt(combatant.$properties.luck * 1.1);
        combatant.$properties.speed = parseInt(combatant.$properties.speed * 1.1);


        /*game.run(
            'yield game.msg(\"%1升为%2级\");'.arg(combatant.$name).arg(combatant.$properties.level)
        );*/
        yield game.msg('%1升为%2级'.arg(combatant.$name).arg(combatant.$properties.level), 20, '', 0, 0b11);


        if(combatant.$name === "killer") {
            switch(combatant.$properties.level) {
            case 1:
                game.getskill(combatant, "恢复血量");
                yield game.msg("%1 获得技能 %2".arg(combatant.$name).arg("恢复血量"), 20, '', 0, 0b11);
                break;
            }
        }
    }

    return level;
}

//targetLeve级别对应需要达到的 各项属性 的算法（升级时会设置，可选；注意：只增不减）
function commonLevelAlgorithm(combatant, targetLevel) {
    if(targetLevel <= 0)
        return null;

    let level = 1;  //级别
    let exp = 10;   //级别的经验

    while(level < targetLevel) {
        exp = exp * 2;
        ++level;
    }

    return {EXP: exp};
}









//增加属性（支持多段属性增加）；
//props是战斗人物的$properties；如果props的某个属性是单段（字符串），则直接增加；如果是多段（数组），如果incrementProps对应属性是单值，则都增加，如果是数组，则对应增加；
//  incrementProps：对象，支持格式：
//      {HP: 6}：每段都改变
//      {HP: [6,6,6]}：按顺序给每段改变（只支持段属性）
//      {'HP,2': 6}：某段改变值
//          当type为2倍率时，value可以为数组，第1、2表示哪一个属性；
//          当type为0时，value为填满的段值个数；
//  type:1为加减；2为倍率；3为直接赋值；0为将值填满（只限n段值的 0~n-2 段值），且increamentProps的value为填满的段值个数；
function addProps(props, incrementProps, type=1, propertiesWithExtra=undefined) {
    if(!propertiesWithExtra)
        propertiesWithExtra = props;

    let tKeys = Object.keys(props);
    //循环属性
    for(let tp in incrementProps) {
        let tincrementValue = incrementProps[tp];
        tp = tp.split(',');

        //如果 属性名 是 {HP: 。。。} 类型
        if(tp.length === 1) {
            tp = tp[0].trim();

            //如果有这个属性
            if(tKeys.indexOf(tp) >= 0) {
                //如果 战斗人物属性 是数组值（多段类型：{HP: [。。。]}）
                if(game.$globalLibraryJS.isArray(props[tp])) {
                    //循环数组
                    for(let tti = props[tp].length; tti > 0; --tti) {
                        //如果增加的属性值是 数字，则每段都加
                        if(game.$globalLibraryJS.isValidNumber(tincrementValue)) {
                            //根据type来赋值
                            if(type === 1)
                                props[tp][tti - 1] = parseInt(props[tp][tti - 1] + tincrementValue);
                            else if(type === 2)
                                props[tp][tti - 1] = parseInt(propertiesWithExtra[tp][tti - 1] * tincrementValue);
                            else if(type === 3)
                                props[tp][tti - 1] = parseInt(tincrementValue);
                            //直接赋值，且 不是最后一项， 且 恢复的个数 >= 当前下标!!!
                            else if(type === 0 && tti < props[tp].length && tincrementValue >= tti) {
                                props[tp][tti - 1] = propertiesWithExtra[tp][tti];
                                propertiesWithExtra[tp][tti - 1] = propertiesWithExtra[tp][tti];    //给下一个props做准备赋值
                            }
                        }
                        //如果增加的属性值是 数组，且此下标值是数字
                        else if(game.$globalLibraryJS.isValidNumber(tincrementValue[tti - 1])) {
                            //根据type来赋值
                            if(type === 1)
                                props[tp][tti - 1] = parseInt(props[tp][tti - 1] + tincrementValue[tti - 1]);
                            else if(type === 2)
                                props[tp][tti - 1] = parseInt(propertiesWithExtra[tp][tti - 1] * tincrementValue[tti - 1]);
                            else if(type === 3)
                                props[tp][tti - 1] = parseInt(tincrementValue[tti - 1]);
                            else if(type === 0 && tti < props[tp].length) {
                                props[tp][tti - 1] = propertiesWithExtra[tp][tti];
                                propertiesWithExtra[tp][tti - 1] = propertiesWithExtra[tp][tti];    //给下一个props做准备赋值
                            }

                            //如果前面的大于后面的，则调整
                            if(game.$globalLibraryJS.isValidNumber(props[tp][tti]) &&
                                    props[tp][tti - 1] > propertiesWithExtra[tp][tti]) {
                                props[tp][tti - 1] = propertiesWithExtra[tp][tti];
                            }
                        }
                    }
                }
                //如果属性是数字（{HP: 。。。}，且增加的属性也是数字
                else if(game.$globalLibraryJS.isValidNumber(tincrementValue)) {

                    //根据type来赋值
                    if(type === 1)
                        props[tp] = parseInt(props[tp] + tincrementValue);
                    else if(type === 2)
                        props[tp] = parseInt(propertiesWithExtra[tp] * tincrementValue);
                    else if(type === 3)
                        props[tp] = parseInt(tincrementValue);
                    //else if(type === 0 && tti < props[tp].length)
                    //    props[tp] += tincrementValue;
                }
            }
        }
        //如果是 {'HP, xxx': 。。。} 类型
        else if(tp.length === 2) {
            tp[0] = tp[0].trim();
            tp[1] = tp[1].trim();

            //根据type来赋值
            //加
            if(type === 1)
                props[tp[0]][tp[1]] = parseInt(props[tp[0]][tp[1]] + tincrementValue);
            //倍率（两种方式）
            else if(type === 2) {
                //形式1：key为数组，前2个表示要修改的属性和段，后2个表示基属性和段（段可省略）
                if(tp[2] !== undefined) {
                    tp[2] = tp[2].trim();

                    if(tp[3] !== undefined) {
                        tp[3] = tp[3].trim();
                        props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tp[2]][tp[3]] * tincrementValue);
                    }
                    else
                        props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tp[2]] * tincrementValue);
                }

                //形式2：value为数组，则 [值,属性,段]
                else if(game.$globalLibraryJS.isArray(tincrementValue)) {
                    //直接乘
                    if(tincrementValue[0] !== undefined) {
                        tincrementValue[0] = tincrementValue[0].trim();
                        if(tincrementValue[1] !== undefined) {
                            tincrementValue[1] = tincrementValue[1].trim();
                            //3个参数，则 乘以 tincrementValue[1]tincrementValue[2] 属性的段值
                            if(tincrementValue[2] !== undefined) {
                                tincrementValue[2] = tincrementValue[2].trim();

                                props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tincrementValue[1]][tincrementValue[2]] * tincrementValue[0]);
                            }
                            //2个参数，则 乘以 tincrementValue[1] 属性的值
                            else
                                props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tincrementValue[1]] * tincrementValue[0]);
                        }
                        //1个参数，则 乘以它自身
                        else
                            props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tp[0]][tp[1]] * tincrementValue[0]);
                    }
                }

                //直接乘
                else if(game.$globalLibraryJS.isValidNumber(tincrementValue))
                    props[tp[0]][tp[1]] = parseInt(propertiesWithExtra[tp[0]][tp[1]] * tincrementValue);
            }
            //赋值
            else if(type === 3)
                props[tp[0]][tp[1]] = parseInt(tincrementValue);
            //else if(type === 0 && tti < props[tp[0]][tp[1]].length)
            //    props[tp[0]][tp[1]] += tincrementValue;
        }
    }

}






/*
function propertyName(prop) {
    switch(prop) {
    case 0:
        return '乱风';
    case 1:
        return '眠土';
    case 2:
        return '雷电';
    case 3:
        return '毒水';
    case 4:
        return '豪火';
    }
}

function skillEffectAlgorithm1(team1, roleIndex1, team2, roleIndex2, skillEffect) {
    //console.debug('damage0', team1, roleIndex1, team2, roleIndex2, skillEffect);

    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];

    //伤害
    let harm, t;

    if(game.$globalLibraryJS.randTarget(role2.luck / 5 + role2.speed / 5)) //miss各占%20
    {
        return [{property: 'remainHP', value: 0, target: team2[roleIndex2]}];
    }

    //计算攻击
    harm = t = role1.attack;


    let PropFlag = 0;
    var attackPropValue = role1.$properties[role1.$$fightData.attackProp]; //攻击属性 的 值

    if((role1.$$fightData.attackProp + 1) % 5 === role2.$$fightData.defenseProp)        //属性攻击成功
    {
        PropFlag = 1;
    }
    else if((role2.$$fightData.attackProp + 1) % 5 === role1.$$fightData.defenseProp)   //失败
    {
        PropFlag = -1;
    }

    if(PropFlag === 1)  //附加使用成功
    {
        if(role1.$$fightData.attackProp === 2)  //雷属性
        {
            harm = t * game.$globalLibraryJS.random(attackPropValue + 1,attackPropValue * 4 + 1) / 100 + t;  //max <5倍
        }
        else   //其他属性
        {
            harm = t * game.$globalLibraryJS.random(attackPropValue + 1,attackPropValue * 2 + 1) / 100 + t;  //属性效果 <3倍
        }
    }
    else if(PropFlag === -1) //失败
    {
        harm = t - t * game.$globalLibraryJS.random((100 - attackPropValue) * 2,(100 - attackPropValue) * 5) / 500;  //属性效果 减小
    }
    else
        if(role1.$$fightData.attackProp === 2) //雷,且无作用
            harm = t * game.$globalLibraryJS.random(attackPropValue / 2,attackPropValue + 1) /100 + t;  //max <5倍


    //计算防御
    //中 防御降低
    t = role2.defense;
    if(role2.$$fightData.bufferProps.defenceDown !== 0) //对方中火
    {
        t = t * game.$globalLibraryJS.random(2, 50) / 100;
    }

    harm = harm - t;  //攻击-防御
    t = role1.attack;
    t = t * game.$globalLibraryJS.random(role1.power, role1.power*2) /10000; //灵力1~2倍 //攻击+灵力效果
    harm = harm + t;
    t = role1.attack;
    t = t * game.$globalLibraryJS.random(10,role1.luck / 10+1) /10000 ; //吉运效果 千分之一到十分之一
    harm = harm + t;
    t = role2.defense;
    t = t * game.$globalLibraryJS.random(role2.power / 2,role2.power) /10000; //防御+灵力效果
    harm = harm - t;
    t = role2.defense;
    t = t * game.$globalLibraryJS.random(10,role2.luck / 10+1) /10000; //吉运效果
    harm = harm - t;


    harm = Math.floor(harm)
    if(harm <= 0)harm = game.$globalLibraryJS.random(0, 10);

    role2.remainHP -= harm;

    //console.debug('damage1');
    return [{property: 'remainHP', value: harm, target: team2[roleIndex2]}];
}
*/
