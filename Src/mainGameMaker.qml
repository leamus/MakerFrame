import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.leamus.gamedata 1.0


//引入Qt定义的类
import cn.leamus.gamedata 1.0


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        spacing: 10


        Text {
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 20

            //height: 50
            //width: parent.width
            font.pointSize: 16
            text: qsTr("当前工程：" + GameMakerGlobal.config.strCurrentProjectName)

            //anchors.horizontalCenter: parent.horizontalCenter
            //horizontalAlignment: Text.AlignHCenter
        }


        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "新建工程"
                onButtonClicked: {
                    textDialogCommonTips.text = "输入工程名";
                    textinputDialogCommonInput.visible = true;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        GameMakerGlobal.config.strCurrentProjectName = textinputDialogCommonInput.text;

                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
                    };
                    dialogCommon.open();
                }
            }


            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打开工程"
                onButtonClicked: {
                    dirListProjects.showList(GameMakerGlobal.config.strProjectPath, "*", 0x001 | 0x2000, 0x00);
                    dirListProjects.visible = true;
                    dirListProjects.focus = true;
                }
            }

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "重命名工程"
                onButtonClicked: {
                    textDialogCommonTips.text = "输入工程名";
                    textinputDialogCommonInput.visible = true;
                    textinputDialogCommonInput.text = GameMakerGlobal.config.strCurrentProjectName;
                    dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                    dialogCommon.fOnAccepted = ()=>{
                        if(GameManager.sl_qml_RenameFolder(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName, GameMakerGlobal.config.strProjectPath + Platform.separator() + textinputDialogCommonInput.text)) {
                            GameMakerGlobal.config.strCurrentProjectName = textinputDialogCommonInput.text;
                        }
                        else {
                            console.warn("重命名失败：", textinputDialogCommonInput.text, GameMakerGlobal.config.strCurrentProjectName)
                        }

                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
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
                Layout.preferredWidth: parent.width * 0.4
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
                Layout.preferredWidth: parent.width * 0.4
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
        }

        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "音乐编辑器"
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
                Layout.preferredWidth: parent.width * 0.3
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
                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
                    };

                    textDialogCommonTips.text = "敬请期待~";
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

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "升级链编辑器"
                onButtonClicked: {

                    if(Platform.compileType() === "debug") {
                        if(Qt.platform.os === "windows")
                            _private.loadModule("GameLevelChain.qml");
                        else if(Qt.platform.os === "android")
                            _private.loadModule("GameLevelChain.qml");
                        //userMainProject.source = "GameLevelChain.qml";
                    }
                    else {
                        _private.loadModule("GameLevelChain.qml");
                        //userMainProject.source = "GameLevelChain.qml";
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

            text: "战斗编辑器"
            onButtonClicked: {
                if(Platform.compileType() === "debug") {
                    if(Qt.platform.os === "windows")
                        _private.loadModule("mainFightEditor.qml");
                    else if(Qt.platform.os === "android")
                        _private.loadModule("mainFightEditor.qml");
                    //userMainProject.source = "mainFightEditor.qml";
                }
                else {
                    _private.loadModule("mainFightEditor.qml");
                    //userMainProject.source = "mainFightEditor.qml";
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
                Layout.preferredWidth: parent.width * 0.3
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
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "打包项目"
                onButtonClicked: {
                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
                    };

                    textDialogCommonTips.text = "敬请期待~";
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
                Layout.preferredWidth: parent.width * 0.3
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
                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
                    };

                    textDialogCommonTips.text = "敬请期待~";
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
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "导出工程"
                onButtonClicked: {
                    let ret = GameManager.sl_qml_CompressDir(
                                GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + ".zip",
                                GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName
                                                  );

                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.Ok;
                    dialogCommon.fOnAccepted = ()=>{
                        root.forceActiveFocus();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        root.forceActiveFocus();
                    };

                    if(ret)
                        textDialogCommonTips.text = "成功：" + GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + ".zip";
                    else
                        textDialogCommonTips.text = "失败";
                    dialogCommon.open();
                }
            }

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
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
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                Layout.fillHeight: true

                text: "示例工程"
                onButtonClicked: {
                    enabled = false;

                    let projectUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + "Leamus";

                    let nr = GameManager.sl_qml_DownloadFile("http://MakerFrame.Leamus.cn/Project.zip", projectUrl + ".zip");
                    nr.finished.connect(function() {
                        GameManager.sl_qml_DeleteLater(nr);
                        //GameManager.sl_qml_Property(nr, "属性");  //TimeStamp、Data、SaveType、Code


                        //let projectUrl = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/GameMaker/Projects/cde"

                        GameManager.sl_qml_CreateFolder(projectUrl);
                        let ret = GameManager.sl_qml_ExtractDir(projectUrl + ".zip", projectUrl);

                        if(ret.length > 0) {
                            GameMakerGlobal.config.strCurrentProjectName = "Leamus";
                            //console.debug(ret, projectUrl, fileUrl, GameManager.sl_qml_AbsolutePath(fileUrl));
                            textDialogCommonTips.text = "成功";
                        }
                        else
                            textDialogCommonTips.text = "失败";
                        textinputDialogCommonInput.visible = false;
                        dialogCommon.standardButtons = Dialog.Ok;
                        dialogCommon.fOnAccepted = ()=>{
                            root.forceActiveFocus();
                        };
                        dialogCommon.fOnRejected = ()=>{
                            root.forceActiveFocus();
                        };
                        dialogCommon.open();

                        enabled = true;

                        console.debug("下载完毕", nr, GameManager.sl_qml_Property(nr, "Data"));
                    });


                    textDialogCommonTips.text = "正在下载工程，请等待（请勿进行其他操作）";
                    textinputDialogCommonInput.visible = false;
                    dialogCommon.standardButtons = Dialog.NoButton;
                    dialogCommon.fOnAccepted = ()=>{
                        dialogCommon.open();
                    };
                    dialogCommon.fOnRejected = ()=>{
                        dialogCommon.open();
                    };
                    dialogCommon.open();

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
                Layout.preferredWidth: parent.width * 0.3
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
                Layout.preferredWidth: parent.width * 0.3
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

            ColorButton {
                Layout.preferredWidth: parent.width * 0.3
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
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
                    else {
                        _private.loadModule("mainGameAbout.qml");
                        //userMainProject.source = "mainGameUpdateLog.qml";
                    }
                }
            }
        }


    }


    //Item {
        //Layout.preferredWidth: parent.width * 0.9
        //Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        //Layout.preferredHeight: 50

        Text {
            height: 50
            //width: parent.width
            font.pointSize: 16
            text: qsTr("鹰歌Maker交流群：654876441")
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            //anchors.horizontalCenter: parent.horizontalCenter
            //horizontalAlignment: Text.AlignHCenter
        }

        Text {
            height: 50
            //width: parent.width
            font.pointSize: 16
            text: qsTr("version:" + GameMakerGlobal.version)
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            //horizontalAlignment: Text.AlignHCenter
        }

    //}



    DirList {
        id: dirListProjects
        visible: false


        onCanceled: {
            //loader.visible = true;
            root.focus = true;
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


            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            root.focus = true;
            visible = false;

        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + item;

            textDialogCommonTips.text = "确认删除?";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainGameMaker]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
                _private.loadModule("");

                dirListProjects.forceActiveFocus();
            };
            dialogCommon.fOnRejected = ()=>{
                dirListProjects.forceActiveFocus();
            };
            dialogCommon.open();
        }
    }



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
            //root.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.forceActiveFocus();

            console.debug("[mainGameMaker]You chose: " + fileUrl, fileUrls);


            textDialogCommonTips.text = "确认解包吗？这会替换目标项目的同名文件！";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                let fUrl;
                if(Qt.platform.os === "android")
                    fUrl = Platform.getRealPathFromURI(fileUrl.toString());
                else
                    fUrl = GameManager.sl_qml_UrlDecode(fileUrl.toString());

                //console.error("!!!", fUrl, fileUrl)

                //GameManager.sl_qml_RemoveRecursively(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName);

                let projectUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameManager.sl_qml_BaseName(fUrl);
                //let projectUrl = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/GameMaker/Projects/cde"

                GameManager.sl_qml_CreateFolder(projectUrl);
                let ret = GameManager.sl_qml_ExtractDir(Global.toQtPath(fUrl), projectUrl);

                if(ret.length > 0) {
                    GameMakerGlobal.config.strCurrentProjectName = GameManager.sl_qml_BaseName(fUrl);
                    //console.debug(ret, projectUrl, fileUrl, GameManager.sl_qml_AbsolutePath(fileUrl));
                    textDialogCommonTips.text = "成功";
                }
                else
                    textDialogCommonTips.text = "失败";
                textinputDialogCommonInput.visible = false;
                dialogCommon.standardButtons = Dialog.Ok;
                dialogCommon.fOnAccepted = ()=>{
                    root.forceActiveFocus();
                };
                dialogCommon.fOnRejected = ()=>{
                    root.forceActiveFocus();
                };
                dialogCommon.open();
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();

        }
        onRejected: {
            //root.forceActiveFocus();


            //s_close();
            console.debug("[mainGameMaker]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    //通用对话框
    /*/Dialog1.Dialog {
        anchors.centerIn: parent

        title: "深林孤鹰"
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
    */
    Dialog {
        id: dialogCommon



        property var fOnAccepted
        property var fOnRejected



        visible: false
        anchors.centerIn: parent
        width: root.width * 0.6
        //height: 200

        title: "深林孤鹰提示"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        ColumnLayout {
            anchors.fill: parent

            Text {
                id: textDialogCommonTips

                Layout.fillWidth: true

                text: qsTr("")
                wrapMode: Text.WrapAnywhere
            }

            TextInput {
                id: textinputDialogCommonInput

                Layout.fillWidth: true

                text: ""
            }
        }

        onAccepted: {
            if(fOnAccepted)fOnAccepted();

            //root.focus = true;
            //root.forceActiveFocus();
        }

        onRejected: {
            if(fOnRejected)fOnRejected();

            //root.focus = true;
            //root.forceActiveFocus();
        }
    }


    Loader {
        id: loader

        source: ""
        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            if(loader.item.init)
                loader.item.init();
            //item.testFresh();
            console.debug("[mainGameMaker]loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;
            }
        }
    }



    Rectangle {
        id: rectDebugWindow
        anchors.fill: parent
        color: "black"
        visible: false


        Keys.onEscapePressed:  {
            rectDebugWindow.visible = false;
            loader.focus = true;

            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            rectDebugWindow.visible = false;
            loader.focus = true;

            event.accepted = true;
            //Qt.quit();
        }


        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true
                //Layout.preferredWidth: parent.width * 0.4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 50
                Layout.minimumHeight: 20
                Layout.fillHeight: true

                Notepad {
                    id: textDebugInfo

                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width

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
                        GameManager.sl_qml_SetClipboardText(GameManager.toPlainText(textDebugInfo.textDocument));
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
                        rectDebugWindow.visible = false;
                        loader.focus = true;
                    }
                }
            }

        }
    }



    QtObject {
        id: _private

        function loadModule(modulePath) {
            loader.visible = true;
            loader.focus = true;

            loader.source = modulePath;

            /*if(loader.status === Loader.Ready) {
                if(loader.item.init)
                    loader.item.init();

                console.debug("Loader.Ready");
                //loader.item.forceActiveFocus();
            }*/

        }

        function showDebugWindow(msgType, msg) {

            switch(msgType) {
            case GameManagerClass.QtDebugMsg:
                if(Platform.compileType() === "debug") {
                }
                break;
            case GameManagerClass.QtWarningMsg:
                if(msg.indexOf('QML Connections: Implicitly defined onFoo properties in Connections are deprecated. Use this syntax instead: function onFoo(<arguments>) { ... }') >= 0)
                    break;
                if(msg.indexOf('Retrying to obtain clipboard.') >= 0)
                    break;
                if(msg.indexOf('libpng warning: iCCP: known incorrect sRGB profile') >= 0)
                    break;
                if(msg.indexOf('Model size of ') >= 0)
                    break;
                if(msg.indexOf('QUnifiedTimer::stopAnimationDriver: driver is not running') >= 0)
                    break;
                textDebugInfo.text += ("[Warning]" + msg);
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
                break;
            case GameManagerClass.QtCriticalMsg:
                textDebugInfo.text += ("[Critical]" + msg);
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
                break;
            case GameManagerClass.QtFatalMsg:
                textDebugInfo.text += ("[Fatal]" + msg);
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
                break;
            case GameManagerClass.QtInfoMsg:
                break;
            default:
                textDebugInfo.text += (msgType + msg);
                rectDebugWindow.visible = true;
                rectDebugWindow.forceActiveFocus();
                break;
            }
        }
    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
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
