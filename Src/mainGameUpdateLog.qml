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
            console.debug("[mainGameUpdateLog]Loader onLoaded");
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

        console.debug("[mainGameUpdateLog]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGameUpdateLog]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameUpdateLog]:key:", event, event.key, event.text)
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
<CENTER><B>更新日志</B></CENTER>
2022/8/5：发布0.8.11版本
1、修复一个bug；
2、增加道具买卖钱数；

2022/8/4：发布0.8.10版本
1、增加装备脱下；
2、可以显示道具和装备的描述；
3、增加role的状态为静止；
4、完善了一些细节东西；

2022/8/3：发布0.8.9版本
修改几个BUG；

2022/8/2：发布0.8.8版本
1、增加3个命令：goods、hasgoods、equipment；
2、调整usegoods命令；
3、加入出现警告、错误等信息时自动弹出提示框；
4、增加剪切板功能；
5、修改几个BUG；

2022/7/30：发布0.8.7版本
1、改了几个命令；
2、完善了道具背包系统；
3、完善了存档功能；
4、地图编辑器加入了测试功能；
5、下一步：修改战斗编辑器和战斗角色编辑器；

2022/5/29：发布0.8.6版本
1、写了个Bug；
2、把上面的Bug修复了；

2022/5/22：发布0.8.5版本
1、完成道具和装备系统；到此为止开发基本完毕了，剩下就是美化和完善细节；
2、优化、修复。。;

2022/4/27：发布0.8.4版本
1、优化脚本引擎；修复引擎Bug；
2、战斗引擎中加入 fight 属性指令集，可以调用相关命令；
3、加入升级和升级链算法脚本；
4、新增每秒恢复事件算法脚本；
5、整整3个月左右了，得休息一阵子了。。。

2022/4/26：发布0.8.3版本
1、重写战斗动画执行脚本引擎；
2、完善了同步脚本引擎内容，以后基本不会变化了；

2022/4/25：发布0.8.2版本
1、完善战斗动画效果：加入文字动态显示；
2、增强脚本和逻辑功能；
3、完善战斗算法、技能算法功能；
4、增强血条显示；
5、新增game.getskill、game.removeskill命令；

2022/4/23：发布0.8.1版本
重大更新：历时几天，终于把运行外部js系统做出来了，还支持脚本错误准确提示。
1、新增game.runjs、game.script、game.evaluate、game.evaluateFile、game.importModule命令；
2、增强脚本系统（支持从文件运行）；

2022/4/23：发布0.7.10版本
1、完善战斗动画效果：加入多特效混用；

2022/4/22：发布0.7.9版本
1、完善战斗动画效果：加入特效；

2022/4/21：发布0.7.8版本
1、完善战斗动画效果和血条；
2、特效中加入镜像和缩放功能；
3、修复同步脚本框架的Bug；
4、修复音乐Bug；

2022/4/20：发布0.7.7版本
1、完善技能编辑和功能；
2、继续完善战斗特效；
3、优化代码；

2022/4/19：发布0.7.6版本
1、加入存档校验；
2、继续完善了战斗脚本、效果和指令；
3、修复Bug；

2022/4/18：发布0.7.5版本
1、做了很多战斗系统方面的东西；
2、修复了一些小Bug；

2022/4/17：发布0.7.4版本
1、初步完善战斗编辑系统，继续细化完善；
2、准备升级链和道具系统；
3、准备生成项目系统；
4、修复PC端打包乱码错误（编码问题）；
5、可以使用示例项目了（点击后请等待完成）；

2022/4/16：发布0.7.3版本
1、完善了项目工程管理；
2、完善了解包功能；
继续做战斗；

2022/4/12：发布0.7.2版本
1、绘制地图加入复制粘贴功能（长按复制）；
2、增加地图编辑器的铺图功能（将地图块图片铺到地图层上）；
3、优化体验；
4、修复同步代码小框架的BUG；
5、修复两个比较恶心的BUG（又踩了QML的坑）；
可以专心作战斗画面了~

2022/4/11：发布0.7.1版本
1、重大更新：目前脚本支持同步代码（异步执行）了，我自己做了个同步执行代码小框架，且支持嵌套调用，支持函数、字符串创建；
2、优化 game.say 和 game.msg 效果；
3、新增 game.wait 命令；

2022/4/9：发布0.6.3版本
1、修复BUG；
2、加入战斗系统（测试）和game.fight、game.fighton、game.fightoff指令；

2022/4/7：发布0.6.2版本
1、优化脚本编辑器；
2、加入game.rnd随机数脚本命令；

2022/4/5：发布0.6.1版本
1、加入特效编辑器；
2、加入game.say脚本命令；
3、将方向优化为0.1以下的偏移为停止主角移动；
4、地图编辑器在绘制地图时，单击地图会显示坐标；
5、修复BUG；优化代码；优化界面和操作。。。

2022/4/2：发布0.6.0版本
1、加固底层代码，加入安卓的Javad代码热更新，目前已完全实现个平台的热更新功能（包括安卓的so、dex，win的dll，资源文件，底层代码，Maker层QML代码和游戏层QML代码）；
2、修复部分BUG，优化部分代码；

2022/3/31：发布0.3.6版本
1、继续优化代码；
2、微调界面；
3、修复安卓选择文件真实路径BUG；

2022/3/30：发布0.3.5版本
1、大幅优化核心代码；

2022/3/29：发布0.3.4版本
1、将小地图居中到屏幕；
2、修正一些BUG，优化代码；

2022/3/28：发布0.3.3版本
1、增加游戏工程导入导出功能；
2、准备导出APK相关工作；
3、地图事件可以删除；
4、调整游戏刷新率、计时器精度（之前非常不精确）；
5、调整角色的速度单位为 像素/毫秒，这样不同刷新率下角色移动速度相同；
6、修正角色碰撞会滑步BUG；

2022/3/28：发布0.3.2版本
1、修复载入地图白屏BUG（这次真的修复了）；
2、优化载入地图时屏乱BUG；
3、修复事件保存的严重BUG；
4、修复其他N多BUG；

2022/3/27：发布0.3.1版本
1、加入了区分地图前景和背景（目前0层和1层地图自动为背景，其他均为前景）；
2、修正NPC移动概率（任何刷新率下概率差不多）；
3、支持修改地图大小、地图块大小；
4、修复资源路径问题；
5、修复跨平台编码问题；
6、修复若干Bug；

2022/3/26：发布0.3.0版本
1、修好了地图编辑器第一次进入白屏的问题；
2、加入了素材功能（选择图片会复制到项目目录下）；
3、地图编辑器的操作修正（单击绘制、双击清除）；
4、修改了项目目录结构；
5、支持地图块图片替换和大小修改（替换图块功能）；
6、优化了多指触摸按键；
7、加入了方向遥感速度；

2022/3/23：发布0.2.0版本

`
        msgBox.text = t.replace(/ /g, "&nbsp;").
            //replace(/\</g, "&lt;").replace(/\>/g, "&gt;").
            replace(/\n/g, "<BR>");
    }
}
