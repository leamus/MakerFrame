﻿import QtQuick 2.14
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
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent

        spacing: 0


        Text {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 22
            font.bold: true
            text: qsTr("教  程")

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "关于"
            onButtonClicked: {
                loader.source = 'mainAbout.qml';
                loader.visible = true;
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "简易教程"
            onButtonClicked: {
                loader.source = 'mainEasyTutorial.qml';
                loader.visible = true;
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "官方教程"
            onButtonClicked: {
                Qt.openUrlExternally('https://gitee.com/leamus/MakerFrame/blob/main/Tutorials/1/');
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "侠道仙缘（引擎上架游戏）"
            onButtonClicked: {
                Qt.openUrlExternally('https://www.taptap.cn/app/261814');
            }
        }
    }


    Loader {
        id: loader

        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            //item.testFresh();
            console.debug("[mainTutorial]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.forceActiveFocus();
            }
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainTutorial]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainTutorial]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainTutorial]key:", event, event.key, event.text)
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
