import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
//import Qt.labs.platform 1.1


import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



Item {
    id: rootGameMaker


    signal s_close();



    readonly property var showMsg: rectHelpWindow.showMsg


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
        height: parent.height * 0.9
        width: parent.width * 0.9
        anchors.centerIn: parent

        spacing: 6


        Label {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            //Layout.preferredHeight: 20

            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width


            font.pointSize: 22
            font.bold: true
            text: qsTr("鹰歌 RPG Maker 引擎")

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
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
            text: qsTr("当前工程：" + GameMakerGlobal.config.strCurrentProjectName)

            //horizontalAlignment: Label.AlignHCenter
            //verticalAlignment: Label.AlignVCenter
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

                text: "新建工程"
                onClicked: {
                    dialogCommon.msg = "输入工程名";
                    dialogCommon.input = '新建工程';
                    textinputDialogCommonInput.visible = true;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        _private.changeProject(dialogCommon.input);

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


            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打开工程"
                onClicked: {
                    l_listProjects.show(GameMakerGlobal.config.strProjectRootPath, "*", 0x001 | 0x2000, 0x00);
                    l_listProjects.visible = true;
                    //l_listProjects.focus = true;
                    l_listProjects.forceActiveFocus();
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "重命名"
                onClicked: {
                    dialogCommon.msg = "输入工程名";
                    textinputDialogCommonInput.visible = true;
                    dialogCommon.input = GameMakerGlobal.config.strCurrentProjectName;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        if(FrameManager.sl_qml_RenameFile(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input) > 0) {
                            _private.changeProject(dialogCommon.input, GameMakerGlobal.config.strCurrentProjectName);
                        }
                        else {
                            console.warn("重命名失败：", GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input);
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



        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            text: "地  图"
            onClicked: {
                if(Platform.compileType() === "debug") {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "角  色"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainRoleEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                    else {
                        _private.loadModule("mainRoleEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                }
            }


            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "特  效"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainSpriteEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                    else {
                        _private.loadModule("mainSpriteEditor.qml");
                        //userMainProject.source = "eventMaker.qml";
                    }
                }
            }


            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "道  具"
                onClicked: {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗角色"
                //font.pointSize: 14

                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainFightRoleEditor.qml");
                        //userMainProject.source = "mainFightRoleEditor.qml";
                    }
                    else {
                        _private.loadModule("mainFightRoleEditor.qml");
                        //userMainProject.source = "mainFightRoleEditor.qml";
                    }
                }
            }


            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗技能"
                //font.pointSize: 14

                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainFightSkillEditor.qml");
                        //userMainProject.source = "mainFightSkillEditor.qml";
                    }
                    else {
                        _private.loadModule("mainFightSkillEditor.qml");
                        //userMainProject.source = "mainFightSkillEditor.qml";
                    }
                }
            }


            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "战斗脚本"
                //font.pointSize: 14

                onClicked: {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.preferredHeight: 50
                Layout.fillHeight: true

                text: "通用脚本"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("GameCommonScript.qml");
                        //userMainProject.source = "GameCommonScript.qml";
                    }
                    else {
                        _private.loadModule("GameCommonScript.qml");
                        //userMainProject.source = "GameCommonScript.qml";
                    }
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

                text: "脚  本"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("GameScriptEditor.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
                    else {
                        _private.loadModule("GameScriptEditor.qml");
                        //userMainProject.source = "GameScriptEditor.qml";
                    }
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

                text: "插件库"
                onClicked: {
                    if(Platform.compileType() === "debug") {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "图片管理"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainImageEditor.qml");
                        //userMainProject.source = "mainImageEditor.qml";
                    }
                    else {
                        _private.loadModule("mainImageEditor.qml");
                        //userMainProject.source = "mainImageEditor.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "音乐管理"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainMusicEditor.qml");
                        //userMainProject.source = "mainMusicEditor.qml";
                    }
                    else {
                        _private.loadModule("mainMusicEditor.qml");
                        //userMainProject.source = "mainMusicEditor.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "视频管理"
                onClicked: {
                    if(Platform.compileType() === "debug") {
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

        Button {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            text: "开始游戏"
            onClicked: {
                if(Platform.compileType() === "debug") {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "测试"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainGameTest.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                    else {
                        _private.loadModule("mainGameTest.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打包项目"
                onClicked: {
                    if(Qt.platform.os === "android") {

                        let path = Platform.getExternalDataPath() + GameMakerGlobal.separator + "RPGMaker" + GameMakerGlobal.separator + "RPGGame";

                        let jsFiles = FrameManager.sl_qml_listDir(path, '*', 0x002 | 0x2000 | 0x4000, 0);
                        jsFiles.sort();

                        /*let needFilesName = ['Android_Package_', 'Android_MakerFrame_RPGRuntime_'];
                        let needFilesIndex = [];
                        for(let fileName in jsFiles) {
                            for(let needFileName in needFilesName) {
                                if(jsFiles[fileName].indexOf(needFilesName[needFileName]) >= 0) {
                                    needFilesIndex[needFileName] = fileName;
                                    break;
                                }
                            }
                        }
                        */

                        let missingFiles = '';
                        if(!jsFiles[0] || jsFiles[0].indexOf('MakerFrame_Package_Android_') < 0)
                            missingFiles += 'MakerFrame_Package_Android_xxx.zip ';
                        if(!jsFiles[1] || jsFiles[1].indexOf('MakerFrame_RPGRuntime_Android_') < 0)
                            missingFiles += 'MakerFrame_RPGRuntime_Android_xxx.zip ';

                        if(missingFiles !== '') {
                            dialogCommon.show({
                                Msg: '请将 %1 文件下载并放入%2文件夹下'.arg(missingFiles).arg(path),
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
                        _private.loadModule("mainGameMakeProgram.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                    else {
                        _private.loadModule("mainGameMakeProgram.qml");
                        //userMainProject.source = "mainGameTest.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "平台分发"
                onClicked: {

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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "导出工程"
                onClicked: {
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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "导入工程"
                onClicked: {
                    filedialogOpenProject.open();
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "示例工程"
                onClicked: {
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
                                    _private.changeProject('Leamus');

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

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "教程"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainTutorial.qml");
                        //userMainProject.source = "mainTutorial.qml";
                    }
                    else {
                        _private.loadModule("mainTutorial.qml");
                        //userMainProject.source = "mainTutorial.qml";
                    }
                }
            }

            /*Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "关于"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainAbout.qml");
                        //userMainProject.source = "mainAbout.qml";
                    }
                    else {
                        _private.loadModule("mainAbout.qml");
                        //userMainProject.source = "mainAbout.qml";
                    }
                }
            }
            */

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "使用协议"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainAgreement.qml");
                        //userMainProject.source = "mainAgreement.qml";
                    }
                    else {
                        _private.loadModule("mainAgreement.qml");
                        //userMainProject.source = "mainAgreement.qml";
                    }
                }
            }

            Button {
                Layout.preferredWidth: 1
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "更新日志"
                onClicked: {
                    if(Platform.compileType() === "debug") {
                        _private.loadModule("mainUpdateLog.qml");
                        //userMainProject.source = "mainUpdateLog.qml";
                    }
                    else {
                        _private.loadModule("mainUpdateLog.qml");
                        //userMainProject.source = "mainUpdateLog.qml";
                    }
                }
            }

        }



        RowLayout {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
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
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                //width: parent.width
                font.pointSize: 12
                text: qsTr("Q群：654876441")
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
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 12
                text: qsTr("<a href='https://afdian.net/a/Leamus'>爱发电</a>")
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
                Layout.fillHeight: true
                //Layout.fillWidth: true
                //Layout.preferredWidth: 1

                font.pointSize: 12
                text: qsTr("RPG引擎 Ver：" + GameMakerGlobal.version)
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
            _private.changeProject(item);


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
        //folder: shortcuts.home
        nameFilters: [ "zip files (*.zip)", "All files (*)" ]

        selectMultiple: false
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
                let ret = FrameManager.sl_qml_ExtractDir(GlobalJS.toPath(fUrl), projectPath);


                if(ret.length > 0) {
                    _private.changeProject(FrameManager.sl_qml_BaseName(fUrl));

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


                    textArea.color: 'white'
                    textArea.readOnly: true
                    textArea.selectByMouse: false

                    textArea.text: ''
                    textArea.placeholderText: ""

                    textArea.background: Rectangle {
                        //implicitWidth: 200
                        //implicitHeight: 40
                        color: 'black'
                        //color: 'transparent'
                        //color: Global.style.backgroundColor
                        border.color: textHelpInfo.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                        border.width: textHelpInfo.textArea.focus ? 2 : 1
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
                    text: '关闭'
                    onClicked: {
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

        //anchors.right: parent.right
        //anchors.bottom: parent.bottom
        x: parent.width - width
        y: parent.height - height
        width: 60
        height: 36


        radius: 10
        color: '#30000000'



        Label {
            id: textDebugButton
            anchors.fill: parent
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            //width: parent.width

            color: 'red'
            font.pointSize: 16
            font.bold: true
            text: rectDebugButton.nCount === 0 ? '' : rectDebugButton.nCount

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
            }

            drag.target: parent
        }
    }

    //调试 界面
    Rectangle {
        id: rectDebugWindow


        function close() {
            rectDebugButton.nCount = 0;

            rectDebugWindow.visible = false;
            //loader.focus = true;
            loader.forceActiveFocus();
        }


        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9
        visible: false

        color: Global.style.backgroundColor

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
            opacity: 0
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


                    nMaximumBlockCount: 0

                    textArea.color: 'white'
                    //textArea.readOnly: true
                    //textArea.selectByKeyboard: true
                    //textArea.selectByMouse: true

                    textArea.text: ''
                    textArea.placeholderText: ""

                    textArea.background: Rectangle {
                        //implicitWidth: 200
                        //implicitHeight: 40
                        color: 'black'
                        //color: 'transparent'
                        //color: Global.style.backgroundColor
                        border.color: textDebugInfo.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                        border.width: textDebugInfo.textArea.focus ? 2 : 1
                    }
                }
            }

            TextField {
                id: textCommand

                readonly property int nPadding: 6

                Layout.fillWidth: true
                Layout.preferredWidth: 1

                leftPadding : nPadding
                rightPadding : nPadding
                topPadding : nPadding
                bottomPadding: nPadding

                placeholderText: '输入命令'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

                background: Rectangle {
                    //implicitWidth: 200
                    //implicitHeight: 40
                    //color: 'black'
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: textCommand.focus ? Global.style.accent : Global.style.hintTextColor
                    border.width: textCommand.focus ? 2 : 1
                }


                Keys.onEnterPressed: {
                    let t = text;
                    //text = '';
                    selectAll();
                    console.info(eval(t));
                }
                Keys.onReturnPressed: {
                    let t = text;
                    //text = '';
                    selectAll();
                    console.info(eval(t));
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
                    text: '复制'
                    onClicked: {
                        FrameManager.sl_qml_SetClipboardText(FrameManager.toPlainText(textDebugInfo.textDocument));
                    }
                }

                Button {
                    text: '清空'
                    onClicked: {
                        textDebugInfo.text = '';
                    }
                }

                Button {
                    text: '关闭'
                    onClicked: {
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


        //切换工程，转移和检查工程引擎变量
        function changeProject(newProject, oldProject=null) {
            if(oldProject !== null) {
                GameMakerGlobal.settings.setValue("$RPG/" + newProject, GameMakerGlobal.settings.value("$RPG/" + oldProject));
                GameMakerGlobal.settings.setValue("$RPG/" + oldProject, undefined);
            }
            if(GameMakerGlobal.settings.value("$RPG/" + newProject) === undefined)
                GameMakerGlobal.settings.setValue("$RPG/" + newProject, {});

            GameMakerGlobal.config.strCurrentProjectName = newProject;
        }


        //显示调试窗口
        function appendDebugMessage(msgType, msg) {

            if(Global.filterMessage(msgType, msg))
                return;

            //消息类型
            switch(msgType) {
                //跳过一部分 无关紧要 的 警告
            case FrameManagerClass.QtWarningMsg:
                textDebugInfo.textArea.append("<font color='yellow'>【Warning】" + msg + "</font>");
                textDebugInfo.toEnd();

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtCriticalMsg:
                textDebugInfo.textArea.append("<font color='red'>【Critical】" + msg + "</font>");
                textDebugInfo.toEnd();

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtFatalMsg:
                textDebugInfo.textArea.append("<font color='red'>【Fatal】" + msg + "</font>");
                textDebugInfo.toEnd();

                //rectDebugWindow.visible = true;
                //rectDebugWindow.forceActiveFocus();
                ++rectDebugButton.nCount;
                break;

            case FrameManagerClass.QtInfoMsg:
                textDebugInfo.textArea.append("<font color='white'>【Info】" + msg + "</font>");
                textDebugInfo.toEnd();

                ++rectDebugButton.nCount;
                break;
            case FrameManagerClass.QtDebugMsg:
                if(Platform.compileType() === "debug") {
                }
                break;

            default:
                textDebugInfo.textArea.append(msgType + msg);
                textDebugInfo.toEnd();

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
        rootWindow.s_MessageHandler.connect(_private.appendDebugMessage);


        if(!GameMakerGlobal.settings.value('$RunTimes')) {
            rectHelpWindow.showMsg('<font size=6>  初来乍到？先进入 教程 来了解一下引擎吧，或者下载 示例工程 试玩，还可以加群下载各种资源和工程。</font>');
            GameMakerGlobal.settings.setValue('$RunTimes', 1);
        }
        else
            GameMakerGlobal.settings.setValue('$RunTimes', parseInt(GameMakerGlobal.settings.value('$RunTimes')) + 1);
        //if(GameMakerGlobal.settings.value('$ProjectName'))
        //    GameMakerGlobal.config.strCurrentProjectName = GameMakerGlobal.settings.value('$ProjectName');



        FrameManager.globalObject().GameMakerGlobal = GameMakerGlobal;



        //let d = console.debug;
        //console.debug = 123;
        //d("!!!!!!!!!!!", d, console.debug, d === console.debug);

        console.debug("[mainGameMaker]Component.onCompleted");
    }

    Component.onDestruction: {
        rootWindow.s_MessageHandler.disconnect(_private.appendDebugMessage);

        delete FrameManager.globalObject().GameMakerGlobal;

        console.debug("[mainGameMaker]Component.onDestruction");
    }
}
