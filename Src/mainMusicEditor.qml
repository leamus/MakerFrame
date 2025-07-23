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
        mediaPlayer.stop();
    }



    function init() {
        //_private.arrMusic = $Frame.sl_dirList(GameMakerGlobal.musicResourcePath(), [], 0x001 | 0x002 | 0x2000 | 0x4000, 0x00);
        //console.debug('[mainMusicEditor]_private.arrMusic', JSON.stringify(_private.arrMusic))
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

                //textMusicName.text = modelData;

                console.debug('[mainMusicEditor]onSg_clicked:', index, item);
            }

            onSg_doubleClicked: {
                _private.playOrPause();

                console.debug('[mainMusicEditor]onSg_doubleClicked:', index, item);
            }

            onSg_removeClicked: {
                //console.debug('delete', modelData);
                //root.removeClicked(index, modelData.Name);
                //_private.arrMusic.splice(index, 1);
                //_private.arrMusic = _private.arrMusic;

                $dialog.show({
                    Msg: '确认删除 <font color="red">' + item + '</font> ？',
                    Buttons: Dialog.Ok | Dialog.Cancel,
                    OnAccepted: function() {
                        root.forceActiveFocus();

                        $Frame.sl_fileDelete(GameMakerGlobal.musicResourcePath(item));
                        _private.refresh();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
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
                id: textMusicName

                Layout.preferredWidth: 100
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '音乐名'

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

                Layout.preferredWidth: 60

                text: '新增'
                onClicked: {
                    filedialog.open();
                }
            }

            Button {
                id: buttonModifyMusic

                Layout.preferredWidth: 60

                text: '修改'
                onClicked: {
                    if(listview.listview.currentIndex < 0)
                        return;

                    let oldFileName = listview.listview.model.get(listview.listview.currentIndex).Name;
                    //let oldFileName = _private.arrMusic[listview.listview.currentIndex];

                    $dialog.show({
                        Msg: '请输入新文件名',
                        Input: oldFileName,
                        Buttons: Dialog.Save | Dialog.Cancel,
                        OnAccepted: function() {
                            root.forceActiveFocus();

                            let newFileName = $dialog.input.trim();
                            //if(_private.arrMusic.indexOf(newFileName) >= 0) {
                            if(listview.listData.indexOf(newFileName) >= 0) {
                                if(newFileName === oldFileName)
                                    return;

                                $dialog.msg = '文件名重复，请重新输入';
                                //$dialog.standardButtons = Dialog.Yes | Dialog.Cancel;
                                $dialog.show();
                                //$dialog.forceActiveFocus();
                            }
                            else {
                                let ret = $Frame.sl_fileRename(GameMakerGlobal.musicResourcePath(oldFileName), GameMakerGlobal.musicResourcePath(newFileName));
                                if(ret <= 0) {
                                    $Platform.sl_showToast('重命名资源失败，请检查是否名称已存在或目录不可写' + newFileName);
                                    console.error('[!mainMusicEditor]RenameFile ERROR:', GameMakerGlobal.musicResourcePath(oldFileName), GameMakerGlobal.musicResourcePath(newFileName));
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

                Layout.preferredWidth: 60

                text: mediaPlayer.playbackState === MediaPlayer.PlayingState ? '暂停' : '播放'
                onClicked: {
                    if(listview.listview.currentIndex < 0)
                        return;

                    _private.playOrPause();
                }
            }

            Button {
                id: buttonStopMusic

                Layout.preferredWidth: 60

                text: '停止'
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

        title: '选择音乐文件'
        //folder: shortcuts.home
        nameFilters: [ 'Music files (*.wav *.mp3 *.wma *.ogg *.mid)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            console.debug('[mainMusicEditor]You chose:', fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === 'android') {
                if(strFileUrl.indexOf('primary') >= 0) {
                    textMusicResourceName.text = 'file:/storage/emulated/0/' + strFileUrl.substr(strFileUrl.indexOf('%3A')+3);
                }
                else if(strFileUrl.indexOf('document/') >= 0) {
                    let tt = strFileUrl.indexOf('%3A');
                    textMusicResourceName.text = 'file:/storage/' + strFileUrl.slice(strFileUrl.indexOf('/document/') + '/document/'.length, tt) + '/' + strFileUrl.slice(tt + 3);
                }
                else
                    textMusicResourceName.text = fileUrl.toString();
            }
            else
                textMusicResourceName.text = fileUrl.toString();
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
                    root.forceActiveFocus();

                    let newFileName = $dialog.input.trim();
                    //if(_private.arrMusic.indexOf(newFileName) >= 0) {
                    if(listview.listData.indexOf(newFileName) >= 0) {
                        $dialog.msg = '文件名重复，请重新输入';
                        //$dialog.standardButtons = Dialog.Yes | Dialog.Cancel;
                        $dialog.show();
                        //$dialog.forceActiveFocus();
                    }
                    else {
                        let ret = $Frame.sl_fileCopy($GlobalJS.toPath(path), GameMakerGlobal.musicResourcePath(newFileName), true);
                        if(ret <= 0) {
                            $Platform.sl_showToast('拷贝资源失败，是否目录不可写？' + newFileName);
                            console.error('[!mainMusicEditor]Copy ERROR:', fileUrl, path, $GlobalJS.toPath(path), GameMakerGlobal.musicResourcePath(newFileName));
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
            console.debug('[mainVideoEditor]onRejected');
            //gameMap.forceActiveFocus();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QtObject {
        id: _private

        //音乐资源数据
        //property var arrMusic: ([])


        function refresh() {
            let index = listview.listview.currentIndex;

            let arrMusic = listview.show(GameMakerGlobal.musicResourcePath(), [], /*0x001 | */0x002 | 0x2000 | 0x4000);

            if(arrMusic.length === 0)
                listview.listview.currentIndex = -1;
            else if(index >= arrMusic.length) {
                listview.listview.currentIndex = arrMusic.length - 1;
                //textMusicName.text = listview.listview.model.get(listview.listview.currentIndex).Name;   //arrMusic[listview.listview.currentIndex];
            }
            else if(index < 0) {
                listview.listview.currentIndex = 0;
                //textMusicName.text = listview.listview.model.get(listview.listview.currentIndex).Name;   //arrMusic[listview.listview.currentIndex];
            }
            else {
                listview.listview.currentIndex = index;
                //textMusicName.text = listview.listview.model.get(listview.listview.currentIndex).Name;   //arrMusic[listview.listview.currentIndex];
            }
        }

        function playOrPause() {
            mediaPlayer.source = GameMakerGlobal.musicResourceURL(listview.listview.model.get(listview.listview.currentIndex).Name);    //arrMusic[listview.listview.model.get(listview.listview.currentIndex).Index]
            if(mediaPlayer.playbackState === MediaPlayer.PlayingState)
                mediaPlayer.pause();
            else
                mediaPlayer.play();

            sliderMusic.forceActiveFocus();

            //console.debug('mediaPlayer:', textMusicName.text, mediaPlayer.source);
            //console.debug('resolve:', Qt.resolvedUrl(textMusicName.text), Qt.resolvedUrl(GameMakerGlobal.musicResourcePath(textMusicName.text)))
            //console.debug('file:', GameMakerGlobal.musicResourceURL(textMusicName.text), $Frame.sl_fileExists(GameMakerGlobal.musicResourcePath(textMusicName.text)));
        }
    }


    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainMusicEditor]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainMusicEditor]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainMusicEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainMusicEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainMusicEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainMusicEditor]Component.onDestruction');
    }
}
