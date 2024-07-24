import QtQuick 2.14
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

*/

Item {
    id: root


    //被点击
    //signal s_clicked();

    signal s_started();
    signal s_refreshed(int currentFrame);
    //每次播放结束
    signal s_looped();
    //停止播放
    signal s_finished();
    onS_finished: {
        //timerSound.stop();
        //root.s_finished();
        if(bTest)
            console.debug('!!!onFinished:', soundeffect.source, strSource);
    }
    signal s_paused();
    signal s_stoped();

    //播放音效
    signal s_playEffect(string soundeffectSource)



    //开始播放动画
    function start() {
        //console.debug('start:', animatedsprite.running, strSource)

        if(_private.nState === 1)
        //if(timerInterval.running)
            return;


        if(nType === 1 && soundeffect.playbackState === Audio.PausedState)
            soundeffect.play();

        if(_private.nState === 0)
            _private.init();
        timerInterval.start();

        _private.nState = 1;
    }

    //重新开始播放动画
    function restart() {
        //console.debug('restart:', animatedsprite.running, strSource)

        _private.init();
        timerInterval.restart();

        if(nType === 1)
            soundeffect.stop();

        _private.nState = 1;
    }

    function pause() {
        if(_private.nState === 2)
            return;

        timerSound.stop();
        timerInterval.stop();
        if(nType === 1 && soundeffect.playbackState === Audio.PlayingState)
            soundeffect.pause();

        _private.nState = 2;

        s_paused();
    }

    //停止动画
    function stop(stopSound=true) {
        if(_private.nState === 0)
            return;

        //console.debug('stop:', animatedsprite.running, strSource)
        timerInterval.stop();
        if(stopSound) {
            timerSound.stop();
            soundeffect.stop();
        }

        _private.nState = 0;

        s_stoped();
    }

    function refresh() {
        if(strSource === '')
            return;

        //imageAnimate.source = strSource + GameMakerGlobal.separator + root.fGetImageName(root.nCurrentFrame + root.nFrameStartIndex);
        //let [tx, ty] = root.fGetImageFixPosition(root.nCurrentFrame + root.nFrameStartIndex, _private.arrFixPositionsData) || [0, 0];
        imageAnimate.rXOffset = root.rXOffset;    // + parseInt(tx);
        imageAnimate.rYOffset = root.rYOffset;      // + parseInt(ty);

        if(GlobalLibraryJS.isFunction(fnRefresh))
            fnRefresh(root.nCurrentFrame + root.nFrameStartIndex, imageAnimate, strSource);
        else if(GlobalLibraryJS.isGenerator(genRefresh))
            genRefresh.next(root.nCurrentFrame + root.nFrameStartIndex);
    }

    function reset() {
        nCurrentFrame = 0;
        refresh();
    }

    function status() {
        return _private.nState;
    }

    function currentFrame() {
        return nCurrentFrame;
    }


    function colorOverlayStart(colors=undefined, index=1) {
        colorOverlay.start(colors=undefined, index=1);
    }
    function colorOverlayStop() {
        colorOverlay.stop();
    }



    readonly property int nSpriteType: 2

    property string strSource: ""   //精灵图片文件夹路径
    onStrSourceChanged: {
        root.stop();

        //currentFrame = 0;   //初始载入时 帧号为0（因为如果设置finishBehavior为FinishAtFinalFrame，则帧是最后一帧）


        if(strSource === '')
            return;

        if(GlobalLibraryJS.isGeneratorFunction(fnRefresh))
            fnRefresh = fnRefresh(imageAnimate, strSource);
        else
            genRefresh = null;
    }

    property int nFrameCount: 3 //一个方向有几张图片
    property alias nInterval: timerInterval.interval  //帧切换速度
    property int nLoops: 1  //循环次数
    property real rXScale: 1        //1为原图，-1为X轴镜像，其他值为X轴缩放
    property real rYScale: 1        //1为原图，-1为Y轴镜像，其他值为Y轴缩放
    property real rXOffset: 0       //x偏移
    property real rYOffset: 0       //y偏移


    property alias imageAnimate: imageAnimate
    //特效额外数据
    //property var arrSpriteExtraData: ({nFrameStartIndex: 0})
    //起始索引
    property int nFrameStartIndex: 0
    ////property point pointOffsetIndex: Qt.point(0, 0)  //行、列 偏移
    ////property size sizeFrame: Qt.size(0,0)     //一帧的宽高

    /*property string strOffsetPositionsFile
    onStrOffsetPositionsFileChanged: {
        _private.arrFixPositionsData = fGetImageFixPositions(strOffsetPositionsFile);
    }

    property var fGetImageName: function(n) {
        return String(n+1).padStart(5, '0') + '.png';
    }
    property var fGetImageFixPosition: function(n, arrFixPositionsData) {
        if(arrFixPositionsData)
            return arrFixPositionsData[n].split(' ');
        return null;
    }
    property var fGetImageFixPositions: function(path) {
        /*var request = new XMLHttpRequest();
        request.open("GET", '布衣_男/x.txt', false); // false为同步操作设置
        request.send(null);
        //console.debug(request.responseText);
        let data = request.responseText;
        * /

        let data = FrameManager.sl_fileRead(path);
        if(data)
            return data.split('\r\n');
        return null;
    }
    */
    //外部读取的刷新函数
    property var fnRefresh
    onFnRefreshChanged: {
        if(GlobalLibraryJS.isGeneratorFunction(fnRefresh))
            fnRefresh = fnRefresh(imageAnimate, strSource);
        else
            genRefresh = null;
    }
    //如果 fnRefresh 是生成器，则这是生成器对象
    property var genRefresh


    property alias mouseArea: mouseArea

    property alias bSmooth: imageAnimate.smooth
    property int nCurrentFrame: 0
    property alias bRunning: timerInterval.running
    //property bool bRunning: _private.nState === 1

    property int nType: 0   //0表示不播放音效，只是触发 播放信号；1表示本组件播放音频（win下如果太多，会卡顿）
    property string strSoundeffectName
    property alias nSoundeffectDelay: timerSound.interval


    property alias numberanimationSpriteEffectX: numberanimationSpriteEffectX
    property alias numberanimationSpriteEffectY: numberanimationSpriteEffectY

    property alias arrColorOverlayColors: colorOverlay.arrColors
    property alias nColorOverlayStep: colorOverlay.nStep
    property alias nColorOverlayInterval: colorOverlay.nInterval


    //测试，可以点击和显示调试信息
    property bool bTest: false


    width: implicitWidth
    height: implicitHeight

    //方案1/2：受root大小影响
    //implicitWidth: imageAnimate.implicitWidth
    //implicitHeight: imageAnimate.implicitHeight
    //方案2/2：不受root的大小影响（建议，因为root大小设置后会导致动画抖动，需要设置大小用缩放）
    implicitWidth: imageAnimate.sourceSize.width * Math.abs(root.rXScale)
    implicitHeight: imageAnimate.sourceSize.height * Math.abs(root.rYScale)

    smooth: false


    onNCurrentFrameChanged: {
        if(root.nCurrentFrame < 0)
            return;

        if(root.nCurrentFrame === root.nFrameCount) {
            ++_private.nLoopedCount;
            if(_private.nLoopedCount === root.nLoops) {
                root.stop(false);
                root.s_looped();
                root.s_finished();
                return;
            }
            else {
                root.s_looped();
                root.nCurrentFrame = 0;
            }
        }

        if(root.nCurrentFrame === 0) {
            root.s_started();

            if(strSoundeffectName)
                timerSound.restart();
        }

        root.s_refreshed(root.nCurrentFrame);

        refresh();
    }



    Item {
        id: itemAnimate

        width: root.width
        height: root.height

        transform: Scale {
            //x方向镜像
            xScale: root.rXScale
            //origin.x: imageAnimate.width / 2

            //y方向镜像
            yScale: root.rYScale
            //origin.y: imageAnimate.height / 2
        }


        Image {
            id: imageAnimate

            //总偏移
            property real rXOffset
            property real rYOffset
            //property alias rXOffset: itemAnimate.rXOffset
            //property alias rYOffset: itemAnimate.rYOffset

            property alias rXScale: root.rXScale
            property alias rYScale: root.rYScale


            x: rXOffset
            y: rYOffset

            //方案1/2：受root大小影响
            //width: root.width
            //height: root.height
            //方案2/2：不受root的大小影响（建议，因为root大小设置后会导致动画抖动，需要设置大小用缩放）
            width: sourceSize.width
            height: sourceSize.height

            //anchors.fill: parent
            //x: rXOffset * root.rXScale
            //y: rYOffset * root.rYScale
            //width: root.width; height: root.height     //一个帧的大小，会缩放
            //width: sourceSize.width * Math.abs(root.rXScale)
            //height: sourceSize.height * Math.abs(root.rYScale)

            //鹰：使用中央偏移，会导致图片抖动（可能是因为anchors擅自调整了坐标）
            //anchors.centerIn: parent
            //anchors.horizontalCenterOffset: rXOffset
            //anchors.verticalCenterOffset: rYOffset
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter

            smooth: false

            //鹰：!!!光使用 Scale 缩放，也会导致抖动；所以只能用这种方式（x、y、width、height 乘以比例，加上镜像来实现）
            //transformOrigin: Item.BottomRight
            /*transform: Scale {
                //x方向镜像
                xScale: root.rXScale > 0 ? 1 : -1
                //origin.x: imageAnimate.width / 2

                //y方向镜像
                yScale: root.rYScale > 0 ? 1 : -1
                //origin.y: imageAnimate.height / 2
            }
            */
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

            anchors.fill: imageAnimate
            source: imageAnimate
            color: "#00000000"
            visible: color.a !== 0

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
            /*transform: Scale {
                //x方向镜像
                xScale: root.rXScale > 0 ? 1 : -1
                //origin.x: imageAnimate.width / 2

                //y方向镜像
                yScale: root.rYScale > 0 ? 1 : -1
                //origin.y: imageAnimate.height / 2
            }
            */
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
        triggeredOnStart: true
        repeat: true

        onTriggered: {
            ++root.nCurrentFrame;

            //console.debug('timerInterval Triggerd:', strSource);
            if(bTest)
                console.debug('!!!timerInterval onTriggered', interval, root.nCurrentFrame);

        }

        onRunningChanged: {
            if(bTest)
                console.debug('!!!RunningChanged:', running, strSource);
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
                soundeffect.source = GameMakerGlobal.soundResourceURL(root.strSoundeffectName);
                soundeffect.play();
            }
            else
                s_playEffect(root.strSoundeffectName);
        }
    }



    MouseArea {
        id: mouseArea

        property int nIndex: 0

        enabled: false

        anchors.fill: parent
        onClicked: {
            if(_private.nState === 1)
                root.stop();
            else
                root.restart();
            //s_clicked();

            //console.debug('[DirSpriteEffect]start')
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


    QtObject {  //私有数据,函数,对象等
        id: _private


        //0：stop，1：播放，2：暂停
        property int nState: 0


        //播放循环次数
        property int nLoopedCount;

        //property var arrFixPositionsData: null


        //第一次播放前初始化
        function init() {
            root.nCurrentFrame = -1;
            _private.nLoopedCount = 0;
        }

        function play() {
        }
    }



    Component.onCompleted: {
        console.debug('[DirSpriteEffect]Component.onCompleted:', Qt.resolvedUrl('.'));
    }

    Component.onDestruction: {
        //root.unload();
    }
}
