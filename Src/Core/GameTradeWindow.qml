﻿import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14
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



//游戏交易框
Item {
    id: root


    //初始化交易道具；
    //goods：可以买的；
    //mygoodsinclude为true表示可卖背包内所有物品，为数组则为数组中可交易的物品列表；
    //callback：交易完成后的脚本
    function init(goods=[], mygoodsinclude=true) {
        arrSaleGoods = [];

        for(let g of goods) {
            if(GlobalLibraryJS.isString(g))
                g = {RID: g, $count: -1};
            let tgoods = game.$sys.getGoodsObject(g, true);
            if(!tgoods)
                console.warn('没有道具：', g);
            else {
                arrSaleGoods.push(tgoods);
            }
        }

        root.mygoodsinclude = mygoodsinclude;
        goodsDetail.text = '双击进行买卖';

        //root.visible = true;
        refresh();
    }


    //刷新（主要是背包的道具）
    function refresh() {
        textMoney.text = '金钱：￥ ' + game.gd['$sys_money'];


        let arrShowSaleGoods = [];  //显示的名称（道具）
        for(let g of arrSaleGoods) {
            let tgoodsName = GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(g, {Image: true, Color: true, Count: (g.$count >= 0 ? true : false), Price: 0}));
            arrShowSaleGoods.push(tgoodsName);
        }
        gamemenuSaleGoods.show(arrShowSaleGoods, arrSaleGoods);


        let arrShowMyGoods = [];  //显示的名称
        let arrMyGoods = [];    //道具名
        for(let g of game.gd['$sys_goods']) {
            if(mygoodsinclude === true ||
                    (GlobalLibraryJS.isArray(mygoodsinclude) && mygoodsinclude.indexOf(g.$rid) >= 0)) {

                //let goodsInfo = _private.goodsResource[g.$rid];
                let tgoods = game.$sys.getGoodsObject(g, false);
                arrShowMyGoods.push(GlobalLibraryJS.convertToHTML(game.$sys.resources.commonScripts.$showGoodsName(g, {Image: true, Color: true, Count: true, Price: 1})));
                arrMyGoods.push(g);
            }
        }
        gamemenuMyGoods.show(arrShowMyGoods, arrMyGoods);
    }


    signal sg_close();


    //商店所列 道具名
    property var arrSaleGoods: []
    //mygoodsinclude为true表示可卖背包内所有物品，为数组则为数组中可交易的物品列表；
    property var mygoodsinclude


    anchors.fill: parent
    visible: false



    Mask {
        anchors.fill: parent
        color: '#7FFFFFFF'
    }


    ColumnLayout {

        width: parent.width * 0.96
        height: parent.height * 0.8
        anchors.centerIn: parent


        Rectangle {

            //width: parent.width
            //height: textGoodsInfo.implicitHeight
            Layout.fillWidth: true
            Layout.preferredHeight: buttonCloseTrade.implicitHeight
            //Layout.preferredWidth: parent.width

            color: 'blue'

            RowLayout {
                //Layout.preferredWidth: parent.width
                //Layout.preferredHeight: 60
                //Layout.fillWidth: true
                anchors.fill: parent

                Text {
                    id: textMoney

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    //Layout.preferredHeight: 60

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
                    id: buttonCloseTrade


                    Layout.preferredWidth: 60
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    //Layout.preferredHeight: parent.height

                    text: '关闭'
                    textTips.color: 'white'
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1

                    onSg_clicked: {
                        sg_close();
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 0

            GameMenu {
                id: gamemenuSaleGoods

                Layout.fillWidth: true
                Layout.fillHeight: true

                nTitleHeight: 30
                colorTitleColor: 'darkred'
                strTitle: '买'
                //每页个数
                nPageItemsCount: 20

                onSg_choice: {
                    //let goodsInfo = _private.goodsResource[arrData[index]];

                    let description = arrData[index].$description;
                    if(GlobalLibraryJS.isFunction(description))
                        description = description(arrData[index]);
                    goodsDetail.text = description;
                }
                onSg_doubleChoice: {
                    if(arrData[index].$price) {
                        itemCountBox.tradeData.type = 1;
                        itemCountBox.tradeData.goods = arrData[index];

                        textCountBoxCount.text = 1;
                        sliderCount.value = 1;
                        sliderCount.from = 1;
                        sliderCount.to = arrData[index].$count >= 0 ? arrData[index].$count : 99;

                        _private.refreshTradeInfoBox();


                        itemCountBox.visible = true;
                        sliderCount.forceActiveFocus();
                    }
                    else
                        //game.run(function() {
                            game.msg('此物品不能买', 20, '', 0, {Type: 0b10}, false);
                            //return false;
                        //});

                    return;


                    ////let goodsInfo = _private.goodsResource[arrData[index]];

                    /*if(game.gd['$sys_money'] < arrData[index].$price[0]) {
                        game.run(function*(){yield game.msg('金钱不足');}());
                        return;
                    }

                    if(arrData[index].$count === 0) {
                        game.run(function*(){yield game.msg('已卖完');}());
                        return;
                    }
                    else if(arrData[index].$count > 0) {
                        --arrData[index].$count;
                    }

                    game.gd['$sys_money'] -= arrData[index].$price[0];
                    game.getgoods(GlobalLibraryJS.copyPropertiesToObject({}, arrData[index]), 1);
                    root.refresh();
                    */
                }
            }

            GameMenu {
                id: gamemenuMyGoods

                Layout.fillWidth: true
                Layout.fillHeight: true

                nTitleHeight: 30
                colorTitleColor: 'darkred'
                strTitle: '卖'
                //每页个数
                nPageItemsCount: 20

                onSg_choice: {
                    //let goodsInfo = _private.goodsResource[game.gd['$sys_goods'][index].$rid];
                    let description = game.gd['$sys_goods'][index].$description;
                    if(GlobalLibraryJS.isFunction(description))
                        description = description(game.gd['$sys_goods'][index]);
                    goodsDetail.text = description;
                }
                onSg_doubleChoice: {
                    if(arrData[index].$price && GlobalLibraryJS.isValidNumber(arrData[index].$price[1])) {
                        itemCountBox.tradeData.type = 2;
                        itemCountBox.tradeData.goods = arrData[index];

                        textCountBoxCount.text = 1;
                        sliderCount.value = 1;
                        sliderCount.from = 1;
                        sliderCount.to = arrData[index].$count;

                        _private.refreshTradeInfoBox();


                        itemCountBox.visible = true;
                        sliderCount.forceActiveFocus();
                    }
                    else
                        //game.run(function() {
                            game.msg('此物品不能卖', 20, '', 0, {Type: 0b10}, false);
                            //return false;
                        //});

                    return;

                    ////let goodsInfo = game.gd['$sys_goods'][index];

                    /*
                    if(arrData[index].$price && GlobalLibraryJS.isValidNumber(arrData[index].$price[1])) {
                        game.removegoods(arrData[index], 1);
                        game.gd['$sys_money'] += arrData[index].$price[1];
                        root.refresh();
                    }
                    else
                        game.run(function*(){yield game.msg('此物品不能卖');}());
                    */
                }
            }
        }

        Notepad {
            id: goodsDetail

            Layout.fillWidth: true
            //Layout.maximumHeight: 60
            Layout.maximumHeight: parent.height * 0.3
            Layout.preferredHeight: textArea.implicitHeight
            //Layout.fillHeight: true

            color: 'darkblue'

            //horizontalAlignment: Text.AlignHCenter
            textArea.verticalAlignment: Text.AlignVCenter

            textArea.color: 'white'
            //textArea.color: Global.style.foreground
            textArea.font.pointSize: 16
            textArea.font.bold: true
            //textArea.enabled: false
            textArea.readOnly: true
            textArea.selectByMouse: false
            textArea.wrapMode: Text.Wrap

            textArea.background: Rectangle {
                color: 'transparent'
                //color: Global.style.backgroundColor
                //border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                //border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }
    }


    Rectangle {
        id: itemCountBox

        property var tradeData: ({})

        anchors.centerIn: parent
        width: parent.width * 0.5
        height: columnLayoutCountBox.implicitHeight

        visible: false


        //color: '#CF6699FF'
        //color: '#EE00CC99'
        color: 'darkblue'


        ColumnLayout {
            id: columnLayoutCountBox

            //anchors.fill: parent
            width: parent.width
            height: implicitHeight

            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode: Text.NoWrap

                text: '输入数量'
                color: 'white'

                font.pointSize: 16
                font.bold: true

                background: Rectangle {
                    color: '#EE00CC99'
                    implicitHeight: 0
                    //color: Global.style.backgroundColor
                    //border.color: debugMsg.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                    //border.width: debugMsg.textArea.focus ? 2 : 1
                }
            }

            Slider {
                id: sliderCount


                Layout.fillWidth: true
                Layout.preferredHeight: 36


                from: 1
                to: 99
                stepSize: 1


                onMoved: {
                    textCountBoxCount.text = value;

                    //console.debug(value, position);
                }
            }

            TextField {
                id: textCountBoxCount


                Layout.fillWidth: true
                Layout.preferredHeight: 36


                placeholderText: '输入数量'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap

                color: 'white'
                placeholderTextColor: '#7F7F7F7F'

                //padding : nPadding
                leftPadding : 6
                rightPadding : 6
                topPadding : 6
                bottomPadding: 6
                background: Rectangle {
                    color: '#FF0035A8'
                    implicitHeight: 0
                    //color: Global.style.backgroundColor
                    //border.color: debugMsg.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                    //border.width: debugMsg.textArea.focus ? 2 : 1
                }


                onTextChanged: {
                    _private.refreshTradeInfoBox();
                }
            }

            Text {
                id: textCountBoxMoney


                Layout.fillWidth: true
                //Layout.preferredHeight: 60

                color: 'white'

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 16
                font.bold: true

                wrapMode: Text.NoWrap

                text: '￥'
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                Layout.preferredWidth: parent.width

                ColorButton {
                    Layout.alignment: Qt.AlignHCenter


                    text: '确定'
                    textTips.color: 'white'
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1



                    onSg_clicked: {
                        itemCountBox.visible = false;

                        let goods = itemCountBox.tradeData.goods;
                        let count = parseInt(textCountBoxCount.text);

                        //买
                        if(itemCountBox.tradeData.type === 1) {
                            if(game.gd['$sys_money'] < goods.$price[0] * count) {
                                //game.run(function() {
                                    game.msg('金钱不足', 20, '', 0, {Type: 0b10}, false);
                                //    return false;
                                //});
                                return;
                            }

                            if(goods.$count === 0 || (goods.$count > 0 && count > goods.$count)) {
                                //game.run(function() {
                                    game.msg('出售道具不够', 20, '', 0, {Type: 0b10}, false);
                                //    return false;
                                //});
                                return;
                            }

                            if(goods.$count > 0)
                                goods.$count -= count;
                            game.gd['$sys_money'] -= (goods.$price[0] * count);
                            game.getgoods(GlobalLibraryJS.copyPropertiesToObject({}, goods), count);
                            root.refresh();
                        }
                        //卖
                        else {
                            if(goods.$count >= count) {
                                game.removegoods(goods, count);
                                game.gd['$sys_money'] += (goods.$price[1] * count);
                                root.refresh();
                            }
                            else
                                //game.run(function() {
                                    game.msg('卖出道具不够', 20, '', 0, {Type: 0b10}, false);
                                    //return false;
                                //});
                        }


                        root.forceActiveFocus();
                    }
                }
                ColorButton {
                    Layout.alignment: Qt.AlignHCenter


                    text: '取消'
                    textTips.color: 'white'
                    colors: ['blue', 'darkblue', 'darkgreen']
                    border.color: 'white'
                    border.width: 1



                    onSg_clicked: {
                        itemCountBox.visible = false;


                        root.forceActiveFocus();
                    }
                }
            }

        }
    }


    QtObject {  //私有数据,函数,对象等
        id: _private

        //刷新 交易数据框
        function refreshTradeInfoBox() {

            let goods = itemCountBox.tradeData.goods;
            let count = parseInt(textCountBoxCount.text);

            if(itemCountBox.tradeData.type === 1) {
                textCountBoxMoney.text = '￥' + goods.$price[0] * count;
            }
            else {
                textCountBoxMoney.text = '￥' + goods.$price[1] * count;
            }

            sliderCount.value = parseInt(textCountBoxCount.text);
        }
    }
}
