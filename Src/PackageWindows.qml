import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


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
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9

        Notepad {
            id: textResult

            Layout.fillWidth: true
            Layout.fillHeight: true


            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
            //textArea.color: Global.style.foreground
            //textArea.readOnly: true
            textArea.selectByMouse: false

            text: '生成Windows版本很简单，只需下载并解压 QtEnv_Win_x64_xxx.rar/QtEnv_Win_x86_xxx.rar 和 MakerFrame_GameRuntime_Win_x64_xxx.rar/MakerFrame_GameRuntime_Win_x86_xxx.rar 并解压在一起，将工程命名为Project放在其根目录即可'
        }

        Button {
            Layout.alignment: Qt.AlignCenter

            text: '关　闭'
            onClicked: {
                sg_close();
            }
        }
    }



    QObject {
        id: _private

    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug('[PackageWindows]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug('[PackageWindows]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[PackageWindows]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[PackageWindows]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[PackageWindows]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PackageWindows]Component.onDestruction');
    }
}
