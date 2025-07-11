import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import './Core'

//import GameComponents 1.0
import 'Core/GameComponents'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: root



    signal sg_close();
    onSg_close: {
        rectImage.visible = false;

        //spriteEffect.unload();
        spriteEffect.nSpriteType = 0;


        _private.strSpriteName = '';
        _private.strTextBackupSpriteImageURL = '';
        _private.strTextBackupSpriteImageResourceName = '';
        _private.strTextBackupSpriteSoundURL = '';
        _private.strTextBackupSpriteSoundResourceName = '';


        _private.jsLoader.clear();
    }



    function newSprite() {
        comboType.currentIndex = 0;

        textSpriteName.text = '';

        textSpriteImageURL.text = '';
        textSpriteImageResourceName.text = '';
        //textSpriteFrameWidth.text = cfg.FrameSize[0].toString();
        //textSpriteFrameHeight.text = cfg.FrameSize[1].toString();
        //textSpriteFrameCount.text = cfg.FrameCount.toString();
        textSpriteFrameOffsetColumn.text = '0';
        textSpriteFrameOffsetRow.text = '0';

        textSpriteFrameInterval.text = '200';
        //spriteEffect.width = parseInt(textSpriteWidth.text);
        //spriteEffect.height = parseInt(textSpriteHeight.text);
        //textSpriteWidth.text = cfg.SpriteSize[0].toString();
        //textSpriteHeight.text = cfg.SpriteSize[1].toString();

        textSpriteSoundURL.text = '';
        textSpriteSoundResourceName.text = '';
        textSoundDelay.text = '0';
        textSpriteFrameOffsetX.text = '0';
        textSpriteFrameOffsetY.text = '0';
        textSpriteOpacity.text = '1';
        textSpriteFrameXScale.text = '1';
        textSpriteFrameYScale.text = '1';

        _private.refreshSprite();


        _private.loadScript();
    }

    function openSprite(cfg) {

        console.debug('[SpriteEditor]openSprite:', JSON.stringify(cfg));

        //cfg.Version;
        _private.strSpriteName = textSpriteName.text = cfg.SpriteName.trim();

        //textSpriteImageURL.text = cfg.Image;
        //textSpriteImageResourceName.text = textSpriteImageURL.text.slice(textSpriteImageURL.text.lastIndexOf('/') + 1);
        textSpriteImageResourceName.text = cfg.Image;
        textSpriteImageURL.text = GameMakerGlobal.spriteResourceURL(cfg.Image);
        //spriteEffect.width = parseInt(textSpriteWidth.text);
        //spriteEffect.height = parseInt(textSpriteHeight.text);
        textSpriteWidth.text = cfg.SpriteSize[0].toString();
        textSpriteHeight.text = cfg.SpriteSize[1].toString();

        if(cfg.Sound) {
            textSpriteSoundURL.text = GameMakerGlobal.soundResourceURL(cfg.Sound);
        }
        else {
            textSpriteSoundURL.text = '';
        }

        textSpriteSoundResourceName.text = cfg.Sound;
        textSoundDelay.text = cfg.SoundDelay.toString();
        textSpriteFrameOffsetX.text = cfg.XOffset !== undefined ? cfg.XOffset.toString() : '0';
        textSpriteFrameOffsetY.text = cfg.YOffset !== undefined ? cfg.YOffset.toString() : '0';
        textSpriteOpacity.text = cfg.Opacity.toString();
        textSpriteFrameXScale.text = cfg.XScale.toString();
        textSpriteFrameYScale.text = cfg.YScale.toString();

        comboType.currentIndex = (cfg.SpriteType ?? 1) - 1;

        if(comboType.currentIndex === 0) {
            let t = $CommonLibJS.getObjectValue(cfg.FrameData, 'FrameSize') ?? cfg.FrameSize;
            textSpriteFrameWidth.text = t[0].toString();
            textSpriteFrameHeight.text = t[1].toString();

            t = $CommonLibJS.getObjectValue(cfg.FrameData, 'OffsetIndex') ?? cfg.OffsetIndex;
            textSpriteFrameOffsetColumn.text = t[0].toString();
            textSpriteFrameOffsetRow.text = t[1].toString();

            textSpriteFrameCount.text = ($CommonLibJS.getObjectValue(cfg.FrameData, 'FrameCount') ?? cfg.FrameCount).toString();
            textSpriteFrameInterval.text = ($CommonLibJS.getObjectValue(cfg.FrameData, 'FrameInterval') ?? cfg.FrameInterval).toString();
        }
        else if(comboType.currentIndex === 1) {
            textSpriteFrameStartIndex.text = (cfg.FrameData.FrameStartIndex ?? cfg.FrameData[0]).toString();
            textSpriteFrameCount.text = (cfg.FrameData.FrameCount ?? cfg.FrameData[1]).toString();
            textSpriteFrameInterval.text = (cfg.FrameData.FrameInterval ?? cfg.FrameData[2]).toString();
        }

        _private.refreshSprite();


        _private.loadScript(textSpriteName.text);
    }



    property alias sprite: spriteEffect


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



    //主界面
    ColumnLayout {
        //anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width * 0.96
        height: parent.height * 0.96

        //spacing: 16



        Rectangle {
            clip: true

            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: 'transparent'
            border {
                color: 'lightgray'
                width: 1
            }

            Flickable {
                id: flickable

                //anchors.fill: parent

                anchors.centerIn: parent
                width: parent.width * 0.96
                //height: parent.height * 0.9
                height: parent.height * 0.96


                contentWidth: width
                contentHeight: Math.max(layout.implicitHeight)

                flickableDirection: Flickable.VerticalFlick



                ColumnLayout {
                    id: layout

                    //anchors.fill: parent
                    width: flickable.width
                    height: Math.max(flickable.height/*, implicitHeight*/)

                    //spacing: 6


                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '类型:'
                        }

                        ComboBox {
                            id: comboType

                            Layout.fillWidth: true


                            model: ['典型行列图', '序列图片文件']

                            background: Rectangle {
                                //implicitWidth: comboBoxComponentItem.comboBoxWidth
                                implicitHeight: 35
                                //border.color: control.pressed ? '#6495ED' : '#696969'
                                //border.width: control.visualFocus ? 2 : 1
                                color: 'transparent'
                                //border.color: comboBoxComponentItem.color
                                border.width: 2
                                radius: 6
                            }

                            onActivated: {
                                console.debug('[SpriteEditor]ComboBox:', comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);

                                _private.changeType();
                            }
                            /*onHighlighted: {
                                console.debug('onHighlighted:', comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);
                            }
                            onAccepted: {
                                console.debug(comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);
                            }*/

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
                            text: '[特效]'
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '大小'
                        }

                        TextField {
                            id: textSpriteWidth

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '50'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '50';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '*'
                        }

                        TextField {
                            id: textSpriteHeight

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '50'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '50';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '透明度'
                        }

                        TextField {
                            id: textSpriteOpacity

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '1.0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '1.0';

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
                            text: 'X/Y轴偏移'
                        }

                        TextField {
                            id: textSpriteFrameOffsetX

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshSprite();
                            }
                        }

                        TextField {
                            id: textSpriteFrameOffsetY

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: 'X/Y轴缩放'
                        }

                        TextField {
                            id: textSpriteFrameXScale

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '1.0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '1.0';

                                _private.refreshSprite();
                            }
                        }

                        TextField {
                            id: textSpriteFrameYScale

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '1.0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '1.0';

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
                            text: '[音效]'
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '播放延时'
                        }

                        TextField {
                            id: textSoundDelay

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

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
                            text: '[帧]'
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '帧数'
                        }

                        TextField {
                            id: textSpriteFrameCount

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '3'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '3';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '帧速度（ms）'
                        }

                        TextField {
                            id: textSpriteFrameInterval

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '100'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '100';

                                _private.refreshSprite();
                            }
                        }
                    }


                    RowLayout {
                        //Layout.preferredWidth: root.width * 0.9
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                        visible: comboType.currentIndex === 0


                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '帧大小'
                        }

                        TextField {
                            id: textSpriteFrameWidth

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '37'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '37';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '*'
                        }
                        TextField {
                            id: textSpriteFrameHeight

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '58'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '58';

                                _private.refreshSprite();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '起始帧（列/行）'
                        }

                        TextField {
                            id: textSpriteFrameOffsetColumn

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshSprite();
                            }
                        }
                        TextField {
                            id: textSpriteFrameOffsetRow

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshSprite();
                            }
                        }

                    }

                    RowLayout {
                        //Layout.preferredWidth: root.width * 0.9
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                        visible: comboType.currentIndex === 1


                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 10
                            text: '起始序号'
                        }

                        TextField {
                            id: textSpriteFrameStartIndex

                            Layout.preferredWidth: Math.max(contentWidth + 9, 9)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '0'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshSprite();
                            }
                        }
                    }


                    Label {
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true

                        visible: comboType.currentIndex === 1

                        color: 'red'
                        text: '注意：图片文件夹请自行复制到资源目录；预览请先保存'
                        font.pointSize: _config.nTextFontSize

                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter

                    }

                    RowLayout {
                        Layout.preferredHeight: 50
                        Layout.fillWidth: true

                        //visible: comboType.currentIndex === 1

                        Button {
                            Layout.fillWidth: true

                            text: '编辑脚本' + (comboType.currentIndex === 0 ? '（可选）' : '')

                            onClicked: {

                                if(!_private.strSpriteName) {
                                    $dialog.show({
                                          Msg: '请先保存特效',
                                          Buttons: Dialog.Yes,
                                          OnAccepted: function() {
                                              root.forceActiveFocus();
                                          },
                                          OnRejected: ()=>{
                                              root.forceActiveFocus();
                                          },
                                      });

                                    return;
                                }


                                //_private.loadScript(textSpriteName.text);
                                if(!scriptEditor.text &&
                                        !$Frame.sl_fileExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + _private.strSpriteName + GameMakerGlobal.separator + 'sprite.js')) {
                                    if(comboType.currentIndex === 1)
                                        scriptEditor.text = _private.strTemplateCode0;
                                    else
                                        scriptEditor.text = '';
                                }


                                scriptEditor.visible = true;
                                scriptEditor.forceActiveFocus();
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: parent.width
            Layout.maximumHeight: parent.height / 2

            Rectangle {
                id: rectSprite
                Layout.alignment: Qt.AlignCenter

                Layout.preferredWidth: parseInt(textSpriteWidth.text)
                Layout.preferredHeight: parseInt(textSpriteHeight.text)
                implicitWidth: spriteEffect.implicitWidth
                implicitHeight: spriteEffect.implicitHeight

                color: 'transparent'
                border {
                    width: 1
                    color: 'lightgray'
                }

                SpriteEffect {
                    id: spriteEffect


                    //anchors.fill: parent
                    //width: 37;
                    //height: 58;


                    bTest: true
                    nType: 1

                    //sizeFrame: Qt.size(37, 58);
                    /*nFrameCount: 3;
                    interval: 100;*/

                    /*onSg_clicked: {
                        root.forceActiveFocus();
                    }*/


                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //console.warn(666, mouseArea, nSpriteType, spriteEffect)
                            root.forceActiveFocus();

                            if(spriteEffect.status() === 1)
                                spriteEffect.stop();
                            else
                                spriteEffect.restart();
                        }
                    }
                }
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '图片资源'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    textSpriteImageURL.enabled = false;
                    textSpriteImageResourceName.enabled = true;
                    _private.strTextBackupSpriteImageURL = textSpriteImageURL.text;
                    _private.strTextBackupSpriteImageResourceName = textSpriteImageResourceName.text;
                    dialogSpriteImageData.open();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '音效'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    textSpriteSoundURL.enabled = false;
                    textSpriteSoundResourceName.enabled = true;
                    _private.strTextBackupSpriteSoundURL = textSpriteSoundURL.text;
                    _private.strTextBackupSpriteSoundResourceName = textSpriteSoundResourceName.text;
                    dialogSpriteSoundData.open();
                }
            }

            Button {
                visible: false

                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '刷新'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    _private.refreshSprite();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '保存'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    //_private.strSpriteName = textSpriteName.text;

                    dialogSaveSprite.open();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                visible: comboType.currentIndex === 0

                text: '原图'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    if(textSpriteImageURL.text)
                        _private.showImage();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: '帮助'
                font.pointSize: _config.nButtonFontSize

                onClicked: {

                    rootGameMaker.showMsg('
  特效大小：游戏中显示的大小；
  特效偏移：帧在特效内的x、y轴偏移；
  X/Y轴缩放：可以在x、y方向进行缩放，且可以为负数（x、y轴的镜像）；
  帧宽高：将图片切割为每一帧的大小（如果图片显示有问题，则可能这里不正确）；
  帧数：连续播放的帧数；
  起始帧：从第几列、第几行开始（然后连续的n张）；
  透明度：0-1之间的小数；
  帧速度：你懂的；
  音效播放延时：帧播放多少毫秒后开始播放音效；

')
                }
            }

            Button {
                visible: $Platform.compileType === 'debug' ? true : false
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: 'Test'
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    /*spriteEffect.sprite.running = true;
                    console.debug('[SpriteEditor]test', spriteEffect.sprite, spriteEffect.sprite.state, spriteEffect.sprite.currentSprite)
                    console.debug(spriteEffect.sprite.sprites);
                    for(let s in spriteEffect.sprite.sprites) {
                        console.debug(spriteEffect.sprite.sprites[s].frameY);
                        spriteEffect.sprite.sprites[s].frameY = 20*s;
                        console.debug(spriteEffect.sprite.sprites[s].frameY);
                    }*/
                    dialogDebugScript.open();
                }
            }

        }

    }


    ScriptEditor {
        id: scriptEditor

        visible: false
        anchors.fill: parent


        strTitle: `${_private.strSpriteName}(特效脚本)`
        /*fnAfterCompile: function(code) {return code;}*/

        visualScriptEditor.strTitle: strTitle

        visualScriptEditor.strSearchPath: GameMakerGlobal.config.strProjectRootPath + $Platform.sl_separator(true) + GameMakerGlobal.config.strCurrentProjectName
        visualScriptEditor.nLoadType: 1

        visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        visualScriptEditor.defaultCommandTemplate: [{'command':'函数/生成器{','params':['*$start',''],'status':{'enabled':true}},{'command':'块结束}','params':[],'status':{'enabled':true}}]


        onSg_close: function(saved) {
            if(saved) {
                //_private.saveJS();

                _private.refreshSprite();
            }

            scriptEditor.visible = false;
            root.forceActiveFocus();
        }
    }






    Dialog1.FileDialog {
        id: filedialogOpenSpriteImage

        visible: false

        title: '选择特效图片'
        //folder: shortcuts.home
        nameFilters: [ 'Image files (*.jpg *.png *.bmp)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.focus = true;
            //loader.forceActiveFocus();


            console.debug('[SpriteEditor]You chose:', fileUrl, fileUrls);


            if(Qt.platform.os === 'android')
                textSpriteImageURL.text = $Platform.sl_getRealPathFromURI(fileUrl.toString());
            else
                textSpriteImageURL.text = $Frame.sl_urlDecode(fileUrl.toString());

            textSpriteImageResourceName.text = textSpriteImageURL.text.slice(textSpriteImageURL.text.lastIndexOf('/') + 1);


            textSpriteImageURL.enabled = true;
            textSpriteImageResourceName.enabled = true;


            checkboxSaveSpriteImageResource.checked = true;
            checkboxSaveSpriteImageResource.enabled = false;


            //console.log('You chose:', fileDialog.fileUrls);
        }
        onRejected: {
            console.debug('[SpriteEditor]onRejected');
            //root.forceActiveFocus();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }


    Dialog {
        id: dialogSpriteImageData

        //1图片，2素材
        //property int nChoiceType: 0


        title: '特效图片数据'
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
                    text: qsTr('路径:')
                }

                TextField {
                    id: textSpriteImageURL

                    Layout.fillWidth: true
                    placeholderText: ''

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
                    placeholderText: '素材名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveSpriteImageResource
                    checked: false
                    enabled: false
                    text: '另存'
                }
            }



            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                Button {
                    visible: comboType.currentIndex === 0

                    text: '选择图片文件'

                    onClicked: {
                        //dialogSpriteImageData.nChoiceType = 1;
                        filedialogOpenSpriteImage.open();
                        //root.forceActiveFocus();
                    }
                }
                Button {
                    text: '选择素材'
                    onClicked: {
                        //dialogSpriteImageData.nChoiceType = 2;

                        let path = GameMakerGlobal.spriteResourcePath();

                        if(comboType.currentIndex === 0)
                            l_listSpriteImageResource.show(path, [], 0x002, 0x00);
                        if(comboType.currentIndex === 1)
                            l_listSpriteImageResource.show(path, [], 0x001 | 0x2000 | 0x4000, 0x00);
                        l_listSpriteImageResource.visible = true;
                        //l_listSpriteImageResource.focus = true;
                        //l_listSpriteImageResource.forceActiveFocus();

                        dialogSpriteImageData.visible = false;
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelSpriteImageDialogTips
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    wrapMode: Label.WrapAnywhere
                    color: 'red'
                    text: ''

                }
            }
        }

        onAccepted: {
            //路径 操作

            /*if(textSpriteImageURL.text.length === 0) {
                open();
                //visible = true;
                labelSpriteImageDialogTips.text = '路径不能为空';
                $Platform.sl_showToast('路径不能为空');
                return;
            }*/
            if(textSpriteImageResourceName.text.length === 0) {
                open();
                //visible = true;
                labelSpriteImageDialogTips.text = '资源名不能为空';
                $Platform.sl_showToast('资源名不能为空');
                return;
            }
            //系统图片
            //if(dialogSpriteImageData.nChoiceType === 1) {
            if(checkboxSaveSpriteImageResource.checked) {
                let ret = $Frame.sl_fileCopy($GlobalJS.toPath(textSpriteImageURL.text), GameMakerGlobal.spriteResourcePath(textSpriteImageResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelSpriteImageDialogTips.text = '拷贝资源失败，是否重名或目录不可写？';
                    $Platform.sl_showToast('拷贝资源失败，是否重名或目录不可写？');
                    //console.debug('[SpriteEditor]Copy ERROR:', textSpriteImageURL.text);

                    //root.forceActiveFocus();
                    return;
                }
            }
            else {  //资源图库

                //console.debug('ttt2:', filepath);

                //console.debug('ttt', textSpriteImageURL.text, Qt.resolvedUrl(textSpriteImageURL.text))
            }

            //textSpriteImageURL.text = textSpriteImageResourceName.text;
            textSpriteImageURL.text = GameMakerGlobal.spriteResourceURL(textSpriteImageResourceName.text);


            if(comboType.currentIndex === 0) {
                if(!$Frame.sl_fileExists($GlobalJS.toPath(textSpriteImageURL.text))) {
                    open();
                    //visible = true;
                    labelSpriteImageDialogTips.text = '路径错误或文件不存在:' + $GlobalJS.toPath(textSpriteImageURL.text);
                    $Platform.sl_showToast('路径错误或文件不存在' + $GlobalJS.toPath(textSpriteImageURL.text));
                    return;
                }
            }
            else if(comboType.currentIndex === 1) {
                if(!$Frame.sl_fileExists($GlobalJS.toPath(textSpriteImageURL.text))) {
                    open();
                    //visible = true;
                    labelSpriteImageDialogTips.text = '路径错误或文件夹不存在:' + $GlobalJS.toPath(textSpriteImageURL.text);
                    $Platform.sl_showToast('路径错误或文件夹不存在' + $GlobalJS.toPath(textSpriteImageURL.text));
                    return;
                }
            }



            textSpriteImageURL.enabled = false;
            textSpriteImageResourceName.enabled = true;


            _private.refreshSprite();


            labelSpriteImageDialogTips.text = '';
            /*
            textSpriteImageURL.text = '';
            textSpriteImageResourceName.text = '';
            textSpriteImageResourceName.enabled = true;
            */


            //visible = false;
            //root.visible = true;
            //dialogSpriteImageData.focus = false;
            //loader.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();

            //console.log('Ok clicked');
        }
        onRejected: {
            textSpriteImageURL.text = _private.strTextBackupSpriteImageURL;
            textSpriteImageResourceName.text = _private.strTextBackupSpriteImageResourceName;


            labelSpriteImageDialogTips.text = '';
            /*
            textSpriteImageURL.text = '';
            textSpriteImageResourceName.text = '';
            textSpriteImageResourceName.enabled = true;
            */


            root.forceActiveFocus();


            //console.log('Cancel clicked');
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

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor

        //removeButtonVisible: false


        onSg_clicked: {
            textSpriteImageURL.text = GameMakerGlobal.spriteResourceURL(item);
            textSpriteImageResourceName.text = item;
            
            textSpriteImageURL.enabled = false;
            textSpriteImageResourceName.enabled = true;


            dialogSpriteImageData.visible = true;


            checkboxSaveSpriteImageResource.checked = false;
            checkboxSaveSpriteImageResource.enabled = false;


            //let cfg = File.read(fileUrl.toString());
            //let cfg = $Frame.sl_fileRead(fileUrl.toString());


            visible = false;
            //root.focus = true;
            root.forceActiveFocus();

            console.debug('[SpriteEditor]Sprite Image file URL:', textSpriteImageURL.text);
        }

        onSg_canceled: {
            dialogSpriteImageData.visible = true;

            visible = false;
            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
        }

        onSg_removeClicked: {
            let filepath = GameMakerGlobal.spriteResourcePath(item);

            $dialog.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug('[SpriteEditor]删除:' + filepath, Qt.resolvedUrl(filepath), $Frame.sl_fileExists(filepath), $Frame.sl_fileDelete(filepath));
                    removeItem(index);

                    l_listSpriteImageResource.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listSpriteImageResource.forceActiveFocus();
                },
            });
        }
    }






    Dialog1.FileDialog {
        id: filedialogOpenSpriteSound

        visible: false

        title: '选择音效'
        //folder: shortcuts.home
        //nameFilters: [ 'Sound files (*.wav)', 'All files (*)' ]
        nameFilters: [ 'Music files (*.wav *.mp3 *.wma *.ogg *.mid)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.focus = true;
            //loader.forceActiveFocus();


            console.debug('[SpriteEditor]You chose:', fileUrl, fileUrls);


            if(Qt.platform.os === 'android')
                textSpriteSoundURL.text = $Platform.sl_getRealPathFromURI(fileUrl.toString());
            else
                textSpriteSoundURL.text = $Frame.sl_urlDecode(fileUrl.toString());

            textSpriteSoundResourceName.text = textSpriteSoundURL.text.slice(textSpriteSoundURL.text.lastIndexOf('/') + 1);


            textSpriteSoundURL.enabled = true;
            textSpriteSoundResourceName.enabled = true;


            checkboxSaveSpriteSoundResource.checked = true;
            checkboxSaveSpriteSoundResource.enabled = false;


            //console.log('You chose:', fileDialog.fileUrls);
        }
        onRejected: {
            console.debug('[SpriteEditor]onRejected');
            //root.forceActiveFocus();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }


    Dialog {
        id: dialogSpriteSoundData

        //1图片，2素材
        //property int nChoiceType: 0


        title: '音效数据'
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
                    text: qsTr('路径:')
                }

                TextField {
                    id: textSpriteSoundURL

                    Layout.fillWidth: true
                    placeholderText: ''

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
                    placeholderText: '素材名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveSpriteSoundResource
                    checked: false
                    enabled: false
                    text: '另存'
                }
            }



            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: '选择音效文件'
                    onClicked: {
                        //dialogSpriteSoundData.nChoiceType = 1;
                        filedialogOpenSpriteSound.open();
                        //root.forceActiveFocus();
                    }
                }
                Button {
                    text: '选择素材'
                    onClicked: {
                        //dialogSpriteSoundDataData.nChoiceType = 2;

                        let path = GameMakerGlobal.soundResourcePath();

                        l_listSpriteSoundResource.show(path, [], 0x002, 0x00);
                        l_listSpriteSoundResource.visible = true;
                        //l_listSpriteSoundResource.focus = true;
                        //l_listSpriteSoundResource.forceActiveFocus();

                        dialogSpriteSoundData.visible = false;
                    }
                }
                Button {
                    text: '无音效'
                    //Layout.fillWidth: true
                    onClicked: {
                        textSpriteSoundURL.text = '';
                        textSpriteSoundResourceName.text = '';

                        textSpriteSoundResourceName.enabled = true;
                        textSpriteSoundURL.enabled = true;

                        labelSpriteSoundDialogTips.text = '';
                        dialogSpriteSoundData.close();

                        root.forceActiveFocus();
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelSpriteSoundDialogTips
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    wrapMode: Label.WrapAnywhere
                    color: 'red'
                    text: ''
                }
            }
        }

        onAccepted: {
            //路径 操作

            /*if(textSpriteSoundURL.text.length === 0) {
                open();
                //visible = true;
                labelSpriteSoundDialogTips.text = '路径不能为空';
                $Platform.sl_showToast('路径不能为空');
                return;
            }
            */
            /*
            if(textSpriteSoundResourceName.text.length === 0) {
                open();
                //visible = true;
                labelSpriteSoundDialogTips.text = '资源名不能为空';
                $Platform.sl_showToast('资源名不能为空');
                return;
            }
            */
            //音效
            //if(dialogSpriteSoundData.nChoiceType === 1) {
            if(checkboxSaveSpriteSoundResource.checked) {
                let ret = $Frame.sl_fileCopy($GlobalJS.toPath(textSpriteSoundURL.text), GameMakerGlobal.soundResourcePath(textSpriteSoundResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelSpriteSoundDialogTips.text = '拷贝到资源目录失败';
                    $Platform.sl_showToast('拷贝到资源目录失败');
                    //console.debug('[SpriteEditor]Copy ERROR:', textSpriteSoundURL.text);

                    //root.forceActiveFocus();
                    return;
                }
            }
            else {  //资源

                //console.debug('ttt2:', filepath);

                //console.debug('ttt', textSpriteSoundURL.text, Qt.resolvedUrl(textSpriteSoundURL.text))
            }

            if(textSpriteSoundResourceName.text.trim()) {
                //textSpriteSoundURL.text = textSpriteSoundResourceName.text;
                textSpriteSoundURL.text = GameMakerGlobal.soundResourceURL(textSpriteSoundResourceName.text);

                if(!$Frame.sl_fileExists($GlobalJS.toPath(textSpriteSoundURL.text))) {
                    open();
                    //visible = true;
                    labelSpriteSoundDialogTips.text = '路径错误或文件不存在:' + $GlobalJS.toPath(textSpriteSoundURL.text);
                    $Platform.sl_showToast('路径错误或文件不存在');
                    return;
                }
            }
            else {
                textSpriteSoundURL.text = '';
                textSpriteSoundResourceName.text = '';
            }



            textSpriteSoundResourceName.enabled = true;
            textSpriteSoundURL.enabled = false;


            labelSpriteSoundDialogTips.text = '';
            /*
            textSpriteSoundURL.text = '';
            textSpriteSoundResourceName.text = '';
            textSpriteSoundResourceName.enabled = true;
            */


            //visible = false;
            //root.visible = true;
            //dialogSpriteSoundData.focus = false;
            //loader.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();

            //console.log('Ok clicked');
        }
        onRejected: {
            textSpriteSoundURL.text = _private.strTextBackupSpriteSoundURL;
            textSpriteSoundResourceName.text = _private.strTextBackupSpriteSoundResourceName;


            labelSpriteSoundDialogTips.text = '';
            /*
            textSpriteSoundURL.text = '';
            textSpriteSoundResourceName.text = '';
            textSpriteSoundResourceName.enabled = true;
            */


            root.forceActiveFocus();


            //console.log('Cancel clicked');
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

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor

        //removeButtonVisible: false


        onSg_clicked: {
            textSpriteSoundURL.text = GameMakerGlobal.soundResourceURL(item);
            textSpriteSoundResourceName.text = item;
            //console.debug('[SpriteEditor]List Clicked:', textSpriteSoundURL.text);

            textSpriteSoundURL.enabled = false;
            textSpriteSoundResourceName.enabled = true;


            dialogSpriteSoundData.visible = true;


            checkboxSaveSpriteSoundResource.checked = false;
            checkboxSaveSpriteSoundResource.enabled = false;


            //let cfg = File.read(fileUrl.toString());
            //let cfg = $Frame.sl_fileRead(fileUrl.toString());


            //root.focus = true;
            root.forceActiveFocus();
            visible = false;

            console.debug('[SpriteEditor]Sprite sound file URL:', textSpriteSoundURL.text);
        }

        onSg_canceled: {
            dialogSpriteSoundData.visible = true;

            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
            visible = false;
        }

        onSg_removeClicked: {
            let filepath = GameMakerGlobal.soundResourcePath(item);

            $dialog.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug('[SpriteEditor]删除:' + filepath, Qt.resolvedUrl(filepath), $Frame.sl_fileExists(filepath), $Frame.sl_fileDelete(filepath));
                    removeItem(index);

                    l_listSpriteSoundResource.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listSpriteSoundResource.forceActiveFocus();
                },
            });
        }
    }



    //导出对话框
    Dialog {
        id: dialogSaveSprite
        title: '请输入名称'
        width: parent.width * 0.9
        //height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            textSpriteName.text = textSpriteName.text.trim();
            if(textSpriteName.text.length === 0) {
                //$Platform.sl_showToast('名称不能为空');
                textDialogMsg.text = '名称不能为空';
                open();
                return;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + textSpriteName.text;

            function fnSave() {
                if(_private.exportSprite()) {
                    //第一次保存，重新刷新
                    if(_private.strSpriteName === '') {
                        _private.loadScript(textSpriteName.text);
                        _private.refreshSprite();
                    }

                    _private.strSpriteName = textSpriteName.text;

                    textDialogMsg.text = '';

                    //root.focus = true;
                    root.forceActiveFocus();
                }
                else {
                    open();
                }
            }

            if(textSpriteName.text !== _private.strSpriteName && $Frame.sl_dirExists(path)) {
                $dialog.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textSpriteName.text = _private.strSpriteName;

                        textDialogMsg.text = '';

                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();

                        root.forceActiveFocus();
                    },*/
                });
            }
            else
                fnSave();

        }
        onRejected: {
            textSpriteName.text = _private.strSpriteName;

            textDialogMsg.text = '';


            //root.focus = true;
            root.forceActiveFocus();

            //console.log('Cancel clicked');
        }

        ColumnLayout {
            width: parent.width
            height: implicitHeight

            RowLayout {
                //width: parent.width
                Label {
                    text: qsTr('特效名:')
                }
                TextField {
                    id: textSpriteName

                    Layout.fillWidth: true
                    placeholderText: '深林孤鹰'
                    text: ''

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            /*RowLayout {
                width: parent.width
                Label {
                    text: qsTr('地图缩放:')
                }
                TextField {
                    id: textMapScale
                    Layout.fillWidth: true
                    selectByMouse: true
                    placeholderText: '1'
                    text: '1'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }*/

            Label {
                id: textDialogMsg
                color: 'red'
            }
        }
    }




    Dialog {
        id: dialogDebugScript

        title: '执行脚本'
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: '输入脚本命令'

            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            //root.focus = true;
            root.forceActiveFocus();
            console.info(eval(textScript.text));
        }
        onRejected: {
            //root.focus = true;
            root.forceActiveFocus();
            //console.log('Cancel clicked');
        }
    }



    Mask {
        id: rectImage

        visible: false
        //opacity: 0

        anchors.fill: parent

        color: Global.style.backgroundColor
        //radius: 9

        Image {
            id: image

            anchors.centerIn: parent
            width: Math.min(implicitWidth, parent.width)
            height: Math.min(implicitHeight, parent.height)
        }

        Label {
            //color: 'white'
            text: image.implicitWidth + ' x ' + image.implicitHeight
            font.pointSize: 16
        }

        mouseArea.onClicked: {
            rectImage.visible = false;
            root.forceActiveFocus();
        }
    }



    QtObject {
        id: _private


        property string strSpriteName: ''
        property string strTextBackupSpriteImageURL
        property string strTextBackupSpriteImageResourceName
        property string strTextBackupSpriteSoundURL
        property string strTextBackupSpriteSoundResourceName

        property var jsLoader: new $GlobalJS.JSLoader(root)

        property string strTemplateCode0: `
//保存坐标偏移数据
let imageFixPositions;

//刷新图片和偏移坐标
function $refresh(index, imageAnimate, path) {
    if(imageFixPositions === undefined) {
        //读取坐标偏移文件并保存
        imageFixPositions = $Frame.sl_fileRead($GlobalJS.toPath(path) + GameMakerGlobal.separator + 'x.txt');
        if(imageFixPositions)
            imageFixPositions = imageFixPositions.split(\/\\r\?\\n\/);
        else
            imageFixPositions = null;
    }

    //设置图片路径（注意图片名字的生成，默认是 index序号+1，保留5位不足的补0，格式为png），请自行按需修改；
    imageAnimate.source = path + GameMakerGlobal.separator + String(index+1).padStart(5, '0') + '.png';
    //从坐标偏移数据中读取坐标偏移并设置（默认index就是行数）；
    let [tx, ty] = imageFixPositions ? imageFixPositions[index].split(' ') : [0, 0];
    imageAnimate.rXOffset += parseInt(tx);
    imageAnimate.rYOffset += parseInt(ty);
}
`



        function changeType() {
            _private.refreshSprite();
        }


        function showImage() {
            image.source = textSpriteImageURL.text;
            rectImage.visible = true;
            rectImage.forceActiveFocus();
        }


        //刷新
        function refreshSprite() {
            /*switch(comboType.currentIndex) {
            case 0:
                loaderSprite.sourceComponent = compSpriteEffect;
                break;
            case 1:
                loaderSprite.sourceComponent = compFileSpriteEffect;
                break;
            }
            */
            spriteEffect.nSpriteType = comboType.currentIndex + 1;
            //console.warn(comboType.currentIndex, loaderSprite.sourceComponent, loaderSprite.item);
            //console.warn(spriteEffect, spriteEffect.nFrameCount);
            //console.warn(loaderSprite.sourceComponent === compSpriteEffect);

            spriteEffect.strSource = textSpriteImageURL.text;

            spriteEffect.nFrameCount = parseInt(textSpriteFrameCount.text);

            spriteEffect.nInterval = parseInt(textSpriteFrameInterval.text);
            //spriteEffect.width = parseInt(textSpriteWidth.text);
            //spriteEffect.height = parseInt(textSpriteHeight.text);
            //spriteEffect.implicitWidth = parseInt(textSpriteWidth.text);
            //spriteEffect.implicitHeight = parseInt(textSpriteHeight.text);
            spriteEffect.rXOffset = parseInt(textSpriteFrameOffsetX.text);
            spriteEffect.rYOffset = parseInt(textSpriteFrameOffsetY.text);
            spriteEffect.opacity = parseFloat(textSpriteOpacity.text);
            spriteEffect.rXScale = parseFloat(textSpriteFrameXScale.text);
            spriteEffect.rYScale = parseFloat(textSpriteFrameYScale.text);

            spriteEffect.strSoundeffectName = textSpriteSoundURL.text;
            //spriteEffect.strSoundeffectName =  GameMakerGlobal.soundResourceURL(textSpriteSoundResourceName.text);
            //console.debug(spriteEffect, spriteEffect.nSoundeffectDelay)
            spriteEffect.nSoundeffectDelay = parseInt(textSoundDelay.text);


            if(comboType.currentIndex === 0) {
                //loaderSprite.sourceComponent = compSpriteEffect;

                //注意这个放在 spriteEffect.sprite.width 和 spriteEffect.sprite.height 之前
                spriteEffect.sprite.sizeFrame = Qt.size(parseInt(textSpriteFrameWidth.text), parseInt(textSpriteFrameHeight.text));

                //spriteEffect.sprite.width = parseInt(textSpriteWidth.text);
                //spriteEffect.sprite.height = parseInt(textSpriteHeight.text);
                spriteEffect.width = parseInt(textSpriteWidth.text);
                spriteEffect.height = parseInt(textSpriteHeight.text);

                spriteEffect.sprite.pointOffsetIndex = Qt.point(parseInt(textSpriteFrameOffsetColumn.text), parseInt(textSpriteFrameOffsetRow.text));
            }
            else if(comboType.currentIndex === 1) {
                //loaderSprite.sourceComponent = compFileSpriteEffect;

                spriteEffect.sprite.nFrameStartIndex = parseInt(textSpriteFrameStartIndex.text);

                //spriteEffect.sprite.width = parseInt(textSpriteWidth.text);
                //spriteEffect.sprite.height = parseInt(textSpriteHeight.text);
                spriteEffect.width = parseInt(textSpriteWidth.text);
                spriteEffect.height = parseInt(textSpriteHeight.text);


                const jsPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + textSpriteName.text + GameMakerGlobal.separator + 'sprite.js';
                if($Frame.sl_fileExists(jsPath)) {
                    _private.jsLoader.clear();
                    let ts = _private.jsLoader.load($GlobalJS.toURL(jsPath));
                    spriteEffect.sprite.fnRefresh = ts.$refresh;
                }

            }


            //rectSprite.Layout.preferredWidth = parseInt(textSpriteWidth.text)
            //rectSprite.Layout.preferredHeight = parseInt(textSpriteHeight.text)


            spriteEffect.sprite.reset();
            //spriteEffect.refresh();

            /*spriteEffect.sizeFrame = Qt.size(37, 58);
            spriteEffect.nFrameCount = 3;
            objActionsData = [3,2,1,0];
            spriteEffect.interval = 100;
            spriteEffect.width = 37;
            spriteEffect.height = 58;
            spriteEffect.x1 = 0;
            spriteEffect.y1 = 0;
            spriteEffect.width1 = 37;
            spriteEffect.height1 = 58;
            spriteEffect.moveSpeed = 100;
            */
            //console.debug('测试:', spriteEffect.width, spriteEffect.height, parseInt(textSpriteWidth.text), parseInt(textSpriteHeight.text))
        }


        function loadScript(spriteName) {
            if(!spriteName) {
                //scriptEditor.text = _private.strTemplateCode0;
                scriptEditor.text = '';
                scriptEditor.visualScriptEditor.loadData(null);
                return;
            }

            //let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName + GameMakerGlobal.separator;
            //if($Frame.sl_fileExists(path + 'sprite.js')) {
            //File.read(path + 'sprite.js');
            scriptEditor.init({
                BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator,
                RelativePath: GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName + GameMakerGlobal.separator + 'sprite.js',
                ChoiceButton: 0b0,
                PathText: 0b0,
                RunButton: 0b0,
            });
            //scriptEditor.text = $Frame.sl_fileRead(path + 'sprite.js') || '';
            //scriptEditor.editor.setPlainText(data);
            //scriptEditor.editor.toBegin();
            //visualScriptEditor.loadData(path + 'sprite.vjs');
        }

        function createJS() {
            //第一次保存js文件
            if(_private.strSpriteName === '') {
                if(comboType.currentIndex === 1)    //序列图片文件
                    scriptEditor.text = _private.strTemplateCode0;
                else
                    scriptEditor.text = '';

                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + textSpriteName.text;
                let ret = $Frame.sl_fileWrite($Frame.sl_toPlainText(scriptEditor.editor.textDocument), path + GameMakerGlobal.separator + 'sprite.js', 0);
            }
            else
                return false;

            return true;
        }
        //复制可视化
        function copyVJS() {
            //如果路径不为空，且是另存为，则赋值vjs文件
            if(_private.strSpriteName !== '' && textSpriteName.text !== '' && _private.strSpriteName !== textSpriteName.text) {
                let oldFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + _private.strSpriteName + GameMakerGlobal.separator + 'sprite.vjs';
                if($Frame.sl_fileExists(oldFilePath)) {
                    let newFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + textSpriteName.text + GameMakerGlobal.separator + 'sprite.vjs';
                    let ret = $Frame.sl_fileCopy(oldFilePath, newFilePath, true);
                }
            }
        }

        //导出特效
        function exportSprite() {

            let spriteName = textSpriteName.text;
            let filepath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName + GameMakerGlobal.separator + 'sprite.json';

            /*//if(!$Frame.sl_dirExists(path))
                $Frame.sl_dirCreate(path);
            */

            let outputData = {};

            outputData.Version = '0.9';
            outputData.SpriteName = spriteName;
            outputData.SpriteType = comboType.currentIndex + 1; //特效类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.SpriteSize = [parseInt(textSpriteWidth.text), parseInt(textSpriteHeight.text)];
            outputData.Image = textSpriteImageResourceName.text;
            outputData.XOffset = parseInt(textSpriteFrameOffsetX.text);
            outputData.YOffset = parseInt(textSpriteFrameOffsetY.text);
            outputData.Opacity = parseFloat(textSpriteOpacity.text);
            outputData.XScale = parseFloat(textSpriteFrameXScale.text);
            outputData.YScale = parseFloat(textSpriteFrameYScale.text);

            outputData.Sound = textSpriteSoundResourceName.text;
            outputData.SoundDelay = parseInt(textSoundDelay.text);

            if(comboType.currentIndex === 0) {
                outputData.FrameData = {
                    FrameSize: [parseInt(textSpriteFrameWidth.text), parseInt(textSpriteFrameHeight.text)],
                    FrameCount: parseInt(textSpriteFrameCount.text),
                    FrameInterval: parseInt(textSpriteFrameInterval.text),

                    OffsetIndex: [parseInt(textSpriteFrameOffsetColumn.text), parseInt(textSpriteFrameOffsetRow.text)],
                };
            }
            else if(comboType.currentIndex === 1) {
                outputData.FrameData = {
                    FrameStartIndex: parseInt(textSpriteFrameStartIndex.text),
                    FrameCount: parseInt(textSpriteFrameCount.text),
                    FrameInterval: parseInt(textSpriteFrameInterval.text),
                };
            }


            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(filepath, JSON.stringify(outputData));
            let ret = $Frame.sl_fileWrite(JSON.stringify(outputData), filepath, 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())


            createJS();

            copyVJS();


            console.debug('[SpriteEditor]exportSprite ret:', ret, filepath);


            return true;
        }



        function close() {
            $dialog.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(exportSprite())
                        sg_close();
                    else {
                        dialogSaveSprite.open();
                    }
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    $dialog.close();
                    root.forceActiveFocus();
                },
            });
        }
    }

    //配置
    QtObject {
        id: _config

        property int nLabelFontSize: 10
        property int nButtonFontSize: 12
        property int nTextFontSize: 10
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[SpriteEditor]Keys.onEscapePressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[SpriteEditor]Keys.onBackPressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onPressed: function(event) {
        console.debug('[SpriteEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;
    }
    Keys.onReleased: function(event) {
        console.debug('[SpriteEditor]Keys.onReleased', event.key, event.isAutoRepeat);
        //console.debug(objActionsData);
        //console.debug(textSpriteFangXiangIndex.text.split(','));
        event.accepted = true;

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;
    }


    Component.onCompleted: {
        console.debug('[SpriteEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[SpriteEditor]Component.onDestruction');
    }
}
