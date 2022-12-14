import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root

    signal s_close();


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        width: parent.width * 0.9
        height: parent.height * 0.95
        anchors.centerIn: parent

        Notepad {
            id: msgBox

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: parent.height - 50
            Layout.fillHeight: true


            textArea.background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: "#80000000"
                //border.color: debugMsg.textArea.enabled ? "#21be2b" : "transparent"
            }
            textArea.color: 'white'
            //textArea.readOnly: true

            textArea.selectByMouse: false

            textArea.font {
                pointSize: 15
            }

            text: ''
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "返回"
            onButtonClicked: {
                s_close();
            }
        }
    }



    Loader {
        id: loader

        source: "./GameScene.qml"
        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            //item.testFresh();
            console.debug("[mainGameAbout]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;
            }
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[mainGameAbout]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGameAbout]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameAbout]:key:", event, event.key, event.text)
    }



    QtObject {
        id: _private

    }

    //配置
    QtObject {
        id: config
    }





    Component.onCompleted: {
        let t = `
<CENTER><B>关于</B></CENTER>

  MakerFrame是一款 使用Qt/QML/JAVA构建的供二次开发的软件/游戏的制作及运行的跨平台框架。


  作者的话
由于时间精力经济问题，MakerFrame的完成度离理想目标还很远，框架完成度80%，游戏引擎只有RPG正在编写，且BUG很多，人性化不足，界面丑陋，难度高，教程少，可视化编辑器也没有完成，很多细节和功能也正在完善，所以不适合初学者，发布这个半成品是希望有人能参与，可以一起完善框架，也可用它试着编写游戏来反馈给我。
写脚本、引擎只需会JavaScript（有一点QML基础更好）就行，等可视化脚本完成，初学者也可以上手了。
框架目标：
1.此框架引擎重点在于打造手持端和国产化系统的游戏框架引擎，专业的还请绕道U3D、虚幻等更好的引擎；
2.此框架适合：非专业人士；想任意端编写，任意端运行（Win、安卓、Linux、苹果等）的游戏；学习Javascript、QML或编写引擎的；
QQ群：654876441


  软件架构
使用Qt和Java来构建整个框架（包括跨平台、联网、打包、底层功能等），使用QML来构建游戏引擎和编辑器（如RPG的 地图编辑器、角色编辑器、道具编辑器、升级链编辑器、特效编辑器、战斗编辑器、音乐编辑器等）


  安装教程
1. Windows版本：将 “鹰歌Maker_v1.0.rar”和 “Qt5.15.2_mingw81_32.rar”解压到同一个文件夹，双击“运行.bat”。
2. 安卓：安装运行即可。
3. 苹果IOS、MACOS、Linux相关：敬请期待适配。
4. 打开软件后，点击 鹰歌Maker 按钮，再点击 示例工程，请等待下载完毕后，点击 开始运行-》运行 就OK了。
5. 各平台软件都是热更新，无需额外操作（服务器带宽较慢，可能升级和下载时间会稍微长一点）。


  功能和特色：
1.跨平台：框架、编辑器和游戏都可完美运行在win、安卓、macos、ios、linux（包括x86、arm的Ubuntu、国产化统信UOS、树莓派）等平台；
2.可联网：框架有后台服务器和数据库，可做注册登录、聊天、房间、联机对战等功能，且都是跨平台共用的；
3.多种发布形式：能生成对应平台的安装包exe、apk等，也可生成框架可载入的游戏资源ROM；资源和代码可原样提供，也可压缩打包，防逆向盗取；ROM可分发到各平台，或上传到官网，用链接、二维码、分享等形式来载入运行）；
4.框架热更新：框架底层采用我编写的升级载入运行器，可对C++编写的库、Java编写的安卓代码、QML编写的编辑器和游戏，无感自动热更新，不用繁琐的下载和重新安装；
5.屏幕自适应：在任何分辨率，各种不同大小的屏幕下有相同的显示效果；提供了不同的方式来应对各种屏幕（比如按比例简单缩放、按固定size显示、按布局方式排列等）；
6.技术层：
  采用最流行的javascript语言写编辑器、游戏脚本和扩展；js引擎是谷歌v8（非H5），运行效率高；
  能用c++、java（安卓）等本地语言来封装接口给js调用（比如 震动、gps等功能）；
  后端是C++和iocp高并发模型的服务，可万人同时在线；
  存储采用远程mysql和本地sqlite；
  理论上几乎支持所有类型(rpg、3d等)的网络和单机游戏；
  以上功能都已封装为js扩展来进行调用；


  功能分层：
最上层：可视化，只需设计剧情、道具、地图、人物等等就可以做出游戏，预计后期还会做Excel来设计游戏内容，框架导入来生成游戏；
中层：代码级别，可以设计游戏的算法、界面效果、升级链、道具类型、登录、联网功能等等；
底层：编辑器级别，可以随意修改编辑器，甚至可以做其他类型的游戏编辑器和游戏；
内核层：我来维护，包括了跨平台、联网基础、资源整合和打包、屏幕自适应、自升级、压缩解压、文件下载、编译打包、平台分发、二维码等；


  未来：
1、RPG Maker完成后，还会继续开发ARPG Maker、卡牌类Maker、战旗类Maker、AVG Maker等（都是我喜欢的游戏类型），希望能有志同道合的朋友一起加入进来~；
2、优化引擎：引入缓存机制，并将QML中效率不高的图形引擎替换为OpenGL；



  技术方面（乱写的）：
1、跨平台，包括Windows、Linux（Ubuntu）MacOS、IOS、Android（Java、JNI）开发；
2、IOCP模型高并发、TCP（Socket的加解密）、UDP；
3、dbghelp（奔溃/异常退出拦截，日志和提示）；
4、日志 和 qDebug输出拦截；
5、耗时任务多线程完成（MessageHandlerInfo写日志 和 数据库 读写）；
6、屏幕自适应；
7、热更新；
8、exe、动态链接库 的加载器；
9、SQLite（加密）和MySql（Json字段的增删查改）；
10、CPU、硬盘、主板等序列号获取、加密（注册码制作）；
11、静态、动态库（lib、dll、a、so等）的编写和使用；
12、池；
13、生产、消费者模型；
14、随系统启动、奔溃重启；

15、事件、信号和槽；
16、QSettings 和 自定义类型的读写；
17、QML；
18、JS、QML、Qt类型、对象互转、互相访问，QDataStream、QByteArray、QString使用和发送；JS对象和JSON互转和发送等；
19、HTTP网络访问(NetworkAccessManager)；
20、单例类、二进制兼容写法（d指针）；
21、多线程 和 控制；
22、图形特效、动画；
23、new和delete的重载、扩展（在IOCP源码中）；

24、模型和视图(QTable)；
25、托盘；
26、窗体样式、响应方式；
`
        msgBox.text = t.replace(/ /g, "&nbsp;").
            //replace(/\</g, "&lt;").replace(/\>/g, "&gt;").
            replace(/\n/g, "<BR>");
    }
}
