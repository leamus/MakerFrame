import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



Rectangle {
    id: root


    signal s_close();
    onS_close: {
        imageReview.visible = false;
    }


    function init() {
        _private.arrImages = FrameManager.sl_qml_listDir(GameMakerGlobal.imageResourceURL(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
        //console.debug("[mainImageEditor]_private.arrImages", JSON.stringify(_private.arrImages))
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: listview

            Layout.fillHeight: true
            Layout.fillWidth: true


            clip: true

            //snapMode: ListView.SnapOneItem
            //orientation:ListView.Horizontal

            model: _private.arrImages

            delegate: L_ListItem {
                text: modelData
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.Name);

                    //textImageName.text = modelData;

                    console.debug(JSON.stringify(modelData));
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.Name);
                    //_private.arrImages.splice(index, 1);
                    //_private.arrImages = _private.arrImages;

                    dialogCommon.show({
                        Msg: '确认删除？',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function(){
                            root.forceActiveFocus();

                            FrameManager.sl_qml_DeleteFile(GameMakerGlobal.imageResourceURL(modelData));
                            _private.refresh();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });
                }
            }

            ScrollBar.vertical: ScrollBar { }
            //ScrollIndicator.vertical: ScrollIndicator { }

        }


        /*RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            TextField {
                id: textImageName

                Layout.preferredWidth: 100
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "图片名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            ColorButton {
                id: buttonAddImage

                Layout.preferredWidth: 60

                text: "新增"
                onButtonClicked: {
                    filedialog.open();
                }
            }

            ColorButton {
                id: buttonModifyImage

                Layout.preferredWidth: 60

                text: "修改"
                onButtonClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    dialogCommon.show({
                        Msg: '请输入新文件名',
                        Input: _private.arrImages[listview.currentIndex],
                        Buttons: Dialog.Yes,
                        OnAccepted: function(){
                            root.forceActiveFocus();

                            let newFileName = dialogCommon.input.trim();
                            if(_private.arrImages.indexOf(newFileName) >= 0) {
                                if(_private.arrImages.indexOf(newFileName) === listview.currentIndex)
                                    return;

                                dialogCommon.msg = '文件名重复，请重新输入';
                                dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                                dialogCommon.open();
                            }
                            else {
                                let ret = FrameManager.sl_qml_RenameFile(GameMakerGlobal.imageResourceURL(_private.arrImages[listview.currentIndex]), GameMakerGlobal.imageResourceURL(newFileName));
                                if(ret <= 0) {
                                    Platform.showToast("拷贝资源失败，是否目录不可写？" + newFileName);
                                    //console.debug("[mainImageEditor]Copy ERROR:", filepath);
                                    return;
                                }
                                _private.refresh();
                            }
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });
                }
            }

            ColorButton {
                id: buttonPlayImage

                Layout.preferredWidth: 60

                text: "显示"
                onButtonClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    imageReview.source = Global.toURL(GameMakerGlobal.imageResourceURL(_private.arrImages[listview.currentIndex]));
                    imageReview.visible = true;

                    //console.debug("image:", textImageName.text, imageReview.source);
                    //console.debug("resolve:", Qt.resolvedUrl(textImageName.text), Qt.resolvedUrl(GameMakerGlobal.imageResourceURL(textImageName.text)))
                    //console.debug("file:", Global.toURL(GameMakerGlobal.imageResourceURL(textImageName.text)), FrameManager.sl_qml_FileExists(GameMakerGlobal.imageResourceURL(textImageName.text)));
                }
            }

        }
    }


    Image {
        id: imageReview
        anchors.fill: parent
        visible: false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                imageReview.visible = false;
            }
        }
    }


    Dialog1.FileDialog {
        id: filedialog

        title: "选择音乐文件"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.jpeg *.bmp *.gif *.png)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            console.debug("[mainImageEditor]You chose: " + fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === "android") {
                if(strFileUrl.indexOf("primary") >= 0) {
                    textImageResourceName.text = "file:/storage/emulated/0/" + strFileUrl.substr(strFileUrl.indexOf("%3A")+3);
                }
                else if(strFileUrl.indexOf("document/") >= 0) {
                    let tt = strFileUrl.indexOf("%3A");
                    textImageResourceName.text = "file:/storage/" + strFileUrl.slice(strFileUrl.indexOf("/document/") + "/document/".length, tt) + "/" + strFileUrl.slice(tt + 3);
                }
                else
                    textImageResourceName.text = fileUrl;
            }
            else
                textImageResourceName.text = fileUrl;
            */

            let path;
            if(Qt.platform.os === "android")
                path = Platform.getRealPathFromURI(fileUrl);
            else
                path = FrameManager.sl_qml_UrlDecode(fileUrl);

            let tIndex = path.lastIndexOf("/");
            let filename = tIndex > 0 ? path.slice(tIndex + 1) : "";
            //let extname = path.lastIndexOf(".") > 0 ? path.slice(path.lastIndexOf(".")) : "";


            dialogCommon.show({
                Msg: '请输入新文件名',
                Input: filename,
                Buttons: Dialog.Yes,
                OnAccepted: function(){
                    root.forceActiveFocus();

                    let newFileName = dialogCommon.input.trim();
                    if(_private.arrImages.indexOf(newFileName) >= 0) {
                        dialogCommon.msg = '文件名重复，请重新输入';
                        dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                        dialogCommon.open();
                    }
                    else {
                        let ret = FrameManager.sl_qml_CopyFile(Global.toPath(path), GameMakerGlobal.imageResourceURL(newFileName), true);
                        if(ret <= 0) {
                            Platform.showToast("拷贝资源失败，是否目录不可写？" + newFileName);
                            //console.debug("[mainImageEditor]Copy ERROR:", filepath);
                            return;
                        }
                        _private.refresh();
                    }
                },
                OnRejected: ()=>{
                    root.forceActiveFocus();
                },
            });
        }

        onRejected: {
            //gameMap.forceActiveFocus();

            console.debug("[mainImageEditor]onRejected")
            //Qt.quit();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QtObject {
        id: _private

        //图片资源数据
        property var arrImages: ([])


        function refresh() {
            let index = listview.currentIndex;

            _private.arrImages = FrameManager.sl_qml_listDir(GameMakerGlobal.imageResourceURL(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);

            if(_private.arrImages.length === 0)
                listview.currentIndex = -1;
            else if(index >= _private.arrImages.length) {
                listview.currentIndex = _private.arrImages.length - 1;
                //textImageName.text = _private.arrImages[listview.currentIndex];
            }
            else {
                listview.currentIndex = index;
                //textImageName.text = _private.arrImages[listview.currentIndex];
            }

        }
    }

    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainImageEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainImageEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainImageEditor]key:", event, event.key, event.text);
    }



    Component.onCompleted: {

    }
}
