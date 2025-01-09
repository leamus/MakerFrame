import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



/*
    鹰：运行扩展的位置：Plugins/A/B/Extends/main.js 或 main.qml（js优先）
    扩展退出：
      缺省为按返回键；
      或者：
        js可以调用 parent.close();
        qml可以定义一个 sg_close() 信号，或调用 parent.close();
*/



Item {
    id: root


    signal sg_close();


    function init() {
        _private.refresh();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }



    //js创建组件的根组件
    Item {
        id: itemExtendsRoot


        function close() {
            for(let tc in itemExtendsRoot.children) {
                itemExtendsRoot.children[tc].destroy();
            }


            //rootWindow.aliasGlobal.l_list.visible = true;
            //rootWindow.aliasGlobal.l_list.forceActiveFocus();
            _private.refresh();
        }


        anchors.fill: parent


        Keys.onEscapePressed: {
            close();

            console.debug('[PluginsManager1]Escape Key');
            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            console.debug('[PluginsManager1]Back Key');
            event.accepted = true;
            //Qt.quit();
        }
    }
    //用来载入main.qml
    Loader {
        id: loaderExtends


        function close() {
            //source = '';
            setSource('');
        }



        //visible: false
        //focus: true

        anchors.fill: parent


        source: ''
        asynchronous: true



        Connections {
            target: loaderExtends.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loaderExtends.close();
            }
        }


        onStatusChanged: {
            console.debug('[PluginsManager]loaderExtends:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                setSource('');

                rootWindow.aliasGlobal.showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();


                //rootWindow.aliasGlobal.l_list.visible = true;
                //rootWindow.aliasGlobal.l_list.forceActiveFocus();
                _private.refresh();
            }
            else if(status === Loader.Loading) {
                rootWindow.aliasGlobal.showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                rootWindow.clearComponentCache();
                rootWindow.trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[PluginsManager]loaderExtends onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init();

                visible = true;


                rootWindow.aliasGlobal.l_list.visible = false;
            }
            catch(e) {
                throw e;
            }
            finally {
                rootWindow.aliasGlobal.showBusyIndicator(false);
            }
        }


        Keys.onEscapePressed: {
            close();

            console.debug('[PluginsManager2]Escape Key');
            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            console.debug('[PluginsManager2]Back Key');
            event.accepted = true;
            //Qt.quit();
        }
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

        property var jsEngine: new GlobalJS.JSEngine(root)

        property var arrPluginsShowName: []
        property var arrPluginsName: []
        property var objPlugins: ({})


        function refresh() {
            jsEngine.clear();

            rootWindow.clearComponentCache();
            rootWindow.trimComponentCache();


            arrPluginsShowName = [];
            arrPluginsName = [];
            objPlugins = {};

            //载入扩展 插件/组件
            let pluginsRootPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'Plugins' + GameMakerGlobal.separator;

            //循环三方根目录
            for(let tc0 of FrameManager.sl_dirList(GlobalJS.toPath(pluginsRootPath), '*', 0x001 | 0x2000 | 0x4000, 0)) {
                //if(tc0 === '$Leamus')
                //    continue;

                //循环三方插件目录
                for(let tc1 of FrameManager.sl_dirList(GlobalJS.toPath(pluginsRootPath + tc0 + GameMakerGlobal.separator), '*', 0x001 | 0x2000 | 0x4000, 0)) {
                    let showName = '';

                    let jsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'main.js';

                    if(FrameManager.sl_fileExists(GlobalJS.toPath(jsPath))) {

                        try {
                            let ts = _private.jsEngine.load(GlobalJS.toURL(jsPath));


                            //放入 _private.objPlugins 中
                            //if(ts.$pluginId !== undefined) {    //插件有ID
                            //    _private.objPlugins[ts.$pluginId] = ts;
                            //}


                            //if(!GlobalLibraryJS.isObject(_private.objPlugins[tc0]))
                            //    _private.objPlugins[tc0] = {};
                            //_private.objPlugins[tc0][tc1] = ts;


                            /*if(ts.$load && ts.$autoLoad !== false) {
                                ts.$load();
                            }
                            */

                            showName = ts.$name;
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            continue;
                        }
                    }

                    arrPluginsName.push([tc0, tc1]);
                    arrPluginsShowName.push('%1(%2/%3)'.arg(showName).arg(tc0).arg(tc1));
                }
            }

            //console.debug(menuJS.plugins, Object.keys(menuJS.plugins), JSON.stringify(menuJS.plugins));

            rootWindow.aliasGlobal.l_list.open({
                RemoveButtonVisible: true,
                Data: arrPluginsShowName,
                OnClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let extendsDirPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Extends';

                    if(FrameManager.sl_fileExists(GlobalJS.toPath(extendsDirPath + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            let ts = _private.jsEngine.load(GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.js'));

                            if(ts.$load) {
                                ts.$load(itemExtendsRoot);
                            }

                            itemExtendsRoot.forceActiveFocus();
                            rootWindow.aliasGlobal.l_list.visible = false;

                            return 1;
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            return -1;
                        }
                    }
                    else if(FrameManager.sl_fileExists(GlobalJS.toPath(extendsDirPath + GameMakerGlobal.separator + 'main.qml'))) {
                        loaderExtends.source = GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.qml');

                        return 2;
                    }


                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '扩展不能运行',
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            rootWindow.aliasGlobal.l_list.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootWindow.aliasGlobal.l_list.forceActiveFocus();
                        },
                    });

                    //rootWindow.aliasGlobal.l_list.visible = false;
                    //root.forceActiveFocus();
                    return 0;
                },
                OnCanceled: ()=>{
                    rootWindow.aliasGlobal.l_list.visible = false;
                    //root.forceActiveFocus();
                    sg_close();
                },
                OnRemoveClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let pluginDirPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1;

                    let description = '';
                    if(FrameManager.sl_fileExists(GlobalJS.toPath(pluginDirPath + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            let ts = _private.jsEngine.load(GlobalJS.toURL(pluginDirPath + GameMakerGlobal.separator + 'main.js'));

                            if(ts.$description) {
                                description = '\r\n' + '描述：' + ts.$description;
                            }
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                        }
                    }
                    rootWindow.aliasGlobal.dialogCommon.show({
                        TextFormat: Label.RichText,
                        //TextFormat: Label.PlainText,
                        Msg: '确认删除 <font color="red">' + item + '</font> ？<br>' + description,
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {

                            let jsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'main.js';
                            if(FrameManager.sl_fileExists(GlobalJS.toPath(jsPath))) {
                                try {
                                    let ts = _private.jsEngine.load(GlobalJS.toURL(jsPath));

                                    if(ts.$uninstall) {
                                        ts.$uninstall();
                                    }

                                    //itemExtendsRoot.forceActiveFocus();
                                    //rootWindow.aliasGlobal.l_list.visible = false;

                                }
                                catch(e) {
                                    console.error('[!PluginsManager]', e);
                                    //return -1;
                                }
                            }

                            console.debug('[PluginsManager]删除：' + pluginDirPath, Qt.resolvedUrl(pluginDirPath), FrameManager.sl_dirExists(pluginDirPath), FrameManager.sl_removeRecursively(pluginDirPath));
                            rootWindow.aliasGlobal.l_list.removeItem(index);
                            _private.refresh();

                            //rootWindow.aliasGlobal.l_list.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootWindow.aliasGlobal.l_list.forceActiveFocus();
                        },
                    });

                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        rootWindow.aliasGlobal.l_list.visible = false;
        sg_close();

        console.debug('[PluginsManager]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        rootWindow.aliasGlobal.l_list.visible = false;
        sg_close();

        console.debug('[PluginsManager]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[PluginsManager]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[PluginsManager]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[PluginsManager]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PluginsManager]Component.onDestruction');
    }
}
