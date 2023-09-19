import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


import _Global 1.0
import _Global.Button 1.0

//import LGlobal 1.0



//战斗角色信息
Item {
    id: root

    property int nFightHeroIndex: 0         //当前角色
    property string strTeamName: '$sys_fight_heros'
    property var arrEquipmentPositions: []   //穿戴位置列表（用于索引用）

    property alias maskFightRoleInfo: maskFightRoleInfo



    function init(params) {
        let n = 0, teamName='$sys_fight_heros';

        if(GlobalLibraryJS.isArray(params)) {   //多参数
            n = params[0] || 0;
            teamName = params[1] || '$sys_fight_heros';
        }
        else    //一个参数
            n = params;


        if(game.gd[teamName].length === 0) {
            return;
        }
        strTeamName = teamName;

        nFightHeroIndex = n;
        refresh();
        msgDetail.text = "双击道具可脱下";

        root.visible = true;
    }

    function hide() {
        //closeWindow(0b10);
        game.window({$id: 0b10, $visible: false});
    }


    function refresh() {
        let fighthero = game.gd[strTeamName][root.nFightHeroIndex];
        let fightHeroPath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator;
        textFightHeroName.text = GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts["show_combatant_name"](fighthero, {avatar: true, color: true}));


        /*textFightHeroInfo.text = "HP：" + fighthero.$$propertiesWithExtra.remainHP + "/" + fighthero.$$propertiesWithExtra.healthHP + "/" + fighthero.$$propertiesWithExtra.HP + ' ' +
            "MP：" + fighthero.$$propertiesWithExtra.remainMP + "/" + fighthero.$$propertiesWithExtra.MP + ' ' +
            "攻击：" + fighthero.$$propertiesWithExtra.attack + ' ' +
            "防御：" + fighthero.$$propertiesWithExtra.defense + ' ' +
            "灵力：" + fighthero.$$propertiesWithExtra.power + ' ' +
            "幸运：" + fighthero.$$propertiesWithExtra.luck + ' ' +
            "速度：" + fighthero.$$propertiesWithExtra.speed + ' ' +
            "经验：" + fighthero.$properties.EXP + ' ' +
            "级别：" + fighthero.$properties.level;
        */

        textFightHeroInfo.text = game.$sys.resources.commonScripts["combatant_info"](fighthero);


        //装备

        let equipReservedSlots = fighthero['$equip_reserved_slots'] || game.$sys.resources.commonScripts["equip_reserved_slots"];
        root.arrEquipmentPositions = [];
        let arrEquipment = [];  //显示的

        arrEquipment.length = equipReservedSlots.length;
        root.arrEquipmentPositions.length = equipReservedSlots.length;

        for(let position in fighthero.$equipment) {
            //跳过为空的
            if(!fighthero.$equipment[position])
                continue;

            let tIndex = equipReservedSlots.indexOf(position);
            let tgoodsName = GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts["show_goods_name"](fighthero.$equipment[position], {image: true, color: true}));
            if(tIndex > -1) {
                //arrEquipment[tIndex] = '%1：%2'.arg(position).arg(game.$sys.resources.goods[fighthero.$equipment[position].$rid].$properties.name);
                arrEquipment[tIndex] = '%1：%2'.arg(position).arg(tgoodsName);
                root.arrEquipmentPositions[tIndex] = position;
            }
            else {
                //arrEquipment.push('%1：%2'.arg(position).arg(game.$sys.resources.goods[fighthero.$equipment[position].$rid].$properties.name) );
                arrEquipment.push('%1：%2'.arg(position).arg(tgoodsName) );
                root.arrEquipmentPositions.push(position);
            }
            //textEquipment.text = textEquipment.text + equipment + "  " + game.$sys.resources.goods[fighthero.$equipment[position].$rid].$properties.name + "\r\n";
        }
        for(let ti = 0; ti < equipReservedSlots.length; ++ti)
            if(arrEquipment[ti] === undefined)
                arrEquipment[ti] = equipReservedSlots[ti] + '：无';

        gamemenuEquipment.show(arrEquipment);


        //技能
        let arrSkill = [];
        for(let skill of fighthero.$skills) {
            arrSkill.push(skill.$name);
        }

        gamemenuSkills.show(arrSkill);
    }

    anchors.fill: parent
    visible: false


    Mask {
        id: maskFightRoleInfo

        anchors.fill: parent
        color: "#7FFFFFFF"

        mouseArea.onPressed: {
            root.hide();
        }
    }

    ColumnLayout {

        width: parent.width * 0.96
        height: parent.height * 0.9
        anchors.centerIn: parent


        RowLayout {
            //Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.preferredHeight: 60


            Rectangle {
                Layout.fillWidth: true
                //Layout.preferredWidth: parent.width
                Layout.preferredHeight: 60
                color: "blue"

                RowLayout {
                    //Layout.alignment: Qt.AlignRight
                    //Layout.fillWidth: true
                    anchors.fill: parent

                    Text {
                        id: textFightHeroName

                        Layout.fillWidth: true
                        //anchors.fill: parent

                        color: "white"

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 16
                        font.bold: true
                        text: ""
                        wrapMode: Text.Wrap
                    }

                    ColorButton {
                        Layout.alignment: Qt.AlignRight

                        text: "上一个"
                        textTips.color: 'white'
                        colors: ['blue', 'darkblue', 'darkgreen']
                        border.color: 'white'
                        border.width: 1

                        onButtonClicked: {
                            if(root.nFightHeroIndex > 0) {
                                --root.nFightHeroIndex;
                                root.refresh();
                            }
                        }
                    }
                    ColorButton {
                        Layout.alignment: Qt.AlignRight

                        text: "下一个"
                        textTips.color: 'white'
                        colors: ['blue', 'darkblue', 'darkgreen']
                        border.color: 'white'
                        border.width: 1

                        onButtonClicked: {
                            if(game.gd[strTeamName].length - 1 > root.nFightHeroIndex) {
                                ++root.nFightHeroIndex;
                                root.refresh();
                            }
                        }
                    }
                    ColorButton {
                        Layout.alignment: Qt.AlignRight

                        text: "关闭"
                        textTips.color: 'white'
                        colors: ['blue', 'darkblue', 'darkgreen']
                        border.color: 'white'
                        border.width: 1

                        onButtonClicked: {
                            root.hide();
                        }
                    }
                }
            }
        }


        //道具说明框（包括位置、颜色、文字等）
        Notepad {
            id: textFightHeroInfo

            Layout.preferredWidth: parent.width
            Layout.maximumHeight: 100
            Layout.preferredHeight: textFightHeroInfo.textArea.implicitHeight


            color: "darkblue"

            //textArea.horizontalAlignment: Text.AlignHCenter
            textArea.verticalAlignment: Text.AlignVCenter

            textArea.readOnly: true

            //horizontalAlignment: Text.AlignHCenter
            //textArea.verticalAlignment: Text.AlignVCenter

            textArea.selectByMouse: false
            textArea.color: 'white'
            textArea.font.pointSize: 16
            textArea.font.bold: true
            textArea.wrapMode: Text.Wrap

        }

        /*Rectangle {
            Layout.preferredWidth: parent.width
            Layout.maximumHeight: 100
            Layout.preferredHeight: textFightHeroInfo.implicitHeight
            color: "darkred"

            Text {
                id: textFightHeroInfo
                anchors.fill: parent

                color: "white"

                //horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 16
                font.bold: true
                text: ""
                wrapMode: Text.Wrap
            }
        }
        */

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GameMenu {
                id: gamemenuEquipment
                Layout.fillWidth: true
                Layout.fillHeight: true

                onS_Choice: {
                    if(root.arrEquipmentPositions[index] === undefined)
                        return;

                    let combatant = game.gd[strTeamName][root.nFightHeroIndex];
                    let position = root.arrEquipmentPositions[index];
                    //msgDetail.text = game.$sys.resources.goods[hero.$equipment[position].$rid].$properties.description;

                    let description = combatant.$equipment[position].$description;
                    if(GlobalLibraryJS.isFunction(description))
                        description = description(combatant.$equipment[position]);
                    msgDetail.text = description;
                }

                onS_DoubleChoice: {
                    if(root.arrEquipmentPositions[index] === undefined)
                        return;

                    //let hero = game.gd[strTeamName][0];
                    game.getgoods(game.unload(root.nFightHeroIndex, root.arrEquipmentPositions[index]));

                    root.refresh();

                    //textGoodsInfo.text = textGoodsInfo.strPreText;
                    //rectGoods.showGoods(rectGoods.nlastShowType);
                }
            }

            GameMenu {
                id: gamemenuSkills
                Layout.fillWidth: true
                Layout.fillHeight: true

                onS_Choice: {
                    let combatant = game.gd[strTeamName][root.nFightHeroIndex];
                    //msgDetail.text = game.$sys.resources.skills[combatant.$skills[index].$rid].$properties.description;

                    let description = combatant.$skills[index].$description;
                    if(GlobalLibraryJS.isFunction(description))
                        description = description(combatant.$skills[index]);
                    msgDetail.text = description;
                }
            }
        }

        Notepad {
            id: msgDetail

            Layout.fillWidth: true
            Layout.maximumHeight: parent.height * 0.3
            Layout.preferredHeight: textArea.implicitHeight
            //Layout.fillHeight: true

            color: 'darkblue'

            //horizontalAlignment: Text.AlignHCenter
            textArea.verticalAlignment: Text.AlignVCenter

            textArea.readOnly: true
            textArea.selectByMouse: false
            textArea.color: 'white'
            textArea.font.pointSize: 16
            textArea.font.bold: true
            textArea.wrapMode: Text.Wrap
        }
    }
}
