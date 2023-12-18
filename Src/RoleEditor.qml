import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import RPGComponents 1.0


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



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

        role.spriteSrc = GlobalJS.toURL(GameMakerGlobal.roleResourceURL(cfg.Image));
        //textRoleImageURL.text = cfg.Image;
        textRoleImageURL.text = GlobalJS.toURL(GameMakerGlobal.roleResourceURL(cfg.Image));
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
        textRoleFrameXScale.text = ((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0].toString() : '1');
        textRoleFrameYScale.text = ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1].toString() : '1');
        textRoleSpeed.text = cfg.MoveSpeed !== undefined ? cfg.MoveSpeed.toString() : '0.1';
        textRoleShadowOpacity.text = cfg.ShadowOpacity !== undefined ? cfg.ShadowOpacity.toString() : '0.3';
        textPenetrate.text = cfg.Penetrate !== undefined ? cfg.Penetrate.toString() : '0';
        textShowName.text = cfg.ShowName !== undefined ? cfg.ShowName.toString() : '1';
        textAvatar.text = cfg.Avatar !== undefined ? cfg.Avatar.toString() : '';
        textAvatarWidth.text = (cfg.AvatarSize && cfg.AvatarSize[0] !== undefined ? cfg.AvatarSize[0].toString() : '60');
        textAvatarHeight.text = (cfg.AvatarSize && cfg.AvatarSize[1] !== undefined ? cfg.AvatarSize[1].toString() : '60');

        _private.refreshRole();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true

    color: Global.style.backgroundColor



    MouseArea {
        anchors.fill: parent
    }



    //主界面
    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

                text: "图片资源"
                font.pointSize: _config.nButtonFontSize

                onClicked: {
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

                    dialogSaveRole.open();
                }
            }

            Button {
                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                Layout.preferredHeight: 50

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
  帧切换速度：你懂的，一般我填100；
  帧宽高：将图片切割为每一帧的大小（填错会导致显示效果出问题）；
  每个方向帧数：每个方向的行走图有多少帧；
  上右下左：将一张图切割为 m列*n行 个帧，则角色的上、右、下、左的 第一个帧 分别是 哪列哪行（可以理解为x、y坐标，0开始）；
  移动速度：角色在地图上的移动速度。这个值单位是 像素/毫秒（为了适应各种刷新率下速度一致），具体要根据图块大小来设置（一般设置为0.1-0.2即可）；
  可穿透：角色是否可以穿过（0或1）；
  显示名字：角色头顶是否显示名字（0或1）；
  头像和大小：使用对话命令的时候，会带有这个头像；

')
                }
            }

            Button {
                visible: Platform.compileType() === "debug" ? true : false
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
                    dialogScript.open();
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

                text: "角色大小"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleWidth

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "50"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "80"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }

            TextField {
                id: textRoleFrameYScale

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                text: "影子偏移坐标和大小"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleTrueX

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }

            TextField {
                id: textRoleTrueY

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }

            TextField {
                id: textRoleTrueWidth

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "50"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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
                id: textRoleTrueHeight

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                font.pointSize: _config.nTextFontSize
                text: "80"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                text: "影子透明度"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleShadowOpacity

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0.5"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }


            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 10

                text: "帧切换速度（ms）"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleFrameInterval

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "100"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                text: "帧宽高"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleFrameWidth

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "37"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "58"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 10

                text: "每个方向帧数"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleFrameCount

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "3"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }
            TextField {
                id: textRoleUpIndexY

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }
            TextField {
                id: textRoleRightIndexY

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }
            TextField {
                id: textRoleDownIndexY

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
                    _private.refreshRole();
                }
            }
            TextField {
                id: textRoleLeftIndexY

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                text: "移动速度"
                font.pointSize: _config.nLabelFontSize
            }

            TextField {
                id: textRoleSpeed

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0.1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "0"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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

                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: "1"
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onEditingFinished: {
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
                Layout.preferredWidth: 90

                text: ''
                placeholderText: '@头像图片'
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                onPressAndHold: {
                    let path = GameMakerGlobal.imageResourceURL();

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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: '60'
                placeholderText: '头像宽'
                font.pointSize: _config.nTextFontSize

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
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

                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: _private.nColumnHeight

                text: '60'
                placeholderText: '头像高'
                font.pointSize: _config.nTextFontSize

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
                    else
                        forceActiveFocus();
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


            Rectangle {
                id: rectRole
                Layout.alignment: Qt.AlignTop | Qt.AlignRight

                //Layout.preferredWidth: parseInt(textSpriteWidth.text)
                //Layout.preferredHeight: parseInt(textSpriteHeight.text)

                color: 'transparent'
                border {
                    width: 1
                    color: 'lightgray'
                }

                Role {
                    id: role

                    anchors.fill: parent

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
                    moveSpeed: 100;*/

                    onS_clicked: {
                        root.forceActiveFocus();
                    }
                }
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
                textRoleImageURL.text = FrameManager.sl_qml_UrlDecode(fileUrl);

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

                Button {
                    text: "选择图片"
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

                        let path = GameMakerGlobal.roleResourceURL();

                        l_listRoleResource.show(path, "*", 0x002, 0x00);
                        l_listRoleResource.visible = true;
                        //l_listRoleResource.focus = true;
                        l_listRoleResource.forceActiveFocus();

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
            if(!FrameManager.sl_qml_FileExists(Global.toPath(textRoleImageURL.text))) {
                open();
                //visible = true;
                labelDialogTips.text = "路径错误或文件不存在:" + Global.toPath(textRoleImageURL.text);
                Platform.showToast("路径错误或文件不存在");
                return;
            }



            //系统图片
            //if(dialogRoleData.nChoiceType === 1) {
            if(checkboxSaveResource.checked) {
                let ret = FrameManager.sl_qml_CopyFile(Global.toPath(textRoleImageURL.text), GameMakerGlobal.roleResourceURL(textRoleResourceName.text), false);
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
            textRoleImageURL.text = GlobalJS.toURL(GameMakerGlobal.roleResourceURL(textRoleResourceName.text));


            role.spriteSrc = textRoleImageURL.text;
            textRoleImageURL.enabled = false;
            textRoleResourceName.enabled = true;


            /*
            textRoleImageURL.text = "";
            textRoleResourceName.text = "";
            textRoleResourceName.enabled = true;
            labelDialogTips.text = "";
            */
            _private.refreshRole();


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


    L_List {
        id: l_listRoleResource

        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onClicked: {
            let filepath = GameMakerGlobal.roleResourceURL(item);

            textRoleImageURL.text = GlobalJS.toURL(filepath);
            textRoleResourceName.text = item;
            console.debug("[RoleEditor]List Clicked:", textRoleImageURL.text)

            textRoleImageURL.enabled = false;
            textRoleResourceName.enabled = false;


            dialogRoleData.visible = true;


            checkboxSaveResource.checked = false;
            checkboxSaveResource.enabled = false;


            //root.focus = true;
            root.forceActiveFocus();
            visible = false;


            //let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_qml_ReadFile(fileUrl);
            console.debug("[RoleEditor]filepath", filepath);
        }

        onCanceled: {
            dialogRoleData.visible = true;

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
                console.debug("[RoleEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_qml_DirExists(dirUrl), FrameManager.sl_qml_RemoveRecursively(dirUrl));
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


            _private.exportRole();

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
                width: parent.width
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



    QtObject {
        id: _private


        property int nColumnHeight: 50

        //property string strRoleName: ""


        function showImage() {
            image.source = textRoleImageURL.text;
            rectImage.visible = true;
        }


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
            role.rXScale = parseFloat(textRoleFrameXScale.text);
            role.rYScale = parseFloat(textRoleFrameYScale.text);

            role.rectShadow.opacity = parseFloat(textRoleShadowOpacity.text);

            //role.moveSpeed = parseFloat(textRoleSpeed.text);


            rectRole.Layout.preferredWidth = rectRole.width = parseInt(textRoleWidth.text);
            rectRole.Layout.preferredHeight = rectRole.height = parseInt(textRoleHeight.text);


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
            role.moveSpeed = 100;
            */
            //console.debug("测试:", role.width, role.height, parseInt(textRoleWidth.text), parseInt(textRoleHeight.text))
        }


        //导出角色
        function exportRole() {

            let roleName = textRoleName.text.trim();

            if(roleName.length === 0) {
                Platform.showToast("角色名不能为空");
                dialogSaveRole.open();
                return false;
            }

            let filepath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + roleName + GameMakerGlobal.separator + 'role.json';

            /*if(FrameManager.sl_qml_DirExists(path))
                ;
            FrameManager.sl_qml_CreateFolder(path);
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
            outputData.MoveSpeed = role.moveSpeed;
            outputData.Image = role.spriteSrc;
            */
            outputData.Version = "0.6";
            outputData.RoleName = roleName;
            outputData.RoleType = 1; //角色类型
            //outputData.MapScale = isNaN(parseFloat(textMapScale.text)) ? 1 : parseFloat(textMapScale.text);
            outputData.RoleSize = [parseInt(textRoleWidth.text), parseInt(textRoleHeight.text)];
            outputData.FrameSize = [parseInt(textRoleFrameWidth.text), parseInt(textRoleFrameHeight.text)];
            outputData.FrameCount = parseInt(textRoleFrameCount.text);

            //outputData.FrameIndex = textRoleFangXiangIndex.text;
            outputData.FrameIndex = [[parseInt(textRoleUpIndexX.text), parseInt(textRoleUpIndexY.text)],
                                           [parseInt(textRoleRightIndexX.text), parseInt(textRoleRightIndexY.text)],
                                           [parseInt(textRoleDownIndexX.text), parseInt(textRoleDownIndexY.text)],
                                           [parseInt(textRoleLeftIndexX.text), parseInt(textRoleLeftIndexY.text)]];

            outputData.FrameInterval = parseInt(textRoleFrameInterval.text);
            outputData.RealOffset = [parseInt(textRoleTrueX.text), parseInt(textRoleTrueY.text)];
            outputData.RealSize = [parseInt(textRoleTrueWidth.text), parseInt(textRoleTrueHeight.text)];
            outputData.Scale = [parseFloat(textRoleFrameXScale.text), parseFloat(textRoleFrameYScale.text)];
            outputData.MoveSpeed = parseFloat(textRoleSpeed.text);
            outputData.ShadowOpacity = parseFloat(textRoleShadowOpacity.text);
            outputData.Penetrate = parseInt(textPenetrate.text);
            outputData.ShowName = parseInt(textShowName.text);

            outputData.Image = textRoleResourceName.text;
            outputData.Avatar = textAvatar.text;
            outputData.AvatarSize = [parseInt(textAvatarWidth.text), parseInt(textAvatarHeight.text)];



            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(filepath, JSON.stringify(outputData));
            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify(outputData), filepath, 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

            console.debug("[RoleEditor]exportRole ret:", ret, filepath);


            return true;
        }




        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key）
        function doAction(type, key) {
            switch(key) {
            case Qt.Key_Down:
                _private.startSprite(role, Qt.Key_Down);
                //role.moveDirection = Qt.Key_Down; //移动方向
                //role.start();
                //timer.start();  //开始移动
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Left:
                _private.startSprite(role, Qt.Key_Left);
                //role.moveDirection = Qt.Key_Left;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Right:
                _private.startSprite(role, Qt.Key_Right);
                //role.moveDirection = Qt.Key_Right;
                //role.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Up:
                _private.startSprite(role, Qt.Key_Up);
                //role.moveDirection = Qt.Key_Up;
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
                        //role.moveDirection = l[0];    //弹出第一个按键
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
            role.moveDirection = key; //移动方向
            role.start();
        }
        function stopSprite(role) {
            role.moveDirection = -1;
            role.stop();
        }



        function close() {
            dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function(){
                    if(exportRole())
                        s_close();
                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    s_close();
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



    Component.onCompleted: {

    }
}
