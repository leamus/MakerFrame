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


    function $load(...params) {
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
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }



    //js创建组件的根组件
    Item {
        id: itemExtendsRoot


        function close() {
            for(let tc in itemExtendsRoot.children) {
                itemExtendsRoot.children[tc].destroy();
            }

            //$list.visible = true;
            //$list.forceActiveFocus();
            _private.refresh();
        }


        anchors.fill: parent


        Keys.onEscapePressed: function(event) {
            console.debug('[PluginsManager]Keys.onEscapePressed:itemExtendsRoot');
            event.accepted = true;

            close();
        }
        Keys.onBackPressed: function(event) {
            console.debug('[PluginsManager]Keys.onBackPressed:itemExtendsRoot');
            event.accepted = true;

            close();
        }
        Keys.onPressed: function(event) {
            console.debug('[PluginsManager]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
            //event.accepted = true;
        }
        Keys.onReleased: function(event) {
            console.debug('[PluginsManager]Keys.onReleased:', event.key, event.isAutoRepeat);
            //event.accepted = true;
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
                //$showBusyIndicator(false);
            }
            else if(status === Loader.Error) {
                setSource('');

                $showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();


                //$list.visible = true;
                //$list.forceActiveFocus();
                _private.refresh();
            }
            else if(status === Loader.Loading) {
                $showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                $clearComponentCache();
                $trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[PluginsManager]loaderExtends onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                ///item.focus = true;
                //if(item.forceActiveFocus)
                //    item.forceActiveFocus();

                //if(item.$load)
                //    item.$load();

                visible = true;


                $list.visible = false;
            }
            catch(e) {
                throw e;
            }
            finally {
                $showBusyIndicator(false);
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
        Keys.onPressed: function(event) {
            console.debug('[PluginsManager]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
            //event.accepted = true;
        }
        Keys.onReleased: function(event) {
            console.debug('[PluginsManager]Keys.onReleased:', event.key, event.isAutoRepeat);
            //event.accepted = true;
        }
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

        property var jsLoader: new $CommonLibJS.JSLoader(root, (qml, parent, fileURL)=>Qt.createQmlObject(qml, parent, fileURL))

        property var arrPluginsShowName: []
        property var arrPluginsName: []
        property var objPlugins: ({})


        function refresh() {
            jsLoader.clear();

            $clearComponentCache();
            $trimComponentCache();


            arrPluginsShowName = [];
            arrPluginsName = [];
            objPlugins = {};

            //载入扩展 插件/组件
            let pluginsRootPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'Plugins' + GameMakerGlobal.separator;

            //循环三方根目录
            for(let tc0 of $Frame.sl_dirList($GlobalJS.toPath(pluginsRootPath), [], 0x001 | 0x2000 | 0x4000, 0)) {
                //if(tc0 === '$Leamus')
                //    continue;

                //循环三方插件目录
                for(let tc1 of $Frame.sl_dirList($GlobalJS.toPath(pluginsRootPath + tc0 + GameMakerGlobal.separator), [], 0x001 | 0x2000 | 0x4000, 0)) {
                    let showName = '';

                    const jsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'main.js';

                    if($Frame.sl_fileExists($GlobalJS.toPath(jsPath))) {

                        try {
                            const ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));


                            //放入 _private.objPlugins 中
                            //if(ts.$pluginId !== undefined) {    //插件有ID
                            //    _private.objPlugins[ts.$pluginId] = ts;
                            //}


                            //if(!$CommonLibJS.isObject(_private.objPlugins[tc0]))
                            //    _private.objPlugins[tc0] = {};
                            //_private.objPlugins[tc0][tc1] = ts;


                            /*if(ts.$load && (ts.$autoLoad || ts.$autoLoad === undefined)) {
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

            $list.open({
                RemoveButtonVisible: true,
                Data: arrPluginsShowName,
                OnClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let extendsDirPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Extends';

                    if($Frame.sl_fileExists($GlobalJS.toPath(extendsDirPath + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            const ts = _private.jsLoader.load($GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.js'));

                            if(ts.$load) {
                                ts.$load(itemExtendsRoot);
                            }

                            itemExtendsRoot.forceActiveFocus();
                            $list.visible = false;

                            return 1;
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            return -1;
                        }
                    }
                    else if($Frame.sl_fileExists($GlobalJS.toPath(extendsDirPath + GameMakerGlobal.separator + 'main.qml'))) {
                        //console.debug('[PluginsManager]main.qml path:', $GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.qml'));
                        //loaderExtends.source = $GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.qml');
                        loaderExtends.setSource($GlobalJS.toURL(extendsDirPath + GameMakerGlobal.separator + 'main.qml'));

                        return 2;
                    }


                    $dialog.show({
                        Msg: '扩展不能运行',
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            //$list.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //$list.forceActiveFocus();
                        },
                    });

                    //$list.visible = false;
                    //root.forceActiveFocus();
                    return 0;
                },
                OnCanceled: ()=>{
                    $list.visible = false;
                    //root.forceActiveFocus();
                    sg_close();
                },
                OnRemoveClicked: (index, item)=>{
                    let tc0 = arrPluginsName[index][0];
                    let tc1 = arrPluginsName[index][1];
                    let pluginDirPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1;

                    let description = '';
                    if($Frame.sl_fileExists($GlobalJS.toPath(pluginDirPath + GameMakerGlobal.separator + 'main.js'))) {
                        try {
                            const ts = _private.jsLoader.load($GlobalJS.toURL(pluginDirPath + GameMakerGlobal.separator + 'main.js'));

                            if(ts.$description) {
                                description = '\r\n' + '描述：' + ts.$description;
                            }
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                        }
                    }
                    $dialog.show({
                        TextFormat: Label.RichText,
                        //TextFormat: Label.PlainText,
                        Msg: '确认删除 <font color="red">' + item + '</font> ？<br>' + description,
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            $CommonLibJS.asyncScript([function*() {
                                console.debug('[PluginsManager]删除：' + pluginDirPath, Qt.resolvedUrl(pluginDirPath), $Frame.sl_dirExists(pluginDirPath));

                                let removeFlag = false;
                                const jsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'main.js';
                                if($Frame.sl_fileExists($GlobalJS.toPath(jsPath))) {
                                    try {
                                        const ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                                        let ret;

                                        if($CommonLibJS.isFunction(ts.$uninstall)) {
                                            ret = ts.$uninstall();
                                        }
                                        else
                                            ret = yield* ts.$uninstall();

                                        if(ret === undefined || ret === null) {
                                            //console.debug('删除', pluginDirPath);
                                            removeFlag = true;
                                        }
                                        else if(ret === false)
                                            return;

                                        //itemExtendsRoot.forceActiveFocus();
                                        //$list.visible = false;

                                        console.debug('[PluginsManager]ret:', ret);
                                    }
                                    catch(e) {
                                        console.error('[!PluginsManager]', e);
                                        //return -1;
                                    }
                                }
                                else
                                    removeFlag = true;

                                if(removeFlag) {
                                    $Frame.sl_removeRecursively(pluginDirPath);
                                    $list.removeItem(index);
                                    _private.refresh();
                                }

                                ///$list.forceActiveFocus();
                            }, 'remove plugin']);
                        },
                        OnRejected: ()=>{
                            //$list.forceActiveFocus();
                        },
                    });

                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PluginsManager]Keys.onEscapePressed');
        event.accepted = true;

        $list.visible = false;
        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PluginsManager]Keys.onBackPressed');
        event.accepted = true;

        $list.visible = false;
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
    }
    Component.onDestruction: {
        console.debug('[PluginsManager]Component.onDestruction');
    }
}
