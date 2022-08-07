import QtQuick 2.14

/*

  鹰：由于Sprite的source和 frameX、 frameY 修改无效，所以只能用Component进行创建，使用refresh进行删除重建。
    问题：1、无法初始化时直接显示某个Sprite
      2、无法显示某个Sprite的帧
*/

Item {
    id: root

    property string spriteSrc: ""   //精灵图片
    property size sizeFrame: Qt.size(0,0)     //一帧的宽高
    property int nFrameCount: 3 //一个方向有几张图片
    property var arrFrameDirectionIndex: [[0,0],[0,1],[0,2],[0,3]]  //上右下左 的 行、列 偏移
    property int interval: 100  //帧切换速度


    //x1、y1为 场景中 人物的 有效占位（占地图） 起始点 偏移（相对于x，y），x2、y2为 有效占位 终止点 偏移，width1、height1为有效占位宽高
    property alias x1: rectShadow.x
    property alias y1: rectShadow.y
    readonly property int x2: x1 + width1 - 1
    readonly property int y2: y1 + height1 - 1
    property alias width1: rectShadow.width
    property alias height1: rectShadow.height

    property alias rectShadow: rectShadow   //真实占用大小（影子）

    property string name: ""


    property int direction: -1 //方向
    property int stopDirection: direction === -1 ? stopDirection : direction    //停止方向
    property real offsetMove: 0.3 //移动像素


    property var sprite: undefined

    property alias test: mouseArea.enabled



    //刷新重建
    function refresh() {
        unload();

        sprite = compSpriteSequence.createObject(root);
    }

    //删除
    function unload() {
        if(sprite) {
            sprite.destroy();
            sprite = undefined;
        }
    }

    //开始播放动画（和方向有关）
    function start() {
        if(sprite === undefined)
            return;

        switch(root.direction) {
        case Qt.Key_Up:
            sprite.jumpTo("Up");
            break;
        case Qt.Key_Right:
            sprite.jumpTo("Right");
            break;
        case Qt.Key_Left:
            sprite.jumpTo("Left");
            break;
        case Qt.Key_Down:
            sprite.jumpTo("Down");
            break;
        }
        sprite.running = true;
        //console.debug("[Role]start", sprite, sprite.state, sprite.currentSprite, direction)
    }

    //停止动画
    function stop() {
        if(sprite === undefined)
            return;
        sprite.running = false;
    }

    //静态换方向
    function changeDirection(d) {
        if(d !== undefined) {
            //sprite.jumpTo(d);
            ////root.direction = d;

            switch(d) {
            case 0:
                sprite.jumpTo("Up");
                //sprite.goalSprite = "Up";
                //sprite.currentSprite = "Up";
                break;
            case 1:
                sprite.jumpTo("Right");
                //sprite.goalSprite = "Right";
                //sprite.currentSprite = "Right";
                break;
            case 2:
                sprite.jumpTo("Down");
                //sprite.goalSprite = "Down";
                //sprite.currentSprite = "Down";
                break;
            case 3:
                sprite.jumpTo("Left");
                //sprite.goalSprite = "Left";
                //sprite.currentSprite = "Left";
                break;
            }

            start();
            stop();
        }
    }


    focus: true
    width: 0
    height: 0

    //implicitWidth: width
    //implicitHeight: height



    Component {
        id: compSpriteSequence

        //sprite.jumpTo("Left");    //立即改变为目标帧
        //sprite.goalSprite = "帧名"; //a、忽略权重（0也可以走）；b、当前帧要播放完毕；c、以最短的路径跳到目标帧（如果没有到达路径则无法跳转）
        SpriteSequence {
            //id: sprite

            width: root.width; height: root.height     //一个帧的大小，会缩放
            anchors.horizontalCenter: parent.horizontalCenter
            interpolate: false   //true（默认）：在帧之间插值，使帧切换更平滑
            goalSprite: ""
            running: false

            Sprite {
                name: "Up"      //帧名，用来跳转
                source: spriteSrc   //图片路径
                frameCount: nFrameCount       //帧的个数
                frameX: arrFrameDirectionIndex[0][0] * sizeFrame.width; frameY: arrFrameDirectionIndex[0][1] * sizeFrame.height     //起始位置
                frameWidth: sizeFrame.width; frameHeight: sizeFrame.height //帧的宽高
                frameDuration: interval     //切换速度
                to: {"Up": 0, "Right": 0, "Down": 0, "Left": 0} //到每个帧的权重（所有权重加起来站的比例），为0则不自动跳转
                randomStart: true
            }

            Sprite {
                name: "Right"; source: spriteSrc
                frameCount: nFrameCount; frameX: arrFrameDirectionIndex[1][0] * sizeFrame.width; frameY: arrFrameDirectionIndex[1][1] * sizeFrame.height
                frameWidth: sizeFrame.width; frameHeight: sizeFrame.height
                frameDuration: interval
                to: {"Up": 0, "Right": 0, "Down": 0, "Left": 0}
                randomStart: true
            }
            Sprite {
                name: "Down"; source: spriteSrc
                frameCount: nFrameCount; frameX: arrFrameDirectionIndex[2][0] * sizeFrame.width; frameY: arrFrameDirectionIndex[2][1] * sizeFrame.height
                frameWidth: sizeFrame.width; frameHeight: sizeFrame.height
                frameDuration: interval
                to: {"Up": 0, "Right": 0, "Down": 0, "Left": 0}
                randomStart: true
            }
            Sprite {
                name: "Left"; source: spriteSrc
                frameCount: nFrameCount; frameX: arrFrameDirectionIndex[3][0] * sizeFrame.width; frameY: arrFrameDirectionIndex[3][1] * sizeFrame.height
                frameWidth: sizeFrame.width; frameHeight: sizeFrame.height
                frameDuration: interval
                to: {"Up": 0, "Right": 0, "Down": 0, "Left": 0}
                randomStart: true
            }
        }
    }




    Rectangle { //真实占位图块
        id: rectShadow

        x: 0
        y: 0
        width: parent.width
        height: parent.height
        color: "#4F000000"
        radius: width / 2
        //visible: false
        z: -1
    }


    MouseArea {
        id: mouseArea
        property int nIndex: 0
        enabled: false

        anchors.fill: parent
        onClicked: {
            ++nIndex;
            if(nIndex > 3)
                nIndex = 0;
            switch(nIndex) {
            case 0:
                sprite.jumpTo("Up");
                //sprite.goalSprite = "Up";
                //sprite.currentSprite = "Up";
                break;
            case 1:
                sprite.jumpTo("Right");
                //sprite.goalSprite = "Right";
                //sprite.currentSprite = "Right";
                break;
            case 2:
                sprite.jumpTo("Down");
                //sprite.goalSprite = "Down";
                //sprite.currentSprite = "Down";
                break;
            case 3:
                sprite.jumpTo("Left");
                //sprite.goalSprite = "Left";
                //sprite.currentSprite = "Left";
                break;
            }

            sprite.running = true;
            //console.debug("[Role]Test Start");
        }
    }


    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:
            sprite.jumpTo("Up");
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Right:
            sprite.jumpTo("Right");
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Left:
            sprite.jumpTo("Left");
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Down:
            sprite.jumpTo("Down");
            sprite.running = true;
            event.accepted = true;
            break;
        }
        //console.debug("[Role]Keys.onPressed:", event.key);
    }

    Keys.onReleased: {
        switch(event.key) {
        case Qt.Key_Up:
        case Qt.Key_Right:
        case Qt.Key_Left:
        case Qt.Key_Down:
            sprite.running = false;
            event.accepted = true;
            //console.debug("[Role]Keys.onReleased:", event.key);
            break;
        }

    }

    Component.onCompleted: {

    }

    Component.onDestruction: {
        root.unload();
    }
}
