import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Rectangle {
    id: root


    signal s_close();


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true

    color: Global.style.backgroundColor



    MouseArea {
        anchors.fill: parent
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialog
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

                //let projectPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + FrameManager.sl_qml_BaseName(fUrl);
                let projectUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;
                //let projectPath = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"

                //FrameManager.sl_qml_CreateFolder(projectPath);
                let ret = FrameManager.sl_qml_ExtractDir(Global.toPath(fUrl), projectUrl);


                if(ret.length > 0) {
                    //GameMakerGlobal.config.strCurrentProjectName = FrameManager.sl_qml_BaseName(fUrl);
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



    QtObject {
        id: _private
        property var jsEngine: new GlobalJS.JSEngine(root)

        function refresh() {

            let menuJS = jsEngine.load('menu.js', 'http://MakerFrame.Leamus.cn/RPGMaker/Plugins');

            //console.debug(menuJS.plugins, Object.keys(menuJS.plugins), JSON.stringify(menuJS.plugins));

            l_list.open({
                RemoveButtonVisible: false,
                Data: Object.keys(menuJS.plugins),
                OnClicked: (index, item)=>{
                    if(!GlobalLibraryJS.isObject(menuJS.plugins[item])) {
                        filedialog.open();
                        return;
                    }

                    dialogCommon.show({
                        Msg: '名称：%1\r\n版本：%2\r\n日期：%3\r\n作者：%4\r\n大小：%5\r\n描述：%6\r\n确定下载？'
                                          .arg(menuJS.plugins[item]['Name'])
                                          .arg(menuJS.plugins[item]['Version'])
                                          .arg(menuJS.plugins[item]['Update'])
                                          .arg(menuJS.plugins[item]['Author'])
                                          .arg(menuJS.plugins[item]['Size'])
                                          .arg(menuJS.plugins[item]['Description'])
                                          ,
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function(){

                            let projectUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator;
                            let zipPath = projectUrl + "Plugins/%1".arg(menuJS.plugins[item]['File']);

                            //let nr = FrameManager.sl_qml_DownloadFile("https://gitee.com/leamus/MakerFrame/raw/master/Examples/Project.zip", projectUrl + ".zip");
                            let nr = FrameManager.sl_qml_DownloadFile("http://MakerFrame.Leamus.cn/RPGMaker/Plugins/%1".arg(menuJS.plugins[item]['File']), zipPath);
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
                                            root.forceActiveFocus();
                                        },
                                        OnRejected: ()=>{
                                            root.forceActiveFocus();
                                        },
                                    });
                                    return;
                                }



                                //let projectUrl = "F:\\_Projects/Pets/Qt_Pets/Desktop_Qt_5_15_2_MinGW_32_bit-Debug/debug/MakerFrame/RPGMaker/Projects/cde"

                                let ret = FrameManager.sl_qml_ExtractDir(zipPath, projectUrl);

                                let msg;
                                if(ret.length > 0) {
                                    //console.debug(ret, projectUrl, fileUrl, FrameManager.sl_qml_AbsolutePath(fileUrl));
                                    msg = "安装成功";
                                }
                                else
                                    msg = "安装失败";

                                dialogCommon.show({
                                    Msg: msg,
                                    Buttons: Dialog.Yes,
                                    OnAccepted: function(){
                                        root.forceActiveFocus();
                                    },
                                    OnRejected: ()=>{
                                        root.forceActiveFocus();
                                    },
                                });
                            });


                            dialogCommon.show({
                                Msg: '正在下载，请等待（请勿进行其他操作）',
                                Buttons: Dialog.NoButton,
                                OnAccepted: function(){
                                    dialogCommon.open();
                                },
                                OnRejected: ()=>{
                                    dialogCommon.open();
                                },
                            });



                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });

                    //l_list.visible = false;
                    //root.forceActiveFocus();
                },
                OnCanceled: ()=>{
                    l_list.visible = false;
                    //root.forceActiveFocus();
                    s_close();
                },
            });
        }
    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        l_list.visible = false;
        s_close();

        console.debug("[mainRoleEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        l_list.visible = false;
        s_close();

        console.debug("[mainRoleEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainRoleEditor]key:", event, event.key, event.text)
    }



    Component.onCompleted: {
        _private.refresh();
    }
}
