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


    signal s_close();


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
                    _private.strTmpPath = textFilePath.text;
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

            if(textFilePath.text.indexOf('.js') < 0 && textFilePath.text.indexOf('.qml') < 0) {

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


            let fileName = textFilePath.text.slice(0, textFilePath.text.lastIndexOf('.'));
            if(textFilePath.text.indexOf('.js') >= 0)
                fileName += '.vjs';
            if(textFilePath.text.indexOf('.qml') >= 0)
                fileName += '.vqml';
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + fileName;
            loaderVisualScript.item.loadData(filePath);



            visible = true;
            //focus = true;
            forceActiveFocus();
            //item.focus = true;
            item.forceActiveFocus();
        }


        anchors.fill: parent

        visible: false
        focus: true


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
            console.debug('[GameScriptEditor]loaderVisualScript.status：', status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {

            }
        }

        onLoaded: {
            console.debug('[GameScriptEditor]loaderVisualScript onLoaded');

            try {
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


        onClicked: {
            //if(item === "..") {
            //    l_list.visible = false;
            //    return;
            //}


            if(_private.strTmpPath.indexOf('/') < 0)
                _private.strTmpPath = '';

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;

            /*/设置为文件夹
            if(!FrameManager.sl_dirExists(path)) {
                _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/'))
                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;
            }*/


            //新建
            if(index === 0) {
                _private.strTmpPath += '/新文件.js';

                textFilePath.text = _private.strTmpPath;


                l_listExplorer.visible = false;
                root.forceActiveFocus();

                return;
            }
            else if(index === 1) {
                _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/'))
                //到顶层
                if(_private.strTmpPath.indexOf('/') < 0) {
                    _private.strTmpPath = '';

                    //return;
                }

                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;

            }
            else {

                _private.strTmpPath += '/' + item;

                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;


                textFilePath.text =  _private.strTmpPath;
            }

            console.debug("[mainScriptEditor]path：", path);

            if(FrameManager.sl_dirExists(path)) {
                _private.showList();
                return;
            }


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

        onRemoveClicked: {
            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath + GameMakerGlobal.separator + item;


            dialogCommon.show({
                Msg: '确认删除：' + path,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if(FrameManager.sl_dirExists(path)) {
                        console.debug("[mainScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_removeRecursively(path));
                        removeItem(index);
                    }
                    else if(FrameManager.sl_fileExists(path)) {
                        console.debug("[mainScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_fileDelete(path));
                        removeItem(index);
                    }

                    l_listExplorer.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listExplorer.forceActiveFocus();
                },
            });
        }

        onCanceled: {
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

        property string strTmpPath


        function showList() {

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;


            if(!FrameManager.sl_dirExists(path)) {
                _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/'))
                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;
            }

            let list = FrameManager.sl_dirList(path, "*.qml|*.js|*.vjs|*.json|*.txt", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建文件】', '..');
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

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + filePath;

            let ret = FrameManager.sl_fileWrite(FrameManager.sl_toPlainText(notepadScript.textDocument), path, 0);

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(save())
                        s_close();
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    s_close();
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

        console.debug('[mainScriptEditor]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[mainScriptEditor]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[mainScriptEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[mainScriptEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }



    Component.onCompleted: {
        if(loaderVisualScript.status === Loader.Loading)
            showBusyIndicator(true);

        console.debug("[mainScriptEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainScriptEditor]Component.onDestruction");
    }
}
