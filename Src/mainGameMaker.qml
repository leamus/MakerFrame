import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


//import "File.js" as File



Rectangle {
    id: rootGameMaker


    signal s_close();

    readonly property var showMsg: rectHelpWindow.showMsg


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.9
        width: parent.width * 0.9
        anchors.centerIn: parent

        spacing: 10


        Text {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 22
            font.bold: true
            text: qsTr("鹰歌 RPG Maker 引擎")

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }


        Text {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //height: 50
            //width: parent.width
            font.pointSize: 16
            text: qsTr("当前工程：" + GameMakerGlobal.config.strCurrentProjectName)

            //horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignVCenter
        }


        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "新建工程"
                onButtonClicked: {
                    dialogCommon.msg = "输入工程名";
                    dialogCommon.input = '新建工程';
                    textinputDialogCommonInput.visible = true;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        GameMakerGlobal.config.strCurrentProjectName = dialogCommon.input;

                        let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
                        FrameManager.sl_qml_CreateFolder(projectPath);

                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.open();
                }
            }


            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打开工程"
                onButtonClicked: {
                    l_listProjects.show(GameMakerGlobal.config.strProjectRootPath, "*", 0x001 | 0x2000, 0x00);
                    l_listProjects.visible = true;
                    //l_listProjects.focus = true;
                    l_listProjects.forceActiveFocus();
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "重命名工程"
                onButtonClicked: {
                    dialogCommon.msg = "输入工程名";
                    textinputDialogCommonInput.visible = true;
                    dialogCommon.input = GameMakerGlobal.config.strCurrentProjectName;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        if(FrameManager.sl_qml_RenameFolder(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input)) {
                            GameMakerGlobal.config.strCurrentProjectName = dialogCommon.input;
                        }
                        else {
                            console.warn("重命名失败：", dialogCommon.input, GameMakerGlobal.config.strCurrentProjectName)
                        }

                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.open();
                }
            }
        }



        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            text: "地图编辑器"
            onButtonClicked: {
                if(Platform.compileType() === "debug") {
                    if(Qt.platform.os === "windows")
                        _private.loadModule("mainMapEditor.qml");
                    else if(Qt.platform.os === "android")
                        _private.loadModule("mainMapEditor.qml");
                    //userMainProject.source = "mainMapEditor.qml";
                }
                else {
                    _private.loadModule("mainMapEditor.qml");
                    //userMainProject.source = "mainMapEditor.qml";
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "角色编辑器"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainRoleEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainRoleEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                    else {
                        _private.loadModule("mainRoleEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                }
            }


            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "特效编辑器"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainSpriteEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainSpriteEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                    else {
                        _private.loadModule("mainSpriteEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                }
            }


            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "道具编辑器"
                onButtonClicked: {
                    /*textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };

                    dialogCommon.msg = "敬请期待~";
                    dialogCommon.open();
                    return;
                    */

                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGoodsEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGoodsEditor.qml");
                        //userMainProject.source = "mainGoodsEditor.qml";
                    }
                    else {
                        _private.loadModule("mainGoodsEditor.qml");
                        //userMainProject.source = "mainGoodsEditor.qml";
                    }
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗角色编辑器"
                font.pointSize: 14

                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainFightRoleEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainFightRoleEditor.qml");
                        //userMainProject.source = "mainFightRoleEditor.qml";
                    }
                    else {
                        _private.loadModule("mainFightRoleEditor.qml");
                        //userMainProject.source = "mainFightRoleEditor.qml";
                    }
                }
            }


            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗技能编辑器"
                font.pointSize: 14

                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainFightSkillEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainFightSkillEditor.qml");
                        //userMainProject.source = "mainFightSkillEditor.qml";
                    }
                    else {
                        _private.loadModule("mainFightSkillEditor.qml");
                        //userMainProject.source = "mainFightSkillEditor.qml";
                    }
                }
            }


            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗脚本编辑器"
                font.pointSize: 14

                onButtonClicked: {
                    /*textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };

                    dialogCommon.msg = "敬请期待~";
                    dialogCommon.open();
                    return;
                    */

                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainFightScriptEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainFightScriptEditor.qml");
                        //userMainProject.source = "mainFightScriptEditor.qml";
                    }
                    else {
                        _private.loadModule("mainFightScriptEditor.qml");
                        //userMainProject.source = "mainFightScriptEditor.qml";
                    }
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.preferredHeight: 50
                Layout.fillHeight: true

                text: "系统通用脚本"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("GameCommonScript.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("GameCommonScript.qml");
                        //userMainProject.source = "GameCommonScript.qml";
                    }
                    else {
                        _private.loadModule("GameCommonScript.qml");
                        //userMainProject.source = "GameCommonScript.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "脚本编辑器"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("GameScriptEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("GameScriptEditor.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
                    else {
                        _private.loadModule("GameScriptEditor.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "插件库"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainPlugins.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainPlugins.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
                    else {
                        _private.loadModule("mainPlugins.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "图片管理"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainImageEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainImageEditor.qml");
                        //userMainProject.source = "mainImageEditor.qml";
                    }
                    else {
                        _private.loadModule("mainImageEditor.qml");
                        //userMainProject.source = "mainImageEditor.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "音乐管理"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainMusicEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainMusicEditor.qml");
                        //userMainProject.source = "mainMusicEditor.qml";
                    }
                    else {
                        _private.loadModule("mainMusicEditor.qml");
                        //userMainProject.source = "mainMusicEditor.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "视频管理"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainVideoEditor.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainVideoEditor.qml");
                        //userMainProject.source = "mainVideoEditor.qml";
                    }
                    else {
                        _private.loadModule("mainVideoEditor.qml");
                        //userMainProject.source = "mainVideoEditor.qml";
                    }
                }
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            text: "开始游戏"
            onButtonClicked: {
                if(Platform.compileType() === "debug") {
                    if(Qt.platform.os === "windows")
                        _private.loadModule("GameStart.qml");
                    else if(Qt.platform.os === "android")
                        _private.loadModule("GameStart.qml");
                    //userMainProject.source = "GameStart.qml";
                }
                else {
                    _private.loadModule("GameStart.qml");
                    //userMainProject.source = "GameStart.qml";
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "测试"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameTest.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameTest.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                    else {
                        _private.loadModule("mainGameTest.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打包项目"
                onButtonClicked: {
                    if(Qt.platform.os === "android") {

                        let path = Platform.getExternalDataPath() + GameMakerGlobal.separator + "MakerFrame" + GameMakerGlobal.separator + "RPGMaker" + GameMakerGlobal.separator + "RPGGame";

                        let jsFiles = FrameManager.sl_qml_listDir(path, '*', 0x002 | 0x2000 | 0x4000, 0);
                        jsFiles.sort();
                        let missingFiles = '';
                        if(!jsFiles[0] || jsFiles[0].indexOf('MakerFramePackage') < 0)
                            missingFiles += 'MakerFramePackage_xxx.zip ';
                        if(!jsFiles[1] || jsFiles[1].indexOf('RPGRuntime') < 0)
                            missingFiles += 'RPGRuntime_xxx.zip ';

                        if(missingFiles !== '') {
                            dialogCommon.show({
                                Msg: '请将 %1文件下载并放入%2文件夹下'.arg(missingFiles).arg(path),
                                Buttons: Dialog.Yes,
                                OnAccepted: function(){
                                    rootGameMaker.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    rootGameMaker.forceActiveFocus();
                                },
                            });
                            return;
                        }


                        let outputDir = path + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;

                        dialogCommon.show({
                            Msg: '打包会删除原来打包的目录 %1，确定吗？'.arg(outputDir),
                            Buttons: Dialog.Yes | Dialog.No,
                            OnAccepted: function(){

                                dialogCommon.close();

                                dialogCommon.show({
                                    Msg: '请等待。。。',
                                    Buttons: Dialog.NoButton,
                                    OnRejected: ()=>{
                                        dialogCommon.open();
                                        rootGameMaker.forceActiveFocus();
                                    },
                                });


                                GlobalLibraryJS.setTimeout(function() {
                                    FrameManager.sl_qml_RemoveRecursively(outputDir);

                                    let ret = FrameManager.sl_qml_ExtractDir(path + GameMakerGlobal.separator + jsFiles[0], outputDir);
                                    ret = FrameManager.sl_qml_ExtractDir(path + GameMakerGlobal.separator + jsFiles[1], outputDir);
                                    ret = FrameManager.sl_qml_CopyFolder(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, outputDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project', true);


                                    dialogCommon.close();

                                    dialogCommon.show({
                                        Msg: '成功，请用 APKtool 打包 %1'.arg(outputDir),
                                        Buttons: Dialog.Yes,
                                        OnAccepted: function(){
                                            rootGameMaker.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            rootGameMaker.forceActiveFocus();
                                        },
                                    });

                                },1,rootGameMaker);


                                rootGameMaker.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                rootGameMaker.forceActiveFocus();
                            },
                        });
                        return;
                    }

                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };

                    dialogCommon.msg = "敬请期待~";
                    dialogCommon.open();
                    return;

                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameMakeProgram.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameMakeProgram.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                    else {
                        _private.loadModule("mainGameMakeProgram.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "平台分发"
                onButtonClicked: {

                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };

                    dialogCommon.msg = "敬请期待~";
                    dialogCommon.open();
                    return;

                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameDistribute.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameDistribute.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                    else {
                        _private.loadModule("mainGameDistribute.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "导出工程"
                onButtonClicked: {
                    let ret = FrameManager.sl_qml_CompressDir(
                                GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + ".zip",
                                GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName
                                                  );

                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };

                    if(ret)
                        dialogCommon.msg = "成功：" + GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + ".zip";
                    else
                        dialogCommon.msg = "失败";
                    dialogCommon.open();
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "导入工程"
                onButtonClicked: {
                    filedialogOpenProject.open();
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "示例工程"
                onButtonClicked: {
                    dialogCommon.show({
                        Msg: '由于服务器带宽低，下载人数多时会导致很慢，建议加群后可以下载更多的示例工程，确定下载吗？',
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function(){

                            enabled = false;

                            let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + "Leamus";

                            //let nr = FrameManager.sl_qml_DownloadFile("https://gitee.com/leamus/MakerFrame/raw/master/Examples/Project.zip", projectPath + ".zip");
                            let nr = FrameManager.sl_qml_DownloadFile("http://MakerFrame.Leamus.cn/RPGMaker/Projects/Project.zip", projectPath + ".zip");
                            nr.finished.connect(function() {
                                //FrameManager.sl_qml_Property("属性", nr);  //TimeStamp、Data、SaveType、Code
                                console.debug("下载完毕", nr, FrameManager.sl_qml_Property("Data", nr), FrameManager.sl_qml_Property("Code", nr));

                                FrameManager.sl_qml_DeleteLater(nr);


                                dialogCommon.close();

                                if(FrameManager.sl_qml_Property("Code", nr) < 0) {
                                    dialogCommon.show({
                                        Msg: '下载失败：%1'.arg(FrameManager.sl_qml_Property("Code", nr)),
                                        Buttons: Dialog.Yes,
                                        OnAccepted: function(){
                                            rootGameMaker.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            rootGameMaker.forceActiveFocus();
                                        },
                                    });
                                    return;
                                }


                                //let projectPath = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"

                                FrameManager.sl_qml_CreateFolder(projectPath);
                                let ret = FrameManager.sl_qml_ExtractDir(projectPath + ".zip", projectPath);

                                if(ret.length > 0) {
                                    GameMakerGlobal.config.strCurrentProjectName = "Leamus";
                                    //console.debug(ret, projectPath, fileUrl, FrameManager.sl_qml_AbsolutePath(fileUrl));
                                    dialogCommon.msg = "成功";
                                }
                                else
                                    dialogCommon.msg = "失败";

                                textinputDialogCommonInput.visible = false;
                                dialogCommon.standardButtons = Dialog.Ok;
                                dialogCommon.fOnAccepted = ()=>{
                                    rootGameMaker.forceActiveFocus();
                                };
                                dialogCommon.fOnRejected = ()=>{
                                    rootGameMaker.forceActiveFocus();
                                };
                                dialogCommon.open();

                                enabled = true;
                            });


                            textinputDialogCommonInput.visible = false;
                            dialogCommon.msg = "正在下载工程，请等待（请勿进行其他操作）";
                            dialogCommon.standardButtons = Dialog.NoButton;
                            dialogCommon.fOnAccepted = ()=>{
                                dialogCommon.open();
                            };
                            dialogCommon.fOnRejected = ()=>{
                                dialogCommon.open();
                            };
                            dialogCommon.open();



                            rootGameMaker.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            rootGameMaker.forceActiveFocus();
                        },
                    });

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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "简易教程"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameTutorial.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameTutorial.qml");
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
                    else {
                        _private.loadModule("mainGameTutorial.qml");
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "关于"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameAbout.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameAbout.qml");
                        //userMainProject.source = "mainGameAbout.qml";
                    }
                    else {
                        _private.loadModule("mainGameAbout.qml");
                        //userMainProject.source = "mainGameAbout.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "使用协议"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameAgreement.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameAgreement.qml");
                        //userMainProject.source = "mainGameAgreement.qml";
                    }
                    else {
                        _private.loadModule("mainGameAgreement.qml");
                        //userMainProject.source = "mainGameAgreement.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "更新日志"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("mainGameUpdateLog.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("mainGameUpdateLog.qml");
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
                    else {
                        _private.loadModule("mainGameUpdateLog.qml");
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
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

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true


                text: "简易画板"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("PaintView.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("PaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                    else {
                        _private.loadModule("PaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                }
            }

            ColorButton {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true


                text: "简易画板2"
                onButtonClicked: {
                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("NanoPaintView.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("NanoPaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                    else {
                        _private.loadModule("NanoPaintView.qml");
                        //userMainProject.source = "mainMapEditor.qml";
                    }
                }
            }
        }



        RowLayout {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            //Layout.fillHeight: true

            Text {
                //anchors.left: parent.left
                //anchors.bottom: parent.bottom
                //anchors.leftMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                //width: parent.width
                font.pointSize: 16
                text: qsTr("Q群：654876441")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }

            Text {
                //anchors.right: parent.right
                //anchors.bottom: parent.bottom
                //anchors.rightMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                //width: parent.width
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 16
                text: qsTr("<a href='https://afdian.net/a/Leamus'>爱发电</a>")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }

            Text {
                //anchors.right: parent.right
                //anchors.bottom: parent.bottom
                //anchors.rightMargin: 20
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //height: 50
                //width: parent.width
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 16
                text: qsTr("Ver：" + GameMakerGlobal.version)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent

                    onDoubleClicked: {
                        let n = Math.random();
                        if(n < 0.25)
                            Qt.openUrlExternally('https://play.tudou.com/v_show/id_XMjYxMDEyNzk5Mg==');
                        else if(n < 0.5)
                            Qt.openUrlExternally('https://play.tudou.com/v_show/id_XMjYxMDEyNzk5Mg==');
                        else if(n < 0.75)
                            Qt.openUrlExternally('https://play.tudou.com/v_show/id_XMjYxMDEyNzk5Mg==');
                        else if(n < 1)
                            Qt.openUrlExternally('https://play.tudou.com/v_show/id_XMjYxMDEyNzk5Mg==');
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


        onCanceled: {
            //loader.visible = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
            //loader.item.focus = true;
            visible = false;
        }

        onClicked: {
            if(item === "..") {
                visible = false;
                return;
            }

            _private.loadModule("");
            GameMakerGlobal.config.strCurrentProjectName = item;
            //GameMakerGlobal.settings.setValue('ProjectName', item);


            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
            visible = false;

        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + item;

            dialogCommon.msg = "确认删除?";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainGameMaker]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
                _private.loadModule("");

                l_listProjects.forceActiveFocus();
            };
            dialogCommon.fOnRejected = ()=>{
                l_listProjects.forceActiveFocus();
            };
            dialogCommon.open();
        }
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialogOpenProject
        visible: false

        title: "选择项目包文件"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "zip files (*.zip)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        onAccepted: {
            //rootGameMaker.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.forceActiveFocus();

            console.debug("[mainGameMaker]You chose: " + fileUrl, fileUrls);


            dialogCommon.msg = "确认解包吗？这会替换目标项目中的同名文件！";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                let fUrl;
                if(Qt.platform.os === "android")
                    fUrl = Platform.getRealPathFromURI(fileUrl.toString());
                else
                    fUrl = FrameManager.sl_qml_UrlDecode(fileUrl.toString());

                //console.error("!!!", fUrl, fileUrl)

                //FrameManager.sl_qml_RemoveRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName);

                let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + FrameManager.sl_qml_BaseName(fUrl);
                //let projectPath = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"

                FrameManager.sl_qml_CreateFolder(projectPath);
                let ret = FrameManager.sl_qml_ExtractDir(Global.toPath(fUrl), projectPath);


                if(ret.length > 0) {
                    GameMakerGlobal.config.strCurrentProjectName = FrameManager.sl_qml_BaseName(fUrl);
                    //console.debug(ret, projectPath, fileUrl, FrameManager.sl_qml_AbsolutePath(fileUrl));
                    dialogCommon.msg = "成功";
                }
                else
                    dialogCommon.msg = "失败";

                textinputDialogCommonInput.visible = false;
                dialogCommon.standardButtons = Dialog.Ok;

                dialogCommon.fOnAccepted = ()=>{
                    rootGameMaker.forceActiveFocus();
                };
                dialogCommon.fOnRejected = ()=>{
                    rootGameMaker.forceActiveFocus();
                };
                dialogCommon.open();
            };

            dialogCommon.fOnRejected = ()=>{
                rootGameMaker.forceActiveFocus();
            };
            dialogCommon.open();

        }
        onRejected: {
            //rootGameMaker.forceActiveFocus();


            //s_close();
            console.debug("[mainGameMaker]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    //主窗口加载
    Loader {
        id: loader

        anchors.fill: parent

        visible: false
        focus: true


        source: ""
        asynchronous: false


        onLoaded: {
            if(loader.item.init)
                loader.item.init();
            //item.testFresh();
            console.debug("[mainGameMaker]loader onLoaded");
        }

        Connections {
            target: loader.item

            ignoreUnknownSignals: true


            function onS_close() {
                loader.source = '';
                loader.visible = false;
                //rootGameMaker.focus = true;
                rootGameMaker.forceActiveFocus();


                FrameManager.sl_qml_clearComponentCache();
                //FrameManager.sl_qml_trimComponentCache();

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

        //color: "black"

        Keys.onEscapePressed: {
            close();

            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            event.accepted = true;
            //Qt.quit();
        }



        Mask {
            anchors.fill: parent
            color: "#90000000"

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


                    textArea.background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 40
                        color: 'black'
                        border.color: textHelpInfo.textArea.enabled ? "#21be2b" : "transparent"
                    }
                    textArea.color: 'white'
                    textArea.readOnly: true
                    textArea.selectByMouse: false

                    textArea.text: ''
                    textArea.placeholderText: ""
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

                ColorButton {
                    text: '关闭'
                    onButtonClicked: {
                        rectHelpWindow.close();
                    }
                }
            }

        }
    }



    //错误提示 按钮
    Rectangle {
        id: rectDebugButton

        property int nCount: 0

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 60
        height: 36


        radius: 10
        color: '#10000000'



        Text {
            id: textDebugButton
            anchors.fill: parent
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width

            color: 'red'
            font.pointSize: 16
            font.bold: true
            text: rectDebugButton.nCount === 0 ? '' : rectDebugButton.nCount

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                rectDebugButton.nCount = 0;
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
            }
        }
    }

    //错误提示 界面
    Rectangle {
        id: rectDebugWindow


        function close() {
            rectDebugWindow.visible = false;
            //loader.focus = true;
            loader.forceActiveFocus();
        }


        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9
        visible: false

        color: "black"

        Keys.onEscapePressed: {
            close();

            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            close();

            event.accepted = true;
            //Qt.quit();
        }


        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Notepad {
                    id: textDebugInfo

                    Layout.fillWidth: true
                    Layout.preferredWidth: 1

                    //Layout.preferredHeight: parent.height
                    //Layout.maximumHeight: parent.height
                    //Layout.minimumHeight: 50
                    Layout.fillHeight: true

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                    textArea.background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 40
                        color: 'black'
                        border.color: textDebugInfo.textArea.enabled ? "#21be2b" : "transparent"
                    }
                    textArea.color: 'white'
                    //textArea.readOnly: true
                    textArea.selectByMouse: false


                    textArea.text: ''
                    textArea.placeholderText: ""
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

                ColorButton {
                    text: '复制'
                    onButtonClicked: {
                        FrameManager.sl_qml_SetClipboardText(FrameManager.toPlainText(textDebugInfo.textDocument));
                    }
                }

                ColorButton {
                    text: '清空'
                    onButtonClicked: {
                        textDebugInfo.text = '';
                    }
                }

                ColorButton {
                    text: '关闭'
                    onButtonClicked: {
                        rectDebugWindow.close();
                    }
                }
            }

        }
    }



    QtObject {
        id: _private

        //载入模块
        function loadModule(modulePath) {
            loader.visible = true;
            //loader.focus = true;
            loader.forceActiveFocus();

            loader.setSource(modulePath);

            /*if(loader.status === Loader.Ready) {
                if(loader.item.init)
                    loader.item.init();

                console.debug("Loader.Ready");
                //loader.item.forceActiveFocus();
            }*/

        }


        //显示调试窗口
        function showDebugWindow(msgType, msg) {

            //消息类型
            switch(msgType) {
                //跳过一部分 无关紧要 的 警告
            case FrameManagerClass.QtWarningMsg:
                if(msg.indexOf('QML Connections: Implicitly defined onFoo properties in Connections are deprecated. Use this syntax instead: function onFoo(<arguments>) { ... }') >= 0)
                    break;
                if(msg.indexOf('Retrying to obtain clipboard.') >= 0)
                    break;
                if(msg.indexOf('libpng warning: iCCP: known incorrect sRGB profile') >= 0)
                    break;
                if(msg.indexOf('Model size of ') >= 0)
                    break;
                if(msg.indexOf('Context2D: The font families specified are invalid') >= 0)
                    break;
                if(msg.indexOf('inputMethodQuery(Qt::InputMethodQuery,QVariant)') >= 0)
                    break;
                if(msg.indexOf('QUnifiedTimer::stopAnimationDriver: driver is not running') >= 0)
                    break;
                if(msg.indexOf('QObject: Cannot create children for a parent that is in a different thread.') >= 0)
                    break;
                //if(msg.indexOf('Binding loop detected for property') >= 0)
                //    break;
                if(msg.indexOf('doRender: Unknown error 0x80040266') >= 0)
                    break;
                if(msg.indexOf('TouchPointPressed without previous release event QQuickEventPoint(accepted:false state:Pressed scenePos:') >= 0)
                    break;
                if(msg.indexOf('Accessible must be attached to an Item') >= 0)
                    break;
                if(msg.indexOf('Unhandled key code') >= 0)
                    break;
                if(msg.indexOf('QEGLPlatformContext: eglSwapBuffers failed:') >= 0)
                    break;
                if(msg.indexOf('doRender: Unknown error') >= 0)
                    break;
                //Unable to obtain clipboard；Retrying to obtain clipboard；
                if(msg.indexOf('to obtain clipboard') >= 0)
                    break;
                if(msg.indexOf('OleSetClipboard: Failed to set mime data (text/plain) on clipboard: COM error') >= 0)
                    break;
                if(msg.indexOf('libpng warning: tRNS: invalid with alpha channel') >= 0)
                    break;
                if(msg.indexOf('DirectShowPlayerService::doSetUrlSource: Unresolved error code') >= 0)
                    break;
                if(msg.indexOf('depends on non-NOTIFYable properties') >= 0)
                    break;

                textDebugInfo.text += ("<font color='yellow'>【Warning】" + msg + "</font><BR>");

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtCriticalMsg:
                textDebugInfo.text += ("<font color='red'>【Critical】" + msg + "</font><BR>");

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtFatalMsg:
                textDebugInfo.text += ("<font color='red'>【Fatal】" + msg + "</font><BR>");

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;

            case FrameManagerClass.QtInfoMsg:
                textDebugInfo.text += ("<font color='white'>【Info】" + msg + "</font><BR>");

                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtDebugMsg:
                if(Platform.compileType() === "debug") {
                }
                break;

            default:
                textDebugInfo.text += (msgType + msg);

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;
            }
        }
    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainGameMaker]Escape Key");
        event.accepted = false;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGameMaker]Back Key");
        event.accepted = false;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameMaker]Keys.onPressed:", event.key)
    }
    Keys.onReleased: {
        console.debug("[mainGameMaker]Keys.onReleased:", event.key)
    }



    Component.onCompleted: {

        rootWindow.s_MessageHandler.connect(_private.showDebugWindow);


        if(!GameMakerGlobal.settings.value('RunTimes')) {
            rectHelpWindow.showMsg('<font size=6>  初来乍到？先看看 简易教程 或 关于 来了解一下引擎吧，或者加群获取各种 示例工程 玩玩</font>');
            GameMakerGlobal.settings.setValue('RunTimes', 1);
        }
        else
            GameMakerGlobal.settings.setValue('RunTimes', parseInt(GameMakerGlobal.settings.value('RunTimes')) + 1);
        //if(GameMakerGlobal.settings.value('ProjectName'))
        //    GameMakerGlobal.config.strCurrentProjectName = GameMakerGlobal.settings.value('ProjectName');



        FrameManager.globalObject().GameMakerGlobal = GameMakerGlobal;



        console.debug("[mainGameMaker]Component.onCompleted");
        //let d = console.debug;
        //console.debug = 123;
        //d("!!!!!!!!!!!", d, console.debug, d === console.debug);
    }

    Component.onDestruction: {
        rootWindow.s_MessageHandler.disconnect(_private.showDebugWindow);
        console.debug("[mainGameMaker]Component.onDestruction");
    }
}
