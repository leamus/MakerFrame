import QtQuick 2.14

//安卓assets的bug（详见QML_Pleafles）
//import RPGComponents 1.0


/*

  鹰：由于Sprite的source和 frameX、 frameY 修改无效，所以只能用Component进行创建，使用reset进行删除重建。
    //!!!后期想办法把reset去掉
    问题：1、无法初始化时直接显示某个Sprite，只能是第一个Srite；
      2、无法显示某个Sprite的某一帧；
      3、running为false时jumpTo无效，只能在后面调用一次 start和stop；
      4、reset（也就是重新创建组件）后立刻调用start（也就是 jumpTo）无效，只能延时1ms后调用才有效。
*/

Item {
    id: root


    //signal s_clicked();
    //signal s_ActionFinished();



    //刷新重建
    function reset() {
        start(2, null);
        if(root.sprite.sprite)
            root.sprite.reset();
    }

    //删除
    function unload() {
        nSpriteType = 0;

        if(root.sprite) {
            //root.sprite.nSpriteType = 0;
            //root.sprite.destroy();
            //root.sprite = undefined;
        }
    }

    //开始播放动画（和方向有关）
    //running为 boolean 为是否运行，为其他值保持不变
    function start(tdirection, running=true) {
        //if(root.sprite === undefined)
        //    return;
        //root.sprite.jumpTo(d);
        let tnDirection = nDirection;

        switch(tdirection) {
        case Qt.Key_Up:
        case 0:
            root.sprite.jumpTo('$Up');
            //root.sprite.jumpTo('$Up');
            //root.sprite.sprite.goalSprite = '$Up';
            //root.sprite.sprite.currentSprite = '$Up';
            break;
        case Qt.Key_Right:
        case 1:
            root.sprite.jumpTo('$Right');
            //root.sprite.jumpTo('$Right');
            //root.sprite.sprite.goalSprite = '$Right';
            //root.sprite.sprite.currentSprite = '$Right';
            break;
        case 2:
        case Qt.Key_Down:
            root.sprite.jumpTo('$Down');
            //root.sprite.jumpTo('$Down');
            //root.sprite.sprite.goalSprite = '$Down';
            //root.sprite.sprite.currentSprite = '$Down';
            break;
        case Qt.Key_Left:
        case 3:
            root.sprite.jumpTo('$Left');
            //root.sprite.jumpTo('$Left');
            //root.sprite.sprite.goalSprite = '$Left';
            //root.sprite.sprite.currentSprite = '$Left';
            break;
        }

        if(running === true) {
            if(nDirection === tnDirection)
                root.sprite.start();
            else
                root.sprite.restart();
        }
        else if(running === false)
            root.sprite.stop();


        //静态换方向
        /*if(root.sprite.sprite.running === false) {
            start();
            stop();
        }
        else
            start();*/

        //console.debug("[Role]start", root.sprite, root.sprite.sprite.state, root.sprite.sprite.currentSprite)
    }

    //停止动画
    function stop() {
        //if(root.sprite === undefined)
        //    return;
        //console.warn(nSpriteType, root.sprite.nSpriteType)
        if(root.sprite.sprite)
            root.sprite.stop();
    }

    //行走方向
    function direction(type=0) {
        if(type === 0)
            return root.nDirection;
        else {
            switch(root.nDirection) {
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


    /*function playSprite() {
        root.sprite.sprite.visible = false;
        customsprite.sprite.visible = true;
        customsprite.start();
    }
    */



    property int nSpriteType: 0
    onNSpriteTypeChanged: {
        switch(nSpriteType) {
        case 1:
            sprite.nSpriteType = 1;
            break;
        case 2:
            sprite.nSpriteType = 2;
            break;
        default:
            sprite.nSpriteType = 0;
        }
    }

    property alias strSource: spriteEffect.strSource   //精灵图片
    property alias nFrameCount: spriteEffect.nFrameCount //一个方向有几张图片
    property alias nInterval: spriteEffect.nInterval  //帧切换速度
    property alias arrActionsData: spriteEffect.arrActionsData
    //缩放
    property alias rXScale: spriteEffect.rXScale
    property alias rYScale: spriteEffect.rYScale
    property alias rXOffset: spriteEffect.rXOffset       //x偏移
    property alias rYOffset: spriteEffect.rYOffset       //y偏移


    //x1、y1为 场景中 人物的 有效占位（占地图） 起始点 偏移（相对于x，y），x2、y2为 有效占位 终止点 偏移，width1、height1为有效占位宽高
    property alias x1: rectShadow.x
    property alias y1: rectShadow.y
    readonly property int x2: x1 + width1 - 1
    readonly property int y2: y1 + height1 - 1
    property alias width1: rectShadow.width
    property alias height1: rectShadow.height

    property alias rectShadow: rectShadow   //真实占用大小（影子）
    property alias mouseArea: mouseArea


    property bool bSmooth: false
    property alias sprite: spriteEffect
    //property alias customSprite: customSprite

    //目前角色的方向
    property int nDirection: -1


    property alias bTest: spriteEffect.bTest


    width: 0
    height: 0
    //implicitWidth: root.sprite.sprite.visible ? root.sprite.sprite.implicitWidth : customSprite.implicitWidth
    //implicitHeight: root.sprite.sprite.visible ? root.sprite.sprite.implicitHeight : customSprite.implicitHeight
    implicitWidth: root.sprite.sprite ? root.sprite.sprite.implicitWidth : 0
    implicitHeight: root.sprite.sprite ? root.sprite.sprite.implicitHeight: 0

    focus: true

    smooth: false



    SpriteEffect {
        id: spriteEffect



        function action(actionName) {
            sprite.nFrameStartIndex = arrActionsData[actionName][0];
            nFrameCount = arrActionsData[actionName][1];
            nInterval = arrActionsData[actionName][2];

            sprite.restart();
        }

        function jumpTo(tdirection) {
            if(nSpriteType === 1) {
                if(tdirection === '$Up') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[0][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[0][1] * root.sizeFrame.height;     //起始位置
                    sprite.pointOffsetIndex = Qt.point(arrActionsData[0][0], arrActionsData[0][1]);
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                    nCurrentFrame = 0;

                    nDirection = 0;
                }
                else if(tdirection === '$Right') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[1][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[1][1] * root.sizeFrame.height;     //起始位置
                    sprite.pointOffsetIndex = Qt.point(arrActionsData[1][0], arrActionsData[1][1]);
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                    nCurrentFrame = 0;

                    nDirection = 1;
                }
                else if(tdirection === '$Down') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[2][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[2][1] * root.sizeFrame.height;     //起始位置
                    sprite.pointOffsetIndex = Qt.point(arrActionsData[2][0], arrActionsData[2][1]);
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                    nCurrentFrame = 0;

                    nDirection = 2;
                }
                else if(tdirection === '$Left') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[3][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[3][1] * root.sizeFrame.height;     //起始位置
                    sprite.pointOffsetIndex = Qt.point(arrActionsData[3][0], arrActionsData[3][1]);
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                    nCurrentFrame = 0;

                    nDirection = 3;
                }
            }
            else if(nSpriteType === 2) {
                if(tdirection === '$Up') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[0][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[0][1] * root.sizeFrame.height;     //起始位置
                    //action('$Up');
                    sprite.nFrameStartIndex = arrActionsData['$Up'][0];
                    nFrameCount = arrActionsData['$Up'][1];
                    nInterval = arrActionsData['$Up'][2];
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                    nDirection = 0;
                }
                else if(tdirection === '$Right') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[1][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[1][1] * root.sizeFrame.height;     //起始位置
                    //action('$Right');
                    sprite.nFrameStartIndex = arrActionsData['$Right'][0];
                    nFrameCount = arrActionsData['$Right'][1];
                    nInterval = arrActionsData['$Right'][2];
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                    nDirection = 1;
                }
                else if(tdirection === '$Down') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[2][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[2][1] * root.sizeFrame.height;     //起始位置
                    //action('$Down');
                    sprite.nFrameStartIndex = arrActionsData['$Down'][0];
                    nFrameCount = arrActionsData['$Down'][1];
                    nInterval = arrActionsData['$Down'][2];
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                    nDirection = 2;
                }
                else if(tdirection === '$Left') {
                    //width = root.width;
                    //height = root.height;
                    //walkSprite.animatedsprite.frameX = arrActionsData[3][0] * root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameY = arrActionsData[3][1] * root.sizeFrame.height;     //起始位置
                    //action('$Left');
                    sprite.nFrameStartIndex = arrActionsData['$Left'][0];
                    nFrameCount = arrActionsData['$Left'][1];
                    nInterval = arrActionsData['$Left'][2];
                    //walkSprite.strSource = root.strSource;
                    //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                    //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                    //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                    //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                    //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                    nDirection = 3;
                }
            }
        }



        //帧数据
        //  类型为1时，[[0,0],[0,1],[0,2],[0,3]]  //上右下左 的 行、列 偏移
        //  类型为2时，{'动作名': [帧起始号, 帧数, 帧速度]}
        property var arrActionsData: []


        //width: root.width; height: root.height     //一个帧的大小，会缩放
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        width: root.width
        height: root.height

        smooth: root.bSmooth

        nLoops: AnimatedSprite.Infinite
    }



    /*/自定义精灵
    SpriteEffect {
        id: customSprite


        onS_finished: {
            visible = false;
            root.sprite.sprite.visible = true;

            //s_ActionFinished();
        }


        visible: false
        //width: root.width; height: root.height     //一个帧的大小，会缩放
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter

        smooth: true

        animatedsprite.loops: AnimatedSprite.Infinite


        bTest: root.bTest
    }
    */



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
            if(bTest) {
                ++nIndex;
                if(nIndex > 3)
                    nIndex = 0;
                switch(nIndex) {
                case 0:
                    root.sprite.jumpTo('$Up');
                    //root.sprite.sprite.goalSprite = '$Up';
                    //root.sprite.sprite.currentSprite = '$Up';
                    break;
                case 1:
                    root.sprite.jumpTo('$Right');
                    //root.sprite.sprite.goalSprite = '$Right';
                    //root.sprite.sprite.currentSprite = '$Right';
                    break;
                case 2:
                    root.sprite.jumpTo('$Down');
                    //root.sprite.sprite.goalSprite = '$Down';
                    //root.sprite.sprite.currentSprite = '$Down';
                    break;
                case 3:
                    root.sprite.jumpTo('$Left');
                    //root.sprite.sprite.goalSprite = '$Left';
                    //root.sprite.sprite.currentSprite = '$Left';
                    break;
                }

                root.sprite.restart();
                //console.debug("[Role]Test Start");
            }

            //s_clicked();
        }
    }



    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:
            root.sprite.jumpTo('$Up');
            break;
        case Qt.Key_Right:
            root.sprite.jumpTo('$Right');
            break;
        case Qt.Key_Left:
            root.sprite.jumpTo('$Left');
            break;
        case Qt.Key_Down:
            root.sprite.jumpTo('$Down');
            break;
        }
        root.sprite.start();

        event.accepted = true;
        //console.debug("[Role]Keys.onPressed:", event.key);
    }

    Keys.onReleased: {
        switch(event.key) {
        case Qt.Key_Up:
        case Qt.Key_Right:
        case Qt.Key_Left:
        case Qt.Key_Down:
            root.sprite.stop();
            event.accepted = true;
            //console.debug("[Role]Keys.onReleased:", event.key);
            break;
        }

    }


    Component.onCompleted: {
        console.debug('[Role]Component.onCompleted:', Qt.resolvedUrl('.'));
    }

    Component.onDestruction: {
        root.unload();
    }
}
