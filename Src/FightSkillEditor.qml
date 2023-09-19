import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



Rectangle {
    id: root


    signal s_close();


    function init(fightSkillName) {

        if(fightSkillName) {
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + fightSkillName + GameMakerGlobal.separator + 'fight_skill.js';
            //let data = File.read(filePath);
            //console.debug('[GameFightSkill]filePath：', filePath);

            let data = FrameManager.sl_qml_ReadFile(filePath);

            if(data) {
                //console.debug('data', data);
                _private.strSavedName = textFightSkillName.text = fightSkillName;
                FrameManager.setPlainText(notepadGameFightSkillScript.textDocument, data);
                notepadGameFightSkillScript.toBegin();

                return;
            }
        }

        _private.strSavedName = textFightSkillName.text = '';
        FrameManager.setPlainText(notepadGameFightSkillScript.textDocument, "

//闭包写法
let data = (function() {



    //独立属性，用 skill 来引用；会保存到存档中；
    let $createData = function(params) {
        return {
            $name: '普通攻击',
            $description: '跑上去打对方一下',

            //0：普通攻击；1：技能
            $type: 0,
            //0b10为选对方；0b1为选己方；
            $targetFlag: 0b10,
            //选择目标数；-1为全体；>0为个数；数组为范围；
            $targetCount: [1, 1],
        };
    };


    //公用属性，用 skill.$commons 或 skill 来引用；
    let $commons = {

        /*
        $name: '普通攻击',
        $description: '跑上去打对方一下',

        //0：普通攻击；1：技能
        $type: 0,
        //0b10为选对方；0b1为选己方；
        $targetFlag: 0b10,
        //选择目标数；-1为全体；>0为个数；数组为范围；
        $targetCount: [1, 1],
        */


        //选择技能时脚本
        $choiceScript: function *(skill, combatant) {
            //yield fight.msg('...');
            return;
        },

        //技能产生的效果 和 动画
        $playScript: function*(skill, combatant) {

            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$attackSkill;
            //目标战斗人物
            let targetCombatant = combatant.$$fightData.$target[0];

            //返回战斗算法结果
            let SkillEffectResult;
            let harm;


            let killCount = game.rnd(1,3);


            //Normal 动作特效，无限循环动画、500ms结束、对方面前
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Combatant: combatant, Target: targetCombatant, Run: 1});


            //kill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant});
            //kill 特效，1次，等待播放结束，特效ID，对方和位置
            yield ({Type: 20, Name: 'kill', Loops: 1, Interval: 0, RId: 'Kill1', Combatant: targetCombatant, Position: 1});
            //效果，Skill：KillType：
            SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {Skill: 1}});
            harm = SkillEffectResult.shift().HP;
            game.addprops(targetCombatant, {'HP': [-harm[0], -harm[1]]});
            //刷新人物信息
            yield ({Type: 1});
            //显示文字，同步播放、红色、内容、大小、对方和位置
            yield ({Type: 30, Interval: 0, Color: 'red', Text: -harm[0], FontSize: 20, Combatant: targetCombatant, Position: undefined});


            //如果砍2次
            if(killCount > 1)  {

                //再杀一次
                yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant, Target: targetCombatant});
                yield ({Type: 20, Name: 'kill', Loops: 1, Interval: 0, RId: 'Kill2', Combatant: targetCombatant, Position: 1});

                SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {Skill: 1}});
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


        //检查技能（有4个阶段会调用：选择时、攻击时、敌人和我方遍历时）；
        //返回：true表示可以使用；字符串表示不能使用并提示的信息（只有选择时）；
        //stage为0表示选择时，为1表示选择某战斗角色（我方或敌方，此时targetCombatant不为null，其他情况为null），为10表示战斗中（在阶段10减去MP的作用：道具的技能可以跳过减MP）；
        $check: function(skill, combatant, targetCombatant, stage) {
            //if(combatant.$properties.MP[0] < 50)
            //    return '技能点不足';

            //阶段10时减去MP
            //if(stage === 10)
            //    game.addprops(combatant, {'MP': [-50]});

            return true;
        },
    };



    return {$createData, $commons};

})();

"
        );
        notepadGameFightSkillScript.toBegin();

    }


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true


    MouseArea {
        anchors.fill: parent
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
                text: '技能算法脚本'
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
                id: notepadGameFightSkillScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                textArea.text: ''
                textArea.placeholderText: '请输入算法脚本'
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            ColorButton {
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: 'V'
                onButtonClicked: {
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
                    let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'fight_skill.vjs';

                    gameVisualFightSkill.forceActiveFocus();
                    gameVisualFightSkill.visible = true;
                    gameVisualFightSkill.init(filePath);
                }
            }
            ColorButton {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: '保存'
                onButtonClicked: {
                    let newName = textFightSkillName.text = textFightSkillName.text.trim();

                    if(newName.length === 0)
                        return;


                    let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator;


                    let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(notepadGameFightSkillScript.textDocument), path + newName + GameMakerGlobal.separator + 'fight_skill.js', 0);


                    //复制可视化
                    let oldName = _private.strSavedName.trim();
                    if(oldName) {
                        let oldFilePath = path + oldName + GameMakerGlobal.separator + 'fight_skill.vjs';
                        if(newName !== oldName && FrameManager.sl_qml_FileExists(oldFilePath)) {
                            ret = FrameManager.sl_qml_CopyFile(oldFilePath, path + newName + GameMakerGlobal.separator + 'fight_skill.vjs', true);
                        }
                    }


                    _private.strSavedName = newName;
                }
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
        }
    }



    GameVisualFightSkill {
        id: gameVisualFightSkill

        anchors.fill: parent

        visible: false

        Connections {
            target: gameVisualFightSkill
            function onS_close() {
                gameVisualFightSkill.visible = false;

                root.forceActiveFocus();
            }

            function onS_Compile(code) {
                FrameManager.setPlainText(notepadGameFightSkillScript.textArea.textDocument, code);
                notepadGameFightSkillScript.toBegin();
            }
        }
    }



    QtObject {
        id: _private

        //保存后的名字
        property string strSavedName: ''
    }

    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug('[GameFightSkill]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug('[GameFightSkill]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameFightSkill]Keys.onPressed:', event.key);
    }
    Keys.onReleased: {
        console.debug('[GameFightSkill]Keys.onReleased:', event.key);
    }



    Component.onCompleted: {

    }
}
