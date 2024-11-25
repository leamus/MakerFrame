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


    signal sg_close();



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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>猎魔人(快爆)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.3839.com/a/172193.htm');
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
                    text: qsTr("<a href='#'>BOSS凶猛(Tap)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/721920');
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr("<a href='#'>封魔传记(Tap)</a>")

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/683317');
                    }
                }

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


        source: ''
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                //loader.source = '';
                _private.loadModule('');
            }
        }


        onStatusChanged: {
            console.debug('[mainTutorial]loader:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                setSource('');

                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
                showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                clearComponentCache();
                trimComponentCache();
            }
        }

        onLoaded: {
            console.debug("[mainTutorial]loader onLoaded");

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init();

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
                showBusyIndicator(false);
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
            //loader.visible = true;
            //loader.focus = true;
            //loader.forceActiveFocus();

            //loader.source = url;
            loader.setSource(url);

            return true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainTutorial]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainTutorial]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainTutorial]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainTutorial]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[mainTutorial]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainTutorial]Component.onDestruction");
    }
}
