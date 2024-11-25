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


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


import './Core'


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
            text: qsTr("鹰歌游戏引擎")

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
                        if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input)) {
                            dialogCommon.show({
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

                        _private.changeProject(dialogCommon.input);

                        let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
                        FrameManager.sl_dirCreate(projectPath);


                        dialogCommon.show({
                            Msg: '是否复制素材资源？\r\n（注意：素材资源均来自互联网，仅供测试使用，侵删）',
                            Buttons: Dialog.Yes | Dialog.No,
                            OnAccepted: function() {
                                /*dialogCommon.show({
                                    Msg: '由于服务器带宽低，下载人数多时会导致很慢，建议加群后可以下载更多的示例工程，确定下载吗？',
                                    Buttons: Dialog.Yes | Dialog.No,
                                    OnAccepted: function() {
                                */


                                let resTemplate = GameMakerGlobal.config.strWorkPath + GameMakerGlobal.separator + "$资源模板.zip";

                                function _continue() {
                                    //FrameManager.sl_dirCreate(projectPath);
                                    let ret = FrameManager.sl_extractDir(resTemplate, projectPath);

                                    if(ret.length > 0) {
                                        //_private.changeProject('Leamus');

                                        //console.debug(ret, projectPath, fileUrl, FrameManager.sl_absolutePath(fileUrl));
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
                                }

                                //enabled = false;

                                if(!FrameManager.sl_fileExists(resTemplate)) {
                                    //https://qiniu.leamus.cn/$资源模板.zip
                                    const httpReply = FrameManager.sl_downloadFile("http://MakerFrame.Leamus.cn/RPGMaker/$资源模板.zip", resTemplate);
                                    httpReply.sg_finished.connect(function(httpReply) {
                                        const networkReply = httpReply.networkReply;
                                        const code = FrameManager.sl_objectProperty("Code", networkReply);
                                        console.debug("[mainGameMaker]下载完毕", httpReply, networkReply, code, FrameManager.sl_objectProperty("Data", networkReply));

                                        FrameManager.sl_deleteLater(httpReply);


                                        dialogCommon.close();
                                        //enabled = true;

                                        if(code !== 0) {
                                            dialogCommon.show({
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


                                    textinputDialogCommonInput.visible = false;
                                    dialogCommon.msg = "正在下载，请等待（请勿进行其他操作）";
                                    dialogCommon.standardButtons = Dialog.NoButton;
                                    dialogCommon.fOnAccepted = ()=>{
                                        dialogCommon.open();
                                    };
                                    dialogCommon.fOnRejected = ()=>{
                                        dialogCommon.open();
                                    };
                                    dialogCommon.open();
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
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.open();
                    textinputDialogCommonInput.forceActiveFocus();
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
                    l_listProjects.show(GameMakerGlobal.config.strProjectRootPath, "*", 0x001 | 0x2000, 0x03);
                    l_listProjects.visible = true;
                    //l_listProjects.focus = true;
                    //l_listProjects.forceActiveFocus();
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
                        if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input)) {
                            dialogCommon.show({
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

                        if(FrameManager.sl_fileRename(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input) > 0) {
                            _private.changeProject(dialogCommon.input, GameMakerGlobal.config.strCurrentProjectName);
                        }
                        else {
                            if(FrameManager.sl_dirExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input)) {
                                dialogCommon.show({
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
                            console.warn("[mainGameMaker]重命名失败：", GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + dialogCommon.input);
                        }

                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        rootGameMaker.forceActiveFocus();
                    };
                    dialogCommon.open();
                    textinputDialogCommonInput.forceActiveFocus();
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

            text: "地　图"
            onClicked: {
                if(Platform.compileType === "debug") {
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

                text: "角　色"
                onClicked: {
                    if(Platform.compileType === "debug") {
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

                text: "特　效"
                onClicked: {
                    if(Platform.compileType === "debug") {
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

                text: "道　具"
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

                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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

                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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

                text: "脚　本"
                onClicked: {
                    if(Platform.compileType === "debug") {
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

                text: "插　件"
                onClicked: {
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                if(Platform.compileType === "debug") {
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

                text: "测　试"
                onClicked: {
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
                        _private.loadModule("mainPackage.qml");
                        //userMainProject.source = "mainPackage.qml";
                    }
                    else {
                        _private.loadModule("mainPackage.qml");
                        //userMainProject.source = "mainPackage.qml";
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
                    if(!_private.checkCurrentProjectName()) {
                        return;
                    }


                    let ret = FrameManager.sl_compressDir(
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
                    filedialogOpenProject.folder = GameMakerGlobal.config.strProjectRootPath;
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
                        OnAccepted: function() {

                            enabled = false;

                            let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + "$Leamus";

                            //https://qiniu.leamus.cn/$Leamus.zip
                            //https://gitee.com/leamus/MakerFrame/raw/master/Examples/$Leamus.zip
                            const httpReply = FrameManager.sl_downloadFile("http://MakerFrame.Leamus.cn/RPGMaker/Projects/$Leamus.zip", projectPath + ".zip");
                            httpReply.sg_finished.connect(function(httpReply) {
                                const networkReply = httpReply.networkReply;
                                const code = FrameManager.sl_objectProperty("Code", networkReply);
                                console.debug("[mainGameMaker]下载完毕", httpReply, networkReply, code, FrameManager.sl_objectProperty("Data", networkReply));

                                FrameManager.sl_deleteLater(httpReply);


                                dialogCommon.close();
                                enabled = true;

                                if(code !== 0) {
                                    dialogCommon.show({
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


                                //let projectPath = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"

                                FrameManager.sl_dirCreate(projectPath);
                                let ret = FrameManager.sl_extractDir(projectPath + ".zip", projectPath);

                                if(ret.length > 0) {
                                    _private.changeProject('$Leamus');

                                    //console.debug(ret, projectPath, fileUrl, FrameManager.sl_absolutePath(fileUrl));
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

                            });


                            textinputDialogCommonInput.visible = false;
                            dialogCommon.msg = "正在下载，请等待（请勿进行其他操作）";
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

                text: "教　程"
                onClicked: {
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                    if(Platform.compileType === "debug") {
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
                text: qsTr("<a href='https://afdian.com/a/Leamus'>爱发电</a>")
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
                text: qsTr("Ver：" + GameMakerGlobal.version)
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
            visible = false;
            //loader.visible = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
            //loader.item.focus = true;
        }

        onClicked: {
            if(item === "..") {
                visible = false;
                rootGameMaker.forceActiveFocus();
                return;
            }


            //_private.loadModule("");
            _private.changeProject(item);


            visible = false;
            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            //rootGameMaker.focus = true;
            rootGameMaker.forceActiveFocus();
        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + item;

            dialogCommon.msg = "确认删除?";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainGameMaker]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_dirExists(dirUrl), FrameManager.sl_removeRecursively(dirUrl));
                removeItem(index);
                //_private.loadModule("");

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
        folder: GameMakerGlobal.config.strProjectRootPath
        nameFilters: [ "zip files (*.zip)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.focus = true;
            //rootGameMaker.forceActiveFocus();

            console.debug("[mainGameMaker]You chose: " + fileUrl, fileUrls);


            dialogCommon.msg = "确认解包吗？这会替换目标项目中的同名文件！";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                let fUrl;
                if(Qt.platform.os === "android")
                    fUrl = Platform.sl_getRealPathFromURI(fileUrl.toString());
                else
                    fUrl = FrameManager.sl_urlDecode(fileUrl.toString());

                //console.error("!!!", fUrl, fileUrl)

                //FrameManager.sl_removeRecursively(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName);

                let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + FrameManager.sl_completeBaseName(fUrl);
                //let projectPath = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"
                //console.debug('[mainGameMaker]path:', fUrl, projectPath, FrameManager.sl_completeBaseName(fUrl))

                FrameManager.sl_dirCreate(projectPath);
                let ret = FrameManager.sl_extractDir(GlobalJS.toPath(fUrl), projectPath);


                if(ret.length > 0) {
                    _private.changeProject(FrameManager.sl_completeBaseName(fUrl));

                    //console.debug('[mainGameMaker]', ret, projectPath, fileUrl, FrameManager.sl_absolutePath(fileUrl));
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


            //sg_close();
            console.debug("[mainGameMaker]onRejected");
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    //主窗口加载
    Loader {
        id: loader

        visible: false
        focus: true

        anchors.fill: parent


        source: ""
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

                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //rootGameMaker.focus = true;
                rootGameMaker.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
                showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                clearComponentCache();
                trimComponentCache();
            }
        }

        onLoaded: {
            console.debug("[mainGameMaker]loader onLoaded");

            try {
                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init();

                visible = true;
            }
            catch(e) {
                throw e;
            }
            finally {
                showBusyIndicator(false);
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
                    //textArea.enabled: false
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
                    text: '关闭'
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
    }


    QtObject {
        id: _private

        function checkCurrentProjectName() {
            if(GameMakerGlobal.config.strCurrentProjectName.trim().length === 0) {
                dialogCommon.show({
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
        function loadModule(moduleURL) {
            //console.debug('~~~loadModule:', moduleURL);


            if(moduleURL.length !== 0 && !checkCurrentProjectName())
                return false;


            //loader.visible = true;
            //loader.focus = true;
            //loader.forceActiveFocus();

            //loader.source = moduleURL;
            loader.setSource(moduleURL);

            /*if(loader.status === Loader.Ready) {
                if(loader.item.init)
                    loader.item.init();

                console.debug("[mainGameMaker]Loader.Ready");
                //loader.item.forceActiveFocus();
            }*/

            return true;
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

    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainGameMaker]Escape Key");
        event.accepted = false;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainGameMaker]Back Key");
        event.accepted = false;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGameMaker]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainGameMaker]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        //if(!GameMakerGlobal.settings.$RunTimes) {
        if(GameMakerGlobal.settings.value('$RunTimes') === 0) {
            rectHelpWindow.showMsg('<font size=6>  初来乍到？先进入 教程 来了解一下引擎吧，或者下载 示例工程 试玩，还可以加群下载各种资源和工程。</font>');
            //GameMakerGlobal.settings.setValue('$RunTimes', 1);
        }
        else {
            //GameMakerGlobal.settings.setValue('$RunTimes', parseInt(GameMakerGlobal.settings.value('$RunTimes')) + 1);
        }
        ++GameMakerGlobal.settings.$RunTimes;

        //if(GameMakerGlobal.settings.value('$ProjectName'))
        //    GameMakerGlobal.config.strCurrentProjectName = GameMakerGlobal.settings.value('$ProjectName');



        //FrameManager.sl_globalObject().GameMakerGlobal = GameMakerGlobal;



        //let d = console.debug;
        //console.debug = 123;
        //d("!!!!!!!!!!!", d, console.debug, d === console.debug);

        console.debug("[mainGameMaker]Component.onCompleted:", Qt.resolvedUrl('.'));
    }
    Component.onDestruction: {
        //delete FrameManager.sl_globalObject().GameMakerGlobal;

        console.debug("[mainGameMaker]Component.onDestruction:", Qt.resolvedUrl('.'));
    }
}
