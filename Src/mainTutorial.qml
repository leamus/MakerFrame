import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal s_close();



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }


    ColumnLayout {
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent

        spacing: 0


        Label {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 22
            font.bold: true
            text: qsTr("教　程")

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "关　于"
            onClicked: {
                _private.loadModule('mainAbout.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "简易教程"
            onClicked: {
                _private.loadModule('mainEasyTutorial.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "官方教程"
            onClicked: {
                Qt.openUrlExternally('https://gitee.com/leamus/MakerFrame/blob/main/Tutorials');
            }
        }



        Label {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            //Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 12
            font.bold: true
            text: qsTr("实验性功能")

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            //Layout.fillHeight: true

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true


                text: "简易画板"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("PaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                    else {
                        _private.loadModule("PaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true


                text: "简易画板2"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("NanoPaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                    else {
                        _private.loadModule("NanoPaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.fillHeight: false
            //Layout.preferredHeight: 1
            Layout.minimumHeight: 0


            RowLayout {
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: false
                //Layout.preferredHeight: 1
                Layout.minimumHeight: 0

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("上架游戏：")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>侠道仙缘(Tap)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/261814');
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>剑心之誓(快爆)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.3839.com/a/164540.htm');
                    }
                }

            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: false
                //Layout.preferredHeight: 1
                Layout.minimumHeight: 0

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>英语杀(Tap)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/180050');
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>英语杀(Steam)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://store.steampowered.com/app/934710');
                    }
                }
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



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

        function loadModule(url) {
            loader.source = url;
            loader.visible = true;
            loader.forceActiveFocus();
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



    Component.onCompleted: {
        console.debug("[mainTutorial]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainTutorial]Component.onDestruction");
    }
}
