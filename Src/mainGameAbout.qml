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
        width: parent.width * 0.96
        height: parent.height * 0.96
        anchors.centerIn: parent

        Notepad {
            id: msgBox

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            textArea.background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: "#80000000"
                //border.color: debugMsg.textArea.enabled ? "#21be2b" : "transparent"
            }
            textArea.color: 'white'
            textArea.readOnly: true

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



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
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

  鹰歌MakerFrame框架 是一款 使用Qt/QML/JAVA 构建的供二次开发的软件/游戏的制作及运行的跨平台框架，它提供了跨平台、屏幕自适应、网络、热更新、数据库、文件管理、媒体播放器、浏览器内核等众多功能和扩展，可以用来开发很多种软件、游戏和引擎等；
  鹰歌RPG Maker引擎 是基于 鹰歌MakerFrame框架 开发的一套 RPG/放置类 游戏制作引擎和运行环境，使用QML/JS编写，适用于开发游戏和插件，可使用可视化、代码或两者结合的方式；

  QQ群：654876441


  作者的话
由于时间精力经济问题，鹰歌MakerFrame和RPG Maker引擎 的完成度还不错（除了UI），框架基本完成，游戏引擎只有RPG类型（兼容放置类），目前已基本完善，除了界面丑陋，体验有点差以外，功能、扩展、自由度都还不错，可视化编辑器也已经完成，很多细节和功能也正在完善和优化，同时也希望有人能参与一起完善框架和引擎。
目前用鹰歌有三种方式来制作游戏（其实并不局限于这三种方式，因为它的用法是针对每种类型每个对象都可以不同，比如你某个道具可以用脚本，另一个道具可以用可视化，技能之间也可以不同，自由度非常高）：
    1、纯可视化，这种是最简单，最快速的方法，缺点是功能固化，模式单一；
    2、纯写脚本，引擎只需会JavaScript（有一点QML基础更好）就行，优点是开放度、自由度、功能性非常高，技术上不封顶，缺点是稍微稍难一点。
    3、可视化+脚本混合，我非常推荐的一种方法，可以逐渐深入引擎并编写各种功能和玩法，方法是某个对象（道具、技能或人物等）可以用可视化生成一个代码模板，然后在此基础上修改，但注意某个可视化对象一旦重新编辑编译，会替换你对应改好的脚本（其实生成后不用再动可视化，而且对象粒度很小）。

  安装教程
1. Windows版本：解压 MakerFrame_鹰歌框架引擎_win_x64_vXXX 或 MakerFrame_鹰歌框架引擎_win_x86_vXXX，双击“_运行鹰歌.bat”。
2. 安卓：安装运行 MakerFrame_鹰歌框架引擎_armeabi-v7a_vXXX 或 MakerFrame_鹰歌框架引擎_arm64-v8a_vXXX 即可。
3. 苹果IOS、MACOS、Linux（RedHat和Debain及其各种分支、x86、arm架构相关）等：已经适配，不过用户人太少（IOS又付费），所以没开放。
4. 打开软件后，进入RPGMaker主界面，再点击 示例工程，请等待下载完毕后，点击 开始运行-》运行 就OK了。
5. 各平台软件都是热更新（内核、引擎和Java代码），大部分情况下无需额外操作（服务器带宽较慢，可能升级和下载时间会稍微长一点）。

  功能和特色：
1.跨平台：框架、编辑器和游戏都可完美运行在win、安卓、macos、ios、linux（包括x86、arm的Ubuntu、国产化统信UOS、树莓派）等平台；
2.可联网：框架有后台服务器和数据库，可做注册登录、聊天、房间、联机对战等功能，且都是跨平台共用的；
3.多种发布形式：能生成对应平台的安装包exe、apk等（可发布在steam、taptap等平台），也可生成框架可载入的游戏资源ROM；资源和代码可原样提供，也可压缩打包，防逆向盗取；ROM可分发到各平台，或上传到官网，用链接、二维码、分享等形式来载入运行）；
4.框架热更新：框架底层采用我编写的升级载入运行器，可对C++编写的库、Java编写的安卓代码、QML编写的编辑器和游戏，无感自动热更新，不用繁琐的下载和重新安装；
5.屏幕自适应：在任何分辨率，各种不同大小的屏幕下有相同的显示效果；提供了不同的方式来应对各种屏幕（比如按比例简单缩放、按固定size显示、按布局方式排列等）；
6.技术层：
  采用最流行的javascript语言写编辑器、游戏脚本和扩展；js引擎是谷歌v8（非H5），运行效率高；
  能用c++、java（安卓）等本地语言来封装接口给js调用（比如 震动、gps等功能）；
  后端是C++和iocp高并发模型的服务，已封装常用功能（登录、聊天、群组、帧同步等），可万人同时在线；
  通信协议可支持TCP、UDP和HTTP三种常用协议；
  支持主流的图片、音乐和视频播放；
  内置一个Web浏览器引擎；
  存储采用远程mysql和本地sqlite（加密和未加密两种）；
  理论上几乎支持所有2d游戏类型(比如已有的RPG和放置、ARPG、AVG、即时战略、战棋、棋牌等等)的网络和单机游戏，3D的需要QML 3D来自行学习和设计（因为我对3D不了解）；
  引擎已集成qnanopainter库，基于opengl的QPaint方式绘图，绘图效率非常高，qml哪个组件不顺眼完全可以用它来替换；
  以上功能大都已封装为js扩展来进行调用；


  架构设计：
1、鹰歌MakerFrame框架 使用Qt（C++）、Java、QML（JavaScript）来构建的（包含跨平台、联网、打包、底层功能等）；
2、鹰歌RPG Maker引擎 基于 鹰歌MakerFrame框架，使用QML来构建游戏制作引擎和运行环境（如RPG的 地图编辑器、角色编辑器、道具编辑器、升级链编辑器、特效编辑器、战斗编辑器、音乐编辑器等）。
3、此框架引擎重点在于打造手持端（兼容PC、MAC等跨端）和国产化系统的游戏框架引擎，专业的还请绕道U3D、虚幻等更好的引擎；
4、此框架适合：
    a、非专业人士；想任意端编写（主要是手机）、任意端运行（Win、安卓、Linux、苹果等）、且可发布在steam、taptap等平台的游戏；
    b、学习Javascript、QML或编写引擎的：鹰歌是个不错的宿主环境，可以在底层或业务层进行任意扩展；
    c、技术爱好者：鹰歌在功能上来说是一款非常丰富的超级APP，它包括了游戏制作、多媒体播放、网络、数据库、浏览器、图形绘制、热更新 等功能，又有跨平台、自适应等特点，很适合用来研究技术；
5、功能分层：
    a、上层（纯可视化开发）：脚本使用纯可视化来写，只需设计 剧情、道具、地图、人物、战斗 等等就可以做出游戏，后期还可能做Excel、Json等来设计游戏内容，框架导入来生成游戏；
    b、中层（可视化+JS代码）：用JS代码来扩展可视化，可以开发和设计更多的内容，比如游戏的算法、界面效果、升级链、道具、人物、登录、联网功能、可视化命令 等等；
    c、底层（QML+JS）：用QML语言来扩展界面，比如制作插件、修改引擎和编辑器、甚至可以做其他类型的游戏引擎、编辑器和游戏，还可以做各种类型的软件APP（系统软件、业务软件、播放器、浏览器等）；
    d、内核/扩展层：一般我来维护，包括了跨平台、联网基础、资源整合与打包、屏幕自适应、自升级、压缩解压、文件下载、编译打包、平台分发、二维码、三方SDK、微信相关、支付 等；
6、未来：
    a、RPG Maker完成后，还会继续开发ARPG Maker、卡牌类Maker、战旗类Maker、AVG Maker等（都是我喜欢的游戏类型），希望能有志同道合的朋友一起加入进来~；
    b、优化引擎：引入缓存机制，并将QML中效率不高的图形引擎替换为OpenGL；
    c、支持3D；
    d、支持Tap上架；


  特别鸣谢
    1、荔竹的策划和demo游戏工程；
    2、吾爱的代码版测试、建议和他的游戏工程；
    3、落雪的可视化测试、建议和他的游戏工程；



  技术方面（乱写的）：
    1、跨平台，包括Windows、Linux（Ubuntu）MacOS、IOS、Android（Java、JNI）开发；
      安卓：包括两种JNI调用方式、权限、亮度、震动、GPS、锁屏 等；
    2、IOCP模型高并发、TCP（Socket的加解密）、UDP；
    3、dbghelp（奔溃/异常退出拦截，日志和提示）；
    4、日志 和 qDebug输出拦截；
    5、耗时任务 多线程+异步 完成（MessageHandlerInfo写日志 和 数据库 读写）；
    6、屏幕自适应；
    7、热更新；
    8、exe、动态链接库 的加载器；
    9、SQLite（加密）和MySql（Json字段的增删查改）；
    10、CPU、硬盘、主板等序列号获取、加密（注册码制作）；
    11、静态、动态库（lib、dll、a、so等）的编写和使用；
    12、池 模型；
    13、生产、消费者模型；
    14、随系统启动、奔溃重启；
    15、QML（包括一些算法、JSEngine库、 Async异步脚本队列、队列信号事件调用、QQuickPaintedItem、C++执行脚本 等实现）、；
    16、qnanopainter库，基于opengl的QPaint方式绘图，绘图效率非常高！
    17、多媒体播放（包括精灵、图片、音频、视频）；
    18、手机浏览器；

    19、Qt基础：
      事件、信号和槽；QSettings 和 自定义类型的读写；pro文件的配置等；
    20、JS、QML、Qt类型、对象互转、互相访问，QDataStream、QByteArray、QString使用和发送；JS对象和JSON互转和发送等；
    21、HTTP网络访问(NetworkAccessManager)；
    22、单例类、二进制兼容写法（d指针）；
    23、多线程 和 控制；
    24、图形特效、动画；
    25、new和delete的重载、扩展（在IOCP源码中）；

    26、模型和视图(QTable)；
    27、托盘；
    28、窗体样式、响应方式；

    其他：
    MQTT、串口通信；
    CRC16；
    读写Excel；
`
        msgBox.text = GlobalLibraryJS.convertToHTML(t);
    }
}
