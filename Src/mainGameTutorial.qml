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
            console.debug("[mainGameTutorial]Loader onLoaded");
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

        console.debug("[mainGameTutorial]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGameTutorial]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameTutorial]:key:", event, event.key, event.text)
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
<CENTER><B>简易教程</B></CENTER>

脚本说明：
  脚本环境为Qt的QML环境（v8引擎），所以支持Javascript（ES6标准）语言来编写脚本，支持所有JS内置对象。

目前支持（已封装）的脚本命令（中括号[]为可选参数）：

game.loadmap("地图名")：载入地图；成功返回true。
game.setmap(x,y)：将主角移动到地图 x、y地方。
game.map：地图信息。
  .name：地图名。
game.msg("信息"[, pauseGame=true[, buttonNum]])：在屏幕中间显示提示信息。pauseGame为是否暂停游戏；buttonNum为按钮数量（0-2）。
game.menu(title, items, pauseGame=true)：显示一个菜单；title为显示文字；items为选项数组；pauseGame是否暂停游戏；返回值为选择的下标（0开始）；注意：该脚本必须用yield才能暂停并接受返回值。
game.say("信息"[, "角色游戏名"[, pauseGame=true]])：在屏幕下方显示信息。如果有 "角色游戏名"，则会显示角色的头像和名称；pauseGame为是否暂停游戏。
game.createhero("主角名"[, "主角游戏名"])：创建主角；成功返回true。
game.createrole("角色名"[, 角色游戏名", bx, by, actionType=1, direction=undefined])：创建NPC到坐标x、y；actionType为0表示静止，为1表示随机移动；direction表示静止方向（0、1、2、3分别表示上右下左）；成功返回true。
game.moverole("角色游戏名", x, y)：移动角色到x，y。
game.delrole("角色游戏名")：删除角色；成功返回true。
game.delallroles()：删除全部角色。
game.money(m=0)：获得金钱；返回金钱数目；

game.createfighthero(name, showName)：创建一个战斗主角；返回这个战斗主角对象；name为战斗主角资源名，showName为游戏中显示名称。
game.deletefighthero(n)：删除一个战斗主角；n为下标，n如果为-1则删除所有战斗主角。
game.fighthero(n=null, type=1)：返回第n个战斗主角；n为null则返回全部战斗主角数组；type为0表示只返回名字（选择框用），为1表示返回对象。
game.getskill(heroIndex, skillName, skillIndex=-1)：获得技能；heroIndex为战斗主角下标；skillName为技能资源名称；skillIndex为替换到第几个（如果为-1或大于已有技能数，则追加）；成功返回true。
game.removeskill(heroIndex, skillIndex=-1)：移除技能；heroIndex 为战斗主角下标；skillIndex 为移除第几个（如果为-1则全部移除）；成功返回true。
game.removeskillname(heroIndex, skillName)：移除技能；heroIndex 为战斗主角下标；skillName 为技能资源名称；成功返回true。
game.getexp(heroIndex, exp=0)：获得经验；heroIndex为战斗主角下标；exp为经验值；返回当前经验值。
game.levelup(heroIndex)：直接升一级。
game.getgoods(goodsId, count=0)：背包内 获得 或 减去count个道具，返回背包中 改变后 道具个数；count为0则直接返回背包中道具个数。如果count<0，且装备数量不够，则返回<0（相差数），原道具数量不变化。返回null表示错误。
game.usegoods(goodsId)：使用道具（会执行道具use脚本）。
game.goods(index=-1, filterkey=null, filtervalue=null)：获得道具列表中某项道具详细信息；index为-1表示返回所有道具（此时filterkey和filtervalue是过滤条件）；返回格式：单个：{id,count,property}，多个：单个的数组。
game.hasgoods(goodsid=null)：背包中是否有某道具，如果有则返回详细信息（getgoods只是返回个数），没有返回null；返回格式：{id,count,property}。
game.equip(heroIndex, positionName, goodsId, count=1)：某主角 获得或减去count个道具，返回背包中 改变后 道具个数；如果positionName为空，则使用 goodsId 的 position 属性来装备；count为0则直接返回背包中道具个数。如果count<0，且装备数量不够，则返回<0（相差数），原道具数量不变化。返回null表示错误。注意，会将不同源装备删除，需要保存则先unload。
game.unload(heroIndex, positionName)：某主角 卸下某装备（所有的），返回装备对象，没有返回undefined。
game.equipment(heroIndex, positionName=null)：返回某 heroIndex 的装备；如果positionName为null，则返回所有装备；返回格式：单个：{id,count,property}，多个：单个的数组；错误返回null。

game.fight(fightScriptName)：载入 fightScriptName 脚本 并进入战斗。
game.fighton(fightScriptName, interval=1000, probability=20)：载入 fightScriptName脚本 并开启随机战斗；每过 interval 毫秒执行一次 probability分之1 的概率 是否进入随机战斗。
game.fightoff()：关闭随机战斗。

game.addtimer("timerName", interval, times)：加入定时器；timerName：定时器名称；interval：定时器间隔；times：触发次数（-1为无限）；成功返回true。
game.deltimer(timerName)：删除定时器。
game.addgtimer("timerName", interval, times)：加入全局定时器；timerName：定时器名称；interval：定时器间隔；times：触发次数（-1为无限）；成功返回true。
game.delgtimer(timerName)：删除全局定时器。
  如果是局部定时器，则触发的脚本在 game.f["定时器名"] 中定义；如果是全局，则触发的脚本在 game.gf["定时器名"] 中定义。

game.playmusic("音乐名")：播放音乐；成功返回true。
game.stopmusic()：停止音乐。
game.pausemusic()：暂停音乐。
game.resumemusic()：继续播放音乐。
game.pushmusic()：将音乐暂停并存栈。一般用在需要播放战斗音乐前。
game.popmusic()：播放上一次存栈的音乐。一般用在战斗结束后（commonFightEndEvent已调用，不用写在战斗结束脚本中）。

game.scale(n)：将场景缩放n倍；可以是小数。
game.pause()：暂停游戏。
game.goon()：继续游戏。
game.setinterval(interval)：设置游戏刷新率（interval毫秒）。

game.wait(time)：暂停time毫秒。
game.rnd(start, end)：返回start~end之间的随机整数（包含start，不包含end）。
game.date()：返回 JS 的 new Date()对象。
game.toast(msg)：显示msg提示。

game.checksave("文件名")：检测存档是否存在且正确，失败返回false，成功返回存档对象（包含Name和Data）。
game.save("文件名", showName="")：存档（将game.gd存为 文件），showName为显示名。
game.load("文件名")：读档（读取数据到 game.gd），成功返回true，失败返回false。

game.loadjson(fileName, filePath="")：读取json文件，失败返回null，返回解析后对象；fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径。

game.run(strScript, ...params)：执行脚本命令（注意：此命令会将脚本放入game系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）。
game.script(fileName, filePath)：执行脚本文件（注意：此命令会将脚本放入game系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）；参数同game.loadjson。

game.evalcode(data, filePath="", envs={})：立即执行脚本命令，失败返回null，成功返回结果；filePath为异常时提供的文件名（目前不支持字符串中的函数异常），envs是额外的上下文环境；和 game.evaluate 的区别是，这个执行时自带所有的上下文环境。
game.evalfile(fileName, filePath="", envs={})：立即执行脚本文件，失败返回null，成功返回结果；fileName、filePath参数同game.loadjson，envs参数同game.runcode；和 game.evaluateFile 的区别是，这个执行时自带所有的上下文环境。

game.evaluate(program, filePath="", lineNumber = 1)：用C++执行program脚本命令（类似runcode）；在初始化时已注入game上下文环境；优点是异常时可提供文件路径；无初学者不要用。
game.evaluateFile：用C++执行脚本文件（类似runfile）；在初始化时已注入game上下文环境；优点是异常时可提供文件路径；初学者不要用。
game.importModule：用C++导入一个脚本（脚本可以使用import和export指令，但只能导入一次，也不能卸载，所以不方便调试）；初学者不要用。


战斗脚本（战斗脚本可以使用game属性）：
fight.myCombatants：我方数组。
fight.enemies：敌方数组。
fight.over(r=0)：结束战斗；-1为失败并调用战斗结束脚本，1为胜利并调用战斗结束脚本，0为直接退出）。
fight.msg(msg, pretext, interval, type)：弹出提示框。
fight.run(strScript, ...params)：执行脚本命令（注意：此命令会将脚本放入fight系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）。
fight.script(fileName, filePath)：执行脚本文件（注意：此命令会将脚本放入fight系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）；参数同game.loadjson。
fight.background(imageName)：切换战斗背景图片；imageName为图片资源名。



脚本变量：

  game.math 或 Math：JS 的 Math对象。
  game.d：用户自定义局部变量集合。
  game.f：用户自定义局部函数集合。
  game.gd：用户自定义全局变量集合。
  game.gf：用户自定义全局函数集合。



NPC事件的四种写法（前两种支持同步调用）：
  game.f["角色游戏名"] = "。。。"   （推荐写法）
  game.f["角色游戏名"] = function*(){。。。}
  game.f["角色游戏名"] = function(){。。。}
  game.f["角色游戏名"] = ()=>{。。。}

定时器事件（写法同上）：
  局部定时器：game.f["局部定时器名"]
  全局定时器：game.gf["全局定时器名"]



如何载入外部脚本：
  1、涉及到算法的脚本，用 game.evaluateFile 或 game.evalfile 命令来立即执行并会返回结果；
    （技术说明：推荐用前者，底层是C++执行，异常时会准确报错；后者是用eval执行，函数内的函数异常时只能报eval错误；但后者执行有脚本的上下文环境）
  2、涉及到事件的脚本，用 game.script 命令来队列执行，调用run的时候才返回结果；
  编辑器中有提示，请注意不要用错。



同步代码调用说明：
  由于Javascript本身是异步调用，所有的指令都是一瞬间运行完毕。比如你想让人物说几句话，这样调用的话：
    game.say("第1句")
    game.say("第2句")
    game.say("第3句")
  默认是一瞬间执行到了第3句指令，第1句和第2句会一闪而过看不到，如果你想一句一句执行，等每一句彻底执行完毕再执行下一句，则应该这样：
    yield game.say("第1句")
    yield game.say("第2句")
    yield game.say("第3句")
  没错，只需要前面加一条 yield 单词就可以了。
  目前所有指令都支持同步调用，但真正有意义的命令：
    game.msg
    game.say
    game.wait
    game.menu
    fight.msg



地图编辑器说明：
  1、功能和特色：支持各种size的地图块；支持无数层级（目前1层和2层为地板层），角色都在2、3层之间；支持事件脚本编辑；支持复制粘贴功能；
  2、操作说明：
    左上角按钮为鼠标功能选择，有绘制、障碍、事件、移动 4个功能；
      绘制：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制地图（注意选择的当前图层）；
        双击和拖动：清空目标地图块；
        长按+拖动：复制地图选块；
      障碍：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制障碍；
        双击和拖动：清空目标障碍；
        长按+拖动：复制地图选块；
      事件：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制事件（注意需要选择一个事件）；
        双击和拖动：清空目标事件；
        长按+拖动：复制地图选块；
      移动：
        可以移动和缩放地图区；
    粘贴：可以复制源地图层的选区到目标地图层的粘贴目标内；
    地图层列表：单击可以选择当前地图层；双击可以显示、隐藏当前地图层；
    事件列表：单击可以选择当前事件进行绘制；双击可以编辑事件；
    载入事件：编辑地图载入时的事件；


其他说明：
  游戏载入脚本：在游戏一开始时执行，主要是载入初始地图、创建主角、创建属性、变量等；
  地图载入脚本：在载入地图时执行，主要是清空原NPC、创建NPC、创建NPC脚本等；

  游戏刷新率：建议5~50，根据游戏实际情况设置（经测试低端手机最高FPS能达到60左右）；
  角色速度：为了匹配所有游戏刷新率，将其定义为 像素/毫秒，所以根据图块大小来设置（一般设置为0.1-0.2即可）；

  游戏退出时会自动存到名为 savedata 的存档；


游戏工程和数据主目录：
  1、windows环境，在 可执行程序 目录下的GameMaker\\Projects 目录下；
  2、android环境，在 /storage/emulated/0/Leamus/GameMaker/Projects 目录下；

  工程打包后导出的路径为 Projects/工程名.zip；

`
        msgBox.text = t.replace(/ /g, "&nbsp;").
            //replace(/\</g, "&lt;").replace(/\>/g, "&gt;").
            replace(/\n/g, "<BR>");
    }
}
