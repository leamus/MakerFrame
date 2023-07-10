import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    id: joystick

    //手柄偏移度（横向纵向都是-1~+1）
    property point pointInput
    //property double inputX
    //property double inputY
    property bool pressed: false   //是否按下
    property alias fingerOutOfBounds: multiPointTouchArea.fingerOutOfBounds


    implicitWidth: 20 * Screen.pixelDensity
    implicitHeight: 20 * Screen.pixelDensity


    //外圆
    Rectangle {
        anchors.fill: parent
        border.width: 2 * Screen.pixelDensity
        border.color: "#1e1b18"
        radius: width / 2
    }

    //内圆
    Rectangle {
        id: handle

        width: 6 * Screen.pixelDensity
        height: 6 * Screen.pixelDensity

        anchors.centerIn: joystick
        anchors.onHorizontalCenterOffsetChanged:
            joystick.pointInput.x = anchors.horizontalCenterOffset / (joystick.width / 2 - handle.width / 2)
        anchors.onVerticalCenterOffsetChanged:
            joystick.pointInput.y = anchors.verticalCenterOffset / (joystick.height / 2 - handle.height / 2)

        radius: width / 2
        color: "#1e1b18"
    }

    //返回动画
    NumberAnimation {
        id: returnAnimation
        target: handle.anchors
        properties: "horizontalCenterOffset,verticalCenterOffset"
        to: 0
        duration: 200
        easing.type: Easing.OutSine
    }

    MultiPointTouchArea {
        id: multiPointTouchArea

        touchPoints : [
            TouchPoint { id: mouseArea }
        ]

        anchors.fill: parent
        property point pointStart   //按下的坐标
        property bool fingerOutOfBounds:    //内圆是否超出了边界（注意不是手指超出了外面）
            (mouseArea.x - pointStart.x) * (mouseArea.x - pointStart.x) + (mouseArea.y-pointStart.y) * (mouseArea.y-pointStart.y) < (joystick.width / 2 - handle.width / 2) * (joystick.width / 2 - handle.width / 2)

        onPressed: {
            //保存按下的坐标
            pointStart.x = mouseArea.startX
            pointStart.y = mouseArea.startY

            //???
            //joystick.anchors.horizontalCenterOffset = mouseArea.x - width / 2
            //joystick.anchors.verticalCenterOffset = mouseArea.y - height / 2
            handle.anchors.horizontalCenterOffset = mouseArea.x - width / 2
            handle.anchors.verticalCenterOffset = mouseArea.y - height / 2

            joystick.pressed = true;
        }

        onUpdated: {
            if (fingerOutOfBounds) {
                handle.anchors.horizontalCenterOffset = mouseArea.x - pointStart.x
                handle.anchors.verticalCenterOffset = mouseArea.y - pointStart.y
            }
            else {
                var angle = Math.atan2(mouseArea.y - pointStart.y, mouseArea.x - pointStart.x)
                handle.anchors.horizontalCenterOffset = Math.cos(angle) * (joystick.width / 2 - handle.width / 2)
                handle.anchors.verticalCenterOffset = Math.sin(angle) * (joystick.width / 2 - handle.width / 2)
            }
        }

        onReleased: {
            returnAnimation.start()

            joystick.pressed = false;
        }
    }
}
