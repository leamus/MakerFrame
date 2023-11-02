//.pragma library //单例（只有一个实例的共享脚本，且没有任何QML文件的环境。如果不加这句，则每个引入此文件的QML都有一个此文件的实例，且环境为引入的QML文件环境）。
//库文件不能使用 导入它的QML的上下文环境，包括C++注入的对象 和 注册的类，但全局对象可以（比如Qt）；给js全局对象注入的属性也可以（比如FrameManager.globalObject().game = game）。


//.import "xxx.js" as Abc       //导入另一个js文件（必须有as，必须首字母大写）
//.import "GlobalLibrary.js" as GlobalLibraryJS
//.import "Global.js" as GlobalJS
//let jsLevelChain = JSLevelChain;    //让外部可访问


//.import QtQuick.Window 2.14 as Window   //导入QML模块（必须有as，必须首字母大写）
//  （非库文件：如果没有任何.import语句，则貌似可以直接使用 QML组件，如果有一个.import，则必须导入每个对应组件才可以使用QML组件!!!）



/*
技能选择系统：
  1、目前只有两种选择：战斗人物和菜单（Type分别为1和2）；
  2、如果要新增类型，则：
    a、Type为3及以上
    b、在选择后调用 _private.skillChoice(n, 值);，表示进行下一个选择步骤
    c、skillSetUsing 函数里加上Type判断，且进行选择步骤的初始化，返回false表示等待，返回true表示不等待；
    d、skillChoiceCanUsing 函数里加上Type判断，且将进行选择步骤的所有可能性返回（供自动调用使用，比如敌方）；返回false表示没有选择对象；返回true表示此次选择步骤不需要选择；
      如果是我方，则会将 已经选择过的步骤值 压栈作为 第一次选择 来判断（如果不符合则会依次判断栈内容）
*/


//系统的单人技能(选择对方）
//yield返回参数对象：Type（选择类型）、Step（第几个步骤，实际用来：1、此步骤的值在$targets的下标；2、战斗时 获取我方战斗人物的lastChoice.$targets[step]步骤的值 再次判断）；TeamFlags（队伍标记）、Filter（战斗人物筛选）、Enabled（是否可选）
//  Type为1：选择战斗人物
//    yield入参：TeamFlags：0b1为己方；0b10为对方；Filter（筛选函数）；Enabled：设置选择标记还是取消选择
//  Type为2：弹出选择菜单
//    yield入参：Title（菜单标题）；Items（选项）；Style（样式）；
//yield false：表示选择失败并重新进行此轮选择
//返回true表示选择完毕并成功
function *gfChoiceSingleCombatantSkill(skill, combatant, params={TeamFlags: 0b11, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}}) {
    //FightSceneJS.setTeamReadyToChoice(0b10, 0b1, true);

    //战斗人物选择
    let c = yield {Type: 1, Step: 0, TeamFlags: params.TeamFlags, Filter: params.Filter, Enabled: true};

    //判断是否符合条件
    /*while(1) {
        if(c.Value && c.Value.$properties.HP[0] > 0)
            break;
        else
            yield false;
    }
    */

    combatant.$$fightData.$choice.$targets = [[c.Value]];

    //取消 战斗人物选择状态
    yield {Type: 1, TeamFlags: params.TeamFlags, Filter: params.Filter, Enabled: false};


    //返回true表示选择完毕并成功
    return true;
}

//不用选择（比如多人技能）
//yield false：表示选择失败并重新进行此轮选择
//返回true表示选择完毕并成功
function *gfNoChoiceSkill(skill, combatant) {
    combatant.$$fightData.$choice.$targets = [-1];


    //菜单示例
    //let c = yield {Type: 2, Step: 1, Title: '深林孤鹰', Items: [1,2,3,4,5]};
    //console.warn(c, JSON.stringify(c));
    //combatant.$$fightData.$choice.$targets.push(c.Value);


    //yield false;

    //返回true表示选择完毕并成功
    return true;
}



//战斗人物 已选择的 技能或道具 处理
//  我方的技能如果不能使用，切换为普通攻击；敌方随机使用技能
//返回 <0 表示休息不使用技能（比如所有技能都不能用、休息等）
function combatantUseSkillOrGoods(combatant) {

    //所有可使用的技能或道具 数组（倒序使用）
    let useSkillsOrGoods;
    //选择的技能或道具
    let choiceSkillOrGoods;
    let skill;


    //我方
    if(combatant.$$fightData.$info.$teamsID[0] === 0) {
        //检查技能

        //休息
        if(combatant.$$fightData.$choice.$type === 1)
            return -1;

        //所有普通技能作为备选
        useSkillsOrGoods = _private.getCombatantSkills(combatant, [0])[1];

        //普通攻击或技能
        if(combatant.$$fightData.$choice.$type === 3) {

            //判断技能是否可用，不能用则 $choice.$type = -2 随机选择
            do {
                //是否有这个技能
                let bFind = false;
                let allSkills = _private.getCombatantSkills(combatant)[1];
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
                if(combatant.$$fightData.$choice.$attack.$type !== 0)
                    useSkillsOrGoods.push(combatant.$$fightData.$choice.$attack);

            }while(0);

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

            }while(0);
        }
        //其他类型（-1和-2）
        else {
            combatant.$$fightData.$choice.$type = -2;
            //combatant.$$fightData.$choice.$attack = -1;
            //console.warn('[!FightScene]', combatant.$$fightData.$choice.$type)
        }

    }

    //敌人
    else if(combatant.$$fightData.$info.$teamsID[0] === 1) {
        //敌人 选择技能
        //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击：OK

        useSkillsOrGoods = game.$sys.resources.commonScripts["enemy_choice_skills_algorithm"](combatant);
    }



    //!循环测试所有技能，直到有可以用的
    //对我方来说检查一次
    useNextSkill:
    while(1) {
        choiceSkillOrGoods = useSkillsOrGoods.pop();    //从最后开始
        if(!choiceSkillOrGoods) //没有技能了
            return -1;


        combatant.$$fightData.$choice.$attack = choiceSkillOrGoods;
        if(choiceSkillOrGoods.$objectType === 3)
            combatant.$$fightData.$choice.$type = 3;
        else if(choiceSkillOrGoods.$objectType === 2)
            combatant.$$fightData.$choice.$type = 2;

        //检测技能 或 道具是否可以使用
        let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](choiceSkillOrGoods, combatant, 10);
        if(GlobalLibraryJS.isString(checkSkill)) {   //如果不可用
            //fight.msg(checkSkill || "不能使用", 50);
            continue;
        }
        else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果不可用
            //fight.msg(...checkSkill);
            continue;
        }
        else if(checkSkill !== true) {   //如果不可用
            //fight.msg("不能使用", 50);
            continue;
        }


        let genFightChoice = null;


        //普通攻击 或 技能
        if(choiceSkillOrGoods.$objectType === 3) {
            skill = choiceSkillOrGoods;
            if(/*skill && */skill.$commons.$choiceScript)
                genFightChoice = skill.$commons.$choiceScript(skill, combatant);
            //else if(!skill) {   //如果不可用
            //    continue;
            //}
        }
        //道具
        else if(choiceSkillOrGoods.$objectType === 2) {
            let goods = combatant.$$fightData.$choice.$attack;
            if(GlobalLibraryJS.isArray(goods.$fight))
                skill = goods.$fight[0];
            //有一种情况为空：道具没有对应技能（$fight[0]），只运行收尾代码（$fightScript[3]）；
            //if(!skill)
            //    skill = {$targetCount: 0, $targetFlag: 0};

            //如果有 $fightScript 和 $choiceScript
            if(GlobalLibraryJS.isObject(goods.$commons.$fightScript) && goods.$commons.$fightScript.$choiceScript) {
                genFightChoice = goods.$commons.$fightScript.$choiceScript(goods, combatant);
            }
            //!!兼容旧代码
            else if(GlobalLibraryJS.isArray(goods.$commons.$fightScript) && goods.$commons.$fightScript[0]) {
                genFightChoice = goods.$commons.$fightScript[0](goods, combatant);
            }
            //使用技能的
            else if(/*skill && */skill.$commons.$choiceScript)
                genFightChoice = skill.$commons.$choiceScript(skill, combatant);
            //else if(!skill) {   //如果不可用
            //    continue;
            //}
        }

        //如果没有特定定义的 $choiceScript选择脚本，则使用系统的
        if(!genFightChoice) {
            //单人技能 且 目标敌方
            if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b10)) {
                genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}});
            }

            //目标己方
            else if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b1)) {
                genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b1, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}});
            }

            //不选（全体）
            //if(skill.$targetFlag === 0) {
            else if(skill.$targetCount <= 0) {
                genFightChoice = FightSceneJS.gfNoChoiceSkill(skill, combatant);
            }
            else {   //不可用
                continue;
            }
        }



        let ret = genFightChoice.next();

        //循环 技能中的每一个选择
        nextFightChoice:
        for(;;) {
            if(ret.done === true) { //选择完毕

                //if(_private.nChoiceFightRoleIndex < 0 || _private.nChoiceFightRoleIndex >= _private.myCombatants.length)
                //    return;


                //检测技能 或 道具是否可以使用
                let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](choiceSkillOrGoods, combatant, 11);
                if(GlobalLibraryJS.isString(checkSkill)) {   //如果不可用
                    //fight.msg(checkSkill || "不能使用", 50);
                    break;
                }
                else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果不可用
                    //fight.msg(...checkSkill);
                    break;
                }
                else if(checkSkill !== true) {   //如果不可用
                    //fight.msg("不能使用", 50);
                    break;
                }


                //if(_private.nStage === 1)
                //    checkToFight();
                return 0;
            }
            else {
                //所有可能的选择
                let selecting = skillChoiceCanUsing(ret.value, combatant);

                if(selecting === false)   //没有选择
                    break;
                else if(selecting === true) { //不需要选择，直接下一个 技能的选择步骤
                    ret = genFightChoice.next();
                    continue;
                }


                //循环每一个备选择的
                for(;;) {
                    let tv = selecting.pop();
                    if(tv === undefined)    //循环完毕
                        continue useNextSkill;


                    let tRet = genFightChoice.next({Type: ret.value.Type, Value: tv});

                    if(tRet.value === false) {   //重新选择
                        continue;
                    }

                    ret = tRet;
                    continue nextFightChoice;
                }

            }
        }
    }





    /*/修正 目标战斗角色

    //if(choiceSkillOrGoods.$targetFlag === 0)
    if(choiceSkillOrGoods.$targetCount <= 0)
        combatant.$$fightData.$choice.$targets = -1;


    //单人，对方
    if((choiceSkillOrGoods.$targetCount > 0 || GlobalLibraryJS.isArray(choiceSkillOrGoods.$targetCount)) && (choiceSkillOrGoods.$targetFlag & 0b10)) {

        //如果角色选择了目标，且目标还活着（否则随机选）
        if(GlobalLibraryJS.isArray(combatant.$$fightData.$choice.$targets)) {
            if(combatant.$$fightData.$choice.$targets[0].$properties.HP[0] <= 0) {
                combatant.$$fightData.$choice.$targets = undefined;
            }
        }
        else
            combatant.$$fightData.$choice.$targets = undefined;


        //如果没有指定对方，则随机选
        if(combatant.$$fightData.$choice.$targets === undefined) {
            //获得 对方还活着的 角色
            let tarrAlive = [];
            for(let tc of combatant.$$fightData.$info.$teams[1]) {
                if(tc.$properties.HP[0] > 0)
                    tarrAlive.push(tc);
            }
            //随机选择对方
            //combatant.$$fightData.defenseProp = combatant.$$fightData.attackProp = GlobalLibraryJS.random(0, 5);

            combatant.$$fightData.$choice.$targets = [tarrAlive[GlobalLibraryJS.random(0, tarrAlive.length)]];
            //console.debug("t1", t, JSON.stringify(team2));

            //roleSpriteEffect2 = repeaterSpriteEffect2.itemAt(combatant.$$fightData.$choice.$targets[0].$$fightData.$info.$index);
        }

        //console.debug("!!!", combatant.$$fightData.$choice.$targets)
    }

    //单人，己方
    if((choiceSkillOrGoods.$targetCount > 0 || GlobalLibraryJS.isArray(choiceSkillOrGoods.$targetCount)) > 0 && (choiceSkillOrGoods.$targetFlag & 0b1)) {

        //如果角色选择了目标（可以选择死亡角色）（否则随机选）
        if(GlobalLibraryJS.isArray(combatant.$$fightData.$choice.$targets)) {
            if(combatant.$$fightData.$choice.$targets[0].$properties.HP[0] <= 0) {
                //combatant.$$fightData.$choice.$targets = undefined;
            }
        }
        else
            combatant.$$fightData.$choice.$targets = undefined;

        if(combatant.$$fightData.$choice.$targets === undefined) {
            //获得 己方还活着的 角色
            let tarrAlive = [];
            for(let tc of combatant.$$fightData.$info.$teams[0]) {
                if(tc.$properties.HP[0] > 0)
                    tarrAlive.push(tc);
            }
            //随机选择对方
            //combatant.$$fightData.$info.defenseProp = combatant.$$fightData.$info.attackProp = GlobalLibraryJS.random(0, 5);

            combatant.$$fightData.$choice.$targets = [tarrAlive[GlobalLibraryJS.random(0, tarrAlive.length)]];
            //console.debug("t1", t, JSON.stringify(team2));

            //roleSpriteEffect2 = repeaterSpriteEffect1.itemAt(combatant.$$fightData.$choice.$targets[0].$$fightData.$info.$index);
        }

        //console.debug("!!!", combatant.$$fightData.$choice.$targets)
    }

    */
}



//设置 某个 team 的所有 战斗人物 是否可点 并 设置效果
//teamFlags:0b1为我方，0b10为敌方；
//filter：战斗人物筛选函数；
//enabled：true为可选，false为取消可选；
//combatant：正在进行选择的战斗人物，有可能为null
function setTeamReadyToChoice(teamFlags, filter, enabled, combatant) {
    if(!filter)
        filter = function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}

    if(enabled) {
        if(teamFlags & 0b1) {
            for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if((_private.myCombatants[i].$properties.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (_private.myCombatants[i].$properties.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(_private.myCombatants[i], combatant)
                ) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                    repeaterMyCombatants.itemAt(i).colorOverlayStart(["#00000000", "#7FFFFFFF", "#00000000"]);
                    repeaterMyCombatants.itemAt(i).bCanClick = true;
                }
            }
        }
        if(teamFlags & 0b10) {
            for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if((_private.enemies[i].$properties.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (_private.enemies[i].$properties.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(_private.enemies[i], combatant)
                ) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                    repeaterEnemies.itemAt(i).colorOverlayStart(["#00000000", "#7FFFFFFF", "#00000000"]);
                    repeaterEnemies.itemAt(i).bCanClick = true;
                }
            }
        }
    }
    else {
        if(teamFlags & 0b1) {
            //全部取消闪烁
            for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    repeaterMyCombatants.itemAt(i).colorOverlayStop();
                    repeaterMyCombatants.itemAt(i).bCanClick = false;
                }
            }
        }
        if(teamFlags & 0b10) {
            //全部取消闪烁
            for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                if(_private.enemies[i].$properties.HP[0] > 0) {
                    repeaterEnemies.itemAt(i).colorOverlayStop();
                    repeaterEnemies.itemAt(i).bCanClick = false;
                }
            }
        }
    }
}



//设置 技能步骤 需要的对象（目前只有战斗人物和菜单），手动选择需要
//params为参数，combatant为正在进行选择的战斗人物
//返回true表示不需要等待选择，返回false表示需要等待选择
//  !!新增技能选择类型，在这里新增
function skillSetUsing(params, combatant) {
    if(params.Type === 1) {
        let team0Flag, team1Flag;   //己方和对方
        if(combatant.$$fightData.$info.$teamsID[0] === 0) {
            team0Flag = 0b1;
            team1Flag = 0b10;
        }
        else {
            team0Flag = 0b10;
            team1Flag = 0b1;
        }

        //己方
        if(params.TeamFlags & 0b1) {
            FightSceneJS.setTeamReadyToChoice(team0Flag, params.Filter, params.Enabled, combatant);
        }
        //对方
        if(params.TeamFlags & 0b10) {
            FightSceneJS.setTeamReadyToChoice(team1Flag, params.Filter, params.Enabled, combatant);
        }

        //设置为可选，则返回等待选择
        if(params.Enabled) {

            return false;
        }
        //取消选择，则继续
        else {

            //ret = _private.genFightChoice.next();

            return true;
        }
    }
    //选择菜单
    else if(params.Type === 2) {
        fight.choicemenu(params.Title, params.Items, params.Style);

        return false;
    }

    else {
        console.warn('[!FightScene]没有这种选择');
        return false;
    }
}


//根据params，返回 技能步骤所需的所有可选 对象（目前只有战斗人物和菜单）
//  如果是我方，注意要把已经选择的压入到selecting的最后一个（注意要使用$lastChoice,因为$choice会被 再次运行的技能步骤生成器 重新赋值）；
//  1、开始战斗时，我方会调用 技能选择生成器 来再次检查一次（并调整是否可用）；2、自动选择或敌人会调用
//params为参数，combatant为正在进行选择的战斗人物
//  !!新增技能选择类型，在这里新增
function skillChoiceCanUsing(params, combatant) {
    //所有可选的对象
    let selecting = [];

    //选择战斗人物
    if(params.Type === 1) {
        if(params.Enabled) {

            //己方
            if(params.TeamFlags & 0b1) {
                //team.push(...combatant.$$fightData.$info.$teams[0]);
                for(let tc of combatant.$$fightData.$info.$teams[0]) {
                    //if((tc.$properties.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$properties.HP[0] <= 0 && (params.CombatantFlags & 0b10))
                    if(params.Filter(tc, combatant)
                    )
                        selecting.push(tc);
                }
            }
            //对方
            if(params.TeamFlags & 0b10) {
                //team.push(...combatant.$$fightData.$info.$teams[1]);
                for(let tc of combatant.$$fightData.$info.$teams[1]) {
                    //if((tc.$properties.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$properties.HP[0] <= 0 && (params.CombatantFlags & 0b10))
                    if(params.Filter(tc, combatant)
                    )
                        selecting.push(tc);
                }
            }

            selecting = GlobalLibraryJS.disorderArray(selecting);

            //如果是我方且已经有目标，则压入备选（注意要使用$lastChoice,因为$choice会被 再次运行的技能步骤生成器 重新赋值）
            if(combatant.$$fightData.$info.$teamsID[0] === 0
                    && GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets)
                    && GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets[params.Step])
                    ) {
                //selecting.push(...combatant.$$fightData.$lastChoice.$targets);

                //循环每个选择的战斗人物，并根据条件来压入 上次选择的
                for(let tc of combatant.$$fightData.$lastChoice.$targets[params.Step]) {
                    //if((tc.$properties.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$properties.HP[0] <= 0 && (params.CombatantFlags & 0b10))
                    if(params.Filter(tc, combatant)
                    ) {
                        selecting.push(tc);
                    }
                }
            }
        }
        //取消人物选择状态，则不处理
        else {
            //ret = genFightChoice.next();

            return true;
        }
    }
    //选择菜单
    else if(params.Type === 2) {
        //可选择 的是 0 到 Items的长度
        selecting = [...new Array(params.Items.length).keys()];

        //如果是我方且已经有目标，则压入备选（注意要使用$lastChoice,因为$choice会被 再次运行的技能步骤生成器 重新赋值）
        if(combatant.$$fightData.$info.$teamsID[0] === 0
                && GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets)
                && GlobalLibraryJS.isValidNumber(combatant.$$fightData.$lastChoice.$targets[params.Step])
                ) {
            selecting.push(combatant.$$fightData.$lastChoice.$targets[params.Step]);
        }
    }

    else {
        console.warn('[!FightScene]没有这种选择');
        return false;
    }

    return selecting;
}






//重置刷新战斗人物（创建时调用）
function resetFightRole(fighthero, fightheroSpriteEffect, index, teamID) {

    fightheroSpriteEffect.propertyBar.refresh(fighthero.$properties.HP);
    fightheroSpriteEffect.strName = fighthero.$name;



    //if(i >= repeaterMyCombatants.count)
    //    break;
    //console.debug("!!!", _private.myCombatants, i, fighthero, JSON.stringify(fighthero));
    if(!fighthero.$$fightData)
        fighthero.$$fightData = {};

    //fighthero.$$fightData.$actionData = {};
    //fighthero.$$fightData.$buffs = {};
    ////_private.myCombatants.$rid = fightScriptData.$enemiesData[tIndex].$rid;

    fighthero.$$fightData.$info = {};
    fighthero.$$fightData.$info.$index = parseInt(index);
    if(teamID === 0) {    //我方
        fighthero.$$fightData.$info.$teamsID = [0, 1];
        fighthero.$$fightData.$info.$teams = [_private.myCombatants, _private.enemies];
        fighthero.$$fightData.$info.$teamsSpriteEffect = [repeaterMyCombatants, repeaterEnemies];

        game.$sys.resources.commonScripts["fight_combatant_choice"](fighthero, -1, false);
    }
    else if(teamID === 1) { //敌方
        fighthero.$$fightData.$info.$teamsID = [1, 0];
        fighthero.$$fightData.$info.$teams = [_private.enemies, _private.myCombatants];
        fighthero.$$fightData.$info.$teamsSpriteEffect = [repeaterEnemies, repeaterMyCombatants];

        game.$sys.resources.commonScripts["fight_combatant_choice"](fighthero, -1, true);
        //_private.enemies[i].$rid = fightScriptData.$enemiesData[tIndex].$rid;

    }

    fighthero.$$fightData.$info.$spriteEffect = fightheroSpriteEffect;

    //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))

    //fighthero.$$fightData.$choice.$type = -1;
    ////fighthero.$$fightData.$lastChoice.$type = -1;
    //fighthero.$$fightData.$choice.$attack = undefined;
    ////fighthero.$$fightData.$lastChoice.$attack = undefined;
    //这两句必须，否则会指向不存在的对象（比如第一场结束前选第4个敌人，第二场直接重复上次就出错了）；
    //fighthero.$$fightData.$choice.$targets = undefined;
    //fighthero.$$fightData.$lastChoice.$targets = undefined;

    //fighthero.$$fightData.defenseSkill = undefined;
    //fighthero.$$fightData.lastDefenseSkill = undefined;


    /*/读取ActionData
    let fightroleInfo = game.$sys.getFightRoleResource(fighthero.$rid);
    if(fightroleInfo) {
        for(let tn in fightroleInfo.ActionData) {
            fighthero.$$fightData.$actionData[fightroleInfo.ActionData[tn].ActionName] = fightroleInfo.ActionData[tn].SpriteName;
        }
    }
    else
        console.warn("[!FightScene]载入战斗精灵失败：" + fighthero.$rid);
    */



    _private.refreshFightRoleAction(fighthero, "Normal", AnimatedSprite.Infinite);

    //刷新血条
    //if(fighthero.$properties.HP[0] <= 0)
    //    fighthero.$properties.HP[0] = 1;
}






/*/读 role战斗角色 的 属性 和 所有Action 到 role
function readFightRole(role) {
    //console.debug("[FightScene]readFightRole");

    let data = game.$sys.getFightRoleResource(role.$rid);
    if(data) {
        GlobalLibraryJS.copyPropertiesToObject(role, data.$createData());

        for(let tn in data.ActionData) {
            role.$$fightData.$actionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
        }

        return true;
    }
    else
        console.warn("[!FightScene]载入战斗精灵失败：" + role.$rid);


    /*let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + role.$rid + GameMakerGlobal.separator + "fight_role.json";

    //console.debug("[FightScene]filePath：", filePath);

    //let data = File.read(filePath);
    let data = FrameManager.sl_qml_ReadFile(filePath);

    if(data !== "") {
        data = JSON.parse(data);

        GlobalLibraryJS.copyPropertiesToObject(role, data.Property);

        for(let tn in data.ActionData) {
            role.$$fightData.$actionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
        }

        return true;
    }
    else
        console.warn("[!FightScene]载入战斗精灵失败：" + filePath);

    return false;
    * /
}*/



//读取技能文件
function loadFightSkillInfo(fightSkillName) {
    //console.debug("[FightScene]loadFightSkillInfo0");
    return game.$sys.getSkillResource(fightSkillName);

    /*if(fightSkillName) {

        /*let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + "fight_skill.json";
        //let data = File.read(filePath);
        //console.debug("[GameFightSkill]filePath：", filePath);

        let data = FrameManager.sl_qml_ReadFile(filePath);

        if(data !== "") {
            data = JSON.parse(data);
            //console.debug("data", data);
            try {
                data = GlobalJS._eval(data.FightSkill);
            }
            catch(e) {
                GlobalJS.PrintException(e);
                return false;
            }
            return data;
        }
        else
            console.warn("[!FightScene]Load Skill Fail:", filePath);
        * /
        let data = game.loadjson(GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + "fight_skill.json");
        if(data) {
            return GlobalJS._eval(data.FightSkill);
        }
    }
    return undefined;
    */
}

//获取 某战斗角色 中心位置
/*/teamID、index是战斗角色的；cols表示有几列（战场分布）；
function getCombatantPosition(teamID, index, cols=4) {
    //let teamID = combatant.$$fightData.$info.$teamsID[0];
    //let index = combatant.$$fightData.$info.$index;

    if(teamID === 0) {    //我方
        return Qt.point(itemRolesContainer.width / cols, itemRolesContainer.height * (index + 1) / (repeaterMyCombatants.nCount + 1));
    }
    else {  //敌方
        return Qt.point(itemRolesContainer.width * (cols-1) / cols, itemRolesContainer.height * (index + 1) / (repeaterEnemies.nCount + 1));
    }
}
*/



/*/没什么用了
function doSkillEffect(team1, roleIndex1, team2, roleIndex2, skillEffect) {
    //!!!!!!修改：加入team效果
    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];

    let skillEffectResult = game.$sys.resources.commonScripts["fight_skill_algorithm"](team1, roleIndex1, team2, roleIndex2, skillEffect);
    //for(let t in skillEffectResult) {
    //}
    return skillEffectResult;
}

//显示伤害文字，并设置伤害
function doSkillEffect1(team1, roleIndex1, team2, roleIndex2, skillEffect) {
    //console.debug("[FightScene]doSkillEffect");
    //console.debug(team1, roleIndex1, team2, roleIndex2, skillEffect);
    //console.debug(JSON.stringify(_private.myCombatants), JSON.stringify(_private.enemies))

    //!!!!!!修改
    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];

    let name1, name2
    let harm;
    let str;

    /*if(role1["name"] === "$$$") {
        name1 = "你";
    }
    else if(role1["name"] === 0) {
        name1 = "敌人";
    }
    else {
        name1 = FrameManager.getPlayerInfo(role1["GroupIndex"]).nickname;
    }* /
    name1 = role1.$name || "无名";

    /*if(role2["GameUserID"] === UserInfo.gameUserID) {
        name2 = "你";
    }
    else if(role2["GameUserID"] === 0) {
        name2 = "敌人";
    }
    else {
        name2 = FrameManager.getPlayerInfo(role2["GroupIndex"]).nickname;
    }* /
    name2 = role2.$name || "无名";

    //console.debug(Global.frameData.arrayPets)
    //console.debug(Global.frameData.arrayPets[0])
    //console.debug(Global.frameData.arrayPets[0].$$fightData.attackProp)
    //console.debug("debug1:", data2.choice)

    //Global.frameData.arrayEnemyPets[0].$$fightData.defenseProp = Global.frameData.arrayEnemyPets[0].$$fightData.attackProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)
    //Global.frameData.arrayEnemyPets[0].$$fightData.defenseProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)

    msgbox.textArea.append(name1 + "使用【" + GameMakerGlobalJS.propertyName(role1.$$fightData.attackProp) + "】攻击");
    msgbox.textArea.append(name1 + "使用【" + GameMakerGlobalJS.propertyName(role1.$$fightData.defenseProp) + "】防御");
    //msgbox.textArea.append(name2 + "使用" + role2.$$fightData.attackProp + "攻击");
    //msgbox.textArea.append(name2 + "使用" + role2.$$fightData.defenseProp + "防御");


    harm = game.$sys.resources.commonScripts["fight_skill_algorithm"](team1, roleIndex1, team2, roleIndex2, skillEffect);


    str = "属性使用";
    if(harm.propertySuccess === 1)str += "成功";
    else if(harm.propertySuccess === -1)str += "失败";
    else str += "无效果";
    str += ",%1把%2揍了".arg(name1).arg(name2) + harm.harm + "血";
    msgbox.textArea.append(str);

    role2.$properties.HP[0] -= harm.harm;
    if(role2.$properties.HP[0] <= 0) {
        role2.$properties.HP[0] = 0;
        //role1.$properties.HP[0] = role1.$properties.HP[2];
        //role2.$properties.HP[0] = role2.$properties.HP[2];
        //msgbox.textArea.append("战斗胜利");
        return {};
    }


    msgbox.textArea.append("--------------------------");
    return 0;
}
*/
