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

        if(type === 2)
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

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }



    //用来载入main.qml
    L_Loader {
        id: loaderExtends
        objectName: 'PluginsManagerLoader'


        visible: false
        //focus: true
        clip: true

        anchors.fill: parent

        //source: ''
        //asynchronous: true



        Connections {
            target: loaderExtends.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loaderExtends.close();
            }
        }


        onStatusChanged: {
            console.debug('[PluginsManager]loaderExtends onStatusChanged:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                //close();
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();


                _private.showPlugins();
            }
            else if(status === Loader.Loading) {
            }
        }

        onLoaded: {
            console.debug('[PluginsManager]loaderExtends onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                //if(item.$load)
                //    item.$load();

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
            }
        }


        Keys.onEscapePressed: function(event) {
            console.debug('[PluginsManager]Keys.onEscapePressed:loaderExtends');
            event.accepted = true;

            close();
        }
        Keys.onBackPressed: function(event) {
            console.debug('[PluginsManager]Keys.onBackPressed:loaderExtends');
            event.accepted = true;

            close();
        }
    }



    QtObject {
        id: _private

        function showPlugins() {
            //jsLoader.clear();

            const pluginsRootPath = (nType === 1 ? (GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName) : ($Platform.externalDataPath + '/GameMaker')) + '/Plugins/';
            return _private.$extends.showExtends({
                ExtendsRootPath: pluginsRootPath,
                ExtendPathSearchDepth: 2,
                ExtendRunRelativePath: 'Extends/',
                CachePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/~Cache/Plugins/',
                ///JSLoader: _private.jsLoader,
                ///JSExtendRootItem: itemExtendsRoot,
                Callbacks: {
                    CloseCallback: ()=>sg_close(),
                    RunExtendCallback: function(url, type) {
                        if(type === 1) //长按
                            if(!$CommonLibJS.isMobile()) {
                                return $openQML(url, -1);
                            }
                        return loaderExtends.load(url);
                    },
                    //UninstallCallback: function(extendsRootPath, rpath, type) {},
                },
            });
        }

        function showInstallPlugins() {
            return _private.$extends.showInstallExtends({
                ExtendsRootPath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/Plugins/',
                ExtendPathSearchDepth: 2,
                InstallPath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/',
                ///JSLoader: _private.jsLoader,
                MenuURL: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/menu.js',
                DownloadURL: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1/%2',
                CachePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/~Cache/Plugins/',
                CacheExtendRootRelativePath: 'Plugins/',
                //CustomMenus: [[], []],
                Callbacks: {
                    CloseCallback: ()=>sg_close(),
                    //InstallCallback: function(cacheExtendRootPath, extendsRootPath, rpath) {},
                    //UninstallCallback: function(extendsRootPath, rpath, type) {},
                },
            });
        }



        readonly property QtObject config: QtObject { //配置
            //id: _config
        }

        readonly property var $extends: $Extends.create(new $CommonLibJS.JSLoader(root, /*(...params)=>Qt.createQmlObject(...params)*/))

        //property var jsLoader: new $CommonLibJS.JSLoader(root, /*(...params)=>Qt.createQmlObject(...params)*/)


        property int nType: -1
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PluginsManager]Keys.onEscapePressed');
        event.accepted = true;

        $list.close();
        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PluginsManager]Keys.onBackPressed');
        event.accepted = true;

        $list.close();
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

        //$$eval = null;
    }
}
