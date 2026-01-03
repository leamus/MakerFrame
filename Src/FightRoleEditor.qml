import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();


    function init(fightRoleName) {

        if(fightRoleName) {
            const filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + fightRoleName + GameMakerGlobal.separator + 'fight_role.js';
            const data = $Frame.sl_fileRead(filePath);

            if(data) {
                _private.strSavedName = textFightRoleName.text = fightRoleName;
                notepadFightRoleProperty.setPlainText(data);
                notepadFightRoleProperty.toBegin();
                notepadFightRoleProperty.forceActiveFocus();

                return;
            }
        }

        _private.strSavedName = textFightRoleName.text = '';
        notepadFightRoleProperty.setPlainText("
//闭包写法
const data = (function() {



    //独立属性，用 combatant 来引用；会保存到存档中；
    //params：使用对象{RID:xxx, Params: 。。。}创建时的对象参数。
    const $createData = function(params) { //创建战斗角色时的初始数据，可忽略（在战斗脚本中写）；
        return {
            $name: '敌人1', $properties: {HP: [60,60,60]}, $avatar: 'avatar.png', $size: [60, 60], $color: 'white', $skills: [{RID: 'fight'}], $goods: [], $equipment: [], $money: 6, $EXP: 6,
        };
    };


    //公用属性，用 combatant.$commons 或 combatant 来引用；
    const $commons = {

        //$name: '敌人1', $properties: {HP: [60,60,60]}, $avatar: 'avatar.png', $size: [60, 60], $color: 'white', $skills: [{RID: 'fight'}], $goods: [], $equipment: [], $money: 6, $EXP: 6,


        //动作包含的 精灵名（可以为函数或对象）
        $actions: function(combatant) {
            return {
                'Normal': 'killer_normal',
                'Kill': 'killer_kill',
            };
        },



        //角色单独的升级链脚本和升级算法（方法1：这里定义 levelUpScript、levelAlgorithm 或 levelInfos；方法2：载入level_chain.js的）；

        /*/方法1（优先）：
        //角色单独的升级链脚本；
        //  level为0表示检测升级，否则表示直接升级level级；
        levelUpScript: function*(combatant, level=0) {
        },

        //targetLevel级别对应需要达到的 各项属性 的算法
        levelAlgorithm: function(combatant, targetLevel) {
            if(targetLevel <= 0)
                return 0;

            let level = 1;  //级别
            let exp = 10;   //级别的经验

            while(level < targetLevel) {
                exp = exp * 2;
                ++level;
            }

            return {Conditions: {EXP: exp}, //支持'HP,2': xxx，不能有空格
                Properties: {
                    HP: {Type: 1, Value: combatant.$properties.HP[2] * 0.1},
                    MP: {Type: 2, Value: 1.1},
                    attack: {Type: 1, Value: combatant.$properties.attack * 0.1},
                    defense: {Type: 2, Value: 1.1},
                    power: {Type: 3, Value: combatant.$properties.power * 1.1},
                    luck: {Type: 3, Value: combatant.$properties.luck * 1.1},
                    speed: {Type: 3, Value: combatant.$properties.speed * 1.1},
                },
                Skills: [],
            };
        },
        */


        //方法2：
        //levelInfos: [],
    };


    /*/方法1：
    if($Frame.sl_fileExists($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.js')))) {
        const levelChain = game.$sys.caches.jsLoader.load($GlobalJS.toURL(Qt.resolvedUrl('./level_chain.js')));
        if(levelChain.levelUpScript)$commons.levelUpScript = levelChain.levelUpScript;
        if(levelChain.levelAlgorithm)$commons.levelAlgorithm = levelChain.levelAlgorithm;
    }
    */
    //方法2：
    if($Frame.sl_fileExists($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.json')))) {
        const levelInfos = $Frame.sl_fileRead($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.json')));
        try {
            $commons.levelInfos = JSON.parse(levelInfos);
        }
        catch(e) {
            console.warn('[!fight_role]level_chain.json文件不合法：', Qt.resolvedUrl('.'));
        }
    }


    return {$createData, $commons};

})();
"
        );
        notepadFightRoleProperty.toBegin();
        notepadFightRoleProperty.forceActiveFocus();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }


    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop


            Button {
                //Layout.fillWidth: true
                //Layout.preferredHeight: 70

                text: '查'

                onClicked: {
                    const e = $GlobalJS.checkJSCode($Frame.sl_toPlainText(notepadFightRoleProperty.textDocument));

                    if(e) {
                        $dialog.show({
                            Msg: e,
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                //root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //root.forceActiveFocus();
                            },
                        });

                        return;
                    }

                    $dialog.show({
                        Msg: '恭喜，没有语法错误',
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            //root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                    });

                    return;
                }
            }

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

            Button {
                id: buttonVisual

                //Layout.preferredWidth: 60

                text: 'V'

                onClicked: {
                    if(!_private.strSavedName) {
                        $dialog.show({
                            Msg: '请先保存',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                //root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //root.forceActiveFocus();
                            },
                        });
                        return;
                    }
                    const filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_role.vjs';

                    fightRoleVisualEditor.forceActiveFocus();
                    fightRoleVisualEditor.visible = true;
                    fightRoleVisualEditor.init(filePath);
                }
            }
        }

        Notepad {
            id: notepadFightRoleProperty

            Layout.preferredWidth: parent.width * 0.96

            Layout.preferredHeight: textArea.contentHeight
            Layout.maximumHeight: parent.height
            Layout.minimumHeight: 50
            Layout.fillHeight: true

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


            //textArea.enabled: false
            //textArea.readOnly: true
            textArea.textFormat: TextArea.PlainText
            textArea.text: ''
            textArea.placeholderText: '输入脚本'

            textArea.background: Rectangle {
                //color: 'transparent'
                color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }

            bCode: true
        }


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.bottomMargin: 10
            
            Label {
                text: '资源名：'
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

            Button {
                id: buttonSave

                //Layout.preferredWidth: 60

                text: '保存'

                onClicked: {
                    _private.save();
                }
            }
        }
    }


    FightRoleVisualEditor {
        id: fightRoleVisualEditor

        anchors.fill: parent

        visible: false

        Connections {
            target: fightRoleVisualEditor
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                fightRoleVisualEditor.visible = false;

                root.forceActiveFocus();
            }

            function onSg_compile(result) {
                notepadFightRoleProperty.setPlainText(result);
                notepadFightRoleProperty.toBegin();
            }
        }
    }



    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


        //保存后的名字
        property string strSavedName: ''


        function save() {
            textFightRoleName.text = textFightRoleName.text.trim();

            if(textFightRoleName.text.length === 0) {
                $dialog.show({
                    Msg: '名称不能为空',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        textFightRoleName.text = _private.strSavedName;

                        //root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        textFightRoleName.text = _private.strSavedName;

                        //root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();
                        //root.forceActiveFocus();
                    },*/
                });

                return false;
            }

            const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;

            function fnSave() {
                let ret = $Frame.sl_fileWrite($Frame.sl_toPlainText(notepadFightRoleProperty.textDocument), path + GameMakerGlobal.separator + textFightRoleName.text + GameMakerGlobal.separator + 'fight_role.js', 0);

                //复制可视化
                if(_private.strSavedName) {
                    const oldFilePath = path + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_role.vjs';
                    if(textFightRoleName.text !== _private.strSavedName && $Frame.sl_fileExists(oldFilePath)) {
                        ret = $Frame.sl_fileCopy(oldFilePath, path + GameMakerGlobal.separator + textFightRoleName.text + GameMakerGlobal.separator + 'fight_role.vjs', true);
                    }
                }

                _private.strSavedName = textFightRoleName.text;

                //root.focus = true;
                //root.forceActiveFocus();
            }

            if(textFightRoleName.text !== _private.strSavedName && $Frame.sl_dirExists(path + GameMakerGlobal.separator + textFightRoleName.text)) {
                $dialog.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textFightRoleName.text = _private.strSavedName;

                        //root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();
                        //root.forceActiveFocus();
                    },*/
                });

                return false;
            }
            else {
                fnSave();

                return true;
            }
        }

        function close() {
            $dialog.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(save())
                        sg_close();

                    ///root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    $dialog.close();
                    //root.forceActiveFocus();
                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[FightRoleEditor]Keys.onEscapePressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[FightRoleEditor]Keys.onBackPressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onPressed: function(event) {
        console.debug('[FightRoleEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[FightRoleEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[FightRoleEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[FightRoleEditor]Component.onDestruction');
    }
}
