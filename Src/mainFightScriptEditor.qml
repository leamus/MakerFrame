import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
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


    ColumnLayout {
        anchors.fill: parent

        L_List {
            id: l_listFightScript

            //visible: false
            //anchors.fill: parent
            //width: parent.width
            //height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: Global.style.backgroundColor
            colorText: Global.style.primaryTextColor


            onSg_canceled: {
                //visible = false;
                //loader.visible = true;
                //root.focus = true;
                //root.forceActiveFocus();
                //loader.item.focus = true;
                sg_close();
            }

            onSg_clicked: {
                _private.openItem(item);
            }

            onSg_removeClicked: {
                let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + item;

                $dialog.show({
                    Msg: '确认删除 <font color="red">' + item + '</font> ？',
                    Buttons: Dialog.Ok | Dialog.Cancel,
                    OnAccepted: function() {
                        console.debug('[mainFightScriptEditor]删除：' + dirUrl, Qt.resolvedUrl(dirUrl), $Frame.sl_dirExists(dirUrl), $Frame.sl_removeRecursively(dirUrl));
                        removeItem(index);

                        //l_listFightScript.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //l_listFightScript.forceActiveFocus();
                    },
                });
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                id: buttonCreate

                //Layout.preferredWidth: 60

                text: '新建'
                onClicked: {
                    _private.openItem(null);
                }
            }

            Button {
                id: buttonCompileAll

                //Layout.preferredWidth: 60

                text: '编译全部可视化'
                onClicked: {
                    $dialog.show({
                        Msg: '确定编译全部可视化？<BR>注意：该操作会覆盖所有目标脚本，且不可逆！',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            //l_listFightScript.forceActiveFocus();
                            const list = $Frame.sl_dirList(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, [], 0x001 | 0x2000 | 0x4000, 0x00);
                            for(let tn of list) {
                                const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + tn + GameMakerGlobal.separator;
                                if(!$Frame.sl_fileExists(path + 'fight_script.vjs')) {
                                    console.info('[mainFightScriptEditor]没有可视化文件:', tn);
                                    continue;
                                }

                                fightScriptVisualEditor.init(path + 'fight_script.vjs');
                                const result = fightScriptVisualEditor.compile(false);
                                console.debug('[mainFightScriptEditor]result:', result);
                                if(result[1])
                                    $Frame.sl_fileWrite(result[1], path + 'fight_script.js', 0);
                                else
                                    console.warn('[!mainFightScriptEditor]ERROR:', result[2].toString());
                            }
                        },
                        OnRejected: ()=>{
                            //l_listFightScript.forceActiveFocus();
                        },
                    });
                }
            }
        }
    }



    Loader {
        id: loader

        visible: false
        focus: true

        anchors.fill: parent


        source: './FightScriptEditor.qml'
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                //l_listFightScript.forceActiveFocus();
            }
        }


        onStatusChanged: {
            console.debug('[mainFightScriptEditor]loader:', source, status);

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
            console.debug('[mainFightScriptEditor]loader onLoaded');

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                //forceActiveFocus();

                ///item.focus = true;
                //if(item.forceActiveFocus)
                //    item.forceActiveFocus();

                //if(item.$load)
                //    item.$load();

                //visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
                $showBusyIndicator(false);
            }
        }
    }


    FightScriptVisualEditor {
        id: fightScriptVisualEditor

        anchors.fill: parent

        visible: false

        /*
        Connections {
            target: fightScriptVisualEditor
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                fightScriptVisualEditor.visible = false;

                root.forceActiveFocus();
            }

            function onSg_compile(result) {
                console.debug('', result);
            }
        }
        */
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private

        function refresh() {
            const list = $Frame.sl_dirList(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, [], 0x001 | 0x2000 | 0x4000, 0x00);
            //list.unshift('【新建战斗脚本】');
            //l_listFightScript.removeButtonVisible = {0: false, '-1': true};
            l_listFightScript.show(list);

        }

        function openItem(item) {
            if(!loader.item)
                return false;

            //if(item === '..') {
            //    $list.visible = false;
            //    return;
            //}


            /*if(index === 0) {
                item = null;
            }
            else if(index === 1) {
            }
            */


            /*
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'fight_script.json';

            console.debug('[mainFightScriptEditor]filePath：', filePath);

            //let cfg = File.read(filePath);
            let cfg = $Frame.sl_fileRead(filePath);

            if(cfg) {
                cfg = JSON.parse(cfg);
                //console.debug('cfg', cfg);
                //loader.setSource('./MapEditor_1.qml', {});
                loader.item.openFightScript(cfg);
            }
            */

            loader.item.init(item);


            //visible = false;
            loader.visible = true;
            //loader.focus = true;
            loader.forceActiveFocus();
            //loader.item.focus = true;
            loader.item.forceActiveFocus();
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainFightScriptEditor]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainFightScriptEditor]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainFightScriptEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainFightScriptEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainFightScriptEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainFightScriptEditor]Component.onDestruction');
    }
}
