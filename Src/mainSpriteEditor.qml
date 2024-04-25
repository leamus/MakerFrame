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
        id: l_listSprite

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
            if(!loader.item)
                return false;

            //if(item === "..") {
            //    l_list.visible = false;
            //    return;
            //}

            loader.visible = true;
            loader.focus = true;

            loader.item.forceActiveFocus();
            //loader.item.focus = true;

            if(index === 0) {
                loader.item.newSprite();

                return;
            }


            //visible = false;


            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "sprite.json";
            console.debug("[mainSpriteEditor]filePath：", filePath);

            let cfg = FrameManager.sl_qml_ReadFile(filePath);
            //let cfg = File.read(filePath);

            if(!cfg)
                return false;

            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            //loader.setSource("./MapEditor_1.qml", {});

            loader.item.openSprite(cfg);
        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + item;

            dialogCommon.show({
                Msg: '确认删除？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug("[mainSpriteEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                    removeItem(index);

                    l_listSprite.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listSprite.forceActiveFocus();
                },
            });
        }
    }



    Loader {
        id: loader

        anchors.fill: parent

        visible: false
        focus: true


        source: "./SpriteEditor.qml"
        asynchronous: false


        onLoaded: {
            showBusyIndicator(false);

            //_private.refresh();

            console.debug("[mainSpriteEditor]Loader onLoaded");
        }

        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onS_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                l_listSprite.forceActiveFocus();
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private

        function refresh() {
            let list = FrameManager.sl_qml_listDir(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName, "*", 0x001 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建特效】');
            l_listSprite.removeButtonVisible = {0: false, '-1': true};
            l_listSprite.showList(list);

        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainSpriteEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainSpriteEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainSpriteEditor]key:", event, event.key, event.text)
    }


    Component.onCompleted: {
        if(loader.status === Loader.Loading)
            showBusyIndicator(true);

        _private.refresh();

        console.debug("[mainSpriteEditor]Component.onCompleted");
    }
}
