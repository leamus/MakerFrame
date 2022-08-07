
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
 
 
Rectangle {
    id: root


    property alias textArea: scrollTextArea
    property alias timer: timer


    signal s_over();


    function show(msg, pretext="", interval = 100, type = 0) {
        if(timer.running)
            stop(0);

        if(type === 0) {
            scrollTextArea.text = pretext + msg;
            s_over();
        }
        else if(type === 1) {
            scrollTextArea.text = pretext;
            _private.pretext = pretext;
            _private.textVar = msg;
            timer.interval = interval;
            timer.start();
        }
    }

    function stop(type) {
        if(type === 1)
            scrollTextArea.text = _private.pretext + _private.textVar;
        timer.stop();
        _private.textIndex = 0;
        s_over();
    }

 
    color: "#BF6699FF"
    border.color: "white"
    radius: height / 20
    //width: 250
    //height: 50
 

    /*Item
    {
        id: waitItem
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 30
        implicitWidth: 30
        Rectangle
        {
            id: rect
            width: parent.width
            height: parent.height
            color: Qt.rgba(0, 0, 0, 0)
            radius: width / 2
            border.width: width / 6
            visible: false
        }
        ConicalGradient
        {
            width: rect.width
            height: rect.height
            gradient: Gradient
            { GradientStop
                { position: 0.0; color: "#87CEFF" }
                GradientStop
                {
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

    //这个不错，可以自定义横向竖向的滚动条，可以自定义横竖拖动；
    Flickable
    {
        id: flickable
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick

        // place a TextArea inside the flickable, you can edit text
        // but you cannot select because click & move mouse flicks the view.
        TextArea.flickable: TextArea
        {
            id: scrollTextArea

            //height: parent.height

            anchors.fill: parent
            //anchors.left: waitItem.right
            //anchors.leftMargin: 15

            enabled: false

            color:"white"


            //font.bold: true
            font.pointSize: 16
            //verticalAlignment: Text.AlignVCenter
            //horizontalAlignment: Text.AlignHCenter
            text: ""
            readOnly: true
            //cursorPosition: 2

            textFormat: Text.RichText
            //selectByKeyboard: true
            //selectByMouse: true// can select but kills scrolling
            wrapMode: TextArea.Wrap

            // try out links
            onLinkActivated: Qt.openUrlExternally(link)
        }

        ScrollBar.vertical: ScrollBar { }
    }

    Timer
    {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered:
        {
            ++_private.textIndex;
            scrollTextArea.text = _private.pretext + _private.textVar.substr(0, _private.textIndex);
            //scrollTextArea.insert(scrollTextArea.length, _private.textVar[_private.textIndex]);


            if(_private.textIndex == _private.textVar.length)
            {
                //scrollTextArea.text = ""
                root.stop(1);

                s_over();

                return;
            }

            //console.debug(scrollTextArea.text, scrollTextArea.width)
        }
 
    }


    QtObject {
        id: _private

        property string textVar: ""
        property string pretext: ""
        property var textIndex: 0
    }
 
}
