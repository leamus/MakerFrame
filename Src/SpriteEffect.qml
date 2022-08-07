import QtQuick 2.15
import QtMultimedia 5.14

/*

  鹰：由于Sprite的source和 frameX、 frameY 修改无效，所以只能用Component进行创建，使用refresh进行删除重建。

*/

Item {
    id: root

    property string spriteSrc: ""   //精灵图片
    property size sizeFrame: Qt.size(0,0)     //一帧的宽高
    property int nFrameCount: 3 //一个方向有几张图片
    property int interval: 100  //帧切换速度
    property point offsetIndex: Qt.point(0, 0)  //上右下左 的 行、列 偏移
    property real rXScale: 1        //1为原图，-1为X轴镜像，其他值为X轴缩放
    property real rYScale: 1        //1为原图，-1为Y轴镜像，其他值为Y轴缩放

    property alias animatedsprite: animatedsprite

    property alias soundeffectSrc: soundeffect.source
    property alias soundeffectDelay: timer.interval


    property alias test: mouseArea.enabled


    //每次播放结束
    signal s_finished();


    //开始播放动画
    function start() {
        if(animatedsprite.running)
            return;

        animatedsprite.start();

        if(soundeffect.source)
            timer.start();
    }

    //停止动画
    function stop() {
        animatedsprite.stop();
        timer.stop();
    }

    //重新开始播放动画
    function restart() {
        animatedsprite.restart();

        soundeffect.stop();

        if(soundeffect.source)
            timer.restart();
    }


    //width: 0
    //height: 0

    //implicitWidth: width
    //implicitHeight: height


    AnimatedSprite {

        id: animatedsprite

        width: root.width; height: root.height     //一个帧的大小，会缩放

        anchors.horizontalCenter: parent.horizontalCenter

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
        }

        onSourceChanged: {
            currentFrame = 0;   //初始载入时 帧号为0（因为如果设置finishBehavior为FinishAtFinalFrame，则帧是最后一帧）
        }

        onFinished: {
            //console.debug("finished:", loops, soundeffect.source)
            root.s_finished();
        }

        //当前帧改变
        onCurrentFrameChanged: {
            //如果是循环播放（循环播放没有开始和结束信号）
            //if(loops === AnimatedSprite.Infinite) {
                //开始下一次播放音效
                if(currentFrame === 0) {    //开始信号
                    if(soundeffect.source) {
                        timer.start();
                    }
                }
                else if(currentFrame === frameCount - 1)    //结束信号
                    root.s_finished();
            //}
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

    SoundEffect {
        id: soundeffect
    }

    Timer {
        id: timer
        interval: 0
        running: false
        triggeredOnStart: false
        repeat: false

        onTriggered: {
            soundeffect.play();
        }
    }



    MouseArea {
        id: mouseArea
        property int nIndex: 0
        enabled: false

        anchors.fill: parent
        onClicked: {
            root.start();
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
