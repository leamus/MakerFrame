import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal s_close();
    onS_close: {
        _private.setImageVisible(false);
    }



    function init() {
        _private.arrImages = FrameManager.sl_qml_listDir(GameMakerGlobal.imageResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
        //console.debug("[mainImageEditor]_private.arrImages", JSON.stringify(_private.arrImages))
    }



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
                height: 6.9 * Screen.pixelDensity

                colorText: Global.style.primaryTextColor
                text: modelData
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"
                strPath: GameMakerGlobal.imageResourceURL()

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.Name);

                    //textImageName.text = modelData;

                    console.debug(JSON.stringify(modelData));
                }

                onDoubleClicked: {
                    imageReview.source = GameMakerGlobal.imageResourceURL(_private.arrImages[listview.currentIndex]);

                    _private.setImageVisible(true);
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.Name);
                    //_private.arrImages.splice(index, 1);
                    //_private.arrImages = _private.arrImages;

                    dialogCommon.show({
                        Msg: '确认删除？',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            root.forceActiveFocus();

                            FrameManager.sl_qml_DeleteFile(GameMakerGlobal.imageResourcePath(modelData));
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

            Button {
                id: buttonAddImage

                Layout.preferredWidth: 60

                text: "新增"
                onClicked: {
                    filedialog.open();
                }
            }

            Button {
                id: buttonModifyImage

                Layout.preferredWidth: 60

                text: "修改"
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    dialogCommon.show({
                        Msg: '请输入新文件名',
                        Input: _private.arrImages[listview.currentIndex],
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
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
                                let ret = FrameManager.sl_qml_RenameFile(GameMakerGlobal.imageResourcePath(_private.arrImages[listview.currentIndex]), GameMakerGlobal.imageResourcePath(newFileName));
                                if(ret <= 0) {
                                    Platform.showToast("重命名资源失败，请检查是否名称已存在或目录不可写" + newFileName);
                                    console.error("[mainImageEditor]RenameFile ERROR:", GameMakerGlobal.imageResourcePath(_private.arrImages[listview.currentIndex]), GameMakerGlobal.imageResourcePath(newFileName));
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

            Button {
                id: buttonPlayImage

                Layout.preferredWidth: 60

                text: "显示"
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    imageReview.source = GameMakerGlobal.imageResourceURL(_private.arrImages[listview.currentIndex]);

                    _private.setImageVisible(true);

                    //console.debug("image:", textImageName.text, imageReview.source);
                    //console.debug("resolve:", Qt.resolvedUrl(textImageName.text), Qt.resolvedUrl(GameMakerGlobal.imageResourcePath(textImageName.text)))
                    //console.debug("file:", GameMakerGlobal.imageResourceURL(textImageName.text), FrameManager.sl_qml_FileExists(GameMakerGlobal.imageResourcePath(textImageName.text)));
                }
            }

        }
    }

    
    Mask {
        id: maskImage

        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height

        //color: 'transparent'
        color: Global.style.backgroundColor



        //因为使用了Mask，Mask的MouseArea会屏蔽PinchHandler，所以必须再定义一个组件MultiPointTouchArea，否则PinchHandler不起作用
        MultiPointTouchArea {
            anchors.fill: parent
            maximumTouchPoints: 1
            onPressed: {
                console.log('press', touchPoints);
            }
            onUpdated: {
                console.log('onupdated', touchPoints);
            }
            onTouchUpdated: {
                console.log('ontouchupdated', touchPoints);
            }


            //!!!不知为何，多次旋转移动后，就点不到itemTest了（点的是MultiPointTouchArea），应该是Qt的Bug，怎么改都无效（替换Mask、移动组件位置、修改z值等等）
            PinchHandler {
                id: pinchHandler

                target: imageReview
                ////pinch.dragAxis: Pinch.XAndYAxis
                //禁止旋转
                //maximumRotation: 0
                //minimumRotation: 0
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                _private.setImageVisible(false);
            }
            onWheel: {
                if(wheel.angleDelta.y > 0) {
                    imageReview.scale *= 1.2;
                }
                else {
                    imageReview.scale *= 0.8;
                }
            }
        }

        Image {
            id: imageReview

            //anchors.fill: parent

            //anchors.centerIn: parent
            transformOrigin: Item.Center


            Keys.onEscapePressed: {
                _private.setImageVisible(false);
                event.accepted = true;
                //Qt.quit();
            }
            Keys.onBackPressed: {
                _private.setImageVisible(false);
                event.accepted = true;
                //Qt.quit();
            }
        }

    }



    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: "选择图片文件"
        //folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.jpeg *.bmp *.gif *.png)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

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
                OnAccepted: function() {
                    root.forceActiveFocus();

                    let newFileName = dialogCommon.input.trim();
                    if(_private.arrImages.indexOf(newFileName) >= 0) {
                        dialogCommon.msg = '文件名重复，请重新输入';
                        dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                        dialogCommon.open();
                    }
                    else {
                        let ret = FrameManager.sl_qml_CopyFile(GlobalJS.toPath(path), GameMakerGlobal.imageResourcePath(newFileName), true);
                        if(ret <= 0) {
                            Platform.showToast("拷贝资源失败，是否目录不可写？" + newFileName);
                            console.error("[mainImageEditor]Copy ERROR:", fileUrl, path, GlobalJS.toPath(path), GameMakerGlobal.imageResourcePath(newFileName));
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

            _private.arrImages = FrameManager.sl_qml_listDir(GameMakerGlobal.imageResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);

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

        function setImageVisible(visible) {
            maskImage.visible = visible;
            if(visible) {
                imageReview.forceActiveFocus();

                let rX = root.width / imageReview.sourceSize.width;
                let rY = root.height / imageReview.sourceSize.height;

                if(Math.min(rX, rY) < 1)
                    imageReview.scale = Math.min(rX, rY);
                imageReview.anchors.centerIn = imageReview.parent;
                imageReview.anchors.centerIn = null;
                //imageReview.transform = 0;
                imageReview.rotation = 0;
            }
            else {
                //imageReview.scale = 1;

                root.forceActiveFocus();
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
