import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



Rectangle {
    id: root


    signal s_close();
    onS_close: {
    }


    function init(fightRoleName) {

        if(fightRoleName) {
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + fightRoleName + GameMakerGlobal.separator + 'fight_role.js';
            let data = FrameManager.sl_qml_ReadFile(filePath);

            if(data) {
                _private.strSavedName = textFightRoleName.text = fightRoleName;
                notepadFightRoleProperty.setPlainText(data);
                notepadFightRoleProperty.toBegin();

                return;
            }
        }

        _private.strSavedName = textFightRoleName.text = '';
        notepadFightRoleProperty.setPlainText("

//闭包写法
let data = (function() {



    //独立属性，用 combatant 来引用；会保存到存档中；
    //params：使用对象{RId:xxx, Params: 。。。}创建时的对象参数。
    let $createData = function(params) { //创建战斗角色时的初始数据，可忽略（在战斗脚本中写）；
        return {
            $name: '敌人1', $properties: {HP: [60,60,60]}, $avatar: '', $size: [60, 60], $color: 'white', $skills: [{RId: 'fight'}], $goods: [], $equipment: [], $money: 6, $EXP: 6,
        };
    };


    //公用属性，用 combatant.$commons 或 combatant 来引用；
    let $commons = {

        //$name: '敌人1', $properties: {HP: [60,60,60]}, $avatar: '', $size: [60, 60], $color: 'white', $skills: [{RId: 'fight'}], $goods: [], $equipment: [], $money: 6, $EXP: 6,


        //动作包含的 精灵名
        $actions: function(combatant) {
            return {
                'Normal': 'killer_normal',
                'Kill': 'killer_kill',
            };
        }


        //角色单独的升级链脚本和升级算法，可忽略（会自动使用通用的升级链和算法）

        /*
        //角色单独的升级链脚本
        function *levelUpScript(combatant) {
        }

        //targetLeve级别对应需要达到的 各项属性 的算法（升级时会设置，可选；注意：只增不减）
        function levelAlgorithm(combatant, targetLevel) {
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
        */
    };



    return {$createData, $commons};

})();
"
        );
        notepadFightRoleProperty.toBegin();


    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true

    color: Global.style.backgroundColor



    MouseArea {
        anchors.fill: parent
    }




    ColumnLayout {
        anchors.fill: parent


        Label {
            //Layout.preferredWidth: 80
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
            Layout.fillWidth: true
            text: '战斗角色脚本'
            font.pointSize: 16
            wrapMode: Label.WordWrap
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }

        Notepad {
            id: notepadFightRoleProperty

            Layout.preferredWidth: parent.width * 0.96

            Layout.preferredHeight: textArea.contentHeight
            Layout.maximumHeight: parent.height
            Layout.minimumHeight: 50
            Layout.fillHeight: true

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


            textArea.textFormat: TextArea.PlainText
            textArea.text: ''
            textArea.placeholderText: '输入脚本'

            textArea.background: Rectangle {
                //color: 'transparent'
                color: Global.style.backgroundColor
                border.color: notepadFightRoleProperty.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                border.width: notepadFightRoleProperty.textArea.focus ? 2 : 1
            }

            bCode: true
        }


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            Button {
                id: buttonVisual

                //Layout.preferredWidth: 60

                text: 'V'
                onClicked: {
                    if(!_private.strSavedName) {
                        dialogCommon.show({
                            Msg: '请先保存',
                            Buttons: Dialog.Yes,
                            OnAccepted: function(){
                                root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                root.forceActiveFocus();
                            },
                        });
                        return;
                    }
                    let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_role.vjs';

                    gameVisualFightRole.forceActiveFocus();
                    gameVisualFightRole.visible = true;
                    gameVisualFightRole.init(filePath);
                }
            }

            Button {
                id: buttonSave

                //Layout.preferredWidth: 60

                text: '保存'
                onClicked: {
                    _private.save();
                }
            }

            TextField {
                id: textFightRoleName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '战斗角色名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }
    }


    GameVisualFightRole {

        id: gameVisualFightRole

        anchors.fill: parent

        visible: false

        Connections {
            target: gameVisualFightRole
            function onS_close() {
                gameVisualFightRole.visible = false;

                root.forceActiveFocus();
            }

            function onS_Compile(code) {
                notepadFightRoleProperty.setPlainText(code);
                notepadFightRoleProperty.toBegin();
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private

        property string strSavedName: ''


        function save() {
            let newName = textFightRoleName.text = textFightRoleName.text.trim();

            if(newName.length === 0)
                return false;


            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator;


            let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(notepadFightRoleProperty.textDocument), path + newName + GameMakerGlobal.separator + 'fight_role.js', 0);


            //复制可视化
            let oldName = _private.strSavedName.trim();
            if(oldName) {
                let oldFilePath = path + oldName + GameMakerGlobal.separator + 'fight_role.vjs';
                if(newName !== oldName && FrameManager.sl_qml_FileExists(oldFilePath)) {
                    ret = FrameManager.sl_qml_CopyFile(oldFilePath, path + newName + GameMakerGlobal.separator + 'fight_role.vjs', true);
                }
            }


            _private.strSavedName = newName;

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function(){
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



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        _private.close();

        console.debug('[GameFightRole]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[GameFightRole]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameFightRole]Keys.onPressed:', event.key);
    }
    Keys.onReleased: {
        console.debug('[GameFightRole]Keys.onReleased:', event.key);
    }



    Component.onCompleted: {
        console.debug('[GameFightRole]Component.onCompleted');
    }
}
