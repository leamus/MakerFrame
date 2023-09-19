//.pragma library //单例（只有一个实例的共享脚本，且没有任何QML文件的环境。如果不加这句，则每个引入此文件的QML都有一个此文件的实例，且环境为引入的QML文件环境）。
//库文件不能使用 导入它的QML的上下文环境，包括C++注入的对象 和 注册的类，但全局对象可以（比如Qt）；给js全局对象注入的属性也可以（比如FrameManager.globalObject().game = game）。


//.import "xxx.js" as Abc       //导入另一个js文件（必须有as，必须首字母大写）
//.import "GlobalLibrary.js" as GlobalLibraryJS
//.import "Global.js" as GlobalJS
//let jsLevelChain = JSLevelChain;    //让外部可访问


//.import QtQuick.Window 2.14 as Window   //导入QML模块（必须有as，必须首字母大写）
//  （非库文件：如果没有任何.import语句，则貌似可以直接使用 QML组件，如果有一个.import，则必须导入每个对应组件才可以使用QML组件!!!）


