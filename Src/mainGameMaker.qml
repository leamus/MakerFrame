import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import QtGraphicalEffects 1.0
//import Qt.labs.platform 1.1


import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import 'Core/Singleton'
import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import '../../_Global/CommonLib.js' as CommonLibJS
//import '../../_Global/Global.js' as GlobalJS
//import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: rootGameMaker
    objectName: 'GameMaker'


    signal sg_close();



    property var $eval: (loader.item ? loader.item.$eval : null) ?? (()=>(c)=>eval(c))()

    readonly property var showMsg: rectHelpWindow.showMsg


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Component {
        id: compScriptEditor

        ScriptEditor {
            anchors.fill: parent
            //width: parent.width
            //height: parent.height

            //strBasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName
            //strTitle: '脚本编辑'
            /*fnAfterCompile: function(code) {return code;}*/

            //visualScriptEditor.strTitle: strTitle

            visualScriptEditor.arrMajorSearchPaths: [GameMakerGlobal.config.strWorkPath + 'Plugins/$Leamus/$VisualScripts', GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/Plugins/$Leamus/$VisualScripts']
            visualScriptEditor.arrMinorSearchPaths: [GameMakerGlobal.config.strWorkPath + 'Plugins', GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + '/Plugins']

            //visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
            //visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
            visualScriptEditor.defaultCommandsInfo: _private.jsGameVisualScript.data.commandsInfo
            visualScriptEditor.defaultCommandGroupsInfo: _private.jsGameVisualScript.data.groupsInfo
            //visualScriptEditor.defaultCommandTemplate: []


            onSg_close: function(saved) {
                //scriptEditor.visible = false;
                //rootGameMaker.forceActiveFocus();
            }
        }
    }


    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }


    /*GameMakerGlobal {
        id: gameMakerGlobal
    }
    */


    ColumnLayout {
        height: parent.height * 0.9
        width: parent.width * 0.9
        anchors.centerIn: parent

        spacing: 0


        Label {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            //Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 18
            font.bold: true
            text: qsTr('鹰歌游戏引擎 GameMaker')

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Item {
            Layout.preferredHeight: 1
            Layout.fillHeight: true
        }

        Label {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            //Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //height: 50
            //width: parent.width
            font.pointSize: 12
            text: qsTr('当前工程：' + GameMakerGlobal.config.strCurrentProjectName)

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        Item {
            Layout.preferredHeight: 1
            Layout.fillHeight: true
        }


        ColumnLayout {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 9
            //Layout.preferredHeight: parent.height * 0.7
            //Layout.fillHeight: false

            //anchors.centerIn: parent

            spacing: 0

            /*Button {
                //id: buttonTest

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: 'Test'
                onClicked: menuTest.open();

                Menu {
                    id: menuTest

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: 'MenuItem'
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            console.warn(9);
                        }
                        onTriggered: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            console.warn(99);
                        }
                    }
                    MenuSeparator { }
                    Action {
                        text: 'Action'
                        onTriggered: {
                            console.info(999)
                        }
                    }

                    onAboutToHide: {
                        console.info(6)
                    }
                    onClosed: {
                        console.info(66)
                    }
                }
            }
            */


            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: '工程管理'
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    menuProjectManager.open();
                    menuProjectManager.enabled = true;
                }

                Menu {
                    id: menuProjectManager

                    //鹰：控制enable，是因为Menu关闭的瞬间，鼠标和触屏仍然可以点到MenuItem会让focus会转移到它身上，enabled设置为false可避免；
                    enabled: false
                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '新建工程'
                        height: _private.config.nMenuItemHeight
                        //focusPolicy: Qt.NoFocus
                        //hoverEnabled: false
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.newProject();
                        }
                    }
                    MenuItem {
                        text: '打开工程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.openProject();
                        }
                    }
                    MenuItem {
                        text: '重命名工程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.renameProject();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '导出工程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            if(!_private.checkCurrentProjectName()) {
                                return;
                            }
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.exportProject();
                        }
                    }
                    MenuItem {
                        text: '导入工程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.importProject();
                        }
                    }
                    /*MenuItem {
                        text: '下载示例工程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.downloadDemoProject();
                        }
                    }
                    */
                    MenuSeparator { }
                    MenuItem {
                        text: '打包项目'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            if(!_private.checkCurrentProjectName()) {
                                return;
                            }
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.gamePackage();
                        }
                    }
                    MenuItem {
                        text: '平台分发'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.future();
                        }
                    }
                    /* 貌似和MenuItem一样
                    Action { text: 'Cut' }
                    Action { text: 'Copy' }
                    Action { text: 'Paste' }
                    */


                    onAboutToHide: {
                        enabled = false;
                    }
                    //onClosed: {
                    //}
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: 0.5
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: '游戏编辑器'
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuGameEditor.open();
                    menuGameEditor.enabled = true;
                }

                Menu {
                    id: menuGameEditor

                    //鹰：控制enable，是因为Menu关闭的瞬间，鼠标和触屏仍然可以点到MenuItem会让focus会转移到它身上，enabled设置为false可避免；
                    enabled: false
                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '地图编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.mapEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '角色编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.roleEditor();
                        }
                    }
                    MenuItem {
                        text: '特效编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.spriteEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '道具编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.goodsEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗技能编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.fightSkillEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗角色编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.fightRoleEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗脚本编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.fightScriptEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '起始脚本编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.startScriptEditor();
                        }
                    }
                    MenuItem {
                        text: '通用脚本编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.commonScriptEditor();
                        }
                    }
                    MenuItem {
                        text: '脚本编辑器'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.scriptEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '测　试'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.gameTest();
                        }
                    }


                    onAboutToHide: {
                        enabled = false;
                    }
                    //onClosed: {
                    //}
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: 0.5
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: '媒体资源'
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuResourceManager.open();
                    menuResourceManager.enabled = true;
                }

                Menu {
                    id: menuResourceManager

                    //鹰：控制enable，是因为Menu关闭的瞬间，鼠标和触屏仍然可以点到MenuItem会让focus会转移到它身上，enabled设置为false可避免；
                    enabled: false
                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '图片管理'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.imageEditor();
                        }
                    }
                    MenuItem {
                        text: '音乐管理'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.musicEditor();
                        }
                    }
                    MenuItem {
                        text: '视频管理'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.videoEditor();
                        }
                    }
                    /*MenuItem {
                        text: '压缩文件夹'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.compressDir();
                        }
                    }
                    MenuItem {
                        text: '解压文件夹'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.uncompressDir();
                        }
                    }
                    */


                    onAboutToHide: {
                        enabled = false;
                    }
                    //onClosed: {
                    //}
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: 0.5
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: '插　件'
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuPluginsManager.open();
                    menuPluginsManager.enabled = true;
                }

                Menu {
                    id: menuPluginsManager

                    //鹰：控制enable，是因为Menu关闭的瞬间，鼠标和触屏仍然可以点到MenuItem会让focus会转移到它身上，enabled设置为false可避免；
                    enabled: false
                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '插件管理'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.pluginsManager(1);
                        }
                    }
                    MenuItem {
                        text: '插件下载'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.pluginsManager(2);
                            //_private.pluginsDownload();
                        }
                    }

                    MenuSeparator { }

                    MenuItem {
                        text: '全局插件'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.pluginsManager(0);
                        }
                    }


                    onAboutToHide: {
                        enabled = false;
                    }
                    //onClosed: {
                    //}
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: 0.5
            }

            Button {
                //Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: `<font color="${Global.style.color(Global.style.Red)}"><b>开始游戏</b></font>`
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    _private.gameStart();
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredHeight: 0.5
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 1
                Layout.minimumHeight: 20
                Layout.fillHeight: true
                Layout.maximumHeight: implicitHeight * 1.2

                text: '文　档'
                font.pointSize: _private.config.nButtonTextSize

                onClicked: {
                    menuDocuments.open();
                    menuDocuments.enabled = true;
                }

                Menu {
                    id: menuDocuments

                    //鹰：控制enable，是因为Menu关闭的瞬间，鼠标和触屏仍然可以点到MenuItem会让focus会转移到它身上，enabled设置为false可避免；
                    enabled: false
                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '关　于'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.about();
                        }
                    }
                    MenuItem {
                        text: '教　程'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.tutorial();
                        }
                    }
                    MenuItem {
                        text: '使用协议'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.agreement();
                        }
                    }
                    MenuItem {
                        text: '更新日志'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.updateLog();
                        }
                    }
                    MenuItem {
                        text: '建议意见'
                        height: _private.config.nMenuItemHeight
                        onClicked: {
                            $Frame.sl_objectParent(this).parent.forceActiveFocus(); //Menu的父级获取焦点
                            _private.suggest();
                        }
                    }


                    onAboutToHide: {
                        enabled = false;
                    }
                    //onClosed: {
                    //}
                }
            }


            /*
            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '新建工程'
                    onClicked: {
                        _private.newProject();
                    }
                }


                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '打开工程'
                    onClicked: {
                        _private.openProject();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '重命名'
                    onClicked: {
                        _private.renameProject();
                    }
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '地　图'
                onClicked: {
                    _private.mapEditor();
                }
            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '角　色'
                    onClicked: {
                        _private.roleEditor();
                    }
                }


                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '特　效'
                    onClicked: {
                        _private.spriteEditor();
                    }
                }


                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '道　具'
                    onClicked: {
                        _private.goodsEditor();
                    }
                }

            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '战斗角色'
                    //font.pointSize: 14

                    onClicked: {
                        _private.fightRoleEditor();
                    }
                }


                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '战斗技能'
                    //font.pointSize: 14

                    onClicked: {
                        _private.fightSkillEditor();
                    }
                }


                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '战斗脚本'
                    //font.pointSize: 14

                    onClicked: {
                        _private.fightScriptEditor();
                    }
                }

            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    //Layout.preferredHeight: 50
                    Layout.fillHeight: true

                    text: '通用脚本'
                    onClicked: {
                        _private.commonScriptEditor();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '脚　本'
                    onClicked: {
                        _private.scriptEditor();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '插　件'
                    onClicked: {
                        _private.pluginsManage();
                    }
                }
            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '图片管理'
                    onClicked: {
                        _private.imageEditor();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '音乐管理'
                    onClicked: {
                        _private.musicEditor();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '视频管理'
                    onClicked: {
                        _private.videoEditor();
                    }
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '开始游戏'
                onClicked: {
                    _private.gameStart();
                }
            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '测　试'
                    onClicked: {
                        _private.gameTest();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '打包项目'
                    onClicked: {
                        _private.gamePackage();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '平台分发'
                    onClicked: {
                        _private.future();
                    }
                }
            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '导出工程'
                    onClicked: {
                        _private.exportProject();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '导入工程'
                    onClicked: {
                        _private.importProject();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '示例工程'
                    onClicked: {
                        _private.downloadDemoProject();
                    }
                }
            }

            RowLayout {
                //Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '教　程'
                    onClicked: {
                        _private.tutorial();
                    }
                }

                /*Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '关于'
                    onClicked: {
                        if($Platform.compileType === 'debug') {
                            loader.loadModule('mainAbout.qml');
                            //userMainProject.source = 'mainAbout.qml';
                        }
                        else {
                            loader.loadModule('mainAbout.qml');
                            //userMainProject.source = 'mainAbout.qml';
                        }
                    }
                }
                * /

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '使用协议'
                    onClicked: {
                        _private.agreement();
                    }
                }

                Button {
                    Layout.preferredWidth: 1
                    Layout.fillWidth: true
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    //Layout.preferredHeight: 50
                    //Layout.minimumHeight: 20
                    Layout.fillHeight: true

                    text: '更新日志'
                    onClicked: {
                        _private.updateLog();
                    }
                }
            }
            */
        }


        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 1
        }

        ColumnLayout {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            //Layout.preferredHeight: 30
            //Layout.minimumHeight: 20
            //Layout.fillHeight: true

            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                Layout.fillWidth: true
                //Layout.preferredHeight: 0
                Layout.minimumHeight: 0
                //Layout.fillHeight: true

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    //anchors.right: parent.right
                    //anchors.bottom: parent.bottom
                    //anchors.rightMargin: 20
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.verticalCenter: parent.verticalCenter
                    //height: 50
                    //width: parent.width
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    //Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr('<a href="https://afdian.com/a/Leamus">爱发电</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally(link);
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    //Layout.preferredWidth: implicitWidth
                    //Layout.maximumWidth: parent.width
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true


                    font.pointSize: 12
                    text: qsTr('<a href="http://makerframe.leamus.cn/Privacy.html">隐私政策</a>')

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter

                    onLinkActivated: {
                        Qt.openUrlExternally(link);
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            Label {
                //anchors.left: parent.left
                //anchors.bottom: parent.bottom
                //anchors.leftMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                //Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                //width: parent.width
                font.pointSize: 12
                text: qsTr('QQ：85885245')
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

            }

            Label {
                //anchors.right: parent.right
                //anchors.bottom: parent.bottom
                //anchors.rightMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                //width: parent.width
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                //Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 12
                text: qsTr('Ver：' + GameMakerGlobal.version)
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

                MouseArea {
                    anchors.fill: parent

                    onDoubleClicked: {
                        let n = Math.random();
                        if(n < 0.25)
                            Qt.openUrlExternally('https://gitee.com/openkylin/maker-frame');
                        else if(n < 0.5)
                            Qt.openUrlExternally('https://github.com/leamus/MakerFrame');
                        else if(n < 0.75)
                            Qt.openUrlExternally('https://gitee.com/leamus/MakerFrame');
                        else if(n < 1)
                            Qt.openUrlExternally('https://gitee.com/leamus/MakerFrame');
                    }
                }
            }

        }

    }


    //Item {
        //Layout.preferredWidth: parent.width * 0.96
        //Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        //Layout.preferredHeight: 50

    //}



    //主窗口加载
    L_Loader {
        id: loader
        objectName: 'GameMakerLoader'


        //载入模块
        function loadModule(url=null, ...params) {
            //console.debug('loadModule:', url, params);


            //if(url.length !== 0 && !checkCurrentProjectName())
            //    return false;


            if(status === Loader.Loading)
                vInitParamsBackup = params;
            else
                vInitParams = params;
            load($CommonLibJS.isString(url) ? Qt.resolvedUrl(url) : url, undefined, );
        }

        fnCustomLoad: function(url, properties) {
            loadModule(url, ...vInitParamsBackup);
            vInitParamsBackup = null;
        }


        property var vInitParams: [] //调用item.$init时给的参数
        property var vInitParamsBackup: [] //调用item.$init时给的参数 备份

        visible: false
        focus: true
        clip: true

        //anchors.fill: parent

        //source: ''
        //asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loader.close();
            }
        }



        onStatusChanged: {
            console.debug('[mainGameMaker]loader onStatusChanged:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                //close();
            }
            else if(status === Loader.Null) {
                visible = false;

                //rootGameMaker.focus = true;
                rootGameMaker.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
            }
        }

        onLoaded: {
            console.debug('[mainGameMaker]loader onLoaded:', vInitParams);

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                ///focus = true;
                forceActiveFocus();

                if(item.$load)
                    item.$load(...vInitParams);

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
            }
        }
    }



    //帮助窗口
    Item {
        id: rectHelpWindow


        //显示信息
        function showMsg(msg) {
            //替换一些常用的字符为HTML代码
            textHelpInfo.text = $CommonLibJS.convertToHTML(msg);

            rectHelpWindow.visible = true;
            rectHelpWindow.forceActiveFocus();
        }

        function close() {
            rectHelpWindow.visible = false;
            //loader.focus = true;
            loader.forceActiveFocus();
        }


        anchors.fill: parent

        visible: false

        //color: 'black'

        Keys.onEscapePressed: function(event) {
            event.accepted = true;

            close();
        }
        Keys.onBackPressed: function(event) {
            event.accepted = true;

            close();
        }
        Keys.onPressed: function(event) {
            console.debug('[mainGameMaker]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
            //event.accepted = true;
        }
        Keys.onReleased: function(event) {
            console.debug('[mainGameMaker]Keys.onReleased:', event.key, event.isAutoRepeat);
            //event.accepted = true;
        }



        Mask {
            anchors.fill: parent
            //opacity: 0
            //color: Global.style.backgroundColor
            color: '#90000000'
            //radius: 9

            mouseArea.onPressed: {
                parent.visible = false;
            }
        }


        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.9

            RowLayout {
                Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.maximumHeight: parent.height
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Notepad {
                    id: textHelpInfo

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1

                    //Layout.preferredHeight: parent.height
                    //Layout.maximumHeight: parent.height
                    //Layout.minimumHeight: 50
                    Layout.fillHeight: true

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                    textArea.color: 'white'
                    //textArea.color: Global.style.foreground
                    //textArea.enabled: false
                    textArea.readOnly: true

                    textArea.wrapMode: TextArea.WrapAnywhere
                    textArea.horizontalAlignment: TextArea.AlignJustify
                    //textArea.verticalAlignment: TextArea.AlignVCenter

                    textArea.selectByMouse: false

                    textArea.text: ''
                    textArea.placeholderText: ''

                    textArea.background: Rectangle {
                        //implicitWidth: 200
                        //implicitHeight: 40
                        color: 'black'
                        //color: 'transparent'
                        //color: Global.style.backgroundColor
                        border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                        border.width: parent.parent.textArea.activeFocus ? 2 : 1
                    }
                }
            }


            RowLayout {
                Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.maximumHeight: 50
                //Layout.fillHeight: true

                Button {
                    text: '关　闭'
                    onClicked: {
                        rectHelpWindow.close();
                    }
                }
            }

        }
    }



    QtObject {
        id: _private

        function checkCurrentProjectName() {
            if(GameMakerGlobal.config.strCurrentProjectName.trim().length === 0) {
                $dialog.show({
                    Msg: '请先新建或选择一个工程',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        //rootGameMaker.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //rootGameMaker.forceActiveFocus();
                    },
                });
                return false;
            }

            return true;
        }


        //切换工程，转移和检查工程引擎变量
        function changeProject(newProject='', oldProject=null) {
            newProject = newProject.trim();
            GameMakerGlobal.config.strCurrentProjectName = newProject;
            if(newProject.length === 0)
                return;

            if(oldProject !== null) {
                GameMakerGlobal.settings.setValue('Projects/' + newProject, GameMakerGlobal.settings.value('Projects/' + oldProject/*, {}*/)); //只有没有值（存undefined也算有值）的时候才返回默认值
                GameMakerGlobal.settings.setValue('Projects/' + oldProject, undefined);
            }
            if(!GameMakerGlobal.settings.value('Projects/' + newProject))
                GameMakerGlobal.settings.setValue('Projects/' + newProject, {});
        }


        //打开工程
        function newProject() {
            $dialog.show({
                Msg: '输入工程名',
                Input: '新建工程',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if($Frame.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + $dialog.input)) {
                        $dialog.show({
                            Msg: '工程已存在',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                //rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //rootGameMaker.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    _private.changeProject($dialog.input);

                    const projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName;
                    $Frame.sl_dirCreate(projectPath);


                    $dialog.show({
                        Msg: '是否复制素材资源？\r\n（注意：素材资源均来自互联网，仅供测试使用，侵删）',
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            /*$dialog.show({
                                Msg: '由于服务器带宽低，下载人数多时会导致很慢，建议加群后可以下载更多的示例工程，确定下载吗？',
                                Buttons: Dialog.Yes | Dialog.No,
                                OnAccepted: function() {
                            */


                            const resTemplate = GameMakerGlobal.config.strWorkPath + '$资源模板.zip';
                            function _continue() {
                                const ret = unzipFile(resTemplate, projectPath);
                                if(ret.length > 0)
                                    ;
                            }
                            if(!$Frame.sl_fileExists(resTemplate)) {
                                //https://qiniu.leamus.cn/$资源模板.zip

                                downloadFile('http://MakerFrame.Leamus.cn/GameMaker/$资源模板.zip', resTemplate,
                                    _continue, null);
                            }
                            else
                                _continue();

                            //enabled = false;

                            /*
                                },
                                OnRejected: ()=>{
                                    rootGameMaker.forceActiveFocus();
                                },
                            });
                            */

                            //rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //rootGameMaker.forceActiveFocus();
                        },
                    });

                    //rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    //rootGameMaker.forceActiveFocus();
                },
            });
        }

        function openProject() {
            $list.open({
                RemoveButtonVisible: true,
                Data: GameMakerGlobal.config.strProjectRootPath,
                Params: [[], 0x001 | 0x2000, 0x00],
                OnClicked: (index, item)=>{
                    if(item === '..') {
                        $list.close();
                        return;
                    }


                    //loader.loadModule();
                    _private.changeProject(item);


                    $list.close();
                    //rootGameMaker.forceActiveFocus();
                },
                OnCanceled: ()=>{

                    $list.close();
                    //rootGameMaker.forceActiveFocus();
                },
                OnRemoveClicked: (index, item)=>{
                    let dirUrl = GameMakerGlobal.config.strProjectRootPath + item;

                    $dialog.show({
                        Msg: '确认删除 <font color="red">' + item + '</font> ?',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            console.debug('[mainGameMaker]删除：' + dirUrl, Qt.resolvedUrl(dirUrl), $Frame.sl_dirExists(dirUrl), );

                            if(!$Frame.sl_removeRecursively(dirUrl)) {
                                $dialog.show({
                                    Msg: '删除失败',
                                    Buttons: Dialog.Yes,
                                    OnAccepted: function() {
                                        //rootGameMaker.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        //rootGameMaker.forceActiveFocus();
                                    },
                                });
                                return;
                            }

                            $list.removeItem(index);

                            GameMakerGlobal.settings.setValue('Projects/' + item, undefined);
                            _private.changeProject('');

                            //$list.close();
                        },
                        OnRejected: ()=>{
                            //$list.close();
                        },
                    });
                }
            });
        }

        function renameProject() {
            $dialog.show({
                Msg: '输入工程名',
                Input: GameMakerGlobal.config.strCurrentProjectName,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if($Frame.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + $dialog.input)) {
                        $dialog.show({
                            Msg: '工程已存在',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                //rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //rootGameMaker.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    if($Frame.sl_fileRename(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + $dialog.input) > 0) {
                        _private.changeProject($dialog.input, GameMakerGlobal.config.strCurrentProjectName);
                    }
                    else {
                        if($Frame.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + $dialog.input)) {
                            $dialog.show({
                                Msg: '重命名失败，请检查名称',
                                Buttons: Dialog.Yes,
                                OnAccepted: function() {
                                    //rootGameMaker.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    //rootGameMaker.forceActiveFocus();
                                },
                            });
                            return;
                        }
                        console.warn('[!mainGameMaker]重命名失败：', GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + $dialog.input);
                    }

                    //rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    ///rootGameMaker.forceActiveFocus();
                },
            });
        }

        function mapEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainMapEditor.qml');
                //userMainProject.source = 'mainMapEditor.qml';
            }
            else {
                loader.loadModule('mainMapEditor.qml');
                //userMainProject.source = 'mainMapEditor.qml';
            }
        }
        function roleEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainRoleEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
            else {
                loader.loadModule('mainRoleEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
        }
        function spriteEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainSpriteEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
            else {
                loader.loadModule('mainSpriteEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
        }
        function goodsEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainGoodsEditor.qml');
                //userMainProject.source = 'mainGoodsEditor.qml';
            }
            else {
                loader.loadModule('mainGoodsEditor.qml');
                //userMainProject.source = 'mainGoodsEditor.qml';
            }
        }
        function fightRoleEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainFightRoleEditor.qml');
                //userMainProject.source = 'mainFightRoleEditor.qml';
            }
            else {
                loader.loadModule('mainFightRoleEditor.qml');
                //userMainProject.source = 'mainFightRoleEditor.qml';
            }
        }
        function fightSkillEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainFightSkillEditor.qml');
                //userMainProject.source = 'mainFightSkillEditor.qml';
            }
            else {
                loader.loadModule('mainFightSkillEditor.qml');
                //userMainProject.source = 'mainFightSkillEditor.qml';
            }
        }
        function fightScriptEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainFightScriptEditor.qml');
                //userMainProject.source = 'mainFightScriptEditor.qml';
            }
            else {
                loader.loadModule('mainFightScriptEditor.qml');
                //userMainProject.source = 'mainFightScriptEditor.qml';
            }
        }
        function startScriptEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('StartScriptEditor.qml');
                //userMainProject.source = 'StartScriptEditor.qml';
            }
            else {
                loader.loadModule('StartScriptEditor.qml');
                //userMainProject.source = 'StartScriptEditor.qml';
            }
        }
        function commonScriptEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('CommonScriptEditor.qml');
                //userMainProject.source = 'CommonScriptEditor.qml';
            }
            else {
                loader.loadModule('CommonScriptEditor.qml');
                //userMainProject.source = 'CommonScriptEditor.qml';
            }
        }
        function scriptEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule(compScriptEditor, {
                    BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName,
                    //RelativePath: '',
                    //ChoiceButton: 0b11,
                    //PathText: 0b11,
                    RunButton: 0b11,
                });
                //loader.loadModule('ScriptEditor.qml');
                //userMainProject.source = 'ScriptEditor.qml';
            }
            else {
                loader.loadModule(compScriptEditor, {
                    BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName,
                    //RelativePath: '',
                    //ChoiceButton: 0b11,
                    //PathText: 0b11,
                    RunButton: 0b11,
                });
                //loader.loadModule('ScriptEditor.qml');
                //userMainProject.source = 'ScriptEditor.qml';
            }
        }
        function pluginsManage() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainPlugins.qml');
                //userMainProject.source = 'mainPlugins.qml';
            }
            else {
                loader.loadModule('mainPlugins.qml');
                //userMainProject.source = 'mainPlugins.qml';
            }
        }
        function imageEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainImageEditor.qml');
                //userMainProject.source = 'mainImageEditor.qml';
            }
            else {
                loader.loadModule('mainImageEditor.qml');
                //userMainProject.source = 'mainImageEditor.qml';
            }
        }
        function musicEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainMusicEditor.qml');
                //userMainProject.source = 'mainMusicEditor.qml';
            }
            else {
                loader.loadModule('mainMusicEditor.qml');
                //userMainProject.source = 'mainMusicEditor.qml';
            }
        }
        function videoEditor() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainVideoEditor.qml');
                //userMainProject.source = 'mainVideoEditor.qml';
            }
            else {
                loader.loadModule('mainVideoEditor.qml');
                //userMainProject.source = 'mainVideoEditor.qml';
            }
        }
        function compressDir() {
        }
        function uncompressDir() {
        }

        function pluginsManager(type) {
            if($Platform.compileType === 'debug') {
                loader.loadModule('PluginsManager.qml', type);
                //userMainProject.source = 'PluginsManager.qml';
            }
            else {
                loader.loadModule('PluginsManager.qml', type);
                //userMainProject.source = 'PluginsManager.qml';
            }
        }

        /*function pluginsDownload() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('PluginsDownload.qml');
                //userMainProject.source = 'PluginsDownload.qml';
            }
            else {
                loader.loadModule('PluginsDownload.qml');
                //userMainProject.source = 'PluginsDownload.qml';
            }
        }
        */

        function gameStart() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('Core/GameScene.qml');
                //userMainProject.source = 'Core/GameScene.qml';
            }
            else {
                loader.loadModule('Core/GameScene.qml');
                //userMainProject.source = 'Core/GameScene.qml';
            }
        }
        function gameTest() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainGameTest.qml');
                //userMainProject.source = 'mainGameTest.qml';
            }
            else {
                loader.loadModule('mainGameTest.qml');
                //userMainProject.source = 'mainGameTest.qml';
            }
        }
        function gamePackage() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainPackage.qml');
                //userMainProject.source = 'mainPackage.qml';
            }
            else {
                loader.loadModule('mainPackage.qml');
                //userMainProject.source = 'mainPackage.qml';
            }
        }
        function future() {
            $dialog.show({
                Msg: '正在开发中，敬请期待~',
                Buttons: Dialog.Ok,
                OnAccepted: function() {
                    //rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    //rootGameMaker.forceActiveFocus();
                },
            });
        }

        function exportProject() {
            $dialog.show({
                Msg: '正在压缩，请等待',
                Buttons: Dialog.NoButton,
                OnAccepted: function() {
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
                OnRejected: function() {
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
            });

            $showBusyIndicator(true, function() {
                let destPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName;
                let ret = $Frame.sl_compressDir(
                    destPath + '.zip',
                    destPath
                );

                $showBusyIndicator(false);

                $dialog.show({
                    Msg: ret ? ('成功:' + destPath + '.zip') : '失败',
                    Buttons: Dialog.Ok,
                    OnAccepted: function() {
                        //rootGameMaker.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //rootGameMaker.forceActiveFocus();
                    },
                });
            });
        }

        //function downloadDemoProject() {
        function importProject() {
            //const jsLoader = new $CommonLibJS.JSLoader(rootGameMaker, /*(...params)=>Qt.createQmlObject(...params)*/);
            const menuURL = 'http://MakerFrame.Leamus.cn/GameMaker/Projects/menu.js';
            let menuList;
            const menuJS = jsLoader.load(menuURL);
            if(!menuJS) {
                menuList = [];
                //return false;
            }
            else
                menuList = Object.keys(menuJS.infos);
            menuList.unshift('【本地导入】');

            //console.debug(menuJS.infos, Object.keys(menuJS.infos), JSON.stringify(menuJS.infos));

            //$showBusyIndicator(true, function() {
                $list.open({
                    RemoveButtonVisible: false,
                    Data: menuList,
                    OnClicked: (index, item)=>{
                        if(index === 0) {
                            $fileDialog.show({
                                Title: '选择项目包文件',
                                //NameFilters: [ 'zip files (*.zip)', 'All files (*)' ],
                                Folder: $GlobalJS.toURL(GameMakerGlobal.config.strProjectRootPath), //shortcuts.home
                                SelectMultiple: false,
                                SelectExisting: true,
                                SelectFolder: false,
                                //ConvertURL: false,
                                OnAccepted: function(url, urls) {
                                    _private.unzipProjectPackage(url);
                                },
                            });
                            return;
                        }

                        $dialog.show({
                            TextFormat: Label.PlainText,
                            Msg: '名称：%1\r\n版本：%2\r\n日期：%3\r\n作者：%4\r\n大小：%5\r\n描述：%6\r\n确定下载？\r\n注意：由于服务器带宽低，下载人数多时会慢一些。'
                                .arg(menuJS.infos[item]['Name'])
                                .arg(menuJS.infos[item]['Version'])
                                .arg(menuJS.infos[item]['Update'])
                                .arg(menuJS.infos[item]['Author'])
                                .arg(menuJS.infos[item]['Size'])
                                .arg(menuJS.infos[item]['Description'])
                            ,
                            Buttons: Dialog.Yes | Dialog.No,
                            OnAccepted: function() {
                                //rootGameMaker.enabled = false;

                                const fileName = $Frame.sl_fileName(menuJS.infos[item]['Path']);
                                const projectName = $Frame.sl_completeBaseName(menuJS.infos[item]['Path']);
                                const projectPath = GameMakerGlobal.config.strProjectRootPath + projectName;
                                //https://qiniu.leamus.cn/$Leamus.zip
                                //https://gitee.com/leamus/MakerFrame/raw/master/Examples/$Leamus.zip


                                function _continue() {
                                    const ret = unzipFile(GameMakerGlobal.config.strProjectRootPath + fileName, projectPath);
                                    if(ret.length > 0)
                                        _private.changeProject(projectName);
                                }

                                downloadFile(menuJS.infos[item]['Path'], GameMakerGlobal.config.strProjectRootPath + fileName,
                                    function() {/*rootGameMaker.enabled = true;*/ _continue();}, function() {/*rootGameMaker.enabled = true;*/});


                                //$list.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                //$list.forceActiveFocus();
                            },
                        });

                        //$list.close();
                        //rootGameMaker.forceActiveFocus();
                    },
                    OnCanceled: ()=>{
                        //jsLoader.clear();
                        jsLoader.unload(menuURL);

                        $list.close();
                        //rootGameMaker.forceActiveFocus();
                    },
                });
                //$showBusyIndicator(false);
            //});
        }

        function about() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainAbout.qml');
                //userMainProject.source = 'mainAbout.qml';
            }
            else {
                loader.loadModule('mainAbout.qml');
                //userMainProject.source = 'mainAbout.qml';
            }
        }
        function tutorial() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainTutorial.qml');
                //userMainProject.source = 'mainTutorial.qml';
            }
            else {
                loader.loadModule('mainTutorial.qml');
                //userMainProject.source = 'mainTutorial.qml';
            }
        }
        function agreement() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainAgreement.qml');
                //userMainProject.source = 'mainAgreement.qml';
            }
            else {
                loader.loadModule('mainAgreement.qml');
                //userMainProject.source = 'mainAgreement.qml';
            }
        }
        function updateLog() {
            if($Platform.compileType === 'debug') {
                loader.loadModule('mainUpdateLog.qml');
                //userMainProject.source = 'mainUpdateLog.qml';
            }
            else {
                loader.loadModule('mainUpdateLog.qml');
                //userMainProject.source = 'mainUpdateLog.qml';
            }
        }
        function suggest() {
            if($globalData.$userData === undefined) {
                $dialog.show({
                    Msg: '请先登录',
                    Buttons: Dialog.Ok,
                    OnAccepted: function() {
                    },
                    OnRejected: ()=>{
                    },
                });
                return;
            }

            if($Platform.compileType === 'debug') {
                loader.loadModule('mainSuggest.qml');
                //userMainProject.source = 'mainSuggest.qml';
            }
            else {
                loader.loadModule('mainSuggest.qml');
                //userMainProject.source = 'mainSuggest.qml';
            }
        }

        function unzipProjectPackage(fURL) {
            const projectName = $Frame.sl_completeBaseName(fURL);
            const projectPath = GameMakerGlobal.config.strProjectRootPath + projectName;
            const msg = $Frame.sl_dirExists(projectPath) ? '<br><font color="red">注意</font>：目标工程已存在，继续解压会覆盖目标项目中的同名文件！' : '';
            $dialog.show({
                Msg: '确认导入工程吗？' + msg,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    const ret = unzipFile($GlobalJS.toPath(fURL), projectPath);
                    if(ret.length > 0)
                        _private.changeProject(projectName);
                },
                OnRejected: ()=>{
                    //rootGameMaker.forceActiveFocus();
                },
            });
        }


        function downloadFile(url, filePath, successCallback, failCallback) {
            //方法一：
            /*const httpReply = */$CommonLibJS.request({
                Url: url,
                Method: 'GET',
                //Data: {},
                //Gzip: [1, 1024],
                //Headers: {},
                FilePath: filePath,
                //Params: ,
            }, 2).$$then(function(xhr) {
                $dialog.close();

                if(successCallback)
                    successCallback();
            }).$$catch(function(e) {
                //$dialog.close();

                $dialog.show({
                    Msg: '下载失败(%1,%2,%3)'.arg(e.$params.code).arg(e.$params.error).arg(e.$params.status),
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        //rootGameMaker.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //rootGameMaker.forceActiveFocus();
                    },
                });

                if(failCallback)
                    failCallback();
            });

            /*/方法二：
            const httpReply = $Frame.sl_downloadFile(url, filePath);
            httpReply.sg_finished.connect(function(httpReply) {
                const networkReply = httpReply.networkReply;
                const code = $Frame.sl_objectProperty('Code', networkReply);
                console.debug('[mainGameMaker]下载完毕', httpReply, networkReply, code, $Frame.sl_objectProperty('Data', networkReply));

                $Frame.sl_deleteLater(httpReply);


                $dialog.close();

                if(code !== 0) {
                    $dialog.show({
                        Msg: '下载失败：%1'.arg(code),
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            //rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //rootGameMaker.forceActiveFocus();
                        },
                    });
                    return;
                }

                _continue();
            });
            */


            $dialog.show({
                Msg: '正在下载，请等待（请勿进行其他操作）',
                Buttons: Dialog.NoButton,
                OnAccepted: function() {
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
                OnRejected: ()=>{
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
            });
        }

        function unzipFile(filePath, dirPath) {
            $dialog.show({
                Msg: '正在解压，请等待',
                Buttons: Dialog.NoButton,
                OnAccepted: function() {
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
                OnRejected: ()=>{
                    $dialog.show();
                    //$dialog.forceActiveFocus();
                },
            });

            //$Frame.sl_removeRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName);

            //console.debug('[mainGameMaker]path:', filePath, dirPath, $Frame.sl_completeBaseName(filePath))

            if(!$Frame.sl_dirExists(dirPath))
                $Frame.sl_dirCreate(dirPath);
            const ret = $Frame.sl_extractDir(/*$GlobalJS.toPath*/(filePath), dirPath);

            if(ret.length > 0) {
                //_private.changeProject($Frame.sl_completeBaseName(filePath));

                //console.debug('[mainGameMaker]', ret, dirPath);
            }

            $dialog.show({
                Msg: ret.length > 0 ? ('成功:' + dirPath) : '失败',
                Buttons: Dialog.Ok,
                OnAccepted: function() {
                    //rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    //rootGameMaker.forceActiveFocus();
                },
            });

            return ret;
        }



        readonly property QtObject config: QtObject { //配置
            //id: _config

            //字体大小
            property int nButtonTextSize: 12

            property int nMenuItemHeight: 39

        }

        //因为GameVisualScript.js里用到了GameMakerGlobal.qml，而前者先于后者加载导致报错，所以使用了jsLoader延迟加载
        readonly property var jsLoader: new $CommonLibJS.JSLoader(rootGameMaker, /*(...params)=>Qt.createQmlObject(...params)*/)
        property var jsGameVisualScript: null

        property var fnBackupOpenFile: null
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainGameMaker]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainGameMaker]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainGameMaker]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainGameMaker]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainGameMaker]---------------Test------------------');
        console.debug('[mainGameMaker]运行环境:', GameMakerGlobal.config.bDebug);



        _private.jsGameVisualScript = _private.jsLoader.load(Qt.resolvedUrl('GameVisualScript.js'));


        if(GameMakerGlobal.settings.$RunTimes === 0) {
        //if(GameMakerGlobal.settings.value('$RunTimes', 0) === 0) {
            rectHelpWindow.showMsg('<font size=6>初来乍到，请阅读并同意<a href="http://makerframe.leamus.cn/Privacy.html">隐私政策</a>。<br>进入 教程 先来了解一下引擎吧，或者在 导入工程 里下载示例 试玩。</font>');
            //GameMakerGlobal.settings.setValue('$RunTimes', 1);
        }
        else {
            //GameMakerGlobal.settings.setValue('$RunTimes', parseInt(GameMakerGlobal.settings.value('$RunTimes', 0)) + 1);
        }
        ++GameMakerGlobal.settings.$RunTimes;

        //if(GameMakerGlobal.settings.value('$ProjectName'))
        //    GameMakerGlobal.config.strCurrentProjectName = GameMakerGlobal.settings.value('$ProjectName');



        //$Frame.sl_globalObject().$GameMakerGlobal = GameMakerGlobal;



        _private.fnBackupOpenFile = $globalData.$openFile;
        $globalData.$openFile = (url, type)=>{
            //如果是文件夹
            if(/*$CommonLibJS.isArray(url) || */$Frame.sl_isDir($GlobalJS.toPath(url)))
                return false;


            const fileExtName = $Frame.sl_suffix(url).toLowerCase();
            if(fileExtName === 'zip') {
                _private.unzipProjectPackage(url);

                return true;
            }
            else
                return false;
        }

        //$$eval = (()=>(c)=>eval(c))();



        console.debug('[mainGameMaker]Component.onCompleted:', Qt.resolvedUrl('.'));
    }
    Component.onDestruction: {
        //$$eval = null;

        $globalData.$openFile = _private.fnBackupOpenFile;


        //delete $Frame.sl_globalObject().$GameMakerGlobal;


        console.debug('[mainGameMaker]Component.onDestruction:', Qt.resolvedUrl('.'));
    }
}
