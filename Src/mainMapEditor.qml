import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


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

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        ColorButton {
            Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.6
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: 50

            text: "新建地图"
            onButtonClicked: {
                dialogMapData.nCreateMapType = 1;
                dialogMapData.open();
            }
        }

        ColorButton {
            Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.6
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "打开地图"
            onButtonClicked: {
                //console.debug(filedialogOpenMap.shortcuts, JSON.stringify(filedialogOpenMap.shortcuts))
                //filedialogOpenMap.folder = Global._FixLocalPath_W(Platform.getExternalDataPath() + Platform.separator() + "Map")
                //filedialogOpenMap.folder = filedialogOpenMap.shortcuts.pictures;
                //filedialogOpenMap.setFolder(filedialogOpenMap.shortcuts.pictures);
                //console.debug("filedialogOpenMap.folder:", filedialogOpenMap.folder)
                //filedialogOpenMap.open();


                //console.debug(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName + Platform.separator())
                dirListMaps.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName + Platform.separator(), "*", 0x001 | 0x2000, 0x00);
                dirListMaps.visible = true;
                dirListMaps.focus = true;
                //console.debug("path:", Global._FixLocalPath_W(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName))
                //console.debug("path:", Qt.resolvedUrl(Platform.getExternalDataPath()));
                //console.debug("path:", Qt.resolvedUrl(Global._FixLocalPath_W(Platform.getExternalDataPath())));
            }
        }
    }



    Loader {
        id: loader

        source: "./MapEditor.qml"
        visible: false
        focus: true

        anchors.fill: parent

        onLoaded: {
            //item.testFresh();
            console.debug("[mainMapEditor]loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;
            }
        }
    }




    Dialog {
        id: dialogMapData

        //1新建；2打开
        property int nCreateMapType: 1
        //1图片，2素材
        //property int nChoiceType: 0

        property var mapData: ({})



        anchors.centerIn: parent
        width: parent.width * 0.9
        //height: 600

        title: "地图数据"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        ColumnLayout {
            width: parent.width

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Text {
                    text: qsTr("地图大小（宽*高）：")
                }

                TextField {
                    id: textMapWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
                Text {
                    text: qsTr("*")
                }
                TextField {
                    id: textMapHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }


            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Text {
                    text: qsTr("地图块大小（宽*高）：")
                }

                TextField {
                    id: textBlockWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                Text {
                    text: qsTr("*")
                }

                TextField {
                    id: textBlockHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }


            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    text: qsTr("路径：")
                }

                TextField {
                    id: textMapBlockImageURL
                    Layout.fillWidth: true
                    placeholderText: ""

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                TextField {
                    id: textMapBlockResourceName
                    Layout.fillWidth: true
                    placeholderText: "素材名"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveResource
                    checked: false
                    enabled: false
                    text: "另存"
                }
            }


            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                Layout.maximumWidth:  parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                ColorButton {
                    text: "选择图片"
                    Layout.fillWidth: true
                    onButtonClicked: {
                        //dialogMapData.nChoiceType = 1;
                        filedialogOpenMapBlock.open();
                        //root.forceActiveFocus();
                    }
                }
                ColorButton {
                    text: "选择素材"
                    Layout.fillWidth: true
                    onButtonClicked: {
                        //dialogMapData.nChoiceType = 2;

                        let path = GameMakerGlobal.mapResourceURL();

                        dirlistMapBlockResource.showList(path, "*", 0x002, 0x00);
                        dirlistMapBlockResource.visible = true;
                        //dirlistMapBlockResource.focus = true;
                        dirlistMapBlockResource.forceActiveFocus();

                        dialogMapData.visible = false;
                    }
                }

            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelDialogTips
                    Layout.alignment: Qt.AlignHCenter
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //地图块路径 操作

            if(textMapBlockImageURL.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "路径不能为空";
                Platform.showToast("路径不能为空");
                return;
            }
            if(textMapBlockResourceName.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "资源名不能为空";
                Platform.showToast("资源名不能为空");
                return;
            }
            if(!GameManager.sl_qml_FileExists(Global.toQtPath(textMapBlockImageURL.text))) {
                open();
                //visible = true;
                labelDialogTips.text = "图块路径错误或文件不存在:" + Global.toQtPath(textMapBlockImageURL.text);
                Platform.showToast("图块路径错误或文件不存在");
                return;
            }



            //系统图片
            //if(dialogMapData.nChoiceType === 1) {
            if(checkboxSaveResource.checked) {
                //filepath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapResourceDirName + Platform.separator() + textMapBlockResourceName.text;
                let ret = GameManager.sl_qml_CopyFile(Global.toQtPath(textMapBlockImageURL.text), GameMakerGlobal.mapResourceURL(textMapBlockResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelDialogTips.text = "拷贝到资源目录失败";
                    Platform.showToast("拷贝到资源目录失败");
                    //console.debug("[mainMapEditor]Copy ERROR:", filepath);

                    //root.forceActiveFocus();
                    return;
                }

                //textMapBlockImageURL.text = Global.toQMLPath(filepath);
            }
            else {  //资源图库
                //console.debug("ttt2:", filepath);

                //textMapBlockImageURL.text = filepath;

                //console.debug("ttt", textMapBlockImageURL.text, Qt.resolvedUrl(textMapBlockImageURL.text))
            }
            textMapBlockImageURL.text = Global.toQMLPath(GameMakerGlobal.mapResourceURL(textMapBlockResourceName.text));


            //创建地图工作

            if(dialogMapData.nCreateMapType === 1) {
                //loader.setSource("./MapEditor.qml", {});
                //item.createNewMap({MapBlockSize: [30, 30], MapSize: [20, 20]});
                loader.item.createNewMap({MapSize: [parseInt(textMapWidth.text), parseInt(textMapHeight.text)],
                                             MapBlockSize: [parseInt(textBlockWidth.text), parseInt(textBlockHeight.text)],
                                             MapBlockImage: [textMapBlockResourceName.text]
                                         });

                //loader.item.testFresh();

            }
            else if(dialogMapData.nCreateMapType === 2) {

                dialogMapData.mapData.MapSize[0] = textMapWidth.text;
                dialogMapData.mapData.MapSize[1] = textMapHeight.text;
                dialogMapData.mapData.MapBlockSize[0] = textBlockWidth.text;
                dialogMapData.mapData.MapBlockSize[1] = textBlockHeight.text;
                dialogMapData.mapData.MapBlockImage[0] = textMapBlockResourceName.text;

                loader.item.openMap(dialogMapData.mapData);

            }

            textMapBlockImageURL.text = "";
            textMapBlockResourceName.text = "";
            textMapBlockResourceName.enabled = true;
            labelDialogTips.text = "";
            textMapBlockImageURL.enabled = false;
            textMapBlockResourceName.enabled = true;


            //visible = false;
            //dialogMapData.focus = false;
            loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            loader.item.forceActiveFocus();

            //console.log("Ok clicked");
        }
        onRejected: {
            textMapBlockImageURL.text = "";
            textMapBlockResourceName.text = "";
            textMapBlockResourceName.enabled = true;
            labelDialogTips.text = "";


            root.forceActiveFocus();


            //console.log("Cancel clicked");
            /*鹰：这点组件树的focus有点奇怪
            let p = dialogMapData;
            let n = 20;
            while(n > 0 && p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
                --n;
            }

            root.focus = true;
            dialogMapData.focus = true;
            root.parent.parent.focus = true;
            console.debug(root.parent.parent.focus);


            p = dialogMapData;
            while(p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
            }*/
        }

    }


    Dialog1.FileDialog {
        id: filedialogOpenMapBlock
        title: "选择地图块文件"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png *.bmp)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            //root.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.forceActiveFocus();

            console.debug("[mainMapEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textMapBlockImageURL.text = Platform.getRealPathFromURI(fileUrl);
            else
                textMapBlockImageURL.text = GameManager.sl_qml_UrlDecode(fileUrl);

            textMapBlockResourceName.text = textMapBlockImageURL.text.slice(textMapBlockImageURL.text.lastIndexOf("/") + 1);


            textMapBlockImageURL.enabled = true;
            textMapBlockResourceName.enabled = true;


            checkboxSaveResource.checked = true;
            checkboxSaveResource.enabled = false;


            //鹰（Image的BUG）：3/3改这里
            //canvasMapBlock.loadImage(fileUrl);
            ////canvasMapBlock.requestPaint(); //重新绘图


            //console.log("You chose: " + fileDialog.fileUrls);
            //Qt.quit();
        }
        onRejected: {
            //root.forceActiveFocus();


            //s_close();
            console.debug("[mainMapEditor]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }

    DirList {
        id: dirlistMapBlockResource
        visible: false


        onClicked: {
            //let filepath = GameMakerGlobal.config.strProjectPath + "/" + GameMakerGlobal.config.strCurrentProjectName + "/" + GameMakerGlobal.config.strMapResourceDirName + "/" + item;

            textMapBlockImageURL.text = Global.toQMLPath(GameMakerGlobal.mapResourceURL(item));
            textMapBlockResourceName.text = item;
            //console.debug("DirList:", textMapBlockImageURL.text)

            textMapBlockImageURL.enabled = false
            textMapBlockResourceName.enabled = false;


            dialogMapData.visible = true;


            checkboxSaveResource.checked = false;
            checkboxSaveResource.enabled = false;


            root.focus = true;
            visible = false;


            //let cfg = File.read(fileUrl);
            //let cfg = GameManager.sl_qml_ReadFile(fileUrl);
            console.debug("[mainMapEditor]filepath", textMapBlockImageURL.text);
        }

        onCanceled: {
            dialogMapData.visible = true;

            //loader.visible = true;
            root.focus = true;
            //loader.item.focus = true;
            visible = false;
        }

        onRemoveClicked: {
            /*let dirUrl = Platform.getExternalDataPath() + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "Maps" + Platform.separator() + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainMapEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();
            */
        }
    }

    /*Dialog1.Dialog {
        id: fileDialogSave
        visible: false
          title: "Choose a date"
          standardButtons: Dialog1.StandardButton.Save | Dialog1.StandardButton.Cancel

          onAccepted: console.log("Saving the date ")

      }*/

    /*Dialog {
        id: dialogMapName
        title: "请输入地图数据"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            //let cfg = File.read(fileUrl);
            let cfg = GameManager.sl_qml_ReadFile(fileUrl);
            //console.debug("cfg", cfg);

            if(cfg === "")
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            loader.setSource("./MapEditor.qml", {});
            loader.item.openMap(cfg);
        }
        onRejected: {
            root.forceActiveFocus();


            //console.log("Cancel clicked");
        }

        ColumnLayout {
            width: parent.width

            RowLayout {
                width: parent.width
                Text {
                    text: qsTr("地图块大小（宽*高）：")
                }

                TextField {
                    id: textBlockWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                Text {
                    text: qsTr("*")
                }

                TextField {
                    id: textBlockHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }

            RowLayout {
                width: parent.width
                Text {
                    text: qsTr("地图大小（宽*高）：")
                }

                TextField {
                    id: textMapWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
                Text {
                    text: qsTr("*")
                }
                TextField {
                    id: textMapHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
        }
    }*/





    /*Dialog1.FileDialog {
        id: filedialogOpenMap
        title: "选择地图文件"
        selectMultiple: false
        //folder: shortcuts.home
        folder: Global._FixLocalPath_W(Platform.getExternalDataPath() + Platform.separator() + "Map")
        nameFilters: [ "Json files (*.json *.map *.jsn)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            let cfg = File.read(fileUrl);
            //let cfg = GameManager.sl_qml_ReadFile(fileUrl);
            console.debug("cfg", cfg, fileUrl);

            if(cfg === "")
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            //loader.setSource("./MapEditor.qml", {});
            loader.item.openMap(cfg);
        }
        onRejected: {
            root.forceActiveFocus();
        }
        Component.onCompleted: {
        }
    }
    */



    DirList {
        id: dirListMaps
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


            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName + Platform.separator() + item + Platform.separator() + "map.json";
            //let cfg = File.read(filePath);
            let cfg = GameManager.sl_qml_ReadFile(filePath);
            console.debug("[mainMapEditor]filePath：", filePath);

            if(cfg === "")
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            //loader.setSource("./MapEditor.qml", {});
            //loader.item.openMap(cfg);


            dialogMapData.nCreateMapType = 2;

            dialogMapData.mapData = cfg;

            textMapWidth.text = cfg.MapSize[0];
            textMapHeight.text = cfg.MapSize[1];
            textBlockWidth.text = cfg.MapBlockSize[0];
            textBlockHeight.text = cfg.MapBlockSize[1];
            textMapBlockImageURL.text = Global.toQMLPath(GameMakerGlobal.mapResourceURL(cfg.MapBlockImage[0]));
            textMapBlockResourceName.text = cfg.MapBlockImage[0];
            //textMapBlockResourceName.text = textMapBlockImageURL.text.slice(textMapBlockImageURL.text.lastIndexOf("/") + 1);
            textMapBlockResourceName.enabled = false;

            dialogMapData.open();


            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            root.focus = true;
            visible = false;

        }

        onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName + Platform.separator() + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[mainMapEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);

                forceActiveFocus();
            };
            dialogCommon.fOnRejected = ()=>{
                forceActiveFocus();
            };
            dialogCommon.open();
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

        property alias text: textDialogTips.text



        visible: false
        anchors.centerIn: parent

        title: "深林孤鹰提示"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        Text {
            id: textDialogTips
            //text: qsTr("text")
        }


        onAccepted: {
            if(fOnAccepted)fOnAccepted();
            console.debug("[mainMapEditor]onAccepted");
        }
        onRejected: {
            if(fOnRejected)fOnRejected();
            console.debug("[mainMapEditor]onRejected");
        }
    }



    QtObject {
        id: _private

    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[mainMapEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainMapEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainMapEditor]key:", event, event.key, event.text)
    }



    Component.onCompleted: {

    }
}
