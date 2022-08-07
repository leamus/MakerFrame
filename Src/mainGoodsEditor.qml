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


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: 50

            text: "新建道具"
            onButtonClicked: {
                loader.item.init();

                loader.visible = true;
                loader.item.forceActiveFocus();
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "打开道具"
            onButtonClicked: {
                dirList.visible = true;
                dirList.focus = true;
                dirList.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName, "*", 0x001 | 0x2000, 0x00);

            }
        }
    }



    Loader {
        id: loader

        source: "./GoodsEditor.qml"
        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            //item.testFresh();
            console.debug("[mainGoodsEditor]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;
            }
        }
    }

    DirList {
        id: dirList
        visible: false


        onCanceled: {
            //loader.visible = true;
            root.focus = true;
            //loader.item.focus = true;
            visible = false;
        }

        onClicked: {
            if(item === "..") {
                dirList.visible = false;
                return;
            }

            loader.visible = true;
            loader.focus = true;
            loader.item.focus = true;
            visible = false;

            /*
            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName + Platform.separator() + item + Platform.separator() + "goods.json";

            console.debug("[mainGoodsEditor]filePath：", filePath);

            //let cfg = File.read(filePath);
            let cfg = GameManager.sl_qml_ReadFile(filePath);

            if(cfg !== "") {
                cfg = JSON.parse(cfg);
                //console.debug("cfg", cfg);
                //loader.setSource("./MapEditor_1.qml", {});
                loader.item.openGoods(cfg);
            }
            */

            loader.item.init(item);
        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName + Platform.separator() + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainGoodsEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);

                forceActiveFocus();
            };
            dialogCommon.fOnRejected = ()=>{
                forceActiveFocus();
            };
            dialogCommon.open();
        }
    }



    //通用对话框
    /*/Dialog1.Dialog {
        anchors.centerIn: parent

        title: "深林孤鹰"
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
    */
    Dialog {
        id: dialogCommon

        property var fOnAccepted
        property var fOnRejected

        property alias text: textDialogTips.text



        visible: false
        anchors.centerIn: parent
        //width: 300
        //height: 200

        title: "深林孤鹰提示"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        Text {
            id: textDialogTips
            //text: qsTr("text")
        }


        onAccepted: {
            if(fOnAccepted)fOnAccepted();
            console.debug("[mainGoodsEditor]onAccepted");
        }
        onRejected: {
            if(fOnRejected)fOnRejected();
            console.debug("[mainGoodsEditor]onRejected");
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

        console.debug("[mainGoodsEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGoodsEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGoodsEditor]key:", event, event.key, event.text)
    }



    Component.onCompleted: {

    }
}
