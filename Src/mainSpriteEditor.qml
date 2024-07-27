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


    signal sg_close();



    function init() {
        if(loader.status === Loader.Loading)
            showBusyIndicator(true);

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


    L_List {
        id: l_listSprite

        //visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onCanceled: {
            //visible = false;
            //loader.visible = true;
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.item.focus = true;

            sg_close();
        }

        onClicked: {
            if(!loader.item)
                return false;

            //if(item === "..") {
            //    l_list.visible = false;
            //    return;
            //}


            //visible = false;
            loader.visible = true;
            //loader.focus = true;
            loader.forceActiveFocus();
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            if(index === 0) {
                loader.item.newSprite();

                return;
            }


            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "sprite.json";
            console.debug("[mainSpriteEditor]filePath：", filePath);

            let cfg = FrameManager.sl_fileRead(filePath);
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
                    console.debug("[mainSpriteEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_dirExists(dirUrl), FrameManager.sl_removeRecursively(dirUrl));
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
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                //l_listSprite.forceActiveFocus();
            }
        }


        onStatusChanged: {
            console.debug('[mainRoleEditor]loader.status：', status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {

            }
        }

        onLoaded: {
            console.debug("[mainRoleEditor]loader onLoaded");

            try {
                //_private.refresh();
            }
            catch(e) {
                throw e;
            }
            finally {
                showBusyIndicator(false);
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
            let list = FrameManager.sl_dirList(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName, "*", 0x001 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建特效】');
            l_listSprite.removeButtonVisible = {0: false, '-1': true};
            l_listSprite.show(list);

        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainSpriteEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainSpriteEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainSpriteEditor]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainSpriteEditor]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[mainSpriteEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainSpriteEditor]Component.onDestruction");
    }
}
