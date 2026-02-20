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


    function $load(type) {
        _private.nType = type;

        if(type === 2)
            _private.refreshDownloadList();
        else
            _private.refreshPluginsList();
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

            _private.refreshPluginsList();

            //$list.visible = true;
            //$list.forceActiveFocus();
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


                _private.refreshPluginsList();
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



    QtObject {
        id: _private

        function refreshPluginsList() {
            jsLoader.clear();

            $clearComponentCache();
            $trimComponentCache();


            const arrPluginsShowName = [];
            const arrPluginsPath = [];
            //const objPlugins = {};

            //载入扩展 插件/组件
            const pluginsRootPath = (nType === 1 ? (GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName) : ($Platform.externalDataPath + '/GameMaker')) + '/Plugins/';

            //循环三方根目录
            for(const tc0 of $Frame.sl_dirList(pluginsRootPath, [], 0x001 | 0x2000 | 0x4000, 0)) {
                //if(tc0 === '$Leamus')
                //    continue;

                //循环三方插件目录
                for(const tc1 of $Frame.sl_dirList(pluginsRootPath + tc0 + GameMakerGlobal.separator, [], 0x001 | 0x2000 | 0x4000, 0)) {
                    let showName = '';

                    const jsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'main.js';
                    if($Frame.sl_fileExists(jsPath)) {
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
                            //$CommonLibJS.printException(e);
                            continue;
                        }
                    }

                    arrPluginsPath.push([tc0, tc1]);
                    arrPluginsShowName.push('%1(%2/%3)'.arg(showName).arg(tc0).arg(tc1));
                }
            }

            //console.debug(menuJS.plugins, Object.keys(menuJS.plugins), JSON.stringify(menuJS.plugins));

            $list.open({
                RemoveButtonVisible: true,
                Data: arrPluginsShowName,
                OnClicked: (index, item)=>{
                    const tc0 = arrPluginsPath[index][0];
                    const tc1 = arrPluginsPath[index][1];
                    const extendsPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Extends' + GameMakerGlobal.separator;

                    if($Frame.sl_fileExists(extendsPath + 'main.qml')) {
                        //console.debug('[PluginsManager]main.qml path:', $GlobalJS.toURL(extendsPath + 'main.qml'));

                        if($Frame.sl_isSymLink(extendsPath + 'main.qml')) //$Frame.sl_isSymbolicLink
                            //loaderExtends.source = $GlobalJS.toURL(extendsPath + 'main.qml');
                            loaderExtends.setSource($GlobalJS.toURL($Frame.sl_fileSymLinkTarget(extendsPath + 'main.qml')));
                        else
                            //loaderExtends.source = $GlobalJS.toURL(extendsPath + 'main.qml');
                            loaderExtends.setSource($GlobalJS.toURL(extendsPath + 'main.qml'));

                        $list.visible = false;

                        return 2;
                    }
                    else if($Frame.sl_fileExists(extendsPath + 'main.js')) {
                        try {
                            let ts;
                            if($Frame.sl_isSymLink(extendsPath + 'main.js')) //$Frame.sl_isSymbolicLink
                                ts = _private.jsLoader.load($GlobalJS.toURL($Frame.sl_fileSymLinkTarget(extendsPath + 'main.js')));
                            else
                                ts = _private.jsLoader.load($GlobalJS.toURL(extendsPath + 'main.js'));
                            if(ts.$load) {
                                ts.$load(itemExtendsRoot);
                            }

                            itemExtendsRoot.forceActiveFocus();
                            $list.visible = false;

                            return 1;
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            //$CommonLibJS.printException(e);
                            return -1;
                        }
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
                    const tc0 = arrPluginsPath[index][0];
                    const tc1 = arrPluginsPath[index][1];
                    const pluginPath = pluginsRootPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator;
                    const jsPath = pluginPath + 'main.js';

                    let description = '';
                    if($Frame.sl_fileExists(jsPath)) {
                        try {
                            const ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                            if(ts.$description) {
                                description = '\r\n' + '描述：' + ts.$description;
                            }
                        }
                        catch(e) {
                            console.error('[!PluginsManager]', e);
                            //$CommonLibJS.printException(e);
                        }
                    }

                    console.debug('[PluginsManager]删除：' + pluginPath, Qt.resolvedUrl(pluginPath), $Frame.sl_dirExists(pluginPath));

                    $dialog.show({
                        TextFormat: Label.RichText,
                        //TextFormat: Label.PlainText,
                        Msg: '确认删除 <font color="red">' + item + '</font> ？<br>' + description,
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            $CommonLibJS.asyncScript([function*() {
                                if(yield* removePlugin(jsPath)) {
                                    $Frame.sl_removeRecursively(pluginPath);
                                    $list.removeItem(index);
                                    _private.refreshPluginsList();
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

        function refreshDownloadList() {
            let menuNames = ['【本地载入】'];

            const menuJS = jsLoader.load('http://MakerFrame.Leamus.cn/GameMaker/Plugins/menu.js');
            if(menuJS)
                menuNames = menuNames.concat(Object.keys(menuJS.infos));
            //console.debug('[PluginsManager]menuJS:', menuJS, menuJS.infos, Object.keys(menuJS.infos), JSON.stringify(menuJS.infos));

            //const projectPath = GameMakerGlobal.config.strProjectRootPath + $Frame.sl_completeBaseName(url);
            const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;

            $list.open({
                RemoveButtonVisible: false,
                Data: menuNames,
                OnClicked: (index, item)=>{
                    if(index === 0) {
                    //if(!$CommonLibJS.isObject(menuJS.infos[item])) {
                        $fileDialog.show({
                            Title: '选择插件文件',
                            NameFilters: [ 'zip files (*.zip)', 'All files (*)' ],
                            //Folder: $GlobalJS.toURL($Platform.externalDataPath), //shortcuts.home
                            SelectMultiple: false,
                            SelectExisting: true,
                            SelectFolder: false,
                            //ConvertURL: false,
                            OnAccepted: function(url, urls) {
                                $dialog.show({
                                    Msg: '确认本地安装吗？此操作会替换插件中的同名文件，且不会调用安装脚本！',
                                    Buttons: Dialog.Ok | Dialog.Cancel,
                                    OnAccepted: function() {
                                        $CommonLibJS.asyncScript([setupPlugin(projectPath, $GlobalJS.toPath(url), null), 'setup']);
                                    },
                                    OnRejected: ()=>{
                                        //root.forceActiveFocus();
                                    },
                                });
                            },
                        });
                        return;
                    }

                    const pluginJS = jsLoader.load(menuJS.infos[item]['Path']);
                    if(!pluginJS) {
                        $dialog.show({
                            TextFormat: Label.PlainText,
                            Msg: '错误',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                //root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //root.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    //console.debug('[PluginsManager]pluginJS:', pluginJS, pluginJS.$$type, pluginJS.$$keys);

                    $dialog.show({
                        TextFormat: Label.PlainText,
                        Msg: '名称：%1\r\n版本：%2\r\n日期：%3\r\n作者：%4\r\n大小：%5\r\n描述：%6\r\n确定下载？'
                            .arg(pluginJS.$name)
                            .arg(pluginJS.$version)
                            .arg(pluginJS.$update)
                            .arg(pluginJS.$author)
                            .arg(pluginJS.$size)
                            .arg(pluginJS.$description)
                        ,
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            const zipPath = projectPath + '~Cache' + GameMakerGlobal.separator + 'Plugins' + GameMakerGlobal.separator + pluginJS.$path[0] + GameMakerGlobal.separator + pluginJS.$file;
                            const pluginRPath = pluginJS.$path.join(GameMakerGlobal.separator).trim();
                            const pluginPath = projectPath + 'Plugins' + GameMakerGlobal.separator + pluginRPath + GameMakerGlobal.separator;
                            //const jsPath = pluginPath + 'main.js';

                            //方法一：
                            /*const httpReply = */$CommonLibJS.request({
                                Url: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1/%2'.arg(pluginRPath).arg(pluginJS.$file),
                                Method: 'GET',
                                //Data: {},
                                //Gzip: [1, 1024],
                                //Headers: {},
                                FilePath: zipPath,
                                //Params: ,
                            }, 2).$$then(function(xhr) {
                                $dialog.close();

                                $CommonLibJS.asyncScript([setupPlugin(projectPath, zipPath, pluginPath), 'setup']);
                            }).$$catch(function(e) {
                                //$dialog.close();

                                $dialog.show({
                                    Msg: '下载失败(%1,%2,%3)'.arg(e.$params.code).arg(e.$params.error).arg(e.$params.status),
                                    Buttons: Dialog.Yes,
                                    OnAccepted: function() {
                                        //root.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        //root.forceActiveFocus();
                                    },
                                });
                            });

                            /*/方法二：
                            const httpReply = $Frame.sl_downloadFile('http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1'.arg(pluginJS.$file), zipPath);
                            httpReply.sg_finished.connect(function(httpReply) {
                                const networkReply = httpReply.networkReply;
                                const code = $Frame.sl_objectProperty('Code', networkReply);
                                console.debug('[PluginsManager]下载完毕', httpReply, networkReply, code, $Frame.sl_objectProperty('Data', networkReply));

                                $Frame.sl_deleteLater(httpReply);


                                $dialog.close();

                                if(code !== 0) {
                                    $dialog.show({
                                        Msg: '下载失败(%1)'.arg(code),
                                        Buttons: Dialog.Yes,
                                        OnAccepted: function() {
                                            //root.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            //root.forceActiveFocus();
                                        },
                                    });
                                    return;
                                }

                                setup();
                            });
                            */


                            $dialog.show({
                                Msg: '正在下载，请等待（请勿进行其他操作）',
                                Buttons: Dialog.NoButton,
                                OnAccepted: function() {
                                    $dialog.show();
                                    //$dialog.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    $dialog.show();
                                    //$dialog.forceActiveFocus();
                                },
                            });



                            //root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                    });

                    //$list.visible = false;
                    //root.forceActiveFocus();
                },
                OnCanceled: ()=>{
                    $list.visible = false;
                    //root.forceActiveFocus();
                    sg_close();
                },
            });
        }

        function* setupPlugin(projectPath, zipPath, pluginPath) {
            console.debug('[PluginsManager]setupPlugin', projectPath, zipPath, pluginPath);

            const jsPath = pluginPath ? (pluginPath + 'main.js') : null;
            if(pluginPath && (yield* removePlugin(jsPath))) {
                $Frame.sl_removeRecursively(pluginPath);
                //$list.removeItem(index);
                //_private.refreshDownloadList();
            }

            let ret = $Frame.sl_extractDir(zipPath, projectPath);

            let msg;
            if(ret.length > 0) {
                //console.debug(ret, projectPath);
                msg = '安装成功';

                if(pluginPath && $Frame.sl_fileExists(jsPath)) {
                    try {
                        let ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                        let ret;

                        if($CommonLibJS.isFunction(ts.$install))
                            ret = ts.$install();
                        else if($CommonLibJS.isGeneratorFunction(ts.$install))
                            ret = ts.$install();
                        if($CommonLibJS.isGenerator(ret))
                            ret = yield* ret;

                        //返回false表示安装失败，则删除
                        if(ret === false) {
                            //console.debug('删除', pluginPath);
                            if(yield* removePlugin(jsPath)) {
                                $Frame.sl_removeRecursively(pluginPath);
                                //$list.removeItem(index);
                                //_private.refreshDownloadList();
                            }

                            return;
                        }

                    }
                    catch(e) {
                        console.error('[!PluginsManager]', e);
                        //return -1;
                    }
                }
            }
            else
                msg = '安装失败';

            $dialog.show({
                Msg: msg,
                Buttons: Dialog.Yes,
                OnAccepted: function() {
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    //root.forceActiveFocus();
                },
            });
        }

        //删除插件
        function* removePlugin(jsPath) {
            let removeFlag = false;
            if($Frame.sl_fileExists(jsPath)) {
                try {
                    let ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                    let ret;

                    if($CommonLibJS.isFunction(ts.$uninstall))
                        ret = ts.$uninstall();
                    else if($CommonLibJS.isGeneratorFunction(ts.$uninstall))
                        ret = ts.$uninstall();
                    if($CommonLibJS.isGenerator(ret))
                        ret = yield* ret;

                    if(ret === undefined || ret === null) {
                        removeFlag = true;
                    }
                    else if(ret === false)
                        return false;

                    console.debug('[PluginsManager]removePlugin ret:', ret);
                }
                catch(e) {
                    $CommonLibJS.printException(e);
                    //return -1;
                }
            }
            else
                removeFlag = true;

            return removeFlag;
        }



        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


        property var jsLoader: new $CommonLibJS.JSLoader(root, /*(qml, parent, fileURL)=>Qt.createQmlObject(qml, parent, fileURL)*/)


        property int nType: -1
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
