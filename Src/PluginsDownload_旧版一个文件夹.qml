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
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
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
            //root.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.forceActiveFocus();

            console.debug('[PluginsDownload]You chose:', fileUrl, fileUrls);


            $dialog.show({
                Msg: '确认安装吗？此操作会替换插件中的同名文件！',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    let fUrl;
                    if(Qt.platform.os === 'android')
                        fUrl = $Platform.sl_getRealPathFromURI(fileUrl.toString());
                    else
                        fUrl = $Frame.sl_urlDecode(fileUrl.toString());

                    //console.error('!!!', fUrl, fileUrl)

                    //$Frame.sl_removeRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName);

                    //const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + $Frame.sl_completeBaseName(fUrl);
                    const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;

                    //$Frame.sl_dirCreate(projectPath);
                    let ret = $Frame.sl_extractDir($GlobalJS.toPath(fUrl), projectPath);


                    if(ret.length > 0) {
                        //GameMakerGlobal.config.strCurrentProjectName = $Frame.sl_completeBaseName(fUrl);
                        //console.debug(ret, projectPath, fileUrl, $Frame.sl_absolutePath(fileUrl.toString()));
                    }

                    $dialog.show({
                        Msg: ret.length > 0 ? '成功' : '失败',
                        Buttons: Dialog.Ok,
                        OnAccepted: function() {
                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });
                },
                OnRejected: ()=>{
                    root.forceActiveFocus();
                },
            });
        }
        onRejected: {
            console.debug('[PluginsDownload]onRejected');
            //root.forceActiveFocus();


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
        property var jsLoader: new $GlobalJS.JSLoader(root)

        function refresh() {

            const menuJS = jsLoader.load('http://MakerFrame.Leamus.cn/GameMaker/Plugins/menu.js');

            if(!menuJS)
                return false;
            //console.debug(menuJS.infos, Object.keys(menuJS.infos), JSON.stringify(menuJS.infos));

            const menuNames = Object.keys(menuJS.infos);
            menuNames.unshift('【本地载入】');

            $list.open({
                RemoveButtonVisible: false,
                Data: menuNames,
                OnClicked: (index, item)=>{
                    if(index === 0) {
                    //if(!$CommonLibJS.isObject(menuJS.infos[item])) {
                        filedialog.open();
                        return;
                    }

                    $dialog.show({
                        TextFormat: Label.PlainText,
                        Msg: '名称：%1\r\n版本：%2\r\n日期：%3\r\n作者：%4\r\n大小：%5\r\n描述：%6\r\n确定下载？'
                            .arg(menuJS.infos[item]['Name'])
                            .arg(menuJS.infos[item]['Version'])
                            .arg(menuJS.infos[item]['Update'])
                            .arg(menuJS.infos[item]['Author'])
                            .arg(menuJS.infos[item]['Size'])
                            .arg(menuJS.infos[item]['Description'])
                        ,
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;
                            const zipPath = projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['File'];
                            let jsPath;
                            if(menuJS.infos[item]['Path'])
                                jsPath = projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['Path'].trim() + GameMakerGlobal.separator + 'main.js';
                            else
                                jsPath = false;

                            function* remove() {
                                if(jsPath && $Frame.sl_fileExists($GlobalJS.toPath(jsPath))) {
                                    try {
                                        const ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                                        let ret;

                                        if($CommonLibJS.isFunction(ts.$uninstall)) {
                                            ret = ts.$uninstall();
                                        }
                                        else
                                            ret = yield* ts.$uninstall();

                                        if(ret === undefined || ret === null) {
                                            //console.debug('删除', projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['Path'].trim());
                                            $Frame.sl_removeRecursively(projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['Path'].trim());
                                        }
                                        else if(ret === false)
                                            return;

                                        //itemExtendsRoot.forceActiveFocus();
                                        //$list.visible = false;

                                    }
                                    catch(e) {
                                        console.error('[!PluginsDownload]', e);
                                        //return -1;
                                    }
                                }
                            }

                            function* setup() {
                                yield* remove();

                                let ret = $Frame.sl_extractDir(zipPath, projectPath);

                                let msg;
                                if(ret.length > 0) {
                                    //console.debug(ret, projectPath, fileUrl, $Frame.sl_absolutePath(fileUrl.toString()));
                                    msg = '安装成功';

                                    if(jsPath && $Frame.sl_fileExists($GlobalJS.toPath(jsPath))) {
                                        try {
                                            const ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                                            let ret;

                                            if($CommonLibJS.isFunction(ts.$install)) {
                                                ret = ts.$install();
                                            }
                                            else
                                                ret = yield* ts.$install();

                                            if(ret === false) {
                                                //console.debug('删除', projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['Path'].trim());
                                                //$Frame.sl_removeRecursively(projectPath + 'Plugins' + GameMakerGlobal.separator + menuJS.infos[item]['Path'].trim());
                                                yield* remove();

                                                return;
                                            }

                                            //itemExtendsRoot.forceActiveFocus();
                                            //$list.visible = false;

                                        }
                                        catch(e) {
                                            console.error('[!PluginsDownload]', e);
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
                                        root.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        root.forceActiveFocus();
                                    },
                                });
                            }


                            //方法一：
                            /*const httpReply = */$CommonLibJS.request({
                                Url: 'http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1'.arg(menuJS.infos[item]['File']),
                                Method: 'GET',
                                //Data: {},
                                //Gzip: [1, 1024],
                                //Headers: {},
                                FilePath: zipPath,
                                //Params: ,
                            }, 2).$$then(function(xhr) {
                                $dialog.close();

                                $CommonLibJS.asyncScript(setup(), 'setup');
                            }).$$catch(function(e) {
                                //$dialog.close();

                                $dialog.show({
                                    Msg: '下载失败(%1,%2)'.arg(e.$params.code).arg(e.$params.error),
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
                            const httpReply = $Frame.sl_downloadFile('http://MakerFrame.Leamus.cn/GameMaker/Plugins/%1'.arg(menuJS.infos[item]['File']), zipPath);
                            httpReply.sg_finished.connect(function(httpReply) {
                                const networkReply = httpReply.networkReply;
                                const code = $Frame.sl_objectProperty('Code', networkReply);
                                console.debug('[PluginsDownload]下载完毕', httpReply, networkReply, code, $Frame.sl_objectProperty('Data', networkReply));

                                $Frame.sl_deleteLater(httpReply);


                                $dialog.close();

                                if(code !== 0) {
                                    $dialog.show({
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


                            $dialog.show({
                                Msg: '正在下载，请等待（请勿进行其他操作）',
                                Buttons: Dialog.NoButton,
                                OnAccepted: function() {
                                    $dialog.show();
                                    $dialog.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    $dialog.show();
                                    $dialog.forceActiveFocus();
                                },
                            });



                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
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
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PluginsDownload]Keys.onEscapePressed');
        event.accepted = true;

        $list.visible = false;
        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PluginsDownload]Keys.onBackPressed');
        event.accepted = true;

        $list.visible = false;
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
