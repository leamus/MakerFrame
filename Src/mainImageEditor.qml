import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();
    onSg_close: {
        _private.setImageVisible(false);
    }



    function $load(...params) {
        //_private.arrImages = $Frame.sl_dirList(GameMakerGlobal.imageResourcePath(), [], 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
        //console.debug('[mainImageEditor]_private.arrImages', JSON.stringify(_private.arrImages))
        _private.refresh();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }


    ColumnLayout {
        anchors.fill: parent

        L_List {
            id: listview

            Layout.fillHeight: true
            Layout.fillWidth: true

            color: Global.style.backgroundColor
            colorText: Global.style.primaryTextColor

            bHighLightSelected: true



            onSg_clicked: {
                //listview.listview.currentIndex = index;
                //root.clicked(index, modelData.Name);

                //textImageName.text = modelData;

                console.debug('[mainImageEditor]onSg_clicked:', index, item);
            }

            onSg_doubleClicked: {
                imageReview.source = GameMakerGlobal.imageResourceURL(item);

                _private.setImageVisible(true);

                console.debug('[mainImageEditor]onSg_doubleClicked:', index, item);
            }

            onSg_removeClicked: {
                //console.debug('delete', modelData);
                //root.removeClicked(index, modelData.Name);
                //_private.arrImages.splice(index, 1);
                //_private.arrImages = _private.arrImages;

                $dialog.show({
                    Msg: '确认删除 <font color="red">' + item + '</font> ？',
                    Buttons: Dialog.Ok | Dialog.Cancel,
                    OnAccepted: function() {
                        //root.forceActiveFocus();

                        $Frame.sl_fileDelete(GameMakerGlobal.imageResourcePath(item));
                        _private.refresh();
                    },
                    OnRejected: ()=>{
                        //root.forceActiveFocus();
                    },
                });
            }

            onSg_canceled: {
                sg_close();
            }
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

                text: ''
                placeholderText: '图片名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50

            Button {
                id: buttonAddImage

                //Layout.preferredWidth: 60

                text: '新增'
                onClicked: {
                    filedialog.open();
                }
            }

            Button {
                id: buttonModifyImage

                //Layout.preferredWidth: 60

                text: '修改'
                onClicked: {
                    if(listview.listview.currentIndex < 0)
                        return;

                    let oldFileName = listview.listview.model.get(listview.listview.currentIndex).Name;
                    //let oldFileName = _private.arrImages[listview.listview.currentIndex];

                    $dialog.show({
                        Msg: '请输入新文件名',
                        Input: oldFileName,
                        Buttons: Dialog.Save | Dialog.Cancel,
                        OnAccepted: function() {
                            //root.forceActiveFocus();

                            let newFileName = $dialog.input.trim();
                            //if(_private.arrImages.indexOf(newFileName) >= 0) {
                            if(listview.listData.indexOf(newFileName) >= 0) {
                                if(newFileName === oldFileName)
                                    return;

                                $dialog.msg = '文件名重复，请重新输入';
                                //$dialog.standardButtons = Dialog.Yes | Dialog.Cancel;
                                $dialog.show();
                                //$dialog.forceActiveFocus();
                            }
                            else {
                                let ret = $Frame.sl_fileRename(GameMakerGlobal.imageResourcePath(oldFileName), GameMakerGlobal.imageResourcePath(newFileName));
                                if(ret <= 0) {
                                    $Platform.sl_showToast('重命名资源失败，请检查是否名称已存在或目录不可写' + newFileName);
                                    console.error('[!mainImageEditor]RenameFile ERROR:', GameMakerGlobal.imageResourcePath(oldFileName), GameMakerGlobal.imageResourcePath(newFileName));
                                    return;
                                }
                                _private.refresh();
                            }
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                    });
                }
            }

            Button {
                id: buttonPlayImage

                //Layout.preferredWidth: 60

                text: '显示'
                onClicked: {
                    if(listview.listview.currentIndex < 0)
                        return;

                    imageReview.source = GameMakerGlobal.imageResourceURL(listview.listview.model.get(listview.listview.currentIndex).Name);

                    _private.setImageVisible(true);

                    //console.debug('image:', textImageName.text, imageReview.source);
                    //console.debug('resolve:', Qt.resolvedUrl(textImageName.text), Qt.resolvedUrl(GameMakerGlobal.imageResourcePath(textImageName.text)))
                    //console.debug('file:', GameMakerGlobal.imageResourceURL(textImageName.text), $Frame.sl_fileExists(GameMakerGlobal.imageResourcePath(textImageName.text)));
                }
            }
        }
    }


    Mask {
        id: maskImage

        visible: false
        //opacity: 0
        //anchors.fill: parent
        width: parent.width
        height: parent.height

        //color: 'transparent'
        color: Global.style.backgroundColor
        //radius: 9



        //因为使用了Mask，Mask的MouseArea会屏蔽PinchHandler，所以必须再定义一个组件MultiPointTouchArea，否则PinchHandler不起作用
        MultiPointTouchArea {
            anchors.fill: parent
            maximumTouchPoints: 1
            onPressed: {
                console.debug('[mainImageEditor]onPressed', touchPoints);
            }
            onUpdated: {
                console.debug('[mainImageEditor]onUpdated', touchPoints);
            }
            onTouchUpdated: {
                console.debug('[mainImageEditor]onTouchUpdated', touchPoints);
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
            drag.target: imageReview
            onWheel: {
                if(wheel.angleDelta.y > 0) {
                    imageReview.scale *= 1.2;
                }
                else {
                    imageReview.scale *= 0.8;
                }
            }
        }

        AnimatedImage {
        //Image {
            id: imageReview

            //anchors.fill: parent

            //anchors.centerIn: parent
            transformOrigin: Item.Center


            Keys.onEscapePressed: function(event) {
                _private.setImageVisible(false);
                event.accepted = true;
            }
            Keys.onBackPressed: function(event) {
                _private.setImageVisible(false);
                event.accepted = true;
            }
        }
    }



    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: '选择图片文件'
        //folder: shortcuts.home
        nameFilters: [ 'Image files (*.jpg *.jpeg *.bmp *.gif *.png)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            console.debug('[mainImageEditor]You chose:', fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === 'android') {
                if(strFileUrl.indexOf('primary') >= 0) {
                    textImageResourceName.text = 'file:/storage/emulated/0/' + strFileUrl.substr(strFileUrl.indexOf('%3A')+3);
                }
                else if(strFileUrl.indexOf('document/') >= 0) {
                    let tt = strFileUrl.indexOf('%3A');
                    textImageResourceName.text = 'file:/storage/' + strFileUrl.slice(strFileUrl.indexOf('/document/') + '/document/'.length, tt) + '/' + strFileUrl.slice(tt + 3);
                }
                else
                    textImageResourceName.text = fileUrl.toString();
            }
            else
                textImageResourceName.text = fileUrl.toString();
            */

            let path;
            if(Qt.platform.os === 'android')
                path = $Platform.sl_getRealPathFromURI(fileUrl.toString());
            else
                path = $Frame.sl_urlDecode(fileUrl.toString());

            let tIndex = path.lastIndexOf('/');
            let filename = tIndex > 0 ? path.slice(tIndex + 1) : '';


            $dialog.show({
                Msg: '请输入新文件名',
                Input: filename,
                Buttons: Dialog.Save | Dialog.Cancel,
                OnAccepted: function() {
                    //root.forceActiveFocus();

                    let newFileName = $dialog.input.trim();
                    //if(_private.arrImages.indexOf(newFileName) >= 0) {
                    if(listview.listData.indexOf(newFileName) >= 0) {
                        $dialog.msg = '文件名重复，请重新输入';
                        //$dialog.standardButtons = Dialog.Yes | Dialog.Cancel;
                        $dialog.show();
                        //$dialog.forceActiveFocus();
                    }
                    else {
                        let ret = $Frame.sl_fileCopy($GlobalJS.toPath(path), GameMakerGlobal.imageResourcePath(newFileName), true);
                        if(ret <= 0) {
                            $Platform.sl_showToast('拷贝资源失败，是否目录不可写？' + newFileName);
                            console.error('[!mainImageEditor]Copy ERROR:', fileUrl, path, $GlobalJS.toPath(path), GameMakerGlobal.imageResourcePath(newFileName));
                            return;
                        }
                        _private.refresh();
                    }
                },
                OnRejected: ()=>{
                    //root.forceActiveFocus();
                },
            });
        }

        onRejected: {
            console.debug('[mainImageEditor]onRejected');
            //gameMap.forceActiveFocus();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


        //图片资源数据
        //property var arrImages: ([])


        function refresh() {
            let index = listview.listview.currentIndex;

            let arrImages = listview.show(GameMakerGlobal.imageResourcePath(), [], /*0x001 | */0x002 | 0x2000 | 0x4000);

            if(arrImages.length === 0)
                listview.listview.currentIndex = -1;
            else if(index >= arrImages.length) {
                listview.listview.currentIndex = arrImages.length - 1;
                //textImageName.text = listview.listview.model.get(listview.listview.currentIndex).Name;    //arrImages[listview.listview.currentIndex];
            }
            else if(index < 0) {
                listview.listview.currentIndex = 0;
                //textImageName.text = listview.listview.model.get(listview.listview.currentIndex).Name;    //arrImages[listview.listview.currentIndex];
            }
            else {
                listview.listview.currentIndex = index;
                //textImageName.text = listview.listview.model.get(listview.listview.currentIndex).Name;    //arrImages[listview.listview.currentIndex];
            }
        }

        function setImageVisible(visible) {
            maskImage.visible = visible;
            if(visible) {
                imageReview.forceActiveFocus();

                let rX = root.width / imageReview.sourceSize.width;
                let rY = root.height / imageReview.sourceSize.height;

                if(Math.min(rX, rY) < 1) //如果 原图尺寸大于屏幕尺寸，则缩小图片适应屏幕
                    imageReview.scale = Math.min(rX, rY);
                //else //恢复尺寸
                //    imageReview.scale = 1;

                imageReview.anchors.centerIn = imageReview.parent;
                imageReview.anchors.centerIn = null;
            }
            else {
                imageReview.scale = 1;
                //imageReview.transform = 0;
                imageReview.rotation = 0;

                imageReview.source = '';


                root.forceActiveFocus();
            }
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainImageEditor]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainImageEditor]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainImageEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainImageEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainImageEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainImageEditor]Component.onDestruction');
    }
}
