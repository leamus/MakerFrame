
import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


Rectangle {
    id: root


    signal s_pressed();
    signal s_released();


    width: 6 * Screen.pixelDensity
    height: 6 * Screen.pixelDensity

    opacity: 0.6
    radius: width / 2
    color: "white"
    border.color: "black"



    MultiPointTouchArea {
        anchors.fill: parent
        /*onClicked: {
        }
        */
        onPressed: {
            s_pressed();
        }
        onReleased: {
            s_released();
        }
    }
}
