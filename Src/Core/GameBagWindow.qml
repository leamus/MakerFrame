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



//道具框（背包）
Item {
    id: root


    //初始化，主要是显示 战斗人物 和 所有的道具
    function init() {

        //let fightheros = game.fighthero(-1, 1);
        //let fightRolePath = $GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName) + GameMakerGlobal.separator;
        let fightheros = game.fighthero(-1);
        let arrFightHerosName = [];
        for(let tf of fightheros) {
            arrFightHerosName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showCombatantName(tf, {avatar: true, color: true})));
        }
        gameFightRoleMenu.show(arrFightHerosName);
        if(arrFightHerosName.length > 0)
            gameFightRoleMenu.choice(0);


        //if(arrFightHerosName.length > 0)
        //    gameFightRoleMenu.nChoiceIndex = 0;

        //gameGoodsMenu.nChoiceIndex = -1;
        showGoods(-1);
        //visible = true;
    }

    function hide() {
        //closeWindow(0b100);
        game.window({$id: 0b100, $visible: false});
    }


    //按类型 显示道具
    //type：-1，所有；1，可用；2，可装；3，战时；4，可卖；5，剧情类
    function showGoods(type=undefined) {
        //let goodsPath = $GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName) + GameMakerGlobal.separator;

        if(type === undefined || type === null)
            type = nlastShowType;


        let arrGoodsName = [];

        switch(type) {
        case 1:
            gameGoodsMenu.arrGoods = [];
            for(let goods of game.gd['$sys_goods']) {
                let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
                if(goodsInfo.$commons.$useScript) {
                    gameGoodsMenu.arrGoods.push(goods);
                    arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
                }
            }

            break;
        case 2:
            gameGoodsMenu.arrGoods = [];
            for(let goods of game.gd['$sys_goods']) {
                let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
                if(goodsInfo.$commons.$equipScript) {
                    gameGoodsMenu.arrGoods.push(goods);
                    arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
                }
            }

            break;
        case 3:
            gameGoodsMenu.arrGoods = [];
            for(let goods of game.gd['$sys_goods']) {
                let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
                if(goodsInfo.$commons.$fightScript) {
                    gameGoodsMenu.arrGoods.push(goods);
                    arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
                }
            }
            break;

        case 4:
            gameGoodsMenu.arrGoods = [];
            for(let goods of game.gd['$sys_goods']) {
                //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
                if(goods.$price && goods.$price[1] !== undefined) {
                    gameGoodsMenu.arrGoods.push(goods);
                    arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
                }
            }
            break;

        case 5:
            gameGoodsMenu.arrGoods = [];
            for(let goods of game.gd['$sys_goods']) {
                //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);
                if(goods.$type === 4) {
                    gameGoodsMenu.arrGoods.push(goods);
                    arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
                }
            }
            break;

        case -1:
        default:
            gameGoodsMenu.arrGoods = game.gd['$sys_goods'];
            for(let goods of game.gd['$sys_goods']) {
                arrGoodsName.push($CommonLibJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(goods, {Image: true, Color: true, Count: true})));
            }

            break;
        }

        //for(let i = 0; i < 2; ++i)
        //    arrGoodsName.push(i + 'hi');


        textGoodsInfo.text = textGoodsInfo.strPreText;
        textMoney.text = game.$sys.getCommonScriptResource('$config', '$names', '$money') + ':' + game.gd['$sys_money'];


        if(arrGoodsName.length > 0 && gameGoodsMenu.nChoiceIndex < 0)
            root.nLastChoicedIndex = 0;
        else
            root.nLastChoicedIndex = gameGoodsMenu.nChoiceIndex;

        gameGoodsMenu.show(arrGoodsName);
        gameGoodsMenu.choice(root.nLastChoicedIndex);

        root.nlastShowType = type;
    }



    //上次保存的类型 和 选择的道具下标
    property int nlastShowType: 0
    property int nLastChoicedIndex: 0

    property alias maskGoods: maskGoods


    anchors.fill: parent
    visible: false



    Mask {
        id: maskGoods

        anchors.fill: parent
        //opacity: 0
        //color: Global.style.backgroundColor
        color: '#7FFFFFFF'
        //radius: 9

        mouseArea.onPressed: {
            //点击后关闭
            root.hide();
        }
    }


    //总布局（竖方向）
    ColumnLayout {
        //大小和位置
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent

        //金钱背景
        Rectangle {
            id: rectMoney

            Layout.fillWidth: true
            Layout.maximumHeight: 60
            Layout.preferredHeight: textMoney.implicitHeight
            //Layout.fillHeight: true

            color: 'darkblue'

            //金钱文字
            Text {
                id: textMoney
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


        //筛选按钮的背景
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: buttonGoodsAll.height

            color: 'blue'

            //筛选的一排按钮布局
            RowLayout {
                anchors.fill: parent
                spacing: 0

                //每个按钮
                ColorButton {
                    id: buttonGoodsAll
                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '全部'
                    onSg_clicked: {
                        root.showGoods(-1);
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '使用'
                    onSg_clicked: {
                        root.showGoods(1);
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '装备'
                    onSg_clicked: {
                        root.showGoods(2);
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '战斗'
                    onSg_clicked: {
                        root.showGoods(3);
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '剧情'
                    onSg_clicked: {
                        root.showGoods(5);
                    }
                }
                ColorButton {
                    visible: false

                    Layout.alignment: Qt.AlignHCenter

                    textTips.color: 'white'
                    textTips.font.pointSize: 12
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1
                    text: '卖'
                    onSg_clicked: {
                        root.showGoods(4);
                    }
                }
            }
        }

        //列表
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            //Layout.preferredWidth: parent.width
            //Layout.maximumHeight: parent.height / 3

            //道具说明框（包括位置、颜色、文字等）
            Notepad {
                id: textGoodsInfo
                property string strPreText: '背包界面，双击战斗角色可以查看详细信息'

                //width: parent.width
                //height: textGoodsInfo.implicitHeight
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                //Layout.preferredHeight: textArea.implicitHeight
                //Layout.maximumHeight: parent.height * 0.3


                //textArea.enabled: false
                textArea.readOnly: true
                color: 'darkblue'

                //horizontalAlignment: Text.AlignHCenter
                //textArea.verticalAlignment: Text.AlignVCenter

                textArea.selectByMouse: false
                textArea.color: 'white'
                //textArea.color: Global.style.foreground
                textArea.font.pointSize: 16
                textArea.font.bold: true
                textArea.wrapMode: Text.Wrap

                //horizontalAlignment: Text.AlignHCenter
                //verticalAlignment: Text.AlignVCenter

                font.pointSize: 16
                font.bold: true
                text: ''
                //wrapMode: Text.Wrap

                textArea.background: Rectangle {
                    color: 'transparent'
                    //color: Global.style.backgroundColor
                    //border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    //border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }
            }

            //战斗人物 和 道具 的竖布局
            ColumnLayout {
                //Layout.preferredWidth: parent.width / 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                //战斗人物的列表
                GameMenu {
                    id: gameFightRoleMenu

                    //Layout.preferredWidth: parent.width * 0.5
                    Layout.fillWidth: true
                    //Layout.fillHeight: true
                    Layout.maximumHeight: 120
                    Layout.minimumHeight: 90
                    Layout.preferredHeight: 105

                    //width: parent.width
                    //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
                    //height: flickableGoods.height < implicitHeight ? flickableGoods.height : implicitHeight
                    //height: parent.height

                    //nItemMaxHeight: 100
                    nItemMinHeight: 50
                    nItemHeight: -1 //implicitHeight

                    rItemFontSize: 12


                    //双击后弹出信息
                    onSg_doubleChoice: {
                        //root.showWindow(0b10, nChoiceIndex);
                        game.window({$id: 0b10, $value: nChoiceIndex});
                        //itemFightRoleInfo.init(nChoiceIndex);
                    }
                }

                //道具的列表
                GameMenu {
                    id: gameGoodsMenu

                    property var arrGoods: []


                    //Layout.preferredWidth: parent.width * 0.5
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //width: parent.width
                    //implicitHeight很大时会滚动，implicitHeight很小时会按顺序排列
                    //height: flickableGoods.height < implicitHeight ? flickableGoods.height : implicitHeight
                    //height: parent.height

                    //nItemMaxHeight: 100
                    nItemMinHeight: 50
                    nItemHeight: -1 //implicitHeight

                    rItemFontSize: 12

                    //每页个数
                    nPageItemsCount: 20


                    //单击
                    onSg_choice: function(index) {

                        /*switch(index) {
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
                        }*/

                        if(gameGoodsMenu.arrGoods.length === 0) {
                            index = -1;
                            return;
                        }
                        if(index < 0) {
                            index = 0;
                        }
                        else if(index >= gameGoodsMenu.arrGoods.length)
                            index = gameGoodsMenu.arrGoods.length - 1;

                        //gameGoodsMenu.nChoiceIndex = index;

                        let goodsInfo = game.$sys.getGoodsResource(gameGoodsMenu.arrGoods[index].$rid);
                        buttonUse.visible = (goodsInfo.$commons.$useScript ? true : false);
                        buttonEquip.visible = (goodsInfo.$commons.$equipScript ? true : false);

                        let description = gameGoodsMenu.arrGoods[index].$description;
                        if($CommonLibJS.isFunction(description))
                            description = description(gameGoodsMenu.arrGoods[index]);
                        textGoodsInfo.text = description;
                        //itemUseOrEquip.visible = true;
                    }
                }
            }
        }


        //操作的一排按钮
        RowLayout {
            Layout.fillWidth: true
            //Layout.preferredHeight: 30

            //使用按钮
            ColorButton {
                id: buttonUse

                Layout.fillWidth: true
                //width: parent.width

                text: '使用'
                textTips.font.pointSize: 12

                //点击后操作
                onSg_clicked: {
                    if(gameGoodsMenu.nChoiceIndex < 0 || gameGoodsMenu.nChoiceIndex >= gameGoodsMenu.arrGoods.length)
                        return;

                    //_private.close();

                    let index = gameFightRoleMenu.nChoiceIndex;
                    let goods = gameGoodsMenu.arrGoods[gameGoodsMenu.nChoiceIndex];

                    //脚本执行完毕后刷新背包
                    game.run(function*() {
                        yield game.usegoods(index, goods);
                        root.showGoods(root.nlastShowType);
                    }());
                }
            }

            //装备按钮
            ColorButton {
                id: buttonEquip

                Layout.fillWidth: true
                //width: parent.width

                text: '装备'
                textTips.font.pointSize: 12
                onSg_clicked: {
                    if(gameGoodsMenu.nChoiceIndex < 0 || gameGoodsMenu.nChoiceIndex >= gameGoodsMenu.arrGoods.length)
                        return;

                    //_private.close();

                    let index = gameFightRoleMenu.nChoiceIndex;
                    let goods = gameGoodsMenu.arrGoods[gameGoodsMenu.nChoiceIndex];
                    //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);

                    //脚本执行完毕后刷新背包
                    game.run(function*() {
                        yield game.equip(index, goods, null);
                        root.showGoods(root.nlastShowType);
                    });
                }
            }

            //丢弃按钮
            ColorButton {
                id: buttonDiscardGoods

                Layout.fillWidth: true
                //width: parent.width

                text: '丢弃'
                textTips.font.pointSize: 12
                onSg_clicked: {
                    if(gameGoodsMenu.nChoiceIndex < 0 || gameGoodsMenu.nChoiceIndex >= gameGoodsMenu.arrGoods.length)
                        return;

                    let goods = gameGoodsMenu.arrGoods[gameGoodsMenu.nChoiceIndex];
                    //let goodsInfo = game.$sys.getGoodsResource(goods.$rid);

                    game.removegoods(goods);

                    root.showGoods(root.nlastShowType);
                }
            }

            //关闭按钮
            ColorButton {
                //Layout.fillWidth: true
                //width: parent.width

                text: '关闭'
                textTips.font.pointSize: 12
                onSg_clicked: {
                    root.hide();
                }
            }
        }
    }
}
