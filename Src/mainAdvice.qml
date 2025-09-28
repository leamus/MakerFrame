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
    objectName: 'mainAdvice'


    signal sg_close();



    function $load(...params) {
        refresh();

        //notepad.forceActiveFocus();
        //labelError.text = '';
    }

    function refresh() {
        //访问验证码
        $CommonLibJS.request({
            Url: captchaUrl,
            Method: 'GET',
            //Data: {},
            //Gzip: [1, 1024],
            //Headers: {},
        }).$$then((xhr)=>{
            infoCallback(xhr);
        }).$$catch((xhr)=>{
        });

        function infoCallback(xhr) {
            let data;
            try {
                data = JSON.parse(xhr.responseText);
            }
            catch(e) {
                //labelError.text = xhr.responseText + `(${xhr.status})`;
            }

            if(xhr.status === 200 && data.code === 0) {
                _private.strKey = data.data.key;
                imageCaptcha.source = 'data:image/png;base64,' + data.data.img;
            }
            else {
                console.warn('[!Login]', JSON.stringify(data));


                //labelError.text = data.msg + `(${data.code})`;
            }
        }
    }



    property string loginUrl: 'http://makerframe.leamus.cn/api/v1/login/login'
    property string captchaUrl: 'http://makerframe.leamus.cn/api/v1/login/getCaptcha'


    //width: 600
    //height: 800
    anchors.fill: parent

    //focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
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
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            focus: true

            text: ''

            textArea.color: 'white'
            //textArea.color: Global.style.foreground
            //textArea.enabled: false
            //textArea.readOnly: true

            //textArea.selectByMouse: false

            textArea.font {
                pointSize: 15
            }

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: '#80000000'
                //color: 'transparent'
                //color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Label {
                text: '验证码：'
            }

            TextField {
                id: textCaptcha

                Layout.fillWidth: true
            }

            Image {
                id: imageCaptcha

                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        refresh();

                        textCaptcha.forceActiveFocus();
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Button {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '提　交'
                onClicked: {
                    sg_close();
                }
            }

            Button {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '返　回'
                onClicked: {
                    sg_close();
                }
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

        //验证码密钥
        property string strKey: ''
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainAdvice]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainAdvice]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainAdvice]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainAdvice]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        //notepad.text = $CommonLibJS.convertToHTML(t);

        console.debug('[mainAdvice]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainAdvice]Component.onDestruction');
    }
}
