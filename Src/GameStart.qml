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
        let data;
        //let data = File.read(filePath);

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;
        if(FrameManager.sl_fileExists(filePath + 'main.js')) {
            gameVisualScript.loadData(filePath + 'main.vjs');
            _private.strMainJSName = 'main.js';

            data = FrameManager.sl_fileRead(filePath + 'main.js');
        }
        //!!!兼容旧代码
        else if(FrameManager.sl_fileExists(filePath + 'start.js')) {
            gameVisualScript.loadData(filePath + 'start.vjs');
            _private.strMainJSName = 'start.js';

            data = FrameManager.sl_fileRead(filePath + 'start.js');
        }
        else {
            gameVisualScript.loadData(filePath + 'main.vjs');
            _private.strMainJSName = 'main.js';

            data = FrameManager.sl_fileRead(filePath + 'main.js');
        }
        console.debug('[GameStart]filePath：', filePath + _private.strMainJSName);


        if(data) {

            //data = JSON.parse(data);
            //console.debug('data', data);
            //loaderGameScene.setSource('./MapEditor.qml', {});
            //loaderGameScene.item.init(data);

            //textGameStartScript.text = data.GameStartScript;
            textGameStartScript.setPlainText(data);
            textGameStartScript.toBegin();
            //textGameFPS.text = data.GameFPS;

            return true;
        }
        else {
            textGameStartScript.setPlainText(
                _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, "
game.scale(1);
game.interval(16);
//yield game.loadmap('鹰歌地图');
//game.createhero('深林孤鹰');
//game.movehero(1,11);
//game.playmusic('音乐1mp3');
yield game.msg('Hello World<br>欢迎来到鹰歌Maker，这是一个最简单的demo，如果需要体验完整游戏请点击 示例工程 或加群下载更多工程！');
game.goon();
")
            );
            textGameStartScript.toBegin();

            return false;
        }
    }

    function start() {
        textGameStartScript.enabled = false;
        buttonStartGame.enabled = false;

        loaderGameScene.source = './Core/GameScene.qml';
        if(loaderGameScene.status === Loader.Loading)
            showBusyIndicator(true);
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
                    let e = GameMakerGlobalJS.checkJSCode(FrameManager.sl_toPlainText(textGameStartScript.textDocument));

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
                text: '游戏起始脚本'
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }

            Button {
                text: 'V'
                onClicked: {
                    gameVisualScript.show();
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
                id: textGameStartScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                color: Global.style.backgroundColor

                //textArea.enabled: false
                //textArea.readOnly: true
                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: ''

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }

                bCode: true
            }

        }

        /*RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {

                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 20

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

                font.pointSize: 15
                text: '游戏刷新率：'
            }

            TextField {
                id: textGameFPS

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: '16'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                id: buttonStartGame

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                enabled: true

                text: '开始游戏'

                onClicked: {
                    start();
                }
            }

            /*Button {
                id: buttonDeleteSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: '删除自动存档'
                onClicked: {
                    FrameManager.sl_fileDelete(GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + 'autosave.json');
                }
            }*/
        }


        /*RowLayout {
            //Layout.preferredWidth: root.width * 0.96
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
                text: 'X'
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
        }*/
    }

    //Loader {
    VisualScript {
        id: gameVisualScript
        //id: loaderVisualScript



        function show() {
            visible = true;
            //focus = true;
            forceActiveFocus();
            //item.focus = true;
            //item.forceActiveFocus();
        }


        anchors.fill: parent

        visible: false
        //focus: true


        //source: './GameVisualScript.qml'
        /*sourceComponent: Component {
            VisualScript {

            }
        }
        */
        //asynchronous: false


        strTitle: '游戏开始脚本'

        defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        defaultCommandTemplate: [{"command":"函数/生成器{","params":["*$start",""],"status":{"enabled":true}},{"command":"块结束}","params":[],"status":{"enabled":true}}]



        /*onLoaded: {
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'start.vjs';
            item.loadData(filePath);

            console.debug('[GameStart]loaderVisualScript onLoaded');
        }
        */

        //Connections {
        //    target: loaderVisualScript.item
            //忽略没有的信号
            //ignoreUnknownSignals: true

            onSg_close: function() {
                //init();


                gameVisualScript.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }

            onSg_compile: function(code) {
                //console.debug(code)
                if(code.indexOf('function *$start() {') < 0 && code.indexOf('function *start() {') < 0) {
                    code = _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, code);
                }
                textGameStartScript.setPlainText(code);
                textGameStartScript.toBegin();
            }
        //}
    }


    //游戏场景
    //关闭时会释放，这样如果有资源释放失败（GameScene的ReleaseResource）也没问题；
    Loader {
        id: loaderGameScene

        visible: false
        focus: true

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
            console.debug('[GameStart]loaderGameScene.status：', status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                _private.gameSceneClose();

                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;
                //root.focus = true;
                root.forceActiveFocus();


                FrameManager.sl_clearComponentCache();
                FrameManager.sl_trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[GameStart]loaderGameScene onLoaded');

            try {
                let ret = FrameManager.sl_fileWrite(FrameManager.sl_toPlainText(textGameStartScript.textDocument), GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + _private.strMainJSName, 0);

                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init(true, true);

                visible = true;
            }
            catch(e) {
                _private.gameSceneClose();
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


        //js名
        property string strMainJSName: 'main.js'

        property string strTemplate: `
//鹰：可以包含其他文件：
//.import 'XXX.js' as JsName
//console.debug(JsName.aaa);



//游戏开始脚本（开始时调用）
function *$start() {

    game.playmusic("");


    while(1) {
        let c = yield game.menu("请选择", ["开始游戏","读取存档","游戏说明","制作人员"]);
        switch(c) {
            case 0:
                $$START_SCRIPT$$

                break;
            case 1:
                /*let arrSave = [];
                for(let i = 0; i < 3; ++i) {
                    let ts = game.checksave('存档' + i);
                    if(ts) {
                        arrSave.push('存档%1：%2（%3）'.arg(i).arg(ts.Name).arg(ts.Time));
                    }
                    else
                        arrSave.push('空');
                }*/

                let readSavesInfo = game.$userscripts.$readSavesInfo || game.$gameMakerGlobalJS.$readSavesInfo;
                let arrSave = readSavesInfo();

                c = yield game.menu("载入存档", [...arrSave,"自动存档","取消"]);
                switch(c) {
                    case 0:
                    case 1:
                    case 2:
                        //game.$globalLibraryJS.runNextEventLoop(function() {yield game.load('存档' + c)},);
                        if(yield game.load('存档' + c))
                            break;
                        else
                            yield game.msg("读取失败");
                        continue;
                    case 3:
                        //game.$globalLibraryJS.runNextEventLoop(function() {yield game.load('autosave')},);
                        if(yield game.load('autosave'))
                            break;
                        else
                            yield game.msg("读取失败");
                        continue;
                    default:
                        continue;
                }
                break;
            case 2:
                yield game.msg("这里写游戏说明");
                continue;
            case 3:
                yield game.msg("框架和引擎开发：深林孤鹰", 60, '', 0);
                continue;
        }

        break;
    }
}
        `

        function gameSceneClose() {
            loaderGameScene.source = '';


            textGameStartScript.enabled = true;
            buttonStartGame.enabled = true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug('[GameStart]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug('[GameStart]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameStart]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[GameStart]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[GameStart]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[GameStart]Component.onDestruction");
    }
}
