//.pragma library

//.import "qrc:/QML/GlobalLibraryJS.js" as GlobalLibraryJS




function createCombatants(fightRoleName, showName) {
    //console.debug("[FightScene]createCombatants");
    if(!fightRoleName)
        fightRoleName = "深林孤鹰";
    if(!showName)
        showName = fightRoleName;

    let properties = {
        HP: 200,
        healthHP: 200,
        remainHP: 200,
        MP: 200,
        remainMP: 200,

        attack: 50,
        defense: 50,

        power: 50,
        luck: 50,
        speed: 50,

        EXP: 0, //经验
        level: 0,
        //其他属性
    };

    return {
        name: showName,     //游戏显示名

        properties: properties,


        //fightSkill: null,   //普通攻击
        skills: [],     //技能（魔法）；{id, count}，可以加入其他，比如级别
        //goods: [],      //携带道具  {id, count}
        equipment: {}, //装备；key为position，value为{id: goodsId, count: count}，可以加入其他，比如破损率


        hide: false,        //是否隐藏


        FightRoleName: fightRoleName,  //战斗角色名（包含特效）


        $$propertiesWithEquipment: properties,

        //战斗属性，不会保存
        $$FightData: {
            index: -1,
            teamID: 0,            //0：我方；1：敌人；2：友军
            team: null,
            ActionData: ({}),   //动作数据；key为动作名，value为特效名
            bufferProps: ({}),  //buffer属性

            attackSkill: "",     //攻击选择的技能
            defenseSkill: "",    //防御选择
        }

    };
}



/*
function goodsInfo() {
    return {
        id: "0",  //唯一（文件名）
        name: "",   //名称
        discription: "",    //描述
        image: "",      //图片
        size: [],
        //count: 1,       //个数
        type: 0,    //普通类、食用类、装备类、剧情类
        equipEffectAlgorithm: (function(){}),    //装备效果
        useScript: (function*(){}),     //使用效果
        //holdsScript: (function*(){}),    //持有效果
        throwScript: (function*(){}),    //投掷效果
        //event: (function*(){}),  //事件
    }
}

function skillInfo() {
    return {
        id: "0",  //唯一（文件名）
        name: "",   //名称
        discription: "",    //描述
        //image: "",      //图片
        doSkillEffects, checkSkillData
    }
}
*/



//计算 combatants 装备后的属性 并返回
//equipEffectAlgorithm为某道具装备脚本，参数1为原属性（参照），参数2为变化属性（修改）
function CombatantsPropsWidthGoodsAndEquip(combatants) {
    let newCombatantsProps = GlobalLibraryJS.deepCopyObject(combatants.properties);

    //循环装备
    for(let tg in combatants.equipment) {
        game.objGoods[combatants.equipment[tg].id].equipEffectAlgorithm(combatants.properties, newCombatantsProps);
    }

    /*for(let tg of combatants.holdsScript) {
        for(let te in tg.holdsScript) {
            newCombatantsProps[te] += tg.holdsScript[te];
        }
    }*/

    //console.debug("combatants.$$propertiesWithEquipment", combatants, combatants.$$FightData, combatants.$$propertiesWithEquipment);
    combatants.$$propertiesWithEquipment = newCombatantsProps;

    return newCombatantsProps;
}






//技能效果算法!!!修改
function skillEffectAlgorithm(team1, roleIndex1, team2, roleIndex2, skillEffect) {

    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];
    //let role1Props = CombatantsPropsWidthGoodsAndEquip(role1);
    //let role2Props = CombatantsPropsWidthGoodsAndEquip(role2);
    let role1Props = role1.$$propertiesWithEquipment;
    let role2Props = role2.$$propertiesWithEquipment;

    //伤害
    let harm, t;

    if(GlobalLibraryJS.randTarget(role2Props.luck / 5 + role2Props.speed / 5)) //miss各占%20
    {
        return [{property: "remainHP", value: 0, target: team2[roleIndex2]}];
    }

    //计算攻击：攻击-防御
    harm = role1Props.attack - role2Props.defense;


    t = role1Props.attack;
    t = t * GlobalLibraryJS.random(role1Props.power, role1Props.power*2) / 1000; //灵力1~2倍 //攻击+灵力效果
    harm = harm + t;
    t = role1Props.attack;
    t = t * GlobalLibraryJS.random(10, role1Props.luck/10+1) / 1000 ; //吉运效果 千分之一到十分之一
    harm = harm + t;
    t = role2Props.defense;
    t = t * GlobalLibraryJS.random(role2Props.power/2, role2Props.power) / 1000; //防御+灵力效果
    harm = harm - t;
    t = role2Props.defense;
    t = t * GlobalLibraryJS.random(10, role2Props.luck/10+1) / 1000; //吉运效果
    harm = harm - t;


    harm = Math.floor(harm);
    if(harm <= 0)harm = GlobalLibraryJS.random(0, 10);

    role2.properties.healthHP -= Math.floor(harm / 4);
    role2.properties.remainHP -= harm;

    //console.debug("damage1");
    return [{property: "remainHP", value: harm, target: team2[roleIndex2]}];
}

//战斗开始通用脚本；
function *commonFightStartScript() {
    let fight = this.fight;
    yield fight.msg("战斗开始通用脚本", "", 100, 1);
}

//战斗回合通用脚本；
function *commonFightRoundScript(round) {
    let fight = this.fight;
    yield fight.msg("战斗回合通用脚本" + round, "", 100, 1);
}

//战斗结束通用脚本；
function *commonFightEndScript(result, exp, money) {
    let game = this.game;
    let fight = this.fight;
    if(result === 1) {
        yield fight.msg("战斗胜利<BR>获得  %1经验，%2金钱".arg(exp).arg(money), "", 100, 1);
        //fight.run('');
    }
    else {
        yield fight.msg("战斗失败<BR>获得  %1经验，%2金钱".arg(exp).arg(money), "", 100, 1);
        //fight.run('fight.popmusic();s_FightOver();'.arg(exp).arg(money));
    }
    game.money(money);
    for(var r in fight.myCombatants) {
        fight.myCombatants[r].EXP += exp;
    }
    game.popmusic();
    fight.over();
}

//恢复算法
function resumeEventScript(hero) {

    if(hero.properties.remainHP === 0)
        return;

    hero.properties.remainHP += 10;
    if(hero.properties.remainHP > hero.properties.healthHP)
        hero.properties.remainHP = hero.properties.healthHP;

    hero.properties.remainMP += 10;
    if(hero.properties.remainMP > hero.properties.MP)
        hero.properties.remainMP = hero.properties.MP;
}

//得到道具通用脚本
function *commonGetGoodsScript(goodsName) {
    let game = this.game;

    //yield game.msg("得到【%1】".arg(game.objGoods[goodsId].name), true);
    yield game.msg("得到【%1】".arg(goodsName), true);
}

//使用道具通用脚本
function *commonUseGoodsScript(goodsName, type) {
    let game = this.game;

    switch(type) {
    case 0:
        //yield game.msg("不能使用【%1】".arg(game.objGoods[goodsId].name), true);
        yield game.msg("得到【%1】".arg(goodsName), true);
        break;
    default:
    }
}






//升级脚本
function *levelUpScript(hero) {

    let level = 0;  //当前经验可达到的级别
    let nextExp = 10;   //下一级别的经验

    //升级条件
    while(nextExp <= hero.properties.EXP) {
        nextExp = nextExp * 2;
        ++level;
    }

    //升级结果
    while(level > hero.properties.level) {
        ++hero.properties.level;

        hero.properties.HP += parseInt(hero.properties.HP * 0.1);
        hero.properties.healthHP = hero.properties.HP;
        hero.properties.remainHP = hero.properties.HP;
        hero.properties.MP += parseInt(hero.properties.MP * 0.1);
        hero.properties.remainMP = hero.properties.MP;

        hero.properties.attack += parseInt(hero.properties.attack * 0.1);
        hero.properties.defense += parseInt(hero.properties.defense * 0.1);

        hero.properties.power += parseInt(hero.properties.power * 0.1);
        hero.properties.luck += parseInt(hero.properties.luck * 0.1);
        hero.properties.speed += parseInt(hero.properties.speed * 0.1);

        /*game.run(
            'yield game.msg("%1升为%2级");'.arg(hero.name).arg(hero.properties.level)
        );*/
        yield game.msg("%1升为%2级".arg(hero.name).arg(hero.properties.level));
    }
    return level;
}

//级别对应的经验算法
function levelAlgorithm(hero, targetLevel) {
    if(targetLevel <= 0)
        return 0;

    let level = 1;  //级别
    let exp = 10;   //级别的经验

    while(level < targetLevel) {
        exp = exp * 2;
        ++level;
    }
    return {EXP: exp};
}






/*
function propertyName(prop) {
    switch(prop) {
    case 0:
        return "乱风";
    case 1:
        return "眠土";
    case 2:
        return "雷电";
    case 3:
        return "毒水";
    case 4:
        return "豪火";
    }
}

function skillEffectAlgorithm1(team1, roleIndex1, team2, roleIndex2, skillEffect) {
    //console.debug("damage0", team1, roleIndex1, team2, roleIndex2, skillEffect);

    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];

    //伤害
    let harm, t;

    if(GlobalLibraryJS.randTarget(role2.luck / 5 + role2.speed / 5)) //miss各占%20
    {
        return [{property: "remainHP", value: 0, target: team2[roleIndex2]}];
    }

    //计算攻击
    harm = t = role1.attack;


    let PropFlag = 0;
    var attackPropValue = role1.properties[role1.$$FightData.attackProp]; //攻击属性 的 值

    if((role1.$$FightData.attackProp + 1) % 5 === role2.$$FightData.defenseProp)        //属性攻击成功
    {
        PropFlag = 1;
    }
    else if((role2.$$FightData.attackProp + 1) % 5 === role1.$$FightData.defenseProp)   //失败
    {
        PropFlag = -1;
    }

    if(PropFlag === 1)  //附加使用成功
    {
        if(role1.$$FightData.attackProp === 2)  //雷属性
        {
            harm = t * GlobalLibraryJS.random(attackPropValue + 1,attackPropValue * 4 + 1) / 100 + t;  //max <5倍
        }
        else   //其他属性
        {
            harm = t * GlobalLibraryJS.random(attackPropValue + 1,attackPropValue * 2 + 1) / 100 + t;  //属性效果 <3倍
        }
    }
    else if(PropFlag === -1) //失败
    {
        harm = t - t * GlobalLibraryJS.random((100 - attackPropValue) * 2,(100 - attackPropValue) * 5) / 500;  //属性效果 减小
    }
    else
        if(role1.$$FightData.attackProp === 2) //雷,且无作用
            harm = t * GlobalLibraryJS.random(attackPropValue / 2,attackPropValue + 1) /100 + t;  //max <5倍


    //计算防御
    //中 防御降低
    t = role2.defense;
    if(role2.$$FightData.bufferProps.defenceDown !== 0) //对方中火
    {
        t = t * GlobalLibraryJS.random(2, 50) / 100;
    }

    harm = harm - t;  //攻击-防御
    t = role1.attack;
    t = t * GlobalLibraryJS.random(role1.power, role1.power*2) /10000; //灵力1~2倍 //攻击+灵力效果
    harm = harm + t;
    t = role1.attack;
    t = t * GlobalLibraryJS.random(10,role1.luck / 10+1) /10000 ; //吉运效果 千分之一到十分之一
    harm = harm + t;
    t = role2.defense;
    t = t * GlobalLibraryJS.random(role2.power / 2,role2.power) /10000; //防御+灵力效果
    harm = harm - t;
    t = role2.defense;
    t = t * GlobalLibraryJS.random(10,role2.luck / 10+1) /10000; //吉运效果
    harm = harm - t;


    harm = Math.floor(harm)
    if(harm <= 0)harm = GlobalLibraryJS.random(0, 10);

    role2.remainHP -= harm;

    //console.debug("damage1");
    return [{property: "remainHP", value: harm, target: team2[roleIndex2]}];
}
*/
