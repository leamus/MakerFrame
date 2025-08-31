﻿import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: root


    signal sg_close(bool saved)



    function init() {
        let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;

        /*if($Frame.sl_fileExists(path + 'main.js')) {
            _private.strMainJSName = 'main.js';
        }
        //!!!兼容旧代码
        //else if($Frame.sl_fileExists(path + 'start.js')) {
        //    _private.strMainJSName = 'start.js';
        //}
        else {
            _private.strMainJSName = 'main.js';
        }
        */

        console.debug('[StartScriptEditor]filePath:', path + _private.strMainJSName);

        const defaultCode = _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, `
game.scale(1);
game.interval(16);
//yield game.loadmap('地图');
//game.createhero('深林孤鹰');
//game.movehero(1,11);
//game.playmusic('音乐1.mp3');
yield game.msg('Hello World<br>欢迎来到鹰歌游戏引擎，这是一个最简单的Demo，如果需要体验完整游戏请点击 示例工程 或加群下载更多工程！');
game.goon();
`);

        scriptEditor.init({
            BasePath: path,
            RelativePath: _private.strMainJSName,
            ChoiceButton: 0b0,
            PathText: 0b0,
            RunButton: 0b0,
            Default: defaultCode,
        });

        scriptEditor.forceActiveFocus();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true

    //color: Global.style.backgroundColor



    ScriptEditor {
        id: scriptEditor

        visible: true
        focus: true
        anchors.fill: parent
        //width: parent.width
        //height: parent.height


        strTitle: '游戏开始脚本'
        fnAfterCompile: function(code) {
            console.debug('[StartScriptEditor]code:', code);
            //if(code.indexOf('function* $start() {') < 0 && code.indexOf('function* start() {') < 0) {
            if(!/function\s*\*{0,1}\s*\${0,1}start\s*\(/.test(code)) {
                code = _private.strTemplate.replace(/\$\$START_SCRIPT\$\$/g, code);
            }
            return code;
        }

        visualScriptEditor.strTitle: strTitle

        visualScriptEditor.strSearchPath: GameMakerGlobal.config.strProjectRootPath + $Platform.sl_separator(true) + GameMakerGlobal.config.strCurrentProjectName
        visualScriptEditor.nLoadType: 1

        visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        visualScriptEditor.defaultCommandTemplate: [{'command':'函数/生成器{','params':['*$start',''],'status':{'enabled':true}},{'command':'块结束}','params':[],'status':{'enabled':true}}]


        onSg_close: function(saved) {
            root.sg_close(saved);
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private


        //js名
        readonly property string strMainJSName: 'main.js'

        property string strTemplate: `
//鹰：可以包含其他文件：
//.import 'Xxx.js' as JsName
//console.debug(JsName.aaa);



//游戏开始脚本（开始时调用）
function* $start() {

    game.playmusic('');


    while(1) {
        let c = yield game.menu('请选择', ['开始游戏','读取存档','游戏说明','制作人员']);
        switch(c) {
            case 0:
                $$START_SCRIPT$$

                break;
            case 1: {
                    /*let arrSave = [];
                    for(let i = 0; i < 3; ++i) {
                        let ts = game.checksave('存档' + i);
                        if(ts) {
                            arrSave.push('存档%1：%2（%3）'.arg(i).arg(ts.Name).arg(ts.Time));
                        }
                        else
                            arrSave.push('空');
                    }*/

                    let arrSave = game.$sys.resources.commonScripts.$readSavesInfo(3);
                    c = yield game.menu("载入存档", [...arrSave, "自动存档", "取消"]);
                    if(c < arrSave.length) {
                        //$CommonLibJS.runNextEventLoop(function() {yield game.load('存档' + c)},);
                        if(yield game.load('存档' + c)){
                            yield game.msg('读档成功');
                        }
                        else {
                            yield game.msg('读取失败');
                            continue;
                        }
                    }
                    else if(c === arrSave.length) {
                        //$CommonLibJS.runNextEventLoop(function() {yield game.load('autosave')},);
                        if(yield game.load('autosave')) {
                            yield game.msg('读档成功');
                        }
                        else {
                            yield game.msg('读取失败');
                            continue;
                        }
                    }
                    else {
                        continue;
                    }
                }
                break;
            case 2:
                yield game.msg('这里写游戏说明');
                continue;
            case 3:
                yield game.msg('框架和引擎开发：深林孤鹰', 60, '', 0);
                continue;
        }

        break;
    }
}
        `
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[StartScriptEditor]Keys.onEscapePressed');
        event.accepted = true;
    }
    Keys.onBackPressed: function(event) {
        console.debug('[StartScriptEditor]Keys.onBackPressed');
        event.accepted = true;
    }
    Keys.onPressed: function(event) {
        console.debug('[StartScriptEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[StartScriptEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[StartScriptEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[StartScriptEditor]Component.onDestruction');
    }
}
