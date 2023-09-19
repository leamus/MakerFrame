﻿import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


import _Global 1.0
import _Global.Button 1.0

//import LGlobal 1.0



//系统
Item {
    id: root


    property alias gamemenuSystemMenu: gamemenuSystemMenu
    property alias maskSystemMenu: maskSystemMenu


    function showSystemMenu() {
        visible = true;
        gamemenuSystemMenu.show(['写入存档', '读取存档', '设置', '返回']);
    }

    function hide() {
        //closeWindow(0b1000);
        game.window({$id: 0b1000, $visible: false});
    }


    anchors.fill: parent
    visible: false


    Mask {
        id: maskSystemMenu

        anchors.fill: parent
        color: "#7FFFFFFF"

        mouseArea.onPressed: {
            root.hide();
        }
    }



    GameMenu {
        id: gamemenuSystemMenu

        width: parent.width * 0.6
        //width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.96
        //height: parent.height * 0.5
        height: Math.min(gamemenuSystemMenu.implicitHeight, parent.height * 0.6)

        anchors.centerIn: parent

        //width: parent.width
        //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
        //height: flickableSkills.height < implicitHeight ? flickableSkills.height : implicitHeight
        //height: parent.height
        //nItemMaxHeight: 100
        //nItemMinHeight: 50

        onS_Choice: function(index) {
            let continueScript;
            switch(index) {
            case 0:

                continueScript = function*() {
                    let readSavesInfo = game.$userscripts.$readSavesInfo || game.$gameMakerGlobalJS.$readSavesInfo;
                    let s = readSavesInfo();
                    s.push('取消');
                    let c = yield game.menu('选择存档', s);
                    switch(c) {
                    case 0:
                    case 1:
                    case 2:
                        game.save('存档' + c, game.gd["$sys_map"].$name, 1);
                        yield game.msg('存档成功');
                        break;
                    default:
                        break;
                    }
                }
                game.run(continueScript);

                break;
            case 1:

                continueScript = function*() {
                    let readSavesInfo = game.$userscripts.$readSavesInfo || game.$gameMakerGlobalJS.$readSavesInfo;
                    let s = readSavesInfo();
                    s.push('取消');
                    let c = yield game.menu('选择存档', s);
                    switch(c) {
                    case 0:
                    case 1:
                    case 2:
                        //game.$globalLibraryJS.setTimeout(function() {game.load('存档' + c)}, 0, game);
                        if(game.load('存档' + c)) {
                            yield game.msg('读档成功');
                        }
                        else {
                            yield game.msg("读取失败");
                        }
                        break;
                    default:
                        break;
                    }
                }
                game.run(continueScript);

                break;
            case 2:

                continueScript = function*() {
                    let musicInfo = '音乐状态：' + ((game.gd["$sys_sound"] & 0b1) ? '开' : '关');
                    let soundInfo = '音效状态：' + ((game.gd["$sys_sound"] & 0b10) ? '开' : '关');
                    //全局音乐
                    //let musicInfo = '音乐状态：' + (GameMakerGlobal.settings.value('$PauseMusic') ? '开' : '关');
                    //let soundInfo = '音效状态：' + (GameMakerGlobal.settings.value('$PauseSound') ? '开' : '关');

                    let c = yield game.menu('设 置', [musicInfo, soundInfo, '关闭']);
                    switch(c) {
                    case 0:
                        //存档音乐
                        if(game.gd["$sys_sound"] & 0b1) {
                            itemBackgroundMusic.pause(false);
                            yield game.msg('关闭音乐');
                        }
                        else {
                            itemBackgroundMusic.resume(false);
                            yield game.msg("打开音乐");
                        }
                        /*
                        //全局音乐
                        if(GameMakerGlobal.settings.value('$PauseMusic')) {
                            itemBackgroundMusic.resume(true);
                            yield game.msg("打开音乐");
                        }
                        else {
                            itemBackgroundMusic.pause(true);
                            yield game.msg('关闭音乐');
                        }
                        */
                        break;
                    case 1:
                        //存档音效
                        if(game.gd["$sys_sound"] & 0b10) {
                            rootSoundEffect.pause(false);
                            yield game.msg('关闭音效');
                        }
                        else {
                            rootSoundEffect.resume(false);
                            yield game.msg("打开音效");
                        }
                        /*
                        //全局音效
                        if(GameMakerGlobal.settings.value('$PauseSound')) {
                            rootSoundEffect.resume(true);
                            yield game.msg("打开音效");
                        }
                        else {
                            rootSoundEffect.pause(true);
                            yield game.msg('关闭音效');
                        }
                        */
                        break;
                    default:
                        break;
                    }
                }
                game.run(continueScript);

                break;
            case 3:
                root.hide();

                break;
            default:
                //root.visible = false;
            }
        }
    }
}
