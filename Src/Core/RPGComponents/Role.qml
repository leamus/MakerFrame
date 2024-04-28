import QtQuick 2.14

//安卓assets的bug（详见QML_Pleafles）
//import RPGComponents 1.0


/*

  鹰：由于Sprite的source和 frameX、 frameY 修改无效，所以只能用Component进行创建，使用reset进行删除重建。
    //!!!后期想办法把reset去掉
    问题：1、无法初始化时直接显示某个Sprite，只能是第一个Srite；
      2、无法显示某个Sprite的某一帧；
      3、running为false时action无效，只能在后面调用一次 start和stop；
      4、reset（也就是重新创建组件）后立刻调用start（也就是 action）无效，只能延时1ms后调用才有效。
*/

Item {
    id: root


    //signal s_clicked();



    //刷新重建
    function reset() {
        changeAction(2);
        spriteEffect.reset();
    }

    //删除
    function unload() {
        nSpriteType = -1;
        spriteEffect.nSpriteType = 0;

        //if(root.sprite) {
            //root.sprite.nSpriteType = 0;
            //root.sprite.destroy();
            //root.sprite = undefined;
        //}
    }

    //开始播放动画（和方向有关）
    function start(taction, loops=AnimatedSprite.Infinite) {
        //if(root.sprite === undefined)
        //    return;
        //root.changeAction(d);

        let tstrActionName = strActionName;

        //taction = taction ?? '$Down';

        if(taction !== undefined && !root.changeAction(taction)) {
            spriteEffect.stop();
            return;
        }
        //root.changeAction('$Left');
        //root.sprite.sprite.goalSprite = '$Left';
        //root.sprite.sprite.currentSprite = '$Left';


        spriteEffect.nLoops = loops ?? AnimatedSprite.Infinite;

        if(strActionName === tstrActionName)
            spriteEffect.start();
        else
            spriteEffect.restart();

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
    function pause() {
        //if(root.sprite === undefined)
        //    return;
        //console.warn(nSpriteType, root.sprite.nSpriteType)
        spriteEffect.pause();
    }

    function stop() {
        //if(root.sprite === undefined)
        //    return;
        //console.warn(nSpriteType, root.sprite.nSpriteType)
        spriteEffect.stop();
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


    function changeAction(actionName) {
        switch(actionName) {
        case 0:
        case Qt.Key_Up:
            actionName = '$Up';
            break;
        case 1:
        case Qt.Key_Right:
            actionName = '$Right';
            break;
        case 2:
        case Qt.Key_Down:
            actionName = '$Down';
            break;
        case Qt.Key_Left:
        case 3:
            actionName = '$Left';
            break;
        }


        if(root.nSpriteType === 0) {
            //读特效信息
            //let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;
            //let data = FrameManager.sl_qml_ReadFile(GlobalJS.toPath(path + GameMakerGlobal.separator + arrActionsData[actionName] + GameMakerGlobal.separator + "sprite.json"));
            //if(data)
            //    data = JSON.parse(data);
            //else
            //    return false;

            let data = arrActionsData[actionName];
            if(!data)
                return false;

            spriteEffect.nSpriteType = data.SpriteType ?? 1;

            spriteEffect.strSource = GameMakerGlobal.spriteResourceURL(data.Image);

            if(spriteEffect.nSpriteType === 1) {
                spriteEffect.nFrameCount = (data.FrameCount);
                spriteEffect.nInterval = (data.FrameInterval);

                //注意这个放在 spriteEffect.sprite.width 和 spriteEffect.sprite.height 之前
                spriteEffect.sprite.sizeFrame = Qt.size((data.FrameSize[0]), (data.FrameSize[1]));

                spriteEffect.sprite.pointOffsetIndex = Qt.point((data.OffsetIndex[0]), (data.OffsetIndex[1]));
            }
            else if(spriteEffect.nSpriteType === 2) {
                spriteEffect.nFrameCount = data.FrameData[1];
                spriteEffect.nInterval = data.FrameData[2];

                spriteEffect.sprite.nFrameStartIndex = data.FrameData[0];


                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + item;
                if(FrameManager.sl_qml_FileExists(path + GameMakerGlobal.separator + 'sprite.js')) {
                    //_private.jsEngine.clear();
                    let ts = _private.jsEngine.load('sprite.js', GlobalJS.toURL(path));
                    spriteEffect.sprite.fnRefresh = ts.$refresh;
                    //FrameManager.sl_qml_clearComponentCache();
                }
            }

            //!只有这个类型是从 特效配置中读取大小并设置，其他类型是从 角色中读取大小并设置
            //root.width = Qt.binding(()=>spriteEffect.width);
            //root.height = Qt.binding(()=>spriteEffect.height);
            root.width = parseInt(data.SpriteSize[0]);
            root.height = parseInt(data.SpriteSize[1]);
            //spriteEffect.implicitWidth = (data.SpriteSize[0]);
            //spriteEffect.implicitHeight = (data.SpriteSize[1]);
            spriteEffect.rXOffset = data.XOffset !== undefined ? (data.XOffset) : 0;
            spriteEffect.rYOffset = data.YOffset !== undefined ? (data.YOffset) : 0;
            spriteEffect.opacity = (data.Opacity);
            spriteEffect.rXScale = (data.XScale);
            spriteEffect.rYScale = (data.YScale);

            if(data.Sound) {
                spriteEffect.strSoundeffectName = data.Sound;
            }
            else {
                spriteEffect.strSoundeffectName = "";
            }
            //console.warn("!!!", data.Sound, strSoundeffectName)
            spriteEffect.nSoundeffectDelay = (data.SoundDelay);


            //nLoops = loops;
            //restart();


            if(actionName === '$Up') {
                nDirection = 0;
            }
            else if(actionName === '$Right') {
                nDirection = 1;
            }
            else if(actionName === '$Down') {
                nDirection = 2;
            }
            else if(actionName === '$Left') {
                nDirection = 3;
            }
        }
        else if(root.nSpriteType === 1) {
            if(actionName === '$Up') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[0][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[0][1] * root.sizeFrame.height;     //起始位置
                spriteEffect.sprite.pointOffsetIndex = Qt.point(arrActionsData[0][0], arrActionsData[0][1]);
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                //spriteEffect.nCurrentFrame = 0;

                nDirection = 0;
            }
            else if(actionName === '$Right') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[1][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[1][1] * root.sizeFrame.height;     //起始位置
                spriteEffect.sprite.pointOffsetIndex = Qt.point(arrActionsData[1][0], arrActionsData[1][1]);
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                //spriteEffect.nCurrentFrame = 0;

                nDirection = 1;
            }
            else if(actionName === '$Down') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[2][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[2][1] * root.sizeFrame.height;     //起始位置
                spriteEffect.sprite.pointOffsetIndex = Qt.point(arrActionsData[2][0], arrActionsData[2][1]);
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                //spriteEffect.nCurrentFrame = 0;

                nDirection = 2;
            }
            else if(actionName === '$Left') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[3][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[3][1] * root.sizeFrame.height;     //起始位置
                spriteEffect.sprite.pointOffsetIndex = Qt.point(arrActionsData[3][0], arrActionsData[3][1]);
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
                //spriteEffect.nCurrentFrame = 0;

                nDirection = 3;
            }

        }
        else if(root.nSpriteType === 2) {
            if(!arrActionsData[actionName])
                return;

            spriteEffect.sprite.nFrameStartIndex = arrActionsData[actionName][0];
            spriteEffect.nFrameCount = arrActionsData[actionName][1];
            spriteEffect.nInterval = arrActionsData[actionName][2];

            if(actionName === '$Up') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[0][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[0][1] * root.sizeFrame.height;     //起始位置
                //changeAction('$Up');
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                nDirection = 0;
            }
            else if(actionName === '$Right') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[1][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[1][1] * root.sizeFrame.height;     //起始位置
                //changeAction('$Right');
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                nDirection = 1;
            }
            else if(actionName === '$Down') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[2][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[2][1] * root.sizeFrame.height;     //起始位置
                //changeAction('$Down');
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                nDirection = 2;
            }
            else if(actionName === '$Left') {
                //width = root.width;
                //height = root.height;
                //walkSprite.animatedsprite.frameX = arrActionsData[3][0] * root.sizeFrame.width;
                //walkSprite.animatedsprite.frameY = arrActionsData[3][1] * root.sizeFrame.height;     //起始位置
                //changeAction('$Left');
                //walkSprite.strSource = root.strSource;
                //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
                //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
                //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
                //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
                //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;

                nDirection = 3;
            }

        }
        else
            return false;


        strActionName = actionName;


        return true;
    }



    property int nTestIndex: 0
    function fTestChangeDirection() {
        ++nTestIndex;
        if(nTestIndex > 3)
            nTestIndex = 0;
        switch(nTestIndex) {
        case 0:
            if(!root.changeAction('$Up')) {
                spriteEffect.stop();
                return;
            }
            //root.sprite.sprite.goalSprite = '$Up';
            //root.sprite.sprite.currentSprite = '$Up';
            break;
        case 1:
            if(!root.changeAction('$Right')) {
                spriteEffect.stop();
                return;
            }
            //root.sprite.sprite.goalSprite = '$Right';
            //root.sprite.sprite.currentSprite = '$Right';
            break;
        case 2:
            if(!root.changeAction('$Down')) {
                spriteEffect.stop();
                return;
            }
            //root.sprite.sprite.goalSprite = '$Down';
            //root.sprite.sprite.currentSprite = '$Down';
            break;
        case 3:
            if(!root.changeAction('$Left')) {
                spriteEffect.stop();
                return;
            }
            //root.sprite.sprite.goalSprite = '$Left';
            //root.sprite.sprite.currentSprite = '$Left';
            break;
        }

        spriteEffect.restart();
        //console.debug("[Role]Test Start");
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
            spriteEffect.nSpriteType = 1;
            break;
        case 2:
            spriteEffect.nSpriteType = 2;
            break;
        default:
            //spriteEffect.nSpriteType = 0;
        }
        spriteEffect.strSource = '';
        spriteEffect.nFrameCount = 0;
        spriteEffect.nInterval = 100;
        spriteEffect.nLoops = -1;
        spriteEffect.rXScale = 1;
        spriteEffect.rYScale = 1;
        spriteEffect.rXOffset = 0;
        spriteEffect.rYOffset = 0;
        spriteEffect.strSoundeffectName = '';
        spriteEffect.nSoundeffectDelay = 0;

        //spriteEffect.bSmooth = false;

        arrActionsData = [];
        //spriteEffect.bTest = false;
    }

    property alias strSource: spriteEffect.strSource   //精灵图片
    property alias nFrameCount: spriteEffect.nFrameCount //一个方向有几张图片
    property alias nInterval: spriteEffect.nInterval  //帧切换速度
    property alias nLoops: spriteEffect.nLoops //循环次数
    //缩放
    property alias rXScale: spriteEffect.rXScale
    property alias rYScale: spriteEffect.rYScale
    property alias rXOffset: spriteEffect.rXOffset       //x偏移
    property alias rYOffset: spriteEffect.rYOffset       //y偏移

    property alias strSoundeffectName: spriteEffect.strSoundeffectName
    property alias nSoundeffectDelay: spriteEffect.nSoundeffectDelay

    property alias bSmooth: spriteEffect.bSmooth


    property alias sprite: spriteEffect
    //帧数据
    //  nSpriteType为0时，{'动作名': 特效名}
    //  nSpriteType为1时，[[0,0],[0,1],[0,2],[0,3]]  //上右下左 的 行、列 偏移
    //  nSpriteType为2时，{'动作名': [帧起始号, 帧数, 帧速度]}
    property var arrActionsData: []


    property string strActionName: ''

    property alias rectShadow: rectShadow   //真实占用大小（影子）

    //x1、y1为 场景中 人物的 有效占位（占地图） 起始点 偏移（相对于x，y），x2、y2为 有效占位 终止点 偏移，width1、height1为有效占位宽高
    property alias x1: rectShadow.x
    property alias y1: rectShadow.y
    readonly property int x2: x1 + width1 - 1
    readonly property int y2: y1 + height1 - 1
    property alias width1: rectShadow.width
    property alias height1: rectShadow.height


    property alias mouseArea: mouseArea


    //property alias customSprite: customSprite

    //目前角色的方向
    property int nDirection: -1


    property alias bTest: spriteEffect.bTest


    width: spriteEffect.width
    height: spriteEffect.height
    //implicitWidth: root.sprite.sprite.visible ? root.sprite.sprite.implicitWidth : customSprite.implicitWidth
    //implicitHeight: root.sprite.sprite.visible ? root.sprite.sprite.implicitHeight : customSprite.implicitHeight
    implicitWidth: spriteEffect.implicitWidth
    implicitHeight: spriteEffect.implicitHeight

    focus: true

    smooth: false



    SpriteEffect {
        id: spriteEffect


        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        width: root.width
        height: root.height

        //smooth: root.bSmooth

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
        //enabled: false

        anchors.fill: parent
        onClicked: {
            if(bTest) {
                fTestChangeDirection();
            }

            //s_clicked();
        }
    }



    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:
            if(!root.changeAction('$Up')) {
                spriteEffect.stop();
                return;
            }
            break;
        case Qt.Key_Right:
            if(!root.changeAction('$Right')) {
                spriteEffect.stop();
                return;
            }
            break;
        case Qt.Key_Left:
            if(!root.changeAction('$Left')) {
                spriteEffect.stop();
                return;
            }
            break;
        case Qt.Key_Down:
            if(!root.changeAction('$Down')) {
                spriteEffect.stop();
                return;
            }
            break;
        }
        spriteEffect.start();

        event.accepted = true;
        //console.debug("[Role]Keys.onPressed:", event.key);
    }

    Keys.onReleased: {
        switch(event.key) {
        case Qt.Key_Up:
        case Qt.Key_Right:
        case Qt.Key_Left:
        case Qt.Key_Down:
            spriteEffect.stop();
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
