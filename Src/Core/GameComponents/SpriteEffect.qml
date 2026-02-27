import QtQuick 2.15
import QtMultimedia 5.14
import QtGraphicalEffects 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'



/*

    //!!!！！！鹰：Loader内嵌套FileSpriteEffect：
    //    不知为何 设置Loader 的width和height会导致无限创建特效（但是不会提醒），会导致特别卡，然后报错：
    //  【Warning】SpriteEngine: Too many animations to fit in one texture...
    //  【Warning】SpriteEngine: Your texture max size today is 16384
    //spriteEffectComp.width = parseInt(data.SpriteSize[0]);
    //spriteEffectComp.height = parseInt(data.SpriteSize[1]);

    设计思路：
      之前（因为上面的bug）：Role 的大小 是SpriteEffect（Loader）的大小，Loader的大小默认就是子组件的大小
        所以设置大小时，设置 FileSpriteEffect/DirSpriteEffect 组件的 大小即可；
      目前：解决了上面的Bug，所以可以设置Role和SpriteEffect大小了。
*/

Loader {
    id: root


    Component {
        id: compFileSpriteEffect

        FileSpriteEffect {
            //anchors.fill: parent

            smooth: root.smooth

            strSource: root.strSource   //精灵图片路径
            onStrSourceChanged: {
                root.strSource = this.strSource;
            }

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
            //nCurrentFrame: root.nCurrentFrame
            //bRunning: root.bRunning

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


            onSg_started: root.sg_started()
            onSg_refreshed: root.sg_refreshed(currentFrame)
            onSg_looped: root.sg_looped()
            onSg_finished: root.sg_finished()
            onSg_paused: root.sg_paused()
            onSg_stoped: root.sg_stoped()

            onSg_playSoundEffect: root.sg_playSoundEffect(soundeffectSource)


            Component.onCompleted: {
                //root.sg_stoped();
            }
        }
    }

    Component {
        id: compDirSpriteEffect

        DirSpriteEffect {
            //anchors.fill: parent
            //width: implicitWidth
            //height: implicitHeight

            smooth: root.smooth

            strSource: root.strSource   //精灵图片路径
            onStrSourceChanged: {
                root.strSource = this.strSource;
            }
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
            //nCurrentFrame: root.nCurrentFrame
            //bRunning: root.bRunning

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


            onSg_started: root.sg_started()
            onSg_refreshed: root.sg_refreshed(currentFrame)
            onSg_looped: root.sg_looped()
            onSg_finished: root.sg_finished()
            onSg_paused: root.sg_paused()
            onSg_stoped: root.sg_stoped()

            onSg_playSoundEffect: root.sg_playSoundEffect(soundeffectSource)


            Component.onCompleted: {
                //root.sg_stoped();
            }
        }
    }



    function start() {
        if(item)
            return item.start();
    }
    function restart() {
        if(item)
            return item.restart();
    }
    function pause() {
        if(item)
            return item.pause();
    }
    function stop(stopSound=true) {
        if(item)
            return item.stop(stopSound);
    }
    function refresh() {
        if(item)
            return item.refresh();
    }
    function reset() {
        if(item)
            return item.reset();
    }
    function status() {
        if(item)
            return item.status();
    }
    function currentFrame() {
        if(item)
            return item.currentFrame();
    }
    function setCurrentFrame(index) {
        if(item)
            return item.setCurrentFrame(index);
    }



    signal sg_started();
    signal sg_refreshed(int currentFrame);
    //每次播放结束
    signal sg_looped();
    //停止播放
    signal sg_finished();
    signal sg_paused();
    signal sg_stoped();

    //播放音效
    signal sg_playSoundEffect(string soundeffectSource)



    //1：经典行列图；2：序列图片文件；
    property int nSpriteType: -1

    property string strSource: ''   //精灵图片路径
    onStrSourceChanged: {
        if(item)
            item.strSource = this.strSource;
    }
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
    //property int nCurrentFrame: 0
    //property bool bRunning: false

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


    clip: true
    width: if(parent)parent.width
    height: if(parent)parent.height

    //implicitWidth: item.implicitWidth
    //implicitHeight: item.implicitHeight

    smooth: false


    asynchronous: false

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
