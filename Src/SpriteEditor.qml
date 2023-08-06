﻿import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


import "Core"
//import "File.js" as File



Rectangle {
    id: root



    signal s_close();
    onS_close: {
        //sprite.unload();
    }



    function newSprite() {

        textSpriteName.text = "";

        sprite.spriteSrc = "";
        textSpriteImageURL.text = "";
        textSpriteImageResourceName.text = "";
        textSpriteImageResourceName.enabled = false;
        //textSpriteFrameWidth.text = cfg.FrameSize[0].toString();
        //textSpriteFrameHeight.text = cfg.FrameSize[1].toString();
        //textSpriteFrameCount.text = cfg.FrameCount.toString();
        textSpriteFrameOffsetX.text = "0";
        textSpriteFrameOffsetY.text = "0";

        textSpriteFrameInterval.text = "200";
        //sprite.width = parseInt(textSpriteWidth.text);
        //sprite.height = parseInt(textSpriteHeight.text);
        //textSpriteWidth.text = cfg.SpriteSize[0].toString();
        //textSpriteHeight.text = cfg.SpriteSize[1].toString();

        sprite.soundeffectName = "";
        textSpriteSoundURL.text = "";
        textSpriteSoundResourceName.text = "";
        textSpriteSoundResourceName.enabled = false;
        textSoundDelay.text = "0";
        textSpriteOpacity.text = "1";
        textSpriteFrameXScale.text = "1";
        textSpriteFrameYScale.text = "1";

        _private.refreshSprite();
    }

    function openSprite(spriteName) {

        let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName + GameMakerGlobal.separator + "sprite.json";
        //let cfg = File.read(filePath);
        let cfg = FrameManager.sl_qml_ReadFile(filePath);
        console.debug("[SpriteEditor]filePath：", filePath);

        if(cfg === "")
            return false;
        cfg = JSON.parse(cfg);
        //console.debug("cfg", cfg);
        //loader.setSource("./MapEditor_1.qml", {});


        console.debug("[SpriteEditor]openSprite:", JSON.stringify(cfg))

        //cfg.Version;
        //cfg.SpriteType;
        textSpriteName.text = cfg.SpriteName;

        sprite.spriteSrc = Global.toURL(GameMakerGlobal.spriteResourceURL(cfg.Image));
        //textSpriteImageURL.text = cfg.Image;
        //textSpriteImageResourceName.text = textSpriteImageURL.text.slice(textSpriteImageURL.text.lastIndexOf("/") + 1);
        textSpriteImageResourceName.text = cfg.Image;
        textSpriteImageResourceName.enabled = false;
        textSpriteImageURL.text = Global.toURL(GameMakerGlobal.spriteResourceURL(cfg.Image));
        textSpriteFrameWidth.text = cfg.FrameSize[0].toString();
        textSpriteFrameHeight.text = cfg.FrameSize[1].toString();
        textSpriteFrameCount.text = cfg.FrameCount.toString();
        textSpriteFrameOffsetX.text = cfg.OffsetIndex[0].toString();
        textSpriteFrameOffsetY.text = cfg.OffsetIndex[1].toString();

        textSpriteFrameInterval.text = cfg.FrameInterval.toString();
        //sprite.width = parseInt(textSpriteWidth.text);
        //sprite.height = parseInt(textSpriteHeight.text);
        textSpriteWidth.text = cfg.SpriteSize[0].toString();
        textSpriteHeight.text = cfg.SpriteSize[1].toString();

        if(cfg.Sound) {
            textSpriteSoundURL.text = Global.toURL(GameMakerGlobal.soundResourceURL(cfg.Sound));
            sprite.soundeffectName = cfg.Sound;
        }
        else {
            textSpriteSoundURL.text = "";
            sprite.soundeffectName = "";
        }

        textSpriteSoundResourceName.text = cfg.Sound;
        textSpriteSoundResourceName.enabled = false;
        textSoundDelay.text = cfg.SoundDelay.toString();
        textSpriteOpacity.text = cfg.Opacity.toString();
        textSpriteFrameXScale.text = cfg.XScale.toString();
        textSpriteFrameYScale.text = cfg.YScale.toString();

        _private.refreshSprite();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    //主界面
    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "特效图片"
                onButtonClicked: {
                    dialogSpriteImageData.open();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "特效音乐"
                onButtonClicked: {
                    dialogSpriteSoundData.open();
                }
            }

            ColorButton {
                visible: false

                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "刷新"
                onButtonClicked: {
                    _private.refreshSprite();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "保存"
                onButtonClicked: {

                    dialogSaveSprite.open();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "原图"
                onButtonClicked: {
                    if(textSpriteImageURL.text)
                        _private.showImage();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "帮助"
                onButtonClicked: {

                    rootGameMaker.showMsg('
  特效大小：游戏中显示的大小；
  X/Y轴缩放：可以在x、y方向进行缩放，且可以为负数（x、y轴的镜像）；
  透明度：0-1之间的小数；
  每帧的宽高：将图片切割为每一帧的大小（如果图片显示有问题，则可能这里不正确）；
  帧数：连续播放的帧数；
  帧偏移：从第几列、第几行开始（然后连续的n张）；
  帧切换速度：你懂的；
  音效播放延时：帧播放多少毫秒后开始播放音效；

')
                }
            }

            ColorButton {
                visible: false
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "Test"
                onButtonClicked: {
                    /*sprite.sprite.running = true;
                    console.debug("[Sprite]test", sprite.sprite, sprite.sprite.state, sprite.sprite.currentSprite)
                    console.debug(sprite.sprite.sprites);
                    for(let s in sprite.sprite.sprites) {
                        console.debug(sprite.sprite.sprites[s].frameY);
                        sprite.sprite.sprites[s].frameY = 20*s;
                        console.debug(sprite.sprite.sprites[s].frameY);
                    }*/
                    dialogScript.open();
                }
            }

        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "特效大小"
            }

            TextField {
                id: textSpriteWidth

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "50"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "*"
            }

            TextField {
                id: textSpriteHeight

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "50"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "透明度"
            }

            TextField {
                id: textSpriteOpacity

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "X/Y轴缩放"
            }

            TextField {
                id: textSpriteFrameXScale

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            TextField {
                id: textSpriteFrameYScale

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }
        }


        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "每帧的宽高"
            }

            TextField {
                id: textSpriteFrameWidth

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "37"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "*"
            }
            TextField {
                id: textSpriteFrameHeight

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "58"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "帧数"
            }

            TextField {
                id: textSpriteFrameCount

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "3"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

        }


        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "帧偏移（列/行）"
            }

            TextField {
                id: textSpriteFrameOffsetX

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }
            TextField {
                id: textSpriteFrameOffsetY

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "帧切换速度（ms）"
            }

            TextField {
                id: textSpriteFrameInterval

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "100"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "音效播放延时"
            }

            TextField {
                id: textSoundDelay

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshSprite();
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.fillHeight: true

            Rectangle {
                id: rectSprite
                Layout.alignment: Qt.AlignTop | Qt.AlignRight

                //Layout.preferredWidth: parseInt(textSpriteWidth.text)
                //Layout.preferredHeight: parseInt(textSpriteHeight.text)

                color: 'transparent'
                border {
                    width: 1
                    color: 'lightgray'
                }

                SpriteEffect {
                    id: sprite

                    anchors.fill: parent

                    test: true
                    nType: 1
                    //width: 37;
                    //height: 58;

                    //sizeFrame: Qt.size(37, 58);
                    /*nFrameCount: 3;
                    interval: 100;*/

                    onS_clicked: {
                        root.forceActiveFocus();
                    }
                }
            }

        }
    }






    Dialog1.FileDialog {
        id: filedialogOpenSpriteImage
        title: "选择特效图片"
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


            console.debug("[SpriteEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textSpriteImageURL.text = Platform.getRealPathFromURI(fileUrl);
            else
                textSpriteImageURL.text = FrameManager.sl_qml_UrlDecode(fileUrl);

            textSpriteImageResourceName.text = textSpriteImageURL.text.slice(textSpriteImageURL.text.lastIndexOf("/") + 1);


            textSpriteImageURL.enabled = true;
            textSpriteImageResourceName.enabled = true;


            checkboxSaveSpriteImageResource.checked = true;
            checkboxSaveSpriteImageResource.enabled = false;


            //console.log("You chose: " + fileDialog.fileUrls);
            //Qt.quit();
        }
        onRejected: {
            //root.forceActiveFocus();

            console.debug("[SpriteEditor]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }


    Dialog {
        id: dialogSpriteImageData

        //1图片，2素材
        //property int nChoiceType: 0


        title: "特效图片数据"
        width: parent.width * 0.9
        //height: 600

        modal: true
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
        standardButtons: Dialog.Ok | Dialog.Cancel

        anchors.centerIn: parent

        ColumnLayout {
            width: parent.width

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    text: qsTr("路径：")
                }

                TextField {
                    id: textSpriteImageURL

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
                    id: textSpriteImageResourceName

                    Layout.fillWidth: true
                    placeholderText: "素材名"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveSpriteImageResource
                    checked: false
                    enabled: false
                    text: "另存"
                }
            }



            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                ColorButton {
                    text: "选择图片"
                    onButtonClicked: {
                        //dialogSpriteImageData.nChoiceType = 1;
                        filedialogOpenSpriteImage.open();
                        //root.forceActiveFocus();
                    }
                }
                ColorButton {
                    text: "选择素材"
                    onButtonClicked: {
                        //dialogSpriteImageData.nChoiceType = 2;

                        let path = GameMakerGlobal.spriteResourceURL();

                        l_listSpriteImageResource.show(path, "*", 0x002, 0x00);
                        l_listSpriteImageResource.visible = true;
                        //l_listSpriteImageResource.focus = true;
                        l_listSpriteImageResource.forceActiveFocus();

                        dialogSpriteImageData.visible = false;
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelSpriteImageDialogTips
                    Layout.alignment: Qt.AlignHCenter
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //路径 操作

            if(textSpriteImageURL.text.length === 0) {
                open();
                //visible = true;
                labelSpriteImageDialogTips.text = "路径不能为空";
                Platform.showToast("路径不能为空");
                return;
            }
            if(textSpriteImageResourceName.text.length === 0) {
                open();
                //visible = true;
                labelSpriteImageDialogTips.text = "资源名不能为空";
                Platform.showToast("资源名不能为空");
                return;
            }
            if(!FrameManager.sl_qml_FileExists(Global.toPath(textSpriteImageURL.text))) {
                open();
                //visible = true;
                labelSpriteImageDialogTips.text = "路径错误或文件不存在:" + Global.toPath(textSpriteImageURL.text);
                Platform.showToast("路径错误或文件不存在");
                return;
            }



            //系统图片
            //if(dialogSpriteImageData.nChoiceType === 1) {
            if(checkboxSaveSpriteImageResource.checked) {
                let ret = FrameManager.sl_qml_CopyFile(Global.toPath(textSpriteImageURL.text), GameMakerGlobal.spriteResourceURL(textSpriteImageResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelSpriteImageDialogTips.text = "拷贝资源失败，是否重名或目录不可写？";
                    Platform.showToast("拷贝资源失败，是否重名或目录不可写？");
                    //console.debug("[SpriteEditor]Copy ERROR:", textSpriteImageURL.text);

                    //root.forceActiveFocus();
                    return;
                }

            }
            else {  //资源图库

                //console.debug("ttt2:", filepath);

                //console.debug("ttt", textSpriteImageURL.text, Qt.resolvedUrl(textSpriteImageURL.text))
            }
            //textSpriteImageURL.text = textSpriteImageResourceName.text;
            textSpriteImageURL.text = Global.toURL(GameMakerGlobal.spriteResourceURL(textSpriteImageResourceName.text));


            sprite.spriteSrc = textSpriteImageURL.text;
            textSpriteImageURL.enabled = false;
            textSpriteImageResourceName.enabled = true;


            /*
            textSpriteImageURL.text = "";
            textSpriteImageResourceName.text = "";
            textSpriteImageResourceName.enabled = true;
            labelSpriteImageDialogTips.text = "";
            */
            _private.refreshSprite();


            //visible = false;
            //root.visible = true;
            //dialogSpriteImageData.focus = false;
            //loader.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();

            //console.log("Ok clicked");
        }
        onRejected: {
            /*
            textSpriteImageURL.text = "";
            textSpriteImageResourceName.text = "";
            textSpriteImageResourceName.enabled = true;
            labelSpriteImageDialogTips.text = "";
            */


            root.forceActiveFocus();


            //console.log("Cancel clicked");
            /*鹰：这点组件树的focus有点奇怪
            let p = dialogSpriteImageData;
            let n = 20;
            while(n > 0 && p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
                --n;
            }

            root.focus = true;
            dialogSpriteImageData.focus = true;
            root.parent.parent.focus = true;
            console.debug(root.parent.parent.focus);


            p = dialogSpriteImageData;
            while(p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
            }*/
        }

    }


    L_List {
        id: l_listSpriteImageResource
        visible: false


        onClicked: {
            let filepath = GameMakerGlobal.spriteResourceURL(item);

            textSpriteImageURL.text = Global.toURL(filepath);
            textSpriteImageResourceName.text = item;
            console.debug("[SpriteEditor]List Clicked:", textSpriteImageURL.text)

            textSpriteImageURL.enabled = false;
            textSpriteImageResourceName.enabled = false;


            dialogSpriteImageData.visible = true;


            checkboxSaveSpriteImageResource.checked = false;
            checkboxSaveSpriteImageResource.enabled = false;


            //root.focus = true;
            root.forceActiveFocus();
            visible = false;


            //let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_qml_ReadFile(fileUrl);
            console.debug("[SpriteEditor]filepath", filepath);
        }

        onCanceled: {
            dialogSpriteImageData.visible = true;

            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
            visible = false;
        }

        onRemoveClicked: {
            /*let dirUrl = Platform.getExternalDataPath() + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Maps" + GameMakerGlobal.separator + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[SpriteEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();
            */
        }
    }













    Dialog1.FileDialog {
        id: filedialogOpenSpriteSound

        title: "选择音效"
        selectMultiple: false
        //folder: shortcuts.home
        nameFilters: [ "Sound files (*.wav)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            //root.focus = true;
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.forceActiveFocus();


            console.debug("[SpriteEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textSpriteSoundURL.text = Platform.getRealPathFromURI(fileUrl);
            else
                textSpriteSoundURL.text = FrameManager.sl_qml_UrlDecode(fileUrl);

            textSpriteSoundResourceName.text = textSpriteSoundURL.text.slice(textSpriteSoundURL.text.lastIndexOf("/") + 1);


            textSpriteSoundURL.enabled = true;
            textSpriteSoundResourceName.enabled = true;


            checkboxSaveSpriteSoundResource.checked = true;
            checkboxSaveSpriteSoundResource.enabled = false;


            //console.log("You chose: " + fileDialog.fileUrls);
            //Qt.quit();
        }
        onRejected: {
            //root.forceActiveFocus();

            console.debug("[SpriteEditor]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }


    Dialog {
        id: dialogSpriteSoundData

        //1图片，2素材
        //property int nChoiceType: 0


        title: "音效数据"
        width: parent.width * 0.9
        //height: 600

        modal: true
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
        standardButtons: Dialog.Ok | Dialog.Cancel

        anchors.centerIn: parent

        ColumnLayout {
            width: parent.width

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    text: qsTr("路径：")
                }

                TextField {
                    id: textSpriteSoundURL

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
                    id: textSpriteSoundResourceName

                    Layout.fillWidth: true
                    placeholderText: "素材名"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveSpriteSoundResource
                    checked: false
                    enabled: false
                    text: "另存"
                }
            }



            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                ColorButton {
                    text: "选择音效"
                    onButtonClicked: {
                        //dialogSpriteSoundData.nChoiceType = 1;
                        filedialogOpenSpriteSound.open();
                        //root.forceActiveFocus();
                    }
                }
                ColorButton {
                    text: "选择素材"
                    onButtonClicked: {
                        //dialogSpriteSoundDataData.nChoiceType = 2;

                        let path = GameMakerGlobal.soundResourceURL();

                        l_listSpriteSoundResource.show(path, "*", 0x002, 0x00);
                        l_listSpriteSoundResource.visible = true;
                        //l_listSpriteSoundResource.focus = true;
                        l_listSpriteSoundResource.forceActiveFocus();

                        dialogSpriteSoundData.visible = false;
                    }
                }
                ColorButton {
                    text: "不用音效"
                    //Layout.fillWidth: true
                    onButtonClicked: {
                        textSpriteSoundURL.text = "";
                        textSpriteSoundResourceName.text = "";

                        sprite.soundeffectName = "";

                        textSpriteSoundResourceName.enabled = true;
                        textSpriteSoundURL.enabled = true;

                        dialogSpriteSoundData.close();
                        //root.forceActiveFocus();
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelSpriteSoundDialogTips
                    Layout.alignment: Qt.AlignHCenter
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //路径 操作

            if(textSpriteSoundURL.text.length === 0) {
                open();
                //visible = true;
                labelSpriteSoundDialogTips.text = "路径不能为空";
                Platform.showToast("路径不能为空");
                return;
            }
            if(textSpriteSoundResourceName.text.length === 0) {
                open();
                //visible = true;
                labelSpriteSoundDialogTips.text = "资源名不能为空";
                Platform.showToast("资源名不能为空");
                return;
            }
            if(!FrameManager.sl_qml_FileExists(Global.toPath(textSpriteSoundURL.text))) {
                open();
                //visible = true;
                labelSpriteSoundDialogTips.text = "路径错误或文件不存在:" + Global.toPath(textSpriteSoundURL.text);
                Platform.showToast("路径错误或文件不存在");
                return;
            }



            //音效
            //if(dialogSpriteSoundData.nChoiceType === 1) {
            if(checkboxSaveSpriteSoundResource.checked) {
                let ret = FrameManager.sl_qml_CopyFile(Global.toPath(textSpriteSoundURL.text), GameMakerGlobal.soundResourceURL(textSpriteSoundResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelSpriteSoundDialogTips.text = "拷贝到资源目录失败";
                    Platform.showToast("拷贝到资源目录失败");
                    //console.debug("[SpriteEditor]Copy ERROR:", textSpriteSoundURL.text);

                    //root.forceActiveFocus();
                    return;
                }

            }
            else {  //资源图库

                //console.debug("ttt2:", filepath);

                //console.debug("ttt", textSpriteSoundURL.text, Qt.resolvedUrl(textSpriteSoundURL.text))
            }
            //textSpriteSoundURL.text = textSpriteSoundResourceName.text;

            textSpriteSoundURL.text = Global.toURL(GameMakerGlobal.soundResourceURL(textSpriteSoundResourceName.text));
            sprite.soundeffectName = textSpriteSoundResourceName.text;

            textSpriteSoundResourceName.enabled = true;
            textSpriteSoundURL.enabled = false;

            /*
            textSpriteSoundURL.text = "";
            textSpriteSoundResourceName.text = "";
            textSpriteSoundResourceName.enabled = true;
            labelSpriteSoundDialogTips.text = "";
            */


            //visible = false;
            //root.visible = true;
            //dialogSpriteSoundData.focus = false;
            //loader.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();

            //console.log("Ok clicked");
        }
        onRejected: {
            /*
            textSpriteSoundURL.text = "";
            textSpriteSoundResourceName.text = "";
            textSpriteSoundResourceName.enabled = true;
            labelSpriteSoundDialogTips.text = "";
            */


            root.forceActiveFocus();


            //console.log("Cancel clicked");
            /*鹰：这点组件树的focus有点奇怪
            let p = dialogSpriteSoundData;
            let n = 20;
            while(n > 0 && p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
                --n;
            }

            root.focus = true;
            dialogSpriteSoundData.focus = true;
            root.parent.parent.focus = true;
            console.debug(root.parent.parent.focus);


            p = dialogSpriteSoundData;
            while(p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
            }*/
        }

    }

    L_List {
        id: l_listSpriteSoundResource
        visible: false


        onClicked: {
            let filepath = GameMakerGlobal.soundResourceURL(item);

            textSpriteSoundURL.text = Global.toURL(filepath);
            textSpriteSoundResourceName.text = item;
            console.debug("[SpriteEditor]List Clicked:", textSpriteSoundURL.text)

            textSpriteSoundURL.enabled = false;
            textSpriteSoundResourceName.enabled = false;


            dialogSpriteSoundData.visible = true;


            checkboxSaveSpriteSoundResource.checked = false;
            checkboxSaveSpriteSoundResource.enabled = false;


            //root.focus = true;
            root.forceActiveFocus();
            visible = false;


            //let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_qml_ReadFile(fileUrl);
            console.debug("[SpriteEditor]filepath", filepath);
        }

        onCanceled: {
            dialogSpriteSoundData.visible = true;

            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
            visible = false;
        }

        onRemoveClicked: {
            /*let dirUrl = Platform.getExternalDataPath() + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Maps" + GameMakerGlobal.separator + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[SpriteEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();
            */
        }
    }






    //导出特效对话框
    Dialog {
        id: dialogSaveSprite
        title: "请输入特效名称"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            //root.focus = true;
            root.forceActiveFocus();


            _private.exportSprite();

        }
        onRejected: {
            //root.focus = true;
            root.forceActiveFocus();


            //console.log("Cancel clicked");
        }

        ColumnLayout {
            width: parent.width
            RowLayout {
                width: parent.width
                Text {
                    text: qsTr("特效名：")
                }
                TextField {
                    id: textSpriteName

                    Layout.fillWidth: true
                    placeholderText: "深林孤鹰"
                    text: ""

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            /*RowLayout {
                width: parent.width
                Text {
                    text: qsTr("地图缩放：")
                }
                TextField {
                    id: textMapScale
                    Layout.fillWidth: true
                    placeholderText: "1"
                    text: "1"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }*/
        }
    }




    //游戏对话框
    Dialog {
        id: dialogScript

        title: "执行脚本"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        TextArea {
            id: textScript
            placeholderText: "输入脚本命令"

            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            //root.focus = true;
            root.forceActiveFocus();
            eval(textScript.text);
        }
        onRejected: {
            //root.focus = true;
            root.forceActiveFocus();
            //console.log("Cancel clicked");
        }
    }



    Rectangle {
        id: rectImage

        anchors.fill: parent

        visible: false

        color: 'black'

        Image {
            id: image

            anchors.centerIn: parent
            width: Math.min(implicitWidth, parent.width)
            height: Math.min(implicitHeight, parent.height)
        }

        Text {
            color: 'white'
            text: image.implicitWidth + ' x ' + image.implicitHeight
            font.pointSize: 16
        }

        MouseArea {
            anchors.fill: parent
            onClicked: rectImage.visible = false;
        }
    }



    QtObject {
        id: _private

        //property string strSpriteName: ""

        function showImage() {
            image.source = textSpriteImageURL.text;
            rectImage.visible = true;
        }


        //刷新
        function refreshSprite() {

            sprite.sizeFrame = Qt.size(parseInt(textSpriteFrameWidth.text), parseInt(textSpriteFrameHeight.text));
            sprite.nFrameCount = parseInt(textSpriteFrameCount.text);
            sprite.offsetIndex = Qt.point(parseInt(textSpriteFrameOffsetX.text), parseInt(textSpriteFrameOffsetY.text));

            sprite.interval = parseInt(textSpriteFrameInterval.text);
            //sprite.width = parseInt(textSpriteWidth.text);
            //sprite.height = parseInt(textSpriteHeight.text);
            sprite.implicitWidth = parseInt(textSpriteWidth.text);
            sprite.implicitHeight = parseInt(textSpriteHeight.text);
            sprite.opacity = parseFloat(textSpriteOpacity.text);
            sprite.rXScale = parseFloat(textSpriteFrameXScale.text);
            sprite.rYScale = parseFloat(textSpriteFrameYScale.text);

            //console.debug(sprite, sprite.soundeffectDelay)
            sprite.soundeffectDelay = parseInt(textSoundDelay.text);

            rectSprite.Layout.preferredWidth = parseInt(textSpriteWidth.text)
            rectSprite.Layout.preferredHeight = parseInt(textSpriteHeight.text)


            //sprite.refresh();

            /*sprite.sizeFrame = Qt.size(37, 58);
            sprite.nFrameCount = 3;
            sprite.arrFrameDirectionIndex = [3,2,1,0];
            sprite.interval = 100;
            sprite.width = 37;
            sprite.height = 58;
            sprite.x1 = 0;
            sprite.y1 = 0;
            sprite.width1 = 37;
            sprite.height1 = 58;
            sprite.moveSpeed = 100;
            */
            //console.debug("测试:", sprite.width, sprite.height, parseInt(textSpriteWidth.text), parseInt(textSpriteHeight.text))
        }


        //导出特效
        function exportSprite() {

            let spriteName = textSpriteName.text.trim();

            if(spriteName.length === 0) {
                Platform.showToast("特效名不能为空");
                dialogSaveSprite.open();
                return;
            }

            let filepath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName + GameMakerGlobal.separator + 'sprite.json';

            /*if(FrameManager.sl_qml_DirExists(path))
                ;
            FrameManager.sl_qml_CreateFolder(path);
            */



            let outputData = {};

            outputData.Version = "0.6";
            outputData.SpriteName = spriteName;
            outputData.SpriteType = 1; //特效类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.SpriteSize = [parseInt(textSpriteWidth.text), parseInt(textSpriteHeight.text)];
            outputData.FrameSize = [parseInt(textSpriteFrameWidth.text), parseInt(textSpriteFrameHeight.text)];
            outputData.FrameCount = parseInt(textSpriteFrameCount.text);
            outputData.OffsetIndex = [parseInt(textSpriteFrameOffsetX.text), parseInt(textSpriteFrameOffsetY.text)];

            outputData.FrameInterval = parseInt(textSpriteFrameInterval.text);
            outputData.Image = textSpriteImageResourceName.text;
            outputData.Opacity = parseFloat(textSpriteOpacity.text);
            outputData.XScale = parseFloat(textSpriteFrameXScale.text);
            outputData.YScale = parseFloat(textSpriteFrameYScale.text);

            outputData.Sound = textSpriteSoundResourceName.text;
            outputData.SoundDelay = parseInt(textSoundDelay.text);



            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(filepath, JSON.stringify(outputData));
            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify(outputData), filepath, 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

            console.debug("[SpriteEditor]exportSprite ret:", ret, filepath)
        }


    }

    //配置
    QtObject {
        id: _config

        property int nLabelFontSize: 10
        property int nTextFontSize: 10
    }




    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        console.debug("[SpriteEditor]Escape Key");
        s_close();
        event.accepted = true;
    }
    Keys.onBackPressed: {
        console.debug("[SpriteEditor]Back Key");
        s_close();
        event.accepted = true;
    }
    Keys.onPressed: {

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        event.accepted = true;


        console.debug("[SpriteEditor]key:", event, event.key, event.text)
    }

    Keys.onReleased: {
        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        console.debug("[SpriteEditor]Keys.onReleased", event.isAutoRepeat);

        //console.debug(sprite.arrFrameDirectionIndex);
        //console.debug(textSpriteFangXiangIndex.text.split(','));
    }



    Component.onCompleted: {

    }
}
