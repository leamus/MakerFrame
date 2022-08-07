import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import Qt.labs.settings 1.1


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


import "GameMakerGlobal.js" as GameMakerGlobalJS

//import "GameJS.js" as GameJS
//import "File.js" as File



Item {
    id: root


    property QtObject fight: QtObject {
        readonly property alias myCombatants: root.myCombatants
        readonly property alias enemies: root.enemies

        readonly property var over: function(r) {
            _private.fightOver(r);

        }
        readonly property var msg: function(msg, pretext, interval, type) {
            dialogFightMsg.show(msg, pretext, interval, type);
        }
        readonly property var run: function(strScript, ...params) {
            if(GlobalJS.createScript(_private.asyncScript, 0, strScript, ...params) === 0)
                return _private.asyncScript.run();
        }
        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, filePath) {
            if(!filePath)
                filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + fileName;
            else
                filePath = filePath + Platform.separator() + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, filePath) === 0)
                return _private.asyncScript.run();
        }
        readonly property var background: function(imageName) {
            imageBackground.source = GameMakerGlobal.imageResourceURL(imageName);
        }
    }

    //我方和敌方数据
    //内容为：createCombatants()返回的对象
    property var myCombatants: []
    property var enemies: []

    //特效组件
    property var compSpriteEffect
    property var compWordMove


    signal s_FightOver();
    onS_FightOver: {
        //audioFightMusic.stop();

        enemies = [];
        _private.asyncScript.clear();
        _private.genHuiHe.clear();
        numberanimationSpriteEffectX.stop();
        numberanimationSpriteEffectY.stop();
        timerRoleSprite.stop();

        repeaterEnemies.model = 0;
        repeaterMyCombatants.model = 0;

        for(let tSpriteEffectIndex in _private.mapSpriteEffects) {
            _private.mapSpriteEffects[tSpriteEffectIndex].destroy();
        }
        _private.mapSpriteEffects = {};
    }


    function init(fightScriptName) {
        console.debug("[FightScene]init", fightScriptName);

        msgbox.textArea.text = "";
        enemies = [];
        _private.nRound = 0;
        rowlayoutButtons.enabled = true;


        /*/载入战斗脚本
        let data;
        if(fightScriptName) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightScriptDirName + Platform.separator() + fightScriptName + Platform.separator() + "fight_script.json";
            //let data = File.read(filePath);
            //console.debug("[GameFightScript]filePath：", filePath);

            data = GameManager.sl_qml_ReadFile(filePath);
            data = JSON.parse(data);

            if(data === "") {
                return;
            }
        }
        else
            return;
        */

        let data = game.loadjson(GameMakerGlobal.config.strFightScriptDirName + Platform.separator() + fightScriptName + Platform.separator() + "fight_script.json");
        if(!data)
            return;


        data = GlobalJS.Eval(data.FightScript);
        /*try {
            data = GlobalJS.Eval(data.FightScript);
        }
        catch(e) {
            GlobalJS.PrintException(e);
            return false;
        }*/


        _private.fightRoundScript = data.fightRoundEvent;
        _private.fightStartScript = data.fightStartEvent;
        _private.fightEndScript = data.fightEndEvent;



        //创建敌人


        //敌人数量
        let enemyCount;
        let enemyRandom = false;    //随机排列

        //如果是数组
        if(GlobalLibraryJS.isArray(data.enemyCount)) {
            if(data.enemyCount.length === 1)
                enemyCount = data.enemyCount[0];
            else
                enemyCount = GlobalLibraryJS.random(data.enemyCount[0], data.enemyCount[1] + 1);
        }
        else {
            if(enemyCount === true) {
                enemyCount = data.enemyFightRoles.length;
                enemyRandom = true;
            }
            else
                enemyCount = data.enemyCount;   //如果是数字
        }




        //创建战斗角色精灵

        //我方
        //组件会全部重新创建
        repeaterMyCombatants.model = myCombatants.length;
        for(let i in myCombatants) {
            //if(i >= repeaterMyCombatants.count)
            //    break;
            //console.debug("!!!", myCombatants, i, myCombatants[i], JSON.stringify(myCombatants[i]));
            myCombatants[i].$$FightData = {};
            myCombatants[i].$$FightData.bufferProps = {};
            myCombatants[i].$$FightData.ActionData = {};
            myCombatants[i].$$FightData.index = parseInt(i);
            ////myCombatants.FightRoleName = data.enemyFightRoles[i];
            myCombatants[i].$$FightData.team = myCombatants;
            myCombatants[i].$$FightData.teamID = 0;

            _private.readFightRole(myCombatants[i]);
            _private.refreshRoleAction(myCombatants[i], "normal", repeaterMyCombatants.itemAt(i), AnimatedSprite.Infinite);

            //刷新血条
            if(myCombatants[i].properties.remainHP <= 0)
                myCombatants[i].properties.remainHP = 1;
            repeaterMyCombatants.itemAt(i).blood.refreshBlood(myCombatants[i].properties);
        }


        //地方
        //组件会全部重新创建
        repeaterEnemies.model = enemies.length = enemyCount;
        for(let i = 0; i < enemyCount; ++i) {


            /*/随机取敌人（不重复）
            let arrRandomEnemiesID = GlobalLibraryJS.GetDifferentNumber(0, data.enemyData.length, enemyCount);
            for(let i in arrRandomEnemiesID) {
                let e = GameMakerGlobalJS.createCombatants();

                /*let enemyData = data.enemyData[arrRandomEnemiesID[i]];
                for(let tp in enemyData) {  //给敌人赋值
                    e.properties[tp] = enemyData[tp];
                }* /

                GlobalLibraryJS.copyPropertiesToObject(e, data.enemyData[arrRandomEnemiesID[i]]);

                GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(e);
                enemies.push(e);
            }*/
            /*/随机取敌人（可重复）
            for(let i = 0; i < enemyCount; ++i) {
                let e = GameMakerGlobalJS.createCombatants();
                enemies.push(e);
            }*/

            //创建
            let tIndex;
            if(enemyRandom)
                tIndex = GlobalLibraryJS.random(0, enemyCount);
            else
                tIndex = i;

            enemies[i] = GameMakerGlobalJS.createCombatants(data.enemyFightRoles[tIndex]);



            //if(i >= repeaterEnemies.count)
            //    break;
            //console.debug("2", enemies[i]);
            enemies[i].$$FightData = {};
            enemies[i].$$FightData.bufferProps = {};
            enemies[i].$$FightData.ActionData = {};
            enemies[i].$$FightData.index = parseInt(i);
            //enemies.FightRoleName = data.enemyFightRoles[i];
            enemies[i].$$FightData.team = enemies;
            enemies[i].$$FightData.teamID = 1;

            _private.readFightRole(enemies[i]);
            _private.refreshRoleAction(enemies[i], "normal", repeaterEnemies.itemAt(i), AnimatedSprite.Infinite);

            //读取战斗脚本的敌人属性，可以覆盖原战斗角色属性
            if(data.enemyData && data.enemyData[tIndex])
                GlobalLibraryJS.copyPropertiesToObject(enemies[i], data.enemyData[tIndex]);

            GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(enemies[i]);

            //刷新血条
            if(enemies[i].properties.remainHP <= 0)
                enemies[i].properties.remainHP = 1;
            repeaterEnemies.itemAt(i).blood.refreshBlood(enemies[i].properties);
        }

        _private.resetRolesPosition();



        _private.genHuiHe.create(_private.huiHe());



        if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_fight_start_stript"].call({game, fight})) === 0)
            _private.asyncScript.run();

        //GlobalLibraryJS.setTimeout(function() {
            //战斗起始脚本
            if(_private.fightStartScript) {
                if(GlobalJS.createScript(_private.asyncScript, 0, _private.fightStartScript) === 0)
                    _private.asyncScript.run();
            }


        //}, 1, root);

        let ret = _private.genHuiHe.run();
    }



    focus: true
    anchors.fill: parent



    Component {
        id: compBlood

        Rectangle {
            id: blood
            color: "#800080"
            antialiasing: false
            radius: height / 3
            clip: true

            property Rectangle blood1: Rectangle {
                parent: blood
                height: parent.height
                color: "red"
                antialiasing: false
                radius: height / 3
            }
            property Rectangle blood2: Rectangle {
                parent: blood
                height: parent.height
                color: "yellow"
                antialiasing: false
                radius: height / 3
            }

            function refreshBlood(data) {
                blood1.width = data.healthHP / data.HP * width;
                blood2.width = data.remainHP / data.HP * width;
            }
        }
    }


    Rectangle {
        anchors.fill: parent

        Image {
            id: imageBackground
            anchors.fill: parent
            source: "FightScene1.jpg"
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
            model: 0

            SpriteEffect {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: true

                property var blood: loaderMyCombatantBlood.item


                Loader {
                    id: loaderMyCombatantBlood
                    sourceComponent: compBlood
                    y: -10
                    width: parent.width
                    height: _private.config.bloodHeight
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
            model: 0

            SpriteEffect {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                test: true

                property var blood: loaderEnemyBlood.item


                Loader {
                    id: loaderEnemyBlood
                    sourceComponent: compBlood
                    y: -10
                    width: parent.width
                    height: _private.config.bloodHeight
                }
            }
        }
    //}


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
        }

    }


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
                text: "普通攻击"
                onButtonClicked: {
                    myCombatants[0].$$FightData.attackSkill = myCombatants[0].skills[0].id;

                    let fightSkillData = _private.loadFightSkill(myCombatants[0].$$FightData.attackSkill);
                    if(fightSkillData.checkSkillData().success) {   //如果技能符合可用
                        rowlayoutButtons.enabled = false;
                        let ret = _private.genHuiHe.run();
                    }

                }
            }

            ColorButton {
                text: "休息"
                onButtonClicked: {
                    myCombatants[0].$$FightData.attackSkill = undefined;
                    rowlayoutButtons.enabled = false;
                    let ret = _private.genHuiHe.run();
                }
            }

            ColorButton {
                text: "逃跑"
                onButtonClicked: {
                    _private.fightOver(-2);
                }
            }
        }

        /*GameMenu {
            id: menuGame

            Layout.preferredWidth: Screen.pixelDensity * 20
            Layout.alignment: Qt.AlignHCenter
            //width: parent.width

            //height: parent.height / 2
            //anchors.centerIn: parent

            onS_Choice: {
                myCombatants[0].$$FightData.defenseProp = myCombatants[0].$$FightData.attackProp = index;

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


    //游戏对话框
    Item {
        id: dialogFightMsg

        //property alias textFightMsg: textFightMsg.text
        //property int standardButtons: Dialog.Ok | Dialog.Cancel


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval, type) {
            visible = true;
            touchAreaFightMsg.enabled = false;
            messageFight.show(msg, pretext, interval, type);
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


    ColorButton {
        text: "调试"
        onButtonClicked: {
            dialogScript.visible = true;
        }
    }

    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: "执行脚本"
        width: 300
        height: 200
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
            GlobalJS.Eval(textScript.text);
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
            property int bloodHeight: 6
        }



        //回合
        property int nRound: 0

        //所有特效（退出时清空）
        property var mapSpriteEffects: ({})

        //脚本
        property var fightRoundScript
        property var fightStartScript
        property var fightEndScript


        //同步脚本（战斗），也可以直接用Generator对象
        property var genHuiHe: new GlobalJS.Async(root)


        //异步脚本
        property var asyncScript: new GlobalJS.Async(root)



        //读 role战斗角色 的 所有Action 到 role
        function readFightRole(role) {
            //console.debug("[FightScene]readFightRole");

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightRoleDirName + Platform.separator() + role.FightRoleName + Platform.separator() + "fight_role.json";

            //console.debug("[FightScene]filePath：", filePath);

            //let data = File.read(filePath);
            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);

                GlobalLibraryJS.copyPropertiesToObject(role, data.Property);

                for(let tn in data.ActionData) {
                    role.$$FightData.ActionData[data.ActionData[tn].ActionName] = data.ActionData[tn].SpriteName;
                }

                return true;
            }
            else
                console.warn("[FightScene]载入战斗精灵失败：" + filePath);

            return false;
        }

        //载入特效，返回特效对象
        function loadSpriteEffect(spriteEffectName, spriteEffect, loop=1) {
            //console.debug("[FightScene]loadSpriteEffect0");

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strSpriteDirName + Platform.separator() + spriteEffectName + Platform.separator() + "sprite.json";

            //console.debug("[FightScene]filePath2：", filePath);

            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                if(!spriteEffect)
                    spriteEffect = compSpriteEffect.createObject(itemRolesContainer);

                spriteEffect.spriteSrc = Global.toQMLPath(GameMakerGlobal.spriteResourceURL(data.Image));
                spriteEffect.sizeFrame = Qt.size(parseInt(data.FrameSize[0]), parseInt(data.FrameSize[1]));
                spriteEffect.nFrameCount = parseInt(data.FrameCount);
                spriteEffect.offsetIndex = Qt.point(parseInt(data.OffsetIndex[0]), parseInt(data.OffsetIndex[1]));

                spriteEffect.interval = parseInt(data.FrameInterval);
                //spriteEffect.width = parseInt(textSpriteWidth.text);
                //spriteEffect.height = parseInt(textSpriteHeight.text);
                spriteEffect.implicitWidth = parseInt(data.SpriteSize[0]);
                spriteEffect.implicitHeight = parseInt(data.SpriteSize[1]);
                spriteEffect.opacity = parseFloat(data.Opacity);
                spriteEffect.rXScale = parseFloat(data.XScale);
                spriteEffect.rYScale = parseFloat(data.YScale);

                if(data.Sound) {
                    spriteEffect.soundeffectSrc = Global.toQMLPath(GameMakerGlobal.soundResourceURL(data.Sound));
                }
                else {
                    spriteEffect.soundeffectSrc = "";
                }
                //console.debug("!!!", data.Sound, spriteEffect.soundeffectSrc)
                spriteEffect.soundeffectDelay = parseInt(data.SoundDelay);

                spriteEffect.animatedsprite.loops = loop;
                spriteEffect.restart();

                return spriteEffect;
            }

            console.warn("[FightScene]载入特效失败：" + filePath);
            return false;
        }

        //刷新 role 的 action 到 sprite 并播放 loop 次
        function refreshRoleAction(role, action, sprite, loop=1) {

            if(!role.$$FightData.ActionData)
                return false;

            if(!role.$$FightData.ActionData[action]) {
                if(!role.$$FightData.ActionData["normal"])
                    return false;
                else
                    action = "normal";
            }

            if(!loadSpriteEffect(role.$$FightData.ActionData[action], sprite, loop)) {
                console.warn("[FightScene]载入战斗精灵动作失败：" + action);
                return false;
            }
            return true;
        }


        //读取技能文件
        function loadFightSkill(fightSkillName) {
            //console.debug("[FightScene]loadFightSkill0");

            if(fightSkillName) {

                /*let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName + Platform.separator() + fightSkillName + Platform.separator() + "fight_skill.json";
                //let data = File.read(filePath);
                //console.debug("[GameFightSkill]filePath：", filePath);

                let data = GameManager.sl_qml_ReadFile(filePath);

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
                */
                let data = game.loadjson(GameMakerGlobal.config.strFightSkillDirName + Platform.separator() + fightSkillName + Platform.separator() + "fight_skill.json");
                if(data) {
                    return GlobalJS.Eval(data.FightSkill);
                }
            }
            return undefined;
        }


        //重置所有Roles位置
        function resetRolesPosition() {
            for(let i = 0; i < repeaterMyCombatants.count; ++i) {
                let tRoleSpriteEffect = repeaterMyCombatants.itemAt(i);
                tRoleSpriteEffect.x = itemRolesContainer.width / 4 - tRoleSpriteEffect.width / 2;
                tRoleSpriteEffect.y = itemRolesContainer.height * (i + 1) / (repeaterMyCombatants.count + 1) - tRoleSpriteEffect.height / 2;
            }

            for(let i = 0; i < repeaterEnemies.count; ++i) {
                let tRoleSpriteEffect = repeaterEnemies.itemAt(i);
                tRoleSpriteEffect.x = itemRolesContainer.width * 3 / 4 - tRoleSpriteEffect.width / 2;
                tRoleSpriteEffect.y = itemRolesContainer.height * (i + 1) / (repeaterEnemies.count + 1) - tRoleSpriteEffect.height / 2;
            }

        }

        //获取角色中心位置
        function getRolesPosition(teamID, index) {
            if(teamID === 0) {    //我方
                return Qt.point(itemRolesContainer.width / 4, itemRolesContainer.height * (index + 1) / (repeaterMyCombatants.count + 1));
            }
            else {  //敌方
                return Qt.point(itemRolesContainer.width * 3 / 4, itemRolesContainer.height * (index + 1) / (repeaterEnemies.count + 1));
            }
        }



        /*/没什么用了
        function doSkillEffect(team1, roleIndex1, team2, roleIndex2, skillEffect) {
            //!!!!!!修改：加入team效果
            let role1 = team1[roleIndex1];
            let role2 = team2[roleIndex2];

            let skillEffectResult = game.gf["$sys_fight_skill_algorithm"](team1, roleIndex1, team2, roleIndex2, skillEffect);
            //for(let t in skillEffectResult) {
            //}
            return skillEffectResult;
        }

        //显示伤害文字，并设置伤害
        function doSkillEffect1(team1, roleIndex1, team2, roleIndex2, skillEffect) {
            //console.debug("[FightScene]doSkillEffect");
            //console.debug(team1, roleIndex1, team2, roleIndex2, skillEffect);
            //console.debug(JSON.stringify(myCombatants), JSON.stringify(enemies))

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
                name1 = GameManager.getPlayerInfo(role1["GroupIndex"]).nickname;
            }* /
            name1 = role1.name || "无名";

            /*if(role2["GameUserID"] === UserInfo.gameUserID) {
                name2 = "你";
            }
            else if(role2["GameUserID"] === 0) {
                name2 = "敌人";
            }
            else {
                name2 = GameManager.getPlayerInfo(role2["GroupIndex"]).nickname;
            }* /
            name2 = role2.name || "无名";

            //console.debug(Global.gameData.arrayPets)
            //console.debug(Global.gameData.arrayPets[0])
            //console.debug(Global.gameData.arrayPets[0].$$FightData.attackProp)
            //console.debug("debug1:", data2.choice)

            //Global.gameData.arrayEnemyPets[0].$$FightData.defenseProp = Global.gameData.arrayEnemyPets[0].$$FightData.attackProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)
            //Global.gameData.arrayEnemyPets[0].$$FightData.defenseProp = Math.floor(GameCore.socketInfo.getRandomNumber(!GameCore.netPlay) * 5)

            msgbox.textArea.append(name1 + "使用【" + GameMakerGlobalJS.propertyName(role1.$$FightData.attackProp) + "】攻击");
            msgbox.textArea.append(name1 + "使用【" + GameMakerGlobalJS.propertyName(role1.$$FightData.defenseProp) + "】防御");
            //msgbox.textArea.append(name2 + "使用" + role2.$$FightData.attackProp + "攻击");
            //msgbox.textArea.append(name2 + "使用" + role2.$$FightData.defenseProp + "防御");


            harm = game.gf["$sys_fight_skill_algorithm"](team1, roleIndex1, team2, roleIndex2, skillEffect);


            str = "属性使用";
            if(harm.propertySuccess === 1)str += "成功";
            else if(harm.propertySuccess === -1)str += "失败";
            else str += "无效果";
            str += ",%1把%2揍了".arg(name1).arg(name2) + harm.harm + "血";
            msgbox.textArea.append(str);

            role2.properties.remainHP -= harm.harm;
            if(role2.properties.remainHP <= 0) {
                role2.properties.remainHP = 0;
                //role1.properties.remainHP = role1.properties.maxHP;
                //role2.properties.remainHP = role2.properties.maxHP;
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

            let bFightOver = false;
            let ret;

            while(1) {

                //console.debug("[FightScene]huiHe");

                //回合开始脚本
                if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_fight_round_stript"].call({game, fight}, _private.nRound)) === 0)
                    _private.asyncScript.run();

                if(_private.fightRoundScript) {
                    //console.debug("运行回合事件!!!", _private.nRound)
                    if(GlobalJS.createScript(_private.asyncScript, 0, _private.fightRoundScript, _private.nRound) === 0)
                        _private.asyncScript.run();
                }


                //选择技能
                yield 1;


                //计算 速度，按速度排列
                let allCombatants = myCombatants.concat(enemies);
                allCombatants.sort(function(a, b) {
                    if(a.$$propertiesWithEquipment.speed > b.$$propertiesWithEquipment.speed)return -1;
                    if(a.$$propertiesWithEquipment.speed < b.$$propertiesWithEquipment.speed)return 1;
                    if(a.$$propertiesWithEquipment.speed === b.$$propertiesWithEquipment.speed)return 0;
                });
                //console.debug("[FightScene]all", allCombatants.length, JSON.stringify(allCombatants));

                /*/敌人 选择防御
                for(let tc in enemies) {
                    let tSkillIndexArray = GlobalLibraryJS.GetDifferentNumber(0, enemies[tc].skills.length);
                    //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击
                    enemies[tc].$$FightData.attackSkill = enemies[tc].skills[tSkillIndexArray[0]].id;
                }*/

                //!!!开始循环每一角色的攻击
                for(let tc in allCombatants) {
                    let role1 = allCombatants[tc];

                    /*console.debug("!!!!!", JSON.stringify(role1, function(k, v) {
                        if(k.indexOf("$$") === 0)
                            return undefined;
                        return v;
                    }))*/

                    //跳过没血的
                    if(role1.properties.remainHP <= 0) {
                        //console.debug("没血");
                        continue;
                    }


                    let tTeam1;
                    let tTeam2;
                    let repeaterSpriteEffect1;
                    let repeaterSpriteEffect2;
                    let tRoleSpriteEffect1;

                    if(role1.$$FightData.teamID === 0) {      //我方
                        tTeam1 = myCombatants;
                        tTeam2 = enemies;
                        repeaterSpriteEffect1 = repeaterMyCombatants;
                        repeaterSpriteEffect2 = repeaterEnemies;
                        tRoleSpriteEffect1 = repeaterMyCombatants.itemAt(role1.$$FightData.index);
                    }
                    else if(role1.$$FightData.teamID === 1) {    //敌人
                        tTeam1 = enemies;
                        tTeam2 = myCombatants;
                        repeaterSpriteEffect1 = repeaterEnemies;
                        repeaterSpriteEffect2 = repeaterMyCombatants;
                        tRoleSpriteEffect1 = repeaterEnemies.itemAt(role1.$$FightData.index);
                    }



                    //!!!!!!修改：我方选择敌人
                    //获得 对方还活着的 角色
                    let tarrAlive = [];
                    for(let ti in tTeam2) {
                        if(tTeam2[ti].properties.remainHP > 0)
                            tarrAlive.push(tTeam2[ti]);
                    }
                    //随机选择对方
                    //role1.$$FightData.defenseProp = role1.$$FightData.attackProp = GlobalLibraryJS.random(0, 5);
                    let role2 = tarrAlive[GlobalLibraryJS.random(0, tarrAlive.length)];
                    //console.debug("t1", t, JSON.stringify(tTeam2));

                    let tRoleSpriteEffect2 = repeaterSpriteEffect2.itemAt(role2.$$FightData.index);



                    let fightSkillData;

                    //敌人 选择攻击
                    //!!!!!这里需要加入：1、普通攻击概率；2、魔法值不足；3、最后还是普通攻击
                    if(role1.$$FightData.teamID === 1) {
                        role1.$$FightData.attackSkill = undefined;
                        //随机选择技能
                        let tSkillIndexArray = GlobalLibraryJS.GetDifferentNumber(0, role1.skills.length);
                        for(let tSkillIndex in tSkillIndexArray) {
                            role1.$$FightData.attackSkill = role1.skills[tSkillIndexArray[tSkillIndex]].id;
                            fightSkillData = loadFightSkill(role1.$$FightData.attackSkill);
                            if(fightSkillData.checkSkillData().success) {   //如果技能符合可用
                                fightSkillData = fightSkillData.doSkillEffects; //得到技能效果方法
                                break;
                            }
                        }
                    }
                    else if(role1.$$FightData.teamID === 0) {
                        fightSkillData = loadFightSkill(role1.$$FightData.attackSkill);
                        fightSkillData = fightSkillData.doSkillEffects; //得到技能效果方法
                    }


                    if(!role1.$$FightData.attackSkill)   //如果没有可选的技能，则下一个角色
                        continue;

                    //console.debug("[FightScene]fightSkill:", JSON.stringify(fightSkillData));


                    //let SkillEffects = [];  //技能效果列表（由技能脚本填充）
                    let SkillEffectResult;  //技能效果结果（技能脚本使用）
                    //执行技能脚本
                    //fightSkillData = fightSkillData(role1.$$FightData.team, role1.$$FightData.index, role2.$$FightData.team, role2.$$FightData.index, SkillEffects);

                    //console.debug("!!!", SkillEffects);

                    let genActionAndSprite = fightSkillData(role1.$$FightData.team, role1.$$FightData.index, role2.$$FightData.team, role2.$$FightData.index);
                    _private.asyncScript.create(genActionAndSprite);


                    //循环技能
                    while(1) {

                        //一个特效
                        let tRoleActionSpriteData = _private.asyncScript.run(SkillEffectResult);

                        //方案2：新的 Generator来执行
                        /*let tRoleActionSpriteData = genActionAndSprite.next(SkillEffectResult);
                        if(tRoleActionSpriteData.done === true)
                            break;
                        else
                            tRoleActionSpriteData = tRoleActionSpriteData.value;
                        */
                        //console.debug(JSON.stringify(tRoleActionSpriteData))

                        //动画结束
                        if(tRoleActionSpriteData.done)
                            break;
                        else
                            tRoleActionSpriteData = tRoleActionSpriteData.value;
                        if(!tRoleActionSpriteData)  //如果是其他yield（比如msg）
                            continue;

                        //类型
                        switch(tRoleActionSpriteData.Type) {
                        case 0: //结算 技能效果，刷新血条
                            SkillEffectResult = game.gf["$sys_fight_skill_algorithm"](role1.$$FightData.team, role1.$$FightData.index, role2.$$FightData.team, role2.$$FightData.index, tRoleActionSpriteData.SkillEffect);
                            //SkillEffectResult = (doSkillEffect(role1.$$FightData.team, role1.$$FightData.index, role2.$$FightData.team, role2.$$FightData.index, tRoleActionSpriteData.SkillEffect));
                            if(tRoleSpriteEffect2.blood)
                                tRoleSpriteEffect2.blood.refreshBlood(role2.properties);
                            continue;

                            break;

                        case 1: //Action

                            _private.refreshRoleAction(role1, tRoleActionSpriteData.Name, tRoleSpriteEffect1, tRoleActionSpriteData.Loops);

                            //缩放
                            if(GlobalLibraryJS.isArray(tRoleActionSpriteData.Scale)) {
                                tRoleSpriteEffect1.rXScale = parseFloat(tRoleActionSpriteData.Scale[0]);
                                tRoleSpriteEffect1.rYScale = parseFloat(tRoleActionSpriteData.Scale[1]);
                            }

                            //半透明
                            if(tRoleActionSpriteData.Opacity) {
                                tRoleSpriteEffect1.opacity = tRoleActionSpriteData.Opacity;
                            }

                            //计算播放时长
                            if(tRoleActionSpriteData.Interval) {
                                if(tRoleActionSpriteData.Interval === -1) {
                                    timerRoleSprite.interval = tRoleSpriteEffect1.nFrameCount * tRoleSpriteEffect1.interval * tRoleActionSpriteData.Loops;
                                    timerRoleSprite.start();
                                }
                                else if(tRoleActionSpriteData.Interval > 0) {
                                    timerRoleSprite.interval = tRoleActionSpriteData.Interval;
                                    timerRoleSprite.start();
                                }
                                else
                                    tRoleActionSpriteData.Interval = 0;
                            }

                            //是否跑动
                            if(tRoleActionSpriteData.Run) {
                                let offset;
                                switch(tRoleActionSpriteData.Run) {
                                case 1:
                                    let tx = tRoleSpriteEffect1.x < tRoleSpriteEffect2.x ? -tRoleSpriteEffect1.width : tRoleSpriteEffect1.width;
                                    offset = tRoleSpriteEffect1.mapFromItem(tRoleSpriteEffect2, tx, 0);
                                    numberanimationSpriteEffectX.to = offset.x + tRoleSpriteEffect1.x;
                                    numberanimationSpriteEffectY.to = offset.y + tRoleSpriteEffect1.y;

                                    //tRoleSpriteEffect1.x = offset.x + tRoleSpriteEffect1.x;
                                    //tRoleSpriteEffect1.y = offset.y + tRoleSpriteEffect1.y;

                                    //console.debug("!!!", offset, tRoleSpriteEffect1.x, offset.x + tRoleSpriteEffect1.x, AnimatedSprite.Infinite);

                                    break;
                                case 4:
                                    offset = _private.getRolesPosition(role1.$$FightData.teamID, role1.$$FightData.index);
                                    numberanimationSpriteEffectX.to = offset.x - tRoleSpriteEffect1.width / 2;
                                    numberanimationSpriteEffectY.to = offset.y - tRoleSpriteEffect1.height / 2;
                                    break;
                                }

                                numberanimationSpriteEffectX.target = tRoleSpriteEffect1;
                                numberanimationSpriteEffectX.duration = timerRoleSprite.interval;
                                numberanimationSpriteEffectX.start();
                                numberanimationSpriteEffectY.target = tRoleSpriteEffect1;
                                numberanimationSpriteEffectY.duration = timerRoleSprite.interval;
                                numberanimationSpriteEffectY.start();
                            }

                            //多特效
                            //MultiSprite

                            //Team
                            //我方还是敌方

                            if(tRoleActionSpriteData.Interval)
                                yield 0;
                            else
                                continue;

                            break;

                        case 2: {   //Sprite
                                let spriteEffect = loadSpriteEffect(tRoleActionSpriteData.Name, undefined, tRoleActionSpriteData.Loops);
                                let tRoleActionSpriteDataID;
                                if(!tRoleActionSpriteData.ID)
                                    tRoleActionSpriteDataID = tRoleActionSpriteData.Name;
                                else
                                    tRoleActionSpriteDataID = tRoleActionSpriteData.ID;

                                //检测ID是否重复
                                if(mapSpriteEffects[tRoleActionSpriteDataID]) {
                                    spriteEffect.destroy();
                                    delete mapSpriteEffects[tRoleActionSpriteDataID];
                                }

                                //保存到列表中，退出时会删除所有，防止删除错误
                                mapSpriteEffects[tRoleActionSpriteDataID] = spriteEffect;
                                spriteEffect.animatedsprite.finished.connect(
                                    function(){if(spriteEffect)spriteEffect.destroy();delete mapSpriteEffects[tRoleActionSpriteDataID];}
                                );
                                //spriteEffect.z = 999;

                                //缩放
                                if(GlobalLibraryJS.isArray(tRoleActionSpriteData.Scale)) {
                                    spriteEffect.rXScale = parseFloat(tRoleActionSpriteData.Scale[0]);
                                    spriteEffect.rYScale = parseFloat(tRoleActionSpriteData.Scale[1]);
                                }

                                //半透明
                                if(tRoleActionSpriteData.Opacity) {
                                    spriteEffect.opacity = tRoleActionSpriteData.Opacity;
                                }

                                //计算播放时长
                                if(tRoleActionSpriteData.Interval) {
                                    if(tRoleActionSpriteData.Interval === -1) {
                                        timerRoleSprite.interval = spriteEffect.nFrameCount * spriteEffect.interval * tRoleActionSpriteData.Loops;
                                        timerRoleSprite.start();
                                    }
                                    else if(tRoleActionSpriteData.Interval > 0) {
                                        timerRoleSprite.interval = tRoleActionSpriteData.Interval;
                                        timerRoleSprite.start();
                                    }
                                    else
                                        tRoleActionSpriteData.Interval = 0;
                                }

                                //位置
                                if(tRoleActionSpriteData.Position) {
                                    let position;
                                    switch(tRoleActionSpriteData.Position) {
                                    case 1:
                                        position = _private.getRolesPosition(role2.$$FightData.teamID, role2.$$FightData.index);
                                        spriteEffect.x = position.x - spriteEffect.width / 2;
                                        spriteEffect.y = position.y - spriteEffect.height / 2;

                                        break;
                                    case 4:
                                        position = _private.getRolesPosition(role1.$$FightData.teamID, role1.$$FightData.index);
                                        spriteEffect.x = position.x - spriteEffect.width / 2;
                                        spriteEffect.y = position.y - spriteEffect.height / 2;
                                        break;
                                    }
                                }

                                //是否跑动
                                if(tRoleActionSpriteData.Run) {
                                    let offset;
                                    switch(tRoleActionSpriteData.Run) {
                                    case 1:
                                        let tx = spriteEffect.x < tRoleSpriteEffect2.x ? -spriteEffect.width : spriteEffect.width;
                                        offset = spriteEffect.mapFromItem(tRoleSpriteEffect2, tx, 0);
                                        numberanimationSpriteEffectX.to = offset.x + spriteEffect.x;
                                        numberanimationSpriteEffectY.to = offset.y + spriteEffect.y;

                                        //spriteEffect.x = offset.x + spriteEffect.x;
                                        //spriteEffect.y = offset.y + spriteEffect.y;

                                        //console.debug("!!!", offset, spriteEffect.x, offset.x + spriteEffect.x, AnimatedSprite.Infinite);

                                        break;
                                    case 4:
                                        offset = _private.getRolesPosition(role1.$$FightData.teamID, role1.$$FightData.index);
                                        numberanimationSpriteEffectX.to = offset.x - spriteEffect.width / 2;
                                        numberanimationSpriteEffectY.to = offset.y - spriteEffect.height / 2;
                                        break;
                                    }

                                    numberanimationSpriteEffectX.target = spriteEffect;
                                    numberanimationSpriteEffectX.duration = timerRoleSprite.interval;
                                    numberanimationSpriteEffectX.start();
                                    numberanimationSpriteEffectY.target = spriteEffect;
                                    numberanimationSpriteEffectY.duration = timerRoleSprite.interval;
                                    numberanimationSpriteEffectY.start();
                                }

                                //多特效
                                //MultiSprite

                                //Team
                                //我方还是敌方

                                if(tRoleActionSpriteData.Interval)
                                    yield 0;
                                else
                                    continue;
                            }
                            break;

                        case 3: //显示动态文字

                            let spriteEffect = compWordMove.createObject(itemRolesContainer);
                            spriteEffect.parallelAnimation.finished.connect(function(){if(spriteEffect)spriteEffect.destroy();})


                            //缩放
                            if(tRoleActionSpriteData.Scale) {
                                spriteEffect.scale = tRoleActionSpriteData.Scale;
                            }

                            //半透明
                            if(tRoleActionSpriteData.Opacity) {
                                spriteEffect.opacity = tRoleActionSpriteData.Opacity;
                            }

                            //计算播放时长
                            if(tRoleActionSpriteData.Interval) {
                                if(tRoleActionSpriteData.Interval === -1) {
                                    spriteEffect.nMoveDuration = 1000;
                                    spriteEffect.nOpacityDuration = 1000;
                                    timerRoleSprite.interval = 1000;
                                    timerRoleSprite.start();
                                }
                                else if(tRoleActionSpriteData.Interval > 0){
                                    spriteEffect.nMoveDuration = tRoleActionSpriteData.Interval;
                                    spriteEffect.nOpacityDuration = tRoleActionSpriteData.Interval;
                                    timerRoleSprite.interval = tRoleActionSpriteData.Interval;
                                    timerRoleSprite.start();
                                }
                                else
                                    tRoleActionSpriteData.Interval = 0;
                            }

                            //颜色
                            if(tRoleActionSpriteData.Color) {
                                spriteEffect.text.color = tRoleActionSpriteData.Color;
                                //spriteEffect.text.styleColor = tRoleActionSpriteData.Color;
                                spriteEffect.text.styleColor = "";
                            }

                            //显示文字
                            if(tRoleActionSpriteData.Text !== undefined) {
                                spriteEffect.text.text = tRoleActionSpriteData.Text;
                            }
                            /*/或者显示 Data字符串方法 的返回值（可以使用 SkillEffectResult 对象）
                            if(tRoleActionSpriteData.Data) {
                                //console.debug(SkillEffectResult[0].value)
                                spriteEffect.text.text = GlobalJS.Eval(tRoleActionSpriteData.Data, "", {SkillEffectResult: SkillEffectResult});
                                //console.debug(spriteEffect.text.text)
                            }*/

                            //文字大小
                            if(tRoleActionSpriteData.FontSize) {
                                spriteEffect.text.font.pointSize = tRoleActionSpriteData.FontSize;
                            }

                            //位置（必须放在显示文字后）
                            if(tRoleActionSpriteData.Position) {
                                let position;
                                switch(tRoleActionSpriteData.Position) {
                                case 1:
                                    position = _private.getRolesPosition(role2.$$FightData.teamID, role2.$$FightData.index);
                                    spriteEffect.x = position.x - spriteEffect.width / 2;
                                    spriteEffect.y = position.y - spriteEffect.height / 2;

                                    break;
                                case 4:
                                    position = _private.getRolesPosition(role1.$$FightData.teamID, role1.$$FightData.index);
                                    spriteEffect.x = position.x - spriteEffect.width / 2;
                                    spriteEffect.y = position.y - spriteEffect.height / 2;
                                    break;
                                }
                            }


                            //!!!!!!修改：加入偏移和透明？
                            spriteEffect.moveAniX.to = spriteEffect.x;
                            spriteEffect.moveAniY.to = spriteEffect.y - 80;
                            spriteEffect.opacityAni.from = spriteEffect.opacity;
                            spriteEffect.opacityAni.to = 0;

                            spriteEffect.parallelAnimation.start();



                            if(tRoleActionSpriteData.Interval)
                                yield 0;
                            else
                                continue;

                        }   //switch

                    }//for



                    //如果有血条
                    if(tRoleSpriteEffect2.blood)
                        tRoleSpriteEffect2.blood.refreshBlood(role2.properties);


                    //重置位置
                    resetRolesPosition();
                    //tRoleSpriteEffect1.Layout.leftMargin = 0;
                    //tRoleSpriteEffect1.Layout.topMargin = 0;

                    //重置normal Action
                    _private.refreshRoleAction(role1, "normal", tRoleSpriteEffect1, AnimatedSprite.Infinite);


                    //if(harm !== 0) {   //对方生命为0
                        ret = _private.checkRoles();    //检测
                        if(ret !== 0) {         //战斗结束
                            bFightOver = true;
                        }
                    //}
                    if(bFightOver)
                        break;
                }


                //战斗结束
                if(bFightOver) {

                    _private.fightOver(ret);

                    return ret;
                }


                //一回合结束
                ++_private.nRound;

                rowlayoutButtons.enabled = true;
            }
        }

        //检测所有角色是否战斗完毕，并将死亡角色隐藏
        //返回：0为没有；1为胜利；-1为失败
        function checkRoles() {
            let nRet = -1;
            for(let i in myCombatants) {
                if(myCombatants[i].properties.remainHP > 0) {
                    nRet = 0;
                    //break;
                }
                //else
                    //repeaterMyCombatants.itemAt(i).visible = false;
            }

            if(nRet === -1)
                return -1;

            nRet = 1;
            for(let i in enemies) {
                if(enemies[i].properties.remainHP > 0) {
                    nRet = 0;
                    //break;
                }
                else {
                    repeaterEnemies.itemAt(i).opacity = 0;
                    //repeaterEnemies.itemAt(i).visible = false;
                }
            }

            return nRet;
        }

        //result：为null或undefined直接结束，为其他值（0平1胜-1败-2逃跑）执行事件（事件中调用结束信号）
        function fightOver(result) {

            _private.asyncScript.clear();
            _private.genHuiHe.clear();
            numberanimationSpriteEffectX.stop();
            numberanimationSpriteEffectY.stop();
            timerRoleSprite.stop();

            if(result !== undefined && result !== null) {

                let totalEXP = 0;
                let totalMoney = 0;
                for(let te in enemies) {
                    if(enemies[te].properties.remainHP <= 0) {
                        totalEXP += enemies[te].properties.EXP;
                        totalMoney += parseInt(enemies[te].money);
                    }
                }

                //回合结束脚本
                if(_private.fightEndScript) {
                    if(GlobalJS.createScript(_private.asyncScript, 0, _private.fightEndScript, result) === 0)
                        _private.asyncScript.run();
                }

                if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_fight_end_stript"].call({game, fight}, result, totalEXP, totalMoney)) === 0)
                    _private.asyncScript.run();

            }
            else
                s_FightOver();
        }
    }



    Keys.onEscapePressed:  {
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
        /*let tb = compBlood.createObject(itemTmp);
        tb.implicitWidth = 200;
        tb.implicitHeight = 20;
        tb.refreshBlood({blood: 100, blood1: 70, blood2: 50});

        let tb1 = compBlood.createObject(itemTmp);
        tb1.implicitWidth = 100;
        tb1.implicitHeight = 20;
        tb1.refreshBlood({blood: 100, blood1: 50, blood2: 20});
        //console.debug(tb, tb1, tb.refreshBlood === tb1.refreshBlood)
        */
        GameManager.globalObject().fight = fight;

        root.compSpriteEffect = Qt.createComponent("SpriteEffect.qml");
        root.compWordMove = Qt.createComponent("qrc:/QML/_Global/WordMove.qml");

        console.debug("[FightScene]Component.onCompleted", game, fight);
    }
}
