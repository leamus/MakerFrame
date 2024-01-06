import QtQuick 2.15
import QtMultimedia 5.14
import QtGraphicalEffects 1.0


import _Global 1.0
import _Global.Button 1.0

//import LGlobal 1.0


import "qrc:/QML"



/*

    //如果是循环播放（循环播放没有开始和结束信号）

    SoundEffect：
    //鹰：play可以停止前面的播放，然后重新开始播放
    //给source赋值时，会从硬盘读取；start时内存才会增加!!
    //多个SoundEffect，同时赋值source会比同时start更卡；


    Bug：如果帧数为1，则精灵不会自动 stop，需要一个Timer来stop
      如果帧数为1，即使loops为-1且running为true，它也会下一个js事件中running设置为false而停止；

*/

Item {
    id: root


    //被点击
    //signal s_clicked();

    //每次播放结束
    signal s_looped();
    //停止播放
    signal s_finished();

    //播放音效
    signal s_playEffect(string soundeffectSource)



    //开始播放动画
    function start() {
        //console.debug('start:', animatedsprite.running, spriteSrc)
        if(animatedsprite.running)
            return;


        animatedsprite.start();

        //if(soundeffectName)
        //    timerSound.start();

        if(animatedsprite.frameCount === 1) {
            timerInterval.interval = interval;
            timerInterval.start();
        }

    }

    //重新开始播放动画
    function restart() {
        //console.debug('restart:', animatedsprite.running, spriteSrc)
        animatedsprite.restart();

        if(nType === 1)
            soundeffect.stop();

        if(soundeffectName)
            timerSound.restart();

        if(animatedsprite.frameCount === 1) {
            timerInterval.interval = interval;
            timerInterval.restart();
        }
    }

    //停止动画
    function stop() {
        //console.debug('stop:', animatedsprite.running, spriteSrc)
        animatedsprite.stop();
        timerSound.stop();
        timerInterval.stop();
    }


    function colorOverlayStart(colors=undefined, index=1) {
        colorOverlay.start(colors=undefined, index=1);
    }
    function colorOverlayStop() {
        colorOverlay.stop();
    }



    property string spriteSrc: ""   //精灵图片
    property size sizeFrame: Qt.size(0,0)     //一帧的宽高
    property int nFrameCount: 3 //一个方向有几张图片
    property int interval: 100  //帧切换速度
    property point offsetIndex: Qt.point(0, 0)  //行、列 偏移
    property real rXScale: 1        //1为原图，-1为X轴镜像，其他值为X轴缩放
    property real rYScale: 1        //1为原图，-1为Y轴镜像，其他值为Y轴缩放
    property alias offsetX: animatedsprite.x
    property alias offsetY: animatedsprite.y


    property alias animatedsprite: animatedsprite
    property alias running: animatedsprite.running
    property alias numberanimationSpriteEffectX: numberanimationSpriteEffectX
    property alias numberanimationSpriteEffectY: numberanimationSpriteEffectY

    property int nType: 0   //0表示不播放音效，只是触发 播放信号；1表示本组件播放音频（win下如果太多，会卡顿）
    property string soundeffectName
    property alias soundeffectDelay: timerSound.interval


    property alias arrColorOverlayColors: colorOverlay.arrColors
    property alias nColorOverlayStep: colorOverlay.nStep
    property alias nColorOverlayInterval: colorOverlay.nInterval

    property alias mouseArea: mouseArea


    //测试，可以点击和显示调试信息
    property bool bTest: false


    //是否准备开始（不适用系统的running是因为系统先调用current
    property bool bStartToRunning: false


    //width: 0
    //height: 0

    implicitWidth: animatedsprite.implicitWidth
    implicitHeight: animatedsprite.implicitHeight

    smooth: false



    AnimatedSprite {
        id: animatedsprite

        width: root.width; height: root.height     //一个帧的大小，会缩放

        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter

        smooth: true

        source: spriteSrc
        interpolate: false   //true（默认）：在帧之间插值，使帧切换更平滑
        running: false
        loops: 1
        //reverse: true
        finishBehavior: AnimatedSprite.FinishAtFinalFrame  //FinishAtInitialFrame

        frameCount: nFrameCount       //帧的个数
        frameX: offsetIndex.x * sizeFrame.width; frameY: offsetIndex.y * sizeFrame.height     //起始位置
        frameWidth: sizeFrame.width; frameHeight: sizeFrame.height //帧的宽高
        frameDuration: interval     //切换速度

        onRunningChanged: {
            if(bTest)
                console.debug('!!!RunningChanged:', running, spriteSrc);
        }

        onSourceChanged: {
            running = false;
            currentFrame = 0;   //初始载入时 帧号为0（因为如果设置finishBehavior为FinishAtFinalFrame，则帧是最后一帧）
        }

        onFinished: {
            timerSound.stop();
            root.s_finished();
            if(bTest)
                console.debug('!!!onFinished:', loops, soundeffect.source, finished, spriteSrc);
        }

        //当前帧改变
        onCurrentFrameChanged: {
            //如果是循环播放（循环播放没有开始和结束信号）
            /*/if(loops === AnimatedSprite.Infinite) {
                //开始下一次播放音效
                if(currentFrame === 0) {    //开始信号
                    if(soundeffectName) {
                        timerSound.start();
                    }

                    if(frameCount === 1) {
                        timerInterval.interval = interval;
                        timerInterval.start();
                    }
                }
            //}*/
            if(currentFrame === 0)
                if(soundeffectName)
                    timerSound.restart();

            if(currentFrame === frameCount - 1) {    //结束信号
                root.s_looped();
            }

            if(bTest)
                console.debug('!!!onCurrentFrameChanged:', currentFrame);
        }

        //transformOrigin: Item.BottomRight
        transform: Scale {
            //x方向镜像
            xScale: root.rXScale
            origin.x: root.width / 2

            //y方向镜像
            yScale: root.rYScale
            origin.y: root.height / 2
        }
    }

    //闪烁（颜色）
    ColorOverlay {
        id: colorOverlay

        property var arrColors: ["#00000000", "#7FFF0000", "#7F00FF00", '#7F0000FF']
        property int nStep: 0
        property int nInterval: 500

        function start(colors=undefined, index=1) {
            if(colors)
                arrColors = colors;

            nStep = index;
            color = arrColors[nStep];
        }

        function stop() {
            nStep = 0;
            color = arrColors[nStep];
        }

        anchors.fill: animatedsprite
        source: animatedsprite
        color: "#00000000"

        Behavior on color {
            ColorAnimation {
                duration: colorOverlay.nInterval
                onRunningChanged: {
                    if(!running) {
                        if(colorOverlay.nStep === 0) {
                            colorOverlay.color = colorOverlay.arrColors[0];
                        }
                        else {
                            if(++colorOverlay.nStep === colorOverlay.arrColors.length)
                                colorOverlay.nStep = 1;
                            colorOverlay.color = colorOverlay.arrColors[colorOverlay.nStep];
                        }
                    }

                }
            }
        }

        //transformOrigin: Item.BottomRight
        transform: Scale {
            //x方向镜像
            xScale: root.rXScale
            origin.x: root.width / 2

            //y方向镜像
            yScale: root.rYScale
            origin.y: root.height / 2
        }
    }


    //鹰：play可以停止前面的播放，然后重新开始播放
    //给source赋值时，会从硬盘读取；start时内存才会增加!!
    //多个SoundEffect，同时赋值source会比同时start更卡；
    /*SoundEffect {
        id: soundeffect
        onStatusChanged: {
            //console.debug("~~~~~~~SoundEffect1", status);
        }
    }*/
    Audio {
        id: soundeffect
    }


    NumberAnimation {
        id: numberanimationSpriteEffectX
        target: root
        properties: "x"
        //to: 0
        //duration: 200
        easing.type: Easing.OutSine
    }
    NumberAnimation {
        id: numberanimationSpriteEffectY
        target: root
        properties: "y"
        //to: 0
        //duration: 200
        easing.type: Easing.OutSine
    }


    Timer {
        id: timerInterval

        interval: 0
        running: false
        triggeredOnStart: false
        repeat: false

        onTriggered: {
            //console.debug('timerInterval Triggerd:', spriteSrc);

            animatedsprite.stop();
            timerSound.stop();
            root.s_looped();
            root.s_finished();

            if(bTest)
                console.debug('!!!timerInterval onTriggered', interval);
        }
    }


    //音效延时
    Timer {
        id: timerSound

        interval: 0
        running: false
        triggeredOnStart: false
        repeat: false

        onTriggered: {
            if(nType === 1) {
                soundeffect.source =  GameMakerGlobal.soundResourceURL(root.soundeffectName);
                soundeffect.play();
            }
            else
                s_playEffect(root.soundeffectName);
        }
    }



    MouseArea {
        id: mouseArea
        property int nIndex: 0
        enabled: false

        anchors.fill: parent
        onClicked: {
            root.restart();
            //s_clicked();

            //console.debug('!!!start')
        }
    }


    /*Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Right:
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Left:
            sprite.running = true;
            event.accepted = true;
            break;
        case Qt.Key_Down:
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

    }*/

    Component.onCompleted: {

    }

    Component.onDestruction: {
        //root.unload();
    }
}
