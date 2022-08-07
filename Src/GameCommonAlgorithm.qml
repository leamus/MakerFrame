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


    function init() {

        //读算法

        let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() +  "common_algorithm.json";
        //let data = File.read(filePath);
        //console.debug("data", filePath, data)

        let data = GameManager.sl_qml_ReadFile(filePath);

        if(data !== "") {
            data = JSON.parse(data)["FightAlgorithm"];
            GameManager.setPlainText(notepadGameFightAlgorithmScript.textDocument, data);
        }
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
                text: "游戏通用算法脚本（载入外部脚本用game.evaluateFile）"
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
                id: notepadGameFightAlgorithmScript

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

        ColorButton {
            id: buttonSave

            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            text: "保存"
            onButtonClicked: {
                let outputData = {};
                outputData.Version = "0.6";
                outputData.FightAlgorithm = GameManager.toPlainText(notepadGameFightAlgorithmScript.textDocument);

                let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "common_algorithm.json", 0);
            }
        }

        /*RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "主角大小："
            }

            TextField {
                id: textMainRoleWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "50"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "X"
            }

            TextField {
                id: textMainRoleHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "80"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/
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
