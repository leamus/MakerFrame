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
        qml可以定义一个 s_close() 信号，或调用 parent.close();
*/



Item {
    id: root


    signal s_close();



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



    Item {
        id: itemExtendsRoot


        function close() {
            for(let tc in itemExtendsRoot.children) {
                itemExtendsRoot.children[tc].destroy();
            }

            //l_list.visible = true;
            //l_list.forceActiveFocus();
            _private.refresh();


            FrameManager.sl_qml_clearComponentCache();
            FrameManager.sl_qml_trimComponentCache();
        }


        anchors.fill: parent


        Keys.onEscapePressed: {
            close();

            console.debug("[PluginsManager1]Escape Key");
            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            console.debug("[PluginsManager1]Back Key");
            event.accepted = true;
            //Qt.quit();
        }
    }
    Loader {
        id: loaderExtends


        function close() {
            loaderExtends.source = '';

            //l_list.visible = true;
            //l_list.forceActiveFocus();
            _private.refresh();


            FrameManager.sl_qml_clearComponentCache();
            FrameManager.sl_qml_trimComponentCache();
        }


        anchors.fill: parent

        //visible: false
        //focus: true


        source: ""
        asynchronous: true


        Connections {
            target: loaderExtends.item

            ignoreUnknownSignals: true


            function onS_close() {
                loaderExtends.close();
            }
        }


        onStatusChanged: {
            console.log('[PluginsManager]loaderExtends.status：', status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                showBusyIndicator(false);
            }
        }

        onLoaded: {
            console.debug("[PluginsManager]loader onLoaded");

            loaderExtends.visible = true;
            loaderExtends.focus = true;
            //loaderExtends.item.focus = true;
            if(loaderExtends.item.forceActiveFocus)
                loaderExtends.item.forceActiveFocus();


            try {
                //loaderGameScene.item.init(true, true);
                l_list.visible = false;
            }
            catch(e) {
                throw e;
            }
            finally {
                showBusyIndicator(false);
            }
        }


        Keys.onEscapePressed: {
            close();

            console.debug("[PluginsManager1]Escape Key");
            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            console.debug("[PluginsManager1]Back Key");
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

            arrPluginsShowName = [];
            arrPluginsName = [];
            objPlugins = {};

            //载入扩展 插件/组件
            let pluginPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Plugins" + GameMakerGlobal.separator;

            //循环三方根目录
            for(let tc0 of FrameManager.sl_qml_listDir(GlobalJS.toPath(pluginPath), '*', 0x001 | 0x2000 | 0x4000, 0)) {
                //if(tc0 === '$Leamus')
                //    continue;

                //循环三方插件目录
                for(let tc1 of FrameManager.sl_qml_listDir(GlobalJS.toPath(pluginPath + tc0 + GameMakerGlobal.separator), '*', 0x001 | 0x2000 | 0x4000, 0)) {
                    let showName = '';

                    let jsPath = pluginPath + tc0 + GameMakerGlobal.separator + tc1;

                    if(FrameManager.sl_qml_FileExists(GlobalJS.toPath(jsPath + GameMakerGlobal.separator + 'main.js'))) {

                        try {
                            let ts = _private.jsEngine.load('main.js', GlobalJS.toURL(jsPath));


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

            l_list.open({
                RemoveButtonVisible: true,
                Data: arrPluginsShowName,
                OnClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let jsPath = pluginPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Extends';

                    if(FrameManager.sl_qml_FileExists(GlobalJS.toPath(jsPath + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            let ts = _private.jsEngine.load('main.js', GlobalJS.toURL(jsPath));

                            if(ts.$load) {
                                ts.$load(itemExtendsRoot);
                            }

                            itemExtendsRoot.forceActiveFocus();
                            l_list.visible = false;

                            return 1;
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            return -1;
                        }
                    }
                    else if(FrameManager.sl_qml_FileExists(GlobalJS.toPath(jsPath + GameMakerGlobal.separator + 'main.qml'))) {
                        loaderExtends.source = GlobalJS.toURL(jsPath + GameMakerGlobal.separator + 'main.qml');
                        if(loaderExtends.status === Loader.Loading)
                            showBusyIndicator(true);

                        return 2;
                    }


                    dialogCommon.show({
                        Msg: '不能运行扩展',
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            l_list.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            l_list.forceActiveFocus();
                        },
                    });

                    //l_list.visible = false;
                    //root.forceActiveFocus();
                    return 0;
                },
                OnCanceled: ()=>{
                    l_list.visible = false;
                    //root.forceActiveFocus();
                    s_close();
                },
                OnRemoveClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let dirUrl = pluginPath + tc0 + GameMakerGlobal.separator + tc1;

                    let description = '';
                    if(FrameManager.sl_qml_FileExists(GlobalJS.toPath(dirUrl + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            let ts = _private.jsEngine.load('main.js', GlobalJS.toURL(dirUrl));

                            if(ts.$description) {
                                description = '\r\n' + '描述：' + ts.$description;
                            }
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                        }
                    }
                    dialogCommon.show({
                        TextFormat: Label.PlainText,
                        Msg: '确认删除？' + description,
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {

                            let jsPath = pluginPath + tc0 + GameMakerGlobal.separator + tc1;
                            if(FrameManager.sl_qml_FileExists(GlobalJS.toPath(jsPath + GameMakerGlobal.separator + 'main.js'))) {
                                try {
                                    let ts = _private.jsEngine.load('main.js', GlobalJS.toURL(jsPath));

                                    if(ts.$uninstall) {
                                        ts.$uninstall();
                                    }

                                    //itemExtendsRoot.forceActiveFocus();
                                    //l_list.visible = false;

                                }
                                catch(e) {
                                    console.error('[!PluginsManager]', e);
                                    //return -1;
                                }
                            }

                            console.debug("[PluginsManager]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                            l_list.removeItem(index);
                            _private.refresh();

                            l_list.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            l_list.forceActiveFocus();
                        },
                    });

                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        l_list.visible = false;
        s_close();

        console.debug("[PluginsManager]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        l_list.visible = false;
        s_close();

        console.debug("[PluginsManager]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[PluginsManager]key:", event, event.key, event.text)
    }


    Component.onCompleted: {
        _private.refresh();

        console.debug("[PluginsManager]Component.onCompleted");
    }

    Component.onDestruction: {
        console.debug("[PluginsManager]Component.onDestruction");
    }
}
