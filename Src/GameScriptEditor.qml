import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


import './Core'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: root


    signal sg_close();


    function init() {

        /*/读脚本

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator +  '';
        //let data = File.read(filePath);
        //console.debug('data', filePath, data)

        let data = FrameManager.sl_fileRead(filePath);

        if(data) {
            //data = JSON.parse(data)['LevelChainScript'];
            notepadScript.setPlainText(data);
            notepadScript.toBegin();
        }
        else {
            notepadScript.setPlainText("
"
            );
            notepadScript.toBegin();
        }
        */
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


    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop


            Button {
                //Layout.fillWidth: true
                //Layout.preferredHeight: 70

                text: '查'

                onClicked: {
                    let e = GameMakerGlobalJS.checkJSCode(FrameManager.sl_toPlainText(notepadScript.textDocument));

                    if(e) {
                        dialogCommon.show({
                            Msg: e,
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

                    dialogCommon.show({
                        Msg: '恭喜，没有语法错误',
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
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.fillWidth: true
                text: '脚本编辑器'
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }

            Button {
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredWidth: 30
                //Layout.preferredHeight: 50
                //Layout.bottomMargin: 10

                text: 'V'
                onClicked: {
                    loaderVisualScript.show();
                }
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            Notepad {
                id: notepadScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                //textArea.enabled: false
                //textArea.readOnly: true
                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: '请输入脚本代码'

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }

                bCode: true
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            //Layout.maximumHeight: parent.height
            //Layout.fillHeight: true


            Button {
                id: buttonChoiceFile

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: '选择文件'
                onClicked: {
                    if(textFilePath.text.lastIndexOf('/') === -1)
                        _private.strTmpPath = '';
                    else
                        _private.strTmpPath = _private.strTmpPath.slice(0, textFilePath.text.lastIndexOf('/') + 1);

                    _private.showList();
                }
            }

            TextField {
                id: textFilePath

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '文件路径'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Button {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: '保存'
                onClicked: {
                    _private.save();
                }
            }
        }
    }



    Loader {
        id: loaderVisualScript


        function show() {
            const fileSuffixPosition = textFilePath.text.lastIndexOf('.');
            const extname = fileSuffixPosition >= 0 ? textFilePath.text.slice(fileSuffixPosition + 1).toLowerCase() : '';
            const filename = fileSuffixPosition >= 0 ? textFilePath.text.slice(0, fileSuffixPosition) : textFilePath.text;

            let virtualFileName = filename;
            //if(textFilePath.text.indexOf('.js') < 0 && textFilePath.text.indexOf('.qml') < 0) {
            switch(extname) {
            case 'js':
                virtualFileName += '.vjs';
                break;
            case 'qml':
                virtualFileName += '.vqml';
                break;
            default:
                dialogCommon.show({
                    Msg: '编辑的文件非js/qml文件，不能用可视化',
                    Buttons: Dialog.Ok,
                    OnAccepted: function() {
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                });

                return;
            }


            /*if(textFilePath.text.indexOf('.js') >= 0)
                virtualFileName += '.vjs';
            if(textFilePath.text.indexOf('.qml') >= 0)
                virtualFileName += '.vqml';
            */
            /*
            switch(fileSuffix) {
            case 'js':
                virtualFileName += '.vjs';
                break;
            case 'qml':
                virtualFileName += '.vqml';
                break;
            default:
            }
            */

            const filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + virtualFileName;
            loaderVisualScript.item.loadData(filePath);



            visible = true;
            //focus = true;
            forceActiveFocus();
            //item.focus = true;
            item.forceActiveFocus();
        }


        visible: false
        focus: true

        anchors.fill: parent


        //source: './GameVisualScript.qml'
        sourceComponent: Component {
            VisualScript {
                strTitle: '游戏脚本'
                defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
                defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
                defaultCommandTemplate: [{"command":"函数/生成器{","params":["*$start",""],"status":{"enabled":true}},{"command":"块结束}","params":[],"status":{"enabled":true}}]
            }
        }
        asynchronous: true



        Connections {
            target: loaderVisualScript.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                //init();


                loaderVisualScript.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }

            function onSg_compile(code) {
                //console.debug(code)

                notepadScript.setPlainText(code);
                notepadScript.toBegin();
            }
        }


        onStatusChanged: {
            console.debug('[GameScriptEditor]loaderVisualScript:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                setSource('');

                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                //visible = false;

                //root.focus = true;
                root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
                showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                clearComponentCache();
                trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[GameScriptEditor]loaderVisualScript onLoaded');

            try {
                /*/应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init();

                visible = true;
                */
            }
            catch(e) {
                throw e;
            }
            finally {
                showBusyIndicator(false);
            }
        }
    }



    L_List {
        id: l_listExplorer

        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onSg_clicked: {
            //if(item === "..") {
            //    l_list.visible = false;
            //    return;
            //}


            //if(_private.strTmpPath.indexOf('/') < 0)
            //    _private.strTmpPath = '';

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;

            /*/设置为文件夹
            if(!FrameManager.sl_dirExists(path)) {
                _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/'))
                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;
            }*/


            if(index === 0) {
                //到顶层
                if(_private.strTmpPath.lastIndexOf('/', _private.strTmpPath.length - 2) < 0)
                    _private.strTmpPath = '';
                else
                    _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/', _private.strTmpPath.length - 2) + 1);

                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;
            }
            //新建
            else if(index === 1) {
                _private.strTmpPath += '新文件.js';

                textFilePath.text = _private.strTmpPath;
                notepadScript.text = '';


                l_listExplorer.visible = false;
                root.forceActiveFocus();

                return;
            }
            else {

                _private.strTmpPath += item;

                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;

                if(FrameManager.sl_dirExists(path))
                    _private.strTmpPath += GameMakerGlobal.separator;
            }

            console.debug("[GameScriptEditor]path：", path);

            if(FrameManager.sl_dirExists(path)) {
                _private.showList();
                return;
            }


            textFilePath.text = _private.strTmpPath;

            //let cfg = File.read(filePath);
            let data = FrameManager.sl_fileRead(path);

            if(data) {
                notepadScript.setPlainText(data);
                notepadScript.toBegin();
            }



            l_listExplorer.visible = false;

            //visible = false;
            root.forceActiveFocus();
        }

        onSg_removeClicked: {
            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath + GameMakerGlobal.separator + item;


            dialogCommon.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？<br>路径：' + path,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if(FrameManager.sl_dirExists(path)) {
                        console.debug("[GameScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_removeRecursively(path));
                        removeItem(index);
                    }
                    else if(FrameManager.sl_fileExists(path)) {
                        console.debug("[GameScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_fileDelete(path));
                        removeItem(index);
                    }

                    l_listExplorer.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listExplorer.forceActiveFocus();
                },
            });
        }

        onSg_canceled: {
            visible = false;
            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
        }

    }



    //配置
    QtObject {
        id: _config
    }


    QtObject {
        id: _private

        //选择时的 临时路径
        property string strTmpPath


        function showList() {

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;


            //if(!FrameManager.sl_dirExists(path)) {
                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strTmpPath;
            //}

            let list = FrameManager.sl_dirList(path, "*.qml|*.js|*.vjs|*.json|*.txt", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00)
            list.unshift('..', '【新建文件】', );
            //console.warn(l_listExplorer.listview.itemAtIndex(0)); //null，还没创建
            l_listExplorer.removeButtonVisible = {0: false, 1: false, '-1': true};
            l_listExplorer.show(list);
        }


        function save() {
            let filePath = textFilePath.text.trim();

            if(filePath.length === 0) {
                dialogCommon.show({
                    Msg: '名称不能为空',
                    Buttons: Dialog.Ok,
                    OnAccepted: function() {
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                });

                return false;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + filePath;

            let ret = FrameManager.sl_fileWrite(FrameManager.sl_toPlainText(notepadScript.textDocument), path, 0);

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(save())
                        sg_close();
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    dialogCommon.close();
                    root.forceActiveFocus();
                },
            });
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        _private.close();

        console.debug('[GameScriptEditor]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[GameScriptEditor]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameScriptEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[GameScriptEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }



    Component.onCompleted: {
        console.debug("[GameScriptEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[GameScriptEditor]Component.onDestruction");
    }
}
