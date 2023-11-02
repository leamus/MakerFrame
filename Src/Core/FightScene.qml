import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtMultimedia 5.14
import Qt.labs.settings 1.1


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0

//import LGlobal 1.0


import "qrc:/QML"


//import "GameMakerGlobal.js" as GameMakerGlobalJS

import "FightScene.js" as FightSceneJS
//import "File.js" as File


/*
    鹰：_private.myCombatants 和 _private.enemies 是 我方和敌方 的数据（$Combatant()返回的对象）
      repeaterMyCombatants 和 repeaterEnemies 是 我方和敌方 的精灵组件，和上面一一对应，用itemAt()来获取
*/



Item {
    id: rootFightScene



    property QtObject fight: QtObject {
        readonly property alias myCombatants: _private.myCombatants
        readonly property alias enemies: _private.enemies

        property alias nAutoAttack: _private.nAutoAttack
        readonly property var saveLast: _private.saveLast
        readonly property var loadLast: _private.loadLast



        //result：为undefined 发送fightOver信号（关闭战斗画面并清理）；为null则判断战斗是否结束；为其他值（0平1胜-1败-2逃跑）执行事件（事件中调用结束信号）；
        //流程：手动或自动 游戏结束，调用依次_private.fightOver，执行脚本，然后通用战斗结束脚本中结尾调用 fight.over() 来清理战斗即可；
        readonly property var over: function(result) {
            if(result === undefined) {
                s_FightOver();
                return;
            }
            else {
                let fightResult = game.$sys.resources.commonScripts["check_all_combatants"](_private.myCombatants, repeaterMyCombatants, _private.enemies, repeaterEnemies);
                if(result !== null) {
                    fightResult.result = result;
                    _private.fightOver(fightResult);
                    return;
                }
                else
                    return fightResult;
            }

        }

        readonly property var msg: function(msg, interval=20, pretext='', keeptime=0, style={Type: 0b11}, callback=true) {
            //game.msg(msg, interval, pretext, keeptime, style);

            //样式
            if(style === undefined || style === null)
                style = {};
            else if(GlobalLibraryJS.isValidNumber(style))
                style = {Type: style};


            dialogFightMsg.item.callback = function(code, itemMsg) {
                itemMsg.visible = false;
                _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
            }


            //回调函数
            if(callback === true) {
                callback = function(code, itemMsg) {
                    itemMsg.visible = false;
                    fight.run(true);
                    //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                }
            }
            dialogFightMsg.item.callback = callback;


            dialogFightMsg.item.show(msg.toString(), pretext.toString(), interval, keeptime, style);


            return true;
        }

        //显示一个菜单；
        //title为显示文字；
        //items为选项数组；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor、ItemHeight、TitleHeight；
        //pauseGame是否暂停游戏；
        //返回值为选择的下标（0开始）；
        //注意：该脚本必须用yield才能暂停并接受返回值。
        readonly property var menu: function(title, items, style={}, callback=true) {

            let itemMenu = loaderFightMenu.item;
            let maskMenu = loaderFightMenu.item.maskMenu;
            let menuGame = loaderFightMenu.item.menuGame;


            //样式
            if(!style)
                style = {};
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$menu') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$menu;

            maskMenu.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;
            menuGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            menuGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            menuGame.nItemHeight = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
            menuGame.nTitleHeight = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
            menuGame.nItemFontSize = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
            menuGame.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
            menuGame.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
            menuGame.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
            menuGame.nTitleFontSize = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
            menuGame.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
            menuGame.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
            menuGame.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;


            menuGame.strTitle = title;
            itemMenu.visible = true;


            if(callback === true) {   //默认回调函数
                callback = function(index, itemMenu) {
                    itemMenu.visible = false;
                    fight.run(true, {Value: index});
                    //_private.asyncScript.run(index);
                }
            }
            loaderFightMenu.item.callback = callback;


            menuGame.show(items);
        }

        readonly property var choicemenu: function(title, items, style={}) {
            menu(title, items, style, function(index, itemMenu) {
                itemMenu.visible = false;

                _private.skillChoice(2, index);
            });
        }


        readonly property var background: function(image='') {
            //console.debug('!!!!image:::', image, Global.toURL(GameMakerGlobal.imageResourceURL(image)))
            imageBackground.source = Global.toURL(GameMakerGlobal.imageResourceURL(image));
        }


        //参数同 game.run
        readonly property var run: function(vScript, scriptProps=-1, ...params) {
            if(vScript === undefined) {
                console.warn('[!FightScene]运行脚本未定义!!!');
                return false;
            }


            //参数
            let priority, runType = 0, running = 1, value;
            if(GlobalLibraryJS.isObject(scriptProps)) { //如果是参数对象
                priority = GlobalLibraryJS.isValidNumber(scriptProps.Priority) ? scriptProps.Priority : -1;
                runType = GlobalLibraryJS.isValidNumber(scriptProps.Type) ? scriptProps.Type : 0;
                running = GlobalLibraryJS.isValidNumber(scriptProps.Running) ? scriptProps.Running : 1;
                value = Object.keys(scriptProps).indexOf('Value') < 0 ? _private.asyncScript.lastEscapeValue : scriptProps.Value;
            }
            else if(GlobalLibraryJS.isValidNumber(scriptProps)) {   //如果是数字，则默认是优先级
                priority = scriptProps;
                runType = 0;
                running = 1;
                value = _private.asyncScript.lastEscapeValue;
            }
            else {
                console.warn('[!FightScene]运行脚本属性错误!!!');
                return false;
            }


            //直接运行
            if(vScript === null) {
                _private.asyncScript.run(value);
                return 1;
            }

            //下次js循环运行
            if(vScript === true) {
                /*GlobalLibraryJS.runNextEventLoop(function() {
                    //game.goon('$event');
                        _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }, 'fight.run1');
                */
                _private.asyncScript.lastEscapeValue = value;
                _private.asyncScript.runNextEventLoop('fight.run1');

                return 0;
            }


            if(runType === 0) { //vScript是代码

            }
            else {  //vScript是文件名
                let tScript;
                if(GlobalLibraryJS.isArray(vScript)) {
                    tScript = vScript[0];
                }
                else {
                    tScript = vScript;
                }

                tScript = tScript.trim();
                if(!scriptProps.Path)
                    scriptProps.Path = game.$projectpath;

                if(GlobalLibraryJS.isArray(vScript))
                    vScript[0] = scriptProps.Path + GameMakerGlobal.separator + tScript;
                else
                    vScript = scriptProps.Path + GameMakerGlobal.separator + tScript;
            }

            //可以立刻执行
            if(GlobalJS.createScript(_private.asyncScript, runType, priority, vScript, ...params) === 0) {
                //暂停游戏主Timer，否则有可能会Timer先超时并运行game.run(null)，导致执行两次
                //game.pause('$event');

                if(running === 1) {
                    //GlobalLibraryJS.setTimeout(function() {
                    /*GlobalLibraryJS.runNextEventLoop(function() {
                        //game.goon('$event');
                            _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                        }, 'fight.run');
                    */
                    _private.asyncScript.lastEscapeValue = value;
                    _private.asyncScript.runNextEventLoop('fight.run');
                }
                else if(running === 2)
                    _private.asyncScript.run(value);

                return 0;
            }
        }

        //!!!鹰：NO
        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, priority, filePath) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, priority, filePath) === 0)
                return _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
        }


        readonly property var continueFight: function(type=0) {
            if(type === 1)
                //将 continueFight 放在脚本队列最后
                fight.run([function() {

                    //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 asyncScript）
                    //否则导致递归代码：在 asyncScript执行genFighting（执行continueFight），continueFight又会继续向下执行到asyncScript，导致递归运行!!!
                    GlobalLibraryJS.setTimeout(function() {
                        //开始运行
                        _private.genFighting.run();
                    },0,rootFightScene, 'fight.continueFight');

                }, 'continueFight']);
            else
                _private.genFighting.run();

        }

        //刷新战斗人物（目前只是血量）
        readonly property var refreshCombatant: function(combatant) {
            if(combatant.$$fightData && combatant.$$fightData.$info && combatant.$$fightData.$info.$spriteEffect)
                combatant.$$fightData.$info.$spriteEffect.propertyBar.refresh(combatant.$properties.HP);
            //repeaterMyCombatants.itemAt(i).propertyBar.refresh(_private.myCombatants[i].$properties.HP);
        }

        property var d: ({})


        readonly property var $sys: ({
            container: itemRolesContainer,

            showSkillsOrGoods: _private.showSkillsOrGoods,
            showFightRoleInfo: function(nIndex){_private.showFightRoleInfo(nIndex);},
            checkToFight: _private.checkToFight,

            getCombatantSkills: _private.getCombatantSkills,

            gfChoiceSingleCombatantSkill: FightSceneJS.gfChoiceSingleCombatantSkill,
            gfNoChoiceSkill: FightSceneJS.gfNoChoiceSkill,

            components: {
                menuSkillsOrGoods: menuSkillsOrGoods,
                menuFightRoleChoice: menuFightRoleChoice,

                spriteEffectMyCombatants: repeaterMyCombatants,
                spriteEffectEnemies: repeaterEnemies,
            },

            insertFightRole: function(index, fightrole, teamID) {
                fightrole = game.$sys.getFightRoleObject(fightrole, false);
                if(!fightrole)
                    return null;

                switch(teamID) {
                case 0:
                    if(index < 0 || index > _private.myCombatants.length)
                        index = _private.myCombatants.length;

                    _private.myCombatants.splice(index, 0, fightrole);
                    repeaterMyCombatants.model.insert(index, {modelData: index});
                    FightSceneJS.resetFightRole(fightrole, repeaterMyCombatants.itemAt(index), index, teamID);

                    for(; index < _private.myCombatants.length; ++index)
                        _private.myCombatants[index].$$fightData.$info.$index = index;

                    ++repeaterMyCombatants.nCount;

                    break;
                case 1:
                    if(index < 0 || index > _private.enemies.length)
                        index = _private.enemies.length;

                    _private.enemies.splice(index, 0, fightrole);
                    repeaterEnemies.model.insert(index, {modelData: index});
                    FightSceneJS.resetFightRole(fightrole, repeaterEnemies.itemAt(index), index, teamID);

                    for(; index < _private.enemies.length; ++index)
                        _private.enemies[index].$$fightData.$info.$index = index;

                    ++repeaterEnemies.nCount;

                    break;
                }

                //_private.refreshFightRoleAction(fighthero, "Normal", AnimatedSprite.Infinite);
                refreshAllFightRoleInfo();
                _private.resetRolesPosition();

                return fightrole;
            },

            removeFightRole: function(index, teamID) {
                let ret = null;

                switch(teamID) {
                case 0:
                    if(index < 0 || index >= _private.myCombatants.length)
                        return false;

                    ret = _private.myCombatants.splice(index, 1);
                    repeaterMyCombatants.model.remove(index, 1);
                    ret[0].$$fightData.$info.$index = -1;
                    ////_private.arrTempLoopedAllFightHeros.splice(_private.arrTempLoopedAllFightHeros.indexOf(ret[0]), 1);

                    for(; index < _private.myCombatants.length; ++index)
                        _private.myCombatants[index].$$fightData.$info.$index = index;

                    --repeaterMyCombatants.nCount;

                    break;
                case 1:
                    if(index < 0 || index >= _private.enemies.length)
                        return false;

                    ret = _private.enemies.splice(index, 1);
                    repeaterEnemies.model.remove(index, 1);
                    ret[0].$$fightData.$info.$index = -1;
                    ////_private.arrTempLoopedAllFightHeros.splice(_private.arrTempLoopedAllFightHeros.indexOf(ret[0]), 1);

                    for(; index < _private.enemies.length; ++index)
                        _private.enemies[index].$$fightData.$info.$index = index;

                    --repeaterEnemies.nCount;

                    break;
                }

                //_private.refreshFightRoleAction(fighthero, "Normal", AnimatedSprite.Infinite);
                refreshAllFightRoleInfo();
                _private.resetRolesPosition();

                return ret;
             },
        })
    }



    property alias asyncScript: _private.asyncScript


    //property var arrFightGenerators: []



    signal s_FightOver();
    onS_FightOver: {
        //audioFightMusic.stop();

        _private.resetFightScene();

        fight.d = {};

        _private.asyncScript.clear(1);
        _private.genFighting.clear();
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        //_private.enemies = [];
        //_private.arrTempLoopedAllFightHeros = [];
        //_private.nRound = 0;
        ////_private.nStep = 0;
        _private.nStage = 0;

        //repeaterEnemies.model = 0;
        //repeaterMyCombatants.model = 0;

        for(let tSpriteEffectIndex in _private.mapSpriteEffectsTemp) {
            _private.mapSpriteEffectsTemp[tSpriteEffectIndex].destroy();
        }
        _private.mapSpriteEffectsTemp = {};


        for(let i in _private.myCombatants) {
            //_private.myCombatants[i].$$fightData.$buffs = {};

            //必须清空lastTarget，否则有可能下次指向不存在的敌人
            _private.myCombatants[i].$$fightData.$lastChoice.$targets = undefined;
            _private.myCombatants[i].$$fightData.$choice.$targets = undefined;
            delete _private.myCombatants[i].$$fightData.$info;
        }



        rootGameScene.focus = true;
        rootFightScene.visible = false;

        game.stage(0);
        //_private.nStage = 0;
        game.goon('$fight');

        game.run(true);

        //升级检测
        //for(let h in game.gd["$sys_fight_heros"]) {
        //    game.levelup(game.gd["$sys_fight_heros"][h]);
        //}
    }



    function *init(fightScriptData) {
        console.debug("[FightScene]init", fightScriptData);

        fight.d = {};

        _private.genFighting.clear();
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        _private.enemies = [];
        ////_private.arrTempLoopedAllFightHeros = [];
        _private.nRound = 0;
        //_private.nStep = 0;
        _private.nStage = 0;

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

            let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + fightScript + GameMakerGlobal.separator + "fight_script.json";
            //let data = File.read(filePath);
            //console.debug("[GameFightScript]filePath：", filePath);

            data = FrameManager.sl_qml_ReadFile(filePath);
            data = JSON.parse(data);

            if(data === "") {
                return;
            }
        }
        else
            return;
        */

        //let data = game.loadjson(GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + fightScript + GameMakerGlobal.separator + "fight_script.js");
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
            GlobalJS.printException(e);
            return false;
        }*/

        //data = data.$createData(fightScriptParams);
        //data.__proto__ = _private.fightInfo;
        _private.fightData = fightScriptData;


        _private.runAway = (fightScriptData.$runAway === undefined ? true : fightScriptData.$runAway);




        //我方
        _private.myCombatants = [...game.fighthero()];


        //敌方

        //敌人数量
        let enemyCount;
        let enemyRandom = false;    //随机排列

        //如果是数组
        if(GlobalLibraryJS.isArray(fightScriptData.$enemyCount)) {
            if(fightScriptData.$enemyCount.length === 1)
                enemyCount = fightScriptData.$enemyCount[0];
            else
                enemyCount = GlobalLibraryJS.random(fightScriptData.$enemyCount[0], fightScriptData.$enemyCount[1] + 1);

            enemyRandom = true;
        }
        else if(fightScriptData.$enemyCount === true) {
            enemyCount = fightScriptData.$enemiesData.length;
        }
        else {
            enemyCount = fightScriptData.$enemyCount;   //如果是数字
        }

        _private.enemies.length = enemyCount;

        for(let i = 0; i < _private.enemies.length; ++i) {
            let tIndex;
            if(enemyRandom) //随机
                tIndex = GlobalLibraryJS.random(0, fightScriptData.$enemiesData.length);
            else    //顺序
                tIndex = i % fightScriptData.$enemiesData.length;

            //创建敌人
            _private.enemies[i] = game.$sys.getFightRoleObject(fightScriptData.$enemiesData[tIndex], true);

            //从 propertiesWithExtra 设置人物的 HP和MP
            //fight.run(function() {
                game.addprops(_private.enemies[i], {HP: 2, MP: 1}, 0);
            //});
        }


        //初始化脚本
        if(game.$sys.resources.commonScripts["fight_init_script"]) {
            yield fight.run([game.$sys.resources.commonScripts["fight_init_script"], 'fight_init_script'], -2, [_private.myCombatants, _private.enemies], fightScriptData)
        }


        let i;


        //创建战斗角色精灵
        ////组件会全部重新创建（已修改为动态创建）

        //我方
        //repeaterMyCombatants.model =
        repeaterMyCombatants.nCount = _private.myCombatants.length;
        for(i = 0; i < _private.myCombatants.length; ++i) {
            if(repeaterMyCombatants.model.count <= i)
                repeaterMyCombatants.model.append({modelData: i});
            repeaterMyCombatants.itemAt(i).visible = true;


            FightSceneJS.resetFightRole(_private.myCombatants[i], repeaterMyCombatants.itemAt(i), i, 0);

        }
        for(; i < repeaterMyCombatants.model.count; ++i)
            repeaterMyCombatants.itemAt(i).visible = false;



        //敌方
        //repeaterEnemies.model = _private.enemies.length = enemyCount;
        repeaterEnemies.nCount = _private.enemies.length;
        for(i = 0; i < _private.enemies.length; ++i) {
            if(repeaterEnemies.model.count <= i)
                repeaterEnemies.model.append({modelData: i});
            repeaterEnemies.itemAt(i).visible = true;


            FightSceneJS.resetFightRole(_private.enemies[i], repeaterEnemies.itemAt(i), i, 1);

        }
        //隐藏剩下的
        for(; i < repeaterEnemies.model.count; ++i)
            repeaterEnemies.itemAt(i).visible = false;



        _private.resetFightScene();

        refreshAllFightRoleInfo();
        _private.resetRolesPosition();


        yield fight.run([game.$sys.resources.commonScripts["fight_start_script"]([_private.myCombatants, _private.enemies,], _private.fightData), 'fight start1'], -2);


        //GlobalLibraryJS.setTimeout(function() {
            //战斗起始脚本
            //if(_private.fightStartScript) {
            //    fight.run([_private.fightStartScript, 'fight start2'], -1, [_private.myCombatants, _private.enemies,], _private.fightData);
            //}


        //}, 1, rootFightScene);



        _private.genFighting.create(_private.gfFighting(), 'gfFighting', -1);

        //将 continueFight 放在脚本队列最后
        fight.run([function() {

            //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 asyncScript）
            //否则导致递归代码：在 asyncScript执行genFighting（执行continueFight），continueFight又会继续向下执行到asyncScript，导致递归运行!!!
            GlobalLibraryJS.setTimeout(function() {
                //开始运行
                let ret = _private.genFighting.run();
            },0,rootFightScene,'fight init');

        }, 'FightingStart']);

    }

    //刷新所有人物信息（目前只是血条）
    function refreshAllFightRoleInfo() {
        for(let i = 0; i < _private.myCombatants.length /*repeaterMyCombatants.nCount*/; ++i) {
            fight.refreshCombatant(_private.myCombatants[i]);
            //repeaterMyCombatants.itemAt(i).propertyBar.refresh(_private.myCombatants[i].$properties.HP);
        }
        for(let i = 0; i < _private.enemies.length /*repeaterEnemies.nCount*/; ++i) {
            fight.refreshCombatant(_private.enemies[i]);
            //repeaterEnemies.itemAt(i).propertyBar.refresh(_private.enemies[i].$properties.HP);
        }

    }



    focus: true
    anchors.fill: parent



    Component {
        id: compBar

        Rectangle {
            id: trootBar

            anchors.fill: parent

            color: "#800080"
            antialiasing: false
            radius: height / 3
            clip: true

            property Rectangle bar1: Rectangle {
                parent: trootBar
                height: parent.height
                color: "red"
                antialiasing: false
                radius: height / 3
            }
            property Rectangle bar2: Rectangle {
                parent: trootBar
                height: parent.height
                color: "yellow"
                antialiasing: false
                radius: height / 3
            }

            function refresh(data) {
                let d0 = (data[0] > 0 ? data[0] : 0);
                let d1 = (data[1] > 0 ? data[1] : 0);
                let d2 = (data[2] > 0 ? data[2] : 0);
                if(data.length === 2) {
                    bar1.width = width;
                    bar2.width = d0 / d1 * width;
                }
                else if(data.length === 3) {
                    bar1.width = d1 / d2 * width;
                    bar2.width = d0 / d2 * width;
                }
            }
        }
    }


    //背景
    Rectangle {
        anchors.fill: parent
        color: 'black'

        Image {
            id: imageBackground
            anchors.fill: parent
            //source: "FightScene1.jpg"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                _private.resetFightScene();

                //_private.nStep = 1;

                mouse.accepted = true;
            }
        }
    }


    //战斗人物容器
    Item {
        id: itemRolesContainer
        width: rootFightScene.width
        height: rootFightScene.height

    //ColumnLayout {
    //    width: parent.width / 2
    //    height: parent.height / 2

        //所有我方组件
        Repeater {
            id: repeaterMyCombatants

            //!!废弃，兼容用
            property int nCount: 0


            //model: 0
            model: ListModel{}

            SpriteEffect {
                //id: tSpriteEffectMyCombatantBar

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: false

                property var propertyBar: loaderMyCombatantPropertyBar.item
                property alias strName: textMyCombatantsName.text

                property bool bCanClick: false


                Text {
                    id: textMyCombatantsName

                    anchors.bottom: loaderMyCombatantPropertyBar.bottom
                    anchors.bottomMargin: 10
                    width: parent.width

                    color: "white"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    textFormat: Text.RichText
                    font.pointSize: 10
                    font.bold: true
                    //wrapMode: Text.Wrap
                }

                Loader {
                    id: loaderMyCombatantPropertyBar

                    anchors.bottom: parent.top
                    anchors.bottomMargin: 10
                    width: parent.width
                    height: _private.config.barHeight

                    sourceComponent: compBar
                    asynchronous: false
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //if(!parent.animatedsprite.running)
                        //    return;

                        //弹出菜单
                        if(_private.genFightChoice === null) {
                        //if(_private.nStep === 1) {

                            //没血的跳过
                            if(_private.myCombatants[modelData].$properties.HP[0] <= 0)
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
                            //let style = game.$sys.resources.commonScripts["$fight_menu"].$styles;
                            let style = {};
                            //样式
                            if(!style)
                                style = {};
                            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$fight_menu') || {};
                            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$fight_menu;

                            //maskMenu.color = style.MaskColor || '#7FFFFFFF';
                            menuFightRoleChoice.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                            menuFightRoleChoice.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                            menuFightRoleChoice.nItemHeight = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
                            menuFightRoleChoice.nTitleHeight = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
                            menuFightRoleChoice.nItemFontSize = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
                            menuFightRoleChoice.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
                            menuFightRoleChoice.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
                            menuFightRoleChoice.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
                            menuFightRoleChoice.nTitleFontSize = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
                            menuFightRoleChoice.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
                            menuFightRoleChoice.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
                            menuFightRoleChoice.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;
                            //menuFightRoleChoice.show(_private.arrMenu);
                            menuFightRoleChoice.show(game.$sys.resources.commonScripts["fight_menu"].$menu);
                        }
                        else if(parent.bCanClick === true) {
                            _private.skillChoice(1, _private.myCombatants[modelData]);
                        }

                        return;
                    }
                }

                onS_playEffect: {
                    game.$sys.playSoundEffect(soundeffectSource);
                }
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

            //!!废弃，兼容用
            property int nCount: 0


            //model: 0
            model: ListModel{}

            SpriteEffect {
                //id: tSpriteEffectEnemy

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: false

                property var propertyBar: loaderEnemyPropertyBar.item
                property alias strName: textEnemyName.text

                property bool bCanClick: false


                Text {
                    id: textEnemyName

                    anchors.bottom: loaderEnemyPropertyBar.bottom
                    anchors.bottomMargin: 10
                    width: parent.width

                    color: "white"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    textFormat: Text.RichText
                    font.pointSize: 10
                    font.bold: true
                    //wrapMode: Text.Wrap
                }


                Loader {
                    id: loaderEnemyPropertyBar

                    anchors.bottom: parent.top
                    anchors.bottomMargin: 10
                    width: parent.width
                    height: _private.config.barHeight

                    sourceComponent: compBar
                    asynchronous: false
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //不是选择敌方
                        //if(_private.nStep !== 3)
                        //    return;

                        if(_private.genFightChoice !== null) {
                            if(parent.bCanClick === true) {
                                _private.skillChoice(1, _private.enemies[modelData]);
                            }
                        }
                    }
                }

                onS_playEffect: {
                    game.$sys.playSoundEffect(soundeffectSource);
                }

                Component.onCompleted: {
                    //colorOverlayStart();
                }
            }
        }
    //}


        /*
        NumberAnimation {
            id: numberanimationSpriteEffectX
            //target: handle.anchors
            properties: "x"
            //to: 0
            //duration: 200
            easing.type: Easing.OutSine
        }
        NumberAnimation {
            id: numberanimationSpriteEffectY
            //target: handle.anchors
            properties: "y"
            //to: 0
            //duration: 200
            easing.type: Easing.OutSine
        }*/

    }

    //战斗人物的 选择主菜单
    GameMenu {
        id: menuFightRoleChoice

        visible: false
        width: 100
        height: implicitHeight
        anchors.centerIn: parent

        onS_Choice: {
            //hide();
            menuFightRoleChoice.visible = false;

            game.$sys.resources.commonScripts["fight_menu"].$actions[index](_private.nChoiceFightRoleIndex);
            return;



            //console.debug("clicked choice")
            switch(index) {
            //普通攻击
            case 0: {
                    _private.showSkillsOrGoods(0);
                }
                break;

            //技能
            case 1: {

                    /*/如果装备了武器，且武器有技能
                    if(type === 1) {
                        let tWeapon = _private.myCombatants[_private.nChoiceFightRoleIndex].$equipment['武器'];
                        if(tWeapon)
                            tlistSkills = game.$sys.getGoodsResource(tWeapon.$rid).$skills;
                    }
                    //人物本身技能
                    else if(type === 0) {
                        tlistSkills = _private.myCombatants[_private.nChoiceFightRoleIndex]
                    }*/

                    _private.showSkillsOrGoods(1);

                }
                break;

            //
            case 2:
                _private.showSkillsOrGoods(2);

                break;

            //信息
            case 3:
                fight.$sys.showFightRoleInfo(_private.myCombatants[_private.nChoiceFightRoleIndex].$index);

                break;

            //休息
            case 4:

                /*for(let i = 0; i < _private.myCombatants.length; ++i) {
                    if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        _private.myCombatants[i].$$fightData.$choice.$targets = -2;
                        _private.myCombatants[i].$$fightData.$choice.$attack = -2;
                    }
                }
                let ret = _private.genFighting.run();
                */

                let combatant = _private.myCombatants[_private.nChoiceFightRoleIndex];
                combatant.$$fightData.$choice.$type = 1;
                combatant.$$fightData.$choice.$attack = undefined;
                combatant.$$fightData.$choice.$targets = undefined;

                combatant.$$fightData.$lastChoice.$type = 1;
                combatant.$$fightData.$lastChoice.$attack = undefined;
                combatant.$$fightData.$lastChoice.$targets = undefined;



                _private.checkToFight();

                break
            }
        }
        Component.onCompleted: {
        }
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


            ColorButton {
                text: "重复上次"
                onButtonClicked: {
                    //rowlayoutButtons.enabled = false;

                    _private.resetFightScene();

                    if(_private.nStage === 1) {
                        _private.loadLast(true, 0);
                        _private.genFighting.run();
                    }
                    else if(_private.nStage === 2)
                        return;

                }

            }

            /*ColorButton {
                text: "随机普通攻击"
                onButtonClicked: {
                    for(let i = 0; i < _private.myCombatants.length; ++i) {
                        if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                            //_private.myCombatants[i].$$fightData.$lastChoice.$targets = _private.myCombatants[i].$$fightData.$choice.$targets;
                            _private.myCombatants[i].$$fightData.$choice.$targets = undefined;
                        }
                    }
                }
            }*/

            ColorButton {
                text: "逃跑"
                onButtonClicked: {
                    //rowlayoutButtons.enabled = false;

                    _private.resetFightScene();

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

                        for(let i = 0; i < _private.myCombatants.length; ++i) {
                            if(_private.myCombatants[i].$properties.HP[0] > 0) {
                            //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                                //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                                game.$sys.resources.commonScripts["fight_combatant_choice"](_private.myCombatants[i], 1, false);
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
            }

            ColorButton {
                text: _private.nAutoAttack === 0 ? "手动攻击" : '自动攻击'
                onButtonClicked: {
                    if(_private.nAutoAttack === 0) {
                        _private.nAutoAttack = 1;


                        if(_private.nStage === 1) {
                            _private.loadLast(true, 1);
                            _private.genFighting.run();
                        }
                        else
                            return;
                    }
                    else
                        _private.nAutoAttack = 0;
                }
            }

            /*ColorButton {
                text: "逃跑"
                onButtonClicked: {
                    rowlayoutButtons.enabled = false;
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

            onS_Choice: {
                _private.myCombatants[0].$$fightData.defenseProp = _private.myCombatants[0].$$fightData.attackProp = index;

                /*while(1) {
                    console.time("round");
                    let ret = _private.genFighting.run();
                    console.timeEnd("round");
                    if(!ret.done) { //战斗没有结束
                        if(ret.value === 1) {   //1个回合结束
                            if(_private.fightRoundScript) {
                                //console.debug("运行回合事件!!!", _private.nRound)
                                GlobalJS.runScript(_private.asyncScript, 0, _private.fightRoundScript, _private.nRound);
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
                            GlobalJS.runScript(_private.asyncScript, 0, _private.fightEndScript, ret.value);
                        if(ret.value === 1) {
                            GlobalJS.runScript(_private.asyncScript, 0, 'yield dialogFightMsg.show(`战斗胜利获得XX经验！`, "", 100, 1);s_FightOver();');
                        }
                        else
                            GlobalJS.runScript(_private.asyncScript, 0, 'yield dialogFightMsg.show(`战斗失败<BR>获得  你妹的经验...`, "", 100, 1);s_FightOver();');
                    }
                    break;
                }*/

                /*while(1) {
                    console.time("round");
                    let ret = _private.genFighting.run();
                    console.timeEnd("round");

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
                let ret = _private.genFighting.run();
            }
            Component.onCompleted: {
                show(["风攻击","土攻击","雷攻击","水攻击","火攻击"]);
            }
        }*/



        //游戏消息框，暂时不用
        Message {
            id: msgbox
            //width: parent.width
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.fillHeight: true
            //implicitHeight: parent.height / 2
            //height: parent.height / 2
            textArea.readOnly: true
            //text: ""
            visible: false
        }
    }



    //技能或道具 选择框
    Item {
        id: rectSkills

        anchors.fill: parent
        visible: false

        Mask {
            anchors.fill: parent
            color: "#10000000"

            mouseArea.onPressed: {
                parent.visible = false;
                //menuSkillsOrGoods.hide();
            }
        }

        Rectangle {
            //width: parent.width * 0.5
            width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.9
            //height: parent.height * 0.5
            height: (/*rectSkillsMenuTitle.height + */menuSkillsOrGoods.implicitHeight < parent.height * 0.5) ? (/*rectSkillsMenuTitle.height + */menuSkillsOrGoods.implicitHeight) : parent.height * 0.5
            anchors.centerIn: parent

            clip: true
            color: "#00000000"
            border.color: "white"
            radius: height / 20


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

                strTitle: "选择"
                //height: parent.height / 2
                //anchors.centerIn: parent

                onS_Choice: {
                    rectSkills.visible = false;
                    //menuSkillsOrGoods.hide();

                    _private.choicedSkillOrGoods(arrData[index], nType);
                }
            }
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

            function onS_Choice(index) {
            }
        }
        */

        onLoaded: {
            //改变回调函数
        }
    }



    //战场的消息框
    Loader {
        id: dialogFightMsg

        visible: true
        anchors.fill: parent
        //z: 6

        sourceComponent: compGameMsg
        asynchronous: false

        Connections {
            target: dialogFightMsg.item

            /*function onAccepted() {
            }

            function onRejected() {
            }
            */
        }

        onLoaded: {
            //改变回调函数
        }
    }



    //战场上的调试按钮
    Row {
        visible: GameMakerGlobal.config.debug

        ColorButton {
            text: "调试"
            onButtonClicked: {
                dialogScript.visible = true;
            }
        }
        ColorButton {
            text: "退出战斗"
            onButtonClicked: {
                fight.over(-2);
                //强制退出后，由于执行逻辑变化（没有按正常逻辑走），导致多次执行game.msg，返回地图模式会被暂停，所以加一个正常继续
                game.run(() => {game.goon(true);})
            }
        }
    }

    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: "执行脚本"
        width: parent.width * 0.9
        height: Math.max(200, Math.min(parent.height, textScript.implicitHeight + 160))
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        visible: false

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: "输入脚本命令"

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
            //GlobalJS.runScript(_private.asyncScript, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            rootFightScene.forceActiveFocus();
            //console.log("Cancel clicked");
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
            let ret = _private.genFighting.run();
        }
    }


    QtObject {
        id: _private

        //游戏配置/设置
        property var config: QtObject {
            property int barHeight: 6
        }



        //我方和敌方数据
        //内容为：$Combatant() 返回的对象（包含各种数据）
        property var myCombatants: []
        property var enemies: []                //动态创建



        //回合
        property int nRound: 0


        //自动攻击
        property int nAutoAttack: 0


        //目前我方选择的人物
        property int nChoiceFightRoleIndex: -1

        //战斗步骤：1为我方装备中；2为选择我方人物中；3为选择敌人中；1x为友军选人
        //property int nStep: 0
        property int nStage: 0  //1：准备中；2：战斗中


        //我方按钮
        //property var arrMenu: ["普通攻击", "技能", "物品", '信息', "休息"]


        //脚本
        //property var fightInfo
        property var fightData  //脚本数据
        //property var fightRoundScript
        //property var fightStartScript
        //property var fightEndScript

        //逃跑
        property var runAway


        //战斗脚本（也可以直接用Generator对象）
        property var genFighting: new GlobalLibraryJS.Async(rootFightScene)

        //异步脚本（播放特效、事件等）
        property var asyncScript: new GlobalLibraryJS.Async(rootFightScene)

        //战斗选择 异步脚本
        property var genFightChoice: null


        //所有特效临时存放（退出时清空）
        property var mapSpriteEffectsTemp: ({})

        ////property var arrTempLoopedAllFightHeros: [] //每次战斗循环的所有临时战斗人物






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

                [arrSkillsName, arrSkills] = _private.getCombatantSkills(_private.myCombatants[_private.nChoiceFightRoleIndex], [0]);

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

                [arrSkillsName, arrSkills] = _private.getCombatantSkills(_private.myCombatants[_private.nChoiceFightRoleIndex], [1]);

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

            //检测技能 或 道具是否可以使用
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
                    _private.genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}});
                }

                //目标己方
                else if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && (skill.$targetFlag & 0b1)) {
                    _private.genFightChoice = FightSceneJS.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b1, Filter: function(targetCombatant, combatant){if(targetCombatant.$$fightData.$info.$index >= 0 && targetCombatant.$properties.HP[0] > 0)return true;return false;}});
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

                    _private.saveLast(combatant);


                    //if(_private.nChoiceFightRoleIndex < 0 || _private.nChoiceFightRoleIndex >= _private.myCombatants.length)
                    //    return;

                    //检测技能 或 道具是否可以使用
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
                if(_private.myCombatants[i].$properties.HP[0] > 0) {
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
            for(let tValue of genFightRolesRound) {
            ////for(let combatant of _private.arrTempLoopedAllFightHeros) {
            ////for(let tc in _private.arrTempLoopedAllFightHeros) {
                ////let combatant = _private.arrTempLoopedAllFightHeros[tc];

                let combatant;
                if(GlobalLibraryJS.isArray(tValue)) {
                    combatant = tValue[0];
                }
                else if(GlobalLibraryJS.isValidNumber(tValue)) {

                    //暂停时间
                    GlobalLibraryJS.setTimeout(function() {
                        //开始运行
                        fight.continueFight();
                    },tValue,rootFightScene, 'fight.continueFight');

                    yield 1;
                    continue;
                }

                /*console.debug("!!!!!", JSON.stringify(combatant, function(k, v) {
                    if(k.indexOf("$$") === 0)
                        return undefined;
                    return v;
                }))*/


                do {


                    //执行 战斗人物回合 脚本
                    let combatantRoundScript = game.$sys.resources.commonScripts["combatant_round_script"](combatant, _private.nRound, 1);

                    if(combatantRoundScript === null) {
                        break;
                    }
                    else if(GlobalLibraryJS.isGenerator(combatantRoundScript)) {
                        for(let tCombatantActionSpriteData of combatantRoundScript) {
                            let SkillEffectResult = _private.actionSpritePlay(tCombatantActionSpriteData, combatant);

                            if(SkillEffectResult === 1)
                                yield 0;
                            else if(SkillEffectResult === 0) {

                            }
                            else {

                            }
                        }
                    }



                    if(FightSceneJS.combatantUseSkillOrGoods(combatant) < 0)
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
                                SkillEffectResult = _private.actionSpritePlay(tCombatantActionSpriteData, combatant);
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
                            SkillEffectResult = _private.actionSpritePlay(tCombatantActionSpriteData, combatant);
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
                    //_private.refreshFightRoleAction(combatant, "normal", AnimatedSprite.Infinite);


                    //if(harm !== 0) {   //对方生命为0
                    let fightResult = fight.over(null);
                    //战斗结束
                    if(fightResult.result !== 0) {
                        _private.fightOver(fightResult);
                        return fightResult;
                    }
                //}

                }while(0);



                //执行 战斗人物回合 脚本
                let combatantRoundScript = game.$sys.resources.commonScripts["combatant_round_script"](combatant, _private.nRound, 2);

                if(combatantRoundScript === null) {
                    continue;
                }
                else if(GlobalLibraryJS.isGenerator(combatantRoundScript)) {
                    for(let tCombatantActionSpriteData of combatantRoundScript) {
                        let SkillEffectResult = _private.actionSpritePlay(tCombatantActionSpriteData, combatant);

                        if(SkillEffectResult === 1)
                            yield 0;
                        else if(SkillEffectResult === 0) {

                        }
                        else {

                        }
                    }
                }

            }   //for

            return;
        }


        //回合生成器，主程序逻辑
        //yield：<0同fnRound；10、11：等待选择或等待下一个事件循环
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

                    let combatantRoundScript = game.$sys.resources.commonScripts["combatant_round_script"](tcombatant, _private.nRound, 0);

                    if(combatantRoundScript === null) {

                    }
                    else if(GlobalLibraryJS.isGenerator(combatantRoundScript)) {
                        for(let tCombatantActionSpriteData of combatantRoundScript) {
                            let SkillEffectResult = _private.actionSpritePlay(tCombatantActionSpriteData, tcombatant);

                            if(SkillEffectResult === 1)
                                yield 0;
                            else if(SkillEffectResult === 0) {

                            }
                            else {

                            }
                        }
                    }


                    //重新计算属性
                    game.$sys.resources.commonScripts["refresh_combatant"](tcombatant);
                }



                fightResult = fight.over(null);
                //战斗结束
                if(fightResult.result !== 0) {
                    _private.fightOver(fightResult);
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
                fight.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
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



                //_private.saveLast();



                /*for(let ti = 0; ti < repeaterEnemies.count; ++ti) {
                    //if(repeaterEnemies.itemAt(ti).opacity !== 0) {
                    if(_private.enemies[ti].$properties.HP[0] > 0) {
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
                fight.continueFight(1);   //这样的写法是，等待 事件队列 运行完毕再发送一个 genFighting.next 事件，否则：1、提前运行会出错!!!2、用async运行genFighting会导致生成器递归错误!!!
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
                            fight.continueFight();
                        },0,rootFightScene, 'fight.continueFight');

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
                for(let tcombatant of [..._private.myCombatants, ..._private.enemies]) {
                    //if(tcombatant.$properties.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        //let fightCombatantChoice = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$fightCombatantChoice'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$fightCombatantChoice'))
                        game.$sys.resources.commonScripts["fight_combatant_choice"](tcombatant, -1, false);
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


        //保存上次
        function saveLast(combatant=true) {
            if(combatant === true)
                for(let tc of _private.myCombatants) {
                //for(let i = 0; i < _private.myCombatants.length; ++i) {
                    if(tc.$properties.HP[0] > 0) {
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
                    if(tc.$properties.HP[0] > 0) {
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



        //播放 动作 或 特效
        //返回1 表示动画正在进行，需要等待（yield）
        function actionSpritePlay(combatantActionSpriteData, combatant) {

            combatant = combatantActionSpriteData.Combatant || combatant;
            //目标战士或队伍
            let targetCombatantOrTeamIndex = combatantActionSpriteData.Target;
            let combatantSpriteEffect = combatant.$$fightData.$info.$spriteEffect;


            //结果
            let SkillEffectResult;

            //类型
            switch(combatantActionSpriteData.Type) {
            case 1: //刷新人物信息
                //refreshAllFightRoleInfo();

                for(let tc of [..._private.myCombatants, ..._private.enemies]) {
                    game.$sys.resources.commonScripts["refresh_combatant"](tc);
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

            case 3:    //结算 技能效果
                SkillEffectResult = game.$sys.resources.commonScripts["fight_skill_algorithm"](combatant, targetCombatantOrTeamIndex, combatantActionSpriteData.Params);
                //SkillEffectResult = (doSkillEffect(role1.$$fightData.$teams, role1.$$fightData.$index, role2.$$fightData.$teams, role2.$$fightData.$index, tSkillEffect));

                return SkillEffectResult;
                //break;

            case 4:
                //检查所有战士（比如处理 死亡角色）
                fight.over(null);

                return 0;

            case 10: //Action

                _private.refreshFightRoleAction(combatant, combatantActionSpriteData.Name, combatantActionSpriteData.Loops);

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
                        combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                        combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
                        break;

                    case 1:
                        position = game.$sys.resources.commonScripts["fight_combatant_melee_position_algorithm"](combatant, targetCombatantOrTeamIndex);
                        /*let targetCombatantSpriteEffect = targetCombatantOrTeamIndex.$$fightData.$info.$spriteEffect;

                        //x偏移一下
                        let tx = combatantSpriteEffect.x < targetCombatantSpriteEffect.x ? -combatantSpriteEffect.width : combatantSpriteEffect.width;

                        position = combatantSpriteEffect.mapFromItem(targetCombatantSpriteEffect, tx, 0);
                        */
                        combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x + offset[0];
                        combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y + offset[1];

                        //combatantSpriteEffect.x = position.x + combatantSpriteEffect.x;
                        //combatantSpriteEffect.y = position.y + combatantSpriteEffect.y;

                        //console.debug("!!!", position, combatantSpriteEffect.x, position.x + combatantSpriteEffect.x, AnimatedSprite.Infinite);

                        break;

                    case 2:
                        position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamsID[targetCombatantOrTeamIndex], -1);
                        combatantSpriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                        combatantSpriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
                        break;

                    }

                    //combatantSpriteEffect.numberanimationSpriteEffectX.target = combatantSpriteEffect;
                    combatantSpriteEffect.numberanimationSpriteEffectX.duration = combatantActionSpriteData.Duration;
                    combatantSpriteEffect.numberanimationSpriteEffectX.start();
                    //combatantSpriteEffect.numberanimationSpriteEffectY.target = combatantSpriteEffect;
                    combatantSpriteEffect.numberanimationSpriteEffectY.duration = combatantActionSpriteData.Duration;
                    combatantSpriteEffect.numberanimationSpriteEffectY.start();
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
                    let spriteEffect = game.$sys.loadSpriteEffect(combatantActionSpriteData.Name, undefined, combatantActionSpriteData.Loops, itemRolesContainer);

                    if(spriteEffect === null)
                        break;

                    let combatantActionSpriteDataID;
                    if(combatantActionSpriteData.ID === undefined)
                        combatantActionSpriteDataID = combatantActionSpriteData.Name;
                    else
                        combatantActionSpriteDataID = combatantActionSpriteData.ID;

                    //检测ID是否重复
                    if(mapSpriteEffectsTemp[combatantActionSpriteDataID] !== undefined) {
                        mapSpriteEffectsTemp[combatantActionSpriteDataID].destroy();
                        delete mapSpriteEffectsTemp[combatantActionSpriteDataID];
                    }

                    //保存到列表中，退出时会删除所有，防止删除错误
                    mapSpriteEffectsTemp[combatantActionSpriteDataID] = spriteEffect;
                    spriteEffect.s_finished.connect(function(){
                        if(spriteEffect)
                            spriteEffect.destroy();
                        delete mapSpriteEffectsTemp[combatantActionSpriteDataID];
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
                            spriteEffect.numberanimationSpriteEffectX.to = position.x - combatantSpriteEffect.width / 2 + offset[0];
                            spriteEffect.numberanimationSpriteEffectY.to = position.y - combatantSpriteEffect.height / 2 + offset[1];
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

                let spriteEffect = compCacheWordMove.createObject(itemRolesContainer);
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

    }



    Keys.onEscapePressed: {
        //_private.fightOver(-1);
        event.accepted = true;

        console.debug("[FightScene]Escape Key");
    }
    Keys.onBackPressed: {
        //_private.fightOver(-1);
        event.accepted = true;

        console.debug("[FightScene]Back Key");
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


        for(let i = 0; i < 10; ++i)
            repeaterMyCombatants.model.append({modelData: i});
        for(let i = 0; i < 10; ++i)
            repeaterEnemies.model.append({modelData: i});



        FrameManager.globalObject().fight = fight;

        console.debug("[FightScene]Component.onCompleted", game, fight);
    }

    Component.onDestruction: {

        repeaterMyCombatants.model.clear();
        repeaterEnemies.model.clear();

        delete FrameManager.globalObject().fight;

        //console.debug("[main]Component.onDestruction");

    }

}
