import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


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
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
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
            text: qsTr('教　程')

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }


        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 2
        }


        /*Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '关　于'
            onClicked: {
                loader.load('mainAbout.qml');
            }
        }
        */

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '引擎简易教程'
            onClicked: {
                loader.load('mainEasyGameMakerTutorial.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: 'JavaScript简易教程'
            onClicked: {
                loader.load('mainEasyJavaScriptTutorial.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '高级玩法教程'
            onClicked: {
                loader.load('mainAdvancedTutorial.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '官方在线教程'
            onClicked: {
                Qt.openUrlExternally('https://gitee.com/leamus/MakerFrame/blob/main/Tutorials');
            }
        }


        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 1
        }


        Label {
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            //Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 12
            font.bold: true
            text: qsTr('实验性功能')

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        RowLayout {
            Layout.fillWidth: false
            Layout.preferredWidth: parent.width * 0.69
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            //Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: false

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true


                text: '简易画板'
                onClicked: {
                    if($Platform.compileType === 'debug') {
                        loader.load($GlobalJS.toURL($Frame.sl_configValue('PluginPath', 'Plugins', 0).trim() + '/Qt/$QNanoPainter/QML/PaintView.qml'));
                        //userMainProject.source = 'mainMapEditor.qml';
                    }
                    else {
                        loader.load($GlobalJS.toURL($Frame.sl_configValue('PluginPath', 'Plugins', 0).trim() + '/Qt/$QNanoPainter/QML/PaintView.qml'));
                        //userMainProject.source = 'mainMapEditor.qml';
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


                text: '简易画板2'
                onClicked: {
                    if($Platform.compileType === 'debug') {
                        loader.load($GlobalJS.toURL($Frame.sl_configValue('PluginPath', 'Plugins', 0).trim() + '/Qt/$QNanoPainter/QML/NanoPaintView.qml'));
                        //userMainProject.source = 'mainMapEditor.qml';
                    }
                    else {
                        loader.load($GlobalJS.toURL($Frame.sl_configValue('PluginPath', 'Plugins', 0).trim() + '/Qt/$QNanoPainter/QML/NanoPaintView.qml'));
                        //userMainProject.source = 'mainMapEditor.qml';
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 1
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.fillWidth: true
            //Layout.preferredHeight: 0
            Layout.minimumHeight: 0
            //Layout.fillHeight: true

            visible: Qt.platform.os === 'android'


            Item {
                Layout.fillWidth: true
            }

            Label {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.preferredWidth: implicitWidth
                //Layout.maximumWidth: parent.width
                //Layout.fillWidth: true
                //Layout.fillHeight: true


                font.pointSize: 12
                text: qsTr('广告测试：')

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
            }

            Item {
                Layout.fillWidth: true

                visible: Qt.platform.os === 'android' && $Platform.Tap
            }

            Label {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.preferredWidth: implicitWidth
                //Layout.maximumWidth: parent.width
                //Layout.fillWidth: true
                //Layout.fillHeight: true

                visible: Qt.platform.os === 'android' && $Platform.Tap


                font.pointSize: 12
                text: qsTr('<a href="#">Tap广告</a>')

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

                onLinkActivated: {
                    $CommonLibJS.asyncScript([function*() {
                        try {
                            const res = yield $Platform.Tap.ad({
                                Callback: function(adData, customData) {
                                    console.debug('[menu]Tap AD Callback:', JSON.stringify(adData), customData);

                                    $dialog.show({
                                        Msg: '仅供测试',
                                        Buttons: Dialog.Ok,
                                        OnAccepted: function() {
                                            //root.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            //root.forceActiveFocus();
                                        },
                                    });
                                },
                                CustomData: 666,
                                Info: true,
                                Type: 1,
                                Flags: 0b111,
                                ErrorCallback: function(e) {
                                    console.warn(e, JSON.stringify(e.$params)); //code, msg, data
                                },
                            });
                            console.debug('[menu]Tap AD res:', JSON.stringify(res));
                        }
                        catch(e) {
                            console.warn('[!menu]Tap AD Error:', e, JSON.stringify(e.$params));
                        }
                    }, 'onLinkActivated: Tap']);
                }
            }

            Item {
                Layout.fillWidth: true

                visible: Qt.platform.os === 'android' && $Platform.CSJ
            }

            Label {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.preferredWidth: implicitWidth
                //Layout.maximumWidth: parent.width
                //Layout.fillWidth: true
                //Layout.fillHeight: true

                visible: Qt.platform.os === 'android' && $Platform.CSJ


                font.pointSize: 12
                text: qsTr('<a href="#">穿山甲广告</a>')

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

                onLinkActivated: {
                    $CommonLibJS.asyncScript([function*() {
                        try {
                            const res = yield $Platform.CSJ.ad({
                                Callback: function(adData, customData) {
                                    console.debug('[menu]CSJ AD Callback:', JSON.stringify(adData), customData);

                                    $dialog.show({
                                        Msg: '仅供测试',
                                        Buttons: Dialog.Ok,
                                        OnAccepted: function() {
                                            //root.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            //root.forceActiveFocus();
                                        },
                                    });
                                },
                                Data: 999,
                                Info: true,
                                Type: 1,
                                Flags: 0b111,
                                ErrorCallback: function(e) {
                                    console.warn(e, JSON.stringify(e.$params)); //code, msg, data
                                },
                            });
                            console.debug('[menu]CSJ AD res:', JSON.stringify(res));
                        }
                        catch(e) {
                            console.warn('[!menu]CSJ AD Error:', e, JSON.stringify(e.$params));
                        }
                    }, 'onLinkActivated: CSJ']);
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Item {
            //Layout.fillHeight: true
            Layout.preferredHeight: 20

            visible: Qt.platform.os === 'android'
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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('上架游戏：')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">侠道仙缘(Tap)</a>')

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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">BOSS凶猛(Tap)</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/721920');
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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">剑心之誓(快爆)</a>')

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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">猎魔人(快爆)</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.3839.com/a/172193.htm');
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">封魔传记(Tap)</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://www.taptap.cn/app/683317');
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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">英语杀(Tap)</a>')

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


                    font.pointSize: _private.config.nTextFontSize
                    text: qsTr('<a href="#">英语杀(Steam)</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally('https://store.steampowered.com/app/934710');
                    }
                }
            }
        }

    }



    L_Loader {
        id: loader


        visible: false
        focus: true
        clip: true

        anchors.fill: parent

        //source: ''
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loader.close();
            }
        }


        onStatusChanged: {
            console.debug('[mainTutorial]loader onStatusChanged:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                $dialog.show({
                    Msg: '%1 载入错误，请确保相关模块、插件安装正确'.arg(source),
                    Buttons: Dialog.Ok,
                    OnAccepted: function() {
                        //root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //root.forceActiveFocus();
                    },
                });

                //close();
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
            }
        }

        onLoaded: {
            console.debug('[mainTutorial]loader onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                //if(item.$load)
                //    item.$load();

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
            }
        }
    }



    QtObject {
        id: _private


        readonly property QtObject config: QtObject { //配置
            //id: _config

            //字体大小
            property int nTextFontSize: 11
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainTutorial]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainTutorial]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainTutorial]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainTutorial]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainTutorial]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainTutorial]Component.onDestruction');
    }
}
