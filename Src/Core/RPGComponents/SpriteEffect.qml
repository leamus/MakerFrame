import QtQuick 2.15
import QtMultimedia 5.14
import QtGraphicalEffects 1.0


import _Global 1.0
import _Global.Button 1.0


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

Loader {
    id: root


    Component {
        id: compFileSpriteEffect

        FileSpriteEffect {
            smooth: root.smooth

            strSource: root.strSource   //精灵图片路径
            nFrameCount: root.nFrameCount //帧数
            nInterval: root.nInterval  //帧切换速度
            nLoops: root.nLoops //循环次数
            rXScale: root.rXScale        //1为原图，-1为X轴镜像，其他值为X轴缩放
            rYScale: root.rYScale        //1为原图，-1为Y轴镜像，其他值为Y轴缩放
            rXOffset: root.rXOffset   //x偏移
            rYOffset: root.rYOffset   //y偏移


            //property alias animatedsprite: animatedsprite
            //property size sizeFrame: Qt.size(0,0)     //一帧的宽高
            //property point pointOffsetIndex: Qt.point(0, 0)  //行、列 偏移


            //property alias mouseArea: mouseArea

            bSmooth: root.bSmooth
            nCurrentFrame: root.nCurrentFrame
            bRunning: root.bRunning

            nType: root.nType   //0表示不播放音效，只是触发 播放信号；1表示本组件播放音频（win下如果太多，会卡顿）
            strSoundeffectName: root.strSoundeffectName
            nSoundeffectDelay: root.nSoundeffectDelay


            //property alias numberanimationSpriteEffectX: numberanimationSpriteEffectX
            //property alias numberanimationSpriteEffectY: numberanimationSpriteEffectY

            //property alias arrColorOverlayColors: colorOverlay.arrColors
            nColorOverlayStep: root.nColorOverlayStep
            nColorOverlayInterval: root.nColorOverlayInterval


            //测试，可以点击和显示调试信息
            bTest: root.bTest


            onS_looped: root.s_looped()
            onS_finished: root.s_finished()
            onS_playEffect: root.s_playEffect(soundeffectSource)
        }
    }

    Component {
        id: compDirSpriteEffect

        DirSpriteEffect {
            smooth: root.smooth

            strSource: root.strSource   //精灵图片路径
            nFrameCount: root.nFrameCount //帧数
            nInterval: root.nInterval  //帧切换速度
            nLoops: root.nLoops //循环次数
            rXScale: root.rXScale        //1为原图，-1为X轴镜像，其他值为X轴缩放
            rYScale: root.rYScale        //1为原图，-1为Y轴镜像，其他值为Y轴缩放
            rXOffset: root.rXOffset   //x偏移
            rYOffset: root.rYOffset   //y偏移


            //property alias animatedsprite: animatedsprite
            //property size sizeFrame: Qt.size(0,0)     //一帧的宽高
            //property point pointOffsetIndex: Qt.point(0, 0)  //行、列 偏移


            //property alias mouseArea: mouseArea

            bSmooth: root.bSmooth
            nCurrentFrame: root.nCurrentFrame
            bRunning: root.bRunning

            nType: root.nType   //0表示不播放音效，只是触发 播放信号；1表示本组件播放音频（win下如果太多，会卡顿）
            strSoundeffectName: root.strSoundeffectName
            nSoundeffectDelay: root.nSoundeffectDelay


            //property alias numberanimationSpriteEffectX: numberanimationSpriteEffectX
            //property alias numberanimationSpriteEffectY: numberanimationSpriteEffectY

            //property alias arrColorOverlayColors: colorOverlay.arrColors
            nColorOverlayStep: root.nColorOverlayStep
            nColorOverlayInterval: root.nColorOverlayInterval


            //测试，可以点击和显示调试信息
            bTest: root.bTest


            onS_looped: root.s_looped()
            onS_finished: root.s_finished()
            onS_playEffect: root.s_playEffect(soundeffectSource)
        }
    }



    property var start: function() {
        if(item)
            return item.start();
    }
    property var restart: function() {
        if(item)
            return item.restart();
    }
    property var pause: function() {
        if(item)
            return item.pause();
    }
    property var stop: function(stopSound=true) {
        if(item)
            return item.stop(stopSound);
    }
    property var refresh: function() {
        if(item)
            return item.refresh();
    }
    property var reset: function() {
        if(item)
            return item.reset();
    }



    //每次播放结束
    signal s_looped();
    //停止播放
    signal s_finished();

    //播放音效
    signal s_playEffect(string soundeffectSource)



    property int nSpriteType: 0

    property string strSource: ""   //精灵图片路径
    property int nFrameCount: 3 //帧数
    property int nInterval: 100  //帧切换速度
    property int nLoops: AnimatedSprite.Infinite //循环次数
    property real rXScale: 1        //1为原图，-1为X轴镜像，其他值为X轴缩放
    property real rYScale: 1        //1为原图，-1为Y轴镜像，其他值为Y轴缩放
    property real rXOffset: 0   //x偏移
    property real rYOffset: 0   //y偏移


    //property alias sprite: item
    readonly property var sprite: item

    readonly property var mouseArea: item ? item.mouseArea : null

    property bool bSmooth: false
    property int nCurrentFrame: 0
    property bool bRunning: false

    property int nType: 0   //0表示不播放音效，只是触发 播放信号；1表示本组件播放音频（win下如果太多，会卡顿）
    property string strSoundeffectName: ''
    property int nSoundeffectDelay: 0


    property var numberanimationSpriteEffectX: item ? item.numberanimationSpriteEffectX : null
    property var numberanimationSpriteEffectY: item ? item.numberanimationSpriteEffectY : null

    property var arrColorOverlayColors: item ? item.arrColorOverlayColors : null
    property int nColorOverlayStep: 0
    property int nColorOverlayInterval: 500


    //测试，可以点击和显示调试信息
    property bool bTest: false


    //是否准备开始（不适用系统的running是因为系统先调用current）
    //property bool bStartToRunning: false


    //width: 0
    //height: 0

    //implicitWidth: item.implicitWidth
    //implicitHeight: item.implicitHeight

    smooth: false


    sourceComponent: {
        switch(nSpriteType) {
        case 1:
            return compFileSpriteEffect;
        case 2:
            return compDirSpriteEffect;
        default:
            //return compWalkSprite;
            return undefined;
        }
    }



    onLoaded: {
        console.debug('[SpriteEffect]onLoaded', nSpriteType, item);
    }


    Component.onCompleted: {
        console.debug('[SpriteEffect]Component.onCompleted:', Qt.resolvedUrl('.'));
    }

    Component.onDestruction: {
        //root.unload();
    }
}
