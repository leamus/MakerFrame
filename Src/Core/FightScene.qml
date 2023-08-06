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

import LGlobal 1.0


import "qrc:/QML"


//import "GameMakerGlobal.js" as GameMakerGlobalJS

import "FightScene.js" as FightSceneJS
//import "File.js" as File


/*
    鹰：_private.myCombatants 和 _private.enemies 是 我方和敌方 的数据（$Combatant()返回的对象）
      repeaterMyCombatants 和 repeaterEnemies 是 我方和敌方 的精灵组件，和上面一一对应，用at()来获取
*/


Item {
    id: root



    signal s_showFightRoleInfo(int nIndex);



    property QtObject fight: QtObject {
        readonly property alias myCombatants: _private.myCombatants
        readonly property alias enemies: _private.enemies

        property alias nAutoAttack: _private.nAutoAttack
        readonly property var saveLast: _private.saveLast
        readonly property var loadLast: _private.loadLast



        //result：为null或undefined 发送fightOver信号（退出），为其他值（0平1胜-1败-2逃跑）执行事件（事件中调用结束信号）；
        //流程：手动或自动 游戏结束，调用依次_private.fightOver，执行脚本，然后通用战斗结束脚本中结尾调用 fight.over() 来清理战斗即可；
        readonly property var over: function(result) {
            if(result !== undefined && result !== null) {
                let fightResult = game.$sys.resources.commonScripts["check_all_combatants"](_private.myCombatants, repeaterMyCombatants, _private.enemies, repeaterEnemies);
                fightResult.result = result;
                _private.fightOver(fightResult);
            }
            else
                s_FightOver();
        }

        readonly property var msg: function(msg, interval=20, pretext='', keeptime=0, style={Type: 0b11}, pauseGame=true) {
            game.msg(msg, interval, pretext, keeptime, style, pauseGame);
            //dialogFightMsg.show(msg, pretext, interval);
        }

        readonly property var background: function(image='') {
            //console.debug('!!!!image:::', image, Global.toURL(GameMakerGlobal.imageResourceURL(image)))
            imageBackground.source = Global.toURL(GameMakerGlobal.imageResourceURL(image));
        }


        //同 game.run
        readonly property var run: function(strScript, priority=-1, ...params) {
            if(strScript === undefined) {
                console.warn('鹰：运行脚本未定义!!!');
                return false;
            }

            if(strScript === null) {
                return _private.asyncScript.run();
            }

            if(GlobalJS.createScript(_private.asyncScript, 0, priority, strScript, ...params) === 0)
                return _private.asyncScript.run();
        }

        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, priority, filePath) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, priority, filePath) === 0)
                return _private.asyncScript.run();
        }


        readonly property var continueFight: function() {
            _private.genHuiHe.run();
        }

        readonly property var getCombatantSkills: _private.getCombatantSkills

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
            showFightRoleInfo: function(){s_showFightRoleInfo();},
            checkToFight: _private.checkToFight,

            components: {
                menuSkillsOrGoods: menuSkillsOrGoods,
                menuFightRoleChoice: menuFightRoleChoice,

                spriteEffectMyCombatants: repeaterMyCombatants,
                spriteEffectEnemies: repeaterEnemies,
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

        //_private.asyncScript.clear();
        _private.genHuiHe.clear();
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        _private.enemies = [];
        _private.nRound = 0;
        _private.nStep = 0;
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
            _private.myCombatants[i].$$fightData.$lastTarget = undefined;
            _private.myCombatants[i].$$fightData.$target = undefined;
            delete _private.myCombatants[i].$$fightData.$info;
        }
    }

    signal s_ShowSystemWindow();



    function *init(fightScript) {
        console.debug("[FightScene]init", fightScript);

        fight.d = {};

        _private.genHuiHe.clear();
        ////numberanimationSpriteEffectX.stop();
        ////numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        _private.enemies = [];
        _private.nRound = 0;
        _private.nStep = 0;
        _private.nStage = 0;

        //rowlayoutButtons.enabled = true;
        msgbox.textArea.text = '';

        imageBackground.source = '';

        _private.resetFightScene();

        for(let i = 0; i < repeaterMyCombatants.model.count; ++i)
            repeaterMyCombatants.itemAt(i).visible = false;
        for(let i = 0; i < repeaterEnemies.model.count; ++i)
            repeaterEnemies.itemAt(i).visible = false;


        /*/载入战斗脚本
        let data;
        if(fightScript) {

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


        //data = GlobalJS.Eval(data.FightScript);
        //let data = game.$sys.resources.fightScripts[fightScriptName];
        //_private.fightInfo = data;
        //_private.fightRoundScript = fightScript.$commons.$fightRoundScript || '';
        //_private.fightStartScript = fightScript.$commons.$fightStartScript || '';
        //_private.fightEndScript = fightScript.$commons.$fightEndScript || '';

        /*try {
            data = GlobalJS.Eval(data.FightScript);
        }
        catch(e) {
            GlobalJS.PrintException(e);
            return false;
        }*/

        //data = data.$createData(fightScriptParams);
        //data.__proto__ = _private.fightInfo;
        _private.fightData = fightScript;


        _private.runAway = (fightScript.$runAway === undefined ? true : fightScript.$runAway);




        //我方
        _private.myCombatants = [...game.fighthero()];


        //敌方

        //敌人数量
        let enemyCount;
        let enemyRandom = false;    //随机排列

        //如果是数组
        if(GlobalLibraryJS.isArray(fightScript.$enemyCount)) {
            if(fightScript.$enemyCount.length === 1)
                enemyCount = fightScript.$enemyCount[0];
            else
                enemyCount = GlobalLibraryJS.random(fightScript.$enemyCount[0], fightScript.$enemyCount[1] + 1);

            enemyRandom = true;
        }
        else if(fightScript.$enemyCount === true) {
            enemyCount = fightScript.$enemiesData.length;
        }
        else {
            enemyCount = fightScript.$enemyCount;   //如果是数字
        }

        _private.enemies.length = enemyCount;

        for(let i = 0; i < _private.enemies.length; ++i) {
            let tIndex;
            if(enemyRandom) //随机
                tIndex = GlobalLibraryJS.random(0, fightScript.$enemiesData.length);
            else    //顺序
                tIndex = i % fightScript.$enemiesData.length;

            //创建敌人
            _private.enemies[i] = rootGameScene._public.getFightRoleObject(fightScript.$enemiesData[tIndex], true);

            //从 propertiesWithExtra 设置人物的 HP和MP
            game.run(function() {
                game.addprops(_private.enemies[i], {HP: 2, MP: 1}, 0);
            });
        }


        //初始化脚本
        if(game.$sys.resources.commonScripts["fight_init_script"]) {
            yield game.run([game.$sys.resources.commonScripts["fight_init_script"], 'fight_init_script'], -2, [_private.myCombatants, _private.enemies], fightScript)
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

            repeaterMyCombatants.itemAt(i).propertyBar.refresh(_private.myCombatants[i].$properties.HP);
            repeaterMyCombatants.itemAt(i).strName = _private.myCombatants[i].$name;



            //if(i >= repeaterMyCombatants.count)
            //    break;
            //console.debug("!!!", _private.myCombatants, i, _private.myCombatants[i], JSON.stringify(_private.myCombatants[i]));
            if(!_private.myCombatants[i].$$fightData)
                _private.myCombatants[i].$$fightData = {};

            //_private.myCombatants[i].$$fightData.$actionData = {};
            //_private.myCombatants[i].$$fightData.$buffs = {};
            ////_private.myCombatants.$rid = fightScript.$enemiesData[tIndex].$rid;

            _private.myCombatants[i].$$fightData.$info = {};
            _private.myCombatants[i].$$fightData.$info.$index = parseInt(i);
            _private.myCombatants[i].$$fightData.$info.$teamID = [0, 1];
            _private.myCombatants[i].$$fightData.$info.$team = [_private.myCombatants, _private.enemies];
            _private.myCombatants[i].$$fightData.$info.$teamSpriteEffect = [repeaterMyCombatants, repeaterEnemies];
            _private.myCombatants[i].$$fightData.$info.$spriteEffect = repeaterMyCombatants.itemAt(i);
            //_private.myCombatants[i].$$fightData.$choiceType = -1;
            //_private.myCombatants[i].$$fightData.$lastChoiceType = -1;
            //_private.myCombatants[i].$$fightData.$attackSkill = undefined;
            //_private.myCombatants[i].$$fightData.$lastAttackSkill = undefined;
            //这两句必须，否则会指向不存在的对象（比如第一场结束前选第4个敌人，第二场直接重复上次就出错了）；
            _private.myCombatants[i].$$fightData.$target = undefined;
            _private.myCombatants[i].$$fightData.$lastTarget = undefined;
            //_private.myCombatants[i].$$fightData.defenseSkill = undefined;
            //_private.myCombatants[i].$$fightData.lastDefenseSkill = undefined;


            /*/读取ActionData
            let fightroleInfo = game.$sys.resources.fightRoles[_private.myCombatants[i].$rid];
            if(fightroleInfo) {
                for(let tn in fightroleInfo.ActionData) {
                    _private.myCombatants[i].$$fightData.$actionData[fightroleInfo.ActionData[tn].ActionName] = fightroleInfo.ActionData[tn].SpriteName;
                }
            }
            else
                console.warn("[FightScene]载入战斗精灵失败：" + _private.myCombatants[i].$rid);
            */



            _private.refreshFightRoleAction(_private.myCombatants[i], "Normal", AnimatedSprite.Infinite);

            //刷新血条
            //if(_private.myCombatants[i].$properties.HP[0] <= 0)
            //    _private.myCombatants[i].$properties.HP[0] = 1;
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

            repeaterEnemies.itemAt(i).propertyBar.refresh(_private.enemies[i].$properties.HP);
            repeaterEnemies.itemAt(i).strName = _private.enemies[i].$name;



            /*/随机取敌人（不重复）
            let arrRandomEnemiesID = GlobalLibraryJS.GetDifferentNumber(0, fightScript.$enemiesData.length, enemyCount);
            for(let i in arrRandomEnemiesID) {
                let e = new game.$sys.resources.commonScripts["combatant_class"]();

                /*let enemiesData = fightScript.$enemiesData[arrRandomEnemiesID[i]];
                for(let tp in enemiesData) {  //给敌人赋值
                    e.$properties[tp] = enemiesData[tp];
                }* /

                GlobalLibraryJS.copyPropertiesToObject(e, fightScript.$enemiesData[arrRandomEnemiesID[i]]);

                game.$sys.resources.commonScripts["refresh_combatant"](e);
                _private.enemies.push(e);
            }*/
            /*/随机取敌人（可重复）
            for(let i = 0; i < enemyCount; ++i) {
                let e = new game.$sys.resources.commonScripts["combatant_class"]();
                _private.enemies.push(e);
            }*/



            //if(i >= repeaterEnemies.count)
            //    break;
            //console.debug("2", _private.enemies[i]);
            if(!_private.enemies[i].$$fightData)
                _private.enemies[i].$$fightData = {};

            //_private.enemies[i].$$fightData.$actionData = {};
            //_private.enemies[i].$$fightData.$buffs = {};

            _private.enemies[i].$$fightData.$info = {};
            _private.enemies[i].$$fightData.$info.$index = parseInt(i);
            _private.enemies[i].$$fightData.$info.$teamID = [1, 0];
            _private.enemies[i].$$fightData.$info.$team = [_private.enemies, _private.myCombatants];
            _private.enemies[i].$$fightData.$info.$teamSpriteEffect = [repeaterEnemies, repeaterMyCombatants];
            _private.enemies[i].$$fightData.$info.$spriteEffect = repeaterEnemies.itemAt(i);
            _private.enemies[i].$$fightData.$choiceType = -1;
            _private.enemies[i].$$fightData.$lastChoiceType = -1;
            _private.enemies[i].$$fightData.$attackSkill = undefined;
            _private.enemies[i].$$fightData.$lastAttackSkill = undefined;
            _private.enemies[i].$$fightData.$target = undefined;
            _private.enemies[i].$$fightData.$lastTarget = undefined;
            //_private.enemies.$rid = fightScript.$enemiesData[tIndex].$rid;

            /*/初始化 和 读取ActionData
            let fightroleInfo = game.$sys.resources.fightRoles[_private.enemies[i].$rid];
            if(fightroleInfo) {
                for(let tn in fightroleInfo.ActionData) {
                    _private.enemies[i].$$fightData.$actionData[fightroleInfo.ActionData[tn].ActionName] = fightroleInfo.ActionData[tn].SpriteName;
                }
            }
            else
                console.warn("[FightScene]载入战斗精灵失败：" + _private.enemies[i].$rid);
            */


            //读取战斗脚本的敌人属性，可以覆盖原战斗角色属性
            //if(fightScript.$enemiesData && fightScript.$enemiesData[tIndex])
            //    GlobalLibraryJS.copyPropertiesToObject(_private.enemies[i], fightScript.$enemiesData[tIndex]);


            _private.refreshFightRoleAction(_private.enemies[i], "Normal", AnimatedSprite.Infinite);

            //刷新血条
            //if(_private.enemies[i].$properties.HP[0] <= 0)
            //    _private.enemies[i].$properties.HP[0] = 1;
        }
        //隐藏剩下的
        for(; i < repeaterEnemies.model.count; ++i)
            repeaterEnemies.itemAt(i).visible = false;



        refreshAllFightRoleInfo();
        _private.resetRolesPosition();




        yield fight.run([game.$sys.resources.commonScripts["fight_start_script"]([_private.myCombatants, _private.enemies,], _private.fightData), 'fight start1'], -2);


        //GlobalLibraryJS.setTimeout(function() {
            //战斗起始脚本
            //if(_private.fightStartScript) {
            //    fight.run([_private.fightStartScript, 'fight start2'], -1, [_private.myCombatants, _private.enemies,], _private.fightData);
            //}


        //}, 1, root);



        _private.genHuiHe.create(_private.huiHe(), 'huihe', -1);

        //将 continueFight 放在脚本队列最后
        fight.run([function() {

            //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 asyncScript）
            //否则导致递归代码：在 asyncScript执行genHuiHe（执行continueFight），continueFight又会继续向下执行到asyncScript，导致递归运行!!!
            GlobalLibraryJS.setTimeout(function() {
                //开始运行
                let ret = _private.genHuiHe.run();
            },0,root);

        }, 'HuiHeStart']);

    }

    //刷新所有人物信息（目前只是血条）
    function refreshAllFightRoleInfo() {
        for(let i = 0; i < repeaterMyCombatants.nCount; ++i) {
            fight.refreshCombatant(_private.myCombatants[i]);
            //repeaterMyCombatants.itemAt(i).propertyBar.refresh(_private.myCombatants[i].$properties.HP);
        }
        for(let i = 0; i < repeaterEnemies.nCount; ++i) {
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

                _private.nStep = 1;

                mouse.accepted = true;
            }
        }
    }


    Item {
        id: itemRolesContainer
        width: root.width
        height: root.height

    //ColumnLayout {
    //    width: parent.width / 2
    //    height: parent.height / 2

        Repeater {
            id: repeaterMyCombatants

            property int nCount: 0


            //model: 0
            model: ListModel{}

            SpriteEffect {
                //id: tSpriteEffectMyCombatantBar

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: false

                property var propertyBar: loaderMyCombatantPropertyBar.item
                property alias strName: textMyCombatantsName.text


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
                        if(_private.nStep === 1) {
                            //保存选择对象
                            menuFightRoleChoice.nChoiceFightRole = modelData;

                            //菜单位置
                            /*跟随战士
                            menuFightRoleChoice.parent = parent;
                            menuFightRoleChoice.anchors.left = parent.right;
                            menuFightRoleChoice.anchors.top = parent.top;
                            */



                            //let style = game.$sys.resources.commonScripts["$fight_menu"].$style;
                            let style = {};
                            //样式
                            if(!style)
                                style = {};
                            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$style', '$fight_menu') || {};
                            let styleSystem = game.$gameMakerGlobalJS.$config.$style.$fight_menu;

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

                        //选择target人物
                        else if(_private.nStep === 2) {

                            if(menuFightRoleChoice.nChoiceFightRole < 0 || menuFightRoleChoice.nChoiceFightRole >= _private.myCombatants.length)
                                return;


                            let combatant = _private.myCombatants[menuFightRoleChoice.nChoiceFightRole];
                            let skill;
                            //如果选择的是技能
                            if(combatant.$$fightData.$choiceType === 0 || combatant.$$fightData.$choiceType === 1) {
                                skill = combatant.$$fightData.$attackSkill;
                            }
                            //如果选择的是道具
                            else if(combatant.$$fightData.$choiceType === 2) {
                                skill = combatant.$$fightData.$attackSkill.$fight[0];
                            }

                            let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](skill, combatant, _private.myCombatants[modelData], 1);
                            if(GlobalLibraryJS.isString(checkSkill)) {   //如果技能不可用
                                fight.msg(checkSkill || "不能选择", 50);
                                return;
                            }
                            if(GlobalLibraryJS.isArray(checkSkill)) {   //如果技能不可用
                                fight.msg(...checkSkill);
                                return;
                            }
                            if(checkSkill !== true) {   //如果技能不可用
                                //fight.msg("不能选择", 50);
                                return;
                            }


                            combatant.$$fightData.$target = [_private.myCombatants[modelData]];
                            combatant.$$fightData.$lastTarget = [_private.myCombatants[modelData]];


                            _private.nStep = 1;

                            //2、全部取消闪烁
                            for(let i = 0; i < repeaterMyCombatants.nCount; ++i) {
                                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                                if(_private.myCombatants[i].$properties.HP[0] > 0) {
                                    repeaterMyCombatants.itemAt(i).colorOverlayStop();
                                }
                            }

                            //3、判断是否可以开始战斗
                            _private.checkToFight();
                        }

                        //选择敌方
                        else if(_private.nStep === 3) {
                            return;
                        }

                        //攻击中，加速
                        else {
                            //if(_private.nStep === 31 || _private.nStep === 32) {
                                //let ret = _private.genHuiHe.run();
                            //}
                            return;
                        }

                        return;
                    }
                }

                onS_playEffect: {
                    rootGameScene._public.playSoundEffect(soundeffectSource);
                }
            }
        }
    //}

    //ColumnLayout {
    //    x: parent.width / 2
    //    width: parent.width / 2
    //    height: parent.height / 2

        Repeater {
            id: repeaterEnemies

            property int nCount: 0


            //model: 0
            model: ListModel{}

            SpriteEffect {
                //id: tSpriteEffectEnemy

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: false

                property var propertyBar: loaderEnemyPropertyBar.item
                property alias strName: textEnemyName.text


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
                        if(_private.nStep !== 3)
                            return;

                        if(menuFightRoleChoice.nChoiceFightRole < 0 || menuFightRoleChoice.nChoiceFightRole >= _private.myCombatants.length)
                            return;


                        let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](_private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$attackSkill, _private.myCombatants[menuFightRoleChoice.nChoiceFightRole], _private.enemies[modelData], 1);
                        if(GlobalLibraryJS.isString(checkSkill)) {   //如果技能不可用
                            fight.msg(checkSkill || "不能选择", 50);
                            return;
                        }
                        if(GlobalLibraryJS.isArray(checkSkill)) {   //如果技能不可用
                            fight.msg(...checkSkill);
                            return;
                        }
                        if(checkSkill !== true) {   //如果技能不可用
                            //fight.msg("不能选择", 50);
                            return;
                        }


                        _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$target = [_private.enemies[modelData]];
                        _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$lastTarget = [_private.enemies[modelData]];


                        _private.nStep = 1;

                        //2、全部取消闪烁
                        for(let i = 0; i < repeaterEnemies.nCount; ++i) {
                            //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                            if(_private.enemies[i].$properties.HP[0] > 0) {
                                repeaterEnemies.itemAt(i).colorOverlayStop();
                            }
                        }

                        //3、判断是否可以开始战斗
                        _private.checkToFight();
                    }
                }

                onS_playEffect: {
                    rootGameScene._public.playSoundEffect(soundeffectSource);
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

    //战斗人物选择
    GameMenu {
        id: menuFightRoleChoice

        //目前我方选择的人物
        property int nChoiceFightRole: -1

        visible: false
        width: 100
        height: implicitHeight
        anchors.centerIn: parent

        onS_Choice: {
            //hide();
            menuFightRoleChoice.visible = false;

            game.$sys.resources.commonScripts["fight_menu"].$actions[index](nChoiceFightRole);
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
                        let tWeapon = _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$equipment['武器'];
                        if(tWeapon)
                            tlistSkills = game.$sys.resources.goods[tWeapon.$rid].$skills;
                    }
                    //人物本身技能
                    else if(type === 0) {
                        tlistSkills = _private.myCombatants[menuFightRoleChoice.nChoiceFightRole]
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
                fight.$sys.showFightRoleInfo(_private.myCombatants[nChoiceFightRole].$index);

                break;

            //休息
            case 4:

                /*for(let i = 0; i < _private.myCombatants.length; ++i) {
                    if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        _private.myCombatants[i].$$fightData.$target = -2;
                        _private.myCombatants[i].$$fightData.$attackSkill = -2;
                    }
                }
                let ret = _private.genHuiHe.run();
                */

                let combatant = _private.myCombatants[nChoiceFightRole];
                combatant.$$fightData.$target = undefined;
                combatant.$$fightData.$attackSkill = undefined;
                combatant.$$fightData.$choiceType = 3;

                combatant.$$fightData.$lastTarget = undefined;
                combatant.$$fightData.$lastAttackSkill = undefined;
                combatant.$$fightData.$lastChoiceType = 3;



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

                    if(_private.nStage === 2)
                        return;


                    _private.loadLast();

                    if(_private.nStage === 1)
                        _private.genHuiHe.run();

                }

            }

            /*ColorButton {
                text: "随机普通攻击"
                onButtonClicked: {
                    for(let i = 0; i < _private.myCombatants.length; ++i) {
                        if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                            //_private.myCombatants[i].$$fightData.$lastTarget = _private.myCombatants[i].$$fightData.$target;
                            _private.myCombatants[i].$$fightData.$target = undefined;
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
                                _private.myCombatants[i].$$fightData.$target = undefined;
                                //_private.myCombatants[i].$$fightData.$attackSkill = -2;
                                _private.myCombatants[i].$$fightData.$choiceType = 3;
                            }
                        }
                        //!!这里使用事件的形式执行genHuihe，因为genHuiHe中也有 fight 脚本，貌似对之后的脚本造成了影响!!
                        GlobalLibraryJS.setTimeout(function() {
                            let ret = _private.genHuiHe.run();
                        },0,root);
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
                            _private.loadLast(1);
                            _private.genHuiHe.run();
                        }
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
                    console.time("huiHe");
                    let ret = _private.genHuiHe.run();
                    console.timeEnd("huiHe");
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
                    console.time("huiHe");
                    let ret = _private.genHuiHe.run();
                    console.timeEnd("huiHe");

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
                let ret = _private.genHuiHe.run();
            }
            Component.onCompleted: {
                show(["风攻击","土攻击","雷攻击","水攻击","火攻击"]);
            }
        }*/



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



    //技能 选择框
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


            GameMenu {
                id: menuSkillsOrGoods
                //保存类型；0为普通技能，1为技能，2为物品
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



    //游戏对话框
    Item {
        id: dialogFightMsg

        //property alias textFightMsg: textFightMsg.text
        //property int standardButtons: Dialog.Ok | Dialog.Cancel


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval) {
            visible = true;
            touchAreaFightMsg.enabled = false;
            messageFight.show(msg, pretext, interval);
            //FightManager.wait(-1);
        }


        anchors.fill: parent
        visible: false


        Mask {
            anchors.fill: parent
            color: "lightgray"
        }


        Message {
            id: messageFight

            width: parent.width * 0.7
            height: parent.height * 0.3
            anchors.centerIn: parent

            onS_over: {
                touchAreaFightMsg.enabled = true;
            }
        }


        MultiPointTouchArea {
            id: touchAreaFightMsg
            anchors.fill: parent
            //enabled: dialogFightMsg.standardButtons === Dialog.NoButton
            enabled: false
            onPressed: {
                //root.forceActiveFocus();
                dialogFightMsg.rejected();
            }
        }


        onAccepted: {
            //gameMap.focus = true;
            visible = false;

            _private.asyncScript.run();
        }
        onRejected: {
            //gameMap.focus = true;
            visible = false;

            _private.asyncScript.run();
        }
    }



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
            root.forceActiveFocus();
            //GlobalJS.Eval(textScript.text);
            console.debug(eval(textScript.text));
            //GlobalJS.runScript(_private.asyncScript, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            root.forceActiveFocus();
            //console.log("Cancel clicked");
        }
    }



    /*Audio {
        id: audioFightMusic
        loops: Audio.Infinite
    }*/


    Timer {
        id: timerRoleSprite
        running: false
        repeat: false
        onTriggered: {
            let ret = _private.genHuiHe.run();
        }
    }


    QtObject {
        id: _private

        //游戏配置/设置
        property var config: QtObject {
            property int barHeight: 6
        }



        //回合
        property int nRound: 0


        //自动攻击
        property int nAutoAttack: 0


        //战斗步骤：1为我方装备中；2为选择我方人物中；3为选择敌人中；1x为友军选人
        property int nStep: 0
        property int nStage: 0  //1：选择中；2：战斗中


        //我方按钮
        //property var arrMenu: ["普通攻击", "技能", "物品", '信息', "休息"]



        //我方和敌方数据
        //内容为：$Combatant() 返回的对象（包含各种数据）
        property var myCombatants: []
        property var enemies: []                //动态创建


        //脚本
        //property var fightInfo
        property var fightData
        //property var fightRoundScript
        //property var fightStartScript
        //property var fightEndScript

        //逃跑
        property var runAway


        //战斗脚本，也可以直接用Generator对象
        property var genHuiHe: new GlobalLibraryJS.Async(root)

        //异步脚本
        property var asyncScript//: new GlobalLibraryJS.Async(root)
        //property var asyncScript


        //所有特效临时存放（退出时清空）
        property var mapSpriteEffectsTemp: ({})




        //得到某个战斗角色的 所有 普通技能 和 技能；
        //0b1：战斗人物所有的普通攻击；0b10：战斗人物所有的技能；0b100：所有道具所有的普通攻击；0b1000：所有道具所有的技能；
        //返回数组：[技能名数组, 技能数组]。
        function getCombatantSkills(combatant, flags=0b1111) {
            let arrSkillsName = [], arrSkills = [];

            if(flags & 0b1) {
                //人物所有的普通攻击
                for(let skill of combatant.$skills) {
                    if(skill.$type === 0) {
                        arrSkillsName.push(skill.$name);
                        arrSkills.push(skill);
                    }
                }
            }

            if(flags & 0b10) {
                //人物所有的技能
                for(let skill of combatant.$skills) {
                    if(skill.$type === 1) {
                        arrSkillsName.push(skill.$name);
                        arrSkills.push(skill);
                    }
                }
            }

            if(flags & 0b100) {
                //所有道具所有的普通攻击
                for(let te in combatant.$equipment) {
                    let tWeapon = combatant.$equipment[te];

                    if(/*tWeapon && */tWeapon.$skills && tWeapon.$skills.length > 0)
                        for(let skill of tWeapon.$skills) {
                            /*let skill;
                            if(GlobalLibraryJS.isString(tskill)) {
                                skill = {$rid: tskill};
                                GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.resources.skills[tskill].$properties);
                            }
                            else {
                                skill = {$rid: tskill.RId};
                                GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.resources.skills[tskill.RId].$properties);
                                GlobalLibraryJS.copyPropertiesToObject(skill, tskill);
                            }*/

                            if(skill.$type === 0) {
                                arrSkillsName.push(skill.$name);
                                arrSkills.push(skill);
                            }
                        }
                }
            }

            if(flags & 0b1000) {
                //所有道具所有的技能
                for(let te in combatant.$equipment) {
                    let tWeapon = combatant.$equipment[te];

                    if(/*tWeapon && */tWeapon.$skills && tWeapon.$skills.length > 0)
                        for(let skill of tWeapon.$skills) {
                            /*let skill;
                            if(GlobalLibraryJS.isString(tskill)) {
                                skill = {$rid: tskill};
                                GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.resources.skills[tskill].$properties);
                            }
                            else {
                                skill = {$rid: tskill.RId};
                                GlobalLibraryJS.copyPropertiesToObject(skill, game.$sys.resources.skills[tskill.RId].$properties);
                                GlobalLibraryJS.copyPropertiesToObject(skill, tskill);
                            }*/

                            if(skill.$type === 1) {
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

                [arrSkillsName, arrSkills] = _private.getCombatantSkills(_private.myCombatants[menuFightRoleChoice.nChoiceFightRole], 0b1 | 0b100);

                //menuSkillsOrGoods.nType = 0;

                //rectSkills.visible = true;
                //menuSkillsOrGoods.show(arrSkillsName, arrSkills);

                //直接选择最后一个普通攻击
                choicedSkillOrGoods(arrSkills.pop(), 0);
            }
            //技能
            else if(type === 1) {
                let arrSkillsName = [];
                let arrSkills = [];

                [arrSkillsName, arrSkills] = _private.getCombatantSkills(_private.myCombatants[menuFightRoleChoice.nChoiceFightRole], 0b10 | 0b1000);

                menuSkillsOrGoods.strTitle = "选择技能";
                menuSkillsOrGoods.nType = 1;

                rectSkills.visible = true;
                menuSkillsOrGoods.show(arrSkillsName, arrSkills);
            }
            //道具
            else if(type === 2) {
                let arrGoodsName = [];
                let arrGoods = [];

                //显示所有战斗可用的道具
                for(let goods of game.gd["$sys_goods"]) {
                    //let goodsInfo = game.$sys.resources.goods[goods.$rid];
                    if(goods.$commons.$fightScript) {
                        arrGoods.push(goods);
                        arrGoodsName.push(GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts["show_goods_name"](goods)));
                    }
                }

                menuSkillsOrGoods.strTitle = "选择道具";
                menuSkillsOrGoods.nType = 2;

                rectSkills.visible = true;
                menuSkillsOrGoods.show(arrGoodsName, arrGoods);
            }
        }

        //选择技能
        function choicedSkillOrGoods(used, type) {

            //console.debug("~~~~~~~~~weapon", JSON.stringify(tWeapon))
            //console.debug("~~~~~~~~~weapon", JSON.stringify(game.$sys.resources.goods[tWeapon.RId]))



            //检测是否可以使用

            let checkSkill;
            //console.debug('!!!1', JSON.stringify(used))
            //检测技能
            if(type === 0 || type === 1) {
                checkSkill = game.$sys.resources.commonScripts["common_check_skill"](used, _private.myCombatants[menuFightRoleChoice.nChoiceFightRole], null, 0);
                if(GlobalLibraryJS.isString(checkSkill)) {   //如果技能不可用
                    fight.msg(checkSkill || "不能选择", 50);
                    return;
                }
                if(GlobalLibraryJS.isArray(checkSkill)) {   //如果技能不可用
                    fight.msg(...checkSkill);
                    return;
                }
                if(checkSkill !== true) {   //如果技能不可用
                    fight.msg("不能选择", 50);
                    return;
                }

                if(used.$commons.$choiceScript)
                    game.run(used.$commons.$choiceScript(used, _private.myCombatants[menuFightRoleChoice.nChoiceFightRole]));
            }
            //检测道具
            else if(type === 2) {
                //let goodsInfo = game.$sys.resources.goods[used.$rid];
                do {
                    //if(GlobalLibraryJS.isArray(used.$commons.$fightScript)) {
                    if(GlobalLibraryJS.isArray(used.$commons.$fightScript) || GlobalLibraryJS.isObject(used.$commons.$fightScript)) {
                        if(used.$commons.$fightScript[1] === true) {
                            checkSkill = true;
                            break;
                        }
                        else if(GlobalLibraryJS.isFunction(used.$commons.$fightScript[1])) {
                            checkSkill = used.$commons.$fightScript[1](used, _private.myCombatants[menuFightRoleChoice.nChoiceFightRole], 0);
                            break;
                        }
                        else if(used.$commons.$fightScript['$check'] === true) {
                            checkSkill = true;
                            break;
                        }
                        else if(GlobalLibraryJS.isFunction(used.$commons.$fightScript['$check'])) {
                            checkSkill = used.$commons.$fightScript['$check'](used, _private.myCombatants[menuFightRoleChoice.nChoiceFightRole], 0);
                            break;
                        }
                    }

                    checkSkill = false;
                }while(0);

                if(checkSkill !== true) {   //如果道具不可用
                    fight.msg(checkSkill || "道具不能使用", 50);
                    return;
                }

                if(used.$commons.$fightScript[0])
                    game.run(used.$commons.$fightScript[0]);
                else if(used.$commons.$fightScript['$choiceScript'])
                    game.run(used.$commons.$fightScript['$choiceScript']);
            }


            _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$choiceType = type;
            _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$attackSkill = used;

            _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$lastChoiceType = type;
            _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$lastAttackSkill = used;

            //console.debug("~~~~~~~~~~used: ", used);


            let skill;

            if(type === 0 || type === 1) {
                skill = _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$attackSkill;
            }
            else if(type === 2) {
                skill = _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$attackSkill.$fight[0];
                //有一种情况为空：道具没有对应技能（$fight[0]），只运行收尾代码（$fightScript[2]）；
                if(!skill)
                    skill = {$targetCount: 0, $targetFlag: 0};
            }


            //单人技能 且 目标敌方
            if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && skill.$targetFlag & 0b10) {
                for(let i = 0; i < repeaterEnemies.nCount; ++i) {
                    if(_private.enemies[i].$properties.HP[0] > 0) {
                    //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                        repeaterEnemies.itemAt(i).colorOverlayStart(["#00000000", "#7FFFFFFF", "#00000000"]);
                    }
                }
                _private.nStep = 3;
            }
            //目标我方
            if((skill.$targetCount > 0 || GlobalLibraryJS.isArray(skill.$targetCount)) && skill.$targetFlag & 0b1) {
                for(let i = 0; i < repeaterMyCombatants.nCount; ++i) {
                    if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        repeaterMyCombatants.itemAt(i).colorOverlayStart(["#00000000", "#7FFFFFFF", "#00000000"]);
                    }
                }
                _private.nStep = 2;
            }
            //不选
            //if(skill.$targetFlag === 0) {
            if(skill.$targetCount <= 0) {
                _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$target = -1;
                _private.myCombatants[menuFightRoleChoice.nChoiceFightRole].$$fightData.$lastTarget = -1;

                if(_private.nStage === 1)
                    checkToFight();
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
                    if(_private.myCombatants[i].$$fightData.$choiceType === -1)
                        return false;
                }
            }

            let ret = _private.genHuiHe.run();
            return true;
        }


        /*/读 role战斗角色 的 属性 和 所有Action 到 role
        function readFightRole(role) {
            //console.debug("[FightScene]readFightRole");

            let data = game.$sys.resources.fightRoles[role.$rid];
            if(data) {
                GlobalLibraryJS.copyPropertiesToObject(role, data.$createData());

                for(let tn in data.ActionData) {
                    role.$$fightData.$actionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
                }

                return true;
            }
            else
                console.warn("[FightScene]载入战斗精灵失败：" + role.$rid);


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
                console.warn("[FightScene]载入战斗精灵失败：" + filePath);

            return false;
            * /
        }*/



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

            if(!rootGameScene._public.loadSpriteEffect(actions[action], spriteEffect, loop)) {
                console.warn("[FightScene]载入战斗精灵动作失败：" + action);
                return false;
            }

            spriteEffect.restart();

            return true;
        }


        //读取技能文件
        function loadFightSkillInfo(fightSkillName) {
            //console.debug("[FightScene]loadFightSkillInfo0");
            return game.$sys.resources.skills[fightSkillName];

            /*if(fightSkillName) {

                /*let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + "fight_skill.json";
                //let data = File.read(filePath);
                //console.debug("[GameFightSkill]filePath：", filePath);

                let data = FrameManager.sl_qml_ReadFile(filePath);

                if(data !== "") {
                    data = JSON.parse(data);
                    //console.debug("data", data);
                    try {
                        data = GlobalJS.Eval(data.FightSkill);
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
                    return GlobalJS.Eval(data.FightSkill);
                }
            }
            return undefined;
            */
        }


        //重置所有Roles位置
        function resetRolesPosition() {
            for(let i = 0; i < repeaterMyCombatants.nCount; ++i) {
                let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](0, i);
                let tRoleSpriteEffect = repeaterMyCombatants.itemAt(i);
                tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
                tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
            }

            for(let i = 0; i < repeaterEnemies.nCount; ++i) {
                let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](1, i);
                let tRoleSpriteEffect = repeaterEnemies.itemAt(i);
                tRoleSpriteEffect.x = position.x - tRoleSpriteEffect.width / 2;
                tRoleSpriteEffect.y = position.y - tRoleSpriteEffect.height / 2;
            }

        }

        //获取 某战斗角色 中心位置
        /*/teamID、index是战斗角色的；cols表示有几列（战场分布）；
        function getCombatantPosition(teamID, index, cols=4) {
            //let teamID = combatant.$$fightData.$info.$teamID[0];
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


        //回合生成器，主程序逻辑
        //yield：0为播放特效；1为1回合结束
        //返回战斗结果
        function *huiHe() {
            console.debug("[FightScene]huiHe");

            let fightResult;

            while(1) {
                //console.debug("[FightScene]huiHe");

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



                fightResult = game.$sys.resources.commonScripts["check_all_combatants"](_private.myCombatants, repeaterMyCombatants, _private.enemies, repeaterEnemies);
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
                fight.run([game.$sys.resources.commonScripts["fight_round_script"](_private.nRound, 0, [_private.myCombatants, _private.enemies,], _private.fightData), 'fight round11']);



                _private.nStep = 1;
                _private.nStage = 1;


                //选择技能
                if(_private.nAutoAttack === 0)
                    yield 1;


                _private.nStage = 2;
                //rowlayoutButtons.enabled = false;
                //menuFightRoleChoice.hide();
                menuFightRoleChoice.visible = false;



                _private.saveLast();



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
                fight.run([game.$sys.resources.commonScripts["fight_round_script"](_private.nRound, 1, [_private.myCombatants, _private.enemies,], _private.fightData), 'fight round12']);



                //如果asyncScript内部有脚本没执行完毕，则等待 asyncScript 运行完毕（主要是 两个回合脚本），再回来运行
                if(!_private.asyncScript.isEmpty()) {

                    //将 continueFight 放在脚本队列最后
                    fight.run([function() {

                        //!!这里使用事件的形式执行continueFight（让执行的函数栈跳出 asyncScript）
                        //否则导致递归代码：在 asyncScript执行genHuiHe（执行continueFight），continueFight又会继续向下执行到asyncScript，导致递归运行!!!
                        GlobalLibraryJS.setTimeout(function() {
                            //开始运行
                            fight.continueFight();
                        },0,root);

                    }, 'continueFight']);

                    //开始执行脚本队列
                    //fight.run(null);

                    yield;
                }



                //计算 攻击 顺序
                let allCombatants = _private.myCombatants.concat(_private.enemies);
                allCombatants.sort(game.$sys.resources.commonScripts["sort_fight_algorithm"]);
                //console.debug("[FightScene]all", allCombatants.length, JSON.stringify(allCombatants));

                /*/敌人 选择防御
                for(let tc in _private.enemies) {
                    let tSkillIndexArray = GlobalLibraryJS.GetDifferentNumber(0, _private.enemies[tc].$skills.length);
                    //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击
                    _private.enemies[tc].$$fightData.$attackSkill = _private.enemies[tc].$skills[tSkillIndexArray[0]].RId;
                }*/



                //!!!开始循环每一角色的攻击
                for(let tc in allCombatants) {
                    let combatant = allCombatants[tc];

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



                        //选择的技能信息
                        let choiceSkill;
                        //技能Info
                        let fightSkillInfo;


                        if(combatant.$$fightData.$info.$teamID[0] === 0) {      //我方
                            //检查技能

                            //休息
                            if(combatant.$$fightData.$choiceType === 3)
                                break;
                            //普通攻击或技能
                            else if(combatant.$$fightData.$choiceType === 0 || combatant.$$fightData.$choiceType === 1) { //如果直接是对象

                                //判断技能是否可用
                                do {
                                    let bFind = false;
                                    let allSkills = getCombatantSkills(combatant);
                                    for(let ts of allSkills[1]) {
                                        if(ts.$rid === combatant.$$fightData.$attackSkill.$rid) {
                                            bFind = true;
                                            break;
                                        }
                                    }

                                    //如果没这个技能，则不能用
                                    //if(!game.skill(combatant, combatant.$$fightData.$attackSkill))
                                    if(!bFind)
                                        ;
                                    //如果技能可用
                                    else if(true === game.$sys.resources.commonScripts["common_check_skill"](combatant.$$fightData.$attackSkill, combatant, null, 10)) {
                                        break;
                                    }

                                    combatant.$$fightData.$choiceType = -2;
                                }while(0);

                            }
                            //道具
                            else if(combatant.$$fightData.$choiceType === 2) {

                                //判断道具是否可用
                                let goods = combatant.$$fightData.$attackSkill;
                                let goodsInfo = game.$sys.resources.goods[goods.$rid];
                                do {
                                    //如果没这个道具，则不能用
                                    if(!game.goods(goods))
                                        ;
                                    //如果有脚本
                                    else if(GlobalLibraryJS.isArray(goodsInfo.$commons.$fightScript) || GlobalLibraryJS.isObject(goodsInfo.$commons.$fightScript)) {
                                        //如果直接为true，则可用
                                        if(goodsInfo.$commons.$fightScript[1] === true)
                                            break;
                                        //如果有脚本且返回为true
                                        if(GlobalLibraryJS.isFunction(goodsInfo.$commons.$fightScript[1]) && goodsInfo.$commons.$fightScript[1](goods, combatant, 1) === true) {
                                            break;
                                        }
                                        //如果直接为true，则可用
                                        if(goodsInfo.$commons.$fightScript['$check'] === true)
                                            break;
                                        //如果有脚本且返回为true
                                        if(GlobalLibraryJS.isFunction(goodsInfo.$commons.$fightScript['$check']) && goodsInfo.$commons.$fightScript['$check'](goods, combatant, 1) === true) {
                                            break;
                                        }
                                    }

                                    combatant.$$fightData.$choiceType = -2;
                                }while(0);
                            }
                            //其他类型
                            else {
                                combatant.$$fightData.$choiceType = -2;
                                //combatant.$$fightData.$attackSkill = -1;
                                //console.warn('[!WARN]', combatant.$$fightData.$choiceType)
                            }


                            //如果 没选 或 随机选取 普通攻击
                            if(combatant.$$fightData.$choiceType === -2 /* || combatant.$$fightData.$choiceType === undefined || combatant.$$fightData.$choiceType === -1*/) {
                                //console.warn('[!FightScene]attackSkill WARN!', combatant.$$fightData.$attackSkill);
                                let skills = _private.getCombatantSkills(combatant, 0b101);
                                skills = skills[1];

                                let skill;

                                while(1) {
                                    skill = skills.pop();
                                    //没有可用技能
                                    if(skill === undefined) {
                                        combatant.$$fightData.$choiceType = 3;
                                        //combatant.$$fightData.$attackSkill = undefined;
                                        break;
                                    }

                                    let checkSkill = game.$sys.resources.commonScripts["common_check_skill"](skill, combatant, null, 10);
                                    if(checkSkill === true) {   //如果技能符合可用
                                        combatant.$$fightData.$choiceType = 0;
                                        combatant.$$fightData.$attackSkill = skill;
                                        break;
                                    }
                                }
                            }

                            //如果休息
                            if(combatant.$$fightData.$choiceType === 3)
                                break;



                            //如果选择的是技能
                            if(combatant.$$fightData.$choiceType === 0 || combatant.$$fightData.$choiceType === 1) {
                                choiceSkill = combatant.$$fightData.$attackSkill;
                            }
                            //如果选择的是道具
                            else if(combatant.$$fightData.$choiceType === 2) {
                                choiceSkill = combatant.$$fightData.$attackSkill.$fight[0];
                            }
                            //有一种情况为空：道具没有对应技能（$fight[0]），只运行收尾代码（$fightScript[2]）；
                            if(choiceSkill)
                                fightSkillInfo = loadFightSkillInfo(choiceSkill.$rid);
                            else {
                                choiceSkill = {$targetCount: 0, $targetFlag: 0};
                            }



                            //_private.nStep = 31;
                        }

                        else if(combatant.$$fightData.$info.$teamID[0] === 1) {    //敌人
                            //敌人 选择攻击
                            //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击：OK

                            if(combatant.$$fightData.$choiceType === 3)   //如果没有可选的技能，则下一个角色
                                break;

                            game.$sys.resources.commonScripts["enemy_choice_skill_algorithm"](combatant);

                            if(combatant.$$fightData.$choiceType === 3)   //如果没有可选的技能，则下一个角色
                                break;

                            choiceSkill = combatant.$$fightData.$attackSkill;
                            fightSkillInfo = loadFightSkillInfo(choiceSkill.$rid);


                            //_private.nStep = 32;
                        }



                        //修正 目标战斗角色

                        //if(choiceSkill.$targetFlag === 0)
                        if(choiceSkill.$targetCount <= 0)
                            combatant.$$fightData.$target = -1;

                        //单人，对方
                        if((choiceSkill.$targetCount > 0 || GlobalLibraryJS.isArray(choiceSkill.$targetCount)) && choiceSkill.$targetFlag & 0b10) {

                            //如果角色选择了目标，且目标还活着（否则随机选）
                            if(GlobalLibraryJS.isArray(combatant.$$fightData.$target)) {
                                if(combatant.$$fightData.$target[0].$properties.HP[0] <= 0) {
                                    combatant.$$fightData.$target = undefined;
                                }
                            }
                            else
                                combatant.$$fightData.$target = undefined;


                            //如果没有指定对方，则随机选
                            if(combatant.$$fightData.$target === undefined) {
                                //获得 对方还活着的 角色
                                let tarrAlive = [];
                                for(let tc of combatant.$$fightData.$info.$team[1]) {
                                    if(tc.$properties.HP[0] > 0)
                                        tarrAlive.push(tc);
                                }
                                //随机选择对方
                                //combatant.$$fightData.defenseProp = combatant.$$fightData.attackProp = GlobalLibraryJS.random(0, 5);

                                combatant.$$fightData.$target = [tarrAlive[GlobalLibraryJS.random(0, tarrAlive.length)]];
                                //console.debug("t1", t, JSON.stringify(team2));

                                //roleSpriteEffect2 = repeaterSpriteEffect2.itemAt(combatant.$$fightData.$target[0].$$fightData.$info.$index);
                            }

                            //console.debug("!!!", combatant.$$fightData.$target)
                        }

                        //单人，己方
                        if((choiceSkill.$targetCount > 0 || GlobalLibraryJS.isArray(choiceSkill.$targetCount)) > 0 && choiceSkill.$targetFlag & 0b1) {

                            //如果角色选择了目标（可以选择死亡角色）（否则随机选）
                            if(GlobalLibraryJS.isArray(combatant.$$fightData.$target)) {
                                if(combatant.$$fightData.$target[0].$properties.HP[0] <= 0) {
                                    //combatant.$$fightData.$target = undefined;
                                }
                            }
                            else
                                combatant.$$fightData.$target = undefined;

                            if(combatant.$$fightData.$target === undefined) {
                                //获得 己方还活着的 角色
                                let tarrAlive = [];
                                for(let tc of combatant.$$fightData.$info.$team[0]) {
                                    if(tc.$properties.HP[0] > 0)
                                        tarrAlive.push(tc);
                                }
                                //随机选择对方
                                //combatant.$$fightData.$info.defenseProp = combatant.$$fightData.$info.attackProp = GlobalLibraryJS.random(0, 5);

                                combatant.$$fightData.$target = [tarrAlive[GlobalLibraryJS.random(0, tarrAlive.length)]];
                                //console.debug("t1", t, JSON.stringify(team2));

                                //roleSpriteEffect2 = repeaterSpriteEffect1.itemAt(combatant.$$fightData.$target[0].$$fightData.$info.$index);
                            }

                            //console.debug("!!!", combatant.$$fightData.$target)
                        }



                        //console.debug("[FightScene]fightSkill:", JSON.stringify(fightSkillInfo));

                        //如果有技能信息，则执行技能动画
                        if(fightSkillInfo) {

                            let SkillEffectResult;      //技能效果结算结果（技能脚本 使用）

                            //执行技能脚本
                            //fightSkillInfo = fightSkillInfo.$commons.$playScript(combatant.$$fightData.$team, combatant.$$fightData.$index, role2.$$fightData.$team, role2.$$fightData.$index, SkillEffects);

                            //console.debug("!!!", SkillEffects);

                            //得到技能生成器函数
                            //let genActionAndSprite = fightSkillInfo.$commons.$playScript(combatant);
                            _private.asyncScript.create(fightSkillInfo.$commons.$playScript(choiceSkill, combatant), '$playScript', -1);


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


                        //道具收尾脚本
                        if(combatant.$$fightData.$choiceType === 2) {

                            let goods = combatant.$$fightData.$attackSkill;
                            let goodsInfo = game.$sys.resources.goods[goods.$rid];


                            let SkillEffectResult;      //技能效果结算结果（技能脚本 使用）
                            //得到技能生成器函数
                            //let genActionAndSprite = goodsInfo.$commons.$fightScript[2](goods, combatant);
                            if(goodsInfo.$commons.$fightScript[2])
                                _private.asyncScript.create(goodsInfo.$commons.$fightScript[2](goods, combatant), '$fightScript', -1);
                            else if(goodsInfo.$commons.$fightScript['$overScript'])
                                _private.asyncScript.create(goodsInfo.$commons.$fightScript['$overScript'](goods, combatant), '$fightScript', -1);

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
                        fightResult = game.$sys.resources.commonScripts["check_all_combatants"](_private.myCombatants, repeaterMyCombatants, _private.enemies, repeaterEnemies);
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


                //清空
                for(let tcombatant of [..._private.myCombatants, ..._private.enemies]) {
                    //if(tcombatant.$properties.HP[0] > 0) {
                    //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                        //tcombatant.$$fightData.$lastTarget = tcombatant.$$fightData.$target;
                        tcombatant.$$fightData.$target = undefined;
                        //tcombatant.$$fightData.lastAttackSkill = tcombatant.$$fightData.$attackSkill;
                        //tcombatant.$$fightData.$attackSkill = undefined;
                        tcombatant.$$fightData.$choiceType = -1;
                    //}
                }



                /*/运行两个回合脚本（阶段3）

                //通用回合开始脚本
                if(GlobalJS.createScript(_private.asyncScript, 0, 0, game.$sys.resources.commonScripts["fight_round_script"].call({game, fight}, _private.nRound, 1)) === 0)
                    _private.asyncScript.run();

                //回合开始脚本
                if(_private.fightRoundScript) {
                    //console.debug("运行回合事件!!!", _private.nRound)
                    if(GlobalJS.createScript(_private.asyncScript, 0, 0, _private.fightRoundScript, _private.nRound, 1) === 0)
                        _private.asyncScript.run();
                }*/



                //一回合结束
                ++_private.nRound;

                //rowlayoutButtons.enabled = true;

            }
        }


        //保存上次
        function saveLast() {
            for(let tc of _private.myCombatants) {
                if(tc.$properties.HP[0] > 0) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                    tc.$$fightData.$lastChoiceType = tc.$$fightData.$choiceType;
                    tc.$$fightData.$lastAttackSkill = tc.$$fightData.$attackSkill;
                    tc.$$fightData.$lastTarget = tc.$$fightData.$target;
                    //_private.myCombatants[i].$$fightData.$target = undefined;
                    //_private.myCombatants[i].$$fightData.$attackSkill = undefined;
                }
            }
        }

        //type：0表示完全载入上次；1表示载入没有选择的
        function loadLast(type=0) {
            for(let i = 0; i < _private.myCombatants.length; ++i) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    if(type === 1) {
                        if(_private.myCombatants[i].$$fightData.$choiceType !== -1)
                            continue;
                    }

                    _private.myCombatants[i].$$fightData.$choiceType = _private.myCombatants[i].$$fightData.$lastChoiceType;
                    _private.myCombatants[i].$$fightData.$attackSkill = _private.myCombatants[i].$$fightData.$lastAttackSkill;
                    _private.myCombatants[i].$$fightData.$target = _private.myCombatants[i].$$fightData.$lastTarget;
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
                //SkillEffectResult = (doSkillEffect(role1.$$fightData.$team, role1.$$fightData.$index, role2.$$fightData.$team, role2.$$fightData.$index, tSkillEffect));

                return SkillEffectResult;
                //break;

            case 4:
                //隐藏死亡角色
                game.$sys.resources.commonScripts["check_all_combatants"](_private.myCombatants, repeaterMyCombatants, _private.enemies, repeaterEnemies);

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
                        position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[0], combatant.$$fightData.$info.$index);
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
                        position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[targetCombatantOrTeamIndex], -1);
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
                    let spriteEffect = rootGameScene._public.loadSpriteEffect(combatantActionSpriteData.Name, undefined, combatantActionSpriteData.Loops, itemRolesContainer);

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
                            position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[0], combatant.$$fightData.$info.$index);
                            spriteEffect.x = position.x - spriteEffect.width / 2;
                            spriteEffect.y = position.y - spriteEffect.height / 2;
                            break;
                        case 1:
                            position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[0], combatant.$$fightData.$info.$index);
                            spriteEffect.x = position.x - spriteEffect.width / 2;
                            spriteEffect.y = position.y - spriteEffect.height / 2;

                            break;
                        case 2:
                            position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[targetCombatantOrTeamIndex], -1);
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
                            position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[0], combatant.$$fightData.$info.$index);
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
                            position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[targetCombatantOrTeamIndex], -1);
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
                    spriteEffect.text.text = GlobalJS.Eval(combatantActionSpriteData.Data, "", {SkillEffectResult: SkillEffectResult});
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
                        /*position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](role2.$$fightData.$teamID, role2.$$fightData.$index);
                        spriteEffect.x = position.x - spriteEffect.width / 2;
                        spriteEffect.y = position.y - spriteEffect.height / 2;
                        */

                        break;
                    case 4:
                        /*position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](role1.$$fightData.$teamID, role1.$$fightData.$index);
                        spriteEffect.x = position.x - spriteEffect.width / 2;
                        spriteEffect.y = position.y - spriteEffect.height / 2;
                        */
                        break;
                    }
                }
                else {
                    let position = game.$sys.resources.commonScripts["fight_combatant_position_algorithm"](combatant.$$fightData.$info.$teamID[0], combatant.$$fightData.$info.$index);
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
                console.warn("!huiHe ERROR")
            }   //switch

            return 0;
        }


        //还原场景样子
        function resetFightScene() {

            //menuFightRoleChoice.hide();
            menuFightRoleChoice.visible = false;

            rectSkills.visible = false;
            //menuSkillsOrGoods.hide();


            //全部取消闪烁
            for(let i = 0; i < repeaterMyCombatants.nCount; ++i) {
                //if(repeaterMyCombatants.itemAt(i).opacity !== 0) {
                //if(_private.myCombatants[i].$properties.HP[0] > 0) {
                    repeaterMyCombatants.itemAt(i).colorOverlayStop();
                //}
            }

            for(let i = 0; i < repeaterEnemies.nCount; ++i) {
                //if(repeaterEnemies.itemAt(i).opacity !== 0) {
                //if(_private.enemies[i].$properties.HP[0] > 0) {
                    repeaterEnemies.itemAt(i).colorOverlayStop();
                //}
            }

        }

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
