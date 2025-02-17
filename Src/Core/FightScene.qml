import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtMultimedia 5.14
import Qt.labs.settings 1.1


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import GameComponents 1.0
import 'GameComponents'


import 'qrc:/QML'


//import 'GameMakerGlobal.js' as GameMakerGlobalJS

import 'FightScene.js' as FightSceneJS
//import 'File.js' as File


/*
    鹰：fight.myCombatants 和 fight.enemies 是 我方和敌方 的数据（$Combatant()返回的对象）
      repeaterMyCombatants 和 repeaterEnemies 是 我方和敌方 的精灵组件，和上面一一对应，用itemAt()来获取


    设计思路：
      1、3个生成器：
        genFightChoice是选择系统使用；genFighting/scriptQueueFighting 是主回合战斗循环使用；scriptQueue是各种事件、特效使用；
          genFighting/scriptQueueFighting 生成各种脚本给scriptQueue运行，分开的好处是随时可以插入用户定义的脚本去运行；
*/



Item {
    id: rootFightScene


    signal sg_fightOver();
    onSg_fightOver: {
        release();
    }



    //第一次载入（其他资源都已经载入完毕）
    function load() {
        console.debug('[FightScene]load');


        let tCommoncript = game.$userscripts;
        let objCommonScripts = game.$resources.commonScripts;


        objCommonScripts['common_run_away_algorithm'] = tCommoncript.$commonRunAwayAlgorithm;
        objCommonScripts['fight_skill_algorithm'] = tCommoncript.$fightSkillAlgorithm || tCommoncript.$skillEffectAlgorithm;
        objCommonScripts['fight_role_choice_skills_or_goods_algorithm'] = tCommoncript.$fightRoleChoiceSkillsOrGoodsAlgorithm;
        objCommonScripts['fight_init_script'] = tCommoncript.$commonFightInitScript;
        objCommonScripts['fight_start_script'] = tCommoncript.$commonFightStartScript;
        objCommonScripts['fight_round_script'] = tCommoncript.$commonFightRoundScript;
        objCommonScripts['fight_end_script'] = tCommoncript.$commonFightEndScript;
        objCommonScripts['fight_combatant_position_algorithm'] = tCommoncript.$fightCombatantPositionAlgorithm;
        objCommonScripts['fight_combatant_melee_position_algorithm'] = tCommoncript.$fightCombatantMeleePositionAlgorithm;
        objCommonScripts['fight_skill_melee_position_algorithm'] = tCommoncript.$fightSkillMeleePositionAlgorithm;
        objCommonScripts['fight_combatant_set_choice'] = tCommoncript.$fightCombatantSetChoice;
        objCommonScripts['fight_menus'] = tCommoncript.$fightMenus;
        objCommonScripts['fight_buttons'] = tCommoncript.$fightButtons;
        objCommonScripts['fight_roles_round'] = tCommoncript.$fightRolesRound;
        objCommonScripts['combatant_round_script'] = tCommoncript.$combatantRoundScript;
        objCommonScripts['check_all_combatants'] = tCommoncript.$checkAllCombatants;
        objCommonScripts['common_check_skill'] = tCommoncript.$commonCheckSkill;

        if(!objCommonScripts['common_run_away_algorithm']) {
            objCommonScripts['common_run_away_algorithm'] = game.$gameMakerGlobalJS.$commonRunAwayAlgorithm;
            console.debug('[FightScene]!载入系统逃跑算法');
        }
        else
            console.debug('[FightScene]载入逃跑算法OK');

        if(!objCommonScripts['fight_skill_algorithm']) {
            objCommonScripts['fight_skill_algorithm'] = game.$gameMakerGlobalJS.$fightSkillAlgorithm;
            console.debug('[FightScene]!载入系统战斗算法');
        }
        else
            console.debug('[FightScene]载入战斗算法OK');  //, objCommonScripts['fight_skill_algorithm'], data, eval('()=>{}'));

        if(!objCommonScripts['fight_role_choice_skills_or_goods_algorithm']) {
            objCommonScripts['fight_role_choice_skills_or_goods_algorithm'] = game.$gameMakerGlobalJS.$fightRoleChoiceSkillsOrGoodsAlgorithm;
            console.debug('[FightScene]!载入系统战斗人物选择技能或物品算法');
        }
        else
            console.debug('[FightScene]载入战斗人物选择技能或物品算法OK');


        if(!objCommonScripts['fight_init_script']) {
            objCommonScripts['fight_init_script'] = game.$gameMakerGlobalJS.$commonFightInitScript;
            console.debug('[FightScene]!载入系统战斗初始化脚本');
        }
        else
            console.debug('[FightScene]载入战斗初始化脚本OK');
        if(!objCommonScripts['fight_start_script']) {
            objCommonScripts['fight_start_script'] = game.$gameMakerGlobalJS.$commonFightStartScript;
            console.debug('[FightScene]!载入系统战斗开始脚本');
        }
        else
            console.debug('[FightScene]载入战斗开始脚本OK');
        if(!objCommonScripts['fight_round_script']) {
            objCommonScripts['fight_round_script'] = game.$gameMakerGlobalJS.$commonFightRoundScript;
            console.debug('[FightScene]!载入系统战斗回合脚本');
        }
        else
            console.debug('[FightScene]载入战斗回合脚本OK');
        if(!objCommonScripts['fight_end_script']) {
            objCommonScripts['fight_end_script'] = game.$gameMakerGlobalJS.$commonFightEndScript;
            console.debug('[FightScene]!载入系统战斗结束脚本');
        }
        else
            console.debug('[FightScene]载入战斗结束脚本OK');

        if(!objCommonScripts['fight_combatant_position_algorithm']) {
            objCommonScripts['fight_combatant_position_algorithm'] = game.$gameMakerGlobalJS.$fightCombatantPositionAlgorithm;
            console.debug('[FightScene]!载入系统战斗坐标算法');
        }
        else
            console.debug('[FightScene]载入战斗坐标算法OK');

        if(!objCommonScripts['fight_combatant_melee_position_algorithm']) {
            objCommonScripts['fight_combatant_melee_position_algorithm'] = game.$gameMakerGlobalJS.$fightCombatantMeleePositionAlgorithm;
            console.debug('[FightScene]!载入系统战斗近战坐标算法');
        }
        else
            console.debug('[FightScene]载入战斗近战坐标算法OK');

        if(!objCommonScripts['fight_skill_melee_position_algorithm']) {
            objCommonScripts['fight_skill_melee_position_algorithm'] = game.$gameMakerGlobalJS.$fightSkillMeleePositionAlgorithm;
            console.debug('[FightScene]!载入系统战斗特效坐标算法');
        }
        else
            console.debug('[FightScene]载入战斗特效坐标算法OK');

        if(!objCommonScripts['fight_combatant_set_choice']) {
            objCommonScripts['fight_combatant_set_choice'] = game.$gameMakerGlobalJS.$fightCombatantSetChoice;
            console.debug('[FightScene]!载入系统设置 战斗人物的 初始化 或 休息');
        }
        else
            console.debug('[FightScene]载入设置 战斗人物的 初始化 或 休息OK');

        if(!objCommonScripts['fight_menus']) {
            objCommonScripts['fight_menus'] = game.$gameMakerGlobalJS.$fightMenus;
            console.debug('[FightScene]!载入系统战斗菜单');
        }
        else
            console.debug('[FightScene]载入战斗菜单OK');

        if(!objCommonScripts['fight_buttons']) {
            objCommonScripts['fight_buttons'] = game.$gameMakerGlobalJS.$fightButtons;
            console.debug('[FightScene]!载入系统战斗按钮');
        }
        else
            console.debug('[FightScene]载入战斗按钮OK');

        if(!objCommonScripts['fight_roles_round']) {
            objCommonScripts['fight_roles_round'] = game.$gameMakerGlobalJS.$fightRolesRound;
            console.debug('[FightScene]!载入系统战斗人物回合顺序');
        }
        else
            console.debug('[FightScene]载入战斗人物回合顺序OK');

        if(!objCommonScripts['combatant_round_script']) {
            objCommonScripts['combatant_round_script'] = game.$gameMakerGlobalJS.$combatantRoundScript;
            console.debug('[FightScene]!载入系统通用Buff脚本');
        }
        else
            console.debug('[FightScene]载入通用Buff脚本OK');

        if(!objCommonScripts['check_all_combatants']) {
            objCommonScripts['check_all_combatants'] = game.$gameMakerGlobalJS.$checkAllCombatants;
            console.debug('[FightScene]!载入系统计算属性脚本');
        }
        else
            console.debug('[FightScene]载入计算属性脚本OK');

        if(!objCommonScripts['common_check_skill']) {
            objCommonScripts['common_check_skill'] = game.$gameMakerGlobalJS.$commonCheckSkill;
            console.debug('[FightScene]!载入系统通用检查技能脚本');
        }
        else
            console.debug('[FightScene]载入通用检查技能脚本OK');



        //读取配置
        _private.config.fightRoleBarConfig = GlobalLibraryJS.shortCircuit(0b1,
            GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$fight', '$combatant_bars'),
            //GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$fight', '$combatant_bars'),
            game.$gameMakerGlobalJS.$config.$fight.$combatant_bars,
            );


        //按钮
        for(let tb of game.$sys.resources.commonScripts['fight_buttons']) {
            //let compButtons1 = Qt.createComponent('qrc:/QML/_Global/Button/ColorButton.qml');
            //console.warn(compButtons1, compButtons1.status, compButtons1.errorString() )
            let button = compButtons.createObject(rowlayoutButtons);
            button.text = tb.$text;
            if(tb.$colors) {
                button.colors = tb.$colors;
                //button.color = tb.$colors[0];
            }
            if(tb.$clicked)
                button.sg_clicked.connect(function() {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    _private.asyncScript.async(tb.$clicked.call(button, button), 'FightScene button clicked');
                });
            //！！！兼容旧代码
            else if(tb.$action)
                button.sg_clicked.connect(function() {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    _private.asyncScript.async(tb.$action.call(button, button), 'FightScene button action');
                });
            GlobalLibraryJS.copyPropertiesToObject(button, tb.$properties, {onlyCopyExists: true,});
        }


        //预留10个我方和敌方人物组件
        for(let i = 0; i < 10; ++i)
            repeaterMyCombatants.model.append({modelData: i});
        for(let i = 0; i < 10; ++i)
            repeaterEnemies.model.append({modelData: i});


        //初始化样式
        //菜单样式
        let style = {};
        //样式
        //if(!style)
        //    style = {};
        let styleSystem = game.$gameMakerGlobalJS.$config.$fight.$styles.$menu;
        let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$fight', '$styles', '$menu') || styleSystem;

        //maskMenu.color = style.MaskColor || '#7FFFFFFF';
        menuSkillsOrGoods.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
        menuSkillsOrGoods.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
        menuSkillsOrGoods.nItemHeight = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
        menuSkillsOrGoods.nTitleHeight = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
        menuSkillsOrGoods.rItemFontSize = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
        menuSkillsOrGoods.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
        menuSkillsOrGoods.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
        menuSkillsOrGoods.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
        menuSkillsOrGoods.rTitleFontSize = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
        menuSkillsOrGoods.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
        menuSkillsOrGoods.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
        menuSkillsOrGoods.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;


        //钩子函数
        //!!鹰：钩子函数其实不是必须的，因为fight的init函数和其他插件init函数功能不同，所以暂时先用钩子函数代替，以后有机会做成插件就不用钩子函数了
        game.$sys.hooks.init['$fight'] = function(bLoadResources) {
            if(!bLoadResources) {
                //恢复随机遇敌
                if(game.gd['$sys_random_fight']) {
                    fight.fighton(...game.gd['$sys_random_fight']);
                }
            }

            return null;
        }


        console.debug('[FightScene]load over');
    }

    //释放卸载
    function unload() {
        console.debug('[FightScene]unload');


        //钩子函数
        game.$sys.hooks.release['$fight'] = function(bUnloadResources) {
            if(!bUnloadResources) {
            }
        }


        repeaterMyCombatants.model.clear();
        repeaterEnemies.model.clear();


        //删除按钮
        for(let tb in rowlayoutButtons.children) {
            rowlayoutButtons.children[tb].destroy();
        }


        console.debug('[FightScene]unload over');
    }


    //初始化
    function *init(fightScriptData) {
        console.debug('[FightScene]init:', fightScriptData);

        fight.d = {};

        //_private.scriptQueueFighting.clear(3);
        ////_private.scriptQueue.clear(1);
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        //我方
        fight.myCombatants = [...game.fighthero()];
        fight.enemies = [];
        ////_private.arrTempLoopedAllFightRoles = [];
        _private.nRound = 0;
        //_private.nStep = 0;
        _private.nStage = 1;

        //rowlayoutButtons.enabled = true;
        msgbox.textArea.text = '';

        imageBackground.source = '';

        for(let i = 0; i < repeaterMyCombatants.model.count; ++i)
            repeaterMyCombatants.itemAt(i).visible = false;
        for(let i = 0; i < repeaterEnemies.model.count; ++i)
            repeaterEnemies.itemAt(i).visible = false;


        rootFightScene.visible = true;
        rootFightScene.focus = true;


        /*/载入战斗脚本
        let data;
        if(fightScriptData) {

            let filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + fightScript + GameMakerGlobal.separator + 'fight_script.json');
            //let data = File.read(filePath);
            //console.debug('[GameFightScript]filePath：', filePath);

            data = FrameManager.sl_fileRead(filePath);
            if(!data)
                return;
            data = JSON.parse(data);
            if(!data) {
                return;
            }
        }
        else
            return;
        */

        //let data = game.loadjson(GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + fightScript + GameMakerGlobal.separator + 'fight_script.js');
        //if(!data)
        //    return;


        //data = GlobalJS._eval(data.FightScript);
        //let data = game.$sys.getFightScriptResource(fightScriptName);
        //_private.fightInfo = data;
        //_private.fightRoundScript = fightScript.$commons.$fightRoundScript || '';
        //_private.fightStartScript = fightScript.$commons.$fightStartScript || '';
        //_private.fightEndScript = fightScript.$commons.$fightEndScript || '';

        /*try {
            data = GlobalJS._eval(data.FightScript);
        }
        catch(e) {
            GlobalLibraryJS.printException(e);
            return false;
        }*/

        //data = data.$createData(fightScriptParams);
        //data.__proto__ = _private.fightInfo;


        fight.fightScript = fightScriptData;

        _private.runAwayPercent = (fight.fightScript.$runAway === undefined ? true : fight.fightScript.$runAway);




        //敌方

        //敌人数量
        let enemyCount;
        let enemyRandom = false;    //随机排列

        //如果是数组
        if(GlobalLibraryJS.isArray(fight.fightScript.$enemyCount)) {
            if(fight.fightScript.$enemyCount.length === 1)
                enemyCount = fight.fightScript.$enemyCount[0];
            else
                enemyCount = GlobalLibraryJS.random(fight.fightScript.$enemyCount[0], fight.fightScript.$enemyCount[1] + 1);

            enemyRandom = true;
        }
        else if(fight.fightScript.$enemyCount === true) {
            enemyCount = fight.fightScript.$enemiesData.length;
        }
        else {
            enemyCount = fight.fightScript.$enemyCount;   //如果是数字
        }

        fight.enemies.length = enemyCount;

        for(let i = 0; i < fight.enemies.length; ++i) {
            let tIndex;
            if(enemyRandom) //随机
                tIndex = GlobalLibraryJS.random(0, fight.fightScript.$enemiesData.length);
            else    //顺序
                tIndex = i % fight.fightScript.$enemiesData.length;

            //创建敌人
            fight.enemies[i] = game.$sys.getFightRoleObject(fight.fightScript.$enemiesData[tIndex], true);

            //从 propertiesWithExtra 设置人物的 HP和MP
            //fight.run(function() {
                //game.addprops(fight.enemies[i], {HP: 2, MP: 1}, 0);
            //});
        }


        //初始化脚本
        if(game.$sys.resources.commonScripts['fight_init_script']) {
            const r = game.$sys.resources.commonScripts['fight_init_script']([fight.myCombatants, fight.enemies], fight.fightScript);
            if(GlobalLibraryJS.isGenerator(r))yield* r;
            //yield fight.run(game.$sys.resources.commonScripts['fight_init_script']([fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Priority: -2, Tips: 'fight_init_script'});
        }


        let i;


        //创建战斗角色精灵
        ////组件会全部重新创建（已修改为动态创建）

        //我方
        //repeaterMyCombatants.model =
        repeaterMyCombatants.nCount = fight.myCombatants.length;
        for(i = 0; i < fight.myCombatants.length; ++i) {
            if(repeaterMyCombatants.model.count <= i)
                repeaterMyCombatants.model.append({modelData: i});
            repeaterMyCombatants.itemAt(i).visible = true;
            repeaterMyCombatants.itemAt(i).opacity = 1;
            if(repeaterMyCombatants.itemAt(i).spriteEffect.sprite)
                repeaterMyCombatants.itemAt(i).spriteEffect.sprite.stop();


            FightSceneJS.resetFightRole(fight.myCombatants[i], repeaterMyCombatants.itemAt(i), i, 0);

        }
        for(; i < repeaterMyCombatants.model.count; ++i) {
            repeaterMyCombatants.itemAt(i).visible = false;
            if(repeaterMyCombatants.itemAt(i).spriteEffect.sprite)
                repeaterMyCombatants.itemAt(i).spriteEffect.sprite.stop();
        }



        //敌方
        //repeaterEnemies.model = fight.enemies.length = enemyCount;
        repeaterEnemies.nCount = fight.enemies.length;
        for(i = 0; i < fight.enemies.length; ++i) {
            if(repeaterEnemies.model.count <= i)
                repeaterEnemies.model.append({modelData: i});
            repeaterEnemies.itemAt(i).visible = true;
            repeaterEnemies.itemAt(i).opacity = 1;
            if(repeaterEnemies.itemAt(i).spriteEffect.sprite)
                repeaterEnemies.itemAt(i).spriteEffect.sprite.stop();


            FightSceneJS.resetFightRole(fight.enemies[i], repeaterEnemies.itemAt(i), i, 1);

        }
        //隐藏剩下的
        for(; i < repeaterEnemies.model.count; ++i) {
            repeaterEnemies.itemAt(i).visible = false;
            if(repeaterEnemies.itemAt(i).spriteEffect.sprite)
                repeaterEnemies.itemAt(i).spriteEffect.sprite.stop();
        }



        FightSceneJS.resetFightScene();

        fight.$sys.refreshCombatant(-1);
        FightSceneJS.resetRolesPosition();


        if(game.$sys.resources.commonScripts['fight_start_script']) {
            const r = game.$sys.resources.commonScripts['fight_start_script']([fight.myCombatants, fight.enemies], fight.fightScript);
            if(GlobalLibraryJS.isGenerator(r))yield* r;
            //yield fight.run(game.$sys.resources.commonScripts['fight_start_script']([fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Priority: -2, Tips: 'fight start1'});
        }


        //GlobalLibraryJS.setTimeout(function() {
            //战斗起始脚本
            //if(_private.fightStartScript) {
            //    fight.run(_private.fightStartScript([fight.myCombatants, fight.enemies], fight.fightScript) ?? null, {Priority: -1, Tips: 'fight start2'});
            //}


        //}, 1, rootFightScene);



        //const ret1 = _private.scriptQueueFighting.create(FightSceneJS.gfFighting() ?? null, -1, true, '$gfFighting', );
        //_private.genFighting = FightSceneJS.gfFighting();
        fight.run(FightSceneJS.gfFighting());
        ////GlobalJS.createScript(_private.genFighting, {Type: 0, Priority: -1, Script: FightSceneJS.gfFighting(), Tips: '$gfFighting'}, );

        //fight.$sys.continueFight(1);
        //_private.genFighting.next();
        //GlobalLibraryJS.runNextEventLoop(function() {
        //    _private.genFighting.next();
        //}, 'fight init');

        console.debug('[FightScene]init over');
    }

    //释放
    function release() {
        console.debug('[FightScene]release');

        //audioFightMusic.stop();

        for(let ti in itemTempComponent.children) {
            itemTempComponent.children[ti].destroy();
        }


        FightSceneJS.resetFightScene();

        fight.d = {};

        _private.asyncScript.terminateAll();
        _private.scriptQueue.clear(1);
        //_private.scriptQueueFighting.clear(3);
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        //fight.enemies = [];
        //_private.arrTempLoopedAllFightRoles = [];
        //_private.nRound = 0;
        ////_private.nStep = 0;
        _private.nStage = 0;

        //repeaterEnemies.model = 0;
        //repeaterMyCombatants.model = 0;

        for(let tSpriteEffectIndex in _private.mapSpriteEffectsTemp) {
            //_private.mapSpriteEffectsTemp[tSpriteEffectIndex].destroy();
            game.$sys.putSpriteEffect(_private.mapSpriteEffectsTemp[tSpriteEffectIndex]);
        }
        _private.mapSpriteEffectsTemp = {};


        for(let i in fight.myCombatants) {
            //fight.myCombatants[i].$$fightData.$buffs = {};

            //必须清空lastTarget，否则有可能下次指向不存在的敌人
            fight.myCombatants[i].$$fightData.$lastChoice.$targets = undefined;
            fight.myCombatants[i].$$fightData.$choice.$targets = undefined;
            delete fight.myCombatants[i].$$fightData.$info;
        }


        rootFightScene.visible = false;

        rootGameScene.focus = true;


        game.stage(0);
        //_private.nStage = 0;
        game.goon('$fight');

        //game.run(true);


        //计算新属性
        game.run(function() {
            //计算新属性
            //for(let tfh of fight.myCombatants)
            for(let tfh of game.gd['$sys_fight_heros'])
                game.$resources.commonScripts['refresh_combatant'](tfh);
            //刷新战斗时人物数据
            //fight.$sys.refreshCombatant(-1);
        }, {Running: 1, Tips: 'FightScene release refresh_combatant'});

        console.debug('[FightScene]release over');
    }



    property QtObject fight: QtObject {
        //我方和敌方
        property var myCombatants: []
        property var enemies: []

        //战斗脚本
        property var fightScript: null


        //!!兼容旧代码
        readonly property var saveLast: FightSceneJS.saveLast
        readonly property var loadLast: FightSceneJS.loadLast
        readonly property var refreshCombatant: fight.$sys.refreshCombatant
        property alias nAutoAttack: _private.nAutoAttack



        //同 game.msg
        readonly property var msg: function(msg, interval=20, pretext='', keeptime=0, style={Type: 0b11}/*, buttonNum=0*/, callback=true) {

            /*/调用回调函数 或 不调用回调函数
            if(GlobalLibraryJS.isFunction(callback) || !callback) {
            }
            //设置默认回调函数
            else {
                //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                callback = function(cb, ...params) {
                    cb(...params);
                    run(true);
                }
            }
            */


            return game.msg(msg, interval, pretext, keeptime, style, false/*, buttonNum*/, callback, itemTempComponent);
            //itemGameMsg.parent = itemTempComponent;
            //return itemGameMsg;
        }

        //同 game.talk
        readonly property var talk: function(role=null, msg='', interval=20, pretext='', keeptime=0, style=null, callback=true) {

            /*/调用回调函数 或 不调用回调函数
            if(GlobalLibraryJS.isFunction(callback) || !callback) {
            }
            //设置默认回调函数
            else {
                //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                callback = function(cb, ...params) {
                    cb(...params);
                    run(true);
                }
            }
            */


            return game.talk(role, msg, interval, pretext, keeptime, style, false, callback, itemTempComponent);
        }

        //同 game.menu
        readonly property var menu: function(title, items, style={}, callback=true) {

            /*/调用回调函数 或 不调用回调函数
            if(GlobalLibraryJS.isFunction(callback) || !callback) {
            }
            //设置默认回调函数
            else {
                //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                callback = function(cb, ...params) {
                    cb(...params);
                    run(true, {Value: params[0]});
                }
            }
            */


            return game.menu(title, items, style, false, callback, itemTempComponent);
        }

        //技能选择菜单
        readonly property var choicemenu: function(title, items, style={}) {
            return menu(title, items, style, );
        }


        //换背景图
        readonly property var background: function(image='') {
            //console.debug('image:::', image, GameMakerGlobal.imageResourceURL(image));
            imageBackground.source = GameMakerGlobal.imageResourceURL(image);
        }


        //参数同 game.run
        readonly property var run: function(vScript, scriptProps=-1, ...params) {
            if(GlobalLibraryJS.isObject(scriptProps)) { //如果是参数对象
                scriptProps.ScriptQueue = _private.scriptQueue;
            }
            else if(GlobalLibraryJS.isValidNumber(scriptProps)) {   //如果是数字
                scriptProps = {ScriptQueue: _private.scriptQueue, Priority: scriptProps};
            }
            else if(GlobalLibraryJS.isString(scriptProps)) {   //如果是字符串
                scriptProps = {ScriptQueue: _private.scriptQueue, Tips: scriptProps};
            }
            return game.run(vScript, scriptProps, ...params);
        }


        //载入 fightScript 脚本 并进入战斗；
        //fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RID、Params和其他属性），或战斗脚本对象本身（带有$rid）；
        //params是给战斗脚本$createData的参数。
        readonly property var fighting: function(fightScript) {
            fightScript = game.$sys.getFightScriptObject(fightScript);
            if(!fightScript) {
                //console.warn('[!FightScene]没有战斗脚本:', fightScript);
                return false;
            }

            game.run(function*() {
                if(game.stage() !== 0)
                    return false;


                let fightHeros = game.fighthero();
                if(fightHeros.length === 0) {
                    //game.run(function*(){yield game.msg('没有战斗人物', 10);});
                    yield game.msg('没有战斗人物', 10);
                    return null;
                }

                game.pause('$fight');
                //_private.nStage = 1;
                game.stage(1);


                //loaderFightScene.test();
                //loaderFightScene.init(GameSceneJS.getFightScriptObject(fightScript));
                fight.run(init(fightScript) ?? null, {Tips: 'FightScene fighting'});


                //暂停脚本，直到stage为0
                // 鹰：必须写在这里，因为如果有多个fighting同时运行，则会出错（因为Timer会一直game.run）
                //while(game.stage() !== 0)
                //    yield null;

            }(), {Tips: 'FightScene fighting'});

            return true;
        }

        //载入 fightScript 脚本 并开启随机战斗；每过 interval 毫秒执行一次 百分之probability 的概率 是否进入随机战斗；
        //fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RID、Params和其他属性），或战斗脚本对象本身（带有$rid）；
        //flag：0b1为行动时遇敌，0b10为静止时遇敌；
        //params是给战斗脚本$createData的参数；
        //会覆盖之前的fighton；
        function fighton(fightScript, probability=5, interval=1000, flag=3) {
            game.gd['$sys_random_fight'] = [fightScript, probability, flag, interval];

            game.deltimer('$sys_random_fight_timer', true);
            game.addtimer('$sys_random_fight_timer', interval, -1, true);
            game.gf['$sys_random_fight_timer'] = function() {

                //判断行动或静止状态

                let mainRole = game.hero(0);

                //行动中
                if(mainRole.isMoving()) {
                    if((0b1 & flag) === 0)
                        return;
                }
                else {
                    if((0b10 & flag) === 0)
                        return;
                }


                if(GlobalLibraryJS.randTarget(probability, 100) === 1) {
                    //game.createfightenemy();
                    fight.fighting(fightScript);
                }
            }
        }

        //关闭随机战斗。
        readonly property var fightoff: function() {
            delete game.gd['$sys_random_fight'];

            game.deltimer('$sys_random_fight_timer', true);
            delete game.gf['$sys_random_fight_timer'];
        }


        //result：为undefined 发送 sg_fightOver 信号（调用release，比如关闭战斗画面等）；为true或对象则强制结束战斗；为null只是判断战斗是否结束；为其他值（0平1胜-1败-2逃跑）执行事件（事件中调用结束信号）；
        //流程：手动或自动 游戏结束，调用依次FightSceneJS.fightOver，执行脚本，然后通用战斗结束脚本中结尾调用 fight.over() 来清理战斗即可；
        readonly property var over: function(result) {
            if(result === undefined) {
                sg_fightOver();
                return;
            }
            else if(result === true)
                FightSceneJS.fightOver({exp: 0, goods: [], money: 0, result: -2}, true);
            else if(GlobalLibraryJS.isObject(result))
                FightSceneJS.fightOver(result, true);
            else {
                let fightResult = game.$sys.resources.commonScripts['check_all_combatants'](fight.myCombatants, repeaterMyCombatants, fight.enemies, repeaterEnemies);
                if(result !== null) {
                    fightResult.result = result;
                    FightSceneJS.fightOver(fightResult);
                    return;
                }
                else
                    return fightResult;
            }

        }



        property var d: ({})


        readonly property var $sys: ({
            screen: rootFightScene,    //固定屏幕上（所有，包含战斗场景）
            viewport: itemFightViewPort,      //战斗视窗
            scene: fightScene,  //容器（包含所有战斗人物）
            tempComponent: itemTempComponent,  //容器（包含所有战斗人物）

            showSkillsOrGoods: FightSceneJS.showSkillsOrGoods,
            showFightRoleInfo: function(nIndex){FightSceneJS.showFightRoleInfo(nIndex);},
            checkToFight: FightSceneJS.checkToFight,

            getCombatantSkills: game.$gameMakerGlobalJS.getCombatantSkills,

            gfChoiceSingleCombatantSkill: game.$gameMakerGlobalJS.gfChoiceSingleCombatantSkill,
            gfNoChoiceSkill: game.$gameMakerGlobalJS.gfNoChoiceSkill,

            saveLast: FightSceneJS.saveLast,
            loadLast: FightSceneJS.loadLast,
            resetFightScene: FightSceneJS.resetFightScene,
            resetFightRole: FightSceneJS.resetFightRole,
            actionSpritePlay: FightSceneJS.actionSpritePlay,
            refreshFightRoleAction: FightSceneJS.refreshFightRoleAction,
            resetRolesPosition: FightSceneJS.resetRolesPosition,

            continueFight: function(type=0, delay=0) {
                if(type === 1)
                    //将 continueFight 放在脚本队列最后
                    //一种实现方式（使用定时器）
                    /*fight.run(function() {

                        //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 scriptQueue）
                        //  否则导致递归代码：在 scriptQueue执行genFighting（执行continueFight），continueFight又会继续向下执行到scriptQueue，导致递归运行!!!
                        GlobalLibraryJS.setTimeout(function() {
                            //开始运行
                            //_private.scriptQueueFighting.run();
                            _private.genFighting.next();
                        }, delay, rootFightScene, 'fight.continueFight');

                    }, 'continueFight');
                    */
                    //另一种实现方式（使用wait）
                    _private.asyncScript.async(function*() {
                        yield game.wait(delay);
                        //_private.genFighting.next();
                        fight.run(true);
                    }(), 'continueFight');
                else
                    //_private.scriptQueueFighting.run();
                    fight.run(false);

            },

            //刷新战斗人物（目前只是血条）
            //combatant可以为数字：-1（全部）、0（我方）、1（敌方） 或 具体的某个战斗人物对象
            refreshCombatant: function(combatant=-1) {
                let refresh = function(combatant) {
                    if(combatant.$$fightData && combatant.$$fightData.$info && combatant.$$fightData.$info.$comp) {
                        game.$sys.resources.commonScripts['refresh_combatant'](combatant, false);
                        combatant.$$fightData.$info.$comp.refresh(combatant);
                        //repeaterMyCombatants.itemAt(i).propertyBar.refresh(fight.myCombatants[i].$$propertiesWithExtra.HP);
                    }
                }

                if(GlobalLibraryJS.isNumber(combatant)) {
                    if(combatant === -1 || combatant === 0)
                        for(let i = 0; i < fight.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
                            refresh(fight.myCombatants[i]);
                            //repeaterMyCombatants.itemAt(i).propertyBar.refresh(fight.myCombatants[i].$$propertiesWithExtra.HP);
                        }
                    if(combatant === -1 || combatant === 1)
                        for(let i = 0; i < fight.enemies.length /*repeaterEnemies.nCount*/; ++i) {
                            refresh(fight.enemies[i]);
                            //repeaterEnemies.itemAt(i).propertyBar.refresh(fight.enemies[i].$$propertiesWithExtra.HP);
                        }
                }
                else {
                    refresh(combatant);
                }
            },

            runAwayFlag: function(value) {
                if(value !== undefined)
                    _private.nRunAwayFlag = value;
                return _private.nRunAwayFlag;
            },
            runAway: FightSceneJS.runAway,

            stage: function(value) {
                if(value !== undefined)
                    _private.nStage = value;
                return _private.nStage;
            },
            autoAttack(value) {
                if(value !== undefined)
                    _private.nAutoAttack = value;
                return _private.nAutoAttack;
            },


            components: {
                menuSkillsOrGoods: menuSkillsOrGoods,
                menuFightRoleChoice: menuFightRoleChoice,

                spriteEffectMyCombatants: repeaterMyCombatants,
                spriteEffectEnemies: repeaterEnemies,
            },
            caches: {
                scriptQueue: _private.scriptQueue,
                //genFighting: _private.genFighting,
                //scriptQueueFighting: _private.scriptQueueFighting,
                genFightChoice: _private.genFightChoice,
            },



            //上场一个战斗人物
            //index表示第几个位置（0开始，负数为追加）；fightrole是战斗人物；teamID为0表示我方，为1表示敌方；
            //如果需要永久加入我方，先使用 game.createfighthero()，再把返回值给第二个参数；或者先调用这个函数，再把返回值给 game.createfighthero() 也行；
            insertFightRole: function(index, fightrole, teamID) {
                fightrole = game.$sys.getFightRoleObject(fightrole, false);
                if(!fightrole)
                    return null;

                switch(teamID) {
                case 0:
                    if(index < 0 || index > fight.myCombatants.length)
                        index = fight.myCombatants.length;

                    fight.myCombatants.splice(index, 0, fightrole);
                    repeaterMyCombatants.model.insert(index, {modelData: index});
                    FightSceneJS.resetFightRole(fightrole, repeaterMyCombatants.itemAt(index), index, teamID);

                    for(; index < fight.myCombatants.length; ++index)
                        fight.myCombatants[index].$$fightData.$info.$index = index;

                    ++repeaterMyCombatants.nCount;

                    break;
                case 1:
                    if(index < 0 || index > fight.enemies.length)
                        index = fight.enemies.length;

                    fight.enemies.splice(index, 0, fightrole);
                    repeaterEnemies.model.insert(index, {modelData: index});
                    FightSceneJS.resetFightRole(fightrole, repeaterEnemies.itemAt(index), index, teamID);

                    for(; index < fight.enemies.length; ++index)
                        fight.enemies[index].$$fightData.$info.$index = index;

                    ++repeaterEnemies.nCount;

                    break;
                }

                //FightSceneJS.refreshFightRoleAction(fightRole, 'Normal', AnimatedSprite.Infinite);
                fight.$sys.refreshCombatant(-1);
                FightSceneJS.resetRolesPosition();

                return fightrole;
            },

            removeFightRole: function(index, teamID) {  //下场
                let ret = null;

                switch(teamID) {
                case 0:
                    if(index < 0 || index >= fight.myCombatants.length)
                        return false;

                    ret = fight.myCombatants.splice(index, 1);
                    repeaterMyCombatants.model.remove(index, 1);
                    ret[0].$$fightData.$info.$index = -1;
                    ////_private.arrTempLoopedAllFightRoles.splice(_private.arrTempLoopedAllFightRoles.indexOf(ret[0]), 1);

                    for(; index < fight.myCombatants.length; ++index)
                        fight.myCombatants[index].$$fightData.$info.$index = index;

                    --repeaterMyCombatants.nCount;

                    break;
                case 1:
                    if(index < 0 || index >= fight.enemies.length)
                        return false;

                    ret = fight.enemies.splice(index, 1);
                    repeaterEnemies.model.remove(index, 1);
                    ret[0].$$fightData.$info.$index = -1;
                    ////_private.arrTempLoopedAllFightRoles.splice(_private.arrTempLoopedAllFightRoles.indexOf(ret[0]), 1);

                    for(; index < fight.enemies.length; ++index)
                        fight.enemies[index].$$fightData.$info.$index = index;

                    --repeaterEnemies.nCount;

                    break;
                }

                //FightSceneJS.refreshFightRoleAction(fightRole, 'Normal', AnimatedSprite.Infinite);
                fight.$sys.refreshCombatant(-1);
                FightSceneJS.resetRolesPosition();

                return ret;
             },
        })
    }



    //property var arrFightGenerators: []


    //anchors.fill: parent
    width: parent.width
    height: parent.height

    focus: true
    clip: true

    //color: 'black'



    Component {
        id: compBar

        Rectangle {
            id: trootBar

            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width

            color: '#800080'
            //antialiasing: false
            radius: 6
            clip: true

            property Rectangle bar1: Rectangle {
                parent: trootBar
                height: parent.height
                color: 'red'
                //antialiasing: false
                radius: 6
            }
            property Rectangle bar2: Rectangle {
                parent: trootBar
                height: parent.height
                color: 'yellow'
                //antialiasing: false
                radius: 6
            }

            function refresh(data) {
                let d0 = (data[0] > 0 ? data[0] : 0);
                let d1 = (data[1] > 0 ? data[1] : 0);
                if(data.length === 2) {
                    bar1.width = width;
                    bar2.width = d0 / d1 * width;
                }
                else if(data.length === 3) {
                    let d2 = (data[2] > 0 ? data[2] : 0);
                    bar1.width = d1 / d2 * width;
                    bar2.width = d0 / d2 * width;
                }
            }
        }
    }

    Component {
        id: compButtons

        ColorButton {

        }
    }

    Component {
        id: compText

        Text {
            //id: textMyCombatantName

            //anchors.bottom: loaderMyCombatantPropertyBar.bottom
            //anchors.bottomMargin: 10
            //width: tSpriteEffectMyCombatant.width
            //Layout.preferredWidth: tSpriteEffectMyCombatant.width
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width

            color: 'white'

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            textFormat: Text.RichText
            font.pointSize: 10
            font.bold: true
            //wrapMode: Text.Wrap
        }
    }

    /*/战斗特效
    Component {
        id: compSpriteEffect
        SpriteEffect {
            animatedsprite.smooth: GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$spriteEffect', '$smooth'),
                //GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$spriteEffect', '$smooth'),
                game.$gameMakerGlobalJS.$config.$spriteEffect.$smooth,
                true)

            onSg_playEffect: {
                game.playsoundeffect(soundeffectSource, -1);
            }
        }
    }*/



    Mask {
        anchors.fill: parent
        color: 'black'
        //opacity: 0
    }


    //战斗场景视窗
    Item {
        id: itemFightViewPort

        //anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        clip: true



        //背景
        Item {
            anchors.fill: parent

            //color: 'black'

            Image {
                id: imageBackground

                anchors.fill: parent

                //source: 'FightScene1.jpg'
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    FightSceneJS.resetFightScene();

                    //_private.nStep = 1;

                    mouse.accepted = true;
                }
            }
        }


        //战斗人物容器
        Item {
            id: fightScene


            // 除以scale的效果是：这个组件的实际大小其实是不变的，但它的子组件都会缩放，否则它自身也会缩放
            // 缩放后，这个组件的坐标系也会缩放
            width: parent.width / scale
            height: parent.height / scale

            clip: true
            //缩放中心
            transformOrigin: Item.TopLeft
            //transformOrigin: Item.Center


            //color: 'black'



        //ColumnLayout {
        //    width: parent.width / 2
        //    height: parent.height / 2

            //所有我方组件
            Repeater {
                id: repeaterMyCombatants

                //!!兼容旧代码
                property int nCount: 0


                //model: 0
                model: ListModel{}


                Item {
                    id: tRootMyCombatantComp

                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    property alias spriteEffect: tSpriteEffectMyCombatant
                    property alias numberanimationSpriteEffectX: numberanimationSpriteEffectMyCombatantX
                    property alias numberanimationSpriteEffectY: numberanimationSpriteEffectMyCombatantY

                    property var cacheComponents: []

                    property bool bCanClick: false



                    //第一次根据配置 创建 组件
                    function init() {
                        for(let bar of _private.config.fightRoleBarConfig) {
                            //文本
                            if(bar.$type === 1) {
                                let obj = compText.createObject(tMyCombatantColumnLayout);
                                obj.Layout.bottomMargin = bar.$spacing;
                                cacheComponents.push(obj);
                            }
                            //状态条
                            else if(bar.$type === 2) {
                                let obj = compBar.createObject(tMyCombatantColumnLayout);
                                obj.color = bar.$colors[2] || 'transparent';
                                obj.bar1.color = bar.$colors[1] || 'white';
                                obj.bar2.color = bar.$colors[0] || 'black';
                                obj.height = bar.$height;
                                obj.Layout.bottomMargin = bar.$spacing;
                                cacheComponents.push(obj);
                            }
                        }
                    }
                    //释放组件
                    function release() {
                        for(let bar of cacheComponents) {
                            bar.destroy();
                        }
                    }

                    //根据 配置和数据 刷新组件
                    function refresh(combatant) {
                        for(let ti in _private.config.fightRoleBarConfig) {
                            let bar = _private.config.fightRoleBarConfig[ti];
                            if(bar.$type === 1) {
                                cacheComponents[ti].text = GlobalLibraryJS.getObjectValue(combatant, ...bar.$property);
                            }
                            else if(bar.$type === 2) {
                                cacheComponents[ti].refresh(GlobalLibraryJS.getObjectValue(combatant, ...bar.$property));
                            }
                        }
                    }

                    //设置为可点或不可点
                    function setEnable(enable=true) {
                        if(enable) {
                            if(tSpriteEffectMyCombatant.sprite)
                                tSpriteEffectMyCombatant.sprite.colorOverlayStart(['#00000000', '#7FFFFFFF', '#00000000']);
                            tRootMyCombatantComp.bCanClick = true;
                        }
                        else {
                            if(tSpriteEffectMyCombatant.sprite)
                                tSpriteEffectMyCombatant.sprite.colorOverlayStop();
                            tRootMyCombatantComp.bCanClick = false;
                        }
                    }


                    width: tSpriteEffectMyCombatant.width// * Math.abs(tSpriteEffectMyCombatant.rXScale)
                    height: tSpriteEffectMyCombatant.height// * Math.abs(tSpriteEffectMyCombatant.rYScale)
                    implicitWidth: tSpriteEffectMyCombatant.implicitWidth// * Math.abs(tSpriteEffectMyCombatant.rXScale)
                    implicitHeight: tSpriteEffectMyCombatant.implicitHeight// * Math.abs(tSpriteEffectMyCombatant.rYScale)



                    NumberAnimation {
                        id: numberanimationSpriteEffectMyCombatantX
                        target: tRootMyCombatantComp
                        properties: 'x'
                        //to: 0
                        //duration: 200
                        easing.type: Easing.OutSine
                    }
                    NumberAnimation {
                        id: numberanimationSpriteEffectMyCombatantY
                        target: tRootMyCombatantComp
                        properties: 'y'
                        //to: 0
                        //duration: 200
                        easing.type: Easing.OutSine
                    }


                    SpriteEffect {
                        id: tSpriteEffectMyCombatant

                        property var $info: null
                        property var $script: null

                        anchors.centerIn: parent
                        //width: strSource ? implicitWidth : 60
                        //height: strSource ? implicitHeight : 60

                        smooth: GlobalLibraryJS.shortCircuit(0b1,
                            GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$spriteEffect', '$smooth'),
                            //GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$spriteEffect', '$smooth'),
                            game.$gameMakerGlobalJS.$config.$spriteEffect.$smooth,
                            true)

                        //bTest: false


                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                //if(!parent.animatedsprite.running)
                                //    return;

                                //弹出菜单
                                if(_private.genFightChoice === null) {
                                //if(_private.nStep === 1) {

                                    //没血的跳过
                                    if(!game.$sys.resources.commonScripts['combatant_is_valid'](fight.myCombatants[modelData]))
                                        return;


                                    //保存选择对象
                                    _private.nChoiceFightRoleIndex = modelData;


                                    //菜单位置
                                    /*跟随战士
                                    menuFightRoleChoice.parent = parent;
                                    menuFightRoleChoice.anchors.left = parent.right;
                                    menuFightRoleChoice.anchors.top = parent.top;
                                    */

                                    //菜单样式
                                    let style = {};
                                    //样式
                                    //if(!style)
                                    //    style = {};
                                    let styleSystem = game.$gameMakerGlobalJS.$config.$fight.$styles.$menu;
                                    let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$fight', '$styles', '$menu') || styleSystem;

                                    //maskMenu.color = style.MaskColor || '#7FFFFFFF';
                                    menuFightRoleChoice.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                                    menuFightRoleChoice.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                                    menuFightRoleChoice.nItemHeight = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
                                    menuFightRoleChoice.nTitleHeight = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
                                    menuFightRoleChoice.rItemFontSize = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
                                    menuFightRoleChoice.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
                                    menuFightRoleChoice.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
                                    menuFightRoleChoice.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
                                    menuFightRoleChoice.rTitleFontSize = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
                                    menuFightRoleChoice.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
                                    menuFightRoleChoice.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
                                    menuFightRoleChoice.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;
                                    //menuFightRoleChoice.show(_private.arrMenu);
                                    menuFightRoleChoice.show(game.$sys.resources.commonScripts['fight_menus'].$menus);
                                }
                                else if(tRootMyCombatantComp.bCanClick === true) {
                                    FightSceneJS.skillStepChoiced(1, fight.myCombatants[modelData]);
                                }

                                return;
                            }
                        }

                        onSg_playEffect: {
                            game.playsoundeffect(soundeffectSource, -1);
                        }
                    }


                    ColumnLayout {
                        id: tMyCombatantColumnLayout

                        //property alias spriteEffect: tSpriteEffectMyCombatant

                        anchors.bottom: tRootMyCombatantComp.top
                        //anchors.bottomMargin: 10
                        width: tRootMyCombatantComp.width

                        spacing: 0


                        /*Text {
                            id: textMyCombatantName

                            //anchors.bottom: loaderMyCombatantPropertyBar.bottom
                            //anchors.bottomMargin: 10
                            //width: tSpriteEffectMyCombatant.width
                            Layout.preferredWidth: tSpriteEffectMyCombatant.width

                            color: 'white'

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            textFormat: Text.RichText
                            font.pointSize: 10
                            font.bold: true
                            //wrapMode: Text.Wrap
                        }

                        Loader {
                            id: loaderMyCombatantPropertyBar

                            //anchors.bottom: parent.top
                            //anchors.bottomMargin: 10
                            //width: tSpriteEffectMyCombatant.width
                            Layout.preferredWidth: tSpriteEffectMyCombatant.width
                            height: _private.config.barHeight

                            sourceComponent: compBar
                            asynchronous: false
                        }
                        */
                    }

                    Component.onCompleted: {
                        //colorOverlayStart();
                    }

                    Component.onDestruction: {
                        release();
                    }
                }

                onItemAdded: {
                    item.init();
                }
            }
        //}

        //ColumnLayout {
        //    x: parent.width / 2
        //    width: parent.width / 2
        //    height: parent.height / 2

            //所有敌方组件
            Repeater {
                id: repeaterEnemies

                //!!兼容旧代码
                property int nCount: 0


                //model: 0
                model: ListModel{}


                Item {
                    id: tRootEnemyComp

                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    property alias spriteEffect: tSpriteEffectEnemy
                    property alias numberanimationSpriteEffectX: numberanimationSpriteEffectEnemyX
                    property alias numberanimationSpriteEffectY: numberanimationSpriteEffectEnemyY

                    property var cacheComponents: []

                    property bool bCanClick: false



                    //第一次根据配置 初始化 组件
                    function init() {
                        for(let bar of _private.config.fightRoleBarConfig) {
                            //文本
                            if(bar.$type === 1) {
                                let obj = compText.createObject(tEnemyColumnLayout);
                                obj.Layout.bottomMargin = bar.$spacing;
                                cacheComponents.push(obj);
                            }
                            //状态条
                            else if(bar.$type === 2) {
                                let obj = compBar.createObject(tEnemyColumnLayout);
                                obj.color = bar.$colors[2] || 'transparent';
                                obj.bar1.color = bar.$colors[1] || 'black';
                                obj.bar2.color = bar.$colors[0] || 'white';
                                obj.height = bar.$height;
                                obj.Layout.bottomMargin = bar.$spacing;
                                cacheComponents.push(obj);
                            }
                        }
                    }
                    //释放组件
                    function release() {
                        for(let bar of cacheComponents) {
                            bar.destroy();
                        }
                    }

                    //根据 配置和数据 刷新组件
                    function refresh(combatant) {
                        for(let ti in _private.config.fightRoleBarConfig) {
                            let bar = _private.config.fightRoleBarConfig[ti];
                            if(bar.$type === 1) {
                                cacheComponents[ti].text = GlobalLibraryJS.getObjectValue(combatant, ...bar.$property);
                            }
                            else if(bar.$type === 2) {
                                cacheComponents[ti].refresh(GlobalLibraryJS.getObjectValue(combatant, ...bar.$property));
                            }
                        }
                    }

                    //设置为可点或不可点
                    function setEnable(enable=true) {
                        if(enable) {
                            if(tSpriteEffectEnemy.sprite)
                                tSpriteEffectEnemy.sprite.colorOverlayStart(['#00000000', '#7FFFFFFF', '#00000000']);
                            tRootEnemyComp.bCanClick = true;
                        }
                        else {
                            if(tSpriteEffectEnemy.sprite)
                                tSpriteEffectEnemy.sprite.colorOverlayStop();
                            tRootEnemyComp.bCanClick = false;
                        }
                    }


                    width: tSpriteEffectEnemy.width// * Math.abs(tSpriteEffectEnemy.rXScale)
                    height: tSpriteEffectEnemy.height// * Math.abs(tSpriteEffectEnemy.rYScale)
                    implicitWidth: tSpriteEffectEnemy.implicitWidth// * Math.abs(tSpriteEffectEnemy.rXScale)
                    implicitHeight: tSpriteEffectEnemy.implicitHeight// * Math.abs(tSpriteEffectEnemy.rYScale)



                    NumberAnimation {
                        id: numberanimationSpriteEffectEnemyX
                        target: tRootEnemyComp
                        properties: 'x'
                        //to: 0
                        //duration: 200
                        easing.type: Easing.OutSine
                    }
                    NumberAnimation {
                        id: numberanimationSpriteEffectEnemyY
                        target: tRootEnemyComp
                        properties: 'y'
                        //to: 0
                        //duration: 200
                        easing.type: Easing.OutSine
                    }


                    SpriteEffect {
                        id: tSpriteEffectEnemy

                        property var $info: null
                        property var $script: null

                        anchors.centerIn: parent
                        //width: strSource ? implicitWidth : 60
                        //height: strSource ? implicitHeight : 60

                        smooth: GlobalLibraryJS.shortCircuit(0b1,
                            GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$spriteEffect', '$smooth'),
                            //GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$spriteEffect', '$smooth'),
                            game.$gameMakerGlobalJS.$config.$spriteEffect.$smooth,
                            true)

                        //bTest: false


                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                //不是选择敌方
                                //if(_private.nStep !== 3)
                                //    return;

                                if(_private.genFightChoice !== null) {
                                    if(tRootEnemyComp.bCanClick === true) {
                                        FightSceneJS.skillStepChoiced(1, fight.enemies[modelData]);
                                    }
                                }
                            }
                        }

                        onSg_playEffect: {
                            game.playsoundeffect(soundeffectSource, -1);
                        }
                    }


                    ColumnLayout {
                        id: tEnemyColumnLayout

                        //property alias spriteEffect: tSpriteEffectEnemy

                        anchors.bottom: tRootEnemyComp.top
                        //anchors.bottomMargin: 10
                        width: tRootEnemyComp.width

                        spacing: 0


                        /*Text {
                            id: textEnemyName

                            //anchors.bottom: loaderEnemyPropertyBar.bottom
                            //anchors.bottomMargin: 10
                            //width: tSpriteEffectEnemy.width
                            Layout.preferredWidth: tSpriteEffectEnemy.width

                            color: 'white'

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            textFormat: Text.RichText
                            font.pointSize: 10
                            font.bold: true
                            //wrapMode: Text.Wrap
                        }

                        Loader {
                            id: loaderEnemyPropertyBar

                            //anchors.bottom: parent.top
                            //anchors.bottomMargin: 10
                            //width: tSpriteEffectEnemy.width
                            Layout.preferredWidth: tSpriteEffectEnemy.width
                            height: _private.config.barHeight

                            sourceComponent: compBar
                            asynchronous: false
                        }
                        */
                    }

                    Component.onCompleted: {
                        //colorOverlayStart();
                    }

                    Component.onDestruction: {
                        release();
                    }
                }

                onItemAdded: {
                    item.init();
                }
            }
        //}


            /*
            NumberAnimation {
                id: numberanimationSpriteEffectX
                //target: handle.anchors
                properties: 'x'
                //to: 0
                //duration: 200
                easing.type: Easing.OutSine
            }
            NumberAnimation {
                id: numberanimationSpriteEffectY
                //target: handle.anchors
                properties: 'y'
                //to: 0
                //duration: 200
                easing.type: Easing.OutSine
            }*/

        }


        Item {
            id: itemTempComponent
            width: parent.width
            height: parent.height
        }

    }



    /*/战场的消息框
    Loader {
        id: dialogFightMsg

        visible: true
        anchors.fill: parent
        //z: 6

        sourceComponent: compGameMsg
        asynchronous: false

        Connections {
            target: dialogFightMsg.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            /*function onAccepted() {
            }

            function onRejected() {
            }
            * /
        }

        onLoaded: {
            //改变回调函数
        }
    }


    //战场的菜单
    Loader {
        id: loaderFightMenu

        visible: true
        anchors.fill: parent
        //z: 6

        sourceComponent: compGameMenu
        asynchronous: false

        /*Connections {
            target: loaderFightMenu.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_choice(index) {
            }
        }
        * /

        onLoaded: {
            //改变回调函数
        }
    }
    */



    //战斗人物的 选择主菜单
    GameMenu {
        id: menuFightRoleChoice

        visible: false
        width: 100
        height: implicitHeight
        anchors.centerIn: parent

        onSg_choice: {
            //hide();
            menuFightRoleChoice.visible = false;

            game.$sys.resources.commonScripts['fight_menus'].$actions[index](_private.nChoiceFightRoleIndex);
            return;



            //console.debug('clicked choice')
            /*switch(index) {
            //普通攻击
            case 0: {
                    FightSceneJS.showSkillsOrGoods(0);
                }
                break;

            //技能
            case 1: {

                    / * /如果装备了武器，且武器有技能
                    if(type === 1) {
                        let tWeapon = fight.myCombatants[_private.nChoiceFightRoleIndex].$equipment['武器'];
                        if(tWeapon)
                            tlistSkills = game.$sys.getGoodsResource(tWeapon.$rid).$skills;
                    }
                    //人物本身技能
                    else if(type === 0) {
                        tlistSkills = fight.myCombatants[_private.nChoiceFightRoleIndex]
                    }* /

                    FightSceneJS.showSkillsOrGoods(1);

                }
                break;

            //
            case 2:
                FightSceneJS.showSkillsOrGoods(2);

                break;

            //信息
            case 3:
                fight.$sys.showFightRoleInfo(fight.myCombatants[_private.nChoiceFightRoleIndex].$index);

                break;

            //休息
            case 4:

                /*for(let i = 0; i < fight.myCombatants.length; ++i) {
                    if(fight.myCombatants[i].$$propertiesWithExtra.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        fight.myCombatants[i].$$fightData.$choice.$targets = -2;
                        fight.myCombatants[i].$$fightData.$choice.$attack = -2;
                    }
                }
                let ret = _private.scriptQueueFighting.run();
                * /

                let combatant = fight.myCombatants[_private.nChoiceFightRoleIndex];
                combatant.$$fightData.$choice.$type = 1;
                combatant.$$fightData.$choice.$attack = undefined;
                combatant.$$fightData.$choice.$targets = undefined;

                combatant.$$fightData.$lastChoice.$type = 1;
                combatant.$$fightData.$lastChoice.$attack = undefined;
                combatant.$$fightData.$lastChoice.$targets = undefined;



                FightSceneJS.checkToFight();

                break;
            }

            */
        }
        Component.onCompleted: {
        }
    }



    //游戏消息框，暂时不用
    Message {
        id: msgbox

        visible: false

        //width: parent.width
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height
        Layout.fillHeight: true
        //implicitHeight: parent.height / 2
        //height: parent.height / 2


        nScrollHorizontal: 0
        nScrollVertical: 1


        textArea.enabled: false
        textArea.readOnly: true
        textArea.font.pointSize: 16


        nMinWidth: 0
        //nMaxWidth: parent.width
        nMinHeight: 0
        nMaxHeight: parent.height * 0.7
        //最小为2行，最大为3.5行
        //nMinHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 2 + textArea.nPadding * 2
        //nMaxHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 3.5 + textArea.nPadding * 2


        //text: ''
    }



    //按钮
    ColumnLayout {
        id: flow

        width: parent.width
        height: 50
        anchors.bottom: parent.bottom

        spacing: 20

        RowLayout {
            id: rowlayoutButtons
            Layout.alignment: Qt.AlignHCenter


            /*ColorButton {
                text: '重复上次'
                onSg_clicked: {
                    //rowlayoutButtons.enabled = false;

                    FightSceneJS.resetFightScene();

                    if(_private.nStage === 1) {
                        FightSceneJS.loadLast(true, 0);
                        _private.scriptQueueFighting.run();
                    }
                    else if(_private.nStage === 2)
                        return;

                }

            }

            /*ColorButton {
                text: '随机普通攻击'
                onSg_clicked: {
                    for(let i = 0; i < fight.myCombatants.length; ++i) {
                        if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                            //fight.myCombatants[i].$$fightData.$lastChoice.$targets = fight.myCombatants[i].$$fightData.$choice.$targets;
                            fight.myCombatants[i].$$fightData.$choice.$targets = undefined;
                        }
                    }
                }
            }* /

            ColorButton {
                text: '逃跑'
                onSg_clicked: {
                    FightSceneJS.runAway();
                }
            }

            ColorButton {
                text: _private.nAutoAttack === 0 ? '手动攻击' : '自动攻击'
                onSg_clicked: {
                    if(_private.nAutoAttack === 0) {
                        _private.nAutoAttack = 1;


                        if(_private.nStage === 1) {
                            FightSceneJS.loadLast(true, 1);
                            _private.scriptQueueFighting.run();
                        }
                        else
                            return;
                    }
                    else
                        _private.nAutoAttack = 0;
                }
            }
            */
        }

        /*GameMenu {
            id: menuGame

            Layout.preferredWidth: Screen.pixelDensity * 20
            Layout.alignment: Qt.AlignHCenter
            //width: parent.width

            //height: parent.height / 2
            //anchors.centerIn: parent

            onSg_choice: {
                fight.myCombatants[0].$$fightData.defenseProp = fight.myCombatants[0].$$fightData.attackProp = index;

                /*while(1) {
                    console.time('round');
                    let ret = _private.scriptQueueFighting.run();
                    console.timeEnd('round');
                    if(!ret.done) { //战斗没有结束
                        if(ret.value === 1) {   //1个回合结束
                            if(_private.fightRoundScript) {
                                //console.debug('运行回合事件!!!', _private.nRound)
                                GlobalJS.runScript(_private.scriptQueue, 0, _private.fightRoundScript, _private.nRound);
                                ++_private.nRound;
                            }
                            break;
                        }
                        else if(ret.value === 0) {
                            continue;
                        }
                    }
                    else {  //战斗结束
                        if(_private.fightEndScript)
                            GlobalJS.runScript(_private.scriptQueue, 0, _private.fightEndScript, ret.value);
                        if(ret.value === 1) {
                            GlobalJS.runScript(_private.scriptQueue, 0, 'yield dialogFightMsg.show(`战斗胜利获得XX经验！`, '', 100, 1);sg_fightOver();');
                        }
                        else
                            GlobalJS.runScript(_private.scriptQueue, 0, 'yield dialogFightMsg.show(`战斗失败<BR>获得  你妹的经验...`, '', 100, 1);sg_fightOver();');
                    }
                    break;
                }*/

                /*while(1) {
                    console.time('round');
                    let ret = _private.scriptQueueFighting.run();
                    console.timeEnd('round');

                    if(!ret.done) { //战斗没有结束
                        if(ret.value === 1) {   //1个回合结束
                            break;
                        }
                        else if(ret.value === 0) {
                            continue;
                        }
                    }
                    else {  //战斗结束
                    }
                    break;
                }* /

                menuGame.enabled = false;
                let ret = _private.scriptQueueFighting.run();
            }
            Component.onCompleted: {
                show(['风攻击','土攻击','雷攻击','水攻击','火攻击']);
            }
        }*/

    }



    //技能或道具 选择框
    Item {
        id: rectSkills

        anchors.fill: parent
        visible: false

        Mask {
            anchors.fill: parent
            color: '#10000000'

            mouseArea.onPressed: {
                parent.visible = false;
                //menuSkillsOrGoods.hide();
            }
        }

        Item {
            //width: parent.width * 0.5
            width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.9
            //height: parent.height * 0.5
            height: (/*rectSkillsMenuTitle.height + */menuSkillsOrGoods.implicitHeight < parent.height * 0.5) ? (/*rectSkillsMenuTitle.height + */menuSkillsOrGoods.implicitHeight) : parent.height * 0.5
            anchors.centerIn: parent

            clip: true
            //color: '#00000000'
            //border.color: 'white'
            //radius: height / 20


            //技能或道具 选择菜单
            GameMenu {
                id: menuSkillsOrGoods
                //保存类型；3为技能，2为物品
                property int nType: -1

                //radius: rectMenu.radius

                width: parent.width
                height: parent.height
                //Layout.preferredHeight: implicitHeight
                //Layout.fillHeight: true

                strTitle: '选择'
                //height: parent.height / 2
                //anchors.centerIn: parent

                onSg_choice: {
                    rectSkills.visible = false;
                    //menuSkillsOrGoods.hide();

                    FightSceneJS.choicedSkillOrGoods(arrData[index], nType);
                }
            }
        }
    }



    //战场上的调试按钮
    Row {
        visible: GameMakerGlobal.config.bDebug

        ColorButton {
            text: '调试'
            onSg_clicked: {
                dialogScript.visible = true;
            }
        }
        ColorButton {
            text: '退出战斗'
            onSg_clicked: {
                fight.over(true);

                //rootFightScene.visible = false;
                //rootGameScene.forceActiveFocus();

                //强制退出后，由于执行逻辑变化（没有按正常逻辑走），导致多次执行game.msg，返回地图模式会被暂停，所以加一个正常继续
                //game.run(() => {game.goon(true);})
            }
        }
    }

    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: '执行脚本'
        width: parent.width * 0.9
        height: Math.max(200, Math.min(parent.height, textScript.implicitHeight + 160))
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        visible: false

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: '输入脚本命令'

            //textFormat: Text.RichText
            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            //gameMap.focus = true;
            rootFightScene.forceActiveFocus();
            //GlobalJS._eval(textScript.text);
            console.debug(eval(textScript.text));
            //GlobalJS.runScript(_private.scriptQueue, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            rootFightScene.forceActiveFocus();
            //console.log('Cancel clicked');
        }
    }



    /*Audio {
        id: audioFightMusic
        loops: Audio.Infinite
    }*/


    //战斗人物的特效定时器
    Timer {
        id: timerRoleSprite
        running: false
        repeat: false
        onTriggered: {
            //let ret1 = _private.scriptQueueFighting.run();
            //let ret1 = _private.genFighting.next();
            fight.run(true);
        }
    }


    QtObject {
        id: _private

        //游戏配置/设置
        readonly property var config: QtObject {
            //property int barHeight: 6

            property var fightRoleBarConfig
        }



        //回合
        property int nRound: 0


        //自动攻击
        property int nAutoAttack: 0


        //目前我方选择的人物
        property int nChoiceFightRoleIndex: -1

        //战斗步骤：1为我方装备中；2为选择我方人物中；3为选择敌人中；1x为友军选人
        //property int nStep: 0
        property int nStage: 0  //0：停止中；1：开始战斗前；2：准备战斗；3：战斗中；-1：逃跑处理中；


        //我方按钮
        //property var arrMenu: ['普通攻击', '技能', '物品', '信息', '休息']


        //逃跑概率
        property var runAwayPercent
        //逃跑标记（0为没有，n为n次逃跑，-1为一直逃跑）
        property int nRunAwayFlag: 0


        //战斗脚本（只用来运行gfFighting；所以也可以直接用Generator对象）
        //property var genFighting
        //readonly property var scriptQueueFighting: new GlobalLibraryJS.ScriptQueue()

        readonly property var asyncScript: new GlobalLibraryJS.AsyncScript();

        //异步脚本（播放特效、事件等）
        readonly property var scriptQueue: new GlobalLibraryJS.ScriptQueue()
        //property var scriptQueue: game.$caches.scriptQueue

        //战斗选择 异步脚本
        property var genFightChoice: null


        //所有特效临时存放（退出时清空）
        property var mapSpriteEffectsTemp: ({})

        ////property var arrTempLoopedAllFightRoles: [] //每次战斗循环的所有临时战斗人物

    }



    //应用程序信号
    Connections {
        target: Qt.application
        //忽略没有的信号
        ignoreUnknownSignals: true

        function onStateChanged() {
            switch(Qt.application.state) {
            case Qt.ApplicationActive:   //每次窗口激活时触发
                break;
            case Qt.ApplicationInactive:    //每次窗口非激活时触发
                break;
            case Qt.ApplicationSuspended:   //程序挂起（比如安卓的后台运行、息屏）
                break;
            case Qt.ApplicationHidden:
                break;
            }
        }
    }

    Connections {
        target: rootWindow
        //忽略没有的信号
        ignoreUnknownSignals: true

        //function onSg_signalHandler(v) {
        //}
        function onSg_messageHandler(msgType, msg) {
        }
        function onRAspectRatioChanged() {
            FightSceneJS.resetRolesPosition();
        }
    }



    Keys.onEscapePressed: {
        //FightSceneJS.fightOver(-1);
        event.accepted = true;

        console.debug('[FightScene]Keys.onEscapePressed');
    }
    Keys.onBackPressed: {
        //FightSceneJS.fightOver(-1);
        event.accepted = true;

        console.debug('[FightScene]Keys.onBackPressed');
    }


    Component.onCompleted: {
        /*let tb = compBar.createObject(itemTmp);
        tb.implicitWidth = 200;
        tb.implicitHeight = 20;
        tb.refresh([100, 70, 50);

        let tb1 = compBar.createObject(itemTmp);
        tb1.implicitWidth = 100;
        tb1.implicitHeight = 20;
        tb1.refresh([100, 50, 20);
        //console.debug(tb, tb1, tb.refresh === tb1.refresh)
        */


        FrameManager.sl_globalObject().fight = fight;

        console.debug('[FightScene]Component.onCompleted');
    }

    Component.onDestruction: {

        //鹰：有可能多次创建GameScene，所以要删除最后一次赋值的（比如热重载地图测试时，不过已经解决了）；
        //if(FrameManager.sl_globalObject().fight === fight)
        //    delete FrameManager.sl_globalObject().fight;

        console.debug('[FightScene]Component.onDestruction');
    }

}
