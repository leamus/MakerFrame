import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
//import QtQuick.Controls.Styles 1.4
//import Qt.labs.platform 1.1


import cn.Leamus.MakerFrame 1.0



Rectangle {
    id: root


    signal sg_close();


    anchors.fill: parent

    visible: true
    focus: true
    clip: true



    L_PaintedItem {
        id: painter

        //anchors.top: options.bottom
        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height
    }


    Rectangle {
        id: options

        anchors.fill: row

        color: 'lightgray';

        /*Component{
            id: btnStyle;
            ButtonStyle {
                background: Rectangle {
                    implicitWidth: 70;
                    implicitHeight: 28;
                    border.width: control.hovered ? 2 : 1;
                    border.color: '#888';
                    radius: 4;
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? '#ccc' : '#eee' }
                        GradientStop { position: 1 ; color: control.pressed ? '#aaa' : '#ccc' }
                    }
                }

                label: Text {
                    text: control.text;
                    font.pointSize: 12;
                    color: 'blue';
                    horizontalAlignment: Text.AlignHCenter;
                    verticalAlignment: Text.AlignVCenter;
                }
            }
        }*/
    }

    RowLayout {
        id: row

        width: parent.width
        height: 70;

        ColumnLayout {
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height

            ColorPicker {
                id: background;

                Layout.preferredWidth: 60
                Layout.preferredHeight: 30
                //Layout.fillHeight: true

                //anchors.verticalCenter: parent.verticalCenter;

                //text: '背景';
                selectedColor: 'white';
                onColorPicked: painter.fillColor = clr;
            }
            ColorPicker {
                id: foreground;

                Layout.preferredWidth: 60
                Layout.preferredHeight: 30
                //Layout.fillHeight: true

                //text: '前景';
                selectedColor: 'black';
                onColorPicked: painter.penColor = clr;
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {

                Text {
                    id: penThickLabel

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    text: '画笔:%1px'.arg(thickness.value);
                    horizontalAlignment: Text.AlignHCenter

                    font.pointSize: 16;
                    color: 'steelblue';
                }

                /*Text {
                    id: minLabel

                    Layout.alignment: Qt.AlignLeft

                    text: thickness.from;
                    font.pointSize: 12;
                }

                Text {
                    id: maxLabel

                    Layout.alignment: Qt.AlignRight

                    text: thickness.to;
                    font.pointSize: 12;
                }*/

            }

            Slider {
                id: thickness;

                Layout.fillWidth: true
                Layout.preferredHeight: 24

                from: 1;
                to: 100;
                stepSize: 1.0;
                value: 1;
                onValueChanged: if(painter != null)painter.penWidth = value;
            }
        }

        ColumnLayout {
            Layout.preferredWidth: 60
            Layout.fillHeight: true

            Button {
                id: clear;

                Layout.preferredWidth: 60
                Layout.preferredHeight: 28

                text: '清除';
                //style: btnStyle;
                onClicked: painter.clear();
            }

            Button {
                id: undo;

                Layout.preferredWidth: 60
                Layout.preferredHeight: 28

                text: '撤销';
                //style: btnStyle;
                onClicked: painter.undo();

                onPressAndHold: {
                    dialogScript.open();
                }
            }
        }
    }




    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: '执行脚本'
        width: parent.width * 0.9
        height: Math.max(200, Math.min(parent.height, textScript.implicitHeight + 160))
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        visible: false

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: '输入脚本命令'

            //textFormat: Text.RichText
            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            //gameMap.focus = true;
            root.forceActiveFocus();
            //GlobalJS.Eval(textScript.text);
            console.debug(eval(textScript.text));
            //GlobalJS.runScript(_private.scriptQueue, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            root.forceActiveFocus();
            //console.log('Cancel clicked');
        }
    }




    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug('[PaintView]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug('[PaintView]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[PaintView]Keys.onPressed:', event, event.key, event.text)
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

    }

}
