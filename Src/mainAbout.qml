﻿import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
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


            text: ''

            textArea.color: 'white'
            //textArea.color: Global.style.foreground
            //textArea.enabled: false
            textArea.readOnly: true

            //textArea.selectByMouse: false

            textArea.font {
                pointSize: 15
            }

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: '#80000000'
                //color: 'transparent'
                //color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }

        Button {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: '返　回'
            onClicked: {
                sg_close();
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainAbout]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainAbout]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainAbout]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainAbout]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        const t = `
<CENTER><B>关　于</B></CENTER>

  简介
1.鹰歌软件框架MakerFrame 是一款由 Qt（C++）、QML（JavaScript）、JAVA（Android） 构建，供二次开发软件和游戏的开放式跨平台框架，它可以运行在Windows、Android、iOS、macOS、Linux（Debian、Ubuntu以及国产化的Openkylin、UOS）等主流平台上，并提供了上架应用商店、广告接口、网络（各种协议和下载）、资源整合打包、屏幕自适应、热更新、数据库、几种图形引擎、文件（夹）操作、压缩解压、进程、线程池、异步脚本（协程）、JS脚本引擎、脚本/事件队列、项目打包生成、平台分发上架、媒体播放器、浏览器内核、以及各种三方库和SDK等丰富的底层功能和扩展，能满足各种软件开发和多种类型的引擎及游戏的一款超级APP；
2.鹰歌游戏引擎GameMaker 是基于 鹰歌软件框架MakerFrame 开发的一套开放式（支持RPG、ARPG、策略与战旗、文字AVG、放置类等几乎所有2D类型）游戏开发引擎和运行环境，主要由QML（JavaScript）编写，支持图形化编辑器（如 地图编辑器、角色编辑器、特效编辑器、道具编辑器、技能编辑器、战斗人物编辑器、战斗脚本编辑器、升级链编辑器、图片音乐视频管理、图形化脚本编程等）、代码或两者结合的方式来设计游戏和开发插件；

  QQ：85885245


  作者的话
1.鹰歌软件框架MakerFrame底层已经完善，游戏引擎目前完成了 RPG/ARPG/文字AVG/放置/策略与战旗 等类型，其功能、扩展性、自由度都非常不错，还提供了完整可扩展的图形化编程和各类图形化编辑器，但很多细节和功能仍然正在完善和优化（由于时间精力和经济问题导致UI和操作体验不太完美），同时也欢迎有志同道合的朋友能参与一起开发。
2.鹰歌游戏引擎GameMaker有三种方式来开发设计（其实并不局限于这三种方式，因为它的用法是针对每种类型每个对象都可以不同，比如你某个道具可以用脚本，另一个道具可以用图形化编辑，其他类型和对象也是如此，所以自由度非常高）：
  a、纯图形化编辑：这种是最简单、最快速的方法（主要是照顾纯小白），缺点是功能固化，模式单一；
  b、纯写脚本：引擎只需会JavaScript（有一点QML基础更好）就行，优点是开放度、自由度、功能性非常高，技术上不封顶，缺点是比图形化稍难一些（适合大神用）；
  c、图形化编辑+脚本混合：我非常推荐的一种方法，可以逐渐深入框架引擎并熟悉编写各种功能和玩法，方法是先用图形化编辑生成一个代码模板（道具、技能或人物等某个对象），然后在此基础上修改，但注意某个图形化编辑对象一旦被修改并重新编译，会替换掉原来对应的脚本（其实大多数情况下生成后不用再图形化编辑，或者要编辑也只是某个对象而已，而且不会影响其他对象）。


  安装教程
1.Windows版本：将Qt环境（Qt_v5.15.12_win_x64）和框架引擎（MakerFrame_鹰歌框架引擎_win_x64_vXXX）解压并放在一起 ，双击“_运行鹰歌.bat”；
2.Android：安装运行 MakerFrame_鹰歌框架引擎_xxx_armeabi-v7a.apk 或 MakerFrame_鹰歌框架引擎_xxx_arm64-v8a.apk 即可；
3.Linux：目前已在OpenKylin系统上打包DEB，并上架了其公司的应用商店（应该支持Debian、Ubuntu及衍生的操作系统）；
4.苹果iOS、macOS、其他架构Linux（RedHat、UOS国产化系统、Arm架构相关）等：已经适配，但由于精力和经济问题（iOS应用市场还需要付费上架），以后再发布；
5.打开软件后，进入GameMaker主界面，再点击 示例工程，请等待下载完毕后，点击 开始运行-》运行 就OK了；
6.各平台的框架引擎都支持热更新（打开软件后会自动检测并更新 动态链接库内核、QML引擎和Java代码库Dex），无需重新下载安装新版（服务器带宽较慢，可能升级和下载时间会稍微长一点）。


  功能和特色：
1.跨平台：框架引擎和游戏都可完美运行在Windows（win7及以上）、Android（6.0及以上）、MacOS、iOS、Linux（包括Ubuntu、Debian、国产化的OpenKylin、Deepin和UOS、Arm的树莓派）等操作系统上，目前OpenKylin和Deepin已成立Sig并上架到了应用商店；
2.全功能网络：支持 TCP、UDP、HTTP（XmlHttpRequest和QNetwork封装的两种方式，后者自由度更高）、WebSocket（QML）、MQTT、串口（QextSerialPort）等多种常用协议的服务端和客户端开发，也可自己封装其他协议；API使用非常简单，支持异步函数的同步写法；支持互联网、局域网、蓝牙、NFC等通信方式；
3.配套的后台服务软件和数据库：已有PHP开发的弱网系统（Workerman/Webman高并发服务），C++开发的联机系统（IOCP高并发模型），配套Redis、MySQL来做缓存和存储，支持注册登录、房间及管理、聊天、联机对战（帧同步）等功能，可万人同时在线；数据存储自由度高，支持JSON，各平台共享；
4.多种发布形式：能生成对应平台的安装包exe、apk、bin、deb等（可发布在Steam、Tap、OpenKylin等平台），也能生成框架引擎能载入运行的游戏ROM包；资源和代码支持源文件形式，也支持压缩、打包、加密的形式，一定程度上可防逆向；ROM可以分发到各平台，或上传到官网，用链接、二维码、分享等形式来载入运行；
5.热更新：框架底层采用我编写的 升级加载运行器，能运行前检测并热更新框架引擎的所有核心库（so/dll、dex、rcc），不用繁琐的下载和重新安装，过程完全无感和自动化；
6.屏幕自适应：在任何分辨率，各种不同大小的屏幕下有相同的显示效果；开发时框架引擎还提供了不同的方式来解决各种屏幕的自适应效果，比如 整体缩放（原创）、虚拟坐标（原创）、点（Point）坐标、布局（Layout）等；
7.多层次的架构设计，能满足从小白到大神不同技术层次的玩家（见 架构设计）；
8.简便易用的接口/API：用极少的JS代码就能调用各接口API和功能，比如文件系统、文件读写、二进制操作、网络（Request和长链接）、实名认证、接入穿山甲和Tap广告和扫描/生成二维码等；
9.可以动态载入 Qt和QML的动态链接库插件（自动载入，热插拔方式）、C++编写的动态链接库、Java编写的安卓Dex库、QML资源RCC库，所以支持用Qt（C++）、QML（JavaScript）和Java（Android）等语言来开发 动态链接库、Dex和组件/插件，封装接口给JavaScript，然后用鹰歌框架引擎来载入和调用（比如 震动、GPS等功能）；
10.已封装3种线程（池），提供线程控制和并行运算；
11.已封装 JS脚本引擎、异步脚本 AsyncScript（协程）、脚本/事件队列 ScriptQueue 来解决JavaScript脚本文件的载入和运行（QML的JavaScript版本是ECMA6，不支持async/await写法，但我已经封装了一种类似async/await的同步脚本写法，非常简单好用；QML本身对外部JavaScript的载入和运行机制也不太友好方便，但我也解决了这个问题）；
12.存储/数据库/缓存：可采用远程Redis、Mysql和本地的Sqlite（未加密）、SQLITECIPHER（加密）、JSON、XML及QML的LocalStorage等；
13.引入了QML/JavaScript语言 和 所有QML基础组件与QtQuick组件（动画特效、粒子系统、3D等等）：
  a.采用最流行的 JavaScript脚本语言 和 QML/QtQuick环境 开发的 游戏各编辑器、扩展和游戏脚本；JavaScript是优化过的谷歌v8（非H5）引擎，开发和运行效率都非常高；QML/QtQuick环境用来写界面非常简单高效；
  b.主流的图片、音乐、视频播放器 和 文本编辑器；
  c.Android内置一个Webview浏览器内核，桌面端可以选带一个Webkit浏览器内核；
14.游戏引擎支持插件开发和下载（使用QML/JavaScript），官方已经开发了多种功能的插件（甚至包括两款游戏脚本引擎）：
  资源打包；
  离线加解密；
  网络服务（包括实时连接、弱网、卡密验证等）；
  Pymo（AVG）游戏引擎工程兼容；
  BBKRPG（RPG）游戏引擎脚本兼容；
  游戏扩展（包括升级链、公告、场景切换、场景消息、三方的可视化指令、战斗人物、背包、交易、系统菜单、宠物、任务、对话）等；
15.框架集成其他三方库和SDK：
  已集成QML的QRC打包为RCC功能，支持解包；
  已集成Box2D-qml和Bacon2D库，QML可使用物理引擎来做插件、游戏等；
  已集成Tap实名认证，完美支持上架Tap（侠道仙缘已上架到Tap和OpenKylin应用商店）；
  已集成Tap广告；
  已集成穿山甲广告；
  已集成OpenSSL库，支持RSA创建密钥对、RSA加解密和签名验证、sha256摘要、DES对称加解密等；
  已集成压缩、解压的zlib库和Quazip库（支持gzip，压缩、解压ZIP文件和目录等）；
  已集成SQLITECIPHER库（加密Sqlite）；
  已集成qnanopainter库，基于opengl的QPaint方式绘图，绘图效率非常高，QML哪个组件效率低完全可以用它来替换；
  已集成SCodes/QZXing插件库（支持 生成和扫描一维码及二维码）；
  已集成Lua插件库；
  已集成libhv插件库（非常不错的一个网络库，支持使用TCP、UDP、HTTP、WebSocket、MQTT等协议开发网络服务端和客户端等）；
  已集成QtWebApp插件库，支持做Web服务应用；
  已集成QextSerialPort插件库；
  已集成SDL3插件库（很不错的一款跨平台游戏开发库）；
  以上功能大都已封装完成并提供给QML或JavaScript来使用。感谢以上框架、库、SDK、扩展的作者、组织和公司。
16.可开发类型：
  游戏：理论上几乎支持所有2D游戏类型(比如已有的RPG和放置、ARPG、AVG、即时战略、战棋、棋牌等等)的网络/单机游戏，3D的可用QML3D或opengl来自行学习和设计（但我对3D不熟悉）；
  引擎：鹰歌游戏引擎GameMaker和编辑器，就是基于鹰歌框架完成的，采用QML/JavaScript和一些系统函数编写，所以也能开发其他类型的游戏引擎（比如已经用插件实现和适配的BBKRPG和Pymo游戏引擎）；
  软件：鹰歌框架引擎封装了很多基础和底层的功能（文件、网络等等），加上QML的易用性，所以也很适合开发各种行业应用软件、系统软件、工具、爬虫等；
  其他：还可以增强鹰歌本身的功能，比如用QML的插件机制来编写QML扩展、编写QML组件、游戏插件，还能载入用本地语言开发的动态链接库来调用系统功能等等；
17.其他：
  Android：
    能使用文件管理器选择鹰歌打开任何文件（可以作为万能播放器使用）/夹，QML文件默认直接运行；
    能使用Scheme URL（比如用链接来传递数据）；
    能分享媒体到鹰歌来进一步处理；
    支持安卓的一些本地功能，比如小窗/画中画、消息、服务等；
  Windows：
    支持拖动文件到窗口进行处理（可以作为万能播放器使用），QML文件默认直接运行；


  架构设计：
1.功能分层：
  a.上层（纯图形化编辑开发）：道具、战斗人物、技能、战斗脚本使用图形化编辑生成，脚本使用纯图形化编程来制作，只需设计 剧情、道具、地图、人物、战斗 等等就可以做出游戏，后期还可能做Excel、Json等来设计游戏内容，用框架引擎导入来生成游戏；
  b.中层（图形化编辑+JavaScript代码）：用JavaScript来扩展图形化编辑的生成结果，可以开发和设计更多的内容，比如游戏的算法、界面效果、升级链、道具、人物、登录、联网功能、图形化命令 等等；
  c.底层（QML+JavaScript）：用来扩展界面和功能，也可使用框架提供的Box2D和qnanopainter库，比如制作插件、扩展图形化命令、修改增强游戏引擎和编辑器、甚至可以做其他类型的游戏引擎、编辑器和游戏，还可以做各种类型的软件APP（系统软件、行业业务软件、播放器、浏览器、各种工具、爬虫等）；
  d.内核/扩展层（框架层）：一般作者我来维护，包括跨平台、网络、资源整合打包、屏幕自适应、热更新、压缩解压、文件下载、数据库、文件管理、线程池、JS脚本引擎、异步脚本（协程）、脚本/事件队列、项目打包生成、平台分发上架、媒体播放器、浏览器内核、三方库（Bacon2D、Box2D-qml、qnanopainter、SCodes/QZXing、Quazip、OpenSSL、SQLITECIPHER、libhv、QtWebApp、Lua、QextSerialPort、SDL3等）、三方SDK（Tap实名、Tap和穿山甲广告SDK、微信相关、支付宝等）等系统功能；
2.此框架适合：
  a.非专业人士；想在任意端编写、任意端运行，能简单高效便捷的开发，且能快速发布在Steam、Tap、应用商店等平台的软件和游戏；
  b.学习Javascript、QML或游戏引擎开发的：鹰歌是个不错的宿主环境，可以任意在几个功能层面上进行编写运行；
  c.技术爱好者：鹰歌在功能上来说是非常丰富的一款超级APP，它包含了多种编程语言、丰富的技术和算法（游戏引擎、游戏设计、图形绘制等），很适合用来学习研究；
3.此框架引擎的重点在于打造 手持端（兼容PC、MAC等跨端）和国产化系统 的跨平台软件框架和游戏引擎，专业的游戏还请绕道Unity、虚幻等更好的游戏引擎；
4.未来：
  a.继续开发战旗类Maker、AVG Maker、ARPG Maker、卡牌类Maker等（都是我喜欢的游戏类型），欢迎有志同道合的朋友一起加入进来~；
  b.优化引擎：引入缓存机制，并将QML中效率不高的算法（比如寻路）、图形引擎替换为OpenGL，JavaScript算法替换为C++等优化；
  c.开发3D引擎（已引入QML3D）；


  特别鸣谢
1.OpenKylin官方的支持；
2.荔竹的策划和demo游戏工程；
3.吾爱的代码版测试、建议和他的游戏工程（已上架Tap应用商店和openKylin应用商店）；
4.落雪的工程和游戏（已上架好游快爆）；
5.金牌服务的建议和游戏工程；
6.网友（落冥迦、工作台等人）的参与使用；
7.所有鹰歌使用的第三方的扩展、插件、库、SDK等的作者、机构、公司；



  杂记：
1.跨平台，包括Windows、Linux、MacOS、IOS、Android（Java、JNI）开发；
  安卓：包括两种JNI调用方式、权限、亮度、震动、GPS、锁屏 等；
2.IOCP模型高并发、TCP（Socket的加解密）、UDP；
3.dbghelp（奔溃/异常退出拦截，日志和提示）；
4.日志 和 qDebug输出拦截；
5.耗时任务 多线程+异步 完成（MessageHandlerInfo写日志 和 数据库 读写）；
6.屏幕自适应（布局、比例缩放和虚拟屏幕几种方式）；
7.热更新（so库的载入、jar/dex文件的更新和载入）；
8.exe、动态链接库 的加载器；
9.SQLite（加密）和MySql（Json字段的增删查改）；
10.CPU、硬盘、主板等序列号获取、加密（注册码制作）；
11.静态、动态库（lib、dll、a、so等）的编写和使用；
12.池 模型；
13.生产、消费者模型；
14.随系统启动、奔溃重启；
15.QML（包括一些算法、JSLoader库、 Async异步脚本队列、队列信号事件调用、QQuickPaintedItem、C++执行脚本 等实现）、；
16.各种三方库（比如qnanopainter库，基于opengl的QPaint方式绘图，绘图效率非常高！）的编译和集成；
17.多媒体播放（包括精灵、图片、音频、视频）；
18.手机浏览器；

19.Qt基础：
  事件、信号和槽；QSettings 和 自定义类型的读写；pro文件的配置等；
20.JS、QML、Qt类型、对象互转、互相访问，QDataStream、QByteArray、QString使用和发送；JS对象和JSON互转和发送等；
21.HTTP网络访问(NetworkAccessManager)；
22.单例类、二进制兼容写法（d指针）；
23.多线程 和 控制；
24.图形特效、动画；
25.new和delete的重载、扩展（在IOCP源码）；

26.模型和视图(QTable)；
27.托盘；
28.窗体样式、响应方式；

29.MQTT、串口通信；
30.CRC16、CRC32；
31.读写Excel；
`;
        msgBox.text = $CommonLibJS.convertToHTML(t);

        console.debug('[mainAbout]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainAbout]Component.onDestruction');
    }
}
