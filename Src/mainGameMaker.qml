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


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


import './Core'


//import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: rootGameMaker


    signal sg_close();



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

            //strBasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName
            //strTitle: '脚本编辑'
            /*fnAfterCompile: function(code) {return code;}*/

            //visualScriptEditor.strTitle: strTitle

            visualScriptEditor.strSearchPath: GameMakerGlobal.config.strProjectRootPath + Platform.sl_separator(true) + GameMakerGlobal.config.strCurrentProjectName
            visualScriptEditor.nLoadType: 1

            //visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
            //visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
            visualScriptEditor.defaultCommandsInfo: _private.jsGameVisualScript.data.commandsInfo
            visualScriptEditor.defaultCommandGroupsInfo: _private.jsGameVisualScript.data.groupsInfo
            //visualScriptEditor.defaultCommandTemplate: []


            onSg_close: function(saved) {
                //scriptEditor.visible = false;
                //root.forceActiveFocus();
            }
        }
    }


    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }


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


            font.pointSize: 22
            font.bold: true
            text: qsTr('鹰歌游戏引擎')

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
            font.pointSize: 16
            text: qsTr('当前工程：' + GameMakerGlobal.config.strCurrentProjectName)

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }


        ColumnLayout {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 5
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
                            console.warn(9)
                        }
                        onTriggered: {
                            console.warn(99)
                        }
                    }
                    MenuSeparator { }
                    Action {
                        text: 'Action'
                        onTriggered: {
                            console.warn(999)
                        }
                    }

                    onAboutToHide: {
                        console.warn(6)
                    }
                    onClosed: {
                        console.warn(66)
                    }
                }
            }
            */


            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '工程管理'
                onClicked: menuProjectManage.open();

                Menu {
                    id: menuProjectManage

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '新建工程'
                        height: _config.nMenuItemHeight
                        //focusPolicy: Qt.NoFocus
                        //hoverEnabled: false
                        onClicked: {
                            _private.newProject();
                        }
                    }
                    MenuItem {
                        text: '打开工程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.openProject();
                        }
                    }
                    MenuItem {
                        text: '重命名工程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.renameProject();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '导出工程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            if(!_private.checkCurrentProjectName()) {
                                return;
                            }
                            _private.exportProject();
                        }
                    }
                    MenuItem {
                        text: '导入工程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.importProject();
                        }
                    }
                    MenuItem {
                        text: '下载示例工程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.downloadDemoProject();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '打包项目'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            if(!_private.checkCurrentProjectName()) {
                                return;
                            }
                            _private.gamePackage();
                        }
                    }
                    MenuItem {
                        text: '平台分发'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.future();
                        }
                    }
                    /* 貌似和MenuItem一样
                    Action { text: "Cut" }
                    Action { text: "Copy" }
                    Action { text: "Paste" }
                    */
                }
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '游戏编辑器'
                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuGameEditor.open();
                }

                Menu {
                    id: menuGameEditor

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '地图编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.mapEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '角色编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.roleEditor();
                        }
                    }
                    MenuItem {
                        text: '特效编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.spriteEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '道具编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.goodsEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗技能编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.fightSkillEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗角色编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.fightRoleEditor();
                        }
                    }
                    MenuItem {
                        text: '战斗脚本编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.fightScriptEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '起始脚本编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.startScriptEditor();
                        }
                    }
                    MenuItem {
                        text: '通用脚本编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.commonScriptEditor();
                        }
                    }
                    MenuItem {
                        text: '脚本编辑器'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.scriptEditor();
                        }
                    }
                    MenuSeparator { }
                    MenuItem {
                        text: '测　试'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.gameTest();
                        }
                    }
                }
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '媒体资源管理'
                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuResourceManager.open();
                }

                Menu {
                    id: menuResourceManager

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '图片管理'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.imageEditor();
                        }
                    }
                    MenuItem {
                        text: '音乐管理'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.musicEditor();
                        }
                    }
                    MenuItem {
                        text: '视频管理'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.videoEditor();
                        }
                    }
                    /*MenuItem {
                        text: '压缩文件夹'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.compressDir();
                        }
                    }
                    MenuItem {
                        text: '解压文件夹'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.uncompressDir();
                        }
                    }
                    */
                }
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '插件管理'
                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    menuPluginsManager.open();
                }

                Menu {
                    id: menuPluginsManager

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '插件管理'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.pluginsManager();
                        }
                    }
                    MenuItem {
                        text: '插件下载'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.pluginsDownload();
                        }
                    }
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: `<font color="${Global.style.color(Global.style.Red)}"><b>开始游戏</b></font>`
                onClicked: {
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }
                    _private.gameStart();
                }
            }

            Button {
                //id: buttonProjectManage

                Layout.preferredWidth: parent.width / 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: '文　档'
                onClicked: menuDocuments.open();

                Menu {
                    id: menuDocuments

                    //鹰（BUG）：注意：不知为何，加上这个，安卓手机上菜单就不会偏移了！！！
                    x: parent.width - 103
                    y: Qt.platform.os === 'android' ? -130 : 0

                    MenuItem {
                        text: '教　程'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.tutorial();
                        }
                    }
                    MenuItem {
                        text: '使用协议'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.agreement();
                        }
                    }
                    MenuItem {
                        text: '更新日志'
                        height: _config.nMenuItemHeight
                        onClicked: {
                            _private.updateLog();
                        }
                    }
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
                        if(Platform.compileType === 'debug') {
                            _private.loadModule('mainAbout.qml');
                            //userMainProject.source = 'mainAbout.qml';
                        }
                        else {
                            _private.loadModule('mainAbout.qml');
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

        RowLayout {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            //Layout.preferredHeight: 30
            //Layout.minimumHeight: 20
            //Layout.fillHeight: true

            Label {
                //anchors.left: parent.left
                //anchors.bottom: parent.bottom
                //anchors.leftMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
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
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 12
                text: qsTr('<a href="https://afdian.com/a/Leamus">爱发电</a>')
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter

                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
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



    //工程目录
    L_List {
        id: l_listProjects

        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor



        onSg_canceled: {
            visible = false;
            //loader.visible = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
            //loader.item.focus = true;
        }

        onSg_clicked: {
            if(item === '..') {
                visible = false;
                rootGameMaker.forceActiveFocus();
                return;
            }


            //_private.loadModule('');
            _private.changeProject(item);


            visible = false;
            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
        }

        onSg_removeClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + item;

            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ?',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug('[mainGameMaker]删除：' + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_dirExists(dirUrl), FrameManager.sl_removeRecursively(dirUrl));

                    removeItem(index);

                    GameMakerGlobal.settings.setValue('Projects/' + item, undefined);
                    _private.changeProject('');

                    l_listProjects.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listProjects.forceActiveFocus();
                },
            });
        }
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialogOpenProject

        visible: false

        title: '选择项目包文件'
        //folder: shortcuts.home
        folder: GameMakerGlobal.config.strProjectRootPath
        nameFilters: [ 'zip files (*.zip)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.focus = true;
            //rootGameMaker.forceActiveFocus();

            console.debug('[mainGameMaker]You chose:', fileUrl, fileUrls);

            let fUrl;
            if(Qt.platform.os === 'android')
                fUrl = Platform.sl_getRealPathFromURI(fileUrl.toString());
            else
                fUrl = FrameManager.sl_urlDecode(fileUrl.toString());

            //console.error('!!!', fUrl, fileUrl, FrameManager.sl_absolutePath(fileUrl))

            _private.unzipProjectPackage(fUrl);
        }
        onRejected: {
            console.debug('[mainGameMaker]onRejected');
            //rootGameMaker.forceActiveFocus();


            //sg_close();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    //主窗口加载
    Loader {
        id: loader

        property var vParams: undefined

        visible: false
        focus: true

        anchors.fill: parent


        source: ''
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                //loader.source = '';
                _private.loadModule('');
            }
        }


        onStatusChanged: {
            console.debug('[mainGameMaker]loader:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                setSource('');

                rootWindow.aliasGlobal.showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //rootGameMaker.focus = true;
                rootGameMaker.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
                rootWindow.aliasGlobal.showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                rootWindow.clearComponentCache();
                rootWindow.trimComponentCache();
            }
        }

        onLoaded: {
            console.debug('[mainGameMaker]loader onLoaded:', vParams);

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init(vParams);

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
                rootWindow.aliasGlobal.showBusyIndicator(false);
            }
        }
    }



    //帮助窗口
    Item {
        id: rectHelpWindow


        //显示信息
        function showMsg(msg) {
            //替换一些常用的字符为HTML代码
            textHelpInfo.text = GlobalLibraryJS.convertToHTML(msg);

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
            color: '#90000000'

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
                Layout.maximumHeight: parent.height
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
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.maximumHeight: 50
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



    //配置
    QtObject {
        id: _config

        property int nMenuItemHeight: 39
    }


    QtObject {
        id: _private

        function checkCurrentProjectName() {
            if(GameMakerGlobal.config.strCurrentProjectName.trim().length === 0) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '请先新建或选择一个工程',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        rootGameMaker.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        rootGameMaker.forceActiveFocus();
                    },
                });
                return false;
            }

            return true;
        }

        //载入模块
        function loadModule(module, params) {
            //console.debug('~~~loadModule:', module);


            //if(module.length !== 0 && !checkCurrentProjectName())
            //    return false;


            //loader.visible = true;
            //loader.focus = true;
            //loader.forceActiveFocus();

            loader.vParams = params;
            if(GlobalLibraryJS.isObject(module)) {
                loader.sourceComponent = module;
            }
            else {
                //loader.source = module;
                loader.setSource(module);
            }

            /*if(loader.status === Loader.Ready) {
                if(loader.item.init)
                    loader.item.init();

                console.debug('[mainGameMaker]Loader.Ready');
                //loader.item.forceActiveFocus();
            }*/

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
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '输入工程名',
                Input: '新建工程',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + rootWindow.aliasGlobal.dialogCommon.input)) {
                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: '工程已存在',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                rootGameMaker.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    _private.changeProject(rootWindow.aliasGlobal.dialogCommon.input);

                    let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
                    FrameManager.sl_dirCreate(projectPath);


                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '是否复制素材资源？\r\n（注意：素材资源均来自互联网，仅供测试使用，侵删）',
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            /*rootWindow.aliasGlobal.dialogCommon.show({
                                Msg: '由于服务器带宽低，下载人数多时会导致很慢，建议加群后可以下载更多的示例工程，确定下载吗？',
                                Buttons: Dialog.Yes | Dialog.No,
                                OnAccepted: function() {
                            */


                            let resTemplate = GameMakerGlobal.config.strWorkPath + GameMakerGlobal.separator + '$资源模板.zip';

                            function _continue() {
                                rootWindow.aliasGlobal.dialogCommon.show({
                                    Msg: '正在解压，请等待',
                                    Buttons: Dialog.NoButton,
                                    OnAccepted: function() {
                                        rootWindow.aliasGlobal.dialogCommon.open();
                                        rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        rootWindow.aliasGlobal.dialogCommon.open();
                                        rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                                    },
                                });

                                //FrameManager.sl_dirCreate(projectPath);
                                let ret = FrameManager.sl_extractDir(resTemplate, projectPath);

                                if(ret.length > 0) {
                                    //_private.changeProject('Leamus');

                                    //console.debug(ret, projectPath);
                                }

                                rootWindow.aliasGlobal.dialogCommon.show({
                                    Msg: ret.length > 0 ? ('成功:' + projectPath) : '失败',
                                    Buttons: Dialog.Ok,
                                    OnAccepted: function() {
                                        rootGameMaker.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        rootGameMaker.forceActiveFocus();
                                    },
                                });
                            }

                            //enabled = false;

                            if(!FrameManager.sl_fileExists(resTemplate)) {
                                //https://qiniu.leamus.cn/$资源模板.zip

                                downloadFile('http://MakerFrame.Leamus.cn/GameMaker/$资源模板.zip', resTemplate,
                                    _continue, null);
                            }
                            else
                                _continue();

                            /*
                                },
                                OnRejected: ()=>{
                                    rootGameMaker.forceActiveFocus();
                                },
                            });
                            */

                            rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootGameMaker.forceActiveFocus();
                        },
                    });

                    rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }

        function openProject() {
            l_listProjects.show(GameMakerGlobal.config.strProjectRootPath, [], 0x001 | 0x2000, 0x00);
            l_listProjects.visible = true;
            //l_listProjects.focus = true;
            //l_listProjects.forceActiveFocus();
        }

        function renameProject() {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '输入工程名',
                Input: GameMakerGlobal.config.strCurrentProjectName,
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + rootWindow.aliasGlobal.dialogCommon.input)) {
                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: '工程已存在',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                rootGameMaker.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    if(FrameManager.sl_fileRename(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + rootWindow.aliasGlobal.dialogCommon.input) > 0) {
                        _private.changeProject(rootWindow.aliasGlobal.dialogCommon.input, GameMakerGlobal.config.strCurrentProjectName);
                    }
                    else {
                        if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + rootWindow.aliasGlobal.dialogCommon.input)) {
                            rootWindow.aliasGlobal.dialogCommon.show({
                                Msg: '重命名失败，请检查名称',
                                Buttons: Dialog.Yes,
                                OnAccepted: function() {
                                    rootGameMaker.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    rootGameMaker.forceActiveFocus();
                                },
                            });
                            return;
                        }
                        console.warn('[!mainGameMaker]重命名失败：', GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + rootWindow.aliasGlobal.dialogCommon.input);
                    }

                    rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }

        function mapEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainMapEditor.qml');
                //userMainProject.source = 'mainMapEditor.qml';
            }
            else {
                _private.loadModule('mainMapEditor.qml');
                //userMainProject.source = 'mainMapEditor.qml';
            }
        }
        function roleEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainRoleEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
            else {
                _private.loadModule('mainRoleEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
        }
        function spriteEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainSpriteEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
            else {
                _private.loadModule('mainSpriteEditor.qml');
                //userMainProject.source = 'eventMaker.qml';
            }
        }
        function goodsEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainGoodsEditor.qml');
                //userMainProject.source = 'mainGoodsEditor.qml';
            }
            else {
                _private.loadModule('mainGoodsEditor.qml');
                //userMainProject.source = 'mainGoodsEditor.qml';
            }
        }
        function fightRoleEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainFightRoleEditor.qml');
                //userMainProject.source = 'mainFightRoleEditor.qml';
            }
            else {
                _private.loadModule('mainFightRoleEditor.qml');
                //userMainProject.source = 'mainFightRoleEditor.qml';
            }
        }
        function fightSkillEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainFightSkillEditor.qml');
                //userMainProject.source = 'mainFightSkillEditor.qml';
            }
            else {
                _private.loadModule('mainFightSkillEditor.qml');
                //userMainProject.source = 'mainFightSkillEditor.qml';
            }
        }
        function fightScriptEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainFightScriptEditor.qml');
                //userMainProject.source = 'mainFightScriptEditor.qml';
            }
            else {
                _private.loadModule('mainFightScriptEditor.qml');
                //userMainProject.source = 'mainFightScriptEditor.qml';
            }
        }
        function startScriptEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('StartScriptEditor.qml');
                //userMainProject.source = 'StartScriptEditor.qml';
            }
            else {
                _private.loadModule('StartScriptEditor.qml');
                //userMainProject.source = 'StartScriptEditor.qml';
            }
        }
        function commonScriptEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('CommonScriptEditor.qml');
                //userMainProject.source = 'CommonScriptEditor.qml';
            }
            else {
                _private.loadModule('CommonScriptEditor.qml');
                //userMainProject.source = 'CommonScriptEditor.qml';
            }
        }
        function scriptEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule(compScriptEditor, {
                    BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName,
                    //RelativePath: '',
                    //ChoiceButton: 0b11,
                    //PathText: 0b11,
                    RunButton: 0b11,
                });
                //_private.loadModule('ScriptEditor.qml');
                //userMainProject.source = 'ScriptEditor.qml';
            }
            else {
                _private.loadModule(compScriptEditor, {
                    BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName,
                    //RelativePath: '',
                    //ChoiceButton: 0b11,
                    //PathText: 0b11,
                    RunButton: 0b11,
                });
                //_private.loadModule('ScriptEditor.qml');
                //userMainProject.source = 'ScriptEditor.qml';
            }
        }
        function pluginsManage() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainPlugins.qml');
                //userMainProject.source = 'mainPlugins.qml';
            }
            else {
                _private.loadModule('mainPlugins.qml');
                //userMainProject.source = 'mainPlugins.qml';
            }
        }
        function imageEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainImageEditor.qml');
                //userMainProject.source = 'mainImageEditor.qml';
            }
            else {
                _private.loadModule('mainImageEditor.qml');
                //userMainProject.source = 'mainImageEditor.qml';
            }
        }
        function musicEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainMusicEditor.qml');
                //userMainProject.source = 'mainMusicEditor.qml';
            }
            else {
                _private.loadModule('mainMusicEditor.qml');
                //userMainProject.source = 'mainMusicEditor.qml';
            }
        }
        function videoEditor() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainVideoEditor.qml');
                //userMainProject.source = 'mainVideoEditor.qml';
            }
            else {
                _private.loadModule('mainVideoEditor.qml');
                //userMainProject.source = 'mainVideoEditor.qml';
            }
        }
        function compressDir() {
        }
        function uncompressDir() {
        }

        function pluginsManager() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('PluginsManager.qml');
                //userMainProject.source = 'PluginsManager.qml';
            }
            else {
                _private.loadModule('PluginsManager.qml');
                //userMainProject.source = 'PluginsManager.qml';
            }
        }

        function pluginsDownload() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('PluginsDownload.qml');
                //userMainProject.source = 'PluginsDownload.qml';
            }
            else {
                _private.loadModule('PluginsDownload.qml');
                //userMainProject.source = 'PluginsDownload.qml';
            }
        }

        function gameStart() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('Core/GameScene.qml');
                //userMainProject.source = 'Core/GameScene.qml';
            }
            else {
                _private.loadModule('Core/GameScene.qml');
                //userMainProject.source = 'Core/GameScene.qml';
            }
        }
        function gameTest() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainGameTest.qml');
                //userMainProject.source = 'mainGameTest.qml';
            }
            else {
                _private.loadModule('mainGameTest.qml');
                //userMainProject.source = 'mainGameTest.qml';
            }
        }
        function gamePackage() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainPackage.qml');
                //userMainProject.source = 'mainPackage.qml';
            }
            else {
                _private.loadModule('mainPackage.qml');
                //userMainProject.source = 'mainPackage.qml';
            }
        }
        function future() {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '敬请期待~',
                Buttons: Dialog.Ok,
                OnAccepted: function() {
                    rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }

        function exportProject() {
            if(!_private.checkCurrentProjectName()) {
                return;
            }


            dialogCommon.show({
                Msg: '正在压缩，请等待',
                Buttons: Dialog.NoButton,
                OnAccepted: function() {
                    rootWindow.aliasGlobal.dialogCommon.open();
                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                },
                OnRejected: function() {
                    rootWindow.aliasGlobal.dialogCommon.open();
                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                },
            });

            let destPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
            let ret = FrameManager.sl_compressDir(
                destPath + '.zip',
                destPath
            );

            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: ret ? ('成功:' + destPath + '.zip') : '失败',
                Buttons: Dialog.Ok,
                OnAccepted: function() {
                    rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }
        function importProject() {
            filedialogOpenProject.folder = GameMakerGlobal.config.strProjectRootPath;
            filedialogOpenProject.open();
        }

        function unzipProjectPackage(fUrl) {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '确认解包吗？这会替换目标项目中的同名文件！',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '正在解压，请等待',
                        Buttons: Dialog.NoButton,
                        OnAccepted: function() {
                            rootWindow.aliasGlobal.dialogCommon.open();
                            rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootWindow.aliasGlobal.dialogCommon.open();
                            rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                        },
                    });

                    //FrameManager.sl_removeRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName);

                    let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + FrameManager.sl_completeBaseName(fUrl);
                    //console.debug('[mainGameMaker]path:', fUrl, projectPath, FrameManager.sl_completeBaseName(fUrl))

                    FrameManager.sl_dirCreate(projectPath);
                    let ret = FrameManager.sl_extractDir(GlobalJS.toPath(fUrl), projectPath);

                    if(ret.length > 0) {
                        _private.changeProject(FrameManager.sl_completeBaseName(fUrl));

                        //console.debug('[mainGameMaker]', ret, projectPath);
                    }

                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: ret.length > 0 ? ('成功:' + projectPath) : '失败',
                        Buttons: Dialog.Ok,
                        OnAccepted: function() {
                            rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootGameMaker.forceActiveFocus();
                        },
                    });
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }

        function downloadDemoProject() {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '由于服务器带宽低，下载人数多时会导致很慢，建议加群后可以下载更多的示例工程，确定下载吗？',
                Buttons: Dialog.Yes | Dialog.No,
                OnAccepted: function() {

                    enabled = false;

                    let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + '$Leamus';

                    //https://qiniu.leamus.cn/$Leamus.zip
                    //https://gitee.com/leamus/MakerFrame/raw/master/Examples/$Leamus.zip

                    function _continue() {
                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: '正在解压，请等待',
                            Buttons: Dialog.NoButton,
                            OnAccepted: function() {
                                rootWindow.aliasGlobal.dialogCommon.open();
                                rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                rootWindow.aliasGlobal.dialogCommon.open();
                                rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                            },
                        });

                        FrameManager.sl_dirCreate(projectPath);
                        let ret = FrameManager.sl_extractDir(projectPath + '.zip', projectPath);

                        if(ret.length > 0) {
                            _private.changeProject('$Leamus');

                            //console.debug(ret, projectPath);
                        }

                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: ret.length > 0 ? ('成功:' + projectPath) : '失败',
                            Buttons: Dialog.Ok,
                            OnAccepted: function() {
                                rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                rootGameMaker.forceActiveFocus();
                            },
                        });
                    }

                    downloadFile('http://MakerFrame.Leamus.cn/GameMaker/Projects/$Leamus.zip', projectPath + '.zip',
                        function() {enabled = true; _continue();}, function() {enabled = true;});


                    rootGameMaker.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootGameMaker.forceActiveFocus();
                },
            });
        }

        function downloadFile(url, filePath, successCallback, failCallback) {
            //方法一：
            /*const httpReply = */GlobalLibraryJS.request({
                Url: url,
                Method: 'GET',
                //Data: {},
                //Gzip: [1, 1024],
                //Headers: {},
                FilePath: filePath,
                //Params: ,
            }, 2).$then(function(xhr) {
                rootWindow.aliasGlobal.dialogCommon.close();

                if(successCallback)
                    successCallback();
            }).$catch(function(e) {
                //rootWindow.aliasGlobal.dialogCommon.close();

                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '下载失败(%1,%2,%3)'.arg(e.$params.code).arg(e.$params.error).arg(e.$params.status),
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        rootGameMaker.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        rootGameMaker.forceActiveFocus();
                    },
                });

                if(failCallback)
                    failCallback();
            });

            /*/方法二：
            const httpReply = FrameManager.sl_downloadFile('http://MakerFrame.Leamus.cn/GameMaker/$资源模板.zip', resTemplate);
            httpReply.sg_finished.connect(function(httpReply) {
                const networkReply = httpReply.networkReply;
                const code = FrameManager.sl_objectProperty('Code', networkReply);
                console.debug('[mainGameMaker]下载完毕', httpReply, networkReply, code, FrameManager.sl_objectProperty('Data', networkReply));

                FrameManager.sl_deleteLater(httpReply);


                rootWindow.aliasGlobal.dialogCommon.close();

                if(code !== 0) {
                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '下载失败：%1'.arg(code),
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootGameMaker.forceActiveFocus();
                        },
                    });
                    return;
                }

                _continue();
            });
            */


            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '正在下载，请等待（请勿进行其他操作）',
                Buttons: Dialog.NoButton,
                OnAccepted: function() {
                    rootWindow.aliasGlobal.dialogCommon.open();
                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                },
                OnRejected: ()=>{
                    rootWindow.aliasGlobal.dialogCommon.open();
                    rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                },
            });
        }

        function tutorial() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainTutorial.qml');
                //userMainProject.source = 'mainTutorial.qml';
            }
            else {
                _private.loadModule('mainTutorial.qml');
                //userMainProject.source = 'mainTutorial.qml';
            }
        }
        function agreement() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainAgreement.qml');
                //userMainProject.source = 'mainAgreement.qml';
            }
            else {
                _private.loadModule('mainAgreement.qml');
                //userMainProject.source = 'mainAgreement.qml';
            }
        }
        function updateLog() {
            if(Platform.compileType === 'debug') {
                _private.loadModule('mainUpdateLog.qml');
                //userMainProject.source = 'mainUpdateLog.qml';
            }
            else {
                _private.loadModule('mainUpdateLog.qml');
                //userMainProject.source = 'mainUpdateLog.qml';
            }
        }


        //因为GameVisualScript.js里用到了GameMakerGlobal.qml，而前者先于后者加载导致报错，所以使用了jsEngine延迟加载
        readonly property var jsEngine: new GlobalJS.JSEngine(rootGameMaker)
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



        _private.jsGameVisualScript = _private.jsEngine.load(Qt.resolvedUrl('GameVisualScript.js'));


        if(GameMakerGlobal.settings.$RunTimes === 0) {
        //if(GameMakerGlobal.settings.value('$RunTimes', 0) === 0) {
            rectHelpWindow.showMsg('<font size=6>  初来乍到？先进入 教程 来了解一下引擎吧，或者下载 示例工程 试玩，还可以加群下载各种资源和工程。</font>');
            //GameMakerGlobal.settings.setValue('$RunTimes', 1);
        }
        else {
            //GameMakerGlobal.settings.setValue('$RunTimes', parseInt(GameMakerGlobal.settings.value('$RunTimes', 0)) + 1);
        }
        ++GameMakerGlobal.settings.$RunTimes;

        //if(GameMakerGlobal.settings.value('$ProjectName'))
        //    GameMakerGlobal.config.strCurrentProjectName = GameMakerGlobal.settings.value('$ProjectName');



        //FrameManager.sl_globalObject().GameMakerGlobal = GameMakerGlobal;



        _private.fnBackupOpenFile = rootWindow.fnOpenFile;
        rootWindow.fnOpenFile = (url, type)=>{
            //如果是文件夹
            if(FrameManager.sl_isDir(GlobalJS.toPath(url))) {
                return false;
            }


            const fileExtName = FrameManager.sl_completeSuffix(url).toLowerCase();
            if(fileExtName === 'zip') {
                _private.unzipProjectPackage(url);

                return true;
            }
            else
                return false;
        }



        //let d = console.debug;
        //console.debug = 123;
        //d('!!!!!!!!!!!', d, console.debug, d === console.debug);

        console.debug('[mainGameMaker]Component.onCompleted:', Qt.resolvedUrl('.'));
    }
    Component.onDestruction: {
        rootWindow.fnOpenFile = _private.fnBackupOpenFile;


        //delete FrameManager.sl_globalObject().GameMakerGlobal;


        console.debug('[mainGameMaker]Component.onDestruction:', Qt.resolvedUrl('.'));
    }
}
