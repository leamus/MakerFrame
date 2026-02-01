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


    function init(fightSkillName) {

        if(fightSkillName) {
            const filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + 'fight_skill.js';
            //const data = File.read(filePath);
            //console.debug('[FightSkillEditor]filePath：', filePath);

            const data = $Frame.sl_fileRead(filePath);

            if(data) {
                _private.strSavedName = textFightSkillName.text = fightSkillName;
                notepadFightSkillScript.setPlainText(data);
                notepadFightSkillScript.toBegin();
                notepadFightSkillScript.forceActiveFocus();

                return;
            }
        }

        _private.strSavedName = textFightSkillName.text = '';
        notepadFightSkillScript.setPlainText("
//闭包写法
const data = (function() {



    //独立属性，用 skill 来引用；会保存到存档中；
    const $createData = function(params) {
        return {
            $name: '普通攻击',
            $description: '跑上去打对方一下',

            //0：普通攻击；1：技能
            $type: 0,

            //如果$choiceScript为null，则根据这两项来选择系统的技能选择机制，反之这两个参数无效
            //0b10为选对方；0b1为选己方；
            $targetFlag: 0b10,
            //选择目标数；-1为全体；>0为个数；数组为范围；
            $targetCount: [1, 1],
        };
    };


    //公用属性，用 skill.$commons 或 skill 来引用；
    const $commons = {

        /*
        $name: '普通攻击',
        $description: '跑上去打对方一下',

        //0：普通攻击；1：技能
        $type: 0,

        //如果$choiceScript为null，则根据这两项来选择系统的技能选择机制，反之这两个参数无效
        //0b10为选对方；0b1为选己方；
        $targetFlag: 0b10,
        //选择目标数；-1为全体；>0为个数；数组为范围；
        $targetCount: [1, 1],
        */


        //选择技能时脚本；如果为null则根据 $targetFlag 和 $targetCount 自动调用 系统定义 的
        /*$choiceScript: function*(skill, combatant) {
            //选择敌方
            //let r = yield* fight.$sys.gfChoiceSingleCombatantSkill(skill, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
            //return r;
        },
        */
        $choiceScript: null,

        //技能产生的效果 和 动画
        $playScript: function*(skill, combatant) {

            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];

            //返回战斗算法结果
            let SkillEffectResult;
            let harm;


            let killCount = game.rnd(1,3);


            //Normal 动作特效，无限循环动画、500ms结束、对方面前
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Combatant: combatant, Target: targetCombatant, Run: 1});


            //kill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant});
            //kill 特效，1次，等待播放结束，特效ID，对方和位置
            yield ({Type: 20, Name: 'kill', Loops: 1, Interval: 0, ID: 'Kill1', Combatant: targetCombatant, Position: 1});
            //效果，Skill：KillType：
            //SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {}});
            SkillEffectResult = game.$sys.resources.commonScripts.$fightSkillAlgorithm(combatant, targetCombatant, {});
            harm = SkillEffectResult.shift().HP;
            game.addprops(targetCombatant, {'HP': [-harm[0], -harm[1]]});
            //刷新人物信息
            yield ({Type: 1});
            //显示文字，同步播放、红色、内容、大小、对方和位置
            yield ({Type: 30, Interval: 0, Color: 'red', Text: -harm[0], FontSize: 20, Combatant: targetCombatant, Position: undefined});


            //如果砍2次
            if(killCount > 1) {

                //再杀一次
                yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant, Target: targetCombatant});
                yield ({Type: 20, Name: 'kill', Loops: 1, Interval: 0, ID: 'Kill2', Combatant: targetCombatant, Position: 1});

                //SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {}});
                SkillEffectResult = game.$sys.resources.commonScripts.$fightSkillAlgorithm(combatant, targetCombatant, {});
                harm = SkillEffectResult.shift().HP;
                game.addprops(targetCombatant, {'HP': [-harm[0], -harm[1]]});
                //刷新人物信息
                yield ({Type: 1});

                yield ({Type: 30, Interval: 0, Color: 'red', Text: -harm[0], FontSize: 20, Combatant: targetCombatant, Position: undefined});

            }


            //Normal 动作特效，无限循环动画、500ms结束、原位置
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Combatant: combatant, Run: 0});



            //技能结束，必须返回null
            return null;
        },


        //检查技能、道具是否可在战斗中使用（有4个阶段会调用：见stage）；
        //返回：true表示可以使用；字符串和数组表示不能使用并提示的信息（只有选择时）；
        //stage为0表示我方刚选择技能时，为1表示我方选择技能的步骤完毕，为10表示战斗中我方或敌方刚选择技能时，为11表示战斗中我方或敌方选择技能的步骤完毕（可在阶段11操作属性，比如减去MP；道具的技能可单独设置）；
        $checkScript: function(skill, combatant, stage) {
            //调用通用
            let r = game.$sys.resources.commonScripts.$commonCheckScript.call(skill, skill, combatant, stage);
            if($CommonLibJS.isGenerator(r))r = yield* r;
            if(r !== true)
                return r;


            //其他步骤

            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            //let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];
            //使用类型：技能或道具
            let choiceType = combatant.$$fightData.$choice.$type;

            //if(combatant.$properties.MP[0] < 50)
            //    return '技能点不足';

            //阶段11时减去MP，道具跳过
            //if(stage === 11 && choiceType !== 2)
            //    game.addprops(combatant, {'MP': [-50]});

            return true;
        },
    };



    return {$createData, $commons};

})();

"
        );
        notepadFightSkillScript.toBegin();
        notepadFightSkillScript.forceActiveFocus();
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
                    const e = $GlobalJS.checkJSCode($Frame.sl_toPlainText(notepadFightSkillScript.textDocument));

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
                text: '战斗技能脚本'
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }

            Button {
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

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
                    const filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_skill.vjs';

                    fightSkillVisualEditor.forceActiveFocus();
                    fightSkillVisualEditor.visible = true;
                    fightSkillVisualEditor.init(filePath);
                }
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            Notepad {
                id: notepadFightSkillScript

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
                textArea.placeholderText: '请输入脚本代码'

                textArea.wrapMode: TextArea.WrapAnywhere
                textArea.horizontalAlignment: TextArea.AlignJustify
                //textArea.verticalAlignment: TextArea.AlignVCenter

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }

                bCode: true
            }

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
                id: textFightSkillName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '战斗技能名称'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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
        }
    }



    FightSkillVisualEditor {
        id: fightSkillVisualEditor

        anchors.fill: parent

        visible: false

        Connections {
            target: fightSkillVisualEditor
            //忽略没有的信号
            ignoreUnknownSignals: true
            
            function onSg_close() {
                fightSkillVisualEditor.visible = false;

                root.forceActiveFocus();
            }

            function onSg_compile(result) {
                notepadFightSkillScript.setPlainText(result);
                notepadFightSkillScript.toBegin();
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
            textFightSkillName.text = textFightSkillName.text.trim();

            if(textFightSkillName.text.length === 0) {
                $dialog.show({
                    Msg: '名称不能为空',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        textFightSkillName.text = _private.strSavedName;

                        //root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        textFightSkillName.text = _private.strSavedName;

                        //root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();
                        //root.forceActiveFocus();
                    },*/
                });

                return false;
            }

            const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

            function fnSave() {
                let ret = $Frame.sl_fileWrite($Frame.sl_toPlainText(notepadFightSkillScript.textDocument), path + GameMakerGlobal.separator + textFightSkillName.text + GameMakerGlobal.separator + 'fight_skill.js', 0);

                //复制可视化
                if(_private.strSavedName) {
                    const oldFilePath = path + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_skill.vjs';
                    if(textFightSkillName.text !== _private.strSavedName && $Frame.sl_fileExists(oldFilePath)) {
                        ret = $Frame.sl_fileCopy(oldFilePath, path + GameMakerGlobal.separator + textFightSkillName.text + GameMakerGlobal.separator + 'fight_skill.vjs', true);
                    }
                }

                _private.strSavedName = textFightSkillName.text;

                //root.focus = true;
                //root.forceActiveFocus();
            }

            if(textFightSkillName.text !== _private.strSavedName && $Frame.sl_dirExists(path + GameMakerGlobal.separator + textFightSkillName.text)) {
                $dialog.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textFightSkillName.text = _private.strSavedName;

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
        console.debug('[FightSkillEditor]Keys.onEscapePressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[FightSkillEditor]Keys.onBackPressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onPressed: function(event) {
        console.debug('[FightSkillEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[FightSkillEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[FightSkillEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[FightSkillEditor]Component.onDestruction');
    }
}
