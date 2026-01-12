import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


//引入Qt定义的类
//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import GameComponents 1.0
import 'GameComponents'


//import 'qrc:/QML'


//import 'GameMakerGlobal.js' as GameMakerGlobalJS

//import 'File.js' as File



//战斗角色信息
Item {
    id: root


    signal sg_refreshBagWindow();



    function init(params) {
        let n = 0, teamName='$sys_fight_heros';

        if($CommonLibJS.isArray(params)) {   //多参数
            n = params[0] || 0;
            teamName = params[1] || '$sys_fight_heros';
        }
        else    //一个参数
            n = params;


        if(game.gd[teamName].length === 0) {
            return;
        }
        strTeamName = teamName;

        nFightRoleIndex = n;
        refresh();
        msgDetail.text = '双击道具可脱下';

        //root.visible = true;
    }

    function hide() {
        //closeWindow(0b10);
        game.window({$id: 0b10, $visible: false});
    }


    function refresh() {
        let conbatant = game.gd[strTeamName][root.nFightRoleIndex];
        //let fightRolePath = $GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName) + GameMakerGlobal.separator;
        textFightRoleName.text = $CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showCombatantName(conbatant, {avatar: true, color: true}));


        /*textFightRoleInfo.text = 'HP：' + conbatant.$$propertiesWithExtra.remainHP + '/' + conbatant.$$propertiesWithExtra.healthHP + '/' + conbatant.$$propertiesWithExtra.HP + ' ' +
            'MP：' + conbatant.$$propertiesWithExtra.remainMP + '/' + conbatant.$$propertiesWithExtra.MP + ' ' +
            '攻击：' + conbatant.$$propertiesWithExtra.attack + ' ' +
            '防御：' + conbatant.$$propertiesWithExtra.defense + ' ' +
            '灵力：' + conbatant.$$propertiesWithExtra.power + ' ' +
            '幸运：' + conbatant.$$propertiesWithExtra.luck + ' ' +
            '速度：' + conbatant.$$propertiesWithExtra.speed + ' ' +
            '经验：' + conbatant.$properties.EXP + ' ' +
            '级别：' + conbatant.$properties.level;
        */

        textFightRoleInfo.text = game.$sys.resources.commonScripts.$combatantInfo(conbatant);


        //装备

        let equipReservedSlots = conbatant['$equipReservedSlots'] ?? game.$sys.getCommonScriptResource('$config', '$names', '$equipReservedSlots') ?? [];
        root.arrEquipmentPositions = [];
        let arrEquipment = [];  //显示的

        arrEquipment.length = equipReservedSlots.length;
        root.arrEquipmentPositions.length = equipReservedSlots.length;

        for(let position in conbatant.$equipment) {
            //跳过为空的
            if(!conbatant.$equipment[position])
                continue;

            let tIndex = equipReservedSlots.indexOf(position);
            let tgoodsName = $CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(conbatant.$equipment[position], {Image: true, Color: true}));
            if(tIndex > -1) {
                //arrEquipment[tIndex] = '%1：%2'.arg(position).arg(game.$sys.getGoodsResource(conbatant.$equipment[position].$rid).$properties.name);
                arrEquipment[tIndex] = '<td style="vertical-align:middle;">%1：</td><td>%2</td>'.arg(position).arg(tgoodsName);
                root.arrEquipmentPositions[tIndex] = position;
            }
            else {
                //arrEquipment.push('%1：%2'.arg(position).arg(game.$sys.getGoodsResource(conbatant.$equipment[position].$rid).$properties.name) );
                arrEquipment.push('<td style="vertical-align:middle;">%1：</td><td>%2</td>'.arg(position).arg(tgoodsName) );
                root.arrEquipmentPositions.push(position);
            }
            //textEquipment.text = textEquipment.text + equipment + '  ' + game.$sys.getGoodsResource(conbatant.$equipment[position].$rid).$properties.name + '\r\n';
        }
        for(let ti = 0; ti < equipReservedSlots.length; ++ti)
            if(arrEquipment[ti] === undefined)
                arrEquipment[ti] = equipReservedSlots[ti] + '：无';

        gamemenuEquipment.show(arrEquipment);


        //技能
        let arrSkill = [];
        for(let skill of conbatant.$skills) {
            arrSkill.push(skill.$name);
        }

        gamemenuSkills.show(arrSkill);
    }



    property int nFightRoleIndex: 0         //当前角色
    property string strTeamName: '$sys_fight_heros'
    property var arrEquipmentPositions: []   //穿戴位置列表（用于索引用）

    property alias maskFightRoleInfo: maskFightRoleInfo


    anchors.fill: parent
    visible: false



    Mask {
        id: maskFightRoleInfo

        anchors.fill: parent
        //opacity: 0
        //color: Global.style.backgroundColor
        color: '#7FFFFFFF'
        //radius: 9

        mouseArea.onPressed: {
            root.hide();
        }
    }


    ColumnLayout {

        width: parent.width * 0.96
        height: parent.height * 0.9
        anchors.centerIn: parent

        spacing: 2


        Rectangle {
            Layout.fillWidth: true
            //Layout.preferredWidth: parent.width
            Layout.preferredHeight: 60
            color: 'blue'

            RowLayout {
                //Layout.alignment: Qt.AlignRight
                //Layout.fillWidth: true
                anchors.fill: parent

                Text {
                    id: textFightRoleName

                    Layout.fillWidth: true
                    //anchors.fill: parent

                    color: 'white'

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 16
                    font.bold: true
                    text: ''
                    wrapMode: Text.Wrap
                }

                ColorButton {
                    Layout.alignment: Qt.AlignRight

                    text: '←' //⬅
                    textTips.color: 'white'
                    font.pointSize: 12
                    font.bold: true
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1

                    onSg_clicked: {
                        if(root.nFightRoleIndex > 0) {
                            --root.nFightRoleIndex;
                            root.refresh();
                        }
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignRight

                    text: '→' //➡
                    textTips.color: 'white'
                    font.pointSize: 12
                    font.bold: true
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1

                    onSg_clicked: {
                        if(game.gd[strTeamName].length - 1 > root.nFightRoleIndex) {
                            ++root.nFightRoleIndex;
                            root.refresh();
                        }
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignRight

                    text: '×'
                    textTips.color: 'white'
                    font.pointSize: 12
                    font.bold: true
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1

                    onSg_clicked: {
                        root.hide();
                    }
                }
            }
        }


        //战斗人物说明框（包括位置、颜色、文字等）
        Notepad {
            id: textFightRoleInfo

            Layout.preferredWidth: parent.width
            //Layout.maximumHeight: 100
            Layout.preferredHeight: textFightRoleInfo.textArea.implicitHeight


            color: 'darkblue'

            //textArea.horizontalAlignment: Text.AlignHCenter
            textArea.verticalAlignment: Text.AlignVCenter

            //textArea.enabled: false
            textArea.readOnly: true

            //horizontalAlignment: Text.AlignHCenter
            //textArea.verticalAlignment: Text.AlignVCenter

            textArea.selectByMouse: false
            textArea.color: 'white'
            //textArea.color: Global.style.foreground
            textArea.font.pointSize: 12
            textArea.font.bold: true
            textArea.wrapMode: Text.Wrap

            textArea.background: Rectangle {
                color: 'transparent'
                //color: Global.style.backgroundColor
                //border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                //border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }

        /*Rectangle {
            Layout.preferredWidth: parent.width
            Layout.maximumHeight: 100
            Layout.preferredHeight: textFightRoleInfo.implicitHeight
            color: 'darkred'

            Text {
                id: textFightRoleInfo
                anchors.fill: parent

                color: 'white'

                //horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 16
                font.bold: true
                text: ''
                wrapMode: Text.Wrap
            }
        }
        */

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 2

            GameMenu {
                id: gamemenuEquipment

                Layout.fillWidth: true
                Layout.fillHeight: true

                //nItemMaxHeight: 100
                nItemMinHeight: 50
                nItemHeight: -1 //implicitHeight

                rItemFontSize: 12


                onSg_choice: {
                    if(root.arrEquipmentPositions[index] === undefined)
                        return;

                    let combatant = game.gd[strTeamName][root.nFightRoleIndex];
                    let position = root.arrEquipmentPositions[index];
                    //msgDetail.text = game.$sys.getGoodsResource(hero.$equipment[position].$rid).$properties.description;

                    let description = combatant.$equipment[position].$description;
                    if($CommonLibJS.isFunction(description))
                        description = description(combatant.$equipment[position]);
                    msgDetail.text = description;
                }

                onSg_doubleChoice: {
                    if(root.arrEquipmentPositions[index] === undefined)
                        return;

                    game.run(function*(){
                        //let hero = game.gd[strTeamName][0];
                        game.getgoods(yield game.unload(root.nFightRoleIndex, root.arrEquipmentPositions[index]));

                        root.refresh();
                        sg_refreshBagWindow();

                        //textGoodsInfo.text = textGoodsInfo.strPreText;
                        //rectGoods.showGoods(rectGoods.nlastShowType);
                    });
                }
            }

            GameMenu {
                id: gamemenuSkills

                Layout.fillWidth: true
                Layout.fillHeight: true

                //nItemMaxHeight: 100
                nItemMinHeight: 50
                nItemHeight: -1 //implicitHeight

                rItemFontSize: 12


                onSg_choice: {
                    let combatant = game.gd[strTeamName][root.nFightRoleIndex];
                    //msgDetail.text = game.$sys.getSkillResource(combatant.$skills[index].$rid).$properties.description;

                    let description = combatant.$skills[index].$description;
                    if($CommonLibJS.isFunction(description))
                        description = description(combatant.$skills[index]);
                    msgDetail.text = description;
                }
            }
        }

        //道具/技能说明框（包括位置、颜色、文字等）
        Notepad {
            id: msgDetail

            Layout.fillWidth: true
            Layout.maximumHeight: parent.height * 0.3
            Layout.preferredHeight: textArea.implicitHeight
            //Layout.fillHeight: true

            color: 'darkblue'

            //horizontalAlignment: Text.AlignHCenter
            textArea.verticalAlignment: Text.AlignVCenter

            //textArea.enabled: false
            textArea.readOnly: true
            textArea.selectByMouse: false
            textArea.color: 'white'
            //textArea.color: Global.style.foreground
            textArea.font.pointSize: 12
            textArea.font.bold: true
            textArea.wrapMode: Text.Wrap

            textArea.background: Rectangle {
                color: 'transparent'
                //color: Global.style.backgroundColor
                //border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                //border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }
    }
}
