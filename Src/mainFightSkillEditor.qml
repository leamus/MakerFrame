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


    L_List {
        id: l_listFightSkill

        //visible: false

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
            if(!loader.item)
                return false;

            //if(item === '..') {
            //    $list.visible = false;
            //    return;
            //}


            //visible = false;
            loader.visible = true;
            //loader.focus = true;
            loader.forceActiveFocus();
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            if(index === 0) {
                loader.item.init();

                return;
            }


            /*
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'fight_skill.json';

            console.debug('[mainFightSkillEditor]filePath：', filePath);

            //let cfg = File.read(filePath);
            let cfg = $Frame.sl_fileRead(filePath);

            if(cfg) {
                cfg = JSON.parse(cfg);
                //console.debug('cfg', cfg);
                //loader.setSource('./MapEditor_1.qml', {});
                loader.item.openFightSkill(cfg);
            }
            */

            loader.item.init(item);
        }

        onSg_removeClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + item;

            $dialog.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug('[mainFightSkillEditor]删除：' + dirUrl, Qt.resolvedUrl(dirUrl), $Frame.sl_dirExists(dirUrl), $Frame.sl_removeRecursively(dirUrl));
                    removeItem(index);

                    l_listFightSkill.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listFightSkill.forceActiveFocus();
                },
            });
        }
    }



    Loader {
        id: loader

        visible: false
        focus: true

        anchors.fill: parent


        source: './FightSkillEditor.qml'
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                //l_listFightSkill.forceActiveFocus();
            }
        }


        onStatusChanged: {
            console.debug('[mainFightSkillEditor]loader:', source, status);

            if(status === Loader.Ready) {
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
            console.debug('[mainFightSkillEditor]loader onLoaded');

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
                $showBusyIndicator(false);
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
            let list = $Frame.sl_dirList(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName, [], 0x001 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建技能】');
            l_listFightSkill.removeButtonVisible = {0: false, '-1': true};
            l_listFightSkill.show(list);

        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainFightSkillEditor]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainFightSkillEditor]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainFightSkillEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainFightSkillEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainFightSkillEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainFightSkillEditor]Component.onDestruction');
    }
}
