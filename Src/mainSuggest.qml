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
    objectName: 'MainSuggest'


    signal sg_close();



    function $load(...params) {
        _private.refresh();

        //notepad.forceActiveFocus();
        //labelError.text = '';
    }



    property string suggestUrl: 'http://makerframe.leamus.cn/api/v1/suggest/suggest'
    property string captchaUrl: 'http://makerframe.leamus.cn/api/v1/suggest/getCaptcha'


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
            placeholderText: '请输入内容'

            textArea.color: 'white'
            //textArea.color: Global.style.foreground
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

                placeholderText: '验证码'
                //font.pixelSize: dpH(22)
                font.pointSize: 16
                selectByMouse: true

                onAccepted: {
                    buttonSubmit.clicked();
                }
            }

            Image {
                id: imageCaptcha

                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        _private.refresh();

                        textCaptcha.forceActiveFocus();
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Button {
                id: buttonSubmit
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: '提　交'
                onClicked: {
                    const suggestText = notepad.toPlainText().trim();
                    const captchaText = textCaptcha.text.trim();
                    if(suggestText.length === 0 || captchaText.length === 0) {
                        $dialog.show({
                            Msg: '有未填的必填项',
                            Buttons: Dialog.Ok,
                            OnAccepted: function() {
                            },
                            OnRejected: ()=>{
                            },
                        });

                        return;
                    }

                    buttonSubmit.enabled = false;

                    //访问应用信息
                    $CommonLibJS.request({
                        Url: suggestUrl,
                        Method: 'POST',
                        Headers: {
                            //Authorization: $globalData.$userData.token,
                        },
                        Data: {
                            suggest: suggestText,
                            captcha: captchaText, cid: _private.strKey,
                            userID: $globalData.$userData.info.id, account: $globalData.$userData.info.account,
                        },
                        Gzip: [1, 1024],
                    }).$$then((xhr)=>{
                        buttonSubmit.enabled = true;
                        infoCallback(xhr);
                    }).$$catch((xhr)=>{
                        buttonSubmit.enabled = true;
                        console.warn('[!Suggest]', xhr);
                    });

                    function infoCallback(xhr) {
                        let data;
                        try {
                            data = JSON.parse(xhr.responseText);
                        }
                        catch(e) {
                            //labelError.text = xhr.responseText + `(${xhr.status})`;
                            console.warn('[!Suggest]', xhr.responseText + `(${xhr.status})`);
                        }

                        if(xhr.status === 200 && data.code === 0) {
                            console.debug('[Suggest]', JSON.stringify(data));

                            $dialog.show({
                                Msg: '感谢建议',
                                Buttons: Dialog.Ok,
                                OnAccepted: function() {
                                    sg_close();
                                },
                                OnRejected: ()=>{
                                    sg_close();
                                },
                            });
                        }
                        else {
                            console.warn('[!Suggest]', JSON.stringify(data));

                            _private.refresh();
                            //labelError.text = data.msg + `(${data.code})`;
                            //console.warn('[!Suggest]', data.msg + `(${data.code})`);
                            $dialog.show({
                                Msg: '错误：' + data.msg + `(${data.code})`,
                                Buttons: Dialog.Ok,
                                OnAccepted: function() {
                                },
                                OnRejected: ()=>{
                                },
                            });
                        }
                    }
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
            }
        }
    }



    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


        //验证码密钥
        property string strKey: ''


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
                    console.warn('[!Suggest]', JSON.stringify(data));


                    //labelError.text = data.msg + `(${data.code})`;
                }
            }
        }

    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainSuggest]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainSuggest]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainSuggest]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainSuggest]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        //notepad.text = $CommonLibJS.convertToHTML(t);

        console.debug('[mainSuggest]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainSuggest]Component.onDestruction');
    }
}
