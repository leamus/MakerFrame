import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



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


    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: '选择插件文件'
        //folder: shortcuts.home
        nameFilters: [ 'zip files (*.zip)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //rootGameMaker.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.forceActiveFocus();

            console.debug('[PluginsDownload]You chose:', fileUrl, fileUrls);


            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '确认安装吗？这可能会替换同名插件！',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    let fUrl;
                    if(Qt.platform.os === 'android')
                        fUrl = Platform.sl_getRealPathFromURI(fileUrl.toString());
                    else
                        fUrl = FrameManager.sl_urlDecode(fileUrl.toString());

                    //console.error('!!!', fUrl, fileUrl)

                    //FrameManager.sl_removeRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName);

                    //const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + FrameManager.sl_completeBaseName(fUrl);
                    const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;

                    //FrameManager.sl_dirCreate(projectPath);
                    let ret = FrameManager.sl_extractDir(GlobalJS.toPath(fUrl), projectPath);


                    if(ret.length > 0) {
                        //GameMakerGlobal.config.strCurrentProjectName = FrameManager.sl_completeBaseName(fUrl);
                        //console.debug(ret, projectPath, fileUrl, FrameManager.sl_absolutePath(fileUrl));
                    }

                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: ret.length > 0 ? '成功' : '失败',
                        Buttons: Dialog.Ok,
                        OnAccepted: function() {
                            rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootGameMaker.forceActiveFocus();
                        },
                    });
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }
        onRejected: {
            console.debug('[PluginsDownload]onRejected');
            //rootGameMaker.forceActiveFocus();


            //sg_close();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private
        property var jsEngine: new GlobalJS.JSEngine(root)

        function refresh() {

            let menuJS = jsEngine.load('http://MakerFrame.Leamus.cn/GameMaker/Plugins/menu.js');

            if(!menuJS)
                return false;
            //console.debug(menuJS.plugins, Object.keys(menuJS.plugins), JSON.stringify(menuJS.plugins));

            rootWindow.aliasGlobal.list.open({
                RemoveButtonVisible: false,
                Data: Object.keys(menuJS.plugins),
                OnClicked: (index, item)=>{
                    if(!GlobalLibraryJS.isObject(menuJS.plugins[item])) {
                        filedialog.open();
                        return;
                    }

                    rootWindow.aliasGlobal.dialogCommon.show({
                        TextFormat: Label.PlainText,
                        Msg: '名称：%1\r\n版本：%2\r\n日期：%3\r\n作者：%4\r\n大小：%5\r\n描述：%6\r\n确定下载？'
                            .arg(menuJS.plugins[item]['Name'])
                            .arg(menuJS.plugins[item]['Version'])
                            .arg(menuJS.plugins[item]['Update'])
                            .arg(menuJS.plugins[item]['Author'])
                            .arg(menuJS.plugins[item]['Size'])
                            .arg(menuJS.plugins[item]['Description'])
                        ,
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;
                            const zipPath = projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['File'];
                            let jsPath;
                            if(menuJS.plugins[item]['Path'])
                                jsPath = projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['Path'].trim() + GameMakerGlobal.separator + 'main.js';
                            else
                                jsPath = false;

                            function* remove() {
                                if(jsPath && FrameManager.sl_fileExists(GlobalJS.toPath(jsPath))) {
                                    try {
                                        const ts = _private.jsEngine.load(GlobalJS.toURL(jsPath));
                                        let ret;

                                        if(GlobalLibraryJS.isFunction(ts.$uninstall)) {
                                            ret = ts.$uninstall();
                                        }
                                        else
                                            ret = yield* ts.$uninstall();

                                        if(ret === undefined || ret === null) {
                                            //console.debug('删除', projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['Path'].trim());
                                            FrameManager.sl_removeRecursively(projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['Path'].trim());
                                        }
                                        else if(ret === false)
                                            return;

                                        //itemExtendsRoot.forceActiveFocus();
                                        //rootWindow.aliasGlobal.list.visible = false;

                                    }
                                    catch(e) {
                                        console.error('[!PluginsDownload]', e);
                                        //return -1;
                                    }
                                }
                            }

                            function* setup() {
                                yield* remove();

                                let ret = FrameManager.sl_extractDir(zipPath, projectPath);

                                let msg;
                                if(ret.length > 0) {
                                    //console.debug(ret, projectPath, fileUrl, FrameManager.sl_absolutePath(fileUrl));
                                    msg = '安装成功';

                                    if(jsPath && FrameManager.sl_fileExists(GlobalJS.toPath(jsPath))) {
                                        try {
                                            const ts = _private.jsEngine.load(GlobalJS.toURL(jsPath));
                                            let ret;

                                            if(GlobalLibraryJS.isFunction(ts.$install)) {
                                                ret = ts.$install();
                                            }
                                            else
                                                ret = yield* ts.$install();

                                            if(ret === false) {
                                                //console.debug('删除', projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['Path'].trim());
                                                //FrameManager.sl_removeRecursively(projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.plugins[item]['Path'].trim());
                                                yield* remove();

                                                return;
                                            }

                                            //itemExtendsRoot.forceActiveFocus();
                                            //rootWindow.aliasGlobal.list.visible = false;

                                        }
                                        catch(e) {
                                            console.error('[!PluginsDownload]', e);
                                            //return -1;
                                        }
                                    }
                                }
                                else
                                    msg = '安装失败';

                                rootWindow.aliasGlobal.dialogCommon.show({
                                    Msg: msg,
                                    Buttons: Dialog.Yes,
                                    OnAccepted: function() {
                                        root.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        root.forceActiveFocus();
                                    },
                                });
                            }


                            //方法一：
                            /*const httpReply = */GlobalLibraryJS.request({
                                Url: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1'.arg(menuJS.plugins[item]['File']),
                                Method: 'GET',
                                //Data: {},
                                //Gzip: [1, 1024],
                                //Headers: {},
                                FilePath: zipPath,
                                //Params: ,
                            }, 2).$$then(function(xhr) {
                                rootWindow.aliasGlobal.dialogCommon.close();

                                GlobalLibraryJS.asyncScript(setup(), 'setup');
                            }).$$catch(function(e) {
                                //rootWindow.aliasGlobal.dialogCommon.close();

                                rootWindow.aliasGlobal.dialogCommon.show({
                                    Msg: '下载失败(%1,%2,%3)'.arg(e.$params.code).arg(e.$params.error).arg(e.$params.status),
                                    Buttons: Dialog.Yes,
                                    OnAccepted: function() {
                                        root.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        root.forceActiveFocus();
                                    },
                                });
                            });

                            /*/方法二：
                            const httpReply = FrameManager.sl_downloadFile('http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1'.arg(menuJS.plugins[item]['File']), zipPath);
                            httpReply.sg_finished.connect(function(httpReply) {
                                const networkReply = httpReply.networkReply;
                                const code = FrameManager.sl_objectProperty('Code', networkReply);
                                console.debug('[PluginsDownload]下载完毕', httpReply, networkReply, code, FrameManager.sl_objectProperty('Data', networkReply));

                                FrameManager.sl_deleteLater(httpReply);


                                rootWindow.aliasGlobal.dialogCommon.close();

                                if(code !== 0) {
                                    rootWindow.aliasGlobal.dialogCommon.show({
                                        Msg: '下载失败(%1)'.arg(code),
                                        Buttons: Dialog.Yes,
                                        OnAccepted: function() {
                                            root.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            root.forceActiveFocus();
                                        },
                                    });
                                    return;
                                }

                                setup();
                            });
                            */


                            rootWindow.aliasGlobal.dialogCommon.show({
                                Msg: '正在下载，请等待（请勿进行其他操作）',
                                Buttons: Dialog.NoButton,
                                OnAccepted: function() {
                                    rootWindow.aliasGlobal.dialogCommon.open();
                                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    rootWindow.aliasGlobal.dialogCommon.open();
                                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                                },
                            });



                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });

                    //rootWindow.aliasGlobal.list.visible = false;
                    //root.forceActiveFocus();
                },
                OnCanceled: ()=>{
                    rootWindow.aliasGlobal.list.visible = false;
                    //root.forceActiveFocus();
                    sg_close();
                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PluginsDownload]Keys.onEscapePressed');
        event.accepted = true;

        rootWindow.aliasGlobal.list.visible = false;
        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PluginsDownload]Keys.onBackPressed');
        event.accepted = true;

        rootWindow.aliasGlobal.list.visible = false;
        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[PluginsDownload]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[PluginsDownload]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[PluginsDownload]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PluginsDownload]Component.onDestruction');
    }
}
