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



    function $load(cfg) {
        root.forceActiveFocus();

        return init(cfg);
    }

    function init(cfg={}) {
        if(cfg) {
            if(cfg.Map)
                textMapRID.text = cfg.Map;
            if(cfg.Role)
                textRoleRID.text = cfg.Role;
            if(cfg.Position) {
                textMapBlockX.text = cfg.Position[0];
                textMapBlockY.text = cfg.Position[1];
            }
        }
    }
    function start() {
        _private.start();
    }



    property alias textMapRID: textMapRID.text
    property alias textRoleRID: textRoleRID.text
    property alias textMapBlockX: textMapBlockX.text
    property alias textMapBlockY: textMapBlockY.text


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
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        TextField {
            id: textMapRID
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            //selectByKeyboard: true
            selectByMouse: true
            //wrapMode: TextEdit.Wrap

        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: '选择地图'
            onClicked: {

                l_listChoice.visible = true;
                //l_listChoice.focus = true;
                //l_listChoice.forceActiveFocus();
                l_listChoice.show(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName, [], 0x001 | 0x2000, 0x00);

                l_listChoice.choicedComponent = textMapRID;
            }
        }

        TextField {
            id: textRoleRID
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            //selectByKeyboard: true
            selectByMouse: true
            //wrapMode: TextEdit.Wrap

        }

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: '选择角色'
            onClicked: {

                l_listChoice.visible = true;
                //l_listChoice.focus = true;
                //l_listChoice.forceActiveFocus();
                l_listChoice.show(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName, [], 0x001 | 0x2000, 0x00);

                l_listChoice.choicedComponent = textRoleRID;
            }
        }


        RowLayout {
            //Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width

            Label {
                text: qsTr('地图块坐标：')
            }

            TextField {
                id: textMapBlockX
                Layout.fillWidth: true
                text: '0'
                placeholderText: '0'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textMapBlockY
                Layout.fillWidth: true
                text: '0'
                placeholderText: '0'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        Button {
            id: buttonStart

            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: '开　始'

            onClicked: {
                _private.start();
            }
        }


        RowLayout {
            visible: false

            //Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: '主角大小：'
            }

            TextField {
                id: textMainRoleWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: '50'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: '*'
            }

            TextField {
                id: textMainRoleHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: '80'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }
    }



    //游戏场景
    //关闭时会释放，这样如果有资源释放失败（GameScene的ReleaseResource）也没问题；
    Loader {
        id: loaderGameScene

        visible: false
        //focus: true

        anchors.fill: parent


        source: ''
        asynchronous: true



        Connections {
            target: loaderGameScene.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                _private.gameSceneClose();
            }
        }


        onStatusChanged: {
            console.debug('[mainGameTest]loaderGameScene:', source, status);

            if(status === Loader.Ready) {
                //$showBusyIndicator(false);
            }
            else if(status === Loader.Error) {
                _private.gameSceneClose();

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
            console.debug('[mainGameTest]loaderGameScene onLoaded');

            try {
                /*let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'map.json';
                //let cfg = File.read(filePath);
                let cfg = $Frame.sl_fileRead(filePath);
                //console.debug('cfg', cfg, filePath);

                if(!cfg)
                    return false;
                cfg = JSON.parse(cfg);
                //console.debug('cfg', cfg);
                //loaderGameScene.setSource('./MapEditor_1.qml', {});
                loaderGameScene.item.openMap(cfg);
                */



                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                ///item.focus = true;
                //if(item.forceActiveFocus)
                //    item.forceActiveFocus();


                //item.testFresh();
                item.bTest = true;
                //item.openMap(item);
                const tScript = function*() {
                    yield game.msg('欢迎来到鹰歌Maker世界！');
                    yield game.loadmap(textMapRID.text);
                    if(textRoleRID.text.trim()) {
                        game.createhero(textRoleRID.text);
                        game.movehero(isNaN(parseInt(textMapBlockX.text)) ? 0 : parseInt(textMapBlockX.text), isNaN(parseInt(textMapBlockY.text)) ? 0 : parseInt(textMapBlockY.text));
                    }
                    game.interval(16);
                    game.goon();
                }


                //if(item.$load)
                    item.$load(tScript, true);

                visible = true;
            }
            catch(e) {
                _private.gameSceneClose();
                throw e;
            }
            finally {
                $showBusyIndicator(false);
            }
        }
    }


    L_List {
        id: l_listChoice


        //要改变的控件
        property var choicedComponent


        visible: false
        anchors.fill: parent
        //width: parent.width
        //height: parent.height

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor

        removeButtonVisible: false


        onSg_clicked: {
            if(item === '..') {
                return;
            }

            choicedComponent.text = item;


            visible = false;
            root.forceActiveFocus();
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

        function start() {
            if(textMapRID.text === ''/* || textRoleRID.text === ''*/)
                return;


            buttonStart.enabled = false;

            loaderGameScene.source = './Core/GameScene.qml';
        }


        function gameSceneClose() {
            loaderGameScene.source = '';


            buttonStart.enabled = true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainGameTest]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainGameTest]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainGameTest]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainGameTest]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainGameTest]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainGameTest]Component.onDestruction');
    }
}
