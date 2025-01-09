
import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0
import 'RPGComponents'



Item {
    id: root

//    property alias gameMenu: gameMenu
//    property alias rectGoods: rectGoods
//    property alias flickableGoods: flickableGoods
//    property alias gameGoodsMenu: gameGoodsMenu

    //
    signal sg_close();

    //显示或关闭
    signal sg_show(int newFlags, int windowFlags);
    signal sg_hide(int newFlags, int windowFlags);


    function showWindow(flags=1, value=0, style={}) {
        //closeWindow();
        let newFlags = 0;

        if((flags & 0b1) && !(nShowWindowFlags & 0b1)) {
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$main') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$main;

            maskMainMenu.color = style.MaskColor ||
                    styleUser.$maskColor ||
                    styleSystem.$maskColor;
            gameMenu.border.color = style.BorderColor ||
                    styleUser.$borderColor ||
                    styleSystem.$borderColor;
            gameMenu.color = style.BackgroundColor ||
                    styleUser.$backgroundColor ||
                    styleSystem.$backgroundColor;
            gameMenu.nItemFontSize = style.ItemFontSize || style.FontSize ||
                    styleUser.$itemFontSize ||
                    styleSystem.$itemFontSize;
            gameMenu.colorItemFontColor = style.ItemFontColor || style.FontColor ||
                    styleUser.$itemFontColor ||
                    styleSystem.$itemFontColor;
            gameMenu.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor ||
                    styleUser.$itemBackgroundColor1 ||
                    styleSystem.$itemBackgroundColor1;
            gameMenu.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor ||
                    styleUser.$itemBackgroundColor2 ||
                    styleSystem.$itemBackgroundColor2;
            gameMenu.nTitleFontSize = style.TitleFontSize || style.FontSize ||
                    styleUser.$titleFontSize ||
                    styleSystem.$titleFontSize;
            gameMenu.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor ||
                    styleUser.$titleBackgroundColor ||
                    styleSystem.$titleBackgroundColor;
            gameMenu.colorTitleFontColor = style.TitleFontColor || style.BackgroundColor ||
                    styleUser.$titleFontColor ||
                    styleSystem.$titleFontColor;
            gameMenu.colorItemBorderColor = style.ItemBorderColor || style.BorderColor ||
                    styleUser.$itemBorderColor ||
                    styleSystem.$itemBorderColor;
            gameMenu.strTitle = style.TitleText ||
                    styleUser.$titleText ||
                    styleSystem.$titleText;

            mainMenu.visible = true;

            nShowWindowFlags |= 0b1;
            newFlags |= 0b1;
        }
        if((flags & 0b10) && !(nShowWindowFlags & 0b10)) {
            itemFightRoleInfo.maskFightRoleInfo.color = style.MaskColor || '#7FFFFFFF';
            itemFightRoleInfo.init(value || 0);
            itemFightRoleInfo.visible = true;
            //showFightRoleInfo(value || 0);

            nShowWindowFlags |= 0b10;
            newFlags |= 0b10;
        }
        if((flags & 0b100) && !(nShowWindowFlags & 0b100)) {
            rectGoods.maskGoods.color = style.MaskColor || '#7FFFFFFF';
            rectGoods.init();
            //rectGoods.showGoods(-1);
            rectGoods.visible = true;

            nShowWindowFlags |= 0b100;
            newFlags |= 0b100;
        }
        if((flags & 0b1000) && !(nShowWindowFlags & 0b1000)) {
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$system') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$system;

            containerSystemMenu.maskSystemMenu.color = style.MaskColor ||
                    styleUser.$maskColor ||
                    styleSystem.$maskColor;
            containerSystemMenu.gamemenuSystemMenu.border.color = style.BorderColor ||
                    styleUser.$borderColor ||
                    styleSystem.$borderColor;
            containerSystemMenu.gamemenuSystemMenu.color = style.BackgroundColor ||
                    styleUser.$backgroundColor ||
                    styleSystem.$backgroundColor;
            containerSystemMenu.gamemenuSystemMenu.nItemFontSize = style.ItemFontSize || style.FontSize ||
                    styleUser.$itemFontSize ||
                    styleSystem.$itemFontSize;
            containerSystemMenu.gamemenuSystemMenu.colorItemFontColor = style.ItemFontColor || style.FontColor ||
                    styleUser.$itemFontColor ||
                    styleSystem.$itemFontColor;
            containerSystemMenu.gamemenuSystemMenu.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor ||
                    styleUser.$itemBackgroundColor1 ||
                    styleSystem.$itemBackgroundColor1;
            containerSystemMenu.gamemenuSystemMenu.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor ||
                    styleUser.$itemBackgroundColor2 ||
                    styleSystem.$itemBackgroundColor2;
            containerSystemMenu.gamemenuSystemMenu.nTitleFontSize = style.TitleFontSize || style.FontSize ||
                    styleUser.$titleFontSize ||
                    styleSystem.$titleFontSize;
            containerSystemMenu.gamemenuSystemMenu.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor ||
                    styleUser.$titleBackgroundColor ||
                    styleSystem.$titleBackgroundColor;
            containerSystemMenu.gamemenuSystemMenu.colorTitleFontColor = style.TitleFontColor || style.BackgroundColor ||
                    styleUser.$titleFontColor ||
                    styleSystem.$titleFontColor;
            containerSystemMenu.gamemenuSystemMenu.colorItemBorderColor = style.ItemBorderColor || style.BorderColor ||
                    styleUser.$itemBorderColor ||
                    styleSystem.$itemBorderColor;
            containerSystemMenu.gamemenuSystemMenu.strTitle = style.TitleText ||
                    styleUser.$titleText ||
                    styleSystem.$titleText;

            containerSystemMenu.showSystemMenu();

            nShowWindowFlags |= 0b1000;
            newFlags |= 0b1000;
        }


        if(nShowWindowFlags !== 0)
            visible = true;


        sg_show(newFlags, nShowWindowFlags);
    }

    function closeWindow(flags=-1) {
        if(nShowWindowFlags === 0)
            return;


        let newFlags = 0;

        if((flags & 0b1) && (nShowWindowFlags & 0b1)) {
            mainMenu.visible = false;
            nShowWindowFlags &= ~0b1;
            newFlags |= 0b1;
        }
        if((flags & 0b10) && (nShowWindowFlags & 0b10)) {
            itemFightRoleInfo.visible = false;
            nShowWindowFlags &= ~0b10;
            newFlags |= 0b10;
        }
        if((flags & 0b100) && (nShowWindowFlags & 0b100)) {
            rectGoods.visible = false;
            nShowWindowFlags &= ~0b100;
            newFlags |= 0b100;
        }
        if((flags & 0b1000) && (nShowWindowFlags & 0b1000)) {
            containerSystemMenu.visible = false;
            nShowWindowFlags &= ~0b1000;
            newFlags |= 0b1000;
        }


        //rectStatus.visible = false;
        //rectSkills.visible = false;
        //rectEquipment.visible = false;
        //itemUseOrEquip.visible = false;
        //rectEquipInfo.visible = false;


        sg_hide(newFlags, nShowWindowFlags);


        if(nShowWindowFlags === 0) {
            sg_close();
        }
    }


    /*function showFightRoleInfo(nIndex) {
        itemFightRoleInfo.init(nIndex);
        itemFightRoleInfo.visible = true;
    }*/



    //打开了哪些窗口
    property int nShowWindowFlags: 0



    //主菜单
    Item {
        id: mainMenu

        anchors.fill: parent
        visible: false


        Mask {
            id: maskMainMenu

            anchors.fill: parent
            color: '#7FFFFFFF'

            mouseArea.onPressed: {
                closeWindow(0b1);
            }
        }


        ColumnLayout {
            id: gameMainMenu

            width: parent.width * 0.6
            //width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.96
            //height: parent.height * 0.5
            height: Math.min(gameMenu.implicitHeight, parent.height * 0.6)

            anchors.centerIn: parent

            spacing: 0

            //菜单
            GameMenu {
                id: gameMenu
                Layout.fillHeight: true
                Layout.fillWidth: true

                border.color: 'white'
                radius: height / 20

                onSg_choice: function(index) {

                    switch(index) {
                    case 0:
                        root.showWindow(0b10);
                        //itemFightRoleInfo.init();
                        break;
                    case 1:
                        root.showWindow(0b100);
                        //rectGoods.init();
                        //rectGoods.visible = true;
                        break;
                    case 2:
                        root.showWindow(0b1000);
                        //containerSystemMenu.showSystemMenu();
                        break;
                    default:
                        closeWindow(-1);
                    }
                }
            }
        }

    }



    GameBagWindow {
        id: rectGoods

        //铺满整个屏幕
        anchors.fill: parent
        visible: false

    }


    GameFightRoleInfoWindow {
        id: itemFightRoleInfo

        anchors.fill: parent
        visible: false


        onSg_refreshBagWindow: {
            rectGoods.init();
            //rectGoods.visible = true;
        }
    }


    GameSystemWindow {
        id: containerSystemMenu

        anchors.fill: parent
        visible: false
    }


    /*/选择道具
    Item {
        id: itemUseOrEquip

        property int choiceIndex: -1


        anchors.fill: parent
        visible: false


        Mask {
            anchors.fill: parent
            color: 'lightgray'
            opacity: 0.6

            mouseArea.onPressed: {
                itemUseOrEquip.visible = false;
            }
        }


        Column {

            width: parent.width * 0.6
            height: parent.height * 0.5
            anchors.centerIn: parent

            spacing: 10


            Rectangle {

                width: parent.width
                height: textGoodsInfo.implicitHeight

                color: 'darkblue'

                Text {
                    id: textGoodsInfo
                    anchors.fill: parent

                    color: 'white'

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 16
                    font.bold: true
                    text: ''
                    wrapMode: Text.Wrap
                }
            }

            ColorButton {
                id: buttonUse

                width: parent.width

                text: '使用'
                onSg_clicked: {
                    _private.close();


                    let goods = game.gd['$sys_goods'][itemUseOrEquip.choiceIndex];
                    yield game.usegoods(goods.$rid);
                }
            }
            ColorButton {
                id: buttonEquip

                width: parent.width

                text: '装备'
                onSg_clicked: {
                    _private.close();


                    let goods = game.gd['$sys_goods'][itemUseOrEquip.choiceIndex];
                    let goodsInfo = game.$sys.getGoodsResource(goods.$rid);

                    if(goodsInfo.$commons.$equipScript)
                        game.run(goodsInfo.$commons.$equipScript(goods, goodsInfo) ?? null);
                        //game.run(goodsInfo.$commons.$equipScript(goods.$rid) ?? null);
                }
            }
        }

    }
    */




    /*/状态框
    Rectangle {
        id: rectStatus
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.5
        color: 'lightgray'
        visible: false

        Column {
            anchors.fill: parent

            Text {
                id: textHP
                text: qsTr('')
            }
            Text {
                id: textMP
                text: qsTr('')
            }
            Text {
                id: textAttack
                text: qsTr('')
            }
            Text {
                id: textDefense
                text: qsTr('')
            }
            Text {
                id: textPower
                text: qsTr('')
            }
            Text {
                id: textLuck
                text: qsTr('')
            }
            Text {
                id: textSpeed
                text: qsTr('')
            }
            Text {
                id: textEXP
                text: qsTr('')
            }
            Text {
                id: textLevel
                text: qsTr('')
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked:
                rectStatus.visible = false
        }
    }


    //装备框
    Item {
        id: rectEquipment
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.5
        //color: 'lightgray'
        visible: false

        GameMenu {
            id: gameEquipmentMenu
            width: parent.width
            //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
            //height: flickableEquipment.height < implicitHeight ? flickableEquipment.height : implicitHeight
            height: parent.height
            //nItemMaxHeight: 100
            //nItemMinHeight: 50

            onSg_choice: function(index) {
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

                let hero = game.gd['$sys_fight_heros'][0];
                let position = rectEquipInfo.positions[rectEquipInfo.choicePosition];
                textEquipInfo.text = game.$sys.getGoodsResource(hero.$equipment[position].$rid).$description;

                rectEquipInfo.visible = true;
            }
        }
    }


    //技能框
    Item {
        id: rectSkills
        anchors.centerIn: parent

        width: parent.width * 0.6
        height: parent.height * 0.5

        //color: 'lightgray'

        visible: false

        GameMenu {
            id: gameSkillsMenu
            width: parent.width
            //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
            //height: flickableSkills.height < implicitHeight ? flickableSkills.height : implicitHeight
            height: parent.height
            //nItemMaxHeight: 100
            //nItemMinHeight: 50

            onSg_choice: function(index) {
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
    }

    */


    /*/选择装备
    Rectangle {
        id: rectEquipInfo
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.5
        color: 'lightgray'
        visible: false

        property int choicePosition
        property var positions: []

        Column {
            anchors.fill: parent

            TextEdit {
                id: textEquipInfo

                width: parent.width
                wrapMode: TextEdit.Wrap
            }

            ColorButton {
                id: buttonUnload

                width: parent.width

                text: '脱下'
                onSg_clicked: {
                    _private.close();


                    //let hero = game.gd['$sys_fight_heros'][0];
                    game.getgoods(game.unload(0, rectEquipInfo.positions[rectEquipInfo.choicePosition]));
                }
            }
        }

    }
    */



    QtObject {  //私有数据,函数,对象等
        id: _private


        /*/显示技能
        function showSkills(heroIndex=0) {
            if(game.gd['$sys_fight_heros'].length <= heroIndex) {
                return;
            }

            let hero = game.gd['$sys_fight_heros'][heroIndex];
            let arrName = [];
            for(let skill of hero['skills']) {
                arrName.push(skill.$name);
            }

            //for(let i = 0; i < 2; ++i)
            //    arrName.push(i + 'hi');

            rectSkills.visible = true;
            gameSkillsMenu.show(arrName);
        }

        function showEquipment(heroIndex=0) {

            if(game.gd['$sys_fight_heros'].length <= heroIndex) {
                rectEquipment.visible = true;
                return;
            }

            rectEquipInfo.positions = [];
            let arrEquipment = [];
            let hero = game.gd['$sys_fight_heros'][heroIndex];
            for(let position in hero.$equipment) {
                rectEquipInfo.positions.push(position);
                arrEquipment.push('%1：%2'.arg(position).arg(game.$sys.getGoodsResource(hero.$equipment[position].$rid).$properties.name) );
                //textEquipment.text = textEquipment.text + equipment + '  ' + game.$sys.getGoodsResource(hero.$equipment[position].$rid).$properties.name + '\r\n';
            }

            //for(let i = 0; i < 2; ++i)
            //    arrName.push(i + 'hi');

            gameEquipmentMenu.show(arrEquipment);

            rectEquipment.visible = true;
        }

        function showStatus(heroIndex=0) {

            if(game.gd['$sys_fight_heros'].length <= heroIndex) {
                textHP.text = '没有这个战斗角色';
                rectStatus.visible = true;
                return;
            }

            let hero = game.gd['$sys_fight_heros'][heroIndex];

            textHP.text = 'HP：' + hero.$$propertiesWithExtra.remainHP + '/' + hero.$$propertiesWithExtra.healthHP + '/' + hero.$$propertiesWithExtra.HP;
            textMP.text = 'MP：'+ hero.$$propertiesWithExtra.remainMP + '/' + hero.$$propertiesWithExtra.MP;
            textAttack.text = '攻击：' + hero.$$propertiesWithExtra.attack;
            textDefense.text = '防御：' + hero.$$propertiesWithExtra.defense;
            textPower.text = '灵力：' + hero.$$propertiesWithExtra.power;
            textLuck.text = '幸运：' + hero.$$propertiesWithExtra.luck;
            textSpeed.text = '速度：' + hero.$$propertiesWithExtra.speed;
            textEXP.text = '经验：' + hero.$properties.EXP;
            textLevel.text = '级别：' + hero.$properties.level;

            rectStatus.visible = true;
        }
        */

    }



    Component.onCompleted: {
        gameMenu.show(['状态', '背包', '系统', '关闭菜单']);
    }
}
