import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.leamus.gamedata 1.0


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    function init(fightSkillName) {
        if(fightSkillName) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName + Platform.separator() + fightSkillName + Platform.separator() + "fight_skill.json";
            //let data = File.read(filePath);
            //console.debug("[GameFightSkill]filePath：", filePath);

            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                //console.debug("data", data);
                GameManager.setPlainText(notepadGameFightSkillScript.textDocument, data.FightSkill);
                textFightSkillName.text = fightSkillName;
                return;
            }
        }

        GameManager.setPlainText(notepadGameFightSkillScript.textDocument,'
//闭包写法
(function() {



    //技能产生的效果 和 动画
    function *doSkillEffects(team1, index1, team2, index2) {

    }

    //检查技能是否可以发动
    function checkSkillData(team1, index1, team2, index2) {
        return {success: true, msg: ""}
    }



    return {showName:"技能名", discription: "技能说明", doSkillEffects, checkSkillData}

})()');
        textFightSkillName.text = "";

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
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.fillWidth: true
                text: "技能算法脚本（载入外部脚本用game.evaluateFile）"
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
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
                textArea.placeholderText: "请输入算法脚本（载入外部脚本用game.evaluateFile）"
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            ColorButton {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: "保存"
                onButtonClicked: {
                    if(textFightSkillName.text.trim().length === 0)
                        return;

                    let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName + Platform.separator() + textFightSkillName.text + Platform.separator() + "fight_skill.json";

                    let outputData = {};
                    outputData.Version = "0.6";
                    outputData.FightSkill = GameManager.toPlainText(notepadGameFightSkillScript.textDocument);

                    //!!!导出为文件
                    //console.debug(JSON.stringify(outputData));
                    //let ret = File.write(path + Platform.separator() + 'map.json', JSON.stringify(outputData));
                    let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), filePath, 0);
                    //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

                }
            }
            TextField {
                id: textFightSkillName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "战斗技能名称"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

    }


    QtObject {
        id: _private

    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[mainGame]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGame]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGame]Keys.onPressed:", event.key);
    }
    Keys.onReleased:  {
        console.debug("[mainGame]Keys.onReleased:", event.key);
    }



    Component.onCompleted: {

    }
}
