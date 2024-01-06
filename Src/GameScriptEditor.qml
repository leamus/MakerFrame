import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal s_close();


    function init() {

        /*/读脚本

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator +  '';
        //let data = File.read(filePath);
        //console.debug('data', filePath, data)

        let data = FrameManager.sl_qml_ReadFile(filePath);

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


                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: '请输入算法脚本'

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: notepadScript.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                    border.width: notepadScript.textArea.focus ? 2 : 1
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
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: 'V'
                onClicked: {

                    loaderVisualScript.show();
                }
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
        }
    }



    Loader {
        id: loaderVisualScript


        function show() {

            if(textFilePath.text.indexOf('.js') < 0 && textFilePath.text.indexOf('.qml') < 0) {

                dialogCommon.show({
                    Msg: '编辑的文件非js/qml文件，不能用可视化',
                    Buttons: Dialog.Ok,
                    OnAccepted: function(){
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                });

                return;
            }

            let fileName = textFilePath.text.slice(0, textFilePath.text.lastIndexOf('.'));


            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + fileName;

            item.loadData(filePath);



            visible = true;
            //forceActiveFocus();
            //item.forceActiveFocus();
            focus = true;
            item.focus = true;
        }


        anchors.fill: parent

        visible: false
        focus: true


        source: './GameVisualScript.qml'
        asynchronous: false


        onLoaded: {
            console.debug('[GameStart]loaderVisualScript onLoaded');
        }

        Connections {
            target: loaderVisualScript.item
            function onS_close() {
                //init();


                loaderVisualScript.visible = false;
                root.forceActiveFocus();
                //root.focus = true;
            }

            function onS_Compile(code) {
                //console.debug(code)

                notepadScript.setPlainText(code);
                notepadScript.toBegin();
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
            if(!FrameManager.sl_qml_DirExists(path)) {
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


            //visible = false;

            console.debug("[mainScriptEditor]path：", path);

            if(FrameManager.sl_qml_DirExists(path)) {
                _private.showList();
                return;
            }



            //let cfg = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(path);

            if(data) {
                notepadScript.setPlainText(data);
                notepadScript.toBegin();
            }



            l_listExplorer.visible = false;
            root.forceActiveFocus();
        }

        onRemoveClicked: {
            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath + GameMakerGlobal.separator + item;


            dialogCommon.show({
                Msg: '确认删除：' + path,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function(){
                    if(FrameManager.sl_qml_DirExists(path)) {
                        console.debug("[mainScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_qml_RemoveRecursively(path));
                        removeItem(index);
                    }
                    else if(FrameManager.sl_qml_FileExists(path)) {
                        console.debug("[mainScriptEditor]删除：" + path, Qt.resolvedUrl(path), FrameManager.sl_qml_DeleteFile(path));
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
            //loader.visible = true;
            //root.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();
            visible = false;
        }

    }



    QtObject {
        id: _private

        property string strTmpPath


        function showList() {

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;


            if(!FrameManager.sl_qml_DirExists(path)) {
                _private.strTmpPath = _private.strTmpPath.slice(0, _private.strTmpPath.lastIndexOf('/'))
                path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + _private.strTmpPath;
            }

            let list = FrameManager.sl_qml_listDir(path, "*.qml|*.js|*.vjs|*.json|*.txt", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建文件】', '..');
            l_listExplorer.showList(list);
            //console.warn(l_listExplorer.listview.itemAtIndex(0)); //null，还没创建
            l_listExplorer.removeButtonVisible = {0: false, 1: false, '-1': true};
            l_listExplorer.visible = true;
            l_listExplorer.forceActiveFocus();
        }


        function save() {
            let filePath = textFilePath.text.trim();

            if(filePath.length === 0) {
                dialogCommon.show({
                    Msg: '名称不能为空',
                    Buttons: Dialog.Ok,
                    OnAccepted: function(){
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                });

                return false;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + filePath;

            let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(notepadScript.textDocument), path, 0);

            return true;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function(){
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

    //配置
    QtObject {
        id: config
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
        console.debug('[mainScriptEditor]Keys.onPressed:', event.key);
    }
    Keys.onReleased: {
        console.debug('[mainScriptEditor]Keys.onReleased:', event.key);
    }



    Component.onCompleted: {

    }
}
