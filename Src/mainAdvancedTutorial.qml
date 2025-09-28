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
            id: notepad

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
        console.debug('[mainAdvancedTutorial]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainAdvancedTutorial]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainAdvancedTutorial]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainAdvancedTutorial]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        const t = `
<CENTER><B>高级教程</B></CENTER>

1、精确定时器 //~~~~~~~
    示例：
    $Frame.preciseTimer.sg_triggered.connect(function(interval){console.info(interval)});
    $Frame.preciseTimer.sl_start(1);
    $Frame.preciseTimer.sl_stop();
2、多线程   //~~~~~~~
    示例：
    let taskID = $Frame.sl_insertScriptTask('console.info(0)', 0, 2, function(params){console.info(999, params)});
    或：
    let taskID = $Frame.sl_insertScriptTask('test.mjs', 666, -1, function(params){console.info('params:', params);console.info(999, params.$$toJson())});

    $Frame.sl_setThreadMaxCount(2);
    let taskParam = $Frame.sl_getScriptTask(taskID);
    //console.info('taskParam', taskParam, taskParam.$$toJson());
    console.info(taskParam.Running.sl_isFinished(), taskParam.Running.sl_isRunning());
    $Frame.sl_cancelScriptTask(taskID);
    //taskParam.Running.sl_terminate();
    //taskParam.Running.sl_isFinished();
    //taskParam.Running.sl_isRunning();
    //taskParam.Running.sl_wait(3000);
3、QML 访问网络/下载文件 //~~~~~~~
  a、使用封装底层的C++方案：
    示例：
    const httpReply = $Frame.sl_request(url, baVerb, baPostData, mapHeaders);
    const httpReply = $Frame.sl_downloadFile(url, filepath);
    if(httpReply)
        httpReply.sg_finished.connect(function(httpReply) {
            const networkReply = httpReply.networkReply;
            //$Frame.sl_objectProperty('属性', networkReply);  //~ ID（m_mapNetworkReply的ID）、Data（保存的QByteArray数据或QFile指针）、SaveType（保存类型）、Code
            //console.debug(httpReply, $Frame.sl_objectProperty('Data', httpReply.networkReply), Object.keys(httpReply.networkReply));

            $Frame.sl_deleteLater(httpReply);
        });
  b、使用封装的异步/协程方案：
    示例：
      使用回调函数：
        $CommonLibJS.request({
            Url: url,
            Method: 'GET',
            //Data: {},
            //Gzip: [1, 1024],
            //Headers: {},
            //FilePath: path,
            //Params: ,
        }, 2).$$then((xhr)=>{
            console.info(xhr.responseText, xhr.$$json));
        }).$$catch((e)=>{
            console.info(e, e.$params.$$json);
        });
      或 使用异步：
        $CommonLibJS.asyncScript(function*() {
            try {
                let res = yield $CommonLibJS.request({
                    Url: url,
                    Method: 'GET',
                    //Data: {},
                    //Gzip: [1, 1024],
                    //Headers: {},
                    //FilePath: path,
                    //Params: ,
                    //CustomData: customData,
                }, 2);
                console.info(res.responseText, res.$$json);
            }
            catch(e) {
                console.info(e, e.$params.$$json);
            }
        });
4、HTTPServer(Libhv)    //~~~~~~
    示例：
    HTTPServer {
        id: httpServer
        service: HTTPService {
            id: httpService
        }
    }

    httpService.baseURL = '/v1/api';
    //方式1：使用sl_addRoute添加路由，这种方式使用QML主线程来处理；
    httpService.sl_addRoute('POST', '/echo', function(body){return {code: 200, data: 'hello1'}});
    httpService.sl_addRoute('GET', '/user/:id', function(body){return {code: 200, data: 'hello2'}});
    httpService.sl_addRoute('/echoAll', function(body){return {code: 200, data: 'hello3'}});
    //方式2：使用sl_addJSFileRoute添加JS文件的路由，这种方式使用 子线程+QJSEngine 来处理；
    httpService.sl_addJSFileRoute($GlobalJS.toPath(Qt.resolvedUrl('testHTTPServerRoute.js')));
    httpService.sl_static('/static/', 'd:/');
    httpServer.port = 8999;
    httpServer.sl_run();
    ...
    httpServer.sl_stop();

    JS路由格式：
    export default [
        ['GET', '/get1', function(body) {
            console.info(body); return {code: 200, data: 'hello3'};
        }],
        ['POST', '/post1', function(body) {
            console.info(body); return {code: 201, data: 'hello4'};
        }],
    ]
5、TCPSocket
    TCPSocket {
        id: tcpSocket

        Component.onCompleted: {
            tcpSocket.sg_hostFound.connect(function(tcp) {
                console.info('sg_hostFound', tcp);
            });
            tcpSocket.sg_connected.connect(function(tcp) {
                console.info('sg_connected', tcp);
            });
            tcpSocket.sg_disconnected.connect(function(tcp) {
                console.info('sg_disconnected', tcp);
            });
            tcpSocket.sg_stateChanged.connect(function(state, tcp) {
                console.info('sg_stateChanged', state, tcp);
            });
            tcpSocket.sg_errorOccurred.connect(function(error, tcp) {
                console.warn('sg_errorOccurred', error, tcp);
            });


            tcpSocket.sg_readyRead.connect(function(data, tcp) {
                console.info('sg_readyRead', data, tcp);
            });
            tcpSocket.sg_bytesWritten.connect(function(bytes, tcp) {
                console.info('sg_bytesWritten', bytes, tcp);
            });
            tcpSocket.sg_aboutToClose.connect(function(tcp) {
                console.info('sg_aboutToClose', tcp);
            });
        }
    }
    。。。
    tcpSocket.sl_connectToHost('127.0.0.1', 8899);
6、TCPServer
    TCPServer {
        id: tcpServer

        onSg_newConnection: {
            console.info('onSg_newConnection:', id, tcpSocket);


            tcpSocket.sg_hostFound.connect(function(udp) {
                console.info('sg_hostFound', udp);
            });
            tcpSocket.sg_connected.connect(function(udp) {
                console.info('sg_connected', udp);
            });
            tcpSocket.sg_disconnected.connect(function(udp) {
                console.info('sg_disconnected', udp);
            });
            tcpSocket.sg_stateChanged.connect(function(state, udp) {
                console.info('sg_stateChanged', state, udp);
            });
            tcpSocket.sg_errorOccurred.connect(function(error, udp) {
                console.warn('sg_errorOccurred', error, udp);
            });


            tcpSocket.sg_readyRead.connect(function(data, udp) {
                console.info('sg_readyRead', data, udp);
            });
            tcpSocket.sg_bytesWritten.connect(function(bytes, udp) {
                console.info('sg_bytesWritten', bytes, udp);
            });
            tcpSocket.sg_aboutToClose.connect(function(udp) {
                console.info('sg_aboutToClose', udp);
            });
        }
        onSg_acceptError: {
            console.warn('onSg_acceptError:', socketError);
        }
    }
7、UDPSocket
    /*~~~~~~
    鹰：貌似两种用法：
      1、类似TCPSocket：
        使用 sl_connectToHost、sl_send、sl_disconnectFromHost、sl_peerAddress、sl_peerPort 等；
      2、类似服务器：
        使用 sl_bind、sl_sendTo 数据为datagram 等；
      注意：
        1、receiveDatagram() 和 readAll() 只能返回一次数据，再调用无效；
          前者类似服务器用法，后者类似TCPSocket用法；
          如果是使用 sl_connectToHost，peerXxx 和 Datagram中的senderXxx、destinationXxx 都没问题；
          如果是使用 sl_bind，peerXxx为空，Datagram中的senderAddress不知为何像IP6（'::ffff:127.0.0.1'），destinationAddress为空，destinationPort为-1，hopLimit为-1
    */
    UDPSocket {
        id: udpSocket

        Component.onCompleted: {
            this.sg_hostFound.connect(function(udp) {
                console.info('sg_hostFound', udp);
            });
            this.sg_connected.connect(function(udp) {
                console.info('sg_connected', udp);
            });
            this.sg_disconnected.connect(function(udp) {
                console.info('sg_disconnected', udp);
            });
            this.sg_stateChanged.connect(function(state, udp) {
                console.info('sg_stateChanged', state, udp);
            });
            this.sg_errorOccurred.connect(function(error, udp) {
                console.warn('sg_errorOccurred', error, udp);
            });


            this.sg_readyRead.connect(function(data, addr, ip, udp) {
                console.info('sg_readyRead', data, addr, ip, udp);
            });
            this.sg_bytesWritten.connect(function(bytes, udp) {
                console.info('sg_bytesWritten', bytes, udp);
            });
            this.sg_aboutToClose.connect(function(udp) {
                console.info('sg_aboutToClose', udp);
            });
        }
    }
    。。。
    udpSocket.sl_connectToHost('127.0.0.1', 8899);
8、载入动态链接库和调用函数  //~~~~~~~
    let lib = $Frame.sl_loadLibrary(libName);
    if(lib !== null) {
        //运行Qt函数（参数是QVariant类型）
        let res = lib.sl_runQtFunction('funtionName', args);
        或：
        //运行普通函数（参数是字符串，需自己处理）
        let res = lib.sl_runFunction('funtionName', 'args');
    }
9、安卓广告  //~~~~~~~
    目前支持 Tap和CSJ（穿山甲） 两个广告SDK，用法基本相同；
    示例1（回调方式）：
        //params：Callback为 广告关闭回调函数（参数为adData、customData）；Data为用户数据（回调时会携带）；Type：广告类型；Info：广告信息；Flags：调用标志位；ErrorCallback：错误回调函数；
        //  Callback：两个参数：adData（广告结果数据）、customData（调用ad时传入的Data）；
        //  Type：为1是激励广告；
        //    Info：广告相关数据；
        //      ForceInit：强制初始化（默认为false，表示只初始化一次，再次调用只发送信号；为true表示再次进行初始化，但得看sdk是否支持重新初始化）；
        //    Flags：从右到左为：初始化、载入广告、播放广告；
        //      注意：如果都设置，则在回调中会正确处理（连续调用）；
        //        初始化调用一次即可（可调用多次但无效），载入广告和播放广告必须每次都调用；
        //        Flags可以初始化时使用 0b1，后期直接用b110播放 也行；也可以每次 0b111；
        $Platform.Tap.ad({     //Tap广告
        //$Platform.CSJ.ad({   //CSJ广告
            Callback: function(adData, customData) {
                console.info(adData, customData);
                if(adData.Flags & 0b11) {
                    if(adData.Flags & 0b10) {
                        //播放完毕回调;
                    }
                    else if(adData.Flags & 0b1) {
                        //奖励回调;
                    }
                }
                else {
                    //进入广告回调;
                }
                if(adData.Flags & 0b100) {
                    //点击广告回调;
                }
            },
            CustomData: '传递给回调函数的自定义参数',
            //Tap的信息
            Info: {MediaID: 100XXXX, MediaName: '鹰歌软件框架&游戏引擎',
                MediaKey: '你的MediaKey',
                MediaVersion: '1', GameChannel: 'taptap2', TapClientID: '你的TapClientID',
                Oaid: '', ForceInit: false,
                SpaceID: 100XXXX},
            //CSJ的信息
            //Info: {AppID: '549XXXX', AppName: '鹰歌软件框架&游戏引擎', ForceInit: false, MediaID: '10XXXXXXX', Orient: 1},
            Type: 1,
            Flags: 0b111,
            ErrorCallback: function(e) {
                console.warn(e, JSON.stringify(e.$params)); //code, msg, data
            },
        });

    示例2（协程用法）：
        const adData = yield $Platform.Tap.ad({。。。});  //此时可以省略Callback和CustomData
        const adData = yield $Platform.CSJ.ad({。。。});  //此时可以省略Callback和CustomData

10、协程（已经被我封装的用法类似async/await）   //~~~~~~~
    用法一（函数形式，简单使用）：
      $CommonLibJS.asyncScript(scriptInfo, ...params)；
      参数：scriptInfo为函数、生成器函数、生成器或数组（第2个参数为tips字符串）（区别：函数和生成器函数在下一个事件循环中运行，而生成器直接运行）；params是给scriptInfo的参数；
      如果是生成器函数或生成器：
        function*() {
            ...
            res1 = yield x1;
            ...
            try{
              res2 = yield x2;
            }
            catch(e) {
              ...
            }
            ...
        }
        其中 x1、x2：可以是Promise、函数和其他；
          如果是Promise或函数（函数是新增的，类似Promise构造函数的参数，两者的区别是Promise的then是在下次事件循环的微任务中运行，函数是立刻运行，不过我已经用runNextEventLoop处理成和Promise一样的了）；
          如果是函数，则类似 Promise 一样立刻调用，参数是 resolve(res)、reject(error) 两个函数，生成器暂停，直到调用这两个函数其中之一则继续。
          如果是其他，则作为 返回值 传递给生成器（res1、res2）继续向下执行；
      $CommonLibJS.asyncSleep(ms, parent);
      等待ms后再继续运行；

    用法二（对象形式，功能更多）：
      使用AsyncScript产生一个对象来运行，这个对象除了有用法一的功能外，还可以使用waitAll函数等待它的所有生成器运行完毕；
        示例：
        $CommonLibJS.asyncScript(function*() {
            //let as = new $CommonLibJS.AsyncScript();   //创建一个新的
            let as = $CommonLibJS.$asyncScript;          //使用系统创建的

            console.info(this.$context, this.$defer); //如果运行的是Generator Function，则this有这两个属性
            //this.$defer = function(){console.info('哈哈defer')}; //设置$defer
            let oThis = yield; //使用 yield 返回undefined或null，则会将这个This对象返回（针对Generator对象无法注入变量设计）
            console.info(oThis, this, oThis === this);

            console.info(1);
            as.async(function*() { //运行的是 Generator Function，则下个事件循环中运行）
                console.info(2);
            });
            console.info(3);
            as.async(function*() { //运行的是 Generator，则立刻运行
                console.info(4);
            }());
            console.info(5);

            yield as.sleep(1000); //休眠1s，会让出cpu

            as.async(function*() {
                console.info(6);
            });
            console.info(7);
            yield as.waitAll(); //等待 as 的所有生成器运行结束；
            console.info(8);
        });
        //输出 1,3,4,5,2,（等待1s）,7,6,8

    注意：如果在游戏中，可以用 game.async 代替 $CommonLibJS.asyncScript。

11、脚本队列
    游戏中已经封装了一个 主脚本队列，用game.run(script, ...params)来运行，具体见命令教程；
    另一种底层用法：
      scriptQueue = new $CommonLibJS.ScriptQueue();  //创建一个脚本队列
      //const ret = scriptQueue.create([genfunc(...) ?? null, -1, true, 'tips'], ...params); //添加一个脚本（支持 字符串函数、普通函数、生成器和生成器对象）；
      const ret = scriptQueue.create(genfunc(...) ?? null, ...params); //添加一个脚本（支持 字符串函数、普通函数、生成器和生成器对象）；
      scriptQueue.clear(5);     //清空脚本队列；参数不同效果不同；
      scriptQueue.run(value);   //运行一次脚本队列；参数为给脚本中断的yield返回值；
      scriptQueue.runNextEventLoop('tips'); //运行一次脚本队列；放在下次事件循环中；
      scriptQueue.lastEscapeValue;  //上次中断时返回值（yield或return）；
      scriptQueue.lastReturnedValue;    //上次返回值（return）；

12、缓存池
    示例：
    let cacheSprites = new $CommonLibJS.Cache({
        //创建时回调
        $create: function(p) {
            let o = compCacheSpriteEffect.createObject(p);
            /*o.sg_playSoundEffect.connect(function(soundeffectSource) {
                。。。
            });
            */
            return o;
        },
        //初始化回调
        $init: function(o, p) {
            o.visible = true;
            o.parent=p;
            return o;
        },
        //释放回调
        $release: function(o){o.visible = false; o.sprite.stop();return o;},
        //销毁回调
        $destroy: function(o){o.destroy();},
    });

    [spriteEffectComp, bNew] = cacheSprites.get(parent); //从缓存池中获取
    cacheSprites.put(spriteEffectComp); //释放到缓存池
    cacheSprites.clear();   //清空缓冲池

13、IO高级操作
  文件：
    //var f = $Frame.sl_file('c:/1321.txt', 2);
    //或：
    var f = $Frame.sl_file();
    f.sl_setFileName('c:/1321.txt')
    f.sl_open(2);
    //读写：f.io（QIODevice封装类）、f.io.ts（QTextStream封装类）、f.io.ds（QDataStream封装类）
    f.io.sl_write('深林孤鹰');f.sl_flush();
    f.io.ts.sl_write('深林孤鹰');f.io.ts.sl_flush();
    g.io.ds.sl_write('1234');
    f.sl_deleteLater();
  二进制（QBuffer）：
    var b = $Frame.sl_buffer();
    b.io.sl_open(3);
    //读写：b.io（QIODevice封装类）、b.io.ts（QTextStream封装类）、b.io.ds（QDataStream封装类）
    b.io.sl_write('深林孤鹰');b.sl_flush();
    b.io.ts.sl_write('深林孤鹰');b.io.ts.sl_flush();
    b.io.ds.sl_write('1234');
    b.sl_deleteLater();
  二进制（QByteArray）：
    var b = $Frame.sl_byteArray();
    //读写：b.ts（QTextStream封装类）、b.ds（QDataStream封装类）
    b.sl_append('深林孤鹰');
    b.ts.sl_write('深林孤鹰');b.ts.sl_flush();
    b.ds.sl_write('1234');
    b.sl_deleteLater();

14、简单打包流程（详细见官网教程）
    1、win下需要下载 鹰歌环境文件（MakerFrame_GameRuntime_Win_xxxxxx.rar） 和 Qt框架库（QtEnv_Win_xxxxxx.rar），解压放在一起，将工程改名为Project复制到目录下即可；
    2、安卓下需要下载 鹰歌环境文件（MakerFrame_GameRuntime_Android_ALL_xxxxxx.rar） 和 Qt框架库（MakerFrame_Package_Android_ALL_xxxxxx.rar），解压放在特定目录下，将工程改名为Project复制到目录下，使用鹰歌的打包功能进行配置，然后用APKTools打包即可；
    3、如果是安卓打包apk，打开 APKTool M，找到第一步解压的文件夹，打开，点“编译此项目”，即可生成APK；
    4、如果是win打包apk，安装Java并下载我集成好的打包环境，将工程拖动到 _打包.bat 即可生成APK；
    5、配置：鹰歌自带的打包可以简单的配置诸如游戏名、应用名、图标等一些选项，如果要详细配置，可以手动修改GameMakerGlobal.qml、AndroidManifest.xml（包括 图标、包名、应用名、权限等）、Privacy.txt（隐私协议）、Config.cfg（框架配置）、LGlobal（框架配置）、GameRuntime（引擎核心文件）、隐私样式文件（privacy_button_shape.xml、privacy_dialog_shape.xml、privacy_activity_main.xml、privacy_dialog_show.xml）、手动打包x86或x64库 等，打包APK后还可以编辑信息（点击APK文件->快速编辑 或 详情）。
    APKTool M切换中文：右上角菜单->第一个选项->第一个菜单->倒数第5个 就是选语言。

15、其他（详细见官网教程）
    a、文件、文件夹操作；
    b、压缩解压（zip）操作；
    c、剪切板操作（$Frame.sl_setClipboardText）；
    d、动态载入卸载QRC资源：$Frame.sl_registerResource、$Frame.sl_unRegisterResource；
    e、登录、联机、弱网等；
    f、本地系统功能（二维码、摄像头、GPS、屏幕旋转、屏幕常量、请求权限等）；
    g、播放音频视频；
    h、数据库（SQLite、SQLITECIPHER等）操作；
    i、各种格式文件操作（ini、json、js）；
        其他：包括URL加密解密、清空QML缓存、HTML/Markdown/TXT格式操作、封装了部分QObject方法、给QML发送队列事件；
    j、扩展自定义可视化命令；
`;
        notepad.text = $CommonLibJS.convertToHTML(t);

        console.debug('[mainAdvancedTutorial]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainAdvancedTutorial]Component.onDestruction');
    }
}
