import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import 'File.js' as File



Rectangle {
    id: root


    signal s_close();


    function init() {

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'start.js';
        //let data = File.read(filePath);
        let data = FrameManager.sl_qml_ReadFile(filePath);
        console.debug('[GameStart]filePath：', filePath);
        //console.exception('????')

        if(data) {

            //data = JSON.parse(data);
            //console.debug('data', data);
            //loaderGameScene.setSource('./MapEditor.qml', {});
            //loaderGameScene.item.init(data);

            //textGameStartScript.text = data.GameStartScript;
            FrameManager.setPlainText(textGameStartScript.textDocument, data);
            textGameStartScript.toBegin();
            //textGameFPS.text = data.GameFPS;

            return true;
        }
        else {
            FrameManager.setPlainText(textGameStartScript.textDocument,
                _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, "
game.scale(1);
game.setinterval(16);
//game.loadmap('鹰歌地图');
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


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
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
                text: '游戏起始脚本'
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }

            ColorButton {
                text: 'v'
                onButtonClicked: {
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
                id: textGameStartScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                textArea.text: ''
                textArea.placeholderText: ''
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

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

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

            ColorButton {
                id: buttonStartGame

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                enabled: true

                text: '开始游戏'

                onButtonClicked: {
                    //enabled = false;

                    loaderGameScene.source = './Core/GameScene.qml';

                }
            }

            /*ColorButton {
                id: buttonDeleteSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.bottomMargin: 10

                text: '删除自动存档'
                onButtonClicked: {
                    FrameManager.sl_qml_DeleteFile(GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + 'autosave.json');
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

    Loader {
        id: loaderVisualScript


        function show() {
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
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'start';

            item.loadData(filePath);

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
                if(code.indexOf('function *$start() {') < 0 && code.indexOf('function *start() {') < 0) {
                    code = _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, code);
                }
                FrameManager.setPlainText(textGameStartScript.textDocument, code);
                textGameStartScript.toBegin();
            }
        }
    }


    //游戏场景
    //关闭时会释放，这样如果有资源释放失败（GameScene的ReleaseResource）也没问题；
    Loader {
        id: loaderGameScene

        anchors.fill: parent

        visible: false
        focus: true


        source: ''
        asynchronous: false



        onStatusChanged: {
            console.log('[GameStart]loaderGameScene.status：', loaderGameScene.status);

            if (loaderGameScene.status === Loader.Ready) {
            }
        }

        onLoaded: {
            console.debug('[GameStart]GameScene Loader onLoaded');
            //buttonStartGame.enabled = true;
            //item.testFresh();

            let ret = FrameManager.sl_qml_WriteFile(FrameManager.toPlainText(textGameStartScript.textDocument), GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + 'start.js', 0);

            loaderGameScene.visible = true;
            loaderGameScene.focus = true;
            loaderGameScene.item.focus = true;

            loaderGameScene.item.init(true, true);

        }



        Connections {
            target: loaderGameScene.item
            function onS_close() {

                loaderGameScene.visible = false;
                //root.focus = true;
                root.forceActiveFocus();

                loaderGameScene.source = '';

                //buttonStartGame.enabled = true;
            }
        }
    }



    QtObject {
        id: _private

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
                        //game.$globalLibraryJS.setTimeout(function() {game.load('存档' + c)}, 0, game);
                        if(game.load('存档' + c))
                            break;
                        else
                            yield game.msg("读取失败");
                        continue;
                    case 3:
                        //game.$globalLibraryJS.setTimeout(function() {game.load('autosave')}, 0, game);
                        if(game.load('autosave'))
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


//游戏初始化（游戏开始和载入存档时调用）
function *$init() {

    //每秒恢复
    function resumeEventScript(combatant) {

        if(combatant.$properties.HP[0] <= 0)
            return;

        game.addprops(combatant, {'HP': [2], 'MP': [2]});
    }

    //每秒恢复事件
    game.addtimer("resume_event", 1000, -1, true);
    game.gf["resume_event"] = function() {
        for(let h in game.gd["$sys_fight_heros"]) {
            resumeEventScript(game.gd["$sys_fight_heros"][h]);
        }
    }


    //点击屏幕事件
    game.gf['$map_click'] = function(bx, by, x, y) {
        let hero = game.hero(0, {$action: 2, $targetBx: bx, $targetBy: by});
    }


    yield game.msg("合理安排时间");

    game.goon();

}


//存档后调用
function *$save() {

}


//读档后调用
function *$load() {

}

        `
    }

    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug('[GameStart]Escape Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug('[GameStart]Back Key');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GameStart]Keys.onPressed:', event.key);
    }
    Keys.onReleased: {
        console.debug('[GameStart]Keys.onReleased:', event.key);
    }


    Component.onCompleted: {
        //FrameManager.globalObject().GameMakerGlobal = GameMakerGlobal;

        console.debug("[GameStart]Component.onCompleted");
    }

    Component.onDestruction: {
        //delete FrameManager.globalObject().GameMakerGlobal;

        console.debug("[GameStart]Component.onDestruction");
    }
}
