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


    function $load(...params) {
        notepad.showHtmlFile(params[0], (c)=>$CommonLibJS.convertToHTML(c));

        console.debug('[mainReader]$load:', params, vExtraData);
    }


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: $Global.style.backgroundColor


    Mask {
        anchors.fill: parent
        //opacity: 0
        color: $Global.style.backgroundColor
        //radius: 9
    }

    ColumnLayout {
        width: parent.width * 0.96
        height: parent.height * 0.96
        anchors.centerIn: parent

        Notepad {
            id: notepad

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            //Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            text: ''

            textArea.color: 'white'
            //textArea.color: $Global.style.foreground
            //textArea.enabled: false
            //textArea.readOnly: true

            textArea.wrapMode: TextArea.WrapAnywhere
            textArea.horizontalAlignment: TextArea.AlignJustify
            //textArea.verticalAlignment: TextArea.AlignVCenter

            //textArea.selectByMouse: false

            textArea.font {
                pointSize: 15
            }

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: '#80000000'
                //color: 'transparent'
                //color: $Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? $Global.style.accent : $Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }

        Button {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50

            text: '返　回'
            onClicked: {
                sg_close();
            }
            /*onPressAndHold: {
                notepad.textArea.selectByMouse = !notepad.textArea.selectByMouse;
            }
            */
        }
    }


    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }
    }


    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainReader]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainReader]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainReader]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainReader]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainReader]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainReader]Component.onDestruction');
    }
}
