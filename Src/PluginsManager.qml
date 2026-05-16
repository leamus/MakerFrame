import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



/*
    鹰：运行扩展的位置：Plugins/A/B/Extends/main.js 或 main.qml（qml优先）
    扩展退出：
      缺省为按返回键；
      或者：qml可以定义一个 sg_close() 信号，或调用 parent.close();
*/



Item {
    id: root


    signal sg_close();


    function $load(type) {
        _private.nType = type;

        if(_private.nType === 2)
            _private.showInstallPlugins();
        else
            _private.showPlugins();
    }



    property var $eval: /*(loader.item ? loader.item.$eval : null) ?? */(()=>(c)=>eval(c))()


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: $Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: $Global.style.backgroundColor
        //radius: 9
    }



    Item { //用来挂载list
        id: itemList
        anchors.fill: parent
    }

    Mask { //扩展背景
        visible: loaderExtends.status === Loader.Ready

        anchors.fill: parent
        //opacity: 0
        color: $Global.style.backgroundColor
        //radius: 9
    }

    L_Loader {
        id: loaderExtends
        objectName: 'PluginsManagerExtendsLoader'


        visible: status === Loader.Ready //false
        //focus: true
        clip: true

        //anchors.fill: parent

        //active: false
        //source: ''
        //asynchronous: true



        Connections {
            target: loaderExtends.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loaderExtends.close();
                //_private.showPlugins();
            }
        }


        onStatusChanged: {
            console.debug('[PluginsManager]loaderExtends onStatusChanged:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                close();
                //active = false;

                //_private.showPlugins();
            }
            else if(status === Loader.Null) {
                //visible = false;

                //root.focus = true;
                //root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
            }
        }

        onLoaded: {
            console.debug('[PluginsManager]loaderExtends onLoaded');

            //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
            ///focus = true;
            forceActiveFocus();

            if(item.$load) {
                try {
                    item.$load(...vExtraData);
                }
                catch(e) {
                    $CommonLibJS.printException(e);
                    //console.warn('[!PluginsManager]', e);
                    //throw e;
                }
                finally {
                }
            }

            //visible = true;
        }


        Keys.onEscapePressed: function(event) {
            console.debug('[PluginsManager]Keys.onEscapePressed:loaderExtends');
            event.accepted = true;

            close();
            //_private.showPlugins();
        }
        Keys.onBackPressed: function(event) {
            console.debug('[PluginsManager]Keys.onBackPressed:loaderExtends');
            event.accepted = true;

            close();
            //_private.showPlugins();
        }
    }



    QtObject {
        id: _private

        function showPlugins() {
            //jsLoader.clear();

            const pluginsRootPath = (nType === 1 ? ($GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName) : ($Platform.externalDataPath + '/GameMaker')) + '/Plugins/';
            return _private.$extends.showExtends({
                ExtendsRootPath: pluginsRootPath,
                ExtendPathSearchDepth: 2,
                ExtendRunRelativePath: 'Extends/',
                CachePath: $GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName + '/~Cache/Plugins/',
                ///JSLoader: _private.jsLoader,
                ///JSExtendRootItem: itemExtendsRoot,
                Callbacks: {
                    CloseCallback: ()=>sg_close(),
                    RunExtendCallback: function(url, type, createCallback, destroyCallback) {
                        let params = [];
                        if($CommonLibJS.isArray(url)) {
                            params = url;
                            url = url.shift();
                        }

                        if(type === 1) { //长按
                            //if(!$CommonLibJS.isSingleWindow()) {
                                //注意（使用Extend.js时的上下文 2/3）：组件绑定了mainGameMaker的环境上下文；写成Qt.create...退出PluginsManager时会出错！
                                if(!$CommonLibJS.isComponent(url)) url = $createComponent(url); //如果是路径，则使用$createComponent绑定上下文；
                                const win = $openQML(url, {Type: -4,
                                    //注意（使用Extend.js时的上下文 3/3）：窗口的parent（Qt）设置为mainGameMaker，确保组件退出上下文时全部释放；
                                    Parent: $CommonLibJS.isComponent(url) ? rootGameMaker : null, //如果是Component，则可能绑定了上下文，所以设置Parent控制生命周期；
                                    //Container: arrExtendsContainer, //将创建的窗口放在指定容器
                                    CreateCallback: createCallback,
                                    DestroyCallback: destroyCallback,
                                    //HotLoaderParams: {},
                                }, ...params);
                                return /*win.bMainWindow ? 0 : 1*/1;
                            //}
                        }
                        function fnLoaderStatusChanged() {
                            switch(loaderExtends.status) {
                            case Loader.Ready:
                                loaderExtends.item.Component.destruction.connect(function() {
                                    if(destroyCallback)
                                        destroyCallback(loaderExtends.item);
                                });
                                if(createCallback)
                                    createCallback(loaderExtends.item);
                                break;
                            case Loader.Error:
                                if(createCallback)
                                    createCallback(null);
                                break;
                            case Loader.Loading:
                                return;
                            }
                            loaderExtends.statusChanged.disconnect(fnLoaderStatusChanged);
                        }
                        loaderExtends.statusChanged.connect(fnLoaderStatusChanged);
                        const res = loaderExtends.load(url, undefined, undefined, ...params);

                        return 0;
                    },
                    //UninstallCallback: function(extendsRootPath, rpath, type) {},
                },
                Parent: itemList,
            });
        }

        function showInstallPlugins() {
            return _private.$extends.showInstallExtends({
                ExtendsRootPath: $GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName + '/Plugins/',
                ExtendPathSearchDepth: 2,
                InstallPath: $GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName + '/',
                ///JSLoader: _private.jsLoader,
                MenuURL: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/menu.js',
                DownloadURL: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1/%2',
                CachePath: $GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName + '/~Cache/Plugins/',
                CacheExtendRootRelativePath: 'Plugins/',
                //CustomMenus: [[], []],
                Callbacks: {
                    CloseCallback: ()=>sg_close(),
                    //InstallCallback: function(cacheExtendRootPath, extendsRootPath, rpath) {},
                    //UninstallCallback: function(extendsRootPath, rpath, type) {},
                },
                Parent: itemList,
            });
        }



        readonly property QtObject config: QtObject { //配置
            //id: _config
        }

        //注意（使用Extend.js时的上下文 1/3）：js脚本和jsQtObject绑定了mainGameMaker的环境上下文；写成Qt.create...退出PluginsManager时会出错！
        readonly property var $extends: $Extends.create((...params)=>$createQmlObject(...params))

        //property var jsLoader: new $CommonLibJS.JSLoader(root, /*(...params)=>$createQmlObject(...params)*/)


        property int nType: -1

        //property var arrExtendsContainer: []
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PluginsManager]Keys.onEscapePressed');
        event.accepted = true;

        //$list.close();
        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PluginsManager]Keys.onBackPressed');
        event.accepted = true;

        //$list.close();
        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[PluginsManager]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[PluginsManager]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[PluginsManager]Component.onCompleted');

        //$$eval = (()=>(c)=>eval(c))();
    }
    Component.onDestruction: {
        console.debug('[PluginsManager]Component.onDestruction');

        /*for(const te of _private.arrExtendsContainer) {
            te.destroy();
        }
        */

        //$$eval = null;
    }
}
