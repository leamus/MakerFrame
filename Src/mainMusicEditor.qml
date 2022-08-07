import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14


import _Global.Button 1.0


import "qrc:/QML"



Rectangle {
    id: root


    signal s_close();
    onS_close: {
        audio.stop();
    }


    function init() {

        let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "music.json";
        //let cfg = File.read(filePath);
        let cfg = GameManager.sl_qml_ReadFile(filePath);
        //console.debug("[mainMusicEditor]filePath：", filePath);

        if(cfg === "")
            return false;

        _private.arrMusic = JSON.parse(cfg)["MusicData"];
        //console.debug("[mainMusicEditor]_private.arrMusic", JSON.stringify(_private.arrMusic))

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

            model: _private.arrMusic

            delegate: FileItem {
                text: modelData.MusicName
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.MusicName);

                    textMusicName.text = modelData.MusicName;
                    textMusicResourceName.text = modelData.MusicURL;

                    console.debug(JSON.stringify(modelData));
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.MusicName);
                    _private.arrMusic.splice(index, 1);
                    _private.arrMusic = _private.arrMusic;
                }
            }
        }


        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            TextField {
                id: textMusicName

                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "音乐名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textMusicResourceName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            ColorButton {
                id: buttonChoiceMusicFile

                Layout.preferredWidth: 60

                text: "选择"
                onButtonClicked: {
                    filedialog.open();
                }
            }
            ColorButton {
                id: buttonAddMusic

                Layout.preferredWidth: 60

                text: "新增"
                onButtonClicked: {
                    if(textMusicName.text.trim().length === 0)
                        return;

                    for(let m in _private.arrMusic) {
                        if(_private.arrMusic[m]["MusicName"] === textMusicName.text) {
                            return;
                        }
                    }


                    let extname = textMusicResourceName.text.lastIndexOf(".") > 0 ? textMusicResourceName.text.slice(textMusicResourceName.text.lastIndexOf(".")) : "";
                    let filepath = textMusicName.text + extname;
                    let ret = GameManager.sl_qml_CopyFile(Global.toQtPath(textMusicResourceName.text), GameMakerGlobal.musicResourceURL(filepath), true);
                    if(ret <= 0) {

                        Platform.showToast("拷贝资源失败，是否重名或目录不可写？" + filepath);
                        //console.debug("[mainMusicEditor]Copy ERROR:", filepath);
                        return;
                    }
                    textMusicResourceName.text = filepath;



                    _private.arrMusic.push({"MusicName": textMusicName.text, "MusicURL": textMusicResourceName.text});
                    _private.arrMusic = _private.arrMusic;

                    listview.currentIndex = _private.arrMusic.length - 1;
                }
            }

            ColorButton {
                id: buttonModifyMusic

                Layout.preferredWidth: 60

                text: "修改"
                onButtonClicked: {
                    if(textMusicName.text.trim().length === 0)
                        return;

                    if(listview.currentIndex < 0 || listview.currentIndex >= _private.arrMusic.length)
                        return;


                    for(let m in _private.arrMusic) {
                        if(m === listview.currentIndex)
                            continue;

                        //console.debug(m, listview.currentIndex, typeof(m), typeof(listview.currentIndex), _private.arrMusic[m]["MusicName"])

                        if(_private.arrMusic[m]["MusicName"] === textMusicName.text) {
                            return;
                        }
                    }


                    //let index = listview.currentIndex;

                    _private.arrMusic[listview.currentIndex] = ({"MusicName": textMusicName.text, "MusicURL": textMusicResourceName.text});
                    _private.arrMusic = _private.arrMusic;

                    //listview.currentIndex = index;
                }
            }

            ColorButton {
                id: buttonPlayMusic

                Layout.preferredWidth: 60

                text: "试听"
                onButtonClicked: {

                    audio.source = Global.toQMLPath(GameMakerGlobal.musicResourceURL(textMusicResourceName.text));
                    audio.play();

                    console.debug("audio:", textMusicResourceName.text, audio.source);
                    console.debug("resolve:", Qt.resolvedUrl(textMusicResourceName.text), Qt.resolvedUrl(GameMakerGlobal.musicResourceURL(textMusicResourceName.text)))
                    console.debug("file:", Global.toQMLPath(GameMakerGlobal.musicResourceURL(textMusicResourceName.text)), GameManager.sl_qml_FileExists(GameMakerGlobal.musicResourceURL(textMusicResourceName.text)));
                }
            }

            ColorButton {
                id: buttonSave

                Layout.preferredWidth: 60

                text: "保存"
                onButtonClicked: {

                    let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "music.json";

                    let outputData = {};

                    outputData.Version = "0.6";
                    outputData.MusicData = _private.arrMusic;


                    //!!!导出为文件
                    //console.debug(JSON.stringify(outputData));
                    //let ret = File.write(path + Platform.separator() + 'map.json', JSON.stringify(outputData));
                    let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), filePath, 0);
                    //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

                }
            }
        }
    }


    Audio {
        id: audio
    }


    Dialog1.FileDialog {
        id: filedialog

        title: "选择音乐文件"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "Music files (*.wav *.mp3 *.wma *.ogg *.mid)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
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

            if(Qt.platform.os === "android")
                textMusicResourceName.text = Platform.getRealPathFromURI(fileUrl);
            else
                textMusicResourceName.text = GameManager.sl_qml_UrlDecode(fileUrl);
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

        property var arrMusic: ([])
    }

    //配置
    QtObject {
        id: _config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[mainMusicEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainMusicEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainMusicEditor]key:", event, event.key, event.text)
    }



    Component.onCompleted: {

    }
}
