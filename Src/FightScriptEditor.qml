﻿import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



Item {
    id: root


    signal s_close();


    function init(fightScriptName) {

        if(fightScriptName) {
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + fightScriptName + GameMakerGlobal.separator + 'fight_script.js';
            //let data = File.read(filePath);
            //console.debug('[GameFightScript]filePath：', filePath);

            let data = FrameManager.sl_qml_ReadFile(filePath);

            if(data) {
                _private.strSavedName = textFightScriptName.text = fightScriptName;

                notepadGameFightScriptScript.setPlainText(data);
                notepadGameFightScriptScript.toBegin();

                return;
            }
        }

        _private.strSavedName = textFightScriptName.text = '';
        notepadGameFightScriptScript.setPlainText("

//闭包写法
let data = (function() {



    //独立属性，用 fightData 来引用；
    let $createData = function(params) {
        return {
            //背景图
            $backgroundImage: 'FightScene.jpg',
            //播放音乐名，为true表示继续播放当前地图的音乐
            $music: 'fight.mp3',
            //是否可以逃跑；true则调用 通用逃跑算法；0~1则为概率逃跑；false为不能逃跑
            $runAway: true,
            $enemyCount: [1, 3],	//为数组（m-n）的随机排列，为数字则依次按顺序排列，如果为true则表示按顺序排列
            //RId是战斗角色资源名（必写），$goods是携带道具（可掉落），其他属性会覆盖战斗角色属性
            $enemiesData: [
                {RId: 'killer2', $name: '敌人1', $properties: {HP: [5, 5, 5], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '西瓜刀', Params: {}}], $money: 5, $EXP: 5},
                {RId: 'killer2', $name: '敌人2', $properties: {HP: [10, 10, 10], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '小刀', Params: {}}], $money: 10, $EXP: 10},
                {RId: 'killer2', $name: '敌人3', $properties: {HP: [20, 20, 20], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '小草', Params: {}}], $money: 20, $EXP: 20},
                {RId: 'killer2', $name: '敌人4', $properties: {HP: [50, 50, 50], speed: 1}, $skills: ['fight'], $goods: ['小草'], $money: 50, $EXP: 50},
                {RId: 'killer2', $name: '敌人5', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 100, $EXP: 100},
                {RId: 'killer2', $name: '敌人6', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 200, $EXP: 200},
                {RId: 'killer2', $name: '敌人7', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 500, $EXP: 500},
            ],
        }
    };


    //公用属性，用 fightData.$commons 或 fightData 来引用；
    let $commons = {

        /*
        //背景图
        $backgroundImage: 'FightScene.jpg',
        //播放音乐名，为true表示继续播放当前地图的音乐
        $music: 'fight.mp3',
        //是否可以逃跑；true则调用 通用逃跑算法；0~1则为概率逃跑；false为不能逃跑
        $runAway: true,
        $enemyCount: [1, 3],	//为数组（m-n）的随机排列，为数字则依次按顺序排列，如果为true则表示按顺序排列
        //RId是战斗角色资源名（必写），$goods是携带道具（可掉落），其他属性会覆盖战斗角色属性
        $enemiesData: [
            {RId: 'killer2', $name: '敌人1', $properties: {HP: [5, 5, 5], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '西瓜刀', Params: {}}], $money: 5, $EXP: 5},
            {RId: 'killer2', $name: '敌人2', $properties: {HP: [10, 10, 10], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '小刀', Params: {}}], $money: 10, $EXP: 10},
            {RId: 'killer2', $name: '敌人3', $properties: {HP: [20, 20, 20], speed: 1}, $skills: [{RId: 'fight', Params: {}}], $goods: [{RId: '小草', Params: {}}], $money: 20, $EXP: 20},
            {RId: 'killer2', $name: '敌人4', $properties: {HP: [50, 50, 50], speed: 1}, $skills: ['fight'], $goods: ['小草'], $money: 50, $EXP: 50},
            {RId: 'killer2', $name: '敌人5', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 100, $EXP: 100},
            {RId: 'killer2', $name: '敌人6', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 200, $EXP: 200},
            {RId: 'killer2', $name: '敌人7', $properties: {HP: [100, 100, 100], speed: 1}, $skills: ['fight'], $goods: ['西瓜刀'], $money: 500, $EXP: 500},
        ],
        */


        $fightInitScript: function *(teams, fightData) {
            yield fight.msg('战斗初始化事件', 0);
        },

        $fightStartScript: function *(teams, fightData) {
            yield fight.msg('战斗开始事件');
        },

        $fightRoundScript: function *(round, step, teams, fightData) {
            switch(step) {  //step：0，回合开始；1，选择完毕
            case 0:
                yield fight.msg('第%1回合'.arg(round));
                break;
            case 1:
                break;
            }
        },

        $fightEndScript: function *(r, step, teams, fightData) {
            //step：为0是战斗结束时调用；为1时返回地图时调用
            //r中包含：result（战斗结果）、money和exp
            //  这里可以修改r，然后会传递给 通用战斗结束函数
            //console.debug(JSON.stringify(r));
            //r.result = 666;

            switch(step) {  //step：0，战斗结束；1，返回地图
            case 0:
                //yield fight.msg('战斗结束事件：' + r.result);
                break;
            case 1:
                //yield game.msg('返回地图事件');
                break;
            }
        },
    };



    return ({$createData, $commons});

})();

"
        );
        notepadGameFightScriptScript.toBegin();

        //console.debug('data', data);
    }


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
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
                text: '战斗脚本'
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


                //textArea.enabled: false
                //textArea.readOnly: true
                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: '请输入战斗脚本'

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: notepadGameFightScriptScript.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                    border.width: notepadGameFightScriptScript.textArea.focus ? 2 : 1
                }

                bCode: true
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            Button {
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: 'V'
                onClicked: {
                    if(!_private.strSavedName) {
                        dialogCommon.show({
                            Msg: '请先保存',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                root.forceActiveFocus();
                            },
                        });
                        return;
                    }
                    let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_script.vjs';

                    gameVisualFightScript.forceActiveFocus();
                    gameVisualFightScript.visible = true;
                    gameVisualFightScript.init(filePath);
                }
            }
            Button {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: '保存'
                onClicked: {
                    _private.save();
                }
            }
            TextField {
                id: textFightScriptName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '战斗脚本名称'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }
    }



    GameVisualFightScript {
        id: gameVisualFightScript

        anchors.fill: parent

        visible: false

        Connections {
            target: gameVisualFightScript
            function onS_close() {
                gameVisualFightScript.visible = false;

                root.forceActiveFocus();
            }

            function onS_Compile(code) {
                notepadGameFightScriptScript.setPlainText(code);
                notepadGameFightScriptScript.toBegin();
            }
        }
    }



    QtObject {
        id: _private

        //保存后的名字
        property string strSavedName: ''


        function save() {
            let newName = textFightScriptName.text = textFightScriptName.text.trim();

            if(newName.length === 0)
                return false;


            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator;


            let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(notepadGameFightScriptScript.textDocument), path + newName + GameMakerGlobal.separator + 'fight_script.js', 0);


            //复制可视化
            let oldName = _private.strSavedName.trim();
            if(oldName) {
                let oldFilePath = path + oldName + GameMakerGlobal.separator + 'fight_script.vjs';
                if(newName !== oldName && FrameManager.sl_qml_FileExists(oldFilePath)) {
                    ret = FrameManager.sl_qml_CopyFile(oldFilePath, path + newName + GameMakerGlobal.separator + 'fight_script.vjs', true);
                }
            }


            _private.strSavedName = newName;

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
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
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        _private.close();

        console.debug('[GameFightScript]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[GameFightScript]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameFightScript]Keys.onPressed:', event.key);
    }
    Keys.onReleased: {
        console.debug('[GameFightScript]Keys.onReleased:', event.key);
    }



    Component.onCompleted: {

    }
}
