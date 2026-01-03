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
            text: qsTr('打　包')

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '打包Windows'
            onClicked: {
                /*$dialog.show({
                    Msg: '有需要时再做~',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        //root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //root.forceActiveFocus();
                    },
                });

                return;
                */

                _private.loadModule('PackageWindows.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.9
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: '打包Android'
            onClicked: {
                _private.loadModule('PackageAndroid.qml');
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
            console.debug('[mainPackage]loader:', source, status);

            if(status === Loader.Ready) {
                //$showBusyIndicator(false);
            }
            else if(status === Loader.Error) {
                setSource('');

                $showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
                $showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                $clearComponentCache();
                $trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[mainPackage]loader onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                ///item.focus = true;
                //if(item.forceActiveFocus)
                //    item.forceActiveFocus();

                //if(item.$load)
                //    item.$load();

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
                $showBusyIndicator(false);
            }
        }
    }



    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


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
    Keys.onEscapePressed: function(event) {
        console.debug('[mainPackage]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainPackage]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainPackage]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainPackage]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainPackage]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainPackage]Component.onDestruction');
    }
}
