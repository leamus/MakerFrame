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


    //signal sg_clicked();



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
        case '$Up':
            actionName = '$Up';
            nDirection = 0;
            break;
        case 1:
        case Qt.Key_Right:
        case '$Right':
            actionName = '$Right';
            nDirection = 1;
            break;
        case 2:
        case Qt.Key_Down:
        case '$Down':
            actionName = '$Down';
            nDirection = 2;
            break;
        case 3:
        case Qt.Key_Left:
        case '$Left':
            actionName = '$Left';
            nDirection = 3;
            break;
        }


        if(!objActionsData[actionName])
            return false;


        if(root.nSpriteType === 0) {
            //读特效信息
            //let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;
            //let info = FrameManager.sl_fileRead(GlobalJS.toPath(path + GameMakerGlobal.separator + objActionsData[actionName] + GameMakerGlobal.separator + "sprite.json"));
            //if(info)
            //    info = JSON.parse(info);
            //else
            //    return false;

            const info = objActionsData[actionName].Info;
            if(!info)
                return false;
            const script = info.Script;

            spriteEffect.nSpriteType = info.SpriteType ?? 1;

            spriteEffect.strSource = GameMakerGlobal.spriteResourceURL(info.Image);

            if(spriteEffect.nSpriteType === 1) {
                spriteEffect.nFrameCount = GlobalLibraryJS.getObjectValue(info.FrameData, 'FrameCount') ?? info.FrameCount;
                spriteEffect.nInterval = GlobalLibraryJS.getObjectValue(info.FrameData, 'FrameInterval') ?? info.FrameInterval;

                //注意这个放在 spriteEffect.sprite.width 和 spriteEffect.sprite.height 之前
                let t = GlobalLibraryJS.getObjectValue(info.FrameData, 'FrameSize') ?? info.FrameSize;
                spriteEffect.sprite.sizeFrame = Qt.size(t[0], t[1]);

                t = GlobalLibraryJS.getObjectValue(info.FrameData, 'OffsetIndex') ?? info.OffsetIndex;
                spriteEffect.sprite.pointOffsetIndex = Qt.point(t[0], t[1]);
            }
            else if(spriteEffect.nSpriteType === 2) {
                spriteEffect.nFrameCount = info.FrameData.FrameCount ?? info.FrameData[1];
                spriteEffect.nInterval = info.FrameData.FrameInterval ?? info.FrameData[2];
                spriteEffect.sprite.nFrameStartIndex = info.FrameData.FrameStartIndex ?? info.FrameData[0];

                spriteEffect.sprite.fnRefresh = script ? script.$refresh : null;
            }

            //!只有这个类型是从 特效配置中读取大小并设置，其他类型是从 角色中读取大小并设置
            //root.width = Qt.binding(()=>spriteEffect.width);
            //root.height = Qt.binding(()=>spriteEffect.height);
            root.width = parseInt(info.SpriteSize[0]);
            root.height = parseInt(info.SpriteSize[1]);
            //spriteEffect.implicitWidth = (info.SpriteSize[0]);
            //spriteEffect.implicitHeight = (info.SpriteSize[1]);
            spriteEffect.rXOffset = info.XOffset !== undefined ? (info.XOffset) : 0;
            spriteEffect.rYOffset = info.YOffset !== undefined ? (info.YOffset) : 0;
            spriteEffect.opacity = (info.Opacity);
            spriteEffect.rXScale = (info.XScale);
            spriteEffect.rYScale = (info.YScale);

            if(info.Sound) {
                spriteEffect.strSoundeffectName = info.Sound;
            }
            else {
                spriteEffect.strSoundeffectName = '';
            }
            //console.warn("!!!", info.Sound, strSoundeffectName)
            spriteEffect.nSoundeffectDelay = (info.SoundDelay);


            //nLoops = loops;
            //restart();
        }
        else if(root.nSpriteType === 1) {
            //width = root.width;
            //height = root.height;
            //walkSprite.animatedsprite.frameX = objActionsData[actionName][0] * root.sizeFrame.width;
            //walkSprite.animatedsprite.frameY = objActionsData[actionName][1] * root.sizeFrame.height;     //起始位置
            spriteEffect.sprite.pointOffsetIndex = Qt.point(objActionsData[actionName][0], objActionsData[actionName][1]);
            //walkSprite.strSource = root.strSource;
            //walkSprite.nFrameCount = root.nFrameCount;       //帧的个数
            //walkSprite.animatedsprite.frameWidth = root.sizeFrame.width;
            //walkSprite.animatedsprite.frameHeight = root.sizeFrame.height; //帧的宽高
            //walkSprite.animatedsprite.frameDuration = root.interval;     //切换速度
            //walkSprite.animatedsprite.loops = AnimatedSprite.Infinite;
            //spriteEffect.nCurrentFrame = 0;
        }
        else if(root.nSpriteType === 2) {
            spriteEffect.sprite.nFrameStartIndex = objActionsData[actionName][0];
            spriteEffect.nFrameCount = objActionsData[actionName][1];
            spriteEffect.nInterval = objActionsData[actionName][2];

            //changeAction(actionName);
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



    //0：从特效选择；1：经典行列图；2：序列图片文件；
    property int nSpriteType: -1
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

        objActionsData = {};
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
    //帧数据（动作名：系统的有 $Up、$Right、$Down、$Left）；
    //  nSpriteType为0时，{'动作名': {Info: 特效信息, Script: 脚本}。。。}
    //  nSpriteType为1时，{'动作名': [0,0]。。。}  //上右下左 的 行、列 偏移
    //  nSpriteType为2时，{'动作名': [帧起始号, 帧数, 帧速度]。。。}
    property var objActionsData: ({})


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


        onsg_finished: {
            visible = false;
            root.sprite.sprite.visible = true;

            //sg_actionFinished();
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

            //sg_clicked();
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
