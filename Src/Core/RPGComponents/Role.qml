import QtQuick 2.14

/*

  鹰：由于Sprite的source和 frameX、 frameY 修改无效，所以只能用Component进行创建，使用refresh进行删除重建。
    //!!!后期想办法把refresh去掉
    问题：1、无法初始化时直接显示某个Sprite，只能是第一个Srite；
      2、无法显示某个Sprite的某一帧；
      3、running为false时jumpTo无效，只能在后面调用一次 start和stop；
      4、refresh（也就是重新创建组件）后立刻调用start（也就是 jumpTo）无效，只能延时1ms后调用才有效。
*/

Item {
    id: root


    signal s_clicked();



    //刷新重建
    function refresh() {
        start(2, null);
        walkSprite.animatedsprite.currentFrame = 0;
    }

    //删除
    function unload() {
        if(walkSprite) {
            //walkSprite.destroy();
            //walkSprite = undefined;
        }
    }

    //开始播放动画（和方向有关）
    function start(tdirect, running=true) {
        //if(walkSprite === undefined)
        //    return;
        //walkSprite.jumpTo(d);

        switch(tdirect) {
        case Qt.Key_Up:
        case 0:
            walkSprite.jumpTo("Up");
            //walkSprite.jumpTo("Up");
            //walkSprite.goalSprite = "Up";
            //walkSprite.currentSprite = "Up";
            break;
        case Qt.Key_Right:
        case 1:
            walkSprite.jumpTo("Right");
            //walkSprite.jumpTo("Right");
            //walkSprite.goalSprite = "Right";
            //walkSprite.currentSprite = "Right";
            break;
        case 2:
        case Qt.Key_Down:
            walkSprite.jumpTo("Down");
            //walkSprite.jumpTo("Down");
            //walkSprite.goalSprite = "Down";
            //walkSprite.currentSprite = "Down";
            break;
        case Qt.Key_Left:
        case 3:
            walkSprite.jumpTo("Left");
            //walkSprite.jumpTo("Left");
            //walkSprite.goalSprite = "Left";
            //walkSprite.currentSprite = "Left";
            break;
        }

        if(running === true || running === false)
            walkSprite.running = running;


        //静态换方向
        /*if(walkSprite.running === false) {
            start();
            stop();
        }
        else
            start();*/

        //console.debug("[Role]start", walkSprite, walkSprite.state, walkSprite.currentSprite)
    }

    //停止动画
    function stop() {
        //if(walkSprite === undefined)
        //    return;
        walkSprite.running = false;
    }

    //行走方向
    function direction(type=0) {
        if(type === 0)
            return walkSprite.nDirection;
        else {
            switch(walkSprite.nDirection) {
            case 0:
                return Qt.Key_Up;
            case 1:
                return Qt.Key_Right;
            case 2:
                return Qt.Key_Down;
            case 3:
                return Qt.Key_Left;
            }
        }
    }



    property alias spriteSrc: walkSprite.spriteSrc   //精灵图片
    property alias sizeFrame: walkSprite.sizeFrame     //一帧的宽高
    property alias nFrameCount: walkSprite.nFrameCount //一个方向有几张图片
    property var arrFrameDirectionIndex: [[0,0],[0,1],[0,2],[0,3]]  //上右下左 的 行、列 偏移
    property alias interval: walkSprite.interval  //帧切换速度

    //缩放
    property alias rXScale: walkSprite.rXScale
    property alias rYScale: walkSprite.rYScale


    //x1、y1为 场景中 人物的 有效占位（占地图） 起始点 偏移（相对于x，y），x2、y2为 有效占位 终止点 偏移，width1、height1为有效占位宽高
    property alias x1: rectShadow.x
    property alias y1: rectShadow.y
    readonly property int x2: x1 + width1 - 1
    readonly property int y2: y1 + height1 - 1
    property alias width1: rectShadow.width
    property alias height1: rectShadow.height

    property alias rectShadow: rectShadow   //真实占用大小（影子）
    property alias mouseArea: mouseArea


    property alias sprite: walkSprite
    property alias actionSprite: actionSprite

    //目前行走特效的方向
    property alias nDirection: walkSprite.nDirection


    property var test: false


    width: 0
    height: 0
    //implicitWidth: width
    //implicitHeight: height

    focus: true

    smooth: false



    SpriteEffect {
        id: walkSprite


        function jumpTo(action) {

            if(action === 'Up') {
                width = root.width;
                height = root.height;
                walkSprite.animatedsprite.frameX = root.arrFrameDirectionIndex[0][0] * root.sizeFrame.width;
                walkSprite.animatedsprite.frameY = root.arrFrameDirectionIndex[0][1] * root.sizeFrame.height;     //起始位置
                //walkSprite.spriteSrc = root.spriteSrc;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                walkSprite.animatedsprite.currentFrame = 0;

                nDirection = 0;
            }
            else if(action === 'Right') {
                width = root.width;
                height = root.height;
                walkSprite.animatedsprite.frameX = root.arrFrameDirectionIndex[1][0] * root.sizeFrame.width;
                walkSprite.animatedsprite.frameY = root.arrFrameDirectionIndex[1][1] * root.sizeFrame.height;     //起始位置
                //walkSprite.spriteSrc = root.spriteSrc;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                walkSprite.animatedsprite.currentFrame = 0;

                nDirection = 1;
            }
            else if(action === 'Down') {
                width = root.width;
                height = root.height;
                walkSprite.animatedsprite.frameX = root.arrFrameDirectionIndex[2][0] * root.sizeFrame.width;
                walkSprite.animatedsprite.frameY = root.arrFrameDirectionIndex[2][1] * root.sizeFrame.height;     //起始位置
                //walkSprite.spriteSrc = root.spriteSrc;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                walkSprite.animatedsprite.currentFrame = 0;

                nDirection = 2;
            }
            else if(action === 'Left') {
                width = root.width;
                height = root.height;
                walkSprite.animatedsprite.frameX = root.arrFrameDirectionIndex[3][0] * root.sizeFrame.width;
                walkSprite.animatedsprite.frameY = root.arrFrameDirectionIndex[3][1] * root.sizeFrame.height;     //起始位置
                //walkSprite.spriteSrc = root.spriteSrc;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                walkSprite.animatedsprite.currentFrame = 0;

                nDirection = 3;
            }
        }


        property int nDirection: -1

        //width: root.width; height: root.height     //一个帧的大小，会缩放
        anchors.horizontalCenter: parent.horizontalCenter

        smooth: true

        animatedsprite.loops: AnimatedSprite.Infinite

    }


    //动作精灵
    SpriteEffect {
        id: actionSprite


        function playAction() {
            walkSprite.visible = false;
            visible = true;
            start();
        }

        onS_finished: {
            visible = false;
            walkSprite.visible = true;
        }


        visible: false
        //width: root.width; height: root.height     //一个帧的大小，会缩放
        anchors.horizontalCenter: parent.horizontalCenter

        smooth: true

        animatedsprite.loops: AnimatedSprite.Infinite

    }



    Rectangle { //真实占位图块
        id: rectShadow

        x: 0
        y: 0
        width: parent.width
        height: parent.height
        color: "#FF000000"
        radius: width / 2

        opacity: 0.3

        //visible: false
        z: -1
    }


    MouseArea {
        id: mouseArea
        property int nIndex: 0
        //enabled: false

        anchors.fill: parent
        onClicked: {
            if(test) {
                ++nIndex;
                if(nIndex > 3)
                    nIndex = 0;
                switch(nIndex) {
                case 0:
                    walkSprite.jumpTo("Up");
                    //walkSprite.goalSprite = "Up";
                    //walkSprite.currentSprite = "Up";
                    break;
                case 1:
                    walkSprite.jumpTo("Right");
                    //walkSprite.goalSprite = "Right";
                    //walkSprite.currentSprite = "Right";
                    break;
                case 2:
                    walkSprite.jumpTo("Down");
                    //walkSprite.goalSprite = "Down";
                    //walkSprite.currentSprite = "Down";
                    break;
                case 3:
                    walkSprite.jumpTo("Left");
                    //walkSprite.goalSprite = "Left";
                    //walkSprite.currentSprite = "Left";
                    break;
                }

                walkSprite.running = true;
                //console.debug("[Role]Test Start");
            }

            s_clicked();
        }
    }



    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:
            walkSprite.jumpTo("Up");
            walkSprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Right:
            walkSprite.jumpTo("Right");
            walkSprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Left:
            walkSprite.jumpTo("Left");
            walkSprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Down:
            walkSprite.jumpTo("Down");
            walkSprite.running = true;
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
            walkSprite.running = false;
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
