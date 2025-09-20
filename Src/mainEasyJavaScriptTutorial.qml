import QtQuick 2.14
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
        console.debug('[mainEasyJavaScriptTutorial]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainEasyJavaScriptTutorial]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainEasyJavaScriptTutorial]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainEasyJavaScriptTutorial]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        const t = `
<CENTER><B>JavaScript简易教程</B></CENTER>

  【】 表示 可选。

1、变量
可以使用 var、let、const（常量）来定义，格式：
  var/let/const 变量名 【= 初始值】;
后期也可以取值或赋值：
  变量名 = 新值;
游戏环境中已经有一些个特定对象，可以存储用户的所有变量和值，用法：
  game.gd['名称'] = 变量/值;
  game.d['名称'] = 变量/值;
区别：
  game.gd：全局变量，在所有的脚本里都可以使用（生命周期为整个游戏，存档读档都是自动存取它，可以存放金钱、事件标记等等）；
  game.d：地图变量，在地图中有效，切换地图后会清空，可做临时变量；
  game.gf：也是全局变量，但它不会自动存档读档，它一般用来存放游戏全局函数，一些特定事件就会从它的函数里寻找；而且它会自动读取工程根目录下的 game.js 并存入；
  game.f：类似game.d，也是地图变量，它一般用来存放地图函数，一些特定事件也是从它的函数里寻找（优先于game.gf）；
  game.cd：引擎变量，一般比较少用，全局可用，只要进入游戏就一直可用，跨存档共享，比如可以存放玩家的总游戏时长；


2、数据类型
主要有 数字、字符串、布尔、数组、对象、null、undefined，其他的基本用不到，有需要可以参考ES6。
数字：整数、浮点数、负数，支持16进制、8进制和2进制。一般可以用来运算。
字符串：用单引号或双引号扩起的一串任意字符组成的，叫字符串。一般用来显示一些文字（对话等）。
  比如：
    '你好'
    "！@#￥%……&*^（）||、"
  注意的是单引号或双引号必须成对出现，而且不能混用：'hello"
  引号里可以出现引号，必须用 \\ 来转义，比如：
    "我说 \\"你好\\" "
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

  if(条件) {
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
  } while(条件);	//至少执行一遍


4、函数
  函数（方法）可看作是一系列脚本命令组成的可复用的代码块。
  定义有3种：
  function 函数名(参数。。。) {	//可以没有参数
    脚本命令、语句。。。
  }

  也可以：
  函数名 = (参数。。。)=>{
    脚本命令、语句。。。
  }

  运行函数：
  函数名(实参。。。);

  还有一种特殊的函数（其实叫生成器）：
  function* 函数名(参数。。。) {	//注意和普通函数名只是多了个 * 号
    脚本命令、语句。。。
  }

  生成器简单的来讲，就是可以用yield关键字返回一个值，下次进入仍然可以从返回的地方继续执行（很适合做异步脚本），而普通函数是一口气执行完，下次调用又是从头开始执行。
  游戏中有些命令是必须用yield来标记脚本语句的，就是这个原因，比如 game.talk，如果不用yield，则一口气会将所有的话显示出来（结果就是只显示最后一个game.talk），不会等一条一条显示的。


5、其他：
  a、脚本的关键字、变量名都是区分大小写的，不注意大小写可能会出错，比如：
    iF	//应该是if
    var choice;  //后面使用不能用 Choice、cHoice等等

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
`;
        msgBox.text = $CommonLibJS.convertToHTML(t);

        console.debug('[mainEasyJavaScriptTutorial]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainEasyJavaScriptTutorial]Component.onDestruction');
    }
}
