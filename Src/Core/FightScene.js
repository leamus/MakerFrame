
/*
技能选择系统：
  原理：
  步骤：
    1、进入战斗，先init（做初始化，创建战斗人物、调用start脚本、创建genFighting，进入gfFighting循环）；
    2、gfFighting中：
      a、运行 runCombatantRoundScript 战斗人物回合脚本（处理buff等）；
      b、检查战斗是否结束；
      c、调用 round 回合脚本；
      d、我方开始战斗选择和步骤；
      e、调用 round 回合脚本；
      f、运行战斗人物回合 fnRound；
    3、我方开始战斗选择和步骤：
      a、如果 _private.genFightChoice 为null，则弹出 选择菜单；
      b、点击 选择菜单后，根据通用脚本的$fightMenus，分别调用 fight.$sys.showSkillsOrGoods（0、1、2分别是普通攻击、技能、物品）、休息；
      c、选择 技能或道具后，调用 FightSceneJS.choicedSkillOrGoods，进行判断是否可用，并赋值_private.genFightChoice，进入skillChoice；
      d、skillChoice：技能步骤选择完后进行的处理（_private.genFightChoice），选择完毕后再次判断是否可用，并检测是否可以战斗；
      e、点人物：如果 _private.genFightChoice 已经有值 且 人物可点，则调用FightSceneJS.skillChoice；
    4、我方选择完毕后，进行战斗回合：yield *fnRound();
      a、调用 通用脚本的fight_roles_round脚本，对每一次返回的战斗人物进行一次战斗人物回合；
      b、调用一次 runCombatantRoundScript；
      c、调用 FightSceneJS.combatantUseSkillOrGoods(combatant)；
      d、调用一次 runCombatantRoundScript；
      e、进行 技能的动画播放、道具收尾 和数据处理；
      f、检测是否结束战斗；
    5、combatantUseSkillOrGoods：
      a、调用 通用脚本 fight_role_choice_skills_or_goods_algorithm 的算法，返回我方（将已选的放在最优先）或敌方能使用技能的数组，返回1不做处理（比如乱）；
      b、将返回的技能数组遍历，检查是否可用，并将技能步骤检查一次（比如有可能已选的对方已下场，则重新自动选择），每个步骤都会返回所有可选可能性数组，已选的最优先；
      c、复现完毕后再检查一次是否可用；返回0表示技能和步骤可用；返回-1表示不可用；

  新增技能步骤：
    1、目前选择的每个步骤只有两种选择类型：战斗人物和菜单（Type分别为1和2）；
    2、如果要新增类型，则：
      a、Type为3及以上
      b、在选择后调用 skillChoice(n, 值);，表示进行下一个选择步骤
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
function *gfChoiceSingleCombatantSkill(skill, combatant, params={TeamFlags: 0b11, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}}) {
    //FightSceneJS.setTeamReadyToChoice(0b10, 0b1, true);

    //战斗人物选择
    let c = yield {Type: 1, Step: 0, TeamFlags: params.TeamFlags, Filter: params.Filter, Enabled: true};

    //判断是否符合条件
    /*while(1) {
        if(c.Value && c.Value.$$propertiesWithExtra.HP[0] > 0)
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

    //休息
    if(combatant.$$fightData.$choice.$type === 1)
        return -1;


    //所有可使用的技能或道具 数组（倒序使用）
    let useSkillsOrGoods;
    //选择的技能或道具
    let choiceSkillOrGoods;
    let skill;


    useSkillsOrGoods = game.$sys.resources.commonScripts["fight_role_choice_skills_or_goods_algorithm"](combatant);
    //不做处理
    if(useSkillsOrGoods === true)
        return 1;


    //!循环测试所有技能，直到有可以用的
    //对我方来说检查一次
    useNextSkill:
    while(1) {
        choiceSkillOrGoods = useSkillsOrGoods.pop();    //从最后开始
        if(!choiceSkillOrGoods) {   //没有技能了
            combatant.$$fightData.$choice.$type = -1;
            return -1;
        }


        combatant.$$fightData.$choice.$attack = choiceSkillOrGoods;
        if(choiceSkillOrGoods.$objectType === game.$sys.protoObjects.skill.$objectType)
            combatant.$$fightData.$choice.$type = 3;
        else if(choiceSkillOrGoods.$objectType === game.$sys.protoObjects.goods.$objectType)
            combatant.$$fightData.$choice.$type = 2;

        //检测技能 或 道具是否可以使用（我方和敌方人物刚选择技能时判断）
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
        if(combatant.$$fightData.$choice.$type === 3) {
            skill = choiceSkillOrGoods;
            if(/*skill && */skill.$commons.$choiceScript)
                genFightChoice = skill.$commons.$choiceScript(skill, combatant);
            //else if(!skill) {   //如果不可用
            //    continue;
            //}
        }
        //道具
        else if(combatant.$$fightData.$choice.$type === 2) {
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
                genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
            }

            //目标己方
            else if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b1)) {
                genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b1, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
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


                //检测技能 或 道具是否可以使用（我方和敌方人物选择技能的步骤完毕时判断）
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
            if(combatant.$$fightData.$choice.$targets[0].$$propertiesWithExtra.HP[0] <= 0) {
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
                if(tc.$$propertiesWithExtra.HP[0] > 0)
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
            if(combatant.$$fightData.$choice.$targets[0].$$propertiesWithExtra.HP[0] <= 0) {
                //combatant.$$fightData.$choice.$targets = undefined;
            }
        }
        else
            combatant.$$fightData.$choice.$targets = undefined;

        if(combatant.$$fightData.$choice.$targets === undefined) {
            //获得 己方还活着的 角色
            let tarrAlive = [];
            for(let tc of combatant.$$fightData.$info.$teams[0]) {
                if(tc.$$propertiesWithExtra.HP[0] > 0)
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
        filter = function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}

    if(enabled) {
        if(teamFlags & 0b1) {
            for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if((_private.myCombatants[i].$$propertiesWithExtra.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (_private.myCombatants[i].$$propertiesWithExtra.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(_private.myCombatants[i], combatant)
                ) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                    repeaterMyCombatants.itemAt(i).setEnable(true);
                }
            }
        }
        if(teamFlags & 0b10) {
            for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if((_private.enemies[i].$$propertiesWithExtra.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (_private.enemies[i].$$propertiesWithExtra.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(_private.enemies[i], combatant)
                ) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                    repeaterEnemies.itemAt(i).setEnable(true);
                }
            }
        }
    }
    else {
        if(teamFlags & 0b1) {
            //全部取消闪烁
            for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                if(_private.myCombatants[i].$$propertiesWithExtra.HP[0] > 0) {
                    repeaterMyCombatants.itemAt(i).setEnable(false);
                }
            }
        }
        if(teamFlags & 0b10) {
            //全部取消闪烁
            for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                if(_private.enemies[i].$$propertiesWithExtra.HP[0] > 0) {
                    repeaterEnemies.itemAt(i).setEnable(false);
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
        fight.menu(params.Title, params.Items, params.Style, function(index, itemMenu) {
            itemMenu.visible = false;
            FightSceneJS.skillChoice(2, index);

            itemMenu.destroy();
        });

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
                    //if((tc.$$propertiesWithExtra.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$$propertiesWithExtra.HP[0] <= 0 && (params.CombatantFlags & 0b10))
                    if(params.Filter(tc, combatant)
                    )
                        selecting.push(tc);
                }
            }
            //对方
            if(params.TeamFlags & 0b10) {
                //team.push(...combatant.$$fightData.$info.$teams[1]);
                for(let tc of combatant.$$fightData.$info.$teams[1]) {
                    //if((tc.$$propertiesWithExtra.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$$propertiesWithExtra.HP[0] <= 0 && (params.CombatantFlags & 0b10))
                    if(params.Filter(tc, combatant)
                    )
                        selecting.push(tc);
                }
            }

            selecting = GlobalLibraryJS.disorderArray(selecting);

            //如果是我方且已经有目标，则压入备选（注意要使用$lastChoice,因为$choice会被 再次运行的技能步骤生成器 重新赋值）
            if(//combatant.$$fightData.$info.$teamsID[0] === 0 &&
                GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets) &&
                GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets[params.Step])
                ) {
                //selecting.push(...combatant.$$fightData.$lastChoice.$targets);

                //循环每个选择的战斗人物，并根据条件来压入 上次选择的
                for(let tc of combatant.$$fightData.$lastChoice.$targets[params.Step]) {
                    //if((tc.$$propertiesWithExtra.HP[0] > 0 && (params.CombatantFlags & 0b1)) ||
                    //    (tc.$$propertiesWithExtra.HP[0] <= 0 && (params.CombatantFlags & 0b10))
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
        if(//combatant.$$fightData.$info.$teamsID[0] === 0 &&
            GlobalLibraryJS.isArray(combatant.$$fightData.$lastChoice.$targets) &&
            GlobalLibraryJS.isValidNumber(combatant.$$fightData.$lastChoice.$targets[params.Step])
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
function resetFightRole(fightRole, fightRoleComp, index, teamID) {

    fightRoleComp.refresh(fightRole);
    //fightRoleComp.strName = fightRole.$name;



    //if(i >= repeaterMyCombatants.count)
    //    break;
    //console.debug("!!!", _private.myCombatants, i, fightRole, JSON.stringify(fightRole));
    if(!fightRole.$$fightData)
        fightRole.$$fightData = {};

    //fightRole.$$fightData.$actionData = {};
    //fightRole.$$fightData.$buffs = {};
    ////_private.myCombatants.$rid = fightScriptData.$enemiesData[tIndex].$rid;

    fightRole.$$fightData.$info = {};
    fightRole.$$fightData.$info.$index = parseInt(index);
    if(teamID === 0) {    //我方
        fightRole.$$fightData.$info.$teamsID = [0, 1];
        fightRole.$$fightData.$info.$teams = [_private.myCombatants, _private.enemies];
        fightRole.$$fightData.$info.$teamsComp = [repeaterMyCombatants, repeaterEnemies];

        game.$sys.resources.commonScripts["fight_combatant_set_choice"](fightRole, -1, false);
    }
    else if(teamID === 1) { //敌方
        fightRole.$$fightData.$info.$teamsID = [1, 0];
        fightRole.$$fightData.$info.$teams = [_private.enemies, _private.myCombatants];
        fightRole.$$fightData.$info.$teamsComp = [repeaterEnemies, repeaterMyCombatants];

        game.$sys.resources.commonScripts["fight_combatant_set_choice"](fightRole, -1, true);
        //_private.enemies[i].$rid = fightScriptData.$enemiesData[tIndex].$rid;

    }

    fightRole.$$fightData.$info.$comp = fightRoleComp;
    fightRole.$$fightData.$info.$spriteEffect = fightRoleComp.spriteEffect;

    //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))

    //fightRole.$$fightData.$choice.$type = -1;
    ////fightRole.$$fightData.$lastChoice.$type = -1;
    //fightRole.$$fightData.$choice.$attack = undefined;
    ////fightRole.$$fightData.$lastChoice.$attack = undefined;
    //这两句必须，否则会指向不存在的对象（比如第一场结束前选第4个敌人，第二场直接重复上次就出错了）；
    //fightRole.$$fightData.$choice.$targets = undefined;
    //fightRole.$$fightData.$lastChoice.$targets = undefined;

    //fightRole.$$fightData.defenseSkill = undefined;
    //fightRole.$$fightData.lastDefenseSkill = undefined;


    /*/读取ActionData
    let fightroleInfo = game.$sys.getFightRoleResource(fightRole.$rid);
    if(fightroleInfo) {
        for(let tn in fightroleInfo.ActionData) {
            fightRole.$$fightData.$actionData[fightroleInfo.ActionData[tn].ActionName] = fightroleInfo.ActionData[tn].SpriteName;
        }
    }
    else
        console.warn("[!FightScene]载入战斗精灵失败：" + fightRole.$rid);
    */



    FightSceneJS.refreshFightRoleAction(fightRole, "Normal", AnimatedSprite.Infinite);

    //刷新血条
    //if(fightRole.$$propertiesWithExtra.HP[0] <= 0)
    //    fightRole.$$propertiesWithExtra.HP[0] = 1;
}






//播放 动作 或 特效
//返回1 表示动画正在进行，需要等待（yield）
function actionSpritePlay(combatantActionSpriteData, combatant) {

    combatant = combatantActionSpriteData.Combatant || combatant;
    //目标战士或队伍
    let targetCombatantOrTeamIndex = combatantActionSpriteData.Target;
    let combatantComp = combatant.$$fightData.$info.$comp;
    let combatantSpriteEffect = combatant.$$fightData.$info.$spriteEffect;


    //结果
    let SkillEffectResult;

    //类型
    switch(combatantActionSpriteData.Type) {
    case 1: //刷新人物信息
        //fight.$sys.refreshCombatant(-1);

        for(let tc of [..._private.myCombatants, ..._private.enemies]) {
            fight.$sys.refreshCombatant(tc);
        }

        //if(tRoleSpriteEffect2.propertyBar)
        //    tRoleSpriteEffect2.propertyBar.refresh(tRole2.$properties);

        return 0;
        //continue;
        //break;

    case 2: //延时

        timerRoleSprite.interval = combatantActionSpriteData.Interval;
        timerRoleSprite.start();

        return 1;
        //break;

    case 3:    //调用战斗技能算法
        SkillEffectResult = game.$sys.resources.commonScripts["fight_skill_algorithm"](combatant, targetCombatantOrTeamIndex, combatantActionSpriteData.Params);
        //SkillEffectResult = (doSkillEffect(role1.$$fightData.$teams, role1.$$fightData.$index, role2.$$fightData.$teams, role2.$$fightData.$index, tSkillEffect));

        return SkillEffectResult;
        //break;

    case 4:
        //检查所有战士（比如处理 死亡角色）
        fight.over(null);

        return 0;

    case 10: //Action

        FightSceneJS.refreshFightRoleAction(combatant, combatantActionSpriteData.Name, combatantActionSpriteData.Loops);

        //缩放
        if(GlobalLibraryJS.isArray(combatantActionSpriteData.Scale)) {
            combatantSpriteEffect.rXScale = parseFloat(combatantActionSpriteData.Scale[0]);
            combatantSpriteEffect.rYScale = parseFloat(combatantActionSpriteData.Scale[1]);
        }

        //半透明
        if(combatantActionSpriteData.Opacity !== undefined) {
            combatantSpriteEffect.opacity = combatantActionSpriteData.Opacity;
        }


        //计算间隔多久开始下一个
        if(combatantActionSpriteData.Interval === -1) {
            combatantActionSpriteData.Interval = timerRoleSprite.interval = combatantSpriteEffect.nFrameCount * combatantSpriteEffect.interval * combatantActionSpriteData.Loops;
            timerRoleSprite.start();
        }
        else if(combatantActionSpriteData.Interval > 0) {
            timerRoleSprite.interval = combatantActionSpriteData.Interval;
            timerRoleSprite.start();
        }
        else
            combatantActionSpriteData.Interval = 0;


        //计算播放时长
        if(combatantActionSpriteData.Duration === -1)
            combatantActionSpriteData.Duration = combatantSpriteEffect.nFrameCount * combatantSpriteEffect.interval * combatantActionSpriteData.Loops;
        else if(combatantActionSpriteData.Duration === undefined || combatantActionSpriteData.Duration === null)
            combatantActionSpriteData.Duration = combatantActionSpriteData.Interval;


        //是否跑动
        if(combatantActionSpriteData.Run !== undefined && combatantActionSpriteData.Duration > 0) {

            //移动位置偏移
            let offset = [0, 0];
            if(GlobalLibraryJS.isArray(combatantActionSpriteData.Offset)) {
                if(GlobalLibraryJS.isValidNumber(combatantActionSpriteData.Offset[0])) {
                    offset[0] = combatantActionSpriteData.Offset[0];
                }
                if(GlobalLibraryJS.isValidNumber(combatantActionSpriteData.Offset[1])) {
                    offset[1] = combatantActionSpriteData.Offset[1];
                }
            }

            let position;
            switch(combatantActionSpriteData.Run) {
            case 0:
                //位置
                position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                combatantComp.numberanimationSpriteEffectX.to = position.x - combatantComp.width / 2 + offset[0];
                combatantComp.numberanimationSpriteEffectY.to = position.y - combatantComp.height / 2 + offset[1];
                //combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                //combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
                break;

            case 1:
                position = game.$sys.resources.commonScripts["fight_combatant_melee_position_algorithm"](combatant, targetCombatantOrTeamIndex);
                /*let targetCombatantSpriteEffect = targetCombatantOrTeamIndex.$$fightData.$info.$spriteEffect;

                //x偏移一下
                let tx = combatantSpriteEffect.x < targetCombatantSpriteEffect.x ? -combatantSpriteEffect.width : combatantSpriteEffect.width;

                position = combatantSpriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);
                */

                combatantComp.numberanimationSpriteEffectX.to = position.x + offset[0];
                combatantComp.numberanimationSpriteEffectY.to = position.y + offset[1];
                //combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x + offset[0];
                //combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y + offset[1];

                //combatantSpriteEffect.x = position.x + combatantSpriteEffect.x;
                //combatantSpriteEffect.y = position.y + combatantSpriteEffect.y;

                //console.debug("!!!", position, combatantSpriteEffect.x, position.x + combatantSpriteEffect.x, AnimatedSprite.Infinite);

                break;

            case 2:
                position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
                combatantComp.numberanimationSpriteEffectX.to = position.x - combatantComp.width / 2 + offset[0];
                combatantComp.numberanimationSpriteEffectY.to = position.y - combatantComp.height / 2 + offset[1];
                //combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                //combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
                break;

            }

            ////combatantSpriteEffect.numberanimationSpriteEffectX.target = combatantSpriteEffect;
            combatantComp.numberanimationSpriteEffectX.duration = combatantActionSpriteData.Duration;
            combatantComp.numberanimationSpriteEffectX.start();
            //combatantSpriteEffect.numberanimationSpriteEffectX.duration = combatantActionSpriteData.Duration;
            //combatantSpriteEffect.numberanimationSpriteEffectX.start();
            ////combatantSpriteEffect.numberanimationSpriteEffectY.target = combatantSpriteEffect;
            combatantComp.numberanimationSpriteEffectY.duration = combatantActionSpriteData.Duration;
            combatantComp.numberanimationSpriteEffectY.start();
            //combatantSpriteEffect.numberanimationSpriteEffectY.duration = combatantActionSpriteData.Duration;
            //combatantSpriteEffect.numberanimationSpriteEffectY.start();
        }

        //多特效
        //MultiSprite

        //Team
        //我方还是敌方

        //延时
        if(combatantActionSpriteData.Interval > 0)
            return 1;
        //else
        //    continue;

        break;

    case 20: {   //Sprite
            let spriteEffect = game.$sys.loadSpriteEffect(combatantActionSpriteData.Name, compSpriteEffect.createObject(fightScene), combatantActionSpriteData.Loops);

            if(spriteEffect === null)
                break;

            let combatantActionSpriteDataID;
            if(combatantActionSpriteData.ID === undefined)
                combatantActionSpriteDataID = combatantActionSpriteData.Name;
            else
                combatantActionSpriteDataID = combatantActionSpriteData.ID;

            //检测ID是否重复
            if(_private.mapSpriteEffectsTemp[combatantActionSpriteDataID] !== undefined) {
                _private.mapSpriteEffectsTemp[combatantActionSpriteDataID].destroy();
                delete _private.mapSpriteEffectsTemp[combatantActionSpriteDataID];
            }

            //保存到列表中，退出时会删除所有，防止删除错误
            _private.mapSpriteEffectsTemp[combatantActionSpriteDataID] = spriteEffect;
            spriteEffect.s_finished.connect(function(){
                if(spriteEffect)
                    spriteEffect.destroy();
                delete _private.mapSpriteEffectsTemp[combatantActionSpriteDataID];
            });
            //spriteEffect.z = 999;


            //缩放
            if(GlobalLibraryJS.isArray(combatantActionSpriteData.Scale)) {
                spriteEffect.rXScale = parseFloat(combatantActionSpriteData.Scale[0]);
                spriteEffect.rYScale = parseFloat(combatantActionSpriteData.Scale[1]);
            }

            //半透明
            if(combatantActionSpriteData.Opacity !== undefined) {
                spriteEffect.opacity = combatantActionSpriteData.Opacity;
            }

            //计算间隔多久开始下一个
            if(combatantActionSpriteData.Interval === -1) {
                combatantActionSpriteData.Interval = timerRoleSprite.interval = spriteEffect.nFrameCount * spriteEffect.interval * combatantActionSpriteData.Loops;
                timerRoleSprite.start();
            }
            else if(combatantActionSpriteData.Interval > 0) {
                timerRoleSprite.interval = combatantActionSpriteData.Interval;
                timerRoleSprite.start();
            }
            else
                combatantActionSpriteData.Interval = 0;

            //计算播放时长
            if(combatantActionSpriteData.Duration === -1)
                combatantActionSpriteData.Duration = spriteEffect.nFrameCount * spriteEffect.interval * combatantActionSpriteData.Loops;
            else if(combatantActionSpriteData.Duration === undefined || combatantActionSpriteData.Duration === null)
                combatantActionSpriteData.Duration = combatantActionSpriteData.Interval;


            //位置
            if(combatantActionSpriteData.Position !== undefined) {
                let position;
                switch(combatantActionSpriteData.Position) {
                case 0:
                    position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.x = position.x - spriteEffect.width / 2;
                    spriteEffect.y = position.y - spriteEffect.height / 2;
                    break;
                case 1:
                    position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.x = position.x - spriteEffect.width / 2;
                    spriteEffect.y = position.y - spriteEffect.height / 2;

                    break;
                case 2:
                    position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
                    spriteEffect.x = position.x - spriteEffect.width / 2;
                    spriteEffect.y = position.y - spriteEffect.height / 2;

                    break;
                }
            }

            //是否跑动
            if(combatantActionSpriteData.Run !== undefined && combatantActionSpriteData.Duration > 0) {

                //移动位置偏移
                let offset = [0, 0];
                if(GlobalLibraryJS.isArray(combatantActionSpriteData.Offset)) {
                    if(GlobalLibraryJS.isValidNumber(combatantActionSpriteData.Offset[0])) {
                        offset[0] = combatantActionSpriteData.Offset[0];
                    }
                    if(GlobalLibraryJS.isValidNumber(combatantActionSpriteData.Offset[1])) {
                        offset[1] = combatantActionSpriteData.Offset[1];
                    }
                }

                let position;
                switch(combatantActionSpriteData.Run) {
                case 0:
                    position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.numberanimationSpriteEffectX.to = position.x - spriteEffect.width / 2 + offset[0];
                    spriteEffect.numberanimationSpriteEffectY.to = position.y - spriteEffect.height / 2 + offset[1];
                    break;

                case 1:
                    position = game.$sys.resources.commonScripts["fight_skill_melee_position_algorithm"](targetCombatantOrTeamIndex, spriteEffect);
                    /*
                    let targetCombatantSpriteEffect = targetCombatantOrTeamIndex.$$fightData.$info.$spriteEffect;

                    let tx = spriteEffect.x < targetCombatantSpriteEffect.x ? -spriteEffect.width : spriteEffect.width;
                    position = spriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);
                    */

                    spriteEffect.numberanimationSpriteEffectX.to = position.x + offset[0];
                    spriteEffect.numberanimationSpriteEffectY.to = position.y + offset[1];

                    //spriteEffect.x = position.x + spriteEffect.x;
                    //spriteEffect.y = position.y + spriteEffect.y;

                    //console.debug("!!!", position, spriteEffect.x, position.x + spriteEffect.x, AnimatedSprite.Infinite);

                    break;

                case 2:
                    position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
                    spriteEffect.numberanimationSpriteEffectX.to = position.x - combatantComp.width / 2 + offset[0];
                    spriteEffect.numberanimationSpriteEffectY.to = position.y - combatantComp.height / 2 + offset[1];
                    break;

                }

                //spriteEffect.numberanimationSpriteEffectX.target = spriteEffect;
                spriteEffect.numberanimationSpriteEffectX.duration = combatantActionSpriteData.Duration;
                spriteEffect.numberanimationSpriteEffectX.start();
                //spriteEffect.numberanimationSpriteEffectY.target = spriteEffect;
                spriteEffect.numberanimationSpriteEffectY.duration = combatantActionSpriteData.Duration;
                spriteEffect.numberanimationSpriteEffectY.start();
            }

            spriteEffect.restart();

            //多特效
            //MultiSprite

            //Team
            //我方还是敌方

            if(combatantActionSpriteData.Interval > 0)
                return 1;
            //else
            //    continue;
        }
        break;

    case 30: //显示动态文字

        let spriteEffect = compCacheWordMove.createObject(fightScene);
        spriteEffect.parallelAnimation.finished.connect(function(){
            if(spriteEffect)
                spriteEffect.destroy();
        });


        //缩放
        if(combatantActionSpriteData.Scale !== undefined) {
            spriteEffect.scale = combatantActionSpriteData.Scale;
        }

        //半透明
        if(combatantActionSpriteData.Opacity !== undefined) {
            spriteEffect.opacity = combatantActionSpriteData.Opacity;
        }


        //计算播放时长
        if(combatantActionSpriteData.Interval === -1) {
            combatantActionSpriteData.Interval = timerRoleSprite.interval = 1000;
            timerRoleSprite.start();
        }
        else if(combatantActionSpriteData.Interval > 0){
            timerRoleSprite.interval = combatantActionSpriteData.Interval;
            timerRoleSprite.start();
        }
        else
            combatantActionSpriteData.Interval = 0;


        if(combatantActionSpriteData.Duration > 0) {
            spriteEffect.nMoveDuration = combatantActionSpriteData.Duration;
            spriteEffect.nOpacityDuration = combatantActionSpriteData.Duration;
        }
        else {
            spriteEffect.nMoveDuration = 1000;
            spriteEffect.nOpacityDuration = 1000;
        }

        //颜色
        if(combatantActionSpriteData.Color !== undefined) {
            spriteEffect.text.color = combatantActionSpriteData.Color;
            //spriteEffect.text.styleColor = combatantActionSpriteData.Color;
            spriteEffect.text.styleColor = "";
        }

        //显示文字
        if(combatantActionSpriteData.Text !== undefined) {
            spriteEffect.text.text = combatantActionSpriteData.Text;
        }
        /*/或者显示 Data字符串方法 的返回值（可以使用 SkillEffectResult 对象）
        if(combatantActionSpriteData.Data) {
            //console.debug(SkillEffectResult[0].value)
            spriteEffect.text.text = GlobalJS._eval(combatantActionSpriteData.Data, "", {SkillEffectResult: SkillEffectResult});
            //console.debug(spriteEffect.text.text)
        }*/

        //文字大小
        if(combatantActionSpriteData.FontSize !== undefined) {
            spriteEffect.text.font.pointSize = combatantActionSpriteData.FontSize;
        }

        //位置（必须放在显示文字后）
        //!!!修改类型
        if(combatantActionSpriteData.Position !== undefined) {
            let position;
            switch(combatantActionSpriteData.Position) {
            case 1:
                /*position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](role2.$$fightData.$teamsID, role2.$$fightData.$index);
                spriteEffect.x = position.x - spriteEffect.width / 2;
                spriteEffect.y = position.y - spriteEffect.height / 2;
                */

                break;
            case 4:
                /*position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](role1.$$fightData.$teamsID, role1.$$fightData.$index);
                spriteEffect.x = position.x - spriteEffect.width / 2;
                spriteEffect.y = position.y - spriteEffect.height / 2;
                */
                break;
            }
        }
        else {
            let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
            spriteEffect.x = position.x - spriteEffect.width / 2;
            spriteEffect.y = position.y - spriteEffect.height / 2;
        }


        //!!!!!!修改：加入偏移和透明？
        spriteEffect.moveAniX.to = spriteEffect.x;
        spriteEffect.moveAniY.to = spriteEffect.y - 66;
        spriteEffect.opacityAni.from = spriteEffect.opacity;
        spriteEffect.opacityAni.to = 0;

        spriteEffect.parallelAnimation.start();



        if(combatantActionSpriteData.Interval > 0)
            return 1;
        //else
        //    continue;

        break;

    default:
        console.warn("[!FightScene]actionSpritePlay ERROR:", JSON.stringify(combatantActionSpriteData))
    }   //switch

    return 0;
}






//得到某个战斗角色的 所有 普通技能 和 技能；
//types：技能的type，系统默认 0为普通攻击，1为技能
//flags：0b1，包括战斗人物自身拥有的技能；0b10：包括战斗人物拥有的所有装备上附带的所有的技能；
//返回数组：[技能名数组, 技能数组]。
function getCombatantSkills(combatant, types=[0, 1], flags=0b11) {
    let arrSkillsName = [], arrSkills = [];

    if(flags & 0b1) {
        //人物所有的
        for(let skill of combatant.$skills) {
            if(types.indexOf(skill.$type) >= 0) {
                arrSkillsName.push(skill.$name);
                arrSkills.push(skill);
            }
        }
    }

    if(flags & 0b10) {
        //道具所有的
        for(let te in combatant.$equipment) {
            let tWeapon = combatant.$equipment[te];

            if(/*tWeapon && */tWeapon.$skills && tWeapon.$skills.length > 0)
                for(let skill of tWeapon.$skills) {
                    /*let skill;
                    if(GlobalLibraryJS.isString(tskill)) {
                        skill = {$rid: tskill};
                        GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.getSkillResource(tskill).$properties);
                    }
                    else {
                        skill = {$rid: tskill.RId};
                        GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.getSkillResource(tskill.RId).$properties);
                        GlobalLibraryJS.copyPropertiesToObject(skill, tskill);
                    }*/

                    if(types.indexOf(skill.$type) >= 0) {
                        arrSkillsName.push(skill.$name);
                        arrSkills.push(skill);
                    }
                }
        }
    }

    return [arrSkillsName, arrSkills];
}


//显示技能选择框
//type：0为普通攻击；1为技能
function showSkillsOrGoods(type) {

    //普通攻击
    if(type === 0) {
        let arrSkillsName = [];
        let arrSkills = [];

        [arrSkillsName, arrSkills] = FightSceneJS.getCombatantSkills(_private.myCombatants[_private.nChoiceFightRoleIndex], [0]);

        //menuSkillsOrGoods.nType = 0;

        //rectSkills.visible = true;
        //menuSkillsOrGoods.show(arrSkillsName, arrSkills);

        if(arrSkills.length === 0) {
            fight.msg("没有技能", 50);
            return;
        }
        //直接选择最后一个普通攻击
        choicedSkillOrGoods(arrSkills.pop(), 3);
    }
    //技能
    else if(type === 1) {
        let arrSkillsName = [];
        let arrSkills = [];

        [arrSkillsName, arrSkills] = FightSceneJS.getCombatantSkills(_private.myCombatants[_private.nChoiceFightRoleIndex], [1]);

        menuSkillsOrGoods.strTitle = "选择技能";
        menuSkillsOrGoods.nType = 3;

        rectSkills.visible = true;
        menuSkillsOrGoods.show(arrSkillsName, arrSkills);
    }
    //道具
    else if(type === 2) {
        let arrGoodsName = [];
        let arrGoods = [];

        //显示所有战斗可用的道具
        for(let goods of game.gd["$sys_goods"]) {
            //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
            if(goods.$commons.$fightScript) {
                arrGoods.push(goods);
                arrGoodsName.push(GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts["show_goods_name"](goods, {image: true, color: true, count: true})));
            }
        }

        menuSkillsOrGoods.strTitle = "选择道具";
        menuSkillsOrGoods.nType = 2;

        rectSkills.visible = true;
        menuSkillsOrGoods.show(arrGoodsName, arrGoods);
    }
}

//选择技能
//type：3为技能，2为物品
function choicedSkillOrGoods(used, type) {

    //console.debug("~~~~~~~~~weapon", JSON.stringify(tWeapon))
    //console.debug("~~~~~~~~~weapon", JSON.stringify(game.$sys.getGoodsResource(tWeapon.RId)))



    let combatant = _private.myCombatants[_private.nChoiceFightRoleIndex];
    combatant.$$fightData.$choice.$type = type;
    combatant.$$fightData.$choice.$attack = used;


    //console.debug('!!!1', JSON.stringify(used))

    //检测技能 或 道具是否可以使用（我方人物刚选择技能时判断）
    if(type === 3 || type === 2) {
        let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](used, combatant, 0);
        if(GlobalLibraryJS.isString(checkSkill)) {   //如果不可用
            fight.msg(checkSkill || "不能选择", 50);
            return;
        }
        else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果不可用
            fight.msg(...checkSkill);
            return;
        }
        else if(checkSkill !== true) {   //如果不可用
            fight.msg("不能选择", 50);
            return;
        }
    }


    //鹰：注释是避免 选择技能后直接点重复上次，会导致有可能攻击自己人的问题
    //combatant.$$fightData.$lastChoice.$type = type;
    //combatant.$$fightData.$lastChoice.$attack = used;

    //console.debug("~~~~~~~~~~used: ", used);



    //技能
    let skill;

    //普通攻击 或 技能
    if(type === 3) {
        skill = combatant.$$fightData.$choice.$attack;
        if(skill && skill.$commons.$choiceScript)
            _private.genFightChoice = skill.$commons.$choiceScript(skill, combatant);
        else if(!skill) {   //如果不可用
            fight.msg("技能不能使用", 50);
            return;
        }
    }
    //道具
    else if(type === 2) {
        let goods = combatant.$$fightData.$choice.$attack;
        if(GlobalLibraryJS.isArray(goods.$fight))
            skill = goods.$fight[0];
        //有一种情况为空：道具没有对应技能（$fight[0]），只运行收尾代码（$fightScript[3]）；
        //if(!skill)
        //    skill = {$targetCount: 0, $targetFlag: 0};

        //如果有 $fightScript 和 $choiceScript
        if(GlobalLibraryJS.isObject(goods.$commons.$fightScript) && goods.$commons.$fightScript.$choiceScript) {
            _private.genFightChoice = goods.$commons.$fightScript.$choiceScript(goods, combatant);
        }
        //!!兼容旧代码
        else if(GlobalLibraryJS.isArray(goods.$commons.$fightScript) && goods.$commons.$fightScript[0]) {
            _private.genFightChoice = goods.$commons.$fightScript[0](goods, combatant);
        }
        //使用技能的
        else if(skill && skill.$commons.$choiceScript)
            _private.genFightChoice = skill.$commons.$choiceScript(skill, combatant);
        else if(!skill) {   //如果不可用
            fight.msg("道具不能使用", 50);
            return;
        }
    }

    //如果没有特定定义的 $choiceScript选择脚本，则使用系统的
    if(!_private.genFightChoice) {
        //单人技能 且 目标敌方
        if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b10)) {
            _private.genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
        }

        //目标己方
        else if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b1)) {
            _private.genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b1, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
        }

        //不选（全体）
        //if(skill.$targetFlag === 0) {
        else if(skill.$targetCount <= 0) {
            _private.genFightChoice = FightSceneJS.gfNoChoiceSkill(skill, combatant);
        }
        else {   //不可用
            fight.msg("不能使用", 50);
            return;
        }
    }

    //开始进入选择
    skillChoice();
}



//技能的选择
//  进入技能的选择步骤后，一次选择完毕后的处理
//type和value是传递给_private.genFightChoice的参数
//  type：是技能选择步骤需要的类型，在技能选择的生成器函数中用yield返回的，这里重新给与；
//  value：选择的结果，比如 type为1，value为选择的对象；type为2，value为菜单的下标
function skillChoice(type, value) {
    if(_private.genFightChoice === null) {
        console.warn('[!FightScene]_private.genFightChoice is NULL');
        return;
    }

    let combatant = _private.myCombatants[_private.nChoiceFightRoleIndex];
    let skillOrGoods = combatant.$$fightData.$choice.$attack;

    let ret = _private.genFightChoice.next({Type: type, Value: value});
    for(;;) {
        if(ret.done === true) { //选择完毕

            _private.genFightChoice = null;

            FightSceneJS.saveLast(combatant);


            //if(_private.nChoiceFightRoleIndex < 0 || _private.nChoiceFightRoleIndex >= _private.myCombatants.length)
            //    return;

            //检测技能 或 道具是否可以使用（我方人物选择技能的步骤完毕时判断）
            let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](skillOrGoods, combatant, 1);
            if(GlobalLibraryJS.isString(checkSkill)) {   //如果技能不可用
                fight.msg(checkSkill || "不能使用", 50);
                return;
            }
            else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果技能不可用
                fight.msg(...checkSkill);
                return;
            }
            else if(checkSkill !== true) {   //如果技能不可用
                fight.msg("不能使用", 50);
                return;
            }


            //检查是否可以开始回合
            if(_private.nStage === 1)
                checkToFight();
            return;
        }
        else {
            //重新选择
            if(ret.value === false)
                return;

            let res = FightSceneJS.skillSetUsing(ret.value, combatant);
            if(res === true) {
                ret = _private.genFightChoice.next();

                continue;
            }
            else if(res === false) {
                return;
            }
        }
    }
}


//判断是否可以开始回合
function checkToFight() {
    if(_private.nStage === 2)
        return false;

    //遍历，判断target
    for(let i = 0; i < _private.myCombatants.length; ++i) {
        if(_private.myCombatants[i].$$propertiesWithExtra.HP[0] > 0) {
        //if(repeaterEnemies.itemAt(i).opacity !== 0) {
            //如果 没选择 且 有技能
            if(_private.myCombatants[i].$$fightData.$choice.$type === -1 && _private.myCombatants[i].$skills.length > 0) {
                return false;
            }
        }
    }

    let ret = _private.genFighting.run();
    return true;
}




//刷新 FightRole 的 action 到 sprite 并播放 loop 次
function refreshFightRoleAction(fightrole, action='Normal', loop=1) {

    if(!fightrole.$commons.$actions)
        return false;

    let actions = fightrole.$commons.$actions(fightrole);

    if(!actions[action]) {
        if(!actions['Normal'])
            return false;
        else
            action = 'Normal';
    }

    let spriteEffect = fightrole.$$fightData.$info.$spriteEffect;

    if(!game.$sys.loadSpriteEffect(actions[action], spriteEffect, loop)) {
        console.warn("[!FightScene]载入战斗精灵动作失败：" + action);
        return false;
    }

    spriteEffect.restart();

    return true;
}



//重置所有Roles位置
function resetRolesPosition() {
    for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
        let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](0, i);
        let tRoleSpriteEffect = repeaterMyCombatants.itemAt(i);
        tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
        tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
    }

    for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
        let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](1, i);
        let tRoleSpriteEffect = repeaterEnemies.itemAt(i);
        tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
        tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
    }
}


//战斗人物回合脚本
//stage：0为回合开始前；1为战斗人物行动前(我方选择完毕）；2为战斗人物行动前（我方和敌方选择和验证完毕）；3为战斗人物行动后；
function *runCombatantRoundScript(combatant, stage) {
    //执行 战斗人物回合 脚本
    let combatantRoundScript = game.$sys.resources.commonScripts["combatant_round_script"](combatant, _private.nRound, stage);

    if(combatantRoundScript === null) {
        return null;
    }
    else if(GlobalLibraryJS.isGenerator(combatantRoundScript)) {
        for(let tCombatantActionSpriteData of combatantRoundScript) {
            let SkillEffectResult = FightSceneJS.actionSpritePlay(tCombatantActionSpriteData, combatant);

            if(SkillEffectResult === 1)
                yield 0;
            else if(SkillEffectResult === 0) {

            }
            else {

            }
        }
    }


    //重新计算属性
    fight.$sys.refreshCombatant(combatant);


    return 0;
}



//一个回合
//yield：0表示进行动画播放，需要等待；1：战斗人物回合之间需要等待；
//return：undefined表示没有结束；否则（返回对象）战斗结束
function *fnRound() {


    /*/敌人 选择防御
    for(let tc in _private.enemies) {
        let tSkillIndexArray = GlobalLibraryJS.getDifferentNumber(0, _private.enemies[tc].$skills.length);
        //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击
        _private.enemies[tc].$$fightData.$choice.$attack = _private.enemies[tc].$skills[tSkillIndexArray[0]].RId;
    }*/



    //!!!开始循环每一角色的攻击
    let genFightRolesRound = game.$sys.resources.commonScripts["fight_roles_round"](_private.nRound);
    //返回战斗人物数组，或 暂停时间（数字）
    for(let tValue of genFightRolesRound) {
    ////for(let combatant of _private.arrTempLoopedAllFightRoles) {
    ////for(let tc in _private.arrTempLoopedAllFightRoles) {
        ////let combatant = _private.arrTempLoopedAllFightRoles[tc];

        let combatant;
        if(GlobalLibraryJS.isArray(tValue)) {
            combatant = tValue[0];
        }
        else if(GlobalLibraryJS.isValidNumber(tValue)) {

            //暂停时间
            fight.$sys.continueFight(1, tValue);

            yield 1;
            continue;
        }

        /*console.debug("!!!!!", JSON.stringify(combatant, function(k, v) {
            if(k.indexOf("$$") === 0)
                return undefined;
            return v;
        }))*/


        let ret;
        do {
            //战斗人物回合脚本
            yield *runCombatantRoundScript(combatant, 1);

            ret = FightSceneJS.combatantUseSkillOrGoods(combatant);

            yield *runCombatantRoundScript(combatant, 2);

            if(ret < 0)
                break;





            let fightSkills;
            let goods;
            let goodsInfo;

            if(combatant.$$fightData.$choice.$type === 3) {
                fightSkills = [combatant.$$fightData.$choice.$attack];
            }

            if(combatant.$$fightData.$choice.$type === 2) {
                goods = combatant.$$fightData.$choice.$attack;
                goodsInfo = game.$sys.getGoodsResource(goods.$rid);

                fightSkills = goods.$fight;
            }

            //console.debug("[FightScene]fightSkill:", JSON.stringify(fightSkillInfo));

            //如果有技能信息，则执行技能动画
            if(fightSkills) {
                for(let fightSkill of fightSkills) {

                    let fightSkillInfo = game.$sys.getSkillResource(fightSkill.$rid);


                    let SkillEffectResult;      //技能效果结算结果（技能脚本 使用）

                    //执行技能脚本
                    //fightSkillInfo = fightSkillInfo.$commons.$playScript(combatant.$$fightData.$teams, combatant.$$fightData.$index, role2.$$fightData.$teams, role2.$$fightData.$index, SkillEffects);

                    //console.debug("!!!", SkillEffects);

                    //得到技能生成器函数
                    //let genActionAndSprite = fightSkillInfo.$commons.$playScript(combatant);
                    _private.asyncScript.create(fightSkillInfo.$commons.$playScript(fightSkill, combatant), '$playScript', -1);


                    //循环 技能（或者 道具技能）包含的特效
                    while(1) {

                        //一个特效
                        let tCombatantActionSpriteData = _private.asyncScript.run(SkillEffectResult);
                        //console.debug("~~~~~", JSON.stringify(tCombatantActionSpriteData));

                        //方案2：新的 Generator来执行
                        /*let tCombatantActionSpriteData = genActionAndSprite.next(SkillEffectResult);
                        if(tCombatantActionSpriteData.done === true)
                            break;
                        else
                            tCombatantActionSpriteData = tCombatantActionSpriteData.value;
                        */

                        //如果动画结束
                        if(tCombatantActionSpriteData === undefined || tCombatantActionSpriteData === null || !tCombatantActionSpriteData || tCombatantActionSpriteData.done === true) {
                            break;
                        }
                        else
                            tCombatantActionSpriteData = tCombatantActionSpriteData.value;
                        if(!tCombatantActionSpriteData)  //如果是其他yield（比如msg）
                            continue;



                        //重新指定 team1、team2、tRole1、tRole2、tRoleSpriteEffect1、2

                        //let tTeam1 = team1;
                        //let tTeam2 = team2;
                        //let tRoleSpriteEffect1 = roleSpriteEffect1;
                        //let tRoleSpriteEffect2 = roleSpriteEffect2;
                        //let tRole1 = role1;
                        //let tRole2 = role2;
                        //let tRepeaterSpriteEffect1 = repeaterSpriteEffect1;
                        //let tRepeaterSpriteEffect2 = repeaterSpriteEffect2;

                        //console.debug("!!!0", tCombatantActionSpriteData.SkillEffect);
                        //if(tCombatantActionSpriteData.SkillEffect)
                        //    console.debug("!!!1", tCombatantActionSpriteData.SkillEffect, tCombatantActionSpriteData.SkillEffect.roleIndex1)

                        //console.debug("!!!2", JSON.stringify(tSkillEffect));
                        //console.debug("!!!33", tSkillEffect);
                        //if(tSkillEffect)
                        //    console.debug("!!!3", tSkillEffect, tSkillEffect.roleIndex2)
                        //console.debug("!!!4", tRoleSpriteEffect2, tRole2)



                        //!!!!!!注意：这里soundeffect如果同时载入很多时，Win下会非常卡（安卓貌似不会）


                        console.time("SkillSprite");
                        SkillEffectResult = FightSceneJS.actionSpritePlay(tCombatantActionSpriteData, combatant);
                        console.timeEnd("SkillSprite");

                        if(SkillEffectResult === 1)
                            yield 0;
                        else if(SkillEffectResult === 0) {

                        }
                        else {

                        }

                    }//while
                }
            }


            //道具 播放 $completeScript 收尾脚本
            if(goods) {


                let SkillEffectResult;      //技能效果结算结果（技能脚本 使用）
                //得到技能生成器函数
                //let genActionAndSprite = goodsInfo.$commons.$fightScript[2](goods, combatant);
                //if(goodsInfo.$commons.$fightScript['$playScript'])
                //    _private.asyncScript.create(goodsInfo.$commons.$fightScript['$playScript'](goods, combatant), '$playScript', -1);
                if(goodsInfo.$commons.$fightScript['$completeScript'])
                    _private.asyncScript.create(goodsInfo.$commons.$fightScript['$completeScript'](goods, combatant), '$completeScript', -1);
                else if(goodsInfo.$commons.$fightScript['$overScript'])
                    _private.asyncScript.create(goodsInfo.$commons.$fightScript['$overScript'](goods, combatant), '$overScript', -1);
                else if(goodsInfo.$commons.$fightScript[2]) //!!兼容旧代码
                    _private.asyncScript.create(goodsInfo.$commons.$fightScript[2](goods, combatant), '$overScript', -1);

                while(1) {

                    //一个特效
                    let tCombatantActionSpriteData = _private.asyncScript.run(SkillEffectResult);
                    //如果动画结束
                    if(tCombatantActionSpriteData === undefined || tCombatantActionSpriteData === null || !tCombatantActionSpriteData || tCombatantActionSpriteData.done === true) {
                        break;
                    }
                    else
                        tCombatantActionSpriteData = tCombatantActionSpriteData.value;
                    if(!tCombatantActionSpriteData)  //如果是其他yield（比如msg）
                        continue;


                    console.time("SkillSprite");
                    SkillEffectResult = FightSceneJS.actionSpritePlay(tCombatantActionSpriteData, combatant);
                    console.timeEnd("SkillSprite");

                    if(SkillEffectResult === 1)
                        yield 0;
                    else if(SkillEffectResult === 0) {

                    }
                    else {

                    }

                }
            }



            //执行产生的脚本
            //fight.run(null);



            //如果有血条
            //if(tRoleSpriteEffect2.propertyBar)
            //    tRoleSpriteEffect2.propertyBar.refresh(role2.$properties);


            //重置位置
            resetRolesPosition();
            //tRoleSpriteEffect1.Layout.leftMargin = 0;
            //tRoleSpriteEffect1.Layout.topMargin = 0;

            //重置normal Action
            //FightSceneJS.refreshFightRoleAction(combatant, "normal", AnimatedSprite.Infinite);


            //if(harm !== 0) {   //对方生命为0
            let fightResult = fight.over(null);
            //战斗结束
            if(fightResult.result !== 0) {
                FightSceneJS.fightOver(fightResult);
                return fightResult;
            }
        //}

        }while(0);



        yield *runCombatantRoundScript(combatant, 3);

    }   //for

    return;
}


//战斗主逻辑，战斗回合循环
//yield：<0同fnRound；10、11：等待选择 或 等待下一个事件循环
//return：战斗结果
function *gfFighting() {
    console.debug("[FightScene]gfFighting");

    let fightResult;

    while(1) {
        //console.debug("[FightScene]Fighting...");

        /*let tTeamsParam = [
            _private.myCombatants,
            _private.enemies,
        ];*/



        //循环每个队伍，开始遍历运行 Buff
        for(let tcombatant of [..._private.myCombatants, ..._private.enemies]) {

            //战斗人物回合脚本
            let ret = yield *runCombatantRoundScript(tcombatant, 0);

        }



        fightResult = fight.over(null);
        //战斗结束
        if(fightResult.result !== 0) {
            FightSceneJS.fightOver(fightResult);
            return fightResult;
        }



        //运行两个回合脚本（阶段1）

        //回合开始脚本
        //if(_private.fightRoundScript) {
        //    fight.run([_private.fightRoundScript, 'fight round21'], -1, _private.nRound, 0, [_private.myCombatants, _private.enemies,], _private.fightData);
        //}

        //通用回合开始脚本
        //console.debug("运行回合事件!!!", _private.nRound)
        fight.run([game.$sys.resources.commonScripts["fight_round_script"](_private.nRound, 0, [_private.myCombatants, _private.enemies,], _private.fightData), 'fight round11'], {Running: 1});
        //yield fight.run(()=>{_private.genFighting.run();});    //!!!这样的写法是，等待 事件队列 运行完毕再继续下一行代码，否则提前运行会出错!!!
        fight.$sys.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
        yield 10;



        //_private.nStep = 1;
        _private.nStage = 1;


        //战斗准备中（选择技能）
        if(_private.nAutoAttack === 0)
            yield 11;


        _private.nStage = 2;
        //rowlayoutButtons.enabled = false;
        //menuFightRoleChoice.hide();
        menuFightRoleChoice.visible = false;



        //FightSceneJS.saveLast();



        /*for(let ti = 0; ti < repeaterEnemies.count; ++ti) {
            //if(repeaterEnemies.itemAt(ti).opacity !== 0) {
            if(_private.enemies[ti].$$propertiesWithExtra.HP[0] > 0) {
                repeaterEnemies.itemAt(ti).colorOverlayStop();
            }
        }*/



        //运行两个回合脚本（阶段2）

        //回合开始脚本
        //if(_private.fightRoundScript) {
        //    fight.run([_private.fightRoundScript, 'fight round22'], -1, _private.nRound, 1, [_private.myCombatants, _private.enemies,], _private.fightData);
        //}

        //通用回合开始脚本
        //console.debug("运行回合事件!!!", _private.nRound)
        fight.run([game.$sys.resources.commonScripts["fight_round_script"](_private.nRound, 1, [_private.myCombatants, _private.enemies,], _private.fightData), 'fight round12'], {Running: 1});
        //yield fight.run(()=>{_private.genFighting.run();});    //!!!这样的写法是，等待 事件队列 运行完毕再继续下一行代码，否则提前运行会出错!!!
        fight.$sys.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
        yield 10;



        //如果asyncScript内部有脚本没执行完毕，则等待 asyncScript 运行完毕（主要是 两个回合脚本），再回来运行
        /*/鹰：有了上面代码貌似不用下面代码了
        if(!_private.asyncScript.isEmpty()) {

            //将 continueFight 放在脚本队列最后
            fight.run([function() {

                //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 asyncScript）
                //否则导致递归代码：在 asyncScript执行genFighting（执行continueFight），continueFight又会继续向下执行到asyncScript，导致递归运行!!!
                GlobalLibraryJS.setTimeout(function() {
                    //开始运行
                    fight.$sys.continueFight();
                },0,rootFightScene, 'fight.$sys.continueFight');

            }, 'continueFight']);

            //开始执行脚本队列
            //fight.run(null);

            yield;
        }
        */



        fightResult = yield *fnRound();
        if(fightResult !== undefined)
            return fightResult;



        //清空
        for(let tcombatant of _private.myCombatants) {
            //if(tcombatant.$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                game.$sys.resources.commonScripts["fight_combatant_set_choice"](tcombatant, -1, false);
                //tcombatant.$$fightData.$choice.$targets = undefined;
                ////tcombatant.$$fightData.$lastChoice.$targets = tcombatant.$$fightData.$choice.$targets;
                //tcombatant.$$fightData.$choice.$attack = undefined;
                ////tcombatant.$$fightData.$lastChoice.$attack = tcombatant.$$fightData.$choice.$attack;
                //tcombatant.$$fightData.$choice.$type = -1;
            //}
        }
        for(let tcombatant of _private.enemies) {
            //if(tcombatant.$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                game.$sys.resources.commonScripts["fight_combatant_set_choice"](tcombatant, -1, true);
                //tcombatant.$$fightData.$choice.$targets = undefined;
                ////tcombatant.$$fightData.$lastChoice.$targets = tcombatant.$$fightData.$choice.$targets;
                //tcombatant.$$fightData.$choice.$attack = undefined;
                ////tcombatant.$$fightData.$lastChoice.$attack = tcombatant.$$fightData.$choice.$attack;
                //tcombatant.$$fightData.$choice.$type = -1;
            //}
        }



        /*/运行两个回合脚本（阶段3）

        //通用回合开始脚本
        if(GlobalJS.createScript(_private.asyncScript, 0, 0, game.$sys.resources.commonScripts["fight_round_script"].call({game, fight}, _private.nRound, 1)) === 0)
            _private.asyncScript.run(_private.asyncScript.lastEscapeValue);

        //回合开始脚本
        if(_private.fightRoundScript) {
            //console.debug("运行回合事件!!!", _private.nRound)
            if(GlobalJS.createScript(_private.asyncScript, 0, 0, _private.fightRoundScript, _private.nRound, 1) === 0)
                _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
        }*/



        //一回合结束
        ++_private.nRound;

        //rowlayoutButtons.enabled = true;

    }
}

//逃跑处理
function runAway() {

    //rowlayoutButtons.enabled = false;

    FightSceneJS.resetFightScene();

    if(_private.nStage === 2)
        return;


    //逃跑计算

    //如果是true，则调用通用逃跑算法
    if(_private.runAway === true) {
        if(game.$sys.resources.commonScripts["common_run_away_algorithm"](_private.myCombatants, -1)) {
            fight.over(-2);
            return;
        }
    }
    //如果是数字（0~1之间），则概率逃跑
    else if(GlobalLibraryJS.isValidNumber(_private.runAway)) {
        if(Math.random() < _private.runAway) {
            fight.over(-2);
            return;
        }
    }

    //脚本形式执行
    let continueScript = function *() {
        yield fight.msg("逃跑失败");

        //全部设置为 休息
        for(let i = 0; i < _private.myCombatants.length; ++i) {
            if(_private.myCombatants[i].$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                game.$sys.resources.commonScripts["fight_combatant_set_choice"](_private.myCombatants[i], 1, false);
                //_private.myCombatants[i].$$fightData.$choice.$type = 1;
                //_private.myCombatants[i].$$fightData.$choice.$attack = undefined;
                //_private.myCombatants[i].$$fightData.$choice.$targets = undefined;
            }
        }
        //!!这里使用事件的形式执行genFighting，因为genFighting中也有 fight 脚本，貌似对之后的脚本造成了影响!!
        GlobalLibraryJS.setTimeout(function() {
            let ret = _private.genFighting.run();
        },0,rootFightScene,'fight runaway');
    }

    fight.run([continueScript, '逃跑失败脚本']);

}


//保存上次
function saveLast(combatant=true) {
    if(combatant === true)
        for(let tc of _private.myCombatants) {
        //for(let i = 0; i < _private.myCombatants.length; ++i) {
            if(tc.$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                tc.$$fightData.$lastChoice = {};
                GlobalLibraryJS.copyPropertiesToObject(tc.$$fightData.$lastChoice, tc.$$fightData.$choice, {arrayRecursion: false, objectRecursion: 0});
                //tc.$$fightData.$lastTarget = tc.$$fightData.$targets;
                //tc.$$fightData.$lastAttackSkill = tc.$$fightData.$attackSkill;
                //tc.$$fightData.$lastChoiceType = tc.$$fightData.$choiceType;
            }
        }
    else {
        combatant.$$fightData.$lastChoice = {};
        GlobalLibraryJS.copyPropertiesToObject(combatant.$$fightData.$lastChoice, combatant.$$fightData.$choice, {arrayRecursion: false, objectRecursion: 0});
        //combatant.$$fightData.$lastTarget = combatant.$$fightData.$targets;
        //combatant.$$fightData.$lastAttackSkill = combatant.$$fightData.$attackSkill;
        //combatant.$$fightData.$lastChoiceType = combatant.$$fightData.$choiceType;
    }
}

//type：0表示完全载入上次；1表示载入没有选择的
function loadLast(combatant=true, type=0) {
    if(combatant === true)
        for(let tc of _private.myCombatants) {
        //for(let i = 0; i < _private.myCombatants.length; ++i) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
            if(tc.$$propertiesWithExtra.HP[0] > 0) {
                if(type === 1 && tc.$$fightData.$choice.$type !== -1) {   //已经有选择
                    continue;
                }
                else {
                    GlobalLibraryJS.copyPropertiesToObject(tc.$$fightData.$choice, tc.$$fightData.$lastChoice, {arrayRecursion: false, objectRecursion: 0});
                    //tc.$$fightData.$targets = tc.$$fightData.$lastTarget;
                    //tc.$$fightData.$attackSkill = tc.$$fightData.$lastAttackSkill;
                    //tc.$$fightData.$choiceType = tc.$$fightData.$lastChoiceType;
                }
            }
        }
    else {
        if(type === 1 && combatant.$$fightData.$choice.$type !== -1) {   //已经有选择
            //continue;
        }
        else {
            GlobalLibraryJS.copyPropertiesToObject(combatant.$$fightData.$choice, combatant.$$fightData.$lastChoice, {arrayRecursion: false, objectRecursion: 0});
            //_private.myCombatants[i].$$fightData.$targets = _private.myCombatants[i].$$fightData.$lastTarget;
            //_private.myCombatants[i].$$fightData.$attackSkill = _private.myCombatants[i].$$fightData.$lastAttackSkill;
            //_private.myCombatants[i].$$fightData.$choiceType = _private.myCombatants[i].$$fightData.$lastChoiceType;
        }
    }
}


//调用脚本
function fightOver(result) {

    //if(result !== undefined && result !== null) {
        //战斗结束脚本
        //if(_private.fightEndScript) {
        //    fight.run([_private.fightEndScript, 'fight end'], -1, result, [_private.myCombatants, _private.enemies,], _private.fightData);
        //}

        fight.run([game.$sys.resources.commonScripts["fight_end_script"](result, [_private.myCombatants, _private.enemies,], _private.fightData), 'fight end2']);
    //}
}




//还原场景样子
function resetFightScene() {
    _private.genFightChoice = null;

    //menuFightRoleChoice.hide();
    menuFightRoleChoice.visible = false;

    rectSkills.visible = false;
    //menuSkillsOrGoods.hide();


    let filter = function(combatant){return true;};
    //全部取消闪烁
    FightSceneJS.setTeamReadyToChoice(0b11, filter, false, null);

}

function showFightRoleInfo(nIndex) {
    gameMenuWindow.showWindow(0b10, nIndex);
    //gameMenuWindow.showFightRoleInfo(nIndex);
}

//function onS_ShowSystemWindow() {
//    gameMenuWindow.show();
//}












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
        return Qt.point(fightScene.width / cols, fightScene.height * (index + 1) / (repeaterMyCombatants.nCount + 1));
    }
    else {  //敌方
        return Qt.point(fightScene.width * (cols-1) / cols, fightScene.height * (index + 1) / (repeaterEnemies.nCount + 1));
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

    role2.$$propertiesWithExtra.HP[0] -= harm.harm;
    if(role2.$$propertiesWithExtra.HP[0] <= 0) {
        role2.$$propertiesWithExtra.HP[0] = 0;
        //role1.$$propertiesWithExtra.HP[0] = role1.$$propertiesWithExtra.HP[2];
        //role2.$$propertiesWithExtra.HP[0] = role2.$$propertiesWithExtra.HP[2];
        //msgbox.textArea.append("战斗胜利");
        return {};
    }


    msgbox.textArea.append("--------------------------");
    return 0;
}
*/
