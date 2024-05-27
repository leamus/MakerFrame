
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
import QtQuick.Window 2.14


import _Global 1.0


 
Notepad {
    id: root



    //signal s_mouseReleased();
    //显示完毕
    signal s_over();



    //type为自适应宽高（0b1为宽，0b10为高），否则固定；
    //keeptime为文字显示完毕后再延迟多长时间（才结束）；
    function show(msg, pretext='', interval=60, keeptime=0, type=0b11) {

        if(timer.running) {
            //stop();

            timer.stop();
            timer.nStatus = -1;
            _private.textIndex = 0;
        }


        if(!pretext)
            pretext = '';

        _private.nKeepTime = (keeptime > 0 ? keeptime : 0);


        //如果是自适应宽高
        root.width = nMaxWidth;
        textArea.text = pretext + msg;
        if(type & 0b1) {
            if(textArea.implicitWidth < nMaxWidth)
                root.width = textArea.implicitWidth;
            else
                root.width = nMaxWidth;
        }
        else
            root.width = nMaxWidth;

        if(type & 0b10) {
            if(textArea.implicitHeight < nMaxHeight)
                root.height = textArea.implicitHeight;
            else
                root.height = nMaxHeight;
        }
        else
            root.height = nMaxHeight;



        //如果按字显示
        if(interval) {
            textArea.text = pretext;
            _private.pretext = pretext;
            _private.textVar = msg;

            timer.nStatus = 1;
            timer.interval = interval;
            timer.start();
        }
        //如果直接显示
        else {
            textArea.text = pretext + msg;

            if(keeptime > 0) {
                timer.nStatus = 2;
                timer.interval = keeptime;
                timer.start();
            }
            else {
                root.stop();
            }
        }


        visible = true;

    }

    //停止显示；
    //type：1是全部显示出来，其他值为停止；
    function stop(type=0) {
        if(type === 1)
            textArea.text = _private.pretext + _private.textVar;

        timer.stop();
        timer.nStatus = -1;
        _private.textIndex = 0;

        s_over();
    }



    //property alias notepad: root
    //property alias textArea: notepad.textArea
    //property alias flickable: notepad.flickable
    property alias timer: timer


    property int nMaxWidth: Screen.desktopAvailableWidth * 0.9
    property int nMaxHeight: Screen.desktopAvailableHeight * 0.9


    width: parent.width
    height: parent.height
    //width: 250
    //height: 50

    //color: 'transparent'
    color: "#BF6699FF"
    border {
        width: 1
        color: "white"
    }
    radius: height / 20


    font.pointSize: 16


    //textArea.enabled: false
    textArea.readOnly: true
    textArea.color: 'white'
    textArea.selectByKeyboard: false
    textArea.selectByMouse: false
    textArea.wrapMode: TextArea.WrapAnywhere


    /*
    textArea.implicitHeight: textArea.contentHeight + 12
    //textArea.padding : 6
    textArea.leftPadding : 6
    textArea.rightPadding : 6
    textArea.topPadding : 6
    textArea.bottomPadding: 6
    */

    textArea.background: Rectangle {
        color: 'transparent'
        //color: Global.style.backgroundColor
        //border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
        //border.width: parent.parent.textArea.activeFocus ? 2 : 1
    }

    /*textArea.onReleased: {
        root.s_mouseReleased();
    }*/



    /*Item {
        id: waitItem
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 30
        implicitWidth: 30
        Rectangle {
            id: rect
            width: parent.width
            height: parent.height
            color: Qt.rgba(0, 0, 0, 0)
            radius: width / 2
            border.width: width / 6
            visible: false
        }
        ConicalGradient {
            width: rect.width
            height: rect.height
            gradient: Gradient {
                GradientStop {
                    position: 0.0; color: "#87CEFF"
                }
                GradientStop {
                    position: 1.0;
                    color: "blue"
                }
            }
            source: rect
            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: rect.border.width
                height: width
                radius: width / 2
                color: "blue"
            }
            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 800
                loops: Animation.Infinite
            }
        }
    }*/



    Timer {
        id: timer

        property int nStatus: -1

        interval: 60
        running: false
        repeat: true

        onTriggered: {
            //console.debug(_private.textVar.substr(0, _private.textIndex), textArea.width, _private.textVar[_private.textIndex])

            if(nStatus === 1) {

                //如果有标签 <。。。>
                if(_private.textVar[_private.textIndex] === '<') {
                    _private.textIndex = _private.textVar.indexOf('>', _private.textIndex);
                    if(_private.textIndex === -1)   //如果没有搜到,则直接到最后
                        _private.textIndex = _private.textVar.length - 1;
                }
                //如果有转义字符
                else if(_private.textVar[_private.textIndex] === '&') {
                    let tIndex = _private.textVar.indexOf(';', _private.textIndex);
                    if(tIndex !== -1)   //如果搜到
                        _private.textIndex = tIndex;
                }
                ++_private.textIndex;


                textArea.text = _private.pretext + _private.textVar.substr(0, _private.textIndex);
                toEnd();
                //textArea.insert(textArea.length, _private.textVar[_private.textIndex]);


                //判断是否结束
                if(_private.textIndex >= _private.textVar.length) {
                    //textArea.text = ""

                    timer.nStatus = 2;
                    if(_private.nKeepTime > 0)
                        timer.interval = _private.nKeepTime;
                    else {
                        root.stop();
                        return;
                    }
                }

                //timer.start();
            }
            else if(nStatus === 2) {
                root.stop();
            }

            //console.debug(textArea.text, textArea.width)
        }
 
    }



    QtObject {
        id: _private

        property string textVar: ""
        property string pretext: ""
        property var textIndex: 0

        property int nKeepTime: -1
    }
 
}
