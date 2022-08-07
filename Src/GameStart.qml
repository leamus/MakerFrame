import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    function init() {

        let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "game_config.json";
        //let cfg = File.read(filePath);
        let cfg = GameManager.sl_qml_ReadFile(filePath);
        console.debug("[GameStart]filePath：", filePath);
        //console.exception("????")

        if(cfg === "")
            return false;
        cfg = JSON.parse(cfg);
        //console.debug("cfg", cfg);
        //loader.setSource("./MapEditor.qml", {});
        //loader.item.init(cfg);

        //textGameStartScript.text = cfg.GameStartScript;
        GameManager.setPlainText(textGameStartScript.textDocument, cfg.GameStartScript);
        textGameFPS.text = cfg.GameFPS;

    }


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



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
                text: "游戏起始脚本（载入外部脚本用game.script）"
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
                id: textGameStartScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                textArea.text: 'game.loadmap("");<BR>game.createhero("");<BR>game.setmap(,);<BR>game.createrole("","",,);<BR>game.playmusic("");<BR>game.msg("欢迎来到鹰歌Maker世界！");'
                textArea.placeholderText: "请输入脚本（载入外部脚本用game.script）"
            }

        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {

                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 20

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 15
                text: "游戏刷新率："
            }

            TextField {
                id: textGameFPS

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "16"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            ColorButton {
                id: buttonStartGame

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: "开始游戏"
                onButtonClicked: {
                    enabled = false;

                    let outputData = {};
                    outputData.Version = "0.6";
                    outputData.GameFPS = textGameFPS.text;
                    outputData.GameStartScript = GameManager.toPlainText(textGameStartScript.textDocument);

                    let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "game_config.json", 0);

                    loader.visible = true;
                    loader.focus = true;
                    loader.item.focus = true;

                    loader.item.init(outputData);
                }
            }

            ColorButton {
                id: buttonDeleteSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: "删除自动存档"
                onButtonClicked: {
                    GameManager.sl_qml_DeleteFile(GameMakerGlobal.config.strSaveDataPath + Platform.separator() + "autosave.json");
                }
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



    Loader {
        id: loader

        source: "./GameScene.qml"
        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            //item.testFresh();
            console.debug("[GameStart]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;

                buttonStartGame.enabled = true;
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

        console.debug("[GameStart]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[GameStart]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[GameStart]Keys.onPressed:", event.key);
    }
    Keys.onReleased:  {
        console.debug("[GameStart]Keys.onReleased:", event.key);
    }



    Component.onCompleted: {

    }
}
