import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


//import "File.js" as File



Rectangle {
    id: root



    signal s_close();
    onS_close: {
        role.unload();
    }



    function newRole() {

        textRoleName.text = "";

        role.spriteSrc = "";
        textRoleImageURL.text = "";
        textRoleResourceName.text = "";
        textRoleResourceName.enabled = false;
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
//        textRoleTrueX.text = cfg.RealOffset[0].toString();
//        textRoleTrueY.text = cfg.RealOffset[1].toString();
//        textRoleTrueWidth.text = cfg.RealSize[0].toString();
//        textRoleTrueHeight.text = cfg.RealSize[1].toString();
//        textRoleSpeed.text = cfg.MoveSpeed.toString();

        _private.refreshRole();
    }


    function openRole(cfg) {

        console.debug("[RoleEditor]openRole:", JSON.stringify(cfg))

        //cfg.Version;
        //cfg.RoleType;
        textRoleName.text = cfg.RoleName;

        role.spriteSrc = Global.toQMLPath(GameMakerGlobal.roleResourceURL(cfg.Image));
        //textRoleImageURL.text = cfg.Image;
        textRoleImageURL.text = Global.toQMLPath(GameMakerGlobal.roleResourceURL(cfg.Image));
        //textRoleResourceName.text = textRoleImageURL.text.slice(textRoleImageURL.text.lastIndexOf("/") + 1);
        textRoleResourceName.text = cfg.Image;
        textRoleResourceName.enabled = false;
        textRoleFrameWidth.text = cfg.FrameSize[0].toString();
        textRoleFrameHeight.text = cfg.FrameSize[1].toString();
        textRoleFrameCount.text = cfg.FrameCount.toString();

        //textRoleFangXiangIndex.text = cfg.FrameIndex.toString();
        textRoleUpIndexX.text = cfg.FrameIndex[0][0].toString();
        textRoleUpIndexY.text = cfg.FrameIndex[0][1].toString();
        textRoleRightIndexX.text = cfg.FrameIndex[1][0].toString();
        textRoleRightIndexY.text = cfg.FrameIndex[1][1].toString();
        textRoleDownIndexX.text = cfg.FrameIndex[2][0].toString();
        textRoleDownIndexY.text = cfg.FrameIndex[2][1].toString();
        textRoleLeftIndexX.text = cfg.FrameIndex[3][0].toString();
        textRoleLeftIndexY.text = cfg.FrameIndex[3][1].toString();

        textRoleFrameInterval.text = cfg.FrameInterval.toString();
        //role.width = parseInt(textRoleWidth.text);
        //role.height = parseInt(textRoleHeight.text);
        textRoleWidth.text = cfg.RoleSize[0].toString();
        textRoleHeight.text = cfg.RoleSize[1].toString();
        textRoleTrueX.text = cfg.RealOffset[0].toString();
        textRoleTrueY.text = cfg.RealOffset[1].toString();
        textRoleTrueWidth.text = cfg.RealSize[0].toString();
        textRoleTrueHeight.text = cfg.RealSize[1].toString();
        textRoleSpeed.text = cfg.MoveSpeed.toString();

        _private.refreshRole();
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

                text: "角色图片"
                onButtonClicked: {
                    dialogRoleData.open();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "刷新"
                onButtonClicked: {
                    _private.refreshRole();
                }
            }

            ColorButton {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "保存"
                onButtonClicked: {

                    dialogSaveRole.open();
                }
            }

            ColorButton {
                visible: false
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "Test"
                onButtonClicked: {
                    /*role.sprite.running = true;
                    console.debug("[Role]test", role.sprite, role.sprite.state, role.sprite.currentSprite)
                    console.debug(role.sprite.sprites);
                    for(let s in role.sprite.sprites) {
                        console.debug(role.sprite.sprites[s].frameY);
                        role.sprite.sprites[s].frameY = 20*s;
                        console.debug(role.sprite.sprites[s].frameY);
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
                text: "角色大小"
            }

            TextField {
                id: textRoleWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "50"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "*"
            }

            TextField {
                id: textRoleHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "80"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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
                text: "占位偏移坐标和大小"
            }

            TextField {
                id: textRoleTrueX
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textRoleTrueY
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textRoleTrueWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "50"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "*"
            }

            TextField {
                id: textRoleTrueHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "80"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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
                id: textRoleFrameWidth
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "37"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "*"
            }
            TextField {
                id: textRoleFrameHeight
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "58"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "每个方向帧数"
            }

            TextField {
                id: textRoleFrameCount
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "3"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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
                text: "上"
            }

            TextField {
                id: textRoleUpIndexX
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            TextField {
                id: textRoleUpIndexY
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "右"
            }

            TextField {
                id: textRoleRightIndexX
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            TextField {
                id: textRoleRightIndexY
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "下"
            }

            TextField {
                id: textRoleDownIndexX
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            TextField {
                id: textRoleDownIndexY
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "左"
            }

            TextField {
                id: textRoleLeftIndexX
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
            TextField {
                id: textRoleLeftIndexY
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                font.pointSize: _config.nTextFontSize
                text: "0"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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
                id: textRoleFrameInterval
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "100"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Label {
                font.pointSize: _config.nLabelFontSize
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 10
                text: "移动速度"
            }

            TextField {
                id: textRoleSpeed
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 30
                text: "10"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.fillHeight: true

            Joystick {
                id: joystick

                Layout.alignment: Qt.AlignTop

                //anchors.margins: 1 * Screen.pixelDensity
                transformOrigin: Item.TopLeft
                opacity: 0.9
                //scale: 0.5
                implicitWidth: 20 * Screen.pixelDensity
                implicitHeight: 20 * Screen.pixelDensity

                onPressedChanged: {
                    if(pressed === false) {
                        _private.stopAction(0);
                    }
                    console.debug("[RoleEditor]Joystick onPressedChanged:", pressed)
                }

                onPointInputChanged: {
                    if(pointInput === Qt.point(0,0))
                        return;

                    if(!pressed)
                        return;

                    if(Math.abs(pointInput.x) > Math.abs(pointInput.y)) {
                        if(pointInput.x > 0)
                            _private.doAction(0, Qt.Key_Right);
                        else
                            _private.doAction(0, Qt.Key_Left);
                    }
                    else {
                        if(pointInput.y > 0)
                            _private.doAction(0, Qt.Key_Down);
                        else
                            _private.doAction(0, Qt.Key_Up);
                    }

                    //console.debug("[RoleEditor]onPointInputChanged", pointInput);
                }
            }


            Role {
                id: role

                Layout.alignment: Qt.AlignTop | Qt.AlignRight
                test: true
                //width: 37;
                //height: 58;

                //sizeFrame: Qt.size(37, 58);
                /*nFrameCount: 3;
                arrFrameDirectionIndex: [3,2,1,0];
                interval: 100;
                width: 37;
                height: 58;
                x1: 0;
                y1: 0;
                width1: 37;
                height1: 58;
                offsetMove: 100;*/
            }
        }
    }






    Dialog1.FileDialog {
        id: filedialogOpenRoleImage
        title: "选择角色图片"
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


            console.debug("[RoleEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textRoleImageURL.text = Platform.getRealPathFromURI(fileUrl);
            else
                textRoleImageURL.text = GameManager.sl_qml_UrlDecode(fileUrl);

            textRoleResourceName.text = textRoleImageURL.text.slice(textRoleImageURL.text.lastIndexOf("/") + 1);


            textRoleImageURL.enabled = true;
            textRoleResourceName.enabled = true;


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
                    id: textRoleResourceName
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

                ColorButton {
                    text: "选择图片"
                    onButtonClicked: {
                        //dialogRoleData.nChoiceType = 1;
                        filedialogOpenRoleImage.open();
                        //root.forceActiveFocus();
                    }
                }
                ColorButton {
                    text: "选择素材"
                    onButtonClicked: {
                        //dialogRoleData.nChoiceType = 2;

                        let path = GameMakerGlobal.roleResourceURL();

                        dirlistRoleResource.showList(path, "*", 0x002, 0x00);
                        dirlistRoleResource.visible = true;
                        //dirlistRoleResource.focus = true;
                        dirlistRoleResource.forceActiveFocus();

                        dialogRoleData.visible = false;
                    }
                }
            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelDialogTips
                    Layout.alignment: Qt.AlignHCenter
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //路径 操作

            if(textRoleImageURL.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "路径不能为空";
                Platform.showToast("路径不能为空");
                return;
            }
            if(textRoleResourceName.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "资源名不能为空";
                Platform.showToast("资源名不能为空");
                return;
            }
            if(!GameManager.sl_qml_FileExists(Global.toQtPath(textRoleImageURL.text))) {
                open();
                //visible = true;
                labelDialogTips.text = "路径错误或文件不存在:" + Global.toQtPath(textRoleImageURL.text);
                Platform.showToast("路径错误或文件不存在");
                return;
            }



            //系统图片
            //if(dialogRoleData.nChoiceType === 1) {
            if(checkboxSaveResource.checked) {
                let ret = GameManager.sl_qml_CopyFile(Global.toQtPath(textRoleImageURL.text), GameMakerGlobal.roleResourceURL(textRoleResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelDialogTips.text = "拷贝资源失败，是否重名或目录不可写？";
                    Platform.showToast("拷贝资源失败，是否重名或目录不可写？");
                    //console.debug("[RoleEditor]Copy ERROR:", textRoleImageURL.text);

                    //root.forceActiveFocus();
                    return;
                }

            }
            else {  //资源图库

                //console.debug("ttt2:", filepath);

                //console.debug("ttt", textRoleImageURL.text, Qt.resolvedUrl(textRoleImageURL.text))
            }
            //textRoleImageURL.text = textRoleResourceName.text;
            textRoleImageURL.text = Global.toQMLPath(GameMakerGlobal.roleResourceURL(textRoleResourceName.text));


            role.spriteSrc = textRoleImageURL.text;
            textRoleImageURL.enabled = false;
            textRoleResourceName.enabled = true;


            /*
            textRoleImageURL.text = "";
            textRoleResourceName.text = "";
            textRoleResourceName.enabled = true;
            labelDialogTips.text = "";
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
            /*
            textRoleImageURL.text = "";
            textRoleResourceName.text = "";
            textRoleResourceName.enabled = true;
            labelDialogTips.text = "";
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


    DirList {
        id: dirlistRoleResource
        visible: false


        onClicked: {
            let filepath = GameMakerGlobal.roleResourceURL(item);

            textRoleImageURL.text = Global.toQMLPath(filepath);
            textRoleResourceName.text = item;
            console.debug("DirList:", textRoleImageURL.text)

            textRoleImageURL.enabled = false;
            textRoleResourceName.enabled = false;


            dialogRoleData.visible = true;


            checkboxSaveResource.checked = false;
            checkboxSaveResource.enabled = false;


            root.focus = true;
            visible = false;


            //let cfg = File.read(fileUrl);
            //let cfg = GameManager.sl_qml_ReadFile(fileUrl);
            console.debug("[RoleEditor]filepath", filepath);
        }

        onCanceled: {
            dialogRoleData.visible = true;

            //loader.visible = true;
            root.focus = true;
            //loader.item.focus = true;
            visible = false;
        }

        onRemoveClicked: {
            /*let dirUrl = Platform.getExternalDataPath() + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + "Maps" + Platform.separator() + item;

            dialogCommon.text = "确认删除?";
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[RoleEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();
            */
        }
    }





    //导出角色对话框
    Dialog {
        id: dialogSaveRole
        title: "请输入角色名称"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            //root.focus = true;
            root.forceActiveFocus();


            if(textRoleName.text.length === 0) {
                Platform.showToast("角色名不能为空");
                open();
                return;
            }

            _private.exportRole(textRoleName.text);

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
                width: parent.width
                Text {
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
            width: parent.width
            placeholderText: "输入脚本命令"

            //textFormat: Text.RichText
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


    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        console.debug("[RoleEditor]Escape Key");
        s_close();
        event.accepted = true;
    }
    Keys.onBackPressed: {
        console.debug("[RoleEditor]Back Key");
        s_close();
        event.accepted = true;
    }
    Keys.onPressed: {

        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        _private.doAction(1, event.key);

        event.accepted = true;


        console.debug("[RoleEditor]key:", event, event.key, event.text)
    }

    Keys.onReleased: {
        if(event.isAutoRepeat === true) //如果是按住不放的事件，则返回（只记录第一次按）
            return;

        _private.stopAction(1, event.key);

        console.debug("[RoleEditor]Keys.onReleased", event.isAutoRepeat);

        //console.debug(role.arrFrameDirectionIndex);
        //console.debug(textRoleFangXiangIndex.text.split(','));
    }



    QtObject {
        id: _private

        //property string strRoleName: ""



        function refreshRole() {
            role.sizeFrame = Qt.size(parseInt(textRoleFrameWidth.text), parseInt(textRoleFrameHeight.text));
            role.nFrameCount = parseInt(textRoleFrameCount.text);

            //role.arrFrameDirectionIndex = textRoleFangXiangIndex.text.split(',');
            role.arrFrameDirectionIndex = [[parseInt(textRoleUpIndexX.text), parseInt(textRoleUpIndexY.text)],
                                           [parseInt(textRoleRightIndexX.text), parseInt(textRoleRightIndexY.text)],
                                           [parseInt(textRoleDownIndexX.text), parseInt(textRoleDownIndexY.text)],
                                           [parseInt(textRoleLeftIndexX.text), parseInt(textRoleLeftIndexY.text)]];

            role.interval = parseInt(textRoleFrameInterval.text);
            //role.width = parseInt(textRoleWidth.text);
            //role.height = parseInt(textRoleHeight.text);
            role.implicitWidth = parseInt(textRoleWidth.text);
            role.implicitHeight = parseInt(textRoleHeight.text);
            role.x1 = parseInt(textRoleTrueX.text);
            role.y1 = parseInt(textRoleTrueY.text);
            role.width1 = parseInt(textRoleTrueWidth.text);
            role.height1 = parseInt(textRoleTrueHeight.text);
            role.offsetMove = parseInt(textRoleSpeed.text);


            role.refresh();

            /*role.sizeFrame = Qt.size(37, 58);
            role.nFrameCount = 3;
            role.arrFrameDirectionIndex = [3,2,1,0];
            role.interval = 100;
            role.width = 37;
            role.height = 58;
            role.x1 = 0;
            role.y1 = 0;
            role.width1 = 37;
            role.height1 = 58;
            role.offsetMove = 100;
            */
            //console.debug("测试:", role.width, role.height, parseInt(textRoleWidth.text), parseInt(textRoleHeight.text))
        }


        //导出角色
        function exportRole(roleName) {

            let filepath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strRoleDirName + Platform.separator() + roleName + Platform.separator() + 'role.json';

            /*if(GameManager.sl_qml_DirExists(path))
                ;
            GameManager.sl_qml_CreateFolder(path);
            */



            let outputData = {};
            /*outputData.Version = "0.6";
            outputData.RoleName = roleName;
            outputData.RoleType = 1; //角色类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.RoleSize = [role.implicitWidth, role.implicitHeight];
            outputData.FrameSize = [role.sizeFrame.width, role.sizeFrame.height];
            outputData.FrameCount = role.nFrameCount;
            outputData.FrameIndex = role.arrFrameDirectionIndex.toString();
            outputData.FrameInterval = role.interval;
            outputData.RealOffset = [role.x1, role.y1];
            outputData.RealSize = [role.width1, role.height1];
            outputData.MoveSpeed = role.offsetMove;
            outputData.Image = role.spriteSrc;
            */
            outputData.Version = "0.6";
            outputData.RoleName = roleName;
            outputData.RoleType = 1; //角色类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.RoleSize = [textRoleWidth.text, textRoleHeight.text];
            outputData.FrameSize = [textRoleFrameWidth.text, textRoleFrameHeight.text];
            outputData.FrameCount = textRoleFrameCount.text;

            //outputData.FrameIndex = textRoleFangXiangIndex.text;
            outputData.FrameIndex = [[parseInt(textRoleUpIndexX.text), parseInt(textRoleUpIndexY.text)],
                                           [parseInt(textRoleRightIndexX.text), parseInt(textRoleRightIndexY.text)],
                                           [parseInt(textRoleDownIndexX.text), parseInt(textRoleDownIndexY.text)],
                                           [parseInt(textRoleLeftIndexX.text), parseInt(textRoleLeftIndexY.text)]];

            outputData.FrameInterval = textRoleFrameInterval.text;
            outputData.RealOffset = [textRoleTrueX.text, textRoleTrueY.text];
            outputData.RealSize = [textRoleTrueWidth.text, textRoleTrueHeight.text];
            outputData.MoveSpeed = textRoleSpeed.text;
            outputData.Image = textRoleResourceName.text;



            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(filepath, JSON.stringify(outputData));
            let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), filepath, 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

            console.debug("[RoleEditor]exportRole ret:", ret, filepath)
        }




        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key）
        function doAction(type, key) {
            switch(key) {
            case Qt.Key_Down:
                _private.startSprite(role, Qt.Key_Down);
                //role.direction = Qt.Key_Down; //移动方向
                //role.start();
                //timer.start();  //开始移动
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Left:
                _private.startSprite(role, Qt.Key_Left);
                //role.direction = Qt.Key_Left;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Right:
                _private.startSprite(role, Qt.Key_Right);
                //role.direction = Qt.Key_Right;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Up:
                _private.startSprite(role, Qt.Key_Up);
                //role.direction = Qt.Key_Up;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            default:
                break;
            }
        }

        function stopAction(type, key) {

            if(type === 1) {
                switch(key) {
                case Qt.Key_Up:
                case Qt.Key_Right:
                case Qt.Key_Left:
                case Qt.Key_Down:
                    delete keys[key]; //从键盘保存中删除

                    //获取下一个已经按下的键
                    let l = Object.keys(keys);
                    //console.debug(l);
                    //keys.pop();
                    if(l.length === 0) {    //如果没有键被按下
                        //timer.stop();
                        _private.stopSprite(role);
                        //role.stop();
                        console.debug("[RoleEditor]_private.stopAction stop");
                    }
                    else {
                        _private.startSprite(role, l[0]);
                        //role.direction = l[0];    //弹出第一个按键
                        //role.start();
                        console.debug("[RoleEditor]_private.stopAction nextKey");
                    }
                    break;

                default:
                    keys = {};
                    _private.stopSprite(role);
                    //role.stop();
                    console.debug("[RoleEditor]_private.stopAction stop1");
                }
            }
            else {
                _private.stopSprite(role);
                //role.stop();
                console.debug("[RoleEditor]_private.stopAction stop2");
            }
        }

        function startSprite(role, key) {
            role.direction = key; //移动方向
            role.start();
        }
        function stopSprite(role) {
            role.direction = -1;
            role.stop();
        }

    }

    //配置
    QtObject {
        id: _config

        property int nLabelFontSize: 10
        property int nTextFontSize: 10
    }





    Component.onCompleted: {

    }
}
