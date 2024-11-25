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


    signal sg_close();
    onSg_close: {
        mediaPlayer.stop();
    }



    function init() {
        _private.arrMusic = FrameManager.sl_dirList(GameMakerGlobal.musicResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
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

            model: _private.arrMusic

            delegate: L_ListItem {
                height: 6.9 * Screen.pixelDensity
                colorText: Global.style.primaryTextColor
                text: modelData
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.Name);

                    //textMusicName.text = modelData;

                    console.debug(JSON.stringify(modelData));
                }

                onDoubleClicked: {
                    _private.playOrPause();
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.Name);
                    //_private.arrMusic.splice(index, 1);
                    //_private.arrMusic = _private.arrMusic;

                    dialogCommon.show({
                        Msg: '确认删除？',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            root.forceActiveFocus();

                            FrameManager.sl_fileDelete(GameMakerGlobal.musicResourcePath(modelData));
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
                id: textMusicName

                Layout.preferredWidth: 100
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "音乐名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }*/


        Slider {
            id: sliderMusic

            Layout.fillWidth: true
            //Layout.preferredHeight: 36

            enabled: mediaPlayer.playbackState !== MediaPlayer.StoppedState

            from: 0
            to: mediaPlayer.duration
            stepSize: 5000
            value: mediaPlayer.position


            onMoved: {
                //if(mediaPlayer.seekable)
                //    mediaPlayer.position = value;
                mediaPlayer.seek(value);

                //console.debug(value, position);
            }
            /*onValueChanged: {
                if(mediaPlayer.seekable)
                    mediaPlayer.position = value;

            }
            */
        }


        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                id: buttonAddMusic

                //Layout.preferredWidth: 60

                text: "新增"
                onClicked: {
                    filedialog.open();
                }
            }

            Button {
                id: buttonModifyMusic

                //Layout.preferredWidth: 60

                text: "修改"
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    dialogCommon.show({
                        Msg: '请输入新文件名',
                        Input: _private.arrMusic[listview.currentIndex],
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            root.forceActiveFocus();

                            let newFileName = dialogCommon.input.trim();
                            if(_private.arrMusic.indexOf(newFileName) >= 0) {
                                if(_private.arrMusic.indexOf(newFileName) === listview.currentIndex)
                                    return;

                                dialogCommon.msg = '文件名重复，请重新输入';
                                dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                                dialogCommon.open();
                            }
                            else {
                                let ret = FrameManager.sl_fileRename(GameMakerGlobal.musicResourcePath(_private.arrMusic[listview.currentIndex]), GameMakerGlobal.musicResourcePath(newFileName));
                                if(ret <= 0) {
                                    Platform.sl_showToast("重命名资源失败，请检查是否名称已存在或目录不可写" + newFileName);
                                    console.error("[mainMusicEditor]RenameFile ERROR:", GameMakerGlobal.musicResourcePath(_private.arrMusic[listview.currentIndex]), GameMakerGlobal.musicResourcePath(newFileName));
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
                id: buttonPlayMusic

                //Layout.preferredWidth: 60

                text: mediaPlayer.playbackState === MediaPlayer.PlayingState ? '暂停' : '播放'
                onClicked: {
                    if(listview.currentIndex < 0)
                        return;

                    _private.playOrPause();
                }
            }

            Button {
                id: buttonStopMusic

                //Layout.preferredWidth: 60

                text: "停止"
                onClicked: {
                    mediaPlayer.stop();
                }
            }
        }
    }


    MediaPlayer {
        id: mediaPlayer

        //source: ''
        loops: MediaPlayer.Infinite
        notifyInterval: 200
        //playbackRate: 0.1
    }


    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: "选择音乐文件"
        //folder: shortcuts.home
        nameFilters: [ "Music files (*.wav *.mp3 *.wma *.ogg *.mid)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            console.debug("[mainMusicEditor]You chose: " + fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === "android") {
                if(strFileUrl.indexOf("primary") >= 0) {
                    textMusicResourceName.text = "file:/storage/emulated/0/" + strFileUrl.substr(strFileUrl.indexOf("%3A")+3);
                }
                else if(strFileUrl.indexOf("document/") >= 0) {
                    let tt = strFileUrl.indexOf("%3A");
                    textMusicResourceName.text = "file:/storage/" + strFileUrl.slice(strFileUrl.indexOf("/document/") + "/document/".length, tt) + "/" + strFileUrl.slice(tt + 3);
                }
                else
                    textMusicResourceName.text = fileUrl;
            }
            else
                textMusicResourceName.text = fileUrl;
            */

            let path;
            if(Qt.platform.os === "android")
                path = Platform.sl_getRealPathFromURI(fileUrl);
            else
                path = FrameManager.sl_urlDecode(fileUrl);

            let tIndex = path.lastIndexOf("/");
            let filename = tIndex > 0 ? path.slice(tIndex + 1) : "";


            dialogCommon.show({
                Msg: '请输入新文件名',
                Input: filename,
                Buttons: Dialog.Yes,
                OnAccepted: function() {
                    root.forceActiveFocus();

                    let newFileName = dialogCommon.input.trim();
                    if(_private.arrMusic.indexOf(newFileName) >= 0) {
                        dialogCommon.msg = '文件名重复，请重新输入';
                        dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
                        dialogCommon.open();
                    }
                    else {
                        let ret = FrameManager.sl_fileCopy(GlobalJS.toPath(path), GameMakerGlobal.musicResourcePath(newFileName), true);
                        if(ret <= 0) {
                            Platform.sl_showToast("拷贝资源失败，是否目录不可写？" + newFileName);
                            console.error("[mainMusicEditor]Copy ERROR:", fileUrl, path, GlobalJS.toPath(path), GameMakerGlobal.musicResourcePath(newFileName));
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

            console.debug("[mainMusicEditor]onRejected")
            //Qt.quit();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QtObject {
        id: _private

        //音乐资源数据
        property var arrMusic: ([])


        function refresh() {
            let index = listview.currentIndex;

            _private.arrMusic = FrameManager.sl_dirList(GameMakerGlobal.musicResourcePath(), "*", 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);

            if(_private.arrMusic.length === 0)
                listview.currentIndex = -1;
            else if(index >= _private.arrMusic.length) {
                listview.currentIndex = _private.arrMusic.length - 1;
                //textMusicName.text = _private.arrMusic[listview.currentIndex];
            }
            else {
                listview.currentIndex = index;
                //textMusicName.text = _private.arrMusic[listview.currentIndex];
            }
        }

        function playOrPause() {
            mediaPlayer.source = GameMakerGlobal.musicResourceURL(_private.arrMusic[listview.currentIndex]);
            if(mediaPlayer.playbackState === MediaPlayer.PlayingState)
                mediaPlayer.pause();
            else
                mediaPlayer.play();

            sliderMusic.forceActiveFocus();

            //console.debug("mediaPlayer:", textMusicName.text, mediaPlayer.source);
            //console.debug("resolve:", Qt.resolvedUrl(textMusicName.text), Qt.resolvedUrl(GameMakerGlobal.musicResourcePath(textMusicName.text)))
            //console.debug("file:", GameMakerGlobal.musicResourceURL(textMusicName.text), FrameManager.sl_fileExists(GameMakerGlobal.musicResourcePath(textMusicName.text)));
        }
    }


    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainMusicEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainMusicEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainMusicEditor]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainMusicEditor]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[mainMusicEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainMusicEditor]Component.onDestruction");
    }
}
