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
            text: qsTr("插　件")

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "管　理"
            onClicked: {
                _private.loadModule('PluginsManager.qml');
            }
        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50

            text: "下　载"
            onClicked: {
                _private.loadModule('PluginsDownload.qml');
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
            console.debug('[mainPlugins]loader.status：', status);

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
            if(status !== Loader.Loading) {
                clearComponentCache();
                trimComponentCache();
            }
        }

        onLoaded: {
            console.debug("[mainPlugins]loader onLoaded");

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
            if(loader.status === Loader.Loading)
                showBusyIndicator(true);

            return true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainPlugins]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainPlugins]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainPlugins]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainPlugins]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[mainPlugins]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainPlugins]Component.onDestruction");
    }
}
