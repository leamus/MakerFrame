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

        console.debug("[mainEasyTutorial]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainEasyTutorial]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainEasyTutorial]key:", event, event.key, event.text)
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

  简要说明：
    1、创作对象基本分为 地图、角色、特效、道具、战斗角色、技能、战斗脚本 和 通用脚本 8个部分，每个部分都有对应的帮助来查看；
        通用脚本包含了各种功能和配置，可以用默认的，如果有代码基础可以自行修改和编写；
        战斗角色和战斗技能的特效，都是来源于 “特效”对象；

    2、创作步骤：一般是：
        地图行走游戏：地图->角色->start脚本，即可做出；
        战斗：特效（人物）->技能->战斗角色->战斗脚本，即可完成；


<font color='red'>可视化版本</font>

    别被脚本吓住，直接忽略它就行，脚本界面一般都有个 V按钮（Visual的意思），点进去就可以可视化操作了，切记要点保存（保存可视化数据）和编译（生成代码），然后返回到代码界面再保存一次即可。
       可视化的文本处，有@标记的都是可以长按选择，有*的是必填项；
    可视化版本优点是简单，缺点是繁杂，模式固定，脚本恰好相反，但js脚本也不是很难，而且可以做出很多效果，所以新手推荐食用可视化，生成一个简单的游戏后研究下脚本代码，试着修改和编写，循序渐进。老手直接干代码吧。


<font color='red'>代码版本</font>

脚本说明：
  游戏引擎采用Qt、Java为主要语言，脚本环境为Qt的QML环境（v8引擎），所以支持Javascript（ES6标准）语言来编写脚本，支持所有JS内置对象。
  首先注意的是，脚本的符号全部用的是半角英文符号，不可出现中文或全角的符号（字符串除外），否则会报错。

目前支持（已封装）的脚本命令（中括号[]为可选参数）：

<font color='yellow'>game.loadmap("地图名")</font>：载入地图并执行地图载入事件；成功返回true。

//在屏幕中间显示提示信息。
//interval为文字显示间隔，为0则不使用；
//pretext为已显示的文字；
//keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
//style为样式；
//  （如果为数字，则表示自适应宽高（0b1为宽，0b10为高），否则固定大小；
//  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Type）；
//      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
//pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
//buttonNum为按钮数量（0-2，目前没用）。
<font color='yellow'>game.msg(msg, interval=20, pretext='', keeptime=0, style={Type: 0b10}, pauseGame=true);</font>

//在屏幕下方显示信息。
//interval为文字显示间隔，为0则不使用；
//pretext为已显示的文字（role为空的情况下）；
//keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
//style为样式；
//  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Name、Avatar）；
//      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间、是否显示名字、是否显示头像；
//pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
<font color='yellow'>game.talk(role, msg, interval=20, pretext='', keeptime=0, style={}, pauseGame=true);</font>

//人物头顶显示信息。
//interval为文字显示间隔，为0则不使用；
//pretext为已显示的文字（role为空的情况下）；
//keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
//style为样式；
//  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor）；
//      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
//pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
readonly property var say: function(role, msg, interval=60, pretext='', keeptime=1000, style={}) {

//显示一个菜单；
//title为显示文字；
//items为选项数组；
//style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
//pauseGame是否暂停游戏；
//返回值为选择的下标（0开始）；
//注意：该脚本必须用yield才能暂停并接受返回值。
<font color='yellow'>game.menu(title, items[, pauseGame=true]);</font>

//显示一个输入框；
//title为显示文字；
//pretext为预设文字；
//style为自定义样式；
//pauseGame是否暂停游戏；
//返回值为输入值；
//注意：该脚本必须用yield才能暂停并接受返回值。
<font color='yellow'>game.input(title='', pretext='', pauseGame=true);</font>

//创建主角；
//role：角色资源名 或 标准创建格式的对象（RId为角色资源名）。
//  其他参数：$id、$name、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y、$bx、$by；
//  $name为游戏显示名；
//成功返回 对象。
<font color='yellow'>game.createhero(role={});</font>

//返回 主角；
//hero可以是下标，或主角的$id，或主角对象，-1表示所有主角；
//props：需要修改的 单个主角属性（有$name、$showName、$speed、$scale、$avatar、$avatarSize，$x，$y、$bx、$by）；
//  $action：为2表示定向移动，此时$targetBx、$targetBy、$targetX、$targetY为定向的地图块坐标或像素坐标（用其中一对即可）；
//返回经过props修改的 主角 或 所有主角的列表；如果没有则返回null；
<font color='yellow'>game.hero(hero=-1, props={});</font>

<font color='yellow'>game.delhero(hero=-1)</font>：删除主角；hero可以是下标，或主角的$id，或主角对象，-1表示所有主角；
<font color='yellow'>game.movehero(bx, by)</font>：将主角移动到地图 x、y 位置。

//创建NPC；
//role：角色资源名 或 标准创建格式的对象（RId为角色资源名）。
//其他参数：$id、$name、$showName、$speed、$scale、$avatar、$avatarSize、$direction、$action、$start、$x、$y、$bx、$by；
//  $name为游戏名；
//  $action为0表示静止，为1表示随机移动；
//  $direction表示静止方向（0、1、2、3分别表示上右下左）；
//  $start表示角色是否自动动作（true或false)；
//成功返回true。
<font color='yellow'>game.createrole(role={});</font>

//返回 角色；
//role可以是下标，或角色的$id，或角色对象，-1表示所有角色；
//props：需要修改的 单个主角属性（有 $name、$showName、$speed、$scale、$avatar、$avatarSize、$direction、$action、$start、$x、$y、$bx、$by）；
//  $action：为0表示静止；为1表示随机移动；为2表示定向移动，此时$targetBx、$targetBy、$targetX、$targetY为定向的地图块坐标或像素坐标（用其中一对即可）；
//返回经过props修改的 角色 或 所有角色的列表；如果没有则返回null；
<font color='yellow'>game.role(role, props={});</font>

<font color='yellow'>game.moverole(role, bx, by)</font>：移动角色到x，y。

//删除角色；
//role可以是 角色对象、角色名或-1（表示删除所有）；
//成功返回true。
<font color='yellow'>game.delrole(role=-1);</font>

//角色中心所在块坐标；
//role为角色组件（可用heros和roles命令返回的组件）；
//  如果为数字或空，则是主角；如果是字符串，则在主角和NPC中查找；
//pos为[x,y]，如果为空则表示返回角色中心所在块坐标；
<font color='yellow'>game.rolepos(role, pos);</font>

//创建一个战斗主角；返回这个战斗主角对象；
//fightrole为战斗主角资源名 或 标准创建格式的对象（带有RId、Params和其他属性）。
<font color='yellow'>game.createfighthero(fightrole);</font>
<font color='yellow'>game.delfighthero(fighthero)</font>：删除一个战斗主角；fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（删除所有战斗主角）。
<font color='yellow'>game.fighthero(fighthero=-1, type=1)</font>：返回战斗主角；fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（所有战斗主角）；type为0表示返回 对象，为1表示只返回名字（选择框用）。返回null表示没有，false错误；

//获得技能；
//fighthero为下标，或战斗角色的name，或战斗角色对象；
//skill为技能资源名，或 标准创建格式的对象（带有RId、Params和其他属性），或技能本身（带有$RId）；
//skillIndex为替换到第几个（如果为-1或大于已有技能数，则追加）；
//copyedNewProps是 从skills复制的创建的新技能的属性（如果skills为技能对象，会复制一个新技能，然后再复制copyedNewProps属性）；
//成功返回true。
<font color='yellow'>game.getskill(fighthero, skill, skillIndex=-1, copyedNewProps={})</font>：
<font color='yellow'>game.removeskill(fighthero, skill=-1, filters={})</font>：移除技能；fighthero为下标，或战斗角色的name，或战斗角色对象；skill：技能下标（-1为删除所有 符合filters 的 技能），或 技能资源名（符合filters 的 技能）；filters：技能条件筛选；成功返回skill对象的数组；失败返回false。
<font color='yellow'>game.skill(fighthero, skill=-1, type=-1)</font>：返回技能信息；fighthero为下标，或战斗角色的name，或战斗角色对象；skill：技能下标（-1为所有 符合filters 的 技能），或 技能资源名（符合filters 的 技能）；filters：技能条件筛选；成功返回 技能数组。

//战斗角色修改属性；
//  fighthero为下标，或战斗角色的name，或战斗角色对象；
//  props：对象；Key可以为 属性 或 属性,下标，Value可以为 数字（字符串属性或n段属性都修改） 或 数组（针对n段属性，对应修改）；
//    支持格式：{HP: 6, HP: [6,6,6], 'HP,3': 6}
//  type为1表示加，为2表示乘，为3表示赋值，为0表示将n段值被n+1段值赋值；
//  成功返回战斗角色对象；失败返回false；
<font color='yellow'>game.addprops(fighthero, props={}, type=1);</font>
<font color='yellow'>game.levelup(fighthero)</font>：直接升一级。fighthero为下标，或战斗角色的name，或战斗角色对象；

//背包内 获得 count个道具；返回背包中 改变后 道具个数，返回false表示错误。
//goods可以为 道具资源名、 或 标准创建格式的对象（带有RId、Params和其他属性），或道具本身（带有$RId），或 下标；
//count为0表示使用goods内的$count；
<font color='yellow'>game.getgoods(goods, count=0);</font>

//背包内 减去count个道具，返回背包中 改变后 道具个数；
//goods可以为 道具资源名、道具对象 和 下标；
//如果 装备数量不够，则返回<0（相差数），原道具数量不变化；
//返回 false 表示错误。
<font color='yellow'>game.removegoods(goods, count=1);</font>

<font color='yellow'>game.goods(goods=-1, filterkey=null, filtervalue=null)</font>：获得道具列表中某项道具信息；goods为-1表示返回所有道具的数组（此时filters是道具属性的过滤条件）；goods为数字（下标），则返回单个道具信息的数组；goods为字符串（道具资源名），返回所有符合道具信息的数组（此时filters是道具属性的过滤条件）；返回格式：道具数组。
<font color='yellow'>game.usegoods(goods, fighthero)</font>：使用道具（会执行道具use脚本）；fighthero为下标，或战斗角色的name，或战斗角色对象，也可以为null或undefined；goods可以为 道具资源名、道具对象 和 下标。

//直接装备一个道具（不是从背包中）；
//fighthero为下标，或战斗角色的name，或战斗角色对象；
//goods可以为 道具资源名、 或 标准创建格式的对象（带有RId、Params和其他属性），或道具本身（带有$RId），或 下标；
//newPosition：如果为空，则使用 goods 的 position 属性来装备；
//copyedNewProps是 从goods复制的创建的新道具的属性（如果goods为道具对象，会复制一个新道具，然后再复制copyedNewProps属性，比如$count、$position）；
//返回null表示错误；
//注意：会将目标装备移除，需要保存则先unload到getgoods。
<font color='yellow'>game.equip(fighthero, goods, newPosition=undefined, copyedNewProps={$count: 1});</font>

<font color='yellow'>game.unload(fighthero, positionName)</font>：卸下某装备（所有个数），返回装备对象，没有返回undefined；fighthero为下标，或战斗角色的name，或战斗角色对象；返回旧装备；
<font color='yellow'>game.equipment(fighthero, positionName=null)</font>：返回某 fighthero 的装备；如果positionName为null，则返回所有装备；fighthero为下标，或战斗角色的name，或战斗角色对象；返回格式：单个：装备对象，多个：单个的数组；错误返回null。

<font color='yellow'>game.trade(goods=[], mygoodsinclude=true, callback=undefined, pauseGame=true)</font>：进入交易界面；goods为买的物品rid列表；mygoodsinclude为true表示可卖背包内所有物品，为数组则为数组中可交易的物品列表；callback为交易结束后的脚本。
<font color='yellow'>game.money(m=0)</font>：获得金钱；返回金钱数目；

//载入 fightScript 脚本 并进入战斗；
//fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RId、Params和其他属性），或战斗脚本对象本身（带有$rid）；
//params是给战斗脚本$createData的参数。
<font color='yellow'>game.fighting(fightScript);</font>

//载入 fightScript 脚本 并开启随机战斗；每过 interval 毫秒执行一次 百分之probability 的概率 是否进入随机战斗；
//fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RId、Params和其他属性），或战斗脚本对象本身（带有$rid）；
//flag：0b1为行动时遇敌，0b10为静止时遇敌；
//params是给战斗脚本$createData的参数；
//会覆盖之前的fighton；
<font color='yellow'>game.fighton(fightScript, probability=5, flag=3, interval=1000);</font>

<font color='yellow'>game.fightoff()</font>：关闭随机战斗。

//加入定时器；
//timerName：定时器名称；interval：定时器间隔；times：触发次数（-1为无限）；bGlobal：是否是全局定时器；
//成功返回true。
<font color='yellow'>game.addtimer("timerName", interval, times, bGlobal=false);</font>
<font color='yellow'>game.deltimer(timerName, bGlobal=false)</font>：删除定时器。
  如果是局部定时器，则触发的脚本在 地图脚本 或 game.f["定时器名"] 中定义；如果是全局，则触发的脚本在 game.gf["定时器名"] 中定义。

//播放音乐；
//music为音乐名；
//params为参数；
//  $loops为循环次数，空或0表示无限循环；
//成功返回true。
<font color='yellow'>game.playmusic(music, params={});</font>
<font color='yellow'>game.stopmusic();</font>：停止音乐。
<font color='yellow'>game.pausemusic();</font>：暂停音乐。
<font color='yellow'>game.resumemusic();</font>：继续播放音乐。
<font color='yellow'>game.pushmusic();</font>：将音乐暂停并存栈。一般用在需要播放战斗音乐前。
<font color='yellow'>game.popmusic();</font>：播放上一次存栈的音乐。一般用在战斗结束后（commonFightEndEvent已调用，不用写在战斗结束脚本中）。
<font color='yellow'>game.seekmusic(offset=0);</font>：设置播放的音乐进度。

//播放视频
//video是视频名称；properties包含两个属性：$videoOutput（包括x、y、width、height等） 和 $mediaPlayer；
//  也可以 $x、$y、$width、$height。
<font color='yellow'>game.playvideo(videoName, properties={});</font>

<font color='yellow'>game.stopvideo()</font>：结束播放。

//显示图片；
//image为图片名；properties为图片属性；id为图片标识（用来控制和删除）；
//properties：包含 Image组件 的所有属性 和 $x、$y、$width、$height、$parent 等属性；还包括 $clicked、$doubleClicked 事件的回调函数；
//  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
//    不带$表示按像素；
//    带$的属性有以下几种格式：
//      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
//        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示全屏的百分比；为3表示居中后偏移多少像素，为4表示居中后偏移多少固定长度；
//      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
//        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示全屏的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
//  $parent：0表示显示在屏幕上（默认）；1表示显示在屏幕上（受scale影响）；2表示显示在地图上；字符串表示显示在某个角色上；
<font color='yellow'>game.showimage(image, properties={}, id=undefined);</font>

<font color='yellow'>game.delimage(id)</font>：删除图片，id为图片标识。

//显示精灵
//spriteEffectRId为精灵名；properties为精灵属性；id为精灵标识（用来控制和删除）
//properties：包含 SpriteEffect组件 的所有属性 和 $x、$y、$width、$height、$parent 等属性；还包括 $clicked、$doubleClicked、$looped、$finished 事件的回调函数；
//  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
//    不带$表示按像素；
//    带$的属性有以下几种格式：
//      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
//        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示全屏的百分比；为3表示居中后偏移多少像素，为4表示居中后偏移多少固定长度；
//      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
//        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示全屏的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
//  $parent：0表示显示在屏幕上（默认）；1表示显示在屏幕上（受scale影响）；2表示显示在地图上；字符串表示显示在某个角色上；
<font color='yellow'>game.showsprite(spriteEffectRId, properties={}, id=undefined);</font>

//删除精灵，id为精灵标识
<font color='yellow'>game.delsprite(id=-1);</font>

//设置操作（遥感可用和可见、键盘可用）；
//参数$gamepad的$visible和$enabled，$keyboard的$enabled；
//参数为空则返回遥感组件，可自定义；
<font color='yellow'>game.control(config={});</font>

<font color='yellow'>game.scale(n)</font>：将场景缩放n倍；可以是小数。
<font color='yellow'>game.setscenerole(r)</font>：场景跟随某个角色。
<font color='yellow'>game.pause()</font>：暂停游戏。
<font color='yellow'>game.goon()</font>：继续游戏。
<font color='yellow'>game.setinterval(interval)</font>：设置游戏刷新率（interval毫秒）。

<font color='yellow'>game.wait(time)</font>：暂停time毫秒。
<font color='yellow'>game.rnd(start, end)</font>：返回start~end之间的随机整数（包含start，不包含end）。
<font color='yellow'>game.toast(msg)</font>：显示msg提示。

//显示窗口；
//params：
//  $id：0b1为主菜单；0b10为战斗人物信息；0b100为道具信息；0b1000为系统菜单；
//  $value：战斗人物信息时为下标；
//  $visible：为false表示关闭窗口；
//style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
<font color='yellow'>game.window(params=null, style={}, pauseGame=true);</font>

<font color='yellow'>game.date()</font>：返回 JS 的 new Date()对象。

<font color='yellow'>game.checksave("文件名")</font>：检测存档是否存在且正确，失败返回false，成功返回存档对象（包含Name和Data）。
<font color='yellow'>game.save("文件名", showName="", 是否压缩)</font>：存档（将game.gd存为 文件），showName为显示名。
<font color='yellow'>game.load("文件名")</font>：读档（读取数据到 game.gd），成功返回true，失败返回false。
<font color='yellow'>game.gameover(params)</font>：游戏结束（调用游戏结束脚本）；

<font color='yellow'>game.loadjson(fileName, filePath="")</font>：读取json文件，失败返回null，返回解析后对象；fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径。

<font color='yellow'>game.run(strScript, ...params)</font>：执行脚本命令（注意：此命令会将脚本放入game系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）。
<font color='yellow'>game.runFirst(strScript, ...params)</font>：同上；
<font color='yellow'>game.script(fileName, filePath)</font>：执行脚本文件（注意：此命令会将脚本放入game系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）；参数同game.loadjson。
<font color='yellow'>game.scriptFirst(fileName, filePath)</font>：同上；
<font color='yellow'>game.lastreturn</font>：脚本上次返回的值；
<font color='yellow'>game.lastvalue</font>：脚本上次返回的值（return+yield）；

<font color='yellow'>game.evalcode(data, filePath="", envs={})</font>：立即执行脚本命令，失败返回null，成功返回结果；filePath为异常时提供的文件名（目前不支持字符串中的函数异常），envs是额外的上下文环境；和 game.evaluate 的区别是，这个执行时自带所有的上下文环境。
<font color='yellow'>game.evalfile(fileName, filePath="", envs={})</font>：立即执行脚本文件，失败返回null，成功返回结果；fileName、filePath参数同game.loadjson，envs参数同game.runcode；和 game.evaluateFile 的区别是，这个执行时自带所有的上下文环境。

<font color='yellow'>game.evaluate(program, filePath="", lineNumber = 1)</font>：用C++执行program脚本命令（类似runcode）；在初始化时已注入game上下文环境；优点是异常时可提供文件路径；无初学者不要用。
<font color='yellow'>game.evaluateFile</font>：用C++执行脚本文件（类似runfile）；在初始化时已注入game上下文环境；优点是异常时可提供文件路径；初学者不要用。
<font color='yellow'>game.importModule</font>：用C++导入一个脚本（脚本可以使用import和export指令，但只能导入一次，也不能卸载，所以不方便调试）；初学者不要用。


战斗脚本（战斗脚本可以使用game属性）：
<font color='yellow'>fight.over(r=0)</font>：结束战斗；-1为失败并调用战斗结束脚本，1为胜利并调用战斗结束脚本，0为平局并调用战斗结束脚本。
<font color='yellow'>fight.msg(msg, interval=60, pretext='', type=2, pauseGame=true)</font>：弹出提示框（同game.msg）。

//combatant获得Buff；
////buffCode：12345分别表示 毒乱封眠 属性，params是参数，override表示是否覆盖（如果不覆盖，则属性名后加时间戳来防止重复）；
//  buffCode：
//    1毒：params有buffName、round、harmType（1为直接减harmValue，2为剩余HP的harmValue倍）、harmValue、flags；
//    2乱、3封、4眠：buffName、round、flags；
//    5属性：buffName、round、properties、flags；
//        properties：[属性名, 值, type]：type为0表示相加，type为1表示 与属性相乘；
//      flags：表示 毒乱封眠属性 类型，也可以表示 buff类型，实质就是决定什么时候运行脚本（见commonBuffScript）；
<font color='yellow'>fight.getbuff(combatant, buffCode, params={}, override=true);</font>
<font color='yellow'>fight.background(image)</font>：切换战斗背景图片；image为图片名。


<font color='yellow'>fight.run(strScript, ...params)</font>：执行脚本命令（注意：此命令会将脚本放入fight系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）。
<font color='yellow'>fight.runFirst(strScript, ...params);</font>
<font color='yellow'>fight.script(fileName, filePath)</font>：执行脚本文件（注意：此命令会将脚本放入fight系统脚本引擎中等候执行，一般用来在Maker中载入外部脚本文件）；参数同game.loadjson。
<font color='yellow'>fight.scriptFirst(fileName, filePath);</font>

//得到某个战斗角色的 所有 普通技能 和 技能；
//types：技能的type，系统默认0为普通攻击，1为技能
//flags：0b1，战斗人物自身拥有的技能：所有道具所有的普通攻击；0b10：战斗人物拥有的所有装备上附带的所有的技能；
//返回数组：[技能名数组, 技能数组]。
<font color='yellow'>fight.$sys.getCombatantSkills(combatant, types=[0, 1], flags=0b11);</font>



脚本变量：

  game.d：用户自定义地图变量集合（切换地图后清空）。
  game.f：用户自定义地图函数集合（切换地图后清空）。
  game.gd：用户自定义全局变量集合（整个游戏可用，会写入存档）。
  game.gf：用户自定义全局函数集合（整个游戏可用）。
    支持用 let、var、const定义局部变量。
  game.math 或 Math：JS 的 Math对象。

  game.gd["$sys_map"]：当前地图信息
    .name：当前地图名


  game.$projectpath：项目根目录。
  game.$userscripts：//用户脚本（用户 common_scripts.js，如果没有则指向 GameMakerGlobalJS）
  game.$globalLibraryJS：一些JS公共方法；
  game.$global：提供跨平台、自适应的一些方法；
  game.$globalJS：一些公共方法；
  game.$gameMakerGlobal：Maker的公共对象；
  game.$gameMakerGlobalJS：一些Maker的相关方法；
  game.$config：项目配置；
  game.$plugins：所有的插件对象；


  fight.d：用户自定义战斗变量集合（战斗结束后清空）。
  fight.myCombatants：我方数组。
  fight.enemies：敌方数组。



NPC事件的四种写法（前两种支持同步调用）：
  game.f["角色游戏名"] = "。。。"   （推荐写法）
  game.f["角色游戏名"] = function*(){。。。}
  game.f["角色游戏名"] = function(){。。。}
  game.f["角色游戏名"] = ()=>{。。。}

定时器事件（写法同上）：
  局部定时器：game.f["局部定时器名"]
  全局定时器：game.gf["全局定时器名"]



如何载入外部脚本：
  由于QML环境没有好的载入外部js脚本的方式，本人也用了一些奇淫技巧来实现了相对便捷的方法来做到了。
    项目中的各种相关脚本几乎都是固定路径和名字的，如果需要在脚本js种导入外部脚本，可以用QML的方式来导入：
        .import '相对路径/xx.js' as JsName
        然后就可以使用JsName中的函数和数据了。

  旧的说明：
  1、涉及到算法的脚本，用 game.evaluateFile 或 game.evalfile 命令来立即执行并会返回结果；
    （技术说明：推荐用前者，底层是C++执行，异常时会准确报错；后者是用eval执行，函数内的函数异常时只能报eval错误；但后者执行有脚本的上下文环境）
  2、涉及到事件的脚本，用 game.script 命令来队列执行，调用run的时候才返回结果；
  编辑器中有提示，请注意不要用错。



同步代码调用说明：
  由于Javascript本身是异步调用，所有的指令都是一瞬间运行完毕。比如你想让人物说几句话，这样调用的话：
    game.talk("第1句")
    game.talk("第2句")
    game.talk("第3句")
  默认是一瞬间执行到了第3句指令，第1句和第2句会一闪而过看不到，如果你想一句一句执行，等每一句彻底执行完毕再执行下一句，则应该这样：
    yield game.talk("第1句")
    yield game.talk("第2句")
    yield game.talk("第3句")
  没错，只需要前面加一条 yield 单词就可以了。
  目前所有指令都支持同步调用，但真正有意义的异步命令：
    game.msg
    game.talk
    game.wait
    game.menu
    game.input
    fight.msg
    战斗时的技能事件



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
    事件列表：单击可以选择当前事件进行绘制；双击可以编辑事件名；
    事件：编辑地图的所有事件（事件名就是函数名）；

    注意：地图编辑器有小概率会崩（估计是QML的canvas大小限制问题，这是QML环境的BUG，后期会用OpenGL替换后应该能解决），所以有个小技巧就是，经常保存，且用不同的地图名，如果崩了可以用上一个保存的地图，等地图完善了再保存为正式的名字，其他的删除。


其他说明：
  游戏载入脚本：在游戏一开始时执行，主要是载入初始地图、创建主角、创建属性、变量等；
  地图载入脚本：在载入地图时执行，主要是清空原NPC、创建NPC、创建NPC脚本等；

  游戏刷新率：建议5~50，根据游戏实际情况设置（经测试低端手机最高FPS能达到60左右）；
  角色速度：为了匹配所有游戏刷新率，将其定义为 像素/毫秒，具体要根据图块大小来设置（一般设置为0.1-0.2即可）；

  游戏退出时会自动存到名为 savedata 的存档；


游戏工程和数据主目录：
  1、windows环境，在 可执行程序 目录下的GameMaker\\Projects 目录下；
  2、android环境，在 /storage/emulated/0/Leamus/MakerFrame/RPGMaker/Projects 目录下；

  工程打包后导出的路径为 Projects/工程名.zip；



关于游戏制作流程：
  1、最必须的：一张地图和一个主角；
  2、生动一点：多个地图和多个角色，完善地图事件和角色事件，地图可切换；
  3、加入音乐；
  4、高级一点，开始做战斗吧，先加入几个图片作为背景；
  5、然后做几个特效（特效是战斗角色和各种技能的基础可视素材）；
  6、创建几个战斗角色；
  7、创建几个技能；
  8、创建几个战斗脚本；
  9、在地图事件中使用脚本来创建战斗角色，并给予他们技能，然后进入战斗；
  10、完善升级链和一些通用脚本；



关于脚本的编写方式和几点说明：
  1、地图脚本：
    function *start()：载入地图时触发的脚本；
    function *其他()：其他为 某角色、某地图事件或某定时器 的脚本；
      注意：这些也可以定义 在start脚本中的 game.f 中，但上面function的优先级高；
  2、道具脚本：
    解释：
        $name：游戏中显示名称；
        $description：描述详情；
        $image：图标；
        $size：大小；
        $type：//1为装备；2为普通使用；3为战斗使用；4为剧情类；
        $position：//装备位置；
          注意：1、武器是特殊位置，普通攻击时会使用 武器 的 skills；2、脚本命令可以重定义给战斗角色装备的位置；
        $price：//买卖金额，false表示不能买卖；
        $skills：道具所带技能（1、此时道具作为装备，且为 武器 时可用；2、目前只用到第一个）；
        $equipEffectAlgorithm：//装备效果；
        $equipScript：装备脚本；
        $useScript：使用脚本；
        $fightScript：战斗时对应的技能；
  3、战斗角色
    战斗角色的脚本都是可选的。
    格式：
      let $createData = function(){return {RId: "killer2", $name: "敌人1", $properties: {HP: 5, healthHP: 5, remainHP: 5, EXP: 5}, $skills: [{RId: "fight"}], $goods: [{RId: '西瓜刀'}], $money: 5};}
        在战斗脚本中可以修改覆盖这些属性。
      function *$levelUpScript(combatant)：角色单独升级链
        如果不定义，则使用通用的升级链算法；
      function $levelAlgorithm(combatant, targetLevel) {
        级别对应的 各项属性 算法（升级时会设置，可选；注意：只增不减）；
        如果不定义，则使用通用的算法；
  4、技能（估计最复杂的）
    说明：
      $name：游戏中显示的名称；
      $description：描述；
      $type：1为选敌方；2为选我方；0为不选（全体技能）；
      $choiceScript：选择技能时脚本
      $playScript：技能产生的效果 和 动画（最复杂难理解的地方，但可以做出各种不错的特效动画效果）；
      $check：是否可以触发（可以用MP判断）；
  5、战斗脚本
    说明：
        $backgroundImage：背景图文件；
        $music：背景音乐；
        $runAway：是否可以逃跑；true则调用 通用逃跑算法；0~1则为概率逃跑；false为不能逃跑；
        $enemyFightRoles：//敌人ID的数组；
        $enemyCount：敌人数；//数字或数组（m-n）的随机排列，如果为true则表示按顺序排列；
        $enemiesData：敌人属性数据，可以覆盖战斗角色中定义的数据；
        $fightRoundEvent：回合事件；
        $fightStartEvent：开始事件；
        $fightEndEvent：结束事件；
  6、通用脚本：
    //游戏结束脚本
    function *$gameOverScript(params) {
    //通用逃跑算法
    function $runAwayAlgorithm(team, roleIndex) {
    //技能效果算法
    function $skillEffectAlgorithm(team1, team2, skillEffect) {
    //战斗开始通用脚本；
    function *$commonFightStartScript() {
    //战斗回合通用脚本；
    function *$commonFightRoundScript(round) {
    //战斗结束通用脚本；
    function *$commonFightEndScript(r, exp, money) {
    //恢复算法
    function $resumeEventScript(combatant) {
    //装备预留槽位（会显示这些槽位，且按顺序排，不在里面的会追加在后面）；
    let $equipReservedSlots = ['头戴', '身穿', '武器', '鞋子'];
  7、通用升级链算法（集成在了通用脚本里）：
    格式：function *commonLevelUpScript(combatant) {//升级脚本
        function commonLevelAlgorithm(combatant, targetLevel) {    //级别对应的 各项属性 算法（升级时会设置，可选；注意：只增不减）
    注意：如果没有单独的战斗人物升级链，则使用通用的。



一些注意点：
    1、游戏中脚本引入的 资源ID（比如特效、角色、道具等），指的是你保存时列表中的名称，并不是脚本中定义的name；
    2、已经实现打包到win、安卓平台的功能，但安卓平台麻烦一点，因为需要打包apk和签名的问题，由于个人时间精力不足，所以提供了APK所需的资源和三方打包签名工具，多一步而已，很方便（尽量使用已有的好东西嘛）；
    3、目前编辑器是在线版本，因为经常需要修改，很有可能就不兼容旧项目了，所以先不弄离线版，等稳定了出离线的；
    4、已知Bug：
        a、经不准确测试，地图编辑器最多支持1920*1920像素（32位armv7）和3200*3200像素（64位armv8），太大有可能导致绘制卡顿或报错、黑屏等问题，这是由于引擎使用了QML的Canvas组件，效率比较低，后期如果用nano/opengl库会好很多（目前只是集成还没有替换）；
    5、想起来再说。



系统其他功能：
  适合高级玩家，包括：
    1、文件、文件夹操作；
    2、压缩解压（zip）操作；
    3、下载文件（FrameManager.sl_qml_DownloadFile）；
    4、剪切板操作（FrameManager.sl_qml_SetClipboardText）；
    5、动态载入卸载QRC资源：FrameManager.registerResource、FrameManager.unRegisterResource；
    6、登录、联机、远程存档等；
    7、本地系统功能（二维码、摄像头、GPS、屏幕旋转、屏幕常量、请求权限等）；
    8、播放音频视频；
    9、远程MySQL数据库操作；
    10、本地SQLite操作；
    11、ini文件操作；
    12、JSON文件操作；
    13、JS文件操作；
        其他：包括URL加密解密、清空QML缓存、HTML/Markdown/TXT格式操作、封装了部分QObject方法、给QML发送队列事件；
    14、扩展自定义可视化命令；




安卓打包流程：
    1、下载 AndroidPackage_vXX.zip 文件（Qt安卓的APK包文件），并解压；
    2、下载 MakerRuntime_vX.Y.Z.zip（游戏运行QML环境，请选择你项目使用的Maker版本），并解压，将解压后的 目录（assets）和 所有文件 移动到第一步解压的目录下；
    3、将你的 工程 复制到第一步解压的目录下，重命名为 Project；
    4、打开 APKTool M，找到第一步解压的文件夹，打开，点“编译此项目”，即可生成APK；
    5、编译前可以修改 AndroidManifest.xml 信息（包括 图标、包名、应用名、权限等），也可打包APK后再编辑信息（点击APK文件->快速编辑 或 详情）。

    APKTool M切换中文：右上角菜单->第一个选项->第一个菜单->倒数第5个 就是选语言。



<font color='red'>Javascript简易教程</font>
  【】 表示 可选。

1、变量
可以使用 var、let、const（常量）来定义，格式：
  var/let/const 变量名 【= 初始值】;
后期也可以取值或赋值：
  变量名 = 新值;
脚本环境中已经有两个特定对象，可以存储变量：
  game.gd['名称'] = 变量;
  game.d['名称'] = 变量;

区别：
game.gd是全局变量，在所有的脚本里都可以使用（生命周期为整个游戏，存档主要就是存它，可以存放金钱、事件等等）；
game.d是地图变量，在地图中有效，切换地图后会清空，可做临时变量。


2、数据类型
主要有 数字、字符串、布尔、数组、对象、null、undefined，其他的基本用不到，可以参考ES6。
数字：整数、浮点数、负数，支持16进制、8进制和2进制。一般可以用来运算。
字符串：用单引号或双引号扩起的一串任意字符组成的，叫字符串。一般用来显示一些文字（对话等）。
  比如：
    '你好'
    "！@#￥%……&*（）||、、、"
  注意的是单引号或双引号必须成对出现，而且不能混用：'hello"
  引号里可以出现引号，必须用 \ 来转义，比如：
    "我说 \"你好\" "
  不同引号可以不转义：
    "我说 '你好' "

布尔：只有 true 和 false两个值，可以用来标记事件，例如：
if(game.gd["事件1"]) {
  game.gd["事件1"] = true;
  。。。事件1触发代码
}

数组：一个有序的集合，比如选择框里需要用到。
  定义格式：
    let 数组名 = [元素1、元素2、元素3。。。];
      比如：
        let choices = ['男', '女', '未知性别']
    元素可以是任意类型的值，甚至也可以是数组和对象。
  使用：
    数组名[下标]
    下标是从0开始的，写几就返回第几个的值。也可以修改数组：
    数组名[下标] = 新值
  返回数组里元素个数：
    数组名.length

对象：一个具有key和value键值对的集合，一般可以保存一个具体角色、物品的属性。
  定义格式：
    对象名 = {key1: value1, key2, value2, 。。。}
    比如：
    let 角色1 = {'攻击': 100, name: '小鬼', '防御': 10。。。}
  使用：
    对象名[key名] 或 对象名.key名
    建议使用前者，后者的key名只能是标准变量格式（英文、下划线或$开头，其余的英文、下划线、$和数字组成的名称）才可以使用
    比如：
    角色1['攻击']	//会返回100
    角色1.name = '大鬼'	//重新设置

null：只有一个值，一般用的少

undefined：没有赋值变量 和 没有定义的数组下标值、对象key 都是 undefined。
比如：
  let varName;	// varName 此时是 undefined。
  let obj = {};	//一个空对象，此时使用obj内所有的key值都是undefined。
  let arr = [];	//一个空数组，此时使用arr内所有的下标值都是undefined。


3、语句流程
和大多数编程语言一样，脚本有3种语句流程：顺序、条件、循环。
脚本默认是从上到下按顺序执行的。
条件：
  if(条件)单条语句;

  if(条件)
  {
    多条语句。。。
    。。。
  }

  也支持switch语句，具体可以看ES6教程。

循环：
  for(初始化;条件;递增) {
    语句。。。
  }

  while(条件) {	//如果条件成真，则一直执行 语句
    语句。。。
  }

  do {
    语句。。。
  }while(条件);	//至少执行一遍


4、函数
  函数（方法）可看作是一系列脚本命令组成的可复用的代码块。
  定义有3种：
  function 函数名(参数。。。){	//可以没有参数
    脚本命令、语句。。。
  }

  也可以：
  函数名 = (参数。。。)=>{
    脚本命令、语句。。。
  }

  运行函数：
  函数名(实参。。。);

  还有一种特殊的函数（其实叫生成器）：
  function *函数名(参数。。。){	//注意和普通函数名只是多了个 * 号
    脚本命令、语句。。。
  }

  生成器简单的来讲，就是可以用yield关键字返回一个值，下次进入仍然可以从返回的地方继续执行（很适合做异步脚本），而普通函数是一口气执行完，下次调用又是从头开始执行。
  游戏中有些命令是必须用yield来标记脚本语句的，就是这个原因，比如 game.talk，如果不用yield，则一口气会将所有的话显示出来（结果就是只显示最后一个game.talk），不会等一条一条显示的。


5、其他：
  a、脚本的关键字、变量名都是区分大小写的，不注意大小写可能会出错，比如：
    iF	//应该是if
    var choice;  //后面使用不能用 Chioce、cHoice等等

  b、注释：
    注释就是给你的脚本做说明，本身不会执行。有两种：
    //  这个是行注释，它后面的所有都是注释
    /* 这个是块注释，可以在一行内，也可以在多行内
      现在是多行。。。
      。。。
    */

  c、关于自动转换：
  Javascript最容易错的地方之一，就是自动转换，这里举例子说明：
  1 + 1	//2，数字运行
  '1' + 1	//11
  1 - 1	//0
  '1' - 1	//0

  因为+号既是运算符，也是字符串拼接符，所以规定：+号两面如果有一个是字符串，则就会进行字符串拼接（另一个也会转换为字符串），如果需要作为运算，则必须将字符串转换为数字：用parseInt或parseFloat括住即可：
    parseInt('1') + 1	//2
  因为-、*、/、% 号只是运算符，出现字符串时引擎会尝试将字符串自动转换为数字来运算。

  d、关于if和for的条件的真假：
  JS规定：
    当值为 true、非0、!NaN、[]、{} 为 真
    当值为 false、0、undefined、null、""、0 或 NaN 为 假。
    用 !可以取反：!真 为 假，!假 为 真。


`
        msgBox.text = GlobalLibraryJS.convertToHTML(t);
    }
}
