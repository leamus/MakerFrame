import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
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
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9

        Notepad {
            id: textResult

            Layout.fillWidth: true
            Layout.fillHeight: true


            //textArea.color: Global.style.foreground
            //textArea.readOnly: true

            textArea.wrapMode: TextArea.WrapAnywhere
            textArea.horizontalAlignment: TextArea.AlignJustify
            //textArea.verticalAlignment: TextArea.AlignVCenter

            textArea.selectByMouse: false

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }

            text: '生成Windows版本很简单，只需下载并解压 QtEnv_Win_x64_xxx.rar/QtEnv_Win_x86_xxx.rar 和 MakerFrame_GameRuntime_Win_x64_xxx.rar/MakerFrame_GameRuntime_Win_x86_xxx.rar 并解压在一起，将工程命名为Project（可在GameMakerGlobal.qml中修改）修改放在项目根目录即可。<br>注意：1、如果项目中有使用插件，请先将插件自行解压到项目根目录的Plugins目录下。Mac、Linux及相关衍生版本打包类似。<br>2、如果打包为APP，则将主qml改名为main.qml并放在QML文件夹下（可在FrameConfig.qml中修改），框架会自动载入。<br>3、其他高级配置在 GameMakerGlobal.qml 和 QML/LGlobal目录下。'
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
    Keys.onEscapePressed: function(event) {
        console.debug('[PackageWindows]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PackageWindows]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[PackageWindows]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[PackageWindows]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[PackageWindows]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PackageWindows]Component.onDestruction');
    }
}
