/****************************************************************************
**
** Copyright (C) 2013-2015 Oleg Yadrov
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
**
****************************************************************************/

import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


import _Global 1.0
import _Global.Button 1.0



Item {
    id: root

//    property alias gameMenu: gameMenu
//    property alias rectGoods: rectGoods
//    property alias flickableGoods: flickableGoods
//    property alias gameGoodsMenu: gameGoodsMenu

    signal s_close();

    property int nShowMenu: -1


    function show() {
        init();
        visible = true;
    }

    function init() {
        rectStatus.visible = false;
        rectGoods.visible = false;
        rectSkills.visible = false;
        rectEquipment.visible = false;
        itemUseOrEquip.visible = false;
        rectEquipInfo.visible = false;

        nShowMenu = -1;
    }


    Rectangle {
        //color: "green"
        anchors.fill: parent
        color: "#20000000"


        MouseArea {
            anchors.fill: parent
            onClicked: {
                switch(nShowMenu) {
                case -1:
                    _private.close();
                    break;

                default:
                    rectStatus.visible = false;
                    rectGoods.visible = false;
                    rectSkills.visible = false;
                    rectEquipment.visible = false;
                    itemUseOrEquip.visible = false;
                    rectEquipInfo.visible = false;

                    nShowMenu = -1;
                }
            }
        }



        Rectangle {
            anchors.centerIn: parent
            width: parent.width / 3
            height: parent.height / 2

            color: "#CF6699FF"
            border.color: "white"
            radius: height / 20
            clip: true

            //菜单
            GameMenu {
                id: gameMenu

                anchors.fill: parent

                onS_Choice: function(index) {
                    nShowMenu = index;

                    switch(index) {
                    case 0:
                        _private.showStatus();
                        break;
                    case 1:
                        _private.showEquipment();
                        break;
                    case 2:
                        _private.showSkills();
                        break;
                    case 3:
                        _private.showGoods();
                        break;
                    case 4:
                        break;
                    default:
                        _private.close();
                    }
                }
            }
        }



        //状态框
        Rectangle {
            id: rectStatus
            anchors.centerIn: parent
            width: parent.width / 3
            height: parent.height / 2
            color: "lightgray"
            visible: false

            Column {
                anchors.fill: parent

                Text {
                    id: textHP
                    text: qsTr("")
                }
                Text {
                    id: textMP
                    text: qsTr("")
                }
                Text {
                    id: textAttack
                    text: qsTr("")
                }
                Text {
                    id: textDefense
                    text: qsTr("")
                }
                Text {
                    id: textPower
                    text: qsTr("")
                }
                Text {
                    id: textLuck
                    text: qsTr("")
                }
                Text {
                    id: textSpeed
                    text: qsTr("")
                }
                Text {
                    id: textEXP
                    text: qsTr("")
                }
                Text {
                    id: textLevel
                    text: qsTr("")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    rectStatus.visible = false
            }
        }


        //装备框
        Rectangle {
            id: rectEquipment
            anchors.centerIn: parent
            width: parent.width / 3
            height: parent.height / 2
            color: "lightgray"
            visible: false

            Flickable {
                id: flickableEquipment
                anchors.fill: parent

                contentWidth: width
                contentHeight: gameEquipmentMenu.implicitHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                GameMenu {
                    id: gameEquipmentMenu
                    width: flickableEquipment.width
                    //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
                    height: flickableEquipment.height < implicitHeight ? flickableEquipment.height : implicitHeight
                    //nItemMaxHeight: 100
                    nItemMinHeight: 50

                    onS_Choice: function(index) {
                        switch(index) {
                        case 0:
                            break;
                        case 1:
                            break;
                        case 2:
                            break;
                        case 3:
                            break;
                        default:
                            //root.visible = false;
                        }

                        rectEquipInfo.choicePosition = index;

                        let hero = game.gd["$sys_fight_heros"][0];
                        let position = rectEquipInfo.positions[rectEquipInfo.choicePosition];
                        textEquipInfo.text = game.objGoods[hero["equipment"][position].id].description;

                        rectEquipInfo.visible = true;
                    }
                }
            }
        }


        //道具框
        Rectangle {
            id: rectGoods
            anchors.centerIn: parent

            width: parent.width / 3
            height: parent.height / 2

            color: "lightgray"

            visible: false

            Flickable {
                id: flickableGoods
                anchors.fill: parent

                contentWidth: width
                contentHeight: gameGoodsMenu.implicitHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                GameMenu {
                    id: gameGoodsMenu
                    width: flickableGoods.width
                    //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
                    height: flickableGoods.height < implicitHeight ? flickableGoods.height : implicitHeight
                    //nItemMaxHeight: 100
                    nItemMinHeight: 50

                    onS_Choice: function(index) {
                        switch(index) {
                        case 0:
                            break;
                        case 1:
                            break;
                        case 2:
                            break;
                        case 3:
                            break;
                        default:
                            //root.visible = false;
                        }


                        itemUseOrEquip.choiceIndex = index;
                        let goodsInfo = game.objGoods[game.gd["$sys_goods"][itemUseOrEquip.choiceIndex].id];
                        goodsInfo['useScript'] ? buttonUse.visible = true : buttonUse.visible = false;
                        goodsInfo['equipScript'] ? buttonEquip.visible = true : buttonEquip.visible = false;
                        textGoodsInfo.text = goodsInfo.description;
                        itemUseOrEquip.visible = true;
                    }
                }

            }

        }


        //技能框
        Rectangle {
            id: rectSkills
            anchors.centerIn: parent

            width: parent.width / 3
            height: parent.height / 2

            color: "lightgray"

            visible: false

            Flickable {
                id: flickableSkills
                anchors.fill: parent

                contentWidth: width
                contentHeight: gameSkillsMenu.implicitHeight
                flickableDirection: Flickable.VerticalFlick
                clip: true

                GameMenu {
                    id: gameSkillsMenu
                    width: flickableSkills.width
                    //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
                    height: flickableSkills.height < implicitHeight ? flickableSkills.height : implicitHeight
                    //nItemMaxHeight: 100
                    nItemMinHeight: 50

                    onS_Choice: function(index) {
                        switch(index) {
                        case 0:
                            break;
                        case 1:
                            break;
                        case 2:
                            break;
                        case 3:
                            break;
                        default:
                            //root.visible = false;
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rectSkills.visible = false
                    }
                }

            }

        }

    }



    //选择道具
    Rectangle {
        id: itemUseOrEquip
        anchors.centerIn: parent
        width: parent.width / 3
        height: parent.height / 2
        color: "lightgray"
        visible: false

        property int choiceIndex: -1

        Column {
            anchors.fill: parent

            TextEdit {
                id: textGoodsInfo
                width: parent.width
            }

            ColorButton {
                id: buttonUse

                width: parent.width

                text: "使用"
                onButtonClicked: {
                    _private.close();


                    let goods = game.gd["$sys_goods"][itemUseOrEquip.choiceIndex];
                    game.usegoods(goods.id);
                }
            }
            ColorButton {
                id: buttonEquip

                width: parent.width

                text: "装备"
                onButtonClicked: {
                    _private.close();


                    let goods = game.gd["$sys_goods"][itemUseOrEquip.choiceIndex];
                    let goodsInfo = game.objGoods[goods.id];

                    if(goodsInfo['equipScript'])
                        game.run(goodsInfo['equipScript'](goods));
                        //game.run(goodsInfo['equipScript'](goods.id));
                }
            }
        }

    }




    //选择装备
    Rectangle {
        id: rectEquipInfo
        anchors.centerIn: parent
        width: parent.width / 3
        height: parent.height / 2
        color: "lightgray"
        visible: false

        property int choicePosition
        property var positions: []

        Column {
            anchors.fill: parent

            TextEdit {
                id: textEquipInfo

                width: parent.width
            }

            ColorButton {
                id: buttonUnload

                width: parent.width

                text: "脱下"
                onButtonClicked: {
                    _private.close();


                    //let hero = game.gd["$sys_fight_heros"][0];
                    game.getgoods(game.unload(0, rectEquipInfo.positions[rectEquipInfo.choicePosition]));
                }
            }
        }

    }






    QtObject {  //私有数据,函数,对象等
        id: _private

        function close() {

            root.s_close();
            root.visible = false;
        }

        function showGoods() {
            let arrGoodsName = [];
            for(let goods of game.gd["$sys_goods"]) {
                arrGoodsName.push("%1 x%2".arg(game.objGoods[goods.id].name).arg(goods.count));
            }

            //for(let i = 0; i < 2; ++i)
            //    arrGoodsName.push(i + 'hi');

            rectGoods.visible = true;
            gameGoodsMenu.show(arrGoodsName);
        }

        function showSkills(heroIndex=0) {
            if(game.gd["$sys_fight_heros"].length <= heroIndex) {
                return;
            }

            let hero = game.gd["$sys_fight_heros"][heroIndex];
            let arrName = [];
            for(let skill of hero["skills"]) {
                arrName.push(game.objSkills[skill.id].name);
            }

            //for(let i = 0; i < 2; ++i)
            //    arrName.push(i + 'hi');

            rectSkills.visible = true;
            gameSkillsMenu.show(arrName);
        }

        function showEquipment(heroIndex=0) {

            if(game.gd["$sys_fight_heros"].length <= heroIndex) {
                rectEquipment.visible = true;
                return;
            }

            rectEquipInfo.positions = [];
            let arrEquipment = [];
            let hero = game.gd["$sys_fight_heros"][heroIndex];
            for(let position in hero["equipment"]) {
                rectEquipInfo.positions.push(position);
                arrEquipment.push('%1：%2'.arg(position).arg(game.objGoods[hero["equipment"][position].id].name) );
                //textEquipment.text = textEquipment.text + equipment + "  " + game.objGoods[hero["equipment"][position].id].name + "\r\n";
            }

            //for(let i = 0; i < 2; ++i)
            //    arrName.push(i + 'hi');

            gameEquipmentMenu.show(arrEquipment);

            rectEquipment.visible = true;
        }

        function showStatus(heroIndex=0) {

            if(game.gd["$sys_fight_heros"].length <= heroIndex) {
                textHP.text = "没有这个战斗角色";
                rectStatus.visible = true;
                return;
            }

            let hero = game.gd["$sys_fight_heros"][heroIndex];

            textHP.text = "HP：" + hero.$$propertiesWithEquipment.remainHP + "/" + hero.$$propertiesWithEquipment.healthHP + "/" + hero.$$propertiesWithEquipment.HP;
            textMP.text = "MP："+ hero.$$propertiesWithEquipment.remainMP + "/" + hero.$$propertiesWithEquipment.MP;
            textAttack.text = "攻击：" + hero.$$propertiesWithEquipment.attack;
            textDefense.text = "防御：" + hero.$$propertiesWithEquipment.defense;
            textPower.text = "灵力：" + hero.$$propertiesWithEquipment.power;
            textLuck.text = "幸运：" + hero.$$propertiesWithEquipment.luck;
            textSpeed.text = "速度：" + hero.$$propertiesWithEquipment.speed;
            textEXP.text = "经验：" + hero.$$propertiesWithEquipment.EXP;
            textLevel.text = "级别：" + hero.$$propertiesWithEquipment.level;

            rectStatus.visible = true;
        }
    }

    Component.onCompleted: {
        gameMenu.show(["状态", "装备", "技能", "物品", "系统", "关闭菜单"]);
    }
}
