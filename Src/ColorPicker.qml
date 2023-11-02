import QtQuick 2.14
//import QtQuick.Dialogs 1.3
import Qt.labs.platform 1.1


Rectangle {
    id: colorPicker


    property alias text: label.text
    property alias textColor: label.color
    property alias font: label.font
    property alias selectedColor: currentColor.color
    //property var colorDialog: null

    signal colorPicked(color clr)


    //width: 64
    //height: 60


    Rectangle {
        id: currentColor

        /*anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 12
        height: 30
        */
        anchors.fill: parent


        color: "lightgray"
        border.width: 2
        border.color: "darkgray"
    }

    Text {
        id: label
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 14
        color: "blue"
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(colorDialog == null){
                //colorDialog = Qt.createQmlObject("import QtQuick 2.14;Qt.labs.platform 1.1; ColorDialog{}",
                //                                 colorPicker, "dynamic_color_dialog")
                //colorDialog.accepted.connect(colorPicker.onColorDialogAccepted)
                //colorDialog.rejected.connect(colorPicker.onColorDialogRejected)
                //colorDialog.open();
            }
            colorDialog.open();
        }
    }

    ColorDialog {
        id: colorDialog

        visible: false

        onAccepted: {
            selectedColor = colorDialog.color
            colorPicked(colorDialog.color)
        }
        onRejected: {
            colorPicked(color)
        }
    }

}
