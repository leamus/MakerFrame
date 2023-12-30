import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal s_close();
    onS_close: {
        mediaPlayer.stop();
        itemVideo.visible = false;
    }



    function init() {
        _private.arrVideos = FrameManager.sl_qml_listDir(GameMakerGlobal.videoResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
        //console.debug("[mainVideoEditor]_private.arrVideos", JSON.stringify(_private.arrVideos))
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

            model: _private.arrVideos

            delegate: L_ListItem {
                height: 6.9 * Screen.pixelDensity
                colorText: Global.style.primaryTextColor
                text: modelData
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.Name);

                    //textVideoName.text = modelData;

                    console.debug(JSON.stringify(modelData));
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.Name);
                    //_private.arrVideos.splice(index, 1);
                    //_private.arrVideos = _private.arrVideos;

                    dialogCommon.show({
                        Msg: '确认删除？',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function(){
                            root.forceActiveFocus();

                            FrameManager.sl_qml_DeleteFile(GameMakerGlobal.videoResourcePath(modelData));
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
                id: textVideoName

                Layout.preferredWidth: 100
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "视频名"

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
                id: buttonAddVideo

                //Layout.preferredWidth: 60

                text: "新增"
                onClicked: {
                    filedialog.open();
                }
            }

            Button {
                id: buttonModifyVideo

                //Layout.preferredWidth: 60

                text: "修改"
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    dialogCommon.show({
                        Msg: '请输入新文件名',
                        Input: _private.arrVideos[listview.currentIndex],
                        Buttons: Dialog.Yes,
                        OnAccepted: function(){
                            root.forceActiveFocus();

                            let newFileName = dialogCommon.input.trim();
                            if(_private.arrVideos.indexOf(newFileName) >= 0) {
                                if(_private.arrVideos.indexOf(newFileName) === listview.currentIndex)
                                    return;

                                dialogCommon.msg = '文件名重复，请重新输入';
                                dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                                dialogCommon.open();
                            }
                            else {
                                let ret = FrameManager.sl_qml_RenameFile(GameMakerGlobal.videoResourcePath(_private.arrVideos[listview.currentIndex]), GameMakerGlobal.videoResourcePath(newFileName));
                                if(ret <= 0) {
                                    Platform.showToast("重命名资源失败，请检查是否名称已存在或目录不可写" + newFileName);
                                    console.error("[mainVideoEditor]RenameFile ERROR:", GameMakerGlobal.videoResourcePath(_private.arrVideos[listview.currentIndex]), GameMakerGlobal.videoResourcePath(newFileName));
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
                id: buttonPlayVideo

                //Layout.preferredWidth: 60

                text: "播放"
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    mediaPlayer.source = GameMakerGlobal.videoResourceURL(_private.arrVideos[listview.currentIndex]);
                    itemVideo.visible = true;
                    mediaPlayer.play();

                    //console.debug("video:", textVideoName.text, mediaPlayer.source);
                    //console.debug("resolve:", Qt.resolvedUrl(textVideoName.text), Qt.resolvedUrl(GameMakerGlobal.videoResourcePath(textVideoName.text)))
                    //console.debug("file:", GameMakerGlobal.videoResourceURL(textVideoName.text), FrameManager.sl_qml_FileExists(GameMakerGlobal.videoResourcePath(textVideoName.text)));
                }
            }

            Button {
                id: buttonStopVideo

                //Layout.preferredWidth: 60

                text: "停止"
                onClicked: {
                    mediaPlayer.stop();
                    itemVideo.visible = false;
                    //mediaPlayer.source = GameMakerGlobal.videoResourceURL(textVideoResourceName.text);
                }
            }
        }
    }


    Item {
        id: itemVideo
        anchors.fill: parent
        visible: false

        MediaPlayer {
            id: mediaPlayer

            source: ""
        }

        //渲染视频
        VideoOutput{
            id: videoOutput

            anchors.fill: parent
            source: mediaPlayer
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(mediaPlayer.playbackState === MediaPlayer.PlayingState)
                    mediaPlayer.pause();
                else
                    mediaPlayer.play();
            }
            onDoubleClicked: {
                itemVideo.visible = false;
                mediaPlayer.stop();
                mediaPlayer.source = '';
            }
        }
    }


    Dialog1.FileDialog {
        id: filedialog

        title: "选择视频文件"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "Video files (*.mp4 *.mpeg *.rm *.rmvb *.wmv)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            console.debug("[mainVideoEditor]You chose: " + fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === "android") {
                if(strFileUrl.indexOf("primary") >= 0) {
                    textVideoResourceName.text = "file:/storage/emulated/0/" + strFileUrl.substr(strFileUrl.indexOf("%3A")+3);
                }
                else if(strFileUrl.indexOf("document/") >= 0) {
                    let tt = strFileUrl.indexOf("%3A");
                    textVideoResourceName.text = "file:/storage/" + strFileUrl.slice(strFileUrl.indexOf("/document/") + "/document/".length, tt) + "/" + strFileUrl.slice(tt + 3);
                }
                else
                    textVideoResourceName.text = fileUrl;
            }
            else
                textVideoResourceName.text = fileUrl;
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
                    if(_private.arrVideos.indexOf(newFileName) >= 0) {
                        dialogCommon.msg = '文件名重复，请重新输入';
                        dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                        dialogCommon.open();
                    }
                    else {
                        let ret = FrameManager.sl_qml_CopyFile(GlobalJS.toPath(path), GameMakerGlobal.videoResourcePath(newFileName), true);
                        if(ret <= 0) {
                            Platform.showToast("拷贝资源失败，是否目录不可写？" + newFileName);
                            console.error("[mainVideoEditor]Copy ERROR:", fileUrl, path, GlobalJS.toPath(path), GameMakerGlobal.videoResourcePath(newFileName));
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

            console.debug("[mainVideoEditor]onRejected")
            //Qt.quit();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QtObject {
        id: _private

        //资源数据
        property var arrVideos: ([])


        function refresh() {
            let index = listview.currentIndex;

            _private.arrVideos = FrameManager.sl_qml_listDir(GameMakerGlobal.videoResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);

            if(_private.arrVideos.length === 0)
                listview.currentIndex = -1;
            else if(index >= _private.arrVideos.length) {
                listview.currentIndex = _private.arrVideos.length - 1;
                //textVideoName.text = _private.arrVideos[listview.currentIndex];
            }
            else {
                listview.currentIndex = index;
                //textVideoName.text = _private.arrVideos[listview.currentIndex];
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

        console.debug("[mainVideoEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainVideoEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainVideoEditor]key:", event, event.key, event.text);
    }


    Component.onCompleted: {

    }
}
