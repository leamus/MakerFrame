import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0
import 'Core/RPGComponents'


import 'qrc:/QML'


import './Core'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



Item {
    id: root



    signal sg_close();
    onSg_close: {
        role.unload();

        rectImage.visible = false;


        _private.strRoleName = '';
        _private.strTextBackupRoleImageURL = '';
        _private.strTextBackupRoleImageResourceName = '';


        for(let tt of layoutAction2.arrCacheComponent) {
            if(tt.bShowDelete)
                tt.destroy();
        }
        layoutAction2.arrCacheComponent.length = 4;

        for(let tt of layoutAction1.arrCacheComponent) {
            if(tt.bShowDelete)
                tt.destroy();
        }
        layoutAction1.arrCacheComponent.length = 4;
    }



    function newRole() {
        comboType.currentIndex = 0;

        textRoleName.text = "";

        textRoleImageURL.text = "";
        textRoleImageResourceName.text = "";
//        textRoleFrameWidth.text = cfg.FrameSize[0].toString();
//        textRoleFrameHeight.text = cfg.FrameSize[1].toString();
//        textRoleFrameCount.text = cfg.FrameCount.toString();

//        textRoleUpIndexX.text = cfg.FrameIndex[0][0].toString();
//        textRoleUpIndexY.text = cfg.FrameIndex[0][1].toString();
//        textRoleRightIndexX.text = cfg.FrameIndex[1][0].toString();
//        textRoleRightIndexY.text = cfg.FrameIndex[1][1].toString();
//        textRoleDownIndexX.text = cfg.FrameIndex[2][0].toString();
//        textRoleDownIndexY.text = cfg.FrameIndex[2][1].toString();
//        textRoleLeftIndexX.text = cfg.FrameIndex[3][0].toString();
//        textRoleLeftIndexY.text = cfg.FrameIndex[3][1].toString();

//        textRoleFrameInterval.text = cfg.FrameInterval.toString();
//        textRoleWidth.text = cfg.RoleSize[0].toString();
//        textRoleHeight.text = cfg.RoleSize[1].toString();
//        textRoleRealX.text = cfg.RealOffset[0].toString();
//        textRoleRealY.text = cfg.RealOffset[1].toString();
//        textRoleRealWidth.text = cfg.RealSize[0].toString();
//        textRoleRealHeight.text = cfg.RealSize[1].toString();
//        textRoleSpeed.text = cfg.MoveSpeed.toString();

        _private.refreshRole();


        _private.loadScript();
    }


    function openRole(cfg) {

        console.debug("[RoleEditor]openRole:", JSON.stringify(cfg))

        //cfg.Version;
        //cfg.RoleType;
        _private.strRoleName = textRoleName.text = cfg.RoleName.trim();

        textRoleRealX.text = cfg.RealOffset[0].toString();
        textRoleRealY.text = cfg.RealOffset[1].toString();
        textRoleRealWidth.text = cfg.RealSize[0].toString();
        textRoleRealHeight.text = cfg.RealSize[1].toString();
        textRoleShadowOpacity.text = cfg.ShadowOpacity !== undefined ? cfg.ShadowOpacity.toString() : '0.3';

        textRoleSpeed.text = cfg.MoveSpeed !== undefined ? cfg.MoveSpeed.toString() : '0.1';
        textPenetrate.text = cfg.Penetrate !== undefined ? cfg.Penetrate.toString() : '0';
        textShowName.text = cfg.ShowName !== undefined ? cfg.ShowName.toString() : '1';
        textAvatar.text = cfg.Avatar !== undefined ? cfg.Avatar.toString() : '';
        textAvatarWidth.text = (cfg.AvatarSize && cfg.AvatarSize[0] !== undefined ? cfg.AvatarSize[0].toString() : '60');
        textAvatarHeight.text = (cfg.AvatarSize && cfg.AvatarSize[1] !== undefined ? cfg.AvatarSize[1].toString() : '60');

        switch(cfg.SpriteType ?? 1) {
        case 0:
            comboType.currentIndex = 2;
            break;
        case 1:
        case 2:
        default:
            comboType.currentIndex = (cfg.SpriteType ?? 1) - 1;
            break;
        }


        if(comboType.currentIndex === 0) {
            //textRoleImageURL.text = cfg.Image;
            //textRoleImageResourceName.text = textRoleImageURL.text.slice(textRoleImageURL.text.lastIndexOf("/") + 1);
            textRoleImageResourceName.text = cfg.Image;
            textRoleImageURL.text = GameMakerGlobal.spriteResourceURL(cfg.Image);

            textRoleFrameWidth.text = cfg.FrameSize[0].toString();
            textRoleFrameHeight.text = cfg.FrameSize[1].toString();
            textRoleFrameCount.text = cfg.FrameCount.toString();

            textRoleFrameInterval.text = cfg.FrameInterval.toString();
            //role.width = parseInt(textRoleWidth.text);
            //role.height = parseInt(textRoleHeight.text);

            textRoleXOffset.text = (cfg.RoleOffset && cfg.RoleOffset[0]) ? cfg.RoleOffset[0].toString() : '0';
            textRoleYOffset.text = (cfg.RoleOffset && cfg.RoleOffset[1]) ? cfg.RoleOffset[1].toString() : '0';
            textRoleWidth.text = cfg.RoleSize[0].toString();
            textRoleHeight.text = cfg.RoleSize[1].toString();
            textRoleFrameXScale.text = ((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0].toString() : '1');
            textRoleFrameYScale.text = ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1].toString() : '1');

            //textRoleFangXiangIndex.text = cfg.FrameIndex.toString();
            textRoleUpIndexX.text = cfg.FrameIndex[0][0].toString();
            textRoleUpIndexY.text = cfg.FrameIndex[0][1].toString();
            textRoleRightIndexX.text = cfg.FrameIndex[1][0].toString();
            textRoleRightIndexY.text = cfg.FrameIndex[1][1].toString();
            textRoleDownIndexX.text = cfg.FrameIndex[2][0].toString();
            textRoleDownIndexY.text = cfg.FrameIndex[2][1].toString();
            textRoleLeftIndexX.text = cfg.FrameIndex[3][0].toString();
            textRoleLeftIndexY.text = cfg.FrameIndex[3][1].toString();
        }
        else if(comboType.currentIndex === 1) {
            //textRoleImageURL.text = cfg.Image;
            //textRoleImageResourceName.text = textRoleImageURL.text.slice(textRoleImageURL.text.lastIndexOf("/") + 1);
            textRoleImageResourceName.text = cfg.Image;
            textRoleImageURL.text = GameMakerGlobal.spriteResourceURL(cfg.Image);


            for(let tt in cfg.FrameIndex) {
                let tObj;
                if(tt === '$Up') {
                    tObj = layoutAction1.arrCacheComponent[0];
                }
                else if(tt === '$Right') {
                    tObj = layoutAction1.arrCacheComponent[1];
                }
                else if(tt === '$Down') {
                    tObj = layoutAction1.arrCacheComponent[2];
                }
                else if(tt === '$Left') {
                    tObj = layoutAction1.arrCacheComponent[3];
                }
                else {
                    tObj = compActions1.createObject(layoutAction1);
                    layoutAction1.arrCacheComponent.push(tObj);
                }

                tObj.arrComps[0].text = tt;
                tObj.arrComps[1].text = cfg.FrameIndex[tt][0];
                tObj.arrComps[2].text = cfg.FrameIndex[tt][1];
                tObj.arrComps[3].text = cfg.FrameIndex[tt][2];
            }


            textRoleXOffset.text = (cfg.RoleOffset && cfg.RoleOffset[0]) ? cfg.RoleOffset[0].toString() : '0';
            textRoleYOffset.text = (cfg.RoleOffset && cfg.RoleOffset[1]) ? cfg.RoleOffset[1].toString() : '0';
            textRoleWidth.text = cfg.RoleSize[0].toString();
            textRoleHeight.text = cfg.RoleSize[1].toString();
            textRoleFrameXScale.text = ((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0].toString() : '1');
            textRoleFrameYScale.text = ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1].toString() : '1');

        }
        else if(comboType.currentIndex === 2) {

            for(let tt in cfg.FrameIndex) {
                let tObj;
                if(tt === '$Up') {
                    tObj = layoutAction2.arrCacheComponent[0];
                }
                else if(tt === '$Right') {
                    tObj = layoutAction2.arrCacheComponent[1];
                }
                else if(tt === '$Down') {
                    tObj = layoutAction2.arrCacheComponent[2];
                }
                else if(tt === '$Left') {
                    tObj = layoutAction2.arrCacheComponent[3];
                }
                else {
                    tObj = compActions2.createObject(layoutAction2);
                    layoutAction2.arrCacheComponent.push(tObj);
                }

                tObj.arrComps[0].text = tt;
                tObj.arrComps[1].text = cfg.FrameIndex[tt][0];
            }
        }

        _private.refreshRole();


        _private.loadScript(textRoleName.text);
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Component {
        id: compActions2

        Item {
            id: tRoot

            property bool bShowDelete: true
            property alias textActionName: ttextActionName.text
            property alias bActionReadOnly: ttextActionName.readOnly
            property alias bActionColor: ttextActionName.color

            //property alias textActionName: ttextActionName
            //property alias textSpriteName: ttextSpriteName
            property var arrComps: [ttextActionName, ttextSpriteName]


            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            RowLayout {
                anchors.fill: parent

                TextField {
                    id: ttextActionName

                    objectName: 'ActionName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: ''
                    placeholderText: '*动作名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                TextField {
                    id: ttextSpriteName

                    objectName: 'SpriteName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: ''
                    placeholderText: '*@特效名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

                        l_list.open({
                            Data: path,
                            CustomData: this,
                            OnClicked: (index, item, customData)=>{
                                text = item;

                                l_list.visible = false;
                                customData.forceActiveFocus();
                            },
                            OnCanceled: (customData)=>{
                                l_list.visible = false;
                                customData.forceActiveFocus();
                            },
                        });
                    }

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                Button {
                    implicitWidth: 30

                    text: 'p'

                    onClicked: {
                        _private.doAction(ttextActionName.text);
                    }
                }

                Button {
                    id: tbutton

                    visible: bShowDelete
                    implicitWidth: 30

                    text: 'x'

                    onClicked: {
                        for(let tc in layoutAction2.arrCacheComponent) {
                            if(layoutAction2.arrCacheComponent[tc] === tRoot) {
                                layoutAction2.arrCacheComponent.splice(tc, 1);
                                break;
                            }
                        }
                        tRoot.destroy();

                        _private.refreshRole();
                    }
                }
            }
        }
    }


    Component {
        id: compActions1

        Item {
            id: tRoot

            property bool bShowDelete: true
            property alias textActionName: ttextActionName.text
            property alias bActionReadOnly: ttextActionName.readOnly
            property alias bActionColor: ttextActionName.color

            //property alias textActionName: ttextActionName
            //property alias textFrameStartIndex: ttextFrameStartIndex
            //property alias textFrameCount: ttextFrameCount
            property alias textFrameInterval: ttextFrameInterval
            property var arrComps: [ttextActionName, ttextFrameStartIndex, ttextFrameCount, ttextFrameInterval]


            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            RowLayout {
                anchors.fill: parent

                TextField {
                    id: ttextActionName

                    objectName: 'ActionName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: ''
                    placeholderText: '*动作名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                TextField {
                    id: ttextFrameStartIndex

                    objectName: 'FrameStartIndex'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: '0'
                    placeholderText: '*起始序号'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                TextField {
                    id: ttextFrameCount

                    objectName: 'FrameCount'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: '4'
                    placeholderText: '*帧数'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                TextField {
                    id: ttextFrameInterval

                    objectName: 'FrameInterval'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    font.pointSize: _config.nTextFontSize
                    text: '100'
                    placeholderText: '*帧速度'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onEditingFinished: {
                        //text = !isNaN(parseInt(text)) ? parseInt(text) : '0.1';

                        _private.refreshRole();
                    }
                }

                Button {
                    implicitWidth: 30

                    text: 'p'

                    onClicked: {
                        _private.doAction(ttextActionName.text);
                    }
                }

                Button {
                    id: tbutton

                    visible: bShowDelete
                    implicitWidth: 30

                    text: 'x'

                    onClicked: {
                        for(let tc in layoutAction1.arrCacheComponent) {
                            if(layoutAction1.arrCacheComponent[tc] === tRoot) {
                                layoutAction1.arrCacheComponent.splice(tc, 1);
                                break;
                            }
                        }
                        tRoot.destroy();

                        _private.refreshRole();
                    }
                }
            }
        }
    }



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
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
                            text: '类型：'
                        }

                        ComboBox {
                            id: comboType

                            Layout.fillWidth: true


                            model: ['典型行走行列图', '序列图片文件', '从特效选择']

                            background: Rectangle {
                                //implicitWidth: comboBoxComponentItem.comboBoxWidth
                                implicitHeight: 35
                                //border.color: control.pressed ? "#6495ED" : "#696969"
                                //border.width: control.visualFocus ? 2 : 1
                                color: "transparent"
                                //border.color: comboBoxComponentItem.color
                                border.width: 2
                                radius: 6
                            }

                            onActivated: {
                                console.debug('[RoleEditor]ComboBox:', comboType.currentIndex,
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
                        //Layout.preferredWidth: root.width * 0.96
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "移动速度"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleSpeed

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0.1"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '0.1';

                                //_private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "可穿透"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textPenetrate

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                //_private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "显示名字"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textShowName

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "1"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '1';

                                //_private.refreshRole();
                            }
                        }
                    }

                    RowLayout {
                        //Layout.preferredWidth: root.width * 0.96
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "@头像和大小"
                            font.pointSize: _config.nLabelFontSize
                        }

                        //头像
                        TextField {
                            id: textAvatar

                            //Layout.preferredWidth: 50
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight
                            Layout.preferredWidth: Math.max(contentWidth + 10, 90)

                            text: ''
                            placeholderText: '@头像图片'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.imageResourcePath();

                                l_list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text = item;

                                        l_list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        l_list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }

                        //头像宽
                        TextField {
                            id: textAvatarWidth

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '60'
                            placeholderText: '头像宽'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                //_private.refreshRole();
                            }
                        }
                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredWidth: 10

                            text: "*"
                            font.pointSize: _config.nLabelFontSize
                        }

                        //头像高
                        TextField {
                            id: textAvatarHeight

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: '60'
                            placeholderText: '头像高'
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                //_private.refreshRole();
                            }
                        }
                    }

                    RowLayout {
                        //Layout.preferredWidth: root.width * 0.96
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "[影子]"
                            font.pointSize: _config.nLabelFontSize
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "偏移和大小"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleRealX

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshRole();
                            }
                        }

                        TextField {
                            id: textRoleRealY

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshRole();
                            }
                        }

                        TextField {
                            id: textRoleRealWidth

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "50"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '50';

                                _private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "*"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleRealHeight

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            font.pointSize: _config.nTextFontSize
                            text: "80"

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '80';

                                _private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "透明度"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleShadowOpacity

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0.5"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '0.5';

                                _private.refreshRole();
                            }
                        }
                    }

                    RowLayout {
                        visible: comboType.currentIndex === 0 || comboType.currentIndex === 1

                        //Layout.preferredWidth: root.width * 0.96
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50


                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "[角色]"
                            font.pointSize: _config.nLabelFontSize
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "偏移"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleXOffset

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshRole();
                            }
                        }

                        TextField {
                            id: textRoleYOffset

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                _private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "大小"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleWidth

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "50"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '50';

                                _private.refreshRole();
                            }
                        }

                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10

                            text: "*"
                            font.pointSize: _config.nLabelFontSize
                        }

                        TextField {
                            id: textRoleHeight

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "80"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseInt(text)) ? parseInt(text) : '80';

                                _private.refreshRole();
                            }
                        }

                        Label {
                            font.pointSize: _config.nLabelFontSize
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 10
                            text: "X/Y轴缩放"
                        }

                        TextField {
                            id: textRoleFrameXScale

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "1.0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '1.0';

                                _private.refreshRole();
                            }
                        }

                        TextField {
                            id: textRoleFrameYScale

                            Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: _private.nColumnHeight

                            text: "1.0"
                            font.pointSize: _config.nTextFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onEditingFinished: {
                                text = !isNaN(parseFloat(text)) ? parseFloat(text) : '1.0';

                                _private.refreshRole();
                            }
                        }
                    }

                    /*RowLayout {
                        visible: comboType.currentIndex === 0

                        //Layout.preferredWidth: root.width * 0.96
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredHeight: 50

                    }*/


                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredWidth: parent.width

                        visible: comboType.currentIndex === 0


                        RowLayout {
                            //Layout.preferredWidth: root.width * 0.96
                            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 50


                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "[帧]"
                                font.pointSize: _config.nLabelFontSize
                            }

                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "宽高"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleFrameWidth

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "37"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '37';

                                    _private.refreshRole();
                                }
                            }

                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "*"
                                font.pointSize: _config.nLabelFontSize
                            }
                            TextField {
                                id: textRoleFrameHeight

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "58"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '58';

                                    _private.refreshRole();
                                }
                            }

                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "帧数"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleFrameCount

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "3"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '3';

                                    _private.refreshRole();
                                }
                            }


                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "速度（ms）"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleFrameInterval

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "100"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '100';

                                    _private.refreshRole();
                                }
                            }

                        }


                        RowLayout {
                            //Layout.preferredWidth: root.width * 0.96
                            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 50

                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "上向（列行）"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleUpIndexX

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            TextField {
                                id: textRoleUpIndexY

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "右向（列行）"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleRightIndexX

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            TextField {
                                id: textRoleRightIndexY

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                        }

                        RowLayout {
                            //Layout.preferredWidth: root.width * 0.96
                            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredHeight: 50

                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "下向（列行）"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleDownIndexX

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            TextField {
                                id: textRoleDownIndexY

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            Label {
                                //Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: 10

                                text: "左向（列行）"
                                font.pointSize: _config.nLabelFontSize
                            }

                            TextField {
                                id: textRoleLeftIndexX

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                            TextField {
                                id: textRoleLeftIndexY

                                Layout.preferredWidth: Math.max(contentWidth + 10, 20)
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                                //Layout.preferredHeight: _private.nColumnHeight

                                text: "0"
                                font.pointSize: _config.nTextFontSize

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onEditingFinished: {
                                    text = !isNaN(parseInt(text)) ? parseInt(text) : '0';

                                    _private.refreshRole();
                                }
                            }
                        }
                    }


                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredWidth: parent.width

                        visible: comboType.currentIndex === 2


                        Button {
                            Layout.fillWidth: true

                            //visible: false
                            text: '增加动作'

                            onClicked: {
                                let c = compActions2.createObject(layoutAction2);
                                layoutAction2.arrCacheComponent.push(c);

                                GlobalLibraryJS.setTimeout(function() {
                                    if(flickable.contentHeight > flickable.height)
                                        flickable.contentY = flickable.contentHeight - flickable.height;
                                    }, 1, root, '');

                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*动作名'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@特效名'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                        }

                        ColumnLayout {
                            id: layoutAction2

                            property var arrCacheComponent: []

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            spacing: 16

                        }
                    }

                    Button {
                        Layout.fillWidth: true

                        text: '编辑脚本'

                        onClicked: {

                            if(!_private.strRoleName) {
                                dialogCommon.show({
                                      Msg: '请先保存角色',
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


                            //_private.loadScript(textRoleName.text);
                            if(!textCode.text &&
                                    !FrameManager.sl_fileExists(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + _private.strRoleName + GameMakerGlobal.separator + 'role.js')) {
                                if(comboType.currentIndex === 1)
                                    textCode.text = _private.strTemplateCode0;
                                else
                                    textCode.text = '';
                            }


                            dialogScript.open();
                        }
                    }


                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                        Layout.preferredWidth: parent.width

                        visible: comboType.currentIndex === 1


                        Label {
                            Layout.fillWidth: true

                            color: 'red'
                            text: '注意：图片文件夹请自行复制到资源目录；预览请先保存'
                            font.pointSize: _config.nLabelFontSize

                            horizontalAlignment: Label.AlignHCenter
                            verticalAlignment: Label.AlignVCenter

                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Button {
                                Layout.fillWidth: true

                                text: '增加动作'

                                onClicked: {
                                    let c = compActions1.createObject(layoutAction1);
                                    layoutAction1.arrCacheComponent.push(c);

                                    GlobalLibraryJS.setTimeout(function() {
                                        if(flickable.contentHeight > flickable.height)
                                            flickable.contentY = flickable.contentHeight - flickable.height;
                                        }, 1, root, '');

                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*动作名'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*起始序号'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*帧数'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*帧速度'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                        }

                        ColumnLayout {
                            id: layoutAction1

                            property var arrCacheComponent: []

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            spacing: 16
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


            Item {
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Joystick {
                id: joystick

                property var nLastDirection: null

                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                //anchors.margins: 1 * Screen.pixelDensity
                transformOrigin: Item.TopLeft
                opacity: 0.9
                //scale: 0.5
                implicitWidth: 20 * Screen.pixelDensity
                implicitHeight: 20 * Screen.pixelDensity

                onPressedChanged: {
                    if(pressed === false) {
                        nLastDirection = null;
                        _private.stopAction(0);
                    }
                    else
                        forceActiveFocus();
                    console.debug("[RoleEditor]Joystick onPressedChanged:", pressed)
                }

                onPointInputChanged: {
                    if(pointInput === Qt.point(0,0))
                        return;

                    if(!pressed)
                        return;


                    let direction;

                    if(Math.abs(pointInput.x) > Math.abs(pointInput.y)) {
                        if(pointInput.x > 0)
                            direction = Qt.Key_Right;
                        else
                            direction = Qt.Key_Left;
                    }
                    else {
                        if(pointInput.y > 0)
                            direction = Qt.Key_Down;
                        else
                            direction = Qt.Key_Up;
                    }

                    if(direction !== nLastDirection) {
                        _private.doAction(0, direction);
                        nLastDirection = direction;
                    }

                    //console.debug("[RoleEditor]onPointInputChanged", pointInput);
                }
            }

            Item {
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Rectangle {
                id: rectRole
                Layout.alignment: Qt.AlignHCenter

                Layout.preferredWidth: role.width
                Layout.preferredHeight: role.height

                color: 'transparent'
                border {
                    width: 1
                    color: 'lightgray'
                }

                Role {
                    id: role

                    //anchors.fill: parent

                    //width: 37;
                    //height: 58;

                    //sizeFrame: Qt.size(37, 58);
                    /*nFrameCount: 3;
                    arrActionsData: [3,2,1,0];
                    interval: 100;
                    width: 37;
                    height: 58;
                    x1: 0;
                    y1: 0;
                    width1: 37;
                    height1: 58;
                    moveSpeed: 100;*/

                    //bTest: true
                    sprite.nType: 1

                    /*onSg_clicked: {
                        root.forceActiveFocus();
                    }*/

                    mouseArea.onClicked: {
                        _private.refreshRole();

                        fTestChangeDirection();

                        root.forceActiveFocus();
                    }


                    //名字
                    property Text textName: Text {
                        parent: role
                        visible: parseInt(textShowName.text) !== 0
                        width: parent.width
                        height: implicitHeight
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: 'white'

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 9
                        font.bold: true
                        text: textRoleName.text || '<角色名>'
                        wrapMode: Text.NoWrap
                    }

                }
            }

            Item {
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Image {
                Layout.preferredWidth: parseInt(textAvatarWidth.text)
                Layout.preferredHeight: parseInt(textAvatarHeight.text)

                source: textAvatar.text ? GameMakerGlobal.imageResourceURL(textAvatar.text) : ''
            }

            Item {
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                visible: comboType.currentIndex === 0 || comboType.currentIndex === 1
                text: "图片资源"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    textRoleImageURL.enabled = false;
                    textRoleImageResourceName.enabled = true;
                    _private.strTextBackupRoleImageURL = textRoleImageURL.text;
                    _private.strTextBackupRoleImageResourceName = textRoleImageResourceName.text;
                    dialogRoleData.open();
                }
            }

            Button {
                visible: false

                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "刷新"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    _private.refreshRole();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "保存"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    //_private.strRoleName = textRoleName.text;

                    dialogSaveRole.open();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                visible: comboType.currentIndex === 0// || comboType.currentIndex === 2
                text: "原图"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    if(textRoleImageURL.text)
                        _private.showImage();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "帮助"
                font.pointSize: _config.nButtonFontSize

                onClicked: {

                    rootGameMaker.showMsg('
  角色大小：游戏中显示的大小（宽和高），根据你游戏整体风格来设置；
  X/Y轴缩放：表示在X、Y方向上放大或缩小多少倍，负数表示镜像（反转）；
  影子偏移坐标和大小：影子表示角色的实际占位，会影响角色到障碍或边界的碰撞，一般斜视地图的效果是将影子放在角色下半身，正视地图的效果是角色全部；
  影子透明度：值范围 0~1，阴影程度；
  帧速度：你懂的，一般100；
  帧宽高：将图片切割为每一帧的大小（填错会导致显示效果出问题）；
  帧数：每个方向的行走图有多少帧；
  上右下左：将一张图切割为 m列*n行 个帧，则角色的上、右、下、左的 第一个帧 分别是 哪列哪行（可以理解为x、y坐标，0开始）；
  移动速度：角色在地图上的移动速度。这个值单位是 像素/毫秒（为了适应各种刷新率下速度一致），具体要根据图块大小来设置（一般设置为0.1-0.2即可）；
  可穿透：角色是否可以穿过角色或障碍（0b1为可穿透其他角色，0b10为可穿透障碍）；
  显示名字：角色头顶是否显示名字（0或1）；
  头像和大小：使用对话命令的时候，会带有这个头像；

')
                }
            }

            Button {
                visible: Platform.compileType === "debug" ? true : false
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "Test"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
                    /*role.sprite.running = true;
                    console.debug("[Role]test", role.sprite, role.sprite.state, role.sprite.currentSprite)
                    console.debug(role.sprite.sprites);
                    for(let s in role.sprite.sprites) {
                        console.debug(role.sprite.sprites[s].frameY);
                        role.sprite.sprites[s].frameY = 20*s;
                        console.debug(role.sprite.sprites[s].frameY);
                    }*/
                    dialogDebugScript.open();
                }
            }

        }

    }






    Dialog1.FileDialog {
        id: filedialogOpenRoleImage

        title: "选择角色图片"
        //folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png *.bmp)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        visible: false
        onAccepted: {
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.focus = true;
            //loader.forceActiveFocus();


            console.debug("[RoleEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textRoleImageURL.text = Platform.sl_getRealPathFromURI(fileUrl);
            else
                textRoleImageURL.text = FrameManager.sl_urlDecode(fileUrl);

            textRoleImageResourceName.text = textRoleImageURL.text.slice(textRoleImageURL.text.lastIndexOf("/") + 1);


            textRoleImageURL.enabled = true;
            textRoleImageResourceName.enabled = true;


            checkboxSaveResource.checked = true;
            checkboxSaveResource.enabled = false;


            //console.log("You chose: " + fileDialog.fileUrls);
            //Qt.quit();
        }
        onRejected: {
            //root.forceActiveFocus();

            console.debug("[RoleEditor]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;

        }
    }


    Dialog {
        id: dialogRoleData

        //1图片，2素材
        //property int nChoiceType: 0


        title: "角色图片数据"
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
                    id: textRoleImageURL
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
                    id: textRoleImageResourceName
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
                Layout.alignment: Qt.AlignHCenter

                Button {
                    visible: comboType.currentIndex === 0

                    text: "选择图片文件"

                    onClicked: {
                        //dialogRoleData.nChoiceType = 1;
                        filedialogOpenRoleImage.open();
                        //root.forceActiveFocus();
                    }
                }
                Button {
                    text: "选择素材"

                    onClicked: {
                        //dialogRoleData.nChoiceType = 2;

                        let path = GameMakerGlobal.spriteResourcePath();

                        if(comboType.currentIndex === 0)
                            l_listRoleResource.show(path, "*", 0x002, 0x00);
                        else if(comboType.currentIndex === 1)
                            l_listRoleResource.show(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);
                        l_listRoleResource.visible = true;
                        //l_listRoleResource.focus = true;
                        //l_listRoleResource.forceActiveFocus();

                        dialogRoleData.visible = false;
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelDialogTips
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    wrapMode: Label.WrapAnywhere
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //路径 操作

            /*if(textRoleImageURL.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "路径不能为空";
                Platform.sl_showToast("路径不能为空");
                return;
            }*/
            if(textRoleImageResourceName.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "资源名不能为空";
                Platform.sl_showToast("资源名不能为空");
                return;
            }
            //系统图片
            //if(dialogRoleData.nChoiceType === 1) {
            if(checkboxSaveResource.checked) {
                let ret = FrameManager.sl_fileCopy(GlobalJS.toPath(textRoleImageURL.text), GameMakerGlobal.spriteResourcePath(textRoleImageResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelDialogTips.text = "拷贝资源失败，是否重名或目录不可写？";
                    Platform.sl_showToast("拷贝资源失败，是否重名或目录不可写？");
                    //console.debug("[RoleEditor]Copy ERROR:", textRoleImageURL.text);

                    //root.forceActiveFocus();
                    return;
                }

            }
            else {  //资源图库

                //console.debug("ttt2:", filepath);

                //console.debug("ttt", textRoleImageURL.text, Qt.resolvedUrl(textRoleImageURL.text))
            }

            //textRoleImageURL.text = textRoleImageResourceName.text;
            textRoleImageURL.text = GameMakerGlobal.spriteResourceURL(textRoleImageResourceName.text);


            if(comboType.currentIndex === 0) {
                if(!FrameManager.sl_fileExists(GlobalJS.toPath(textRoleImageURL.text))) {
                    open();
                    //visible = true;
                    labelDialogTips.text = "路径错误或文件不存在:" + GlobalJS.toPath(textRoleImageURL.text);
                    Platform.sl_showToast("路径错误或文件不存在" + GlobalJS.toPath(textRoleImageURL.text));
                    return;
                }
            }
            else if(comboType.currentIndex === 1) {
                if(!FrameManager.sl_dirExists(GlobalJS.toPath(textRoleImageURL.text))) {
                    open();
                    //visible = true;
                    labelDialogTips.text = "路径错误或文件夹不存在:" + GlobalJS.toPath(textRoleImageURL.text);
                    Platform.sl_showToast("路径错误或文件夹不存在" + GlobalJS.toPath(textRoleImageURL.text));
                    return;
                }
            }
            else if(comboType.currentIndex === 2) {

            }



            textRoleImageURL.enabled = false;
            textRoleImageResourceName.enabled = true;


            _private.refreshRole();


            labelDialogTips.text = '';
            /*
            textRoleImageURL.text = "";
            textRoleImageResourceName.text = "";
            textRoleImageResourceName.enabled = true;
            */


            //visible = false;
            //root.visible = true;
            //dialogRoleData.focus = false;
            //loader.focus = true;
            //loader.item.focus = true;
            root.forceActiveFocus();

            //console.log("Ok clicked");
        }
        onRejected: {
            textRoleImageURL.text = _private.strTextBackupRoleImageURL;
            textRoleImageResourceName.text = _private.strTextBackupRoleImageResourceName;


            labelDialogTips.text = "";
            /*
            textRoleImageURL.text = "";
            textRoleImageResourceName.text = "";
            textRoleImageResourceName.enabled = true;
            */


            root.forceActiveFocus();


            //console.log("Cancel clicked");
            /*鹰：这点组件树的focus有点奇怪
            let p = dialogRoleData;
            let n = 20;
            while(n > 0 && p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
                --n;
            }

            root.focus = true;
            dialogRoleData.focus = true;
            root.parent.parent.focus = true;
            console.debug(root.parent.parent.focus);


            p = dialogRoleData;
            while(p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
            }*/
        }
    }


    L_List {
        id: l_listRoleResource

        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor

        //removeButtonVisible: false


        onClicked: {
            textRoleImageURL.text = GameMakerGlobal.spriteResourceURL(item);
            textRoleImageResourceName.text = item;

            textRoleImageURL.enabled = false;
            textRoleImageResourceName.enabled = true;


            dialogRoleData.visible = true;


            checkboxSaveResource.checked = false;
            checkboxSaveResource.enabled = false;


            //let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_fileRead(fileUrl);


            visible = false;
            //root.focus = true;
            root.forceActiveFocus();

            console.debug("[RoleEditor]fileURL", textRoleImageURL.text);
        }

        onCanceled: {
            dialogRoleData.visible = true;

            visible = false;
            //loader.visible = true;
            //root.focus = true;
            root.forceActiveFocus();
            //loader.item.focus = true;
        }

        onRemoveClicked: {
            let filepath = GameMakerGlobal.spriteResourcePath(item);

            dialogCommon.show({
                Msg: '确认删除？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug("[RoleEditor]删除：" + filepath, Qt.resolvedUrl(filepath), FrameManager.sl_fileExists(filepath), FrameManager.sl_fileDelete(filepath));
                    removeItem(index);

                    l_listRoleResource.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listRoleResource.forceActiveFocus();
                },
            });
        }
    }






    Dialog {
        id: dialogScript

        visible: false
        title: "角色脚本"
        width: parent.width * 0.9
        //height: parent.height * 0.9
        anchors.centerIn: parent


        modal: true
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
        standardButtons: Dialog.Ok | Dialog.Cancel


        ColumnLayout {
            anchors.fill: parent


            RowLayout {
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    //Layout.preferredHeight: 70

                    text: '查'

                    onClicked: {
                        let e = GameMakerGlobalJS.checkJSCode(FrameManager.sl_toPlainText(textCode.textDocument));

                        if(e) {
                            dialogCommon.show({
                                Msg: e,
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

                        dialogCommon.show({
                            Msg: '恭喜，没有语法错误',
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
                }

                Button {
                    Layout.fillWidth: true
                    //Layout.preferredHeight: 70

                    text: 'V'

                    onClicked: {
                        /*if(!_private.strMapName) {
                            dialogCommon.show({
                                  Msg: '请先保存地图',
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
                        */

                        gameVisualScript.show();

                        dialogScript.visible = false;
                    }
                }
            }

            Notepad {
                id: textCode

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.implicitHeight
                Layout.maximumHeight: root.height * 0.6
                Layout.minimumHeight: 60
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                //textArea.enabled: false
                //textArea.readOnly: true
                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: "请输入脚本代码"

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }

                bCode: true
            }
        }


        onAccepted: {
            _private.saveJS();

            _private.refreshRole();


            root.forceActiveFocus();

            //console.debug("[MapEditor]onAccepted");
        }
        onRejected: {
            root.forceActiveFocus();

            //console.debug("[MapEditor]onRejected");
        }
    }



    //导出对话框
    Dialog {
        id: dialogSaveRole
        title: "请输入名称"
        width: parent.width * 0.9
        //height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            textRoleName.text = textRoleName.text.trim();
            if(textRoleName.text.length === 0) {
                //Platform.sl_showToast("名称不能为空");
                textDialogMsg.text = "名称不能为空";
                open();
                return;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + textRoleName.text;

            function fnSave() {
                if(_private.exportRole()) {
                    //第一次保存，重新刷新
                    if(_private.strRoleName === '') {
                        _private.loadScript(textRoleName.text);
                        _private.refreshRole();
                    }

                    _private.strRoleName = textRoleName.text;

                    textDialogMsg.text = '';

                    //root.focus = true;
                    root.forceActiveFocus();
                }
                else {
                    open();
                }
            }

            if(textRoleName.text !== _private.strRoleName && FrameManager.sl_dirExists(path)) {
                dialogCommon.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textRoleName.text = _private.strRoleName;

                        textDialogMsg.text = '';

                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        dialogCommon.close();

                        root.forceActiveFocus();
                    },*/
                });
            }
            else
                fnSave();

        }
        onRejected: {
            textRoleName.text = _private.strRoleName;

            textDialogMsg.text = '';


            //root.focus = true;
            root.forceActiveFocus();

            //console.log("Cancel clicked");
        }

        ColumnLayout {
            width: parent.width
            height: implicitHeight

            RowLayout {
                //width: parent.width
                Label {
                    text: qsTr("角色名：")
                }
                TextField {
                    id: textRoleName

                    Layout.fillWidth: true
                    placeholderText: "深林孤鹰"
                    text: ""

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            /*RowLayout {
                //width: parent.width
                Label {
                    text: qsTr("地图缩放：")
                }
                TextField {
                    id: textMapScale
                    Layout.fillWidth: true
                    selectByMouse: true
                    placeholderText: "1"
                    text: "1"

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

        title: "执行脚本"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: "输入脚本命令"

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

        Label {
            //color: 'white'
            text: image.implicitWidth + ' x ' + image.implicitHeight
            font.pointSize: 16
        }

        MouseArea {
            anchors.fill: parent
            onClicked: rectImage.visible = false;
        }
    }



    //可视化
    //Loader {
    VisualScript {
        id: gameVisualScript
        //id: loaderVisualScript


        function show() {
            visible = true;
            //focus = true;
            forceActiveFocus();
            //item.focus = true;
            //item.forceActiveFocus();
        }


        anchors.fill: parent

        visible: false
        //focus: true


        //source: './GameVisualScript.qml'
        /*sourceComponent: Component {
            VisualScript {

            }
        }
        */
        //asynchronous: false


        strTitle: `${_private.strRoleName}(角色脚本)`

        defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        defaultCommandTemplate: [{"command":"函数/生成器{","params":["*$start",""],"status":{"enabled":true}},{"command":"块结束}","params":[],"status":{"enabled":true}}]



        /*onLoaded: {
            //let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "role.vjs";
            //item.loadData(filePath);

            console.debug("[MapEditor]loaderVisualScript onLoaded");
        }
        */

        //Connections {
        //    target: loaderVisualScript.item
            onSg_close: function() {
                //_private.loadScript();
                dialogScript.visible = true;


                gameVisualScript.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }

            onSg_compile: function(code) {
                textCode.setPlainText(code);
                textCode.toBegin();
            }
        //}
    }



    QtObject {
        id: _private


        property int nColumnHeight: 50

        property string strRoleName: ''
        property string strTextBackupRoleImageURL
        property string strTextBackupRoleImageResourceName

        property var jsEngine: new GlobalJS.JSEngine(root)

        property string strTemplateCode0: `
//保存坐标偏移数据
let imageFixPositions;

//刷新图片和偏移坐标
function $refresh(index, imageAnimate, path) {
    if(imageFixPositions === undefined) {
        //读取坐标偏移文件并保存
        imageFixPositions = FrameManager.sl_fileRead(GlobalJS.toPath(path) + GameMakerGlobal.separator + 'x.txt');
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
            _private.refreshRole();
        }


        function showImage() {
            image.source = textRoleImageURL.text;
            rectImage.visible = true;
        }


        //刷新
        function refreshRole() {
            switch(comboType.currentIndex) {
            case 2:
                role.nSpriteType = 0;
                break;
            case 0:
            case 1:
            default:
                role.nSpriteType = comboType.currentIndex + 1;
                break;
            }


            if(comboType.currentIndex === 0) {
                //role.arrActionsData = textRoleFangXiangIndex.text.split(',');
                role.arrActionsData = [[parseInt(textRoleUpIndexX.text), parseInt(textRoleUpIndexY.text)],
                                               [parseInt(textRoleRightIndexX.text), parseInt(textRoleRightIndexY.text)],
                                               [parseInt(textRoleDownIndexX.text), parseInt(textRoleDownIndexY.text)],
                                               [parseInt(textRoleLeftIndexX.text), parseInt(textRoleLeftIndexY.text)]];

                //注意这个放在 role.sprite.sprite.width 和 role.sprite.sprite.height 之前
                role.sprite.sprite.sizeFrame = Qt.size(parseInt(textRoleFrameWidth.text), parseInt(textRoleFrameHeight.text));


                role.strSource = textRoleImageURL.text;

                role.nFrameCount = parseInt(textRoleFrameCount.text);
                role.nInterval = parseInt(textRoleFrameInterval.text);

                role.width = parseInt(textRoleWidth.text);
                role.height = parseInt(textRoleHeight.text);
                //role.sprite.sprite.width = parseInt(textRoleWidth.text);
                //role.sprite.sprite.height = parseInt(textRoleHeight.text);
                //role.sprite.width = parseInt(textRoleWidth.text);
                //role.sprite.height = parseInt(textRoleHeight.text);
                role.rXOffset = parseInt(textRoleXOffset.text);
                role.rYOffset = parseInt(textRoleYOffset.text);
                role.rXScale = parseFloat(textRoleFrameXScale.text);
                role.rYScale = parseFloat(textRoleFrameYScale.text);

            }
            else if(comboType.currentIndex === 1) {
                role.strSource = textRoleImageURL.text;

                role.width = parseInt(textRoleWidth.text);
                role.height = parseInt(textRoleHeight.text);
                //role.sprite.sprite.width = parseInt(textRoleWidth.text);
                //role.sprite.sprite.height = parseInt(textRoleHeight.text);
                //role.sprite.width = parseInt(textRoleWidth.text);
                //role.sprite.height = parseInt(textRoleHeight.text);
                role.rXOffset = parseInt(textRoleXOffset.text);
                role.rYOffset = parseInt(textRoleYOffset.text);
                role.rXScale = parseFloat(textRoleFrameXScale.text);
                role.rYScale = parseFloat(textRoleFrameYScale.text);


                role.arrActionsData = {};
                let actionNames = FrameManager.sl_findChildren(layoutAction1, 'ActionName');
                let frameStartIndexes = FrameManager.sl_findChildren(layoutAction1, 'FrameStartIndex');
                let frameCounts = FrameManager.sl_findChildren(layoutAction1, 'FrameCount');
                let frameIntervals = FrameManager.sl_findChildren(layoutAction1, 'FrameInterval');

                for(let tt in actionNames) {
                    if(actionNames[tt].text.trim() && frameStartIndexes[tt].text.trim() && frameCounts[tt].text.trim() && frameIntervals[tt].text.trim())
                        role.arrActionsData[actionNames[tt].text.trim()] = [
                            parseInt(frameStartIndexes[tt].text.trim()), parseInt(frameCounts[tt].text.trim()), parseInt(frameIntervals[tt].text.trim())
                        ];
                    else {
                        return false;
                    }
                }


                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + textRoleName.text;
                if(FrameManager.sl_fileExists(path + GameMakerGlobal.separator + 'role.js')) {
                    _private.jsEngine.clear();
                    let ts = _private.jsEngine.load('role.js', GlobalJS.toURL(path));
                    role.sprite.sprite.fnRefresh = ts.$refresh;
                    //FrameManager.sl_clearComponentCache();
                    //FrameManager.sl_trimComponentCache();
                }
            }
            else if(comboType.currentIndex === 2) {
                //role.implicitWidth = parseInt(textRoleWidth.text);
                //role.implicitHeight = parseInt(textRoleHeight.text);

                role.arrActionsData = {};
                let actionNames = FrameManager.sl_findChildren(layoutAction2, 'ActionName');
                let SpriteNames = FrameManager.sl_findChildren(layoutAction2, 'SpriteName');

                for(let tt in actionNames) {
                    if(actionNames[tt].text.trim() && SpriteNames[tt].text.trim()) {
                        //role.arrActionsData[actionNames[tt].text.trim()] = [
                        //    SpriteNames[tt].text.trim()
                        //];

                        let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;
                        let data = FrameManager.sl_fileRead(GlobalJS.toPath(path + GameMakerGlobal.separator + SpriteNames[tt].text.trim() + GameMakerGlobal.separator + "sprite.json"));
                        if(data)
                            data = JSON.parse(data);
                        //else
                        //    return false;
                        role.arrActionsData[actionNames[tt].text.trim()] = data;
                    }
                    else {
                        textDialogMsg.text = "有必填项没填";
                        return false;
                    }
                }
            }

            role.x1 = parseInt(textRoleRealX.text);
            role.y1 = parseInt(textRoleRealY.text);
            role.width1 = parseInt(textRoleRealWidth.text);
            role.height1 = parseInt(textRoleRealHeight.text);
            role.rectShadow.opacity = parseFloat(textRoleShadowOpacity.text);

            //role.moveSpeed = parseFloat(textRoleSpeed.text);


            //rectRole.Layout.preferredWidth = rectRole.width = role.sprite.width;
            //rectRole.Layout.preferredHeight = rectRole.height = role.sprite.height;


            role.reset();

            /*role.sizeFrame = Qt.size(37, 58);
            role.nFrameCount = 3;
            role.arrActionsData = [3,2,1,0];
            role.interval = 100;
            role.width = 37;
            role.height = 58;
            role.x1 = 0;
            role.y1 = 0;
            role.width1 = 37;
            role.height1 = 58;
            role.moveSpeed = 100;
            */
            //console.debug("测试:", role.width, role.height, parseInt(textRoleWidth.text), parseInt(textRoleHeight.text))
        }


        function loadScript(roleName) {
            if(!roleName) {
                //textCode.text = _private.strTemplateCode0;
                textCode.text = '';
                gameVisualScript.loadData(null);
                return;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + roleName + GameMakerGlobal.separator;
            //if(FrameManager.sl_fileExists(path + 'role.js')) {
            //File.read(path + 'role.js');
            textCode.text = FrameManager.sl_fileRead(path + 'role.js') || '';
            //textCode.setPlainText(data);
            //textCode.toBegin();
            gameVisualScript.loadData(path + 'role.vjs');
        }

        //保存js文件
        function saveJS() {
            //第一次保存，重新刷新
            if(_private.strRoleName === '') {
                if(comboType.currentIndex === 1)    //序列图片文件
                    textCode.text = _private.strTemplateCode0;
                else
                    textCode.text = '';
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + textRoleName.text;
            let ret = FrameManager.sl_fileWrite(FrameManager.sl_toPlainText(textCode.textDocument), path + GameMakerGlobal.separator + 'role.js', 0);
        }
        //复制可视化
        function copyVJS() {
            //如果路径不为空，且是另存为，则赋值vjs文件
            if(_private.strRoleName !== '' && textRoleName.text !== '' && _private.strRoleName !== textRoleName.text) {
                let oldFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + _private.strRoleName + GameMakerGlobal.separator + 'role.vjs';
                if(FrameManager.sl_fileExists(oldFilePath)) {
                    let newFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + textRoleName.text + GameMakerGlobal.separator + 'role.vjs';
                    let ret = FrameManager.sl_fileCopy(oldFilePath, newFilePath, true);
                }
            }
        }

        //导出角色
        function exportRole() {

            let roleName = textRoleName.text;
            let filepath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + roleName + GameMakerGlobal.separator + 'role.json';

            /*//if(!FrameManager.sl_dirExists(path))
                FrameManager.sl_dirCreate(path);
            */

            let outputData = {};
            /*outputData.Version = "0.6";
            outputData.RoleName = roleName;
            outputData.RoleType = 1; //角色类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.RoleSize = [role.implicitWidth, role.implicitHeight];
            outputData.FrameSize = [role.sizeFrame.width, role.sizeFrame.height];
            outputData.FrameCount = role.nFrameCount;
            outputData.FrameIndex = role.arrActionsData.toString();
            outputData.FrameInterval = role.interval;
            outputData.RealOffset = [role.x1, role.y1];
            outputData.RealSize = [role.width1, role.height1];
            outputData.MoveSpeed = role.moveSpeed;
            outputData.Image = role.strSource;
            */
            outputData.Version = "0.9";
            outputData.RoleName = roleName;
            outputData.RoleType = 1; //角色类型
            //outputData.SpriteType = comboType.currentIndex + 1;
            switch(comboType.currentIndex) {
            case 2:
                outputData.SpriteType = 0;
                break;
            case 0:
            case 1:
            default:
                outputData.SpriteType = comboType.currentIndex + 1;
                break;
            }

            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);

            outputData.RealOffset = [parseInt(textRoleRealX.text), parseInt(textRoleRealY.text)];
            outputData.RealSize = [parseInt(textRoleRealWidth.text), parseInt(textRoleRealHeight.text)];
            outputData.ShadowOpacity = parseFloat(textRoleShadowOpacity.text);

            outputData.MoveSpeed = parseFloat(textRoleSpeed.text);
            outputData.Penetrate = parseInt(textPenetrate.text);
            outputData.ShowName = parseInt(textShowName.text);

            outputData.Avatar = textAvatar.text;
            outputData.AvatarSize = [parseInt(textAvatarWidth.text), parseInt(textAvatarHeight.text)];

            if(comboType.currentIndex === 0) {
                outputData.Image = textRoleImageResourceName.text;

                //outputData.FrameIndex = textRoleFangXiangIndex.text;
                outputData.FrameIndex = [[parseInt(textRoleUpIndexX.text), parseInt(textRoleUpIndexY.text)],
                                               [parseInt(textRoleRightIndexX.text), parseInt(textRoleRightIndexY.text)],
                                               [parseInt(textRoleDownIndexX.text), parseInt(textRoleDownIndexY.text)],
                                               [parseInt(textRoleLeftIndexX.text), parseInt(textRoleLeftIndexY.text)]];

                outputData.FrameSize = [parseInt(textRoleFrameWidth.text), parseInt(textRoleFrameHeight.text)];
                outputData.FrameCount = parseInt(textRoleFrameCount.text);
                outputData.FrameInterval = parseInt(textRoleFrameInterval.text);

                outputData.RoleOffset = [parseInt(textRoleXOffset.text), parseInt(textRoleYOffset.text)];
                outputData.RoleSize = [parseInt(textRoleWidth.text), parseInt(textRoleHeight.text)];
                outputData.Scale = [parseFloat(textRoleFrameXScale.text), parseFloat(textRoleFrameYScale.text)];
            }
            else if(comboType.currentIndex === 1) {
                outputData.Image = textRoleImageResourceName.text;


                outputData.FrameIndex = {};
                let actionNames = FrameManager.sl_findChildren(layoutAction1, 'ActionName');
                let frameStartIndexes = FrameManager.sl_findChildren(layoutAction1, 'FrameStartIndex');
                let frameCounts = FrameManager.sl_findChildren(layoutAction1, 'FrameCount');
                let frameIntervals = FrameManager.sl_findChildren(layoutAction1, 'FrameInterval');

                for(let tt in actionNames) {
                    if(actionNames[tt].text.trim() && frameStartIndexes[tt].text.trim() && frameCounts[tt].text.trim() && frameIntervals[tt].text.trim())
                        outputData.FrameIndex[actionNames[tt].text.trim()] = [
                            parseInt(frameStartIndexes[tt].text.trim()), parseInt(frameCounts[tt].text.trim()), parseInt(frameIntervals[tt].text.trim())
                        ];
                    else {
                        textDialogMsg.text = "有必填项没填";
                        return false;
                    }
                }


                outputData.RoleOffset = [parseInt(textRoleXOffset.text), parseInt(textRoleYOffset.text)];
                outputData.RoleSize = [parseInt(textRoleWidth.text), parseInt(textRoleHeight.text)];
                outputData.Scale = [parseFloat(textRoleFrameXScale.text), parseFloat(textRoleFrameYScale.text)];
            }
            else if(comboType.currentIndex === 2) {
                outputData.FrameIndex = {};
                let actionNames = FrameManager.sl_findChildren(layoutAction2, 'ActionName');
                let SpriteNames = FrameManager.sl_findChildren(layoutAction2, 'SpriteName');

                for(let tt in actionNames) {
                    if(actionNames[tt].text.trim() && SpriteNames[tt].text.trim())
                        outputData.FrameIndex[actionNames[tt].text.trim()] = [
                            SpriteNames[tt].text.trim()
                        ];
                    else {
                        textDialogMsg.text = "有必填项没填";
                        return false;
                    }
                }
            }


            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(filepath, JSON.stringify(outputData));
            let ret = FrameManager.sl_fileWrite(JSON.stringify(outputData), filepath, 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())


            saveJS();

            copyVJS();


            console.debug("[RoleEditor]exportRole ret:", ret, filepath);


            return true;
        }




        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key）
        function doAction(type, action) {
            _private.refreshRole();

            role.start(action);

            switch(action) {
            case Qt.Key_Down:
                //role.start(Qt.Key_Down);
                //_private.startSprite(role, Qt.Key_Down);
                //role.moveDirection = Qt.Key_Down; //移动方向
                //role.start();
                //timer.start();  //开始移动
                if(type === 1)
                    keys[action] = true; //保存键盘按下
                //keys.push(action);
                break;
            case Qt.Key_Left:
                //role.start(Qt.Key_Left);
                //_private.startSprite(role, Qt.Key_Left);
                //role.moveDirection = Qt.Key_Left;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[action] = true; //保存键盘按下
                //keys.push(action);
                break;
            case Qt.Key_Right:
                //role.start(Qt.Key_Right);
                //_private.startSprite(role, Qt.Key_Right);
                //role.moveDirection = Qt.Key_Right;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[action] = true; //保存键盘按下
                //keys.push(action);
                break;
            case Qt.Key_Up:
                //role.start(Qt.Key_Up);
                //_private.startSprite(role, Qt.Key_Up);
                //role.moveDirection = Qt.Key_Up;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[action] = true; //保存键盘按下
                //keys.push(action);
                break;
            default:
                break;
            }
        }

        function stopAction(type, action) {

            if(type === 1) {
                switch(action) {
                case Qt.Key_Up:
                case Qt.Key_Right:
                case Qt.Key_Left:
                case Qt.Key_Down:
                    delete keys[action]; //从键盘保存中删除

                    //获取下一个已经按下的键
                    let l = Object.keys(keys);
                    //console.debug(l);
                    //keys.pop();
                    if(l.length === 0) {    //如果没有键被按下
                        //timer.stop();
                        role.stop();
                        //role.stop();
                        console.debug("[RoleEditor]_private.stopAction stop");
                    }
                    else {
                        doAction(-1, parseInt(l[0]));
                        //_private.startSprite(role, l[0]);
                        //role.moveDirection = l[0];    //弹出第一个按键
                        //role.start();
                        console.debug("[RoleEditor]_private.stopAction nextKey");
                    }
                    break;

                default:
                    keys = {};
                    role.stop();
                    //role.stop();
                    console.debug("[RoleEditor]_private.stopAction stop1");
                }
            }
            else {
                role.stop();
                //role.stop();
                console.debug("[RoleEditor]_private.stopAction stop2");
            }
        }

        

        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(exportRole())
                        sg_close();
                    else {
                        dialogSaveRole.open();
                    }
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    dialogCommon.close();
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
    Keys.onEscapePressed: {
        console.debug("[RoleEditor]Escape Key");
        _private.close();
        event.accepted = true;
    }
    Keys.onBackPressed: {
        console.debug("[RoleEditor]Back Key");
        _private.close();
        event.accepted = true;
    }
    Keys.onPressed: {
        event.accepted = true;

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        _private.doAction(1, event.key);



        console.debug("[RoleEditor]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        event.accepted = true;

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        _private.stopAction(1, event.key);


        console.debug("[RoleEditor]Keys.onReleased:", event.key, event.isAutoRepeat);

        //console.debug(role.arrActionsData);
        //console.debug(textRoleFangXiangIndex.text.split(','));
    }


    Component.onCompleted: {
        layoutAction1.arrCacheComponent.push(compActions1.createObject(layoutAction1, {bShowDelete: false, textActionName: '$Up', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction1.arrCacheComponent.push(compActions1.createObject(layoutAction1, {bShowDelete: false, textActionName: '$Right', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction1.arrCacheComponent.push(compActions1.createObject(layoutAction1, {bShowDelete: false, textActionName: '$Down', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction1.arrCacheComponent.push(compActions1.createObject(layoutAction1, {bShowDelete: false, textActionName: '$Left', bActionReadOnly: true, bActionColor: 'red'}));


        layoutAction2.arrCacheComponent.push(compActions2.createObject(layoutAction2, {bShowDelete: false, textActionName: '$Up', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction2.arrCacheComponent.push(compActions2.createObject(layoutAction2, {bShowDelete: false, textActionName: '$Right', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction2.arrCacheComponent.push(compActions2.createObject(layoutAction2, {bShowDelete: false, textActionName: '$Down', bActionReadOnly: true, bActionColor: 'red'}));
        layoutAction2.arrCacheComponent.push(compActions2.createObject(layoutAction2, {bShowDelete: false, textActionName: '$Left', bActionReadOnly: true, bActionColor: 'red'}));


        console.debug("[RoleEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[RoleEditor]Component.onDestruction");
    }
}
