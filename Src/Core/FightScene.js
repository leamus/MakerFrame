
//保存上次
function saveLast(combatant=true) {
    if(combatant === true) {
        for(let tc of fight.myCombatants) {
        //for(let i = 0; i < fight.myCombatants.length; ++i) {
            if(game.$sys.resources.commonScripts['combatant_is_valid'](tc)) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                tc.$$fightData.$lastChoice = {};
                GlobalLibraryJS.copyPropertiesToObject(tc.$$fightData.$lastChoice, tc.$$fightData.$choice, {arrayRecursion: false, objectRecursion: 0});
                //tc.$$fightData.$lastTarget = tc.$$fightData.$targets;
                //tc.$$fightData.$lastAttackSkill = tc.$$fightData.$attackSkill;
                //tc.$$fightData.$lastChoiceType = tc.$$fightData.$choiceType;
            }
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
    if(combatant === true) {
        for(let tc of fight.myCombatants) {
        //for(let i = 0; i < fight.myCombatants.length; ++i) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
            if(game.$sys.resources.commonScripts['combatant_is_valid'](tc)) {
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
    }
    else {
        if(type === 1 && combatant.$$fightData.$choice.$type !== -1) {   //已经有选择
            //continue;
        }
        else {
            GlobalLibraryJS.copyPropertiesToObject(combatant.$$fightData.$choice, combatant.$$fightData.$lastChoice, {arrayRecursion: false, objectRecursion: 0});
            //fight.myCombatants[i].$$fightData.$targets = fight.myCombatants[i].$$fightData.$lastTarget;
            //fight.myCombatants[i].$$fightData.$attackSkill = fight.myCombatants[i].$$fightData.$lastAttackSkill;
            //fight.myCombatants[i].$$fightData.$choiceType = fight.myCombatants[i].$$fightData.$lastChoiceType;
        }
    }
}



//重置刷新战斗人物（创建时调用）
function resetFightRole(fightRole, fightRoleComp, index, teamID) {

    game.$gameMakerGlobalJS.resetFightRole(fightRole, index, teamID, fight.myCombatants, fight.enemies);

    //if(i >= repeaterMyCombatants.count)
    //    break;
    //console.debug('', fight.myCombatants, i, fightRole, JSON.stringify(fightRole));

    //fightRole.$$fightData.$actionData = {};
    //fightRole.$$fightData.$buffs = {};
    ////fight.myCombatants.$rid = fightScriptData.$enemiesData[tIndex].$rid;

    if(teamID === 0) {    //我方
        fightRole.$$fightData.$info.$teamsComp = [repeaterMyCombatants, repeaterEnemies];
    }
    else if(teamID === 1) { //敌方
        fightRole.$$fightData.$info.$teamsComp = [repeaterEnemies, repeaterMyCombatants];

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
        console.warn('[!FightScene]载入战斗精灵失败：' + fightRole.$rid);
    */



    //刷新组件
    fightRoleComp.refresh(fightRole);
    //fightRoleComp.strName = fightRole.$name;



    FightSceneJS.refreshFightRoleAction(fightRole, 'Normal', AnimatedSprite.Infinite);

    //刷新血条
    //if(fightRole.$$propertiesWithExtra.HP[0] <= 0)
    //    fightRole.$$propertiesWithExtra.HP[0] = 1;
}






//显示技能选择框
//type：0为普通攻击；1为技能；
//value：直接使用第n个技能/道具，-1为最后一个，-2为随机；其他类型的值为弹出选择框；
function showSkillsOrGoods(type, value) {

    let arrNames = [];
    let arrData = [];

    //普通攻击
    if(type === 0) {

        [arrNames, arrData] = game.$gameMakerGlobalJS.getCombatantSkills(fight.myCombatants[_private.nChoiceFightRoleIndex], [0]);

        //menuSkillsOrGoods.nType = 0;

        //rectSkills.visible = true;
        //menuSkillsOrGoods.show(arrNames, arrData);

        if(!GlobalLibraryJS.isNumber(value)) {
            if(arrData.length === 1) {
                choicedSkillOrGoods(arrData[0], 3);
                return;
            }


            menuSkillsOrGoods.strTitle = '选择技能';
            menuSkillsOrGoods.nType = 3;

            rectSkills.visible = true;
            menuSkillsOrGoods.show(arrNames, arrData);
        }
        else {
            if(arrData.length === 0) {
                fight.msg('没有技能', 50);
                return;
            }
            else if(value === -2)
                value = GlobalLibraryJS.random(0, arrData.length);
            //else if(value === -1)
            //    value = arrData.length - 1;
            else if(value >= 0 && value < arrData.length)
                ;
            else
                value = arrData.length - 1;

            //直接选择最后一个普通攻击
            choicedSkillOrGoods(arrData[value], 3);
        }
    }
    //技能
    else if(type === 1) {

        [arrNames, arrData] = game.$gameMakerGlobalJS.getCombatantSkills(fight.myCombatants[_private.nChoiceFightRoleIndex], [1]);

        if(!GlobalLibraryJS.isNumber(value)) {
            //if(arrData.length === 1) {
            //    choicedSkillOrGoods(arrData[0], 3);
            //    return;
            //}


            menuSkillsOrGoods.strTitle = '选择技能';
            menuSkillsOrGoods.nType = 3;

            rectSkills.visible = true;
            menuSkillsOrGoods.show(arrNames, arrData);
        }
        else {
            if(arrData.length === 0) {
                fight.msg('没有技能', 50);
                return;
            }
            else if(value === -2)
                value = GlobalLibraryJS.random(0, arrData.length);
            //else if(value === -1)
            //    value = arrData.length - 1;
            else if(value >= 0 && value < arrData.length)
                ;
            else
                value = arrData.length - 1;

            //直接选择最后一个普通攻击
            choicedSkillOrGoods(arrData[value], 3);
        }
    }
    //道具
    else if(type === 2) {

        //显示所有战斗可用的道具
        for(let goods of game.gd['$sys_goods']) {
            //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
            if(goods.$commons.$fightScript) {
                arrData.push(goods);
                arrNames.push(GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts['show_goods_name'](goods, {Image: true, Color: true, Count: true})));
            }
        }

        if(!GlobalLibraryJS.isNumber(value)) {
            //if(arrData.length === 1) {
            //    choicedSkillOrGoods(arrData[0], 2);
            //    return;
            //}


            menuSkillsOrGoods.strTitle = '选择道具';
            menuSkillsOrGoods.nType = 2;

            rectSkills.visible = true;
            menuSkillsOrGoods.show(arrNames, arrData);
        }
        else {
            if(arrData.length === 0) {
                fight.msg('没有道具', 50);
                return;
            }
            else if(value === -2)
                value = GlobalLibraryJS.random(0, arrData.length);
            //else if(value === -1)
            //    value = arrData.length - 1;
            else if(value >= 0 && value < arrData.length)
                ;
            else
                value = arrData.length - 1;

            //直接选择最后一个道具
            choicedSkillOrGoods(arrData[value], 2);
        }
    }
}

//选择技能/道具
//type：3为技能，2为道具
function choicedSkillOrGoods(used, type) {

    //console.debug('~~~~~~~~~weapon', JSON.stringify(tWeapon))
    //console.debug('~~~~~~~~~weapon', JSON.stringify(game.$sys.getGoodsResource(tWeapon.RID)))



    let combatant = fight.myCombatants[_private.nChoiceFightRoleIndex];
    combatant.$$fightData.$choice.$type = type;
    combatant.$$fightData.$choice.$attack = used;


    //console.debug('1', JSON.stringify(used))

    //检测技能 或 道具是否可以使用（我方人物刚选择技能时判断）
    if(type === 3 || type === 2) {
        let checkSkill = game.$sys.resources.commonScripts['common_check_skill'](used, combatant, 0);
        if(GlobalLibraryJS.isString(checkSkill)) {   //如果不可用
            fight.msg(checkSkill || '不能选择', 50);
            return;
        }
        else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果不可用
            fight.msg(...checkSkill);
            return;
        }
        else if(checkSkill !== true) {   //如果不可用
            fight.msg('不能选择', 50);
            return;
        }
    }


    //鹰：注释是避免 选择技能后直接点重复上次，会导致有可能攻击自己人的问题
    //combatant.$$fightData.$lastChoice.$type = type;
    //combatant.$$fightData.$lastChoice.$attack = used;

    //console.debug('~~~~~~~~~~used: ', used);



    //技能
    let skill;

    //普通攻击 或 技能
    if(type === 3) {
        skill = combatant.$$fightData.$choice.$attack;
        if(skill && skill.$commons.$choiceScript)
            _private.genFightChoice = skill.$commons.$choiceScript(skill, combatant);
        else if(!skill) {   //如果不可用
            fight.msg('技能不能使用', 50);
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
            fight.msg('道具不能使用', 50);
            return;
        }
    }

    //如果没有特定定义的 $choiceScript选择脚本，则使用系统的
    if(!_private.genFightChoice) {
        //单人技能 且 目标敌方
        if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b10)) {
            _private.genFightChoice = game.$gameMakerGlobalJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){return game.$sys.resources.commonScripts['combatant_is_valid'](targetCombatant);}});
        }

        //目标己方
        else if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b1)) {
            _private.genFightChoice = game.$gameMakerGlobalJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b1, Filter: function(targetCombatant, combatant){return game.$sys.resources.commonScripts['combatant_is_valid'](targetCombatant);}});
        }

        //不选（全体）
        //if(skill.$targetFlag === 0) {
        else if(skill.$targetCount <= 0) {
            _private.genFightChoice = game.$gameMakerGlobalJS.gfNoChoiceSkill(skill, combatant);
        }
        else {   //不可用
            fight.msg('不能使用', 50);
            return;
        }
    }


    //开始进入步骤选择
    skillStepChoiced();
}



//技能步骤的选择
//  进入技能的选择步骤后，一次选择完毕后的处理
//type和value是传递给_private.genFightChoice的参数
//  type：是技能选择步骤需要的类型，在技能选择的生成器函数中用yield返回的，这里重新给与；
//  value：选择的结果，比如 type为1，value为选择的对象；type为2，value为菜单的下标
function skillStepChoiced(type, value) {
    if(_private.genFightChoice === null) {
        console.warn('[!FightScene]_private.genFightChoice is NULL');
        return;
    }

    let combatant = fight.myCombatants[_private.nChoiceFightRoleIndex];
    let skillOrGoods = combatant.$$fightData.$choice.$attack;

    let ret = _private.genFightChoice.next({Type: type, Value: value});
    for(;;) {
        if(ret.done === true) { //选择完毕

            _private.genFightChoice = null;

            FightSceneJS.saveLast(combatant);


            //if(_private.nChoiceFightRoleIndex < 0 || _private.nChoiceFightRoleIndex >= fight.myCombatants.length)
            //    return;

            //检测技能 或 道具是否可以使用（我方人物选择技能的步骤完毕时判断）
            let checkSkill = game.$sys.resources.commonScripts['common_check_skill'](skillOrGoods, combatant, 1);
            if(GlobalLibraryJS.isString(checkSkill)) {   //如果技能不可用
                fight.msg(checkSkill || '不能使用', 50);
                return;
            }
            else if(GlobalLibraryJS.isArray(checkSkill)) {   //如果技能不可用
                fight.msg(...checkSkill);
                return;
            }
            else if(checkSkill !== true) {   //如果技能不可用
                fight.msg('不能使用', 50);
                return;
            }


            //检查是否可以开始回合
            if(_private.nStage === 2)
                checkToFight();
            return;
        }
        else {
            //重新选择
            if(ret.value === false)
                return;

            let res = FightSceneJS.skillStepGetReadyToChoice(ret.value, combatant);
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



//设置 技能步骤 需要选择时的准备工作（目前只有战斗人物和菜单）（我方手动选择时调用）
//params为参数，combatant为正在进行选择的战斗人物
//返回true表示不需要等待选择，返回false表示需要等待选择
//  !!新增技能选择类型，在这里新增
function skillStepGetReadyToChoice(params, combatant) {
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
            FightSceneJS.skillStepChoiced(2, index);

            itemMenu.destroy();
        });

        return false;
    }

    else {
        console.warn('[!FightScene]没有这种选择');
        return false;
    }
}



//设置 某个 team 的所有 战斗人物 是否可点 并 设置可点击效果
//teamFlags:0b1为我方，0b10为敌方；
//filter：战斗人物筛选函数；
//enabled：true为可选，false为取消可选；
//combatant：正在进行选择的战斗人物，有可能为null
function setTeamReadyToChoice(teamFlags, filter, enabled, combatant) {
    if(!filter)
        filter = function(targetCombatant, combatant){return game.$sys.resources.commonScripts['combatant_is_valid'](targetCombatant);}

    if(enabled) {
        if(teamFlags & 0b1) {
            for(let i = 0; i < fight.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if((fight.myCombatants[i].$$propertiesWithExtra.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (fight.myCombatants[i].$$propertiesWithExtra.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(fight.myCombatants[i], combatant)
                ) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                    repeaterMyCombatants.itemAt(i).setEnable(true);
                }
            }
        }
        if(teamFlags & 0b10) {
            for(let i = 0; i < fight.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if((fight.enemies[i].$$propertiesWithExtra.HP[0] > 0 && (combatantFlags & 0b1)) ||
                //    (fight.enemies[i].$$propertiesWithExtra.HP[0] <= 0 && (combatantFlags & 0b10))
                if(filter(fight.enemies[i], combatant)
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
            for(let i = 0; i < fight.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                if(game.$sys.resources.commonScripts['combatant_is_valid'](fight.myCombatants[i])) {
                    repeaterMyCombatants.itemAt(i).setEnable(false);
                }
            }
        }
        if(teamFlags & 0b10) {
            //全部取消闪烁
            for(let i = 0; i < fight.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                if(game.$sys.resources.commonScripts['combatant_is_valid'](fight.enemies[i])) {
                    repeaterEnemies.itemAt(i).setEnable(false);
                }
            }
        }
    }
}



//判断是否可以开始回合
function checkToFight() {
    if(_private.nStage === 3)
        return false;

    //遍历，判断target
    for(let i = 0; i < fight.myCombatants.length; ++i) {
        if(game.$sys.resources.commonScripts['combatant_is_valid'](fight.myCombatants[i])) {
        //if(repeaterEnemies.itemAt(i).opacity !== 0) {
            //如果 没选择 且 有技能
            if(fight.myCombatants[i].$$fightData.$choice.$type === -1 && fight.myCombatants[i].$skills.length > 0) {
                return false;
            }
        }
    }

    fight.$sys.continueFight(1);
    //let ret1 = _private.genFighting.next();
    //let ret1 = _private.scriptQueueFighting.run();
    return true;
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

        for(let tc of [...fight.myCombatants, ...fight.enemies]) {
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
        SkillEffectResult = game.$sys.resources.commonScripts['fight_skill_algorithm'](combatant, targetCombatantOrTeamIndex, combatantActionSpriteData.Params);
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
            combatantActionSpriteData.Interval = timerRoleSprite.interval = combatantSpriteEffect.nFrameCount * combatantSpriteEffect.nInterval * combatantActionSpriteData.Loops;
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
            combatantActionSpriteData.Duration = combatantSpriteEffect.nFrameCount * combatantSpriteEffect.nInterval * combatantActionSpriteData.Loops;
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
                position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                combatantComp.numberanimationSpriteEffectX.to = position.x - combatantComp.width / 2 + offset[0];
                combatantComp.numberanimationSpriteEffectY.to = position.y - combatantComp.height / 2 + offset[1];
                //combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                //combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
                break;

            case 1:
                position = game.$sys.resources.commonScripts['fight_combatant_melee_position_algorithm'](combatant, targetCombatantOrTeamIndex);
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

                //console.debug('', position, combatantSpriteEffect.x, position.x + combatantSpriteEffect.x, AnimatedSprite.Infinite);

                break;

            case 2:
                position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
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
            let spriteEffect = game.$sys.getSpriteEffect(combatantActionSpriteData.Name, null, {Loops: combatantActionSpriteData.Loops}, fightScene);

            if(spriteEffect === null)
                break;

            if(combatantActionSpriteData.ID === undefined)
                combatantActionSpriteData.ID = combatantActionSpriteData.Name;

            //检测ID是否重复
            if(_private.mapSpriteEffectsTemp[combatantActionSpriteData.ID] !== undefined) {
                game.$sys.putSpriteEffect(_private.mapSpriteEffectsTemp[combatantActionSpriteData.ID]);
                //_private.mapSpriteEffectsTemp[combatantActionSpriteData.ID].destroy();
                delete _private.mapSpriteEffectsTemp[combatantActionSpriteData.ID];
            }

            //保存到列表中，退出时会删除所有，防止删除错误
            _private.mapSpriteEffectsTemp[combatantActionSpriteData.ID] = spriteEffect;
            let _finished = function() {
                if(GlobalLibraryJS.isComponent(spriteEffect)) {
                    game.$sys.putSpriteEffect(spriteEffect);
                    //spriteEffect.destroy();
                }
                delete _private.mapSpriteEffectsTemp[combatantActionSpriteData.ID];
                spriteEffect.sg_finished.disconnect(_finished);
            };
            spriteEffect.sg_finished.connect(_finished);
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
                combatantActionSpriteData.Interval = timerRoleSprite.interval = spriteEffect.nFrameCount * spriteEffect.nInterval * combatantActionSpriteData.Loops;
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
                combatantActionSpriteData.Duration = spriteEffect.nFrameCount * spriteEffect.nInterval * combatantActionSpriteData.Loops;
            else if(combatantActionSpriteData.Duration === undefined || combatantActionSpriteData.Duration === null)
                combatantActionSpriteData.Duration = combatantActionSpriteData.Interval;


            //位置
            if(combatantActionSpriteData.Position !== undefined) {
                let position;
                switch(combatantActionSpriteData.Position) {
                case 0:
                    position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.x = position.x - spriteEffect.width / 2;
                    spriteEffect.y = position.y - spriteEffect.height / 2;
                    break;
                case 1:
                    position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.x = position.x - spriteEffect.width / 2;
                    spriteEffect.y = position.y - spriteEffect.height / 2;

                    break;
                case 2:
                    position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
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
                    position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
                    spriteEffect.numberanimationSpriteEffectX.to = position.x - spriteEffect.width / 2 + offset[0];
                    spriteEffect.numberanimationSpriteEffectY.to = position.y - spriteEffect.height / 2 + offset[1];
                    break;

                case 1:
                    position = game.$sys.resources.commonScripts['fight_skill_melee_position_algorithm'](targetCombatantOrTeamIndex, spriteEffect);
                    /*
                    let targetCombatantSpriteEffect = targetCombatantOrTeamIndex.$$fightData.$info.$spriteEffect;

                    let tx = spriteEffect.x < targetCombatantSpriteEffect.x ? -spriteEffect.width : spriteEffect.width;
                    position = spriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);
                    */

                    spriteEffect.numberanimationSpriteEffectX.to = position.x + offset[0];
                    spriteEffect.numberanimationSpriteEffectY.to = position.y + offset[1];

                    //spriteEffect.x = position.x + spriteEffect.x;
                    //spriteEffect.y = position.y + spriteEffect.y;

                    //console.debug('', position, spriteEffect.x, position.x + spriteEffect.x, AnimatedSprite.Infinite);

                    break;

                case 2:
                    position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
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

            spriteEffect.sprite.restart();

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

        let wordmove = compCacheWordMove.createObject(fightScene);
        wordmove.parallelAnimation.finished.connect(function() {
            if(GlobalLibraryJS.isComponent(wordmove)) {
                wordmove.destroy();
            }
        });


        //缩放
        if(combatantActionSpriteData.Scale !== undefined) {
            wordmove.scale = combatantActionSpriteData.Scale;
        }

        //半透明
        if(combatantActionSpriteData.Opacity !== undefined) {
            wordmove.opacity = combatantActionSpriteData.Opacity;
        }


        //计算播放时长
        if(combatantActionSpriteData.Interval === -1) {
            combatantActionSpriteData.Interval = timerRoleSprite.interval = 1000;
            timerRoleSprite.start();
        }
        else if(combatantActionSpriteData.Interval > 0) {
            timerRoleSprite.interval = combatantActionSpriteData.Interval;
            timerRoleSprite.start();
        }
        else
            combatantActionSpriteData.Interval = 0;


        if(combatantActionSpriteData.Duration > 0) {
            wordmove.nMoveDuration = combatantActionSpriteData.Duration;
            wordmove.nOpacityDuration = combatantActionSpriteData.Duration;
        }
        else {
            wordmove.nMoveDuration = 1000;
            wordmove.nOpacityDuration = 1000;
        }

        //颜色
        if(combatantActionSpriteData.Color !== undefined) {
            wordmove.text.color = combatantActionSpriteData.Color;
            //wordmove.text.styleColor = combatantActionSpriteData.Color;
            wordmove.text.styleColor = '';
        }

        //显示文字
        if(combatantActionSpriteData.Text !== undefined) {
            wordmove.text.text = combatantActionSpriteData.Text;
        }
        /*/或者显示 Data字符串方法 的返回值（可以使用 SkillEffectResult 对象）
        if(combatantActionSpriteData.Data) {
            //console.debug(SkillEffectResult[0].value)
            wordmove.text.text = GlobalJS._eval(combatantActionSpriteData.Data, '', {SkillEffectResult: SkillEffectResult});
            //console.debug(wordmove.text.text)
        }*/

        //文字大小
        if(combatantActionSpriteData.FontSize !== undefined) {
            wordmove.text.font.pointSize = combatantActionSpriteData.FontSize;
        }

        //位置（必须放在显示文字后）
        //!!!修改类型
        if(combatantActionSpriteData.Position !== undefined) {
            let position;
            switch(combatantActionSpriteData.Position) {
            case 1:
                /*position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](role2.$$fightData.$teamsID, role2.$$fightData.$index);
                wordmove.x = position.x - wordmove.width / 2;
                wordmove.y = position.y - wordmove.height / 2;
                */

                break;
            case 4:
                /*position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](role1.$$fightData.$teamsID, role1.$$fightData.$index);
                wordmove.x = position.x - wordmove.width / 2;
                wordmove.y = position.y - wordmove.height / 2;
                */
                break;
            }
        }
        else {
            let position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](combatant.$$fightData.$info.$teamsID[0], combatant.$$fightData.$info.$index);
            wordmove.x = position.x - wordmove.width / 2;
            wordmove.y = position.y - wordmove.height / 2;
        }


        //!!!!!!修改：加入偏移和透明？
        wordmove.moveAniX.to = wordmove.x;
        wordmove.moveAniY.to = wordmove.y - 66;
        wordmove.opacityAni.from = wordmove.opacity;
        wordmove.opacityAni.to = 0;

        wordmove.parallelAnimation.start();



        if(combatantActionSpriteData.Interval > 0)
            return 1;
        //else
        //    continue;

        break;

    default:
        console.warn('[!FightScene]actionSpritePlay ERROR:', JSON.stringify(combatantActionSpriteData))
    }   //switch

    return 0;
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

    if(!game.$sys.getSpriteEffect(actions[action], spriteEffect, {Loops: loop})) {
        console.warn('[!FightScene]载入战斗精灵动作失败：' + action);
        return false;
    }

    spriteEffect.sprite.restart();

    return true;
}



//重置所有Roles位置
function resetRolesPosition() {
    for(let i = 0; i < fight.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
        let position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](0, i);
        let tRoleSpriteEffect = repeaterMyCombatants.itemAt(i);
        tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
        tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
    }

    for(let i = 0; i < fight.enemies.length /*repeaterEnemies.nCount*/; ++i) {
        let position = game.$sys.resources.commonScripts['fight_combatant_position_algorithm'](1, i);
        let tRoleSpriteEffect = repeaterEnemies.itemAt(i);
        tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
        tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
    }
}




//一个回合
//yield：0表示进行动画播放，需要等待；1：战斗人物回合之间需要等待；
//return：undefined表示没有结束；否则（返回对象）战斗结束
function *fnRound() {


    /*/敌人 选择防御
    for(let tc in fight.enemies) {
        let tSkillIndexArray = GlobalLibraryJS.getDifferentNumber(0, fight.enemies[tc].$skills.length);
        //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击
        fight.enemies[tc].$$fightData.$choice.$attack = fight.enemies[tc].$skills[tSkillIndexArray[0]].RID;
    }*/



    //!!!开始循环每一角色的攻击
    let genFightRolesRound = game.$sys.resources.commonScripts['fight_roles_round'](_private.nRound);
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

        /*console.debug('', JSON.stringify(combatant, function(k, v) {
            if(k.indexOf('$$') === 0)
                return undefined;
            return v;
        }))*/


        let ret;
        do {
            //战斗人物回合脚本
            yield* runCombatantRoundScript(combatant, 1);

            ret = game.$gameMakerGlobalJS.combatantChoiceSkillOrGoods(combatant);

            yield* runCombatantRoundScript(combatant, 2);

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

            //console.debug('[FightScene]fightSkill:', JSON.stringify(fightSkillInfo));

            //如果有技能信息，则执行技能动画
            if(fightSkills) {
                for(let fightSkill of fightSkills) {

                    let fightSkillInfo = game.$sys.getSkillResource(fightSkill.$rid);


                    let SkillEffectResult;      //技能效果结算结果（技能脚本 使用）

                    //执行技能脚本
                    //fightSkillInfo = fightSkillInfo.$commons.$playScript(combatant.$$fightData.$teams, combatant.$$fightData.$index, role2.$$fightData.$teams, role2.$$fightData.$index, SkillEffects);

                    //console.debug('', SkillEffects);

                    //得到技能生成器函数
                    let genActionAndSprite = fightSkillInfo.$commons.$playScript(fightSkill, combatant);
                    //const ret1 = _private.scriptQueue.create(fightSkillInfo.$commons.$playScript(fightSkill, combatant) ?? null, -1, true, '$playScript', );
                    ///GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: fightSkillInfo.$commons.$playScript(fightSkill, combatant) ?? null, Tips: '$playScript'}, );


                    //循环 技能（或者 道具技能）包含的特效
                    while(GlobalLibraryJS.isGenerator(genActionAndSprite)) {

                        //一个技能生成器
                        let tCombatantActionSpriteData;

                        /*/方案1：
                        let [tCombatantActionSpriteData] = _private.scriptQueue.run(SkillEffectResult);

                        //如果动画结束
                        if(tCombatantActionSpriteData === undefined || tCombatantActionSpriteData === null || !tCombatantActionSpriteData || tCombatantActionSpriteData.done === true) {
                            break;
                        }
                        else
                            tCombatantActionSpriteData = tCombatantActionSpriteData.value;
                        */


                        //方案2：新的 Generator来执行
                        tCombatantActionSpriteData = genActionAndSprite.next(SkillEffectResult);
                        if(tCombatantActionSpriteData.done === true)
                            break;
                        else
                            tCombatantActionSpriteData = tCombatantActionSpriteData.value;



                        //console.debug('1', tCombatantActionSpriteData);
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

                        //console.debug('0', tCombatantActionSpriteData.SkillEffect);
                        //if(tCombatantActionSpriteData.SkillEffect)
                        //    console.debug('1', tCombatantActionSpriteData.SkillEffect, tCombatantActionSpriteData.SkillEffect.roleIndex1)

                        //console.debug('2', JSON.stringify(tSkillEffect));
                        //console.debug('33', tSkillEffect);
                        //if(tSkillEffect)
                        //    console.debug('3', tSkillEffect, tSkillEffect.roleIndex2)
                        //console.debug('4', tRoleSpriteEffect2, tRole2)



                        //!!!!!!注意：这里soundeffect如果同时载入很多时，Win下会非常卡（安卓貌似不会）


                        console.time('SkillSprite');
                        SkillEffectResult = FightSceneJS.actionSpritePlay(tCombatantActionSpriteData, combatant);
                        console.timeEnd('SkillSprite');

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
                //    _private.scriptQueue.create(goodsInfo.$commons.$fightScript['$playScript'](goods, combatant), '$playScript', -1);

                if(goodsInfo.$commons.$fightScript['$completeScript'])
                    /*const ret1 = */_private.scriptQueue.create(goodsInfo.$commons.$fightScript['$completeScript'](goods, combatant) ?? null, -1, true, '$completeScript', );
                    //GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: goodsInfo.$commons.$fightScript['$completeScript'](goods, combatant) ?? null, Tips: '$completeScript'}, );
                else if(goodsInfo.$commons.$fightScript['$overScript'])
                    /*const ret1 = */_private.scriptQueue.create(goodsInfo.$commons.$fightScript['$overScript'](goods, combatant) ?? null, -1, true, '$overScript', );
                    //GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: goodsInfo.$commons.$fightScript['$overScript'](goods, combatant) ?? null, Tips: '$overScript'}, );
                else if(goodsInfo.$commons.$fightScript[2]) //!!兼容旧代码
                    /*const ret1 = */_private.scriptQueue.create(goodsInfo.$commons.$fightScript[2](goods, combatant) ?? null, -1, true, '$overScript', );
                    //GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: goodsInfo.$commons.$fightScript[2](goods, combatant) ?? null, Tips: '$overScript'}, );

                while(1) {

                    //一个特效
                    let [tCombatantActionSpriteData] = _private.scriptQueue.run(SkillEffectResult);
                    //如果动画结束
                    if(tCombatantActionSpriteData === undefined || tCombatantActionSpriteData === null || !tCombatantActionSpriteData || tCombatantActionSpriteData.done === true) {
                        break;
                    }
                    else
                        tCombatantActionSpriteData = tCombatantActionSpriteData.value;
                    if(!tCombatantActionSpriteData)  //如果是其他yield（比如msg）
                        continue;


                    console.time('SkillSprite');
                    SkillEffectResult = FightSceneJS.actionSpritePlay(tCombatantActionSpriteData, combatant);
                    console.timeEnd('SkillSprite');

                    if(SkillEffectResult === 1)
                        yield 0;
                    else if(SkillEffectResult === 0) {

                    }
                    else {

                    }

                }
            }



            //执行产生的脚本
            //fight.run(false);



            //如果有血条
            //if(tRoleSpriteEffect2.propertyBar)
            //    tRoleSpriteEffect2.propertyBar.refresh(role2.$properties);


            //重置位置
            resetRolesPosition();
            //tRoleSpriteEffect1.Layout.leftMargin = 0;
            //tRoleSpriteEffect1.Layout.topMargin = 0;

            //重置normal Action
            //FightSceneJS.refreshFightRoleAction(combatant, 'normal', AnimatedSprite.Infinite);


            //if(harm !== 0) {   //对方生命为0
            let fightResult = fight.over(null);
            //战斗结束
            if(fightResult.result !== 0) {
                FightSceneJS.fightOver(fightResult);
                return fightResult;
            }
        //}

        } while(0);



        yield* runCombatantRoundScript(combatant, 3);
        //game.$sys.resources.commonScripts['fight_combatant_set_choice'](combatant, -1, false);

    }   //for

    return;
}


//战斗主逻辑，战斗回合循环
//yield：<0同fnRound；10、11：等待选择 或 等待下一个事件循环
//return：战斗结果
function *gfFighting() {
    console.debug('[FightScene]gfFighting');

    let fightResult;

    while(1) {
        //console.debug('[FightScene]Fighting...');

        /*let tTeamsParam = [
            fight.myCombatants,
            fight.enemies,
        ];*/



        //循环每个队伍，开始遍历运行 Buff
        for(let tcombatant of [...fight.myCombatants, ...fight.enemies]) {

            //战斗人物回合脚本
            let ret = yield* runCombatantRoundScript(tcombatant, 0);

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
        //    fight.run(_private.fightRoundScript(_private.nRound, 0, [fight.myCombatants, fight.enemies], fight.fightScript), 'fight round21');
        //}

        //通用回合开始脚本
        //console.debug('运行回合事件!!!', _private.nRound)
        const fightInitScript = game.$sys.resources.commonScripts['fight_round_script'];
        if(fightInitScript) { //GlobalLibraryJS.checkCallable
            //fight.run(fightInitScript(_private.nRound, 0, [fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Running: 1, Tips: 'fight round11'});
            let r = fightInitScript(_private.nRound, 0, [fight.myCombatants, fight.enemies], fight.fightScript);
            if(GlobalLibraryJS.isGenerator(r))r = yield* r;
        }


        //等待脚本队列运行完毕，再继续执行：

        //方案一：
        //fight.run(()=>{_private.genFighting.next();}, {Running: 1, Tips: 'genFighting.next1'});    //!!!这样的写法是，等待 事件队列 运行完毕再继续下一行代码，否则提前运行会出错!!!
        //fight.$sys.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
        //yield 10;

        //方案二：使用Promise
        /*yield new Promise(
            function (resolved, reject) {
                fight.run(function() {resolved();});
        });*/
        //yield fight.run(0);



        //_private.nStep = 1;
        _private.nStage = 2;

        //战斗准备中（选择技能）
        if(_private.nRunAwayFlag === 0 && _private.nAutoAttack === 0)
            yield 11;

        if(_private.nRunAwayFlag !== 0) {
            const ret = yield *runAway();
            if(ret === true) {
                fight.over(-2);
                return ret;
            }
        }

        _private.nStage = 3;
        //rowlayoutButtons.enabled = false;
        //menuFightRoleChoice.hide();
        menuFightRoleChoice.visible = false;



        //FightSceneJS.saveLast();



        /*for(let ti = 0; ti < repeaterEnemies.count; ++ti) {
            //if(repeaterEnemies.itemAt(ti).opacity !== 0) {
            if(fight.enemies[ti].$$propertiesWithExtra.HP[0] > 0) {
                repeaterEnemies.itemAt(ti).colorOverlayStop();
            }
        }*/



        //运行两个回合脚本（阶段2）

        //回合开始脚本
        //if(_private.fightRoundScript) {
        //    fight.run(_private.fightRoundScript( _private.nRound, 1, [fight.myCombatants, fight.enemies], fight.fightScript), 'fight round22');
        //}

        //通用回合开始脚本
        //console.debug('运行回合事件!!!', _private.nRound)
        //const fightInitScript = game.$sys.resources.commonScripts['fight_round_script'];
        if(fightInitScript) { //GlobalLibraryJS.checkCallable
            //fight.run(fightInitScript(_private.nRound, 1, [fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Running: 1, Tips: 'fight round12'});
            let r = fightInitScript(_private.nRound, 1, [fight.myCombatants, fight.enemies], fight.fightScript);
            if(GlobalLibraryJS.isGenerator(r))r = yield* r;
        }


        //等待脚本队列运行完毕，再继续执行：

        //方案一：
        //fight.run(()=>{_private.genFighting.next();}, {Running: 1, Tips: 'genFighting.next2'});    //!!!这样的写法是，等待 事件队列 运行完毕再继续下一行代码，否则提前运行会出错!!!
        //fight.$sys.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
        //yield 10;

        //方案二：使用Promise
        /*yield new Promise(
            function (resolved, reject) {
                fight.run(function() {resolved();});
        });*/
        //yield fight.run(0);



        //如果scriptQueue内部有脚本没执行完毕，则等待 scriptQueue 运行完毕（主要是 两个回合脚本），再回来运行
        /*/鹰：有了上面代码貌似不用下面代码了
        if(!_private.scriptQueue.isEmpty()) {

            //将 continueFight 放在脚本队列最后
            fight.run(function() {

                //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 scriptQueue）
                //否则导致递归代码：在 scriptQueue执行genFighting（执行continueFight），continueFight又会继续向下执行到scriptQueue，导致递归运行!!!
                GlobalLibraryJS.setTimeout(function() {
                    //开始运行
                    fight.$sys.continueFight();
                },0,rootFightScene, 'fight.$sys.continueFight');

            }, 'continueFight');

            //开始执行脚本队列
            //fight.run(false);

            yield;
        }
        */



        fightResult = yield* fnRound();
        if(fightResult !== undefined)
            return fightResult;



        //清空
        for(let tcombatant of fight.myCombatants) {
            //if(tcombatant.$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                game.$sys.resources.commonScripts['fight_combatant_set_choice'](tcombatant, -1, false);
                //tcombatant.$$fightData.$choice.$targets = undefined;
                ////tcombatant.$$fightData.$lastChoice.$targets = tcombatant.$$fightData.$choice.$targets;
                //tcombatant.$$fightData.$choice.$attack = undefined;
                ////tcombatant.$$fightData.$lastChoice.$attack = tcombatant.$$fightData.$choice.$attack;
                //tcombatant.$$fightData.$choice.$type = -1;
            //}
        }
        for(let tcombatant of fight.enemies) {
            //if(tcombatant.$$propertiesWithExtra.HP[0] > 0) {
            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                game.$sys.resources.commonScripts['fight_combatant_set_choice'](tcombatant, -1, true);
                //tcombatant.$$fightData.$choice.$targets = undefined;
                ////tcombatant.$$fightData.$lastChoice.$targets = tcombatant.$$fightData.$choice.$targets;
                //tcombatant.$$fightData.$choice.$attack = undefined;
                ////tcombatant.$$fightData.$lastChoice.$attack = tcombatant.$$fightData.$choice.$attack;
                //tcombatant.$$fightData.$choice.$type = -1;
            //}
        }



        /*/运行两个回合脚本（阶段3）

        //通用回合开始脚本
        if(_private.scriptQueue.create(fightInitScript.call({game, fight} ?? null, 0, true, '', _private.nRound, 1) === 0)
        //if(GlobalJS.createScript(_private.scriptQueue, 0, 0, fightInitScript.call({game, fight}, _private.nRound, 1)) === 0)
            _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);

        //回合开始脚本
        if(_private.fightRoundScript) {
            //console.debug('运行回合事件!!!', _private.nRound)
            if(_private.scriptQueue.create(_private.fightRoundScript(_private.nRound, 1) ?? null, -1, true, '', ) === 0)
            //if(GlobalJS.createScript(_private.scriptQueue, 0, 0, _private.fightRoundScript(_private.nRound, 1), ) === 0)
                _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
        }*/



        //一回合结束
        ++_private.nRound;

        //rowlayoutButtons.enabled = true;

    }
}


//战斗人物回合脚本
//stage：0为大回合开始前；1为战斗人物行动前(我方选择完毕）；2为战斗人物行动前（我方和敌方选择和验证完毕）；3为战斗人物行动后；
function *runCombatantRoundScript(combatant, stage) {
    //执行 战斗人物回合 脚本
    let combatantRoundScript = game.$sys.resources.commonScripts['combatant_round_script'](combatant, _private.nRound, stage);

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



//逃跑处理
function *runAway() {
    //if(flag === null)
    //    return _private.nRunAwayFlag;


    if(_private.nStage < 2)
        return false;


    //rowlayoutButtons.enabled = false;

    FightSceneJS.resetFightScene();

    //战斗阶段不可以逃跑，标记flag
    if(_private.nStage === 3) {
        //_private.nRunAwayFlag = flag;
        return null;
    }
    //if(flag !== true)    //次数
    //    _private.nRunAwayFlag = flag;
    if(_private.nRunAwayFlag === 0)
        return false;
    else if(_private.nRunAwayFlag > 0)
        --_private.nRunAwayFlag;


    //设置标记不可重入
    _private.nStage = -1;


    //逃跑计算

    //如果是true，则调用通用逃跑算法
    if(_private.runAwayPercent === true) {
        if(game.$sys.resources.commonScripts['common_run_away_algorithm'](fight.myCombatants, -1)) {
            return true;
        }
    }
    //如果是数字（0~1之间），则概率逃跑
    else if(GlobalLibraryJS.isValidNumber(_private.runAwayPercent)) {
        if(Math.random() < _private.runAwayPercent) {
            return true;
        }
    }

    yield fight.msg('逃跑失败');

    //全部设置为 休息
    for(let i = 0; i < fight.myCombatants.length; ++i) {
        if(game.$sys.resources.commonScripts['combatant_is_valid'](fight.myCombatants[i])) {
        //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
            //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
            game.$sys.resources.commonScripts['fight_combatant_set_choice'](fight.myCombatants[i], 1, false);
            //fight.myCombatants[i].$$fightData.$choice.$type = 1;
            //fight.myCombatants[i].$$fightData.$choice.$attack = undefined;
            //fight.myCombatants[i].$$fightData.$choice.$targets = undefined;
        }
    }
        //!!这里使用事件的形式执行genFighting，因为genFighting中也有 fight 脚本，貌似对之后的脚本造成了影响!!
        //if(flag !== true)
        //GlobalLibraryJS.runNextEventLoop(function() {
        //    let ret1 = _private.genFighting.next();
        //}/*,0,rootFightScene*/,'fight runaway');
        //fight.$sys.continueFight(1);

    return false;
}



//调用脚本
function fightOver(result, force=false) {
    if(force) {
        timerRoleSprite.stop();
        //_private.scriptQueueFighting.clear(3);
        _private.scriptQueue.clear(3);
    }

    //if(result !== undefined && result !== null) {
        //战斗结束脚本
        //if(_private.fightEndScript) {
        //    fight.run(_private.fightEndScript(result, [fight.myCombatants, fight.enemies], fight.fightScript), 'fight end');
        //}

        fight.run(game.$sys.resources.commonScripts['fight_end_script'](result, [fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Running: 2, Tips: 'fight end2'});
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

//function onSg_showSystemWindow() {
//    gameMenuWindow.show();
//}












/*/读 role战斗角色 的 属性 和 所有Action 到 role
function readFightRole(role) {
    //console.debug('[FightScene]readFightRole');

    let data = game.$sys.getFightRoleResource(role.$rid);
    if(data) {
        GlobalLibraryJS.copyPropertiesToObject(role, data.$createData());

        for(let tn in data.ActionData) {
            role.$$fightData.$actionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
        }

        return true;
    }
    else
        console.warn('[!FightScene]载入战斗精灵失败：' + role.$rid);


    /*let filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + role.$rid + GameMakerGlobal.separator + 'fight_role.json');

    //console.debug('[FightScene]filePath：', filePath);

    //let data = File.read(filePath);
    let data = FrameManager.sl_fileRead(filePath);

    if(data) {
        data = JSON.parse(data);

        GlobalLibraryJS.copyPropertiesToObject(role, data.Property);

        for(let tn in data.ActionData) {
            role.$$fightData.$actionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
        }

        return true;
    }
    else
        console.warn('[!FightScene]载入战斗精灵失败：' + filePath);

    return false;
    * /
}*/



//读取技能文件
function loadFightSkillInfo(fightSkillName) {
    //console.debug('[FightScene]loadFightSkillInfo0');
    return game.$sys.getSkillResource(fightSkillName);

    /*if(fightSkillName) {

        /*let filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + 'fight_skill.json');
        //let data = File.read(filePath);
        //console.debug('[GameFightSkill]filePath：', filePath);

        let data = FrameManager.sl_fileRead(filePath);

        if(data) {
            data = JSON.parse(data);
            //console.debug('data', data);
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
            console.warn('[!FightScene]Load Skill Fail:', filePath);
        * /
        let data = game.loadjson(GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + 'fight_skill.json');
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

    let skillEffectResult = game.$sys.resources.commonScripts['fight_skill_algorithm'](team1, roleIndex1, team2, roleIndex2, skillEffect);
    //for(let t in skillEffectResult) {
    //}
    return skillEffectResult;
}

//显示伤害文字，并设置伤害
function doSkillEffect1(team1, roleIndex1, team2, roleIndex2, skillEffect) {
    //console.debug('[FightScene]doSkillEffect');
    //console.debug(team1, roleIndex1, team2, roleIndex2, skillEffect);
    //console.debug(JSON.stringify(fight.myCombatants), JSON.stringify(fight.enemies))

    //!!!!!!修改
    let role1 = team1[roleIndex1];
    let role2 = team2[roleIndex2];

    let name1, name2
    let harm;
    let str;

    /*if(role1['name'] === '$$$') {
        name1 = '你';
    }
    else if(role1['name'] === 0) {
        name1 = '敌人';
    }
    else {
        name1 = FrameManager.sl_getPlayerInfo(role1['GroupIndex']).nickname;
    }* /
    name1 = role1.$name || '无名';

    /*if(role2['GameUserID'] === UserInfo.gameUserID) {
        name2 = '你';
    }
    else if(role2['GameUserID'] === 0) {
        name2 = '敌人';
    }
    else {
        name2 = FrameManager.sl_getPlayerInfo(role2['GroupIndex']).nickname;
    }* /
    name2 = role2.$name || '无名';

    //console.debug(Global.frameData.arrayPets)
    //console.debug(Global.frameData.arrayPets[0])
    //console.debug(Global.frameData.arrayPets[0].$$fightData.attackProp)
    //console.debug('debug1:', data2.choice)

    //Global.frameData.arrayEnemyPets[0].$$fightData.defenseProp = Global.frameData.arrayEnemyPets[0].$$fightData.attackProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)
    //Global.frameData.arrayEnemyPets[0].$$fightData.defenseProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)

    msgbox.textArea.append(name1 + '使用【' + game.$gameMakerGlobalJS.propertyName(role1.$$fightData.attackProp) + '】攻击');
    msgbox.textArea.append(name1 + '使用【' + game.$gameMakerGlobalJS.propertyName(role1.$$fightData.defenseProp) + '】防御');
    //msgbox.textArea.append(name2 + '使用' + role2.$$fightData.attackProp + '攻击');
    //msgbox.textArea.append(name2 + '使用' + role2.$$fightData.defenseProp + '防御');


    harm = game.$sys.resources.commonScripts['fight_skill_algorithm'](team1, roleIndex1, team2, roleIndex2, skillEffect);


    str = '属性使用';
    if(harm.propertySuccess === 1)str += '成功';
    else if(harm.propertySuccess === -1)str += '失败';
    else str += '无效果';
    str += ',%1把%2揍了'.arg(name1).arg(name2) + harm.harm + '血';
    msgbox.textArea.append(str);

    role2.$$propertiesWithExtra.HP[0] -= harm.harm;
    if(role2.$$propertiesWithExtra.HP[0] <= 0) {
        role2.$$propertiesWithExtra.HP[0] = 0;
        //role1.$$propertiesWithExtra.HP[0] = role1.$$propertiesWithExtra.HP[2];
        //role2.$$propertiesWithExtra.HP[0] = role2.$$propertiesWithExtra.HP[2];
        //msgbox.textArea.append('战斗胜利');
        return {};
    }


    msgbox.textArea.append('--------------------------');
    return 0;
}
*/
