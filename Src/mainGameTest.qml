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


//import './Core'


//import 'File.js' as File



Rectangle {
    id: root

    signal s_close();


    function init(cfg) {
        if(cfg && cfg.map)
            textMapName.text = cfg.map;
        if(cfg && cfg.role)
            textRoleName.text = cfg.role;
    }


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true

    color: Global.style.backgroundColor



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        TextField {
            id: textMapName
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            //selectByKeyboard: true
            selectByMouse: true
            //wrapMode: TextEdit.Wrap

        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "选择地图"
            onClicked: {

                l_listChoice.visible = true;
                l_listChoice.focus = true;
                l_listChoice.show(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName, "*", 0x001 | 0x2000, 0x00);

                l_listChoice.choicedComponent = textMapName;
            }
        }

        TextField {
            id: textRoleName
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            //selectByKeyboard: true
            selectByMouse: true
            //wrapMode: TextEdit.Wrap

        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "选择角色"
            onClicked: {

                l_listChoice.visible = true;
                l_listChoice.focus = true;
                l_listChoice.show(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, "*", 0x001 | 0x2000, 0x00);

                l_listChoice.choicedComponent = textRoleName;
            }
        }


        RowLayout {
            //Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width

            Label {
                text: qsTr("地图坐标：")
            }

            TextField {
                id: textMapBlockX
                Layout.fillWidth: true
                text: "0"
                placeholderText: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textMapBlockY
                Layout.fillWidth: true
                text: "0"
                placeholderText: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "开始"

            onClicked: {
                if(textMapName.text === "" || textRoleName.text === "")
                    return;

                /*let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "map.json";
                //let cfg = File.read(filePath);
                let cfg = FrameManager.sl_qml_ReadFile(filePath);
                //console.debug("cfg", cfg, filePath);

                if(cfg === "")
                    return false;
                cfg = JSON.parse(cfg);
                //console.debug("cfg", cfg);
                //loader.setSource("./MapEditor_1.qml", {});
                loader.item.openMap(cfg);
                */

                loader.visible = true;
                loader.focus = true;
                loader.item.focus = true;


                //loader.item.openMap(item);
                let tScript = "game.loadmap('%1');game.createhero('%2');game.movehero(%3,%4);game.setinterval(6);game.goon();yield game.msg('欢迎来到鹰歌Maker世界！');".
                    arg(textMapName.text).
                    arg(textRoleName.text).
                    arg(textMapBlockX.text ? textMapBlockX.text : 0).
                    arg(textMapBlockY.text ? textMapBlockY.text : 0)
                    ;
                loader.item.init(tScript);
            }
        }


        RowLayout {
            visible: false

            //Layout.preferredWidth: parent.width
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
        }
    }



    Loader {
        id: loader

        anchors.fill: parent

        visible: false
        focus: true


        source: "./Core/GameScene.qml"
        asynchronous: false


        onLoaded: {
            //item.testFresh();
            console.debug("[mainGameTest]Loader onLoaded");
            item.bTest = true;
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }
        }
    }

    L_List {
        id: l_listChoice

        property var choicedComponent


        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onClicked: {
            visible = false;

            if(item === "..") {
                return;
            }

            choicedComponent.text = item;
        }

        onCanceled: {
            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
            visible = false;
        }

    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainGameTest]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGameTest]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameTest]key:", event, event.key, event.text)
    }



    QtObject {
        id: _private

    }

    //配置
    QtObject {
        id: config
    }





    Component.onCompleted: {

    }
}
