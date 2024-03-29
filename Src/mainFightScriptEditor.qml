﻿import QtQuick 2.14
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


//import './Core'


//import 'File.js' as File



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


    L_List {
        id: l_listFightScript

        //visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onCanceled: {
            //loader.visible = true;
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.item.focus = true;
            //visible = false;
            s_close();
        }

        onClicked: {
            //if(item === "..") {
            //    l_list.visible = false;
            //    return;
            //}
            if(index === 0) {
                loader.item.init();

                loader.visible = true;
                loader.item.forceActiveFocus();
                return;
            }


            loader.visible = true;
            loader.focus = true;
            loader.item.focus = true;
            //visible = false;

            /*
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_script.json";

            console.debug("[mainFightScriptEditor]filePath：", filePath);

            //let cfg = File.read(filePath);
            let cfg = FrameManager.sl_qml_ReadFile(filePath);

            if(cfg) {
                cfg = JSON.parse(cfg);
                //console.debug("cfg", cfg);
                //loader.setSource("./MapEditor_1.qml", {});
                loader.item.openFightScript(cfg);
            }
            */

            loader.item.init(item);
        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + item;

            dialogCommon.show({
                Msg: '确认删除？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug("[mainFightScriptEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                    removeItem(index);

                    l_listFightScript.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listFightScript.forceActiveFocus();
                },
            });
        }
    }



    Loader {
        id: loader

        anchors.fill: parent

        visible: false
        focus: true


        source: "./FightScriptEditor.qml"
        asynchronous: false


        onLoaded: {
            //item.testFresh();
            console.debug("[mainFightScriptEditor]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }
        }
    }



    QtObject {
        id: _private

        function refresh() {
            let list = FrameManager.sl_qml_listDir(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName, "*", 0x001 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建战斗脚本】');
            l_listFightScript.removeButtonVisible = {0: false, '-1': true};
            l_listFightScript.showList(list);

        }
    }


    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainFightScriptEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainFightScriptEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainFightScriptEditor]key:", event, event.key, event.text)
    }


    Component.onCompleted: {
        _private.refresh();
    }
}
