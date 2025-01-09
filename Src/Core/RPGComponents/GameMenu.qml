import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Controls 1.3 as Controls1
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import Qt.labs.settings 1.1


Rectangle {
    id: root



    //选择事件
    signal sg_choice(int index);
    signal sg_doubleChoice(int index);



    //外部选择
    function choice(index) {
        //console.debug(index);

        if(index >= arrList.length) {
            nChoiceIndex = arrList.length - 1;
        }
        else {
            nChoiceIndex = index;
        }

        if(nChoiceIndex < 0)
            nChoiceListIndex = arrList.length;
        else if(nPageItemsCount <= 0) {
            nChoiceListIndex = nChoiceIndex;
        }
        else {
            nChoiceListIndex = nChoiceIndex % nPageItemsCount;
        }

        if(nChoiceIndex < 0)
            nPageIndex = 0;
        else if(nPageItemsCount <= 0) {
            nPageIndex = 0;
        }
        else
            nPageIndex = parseInt(nChoiceIndex / nPageItemsCount);

        refresh();

        if(index >= 0)
            sg_choice(index);
    }


    //显示。
    //参数：为列表的项目，可以是数组（包含 1个显示的数组 和 1个data的数组），也可以是多个字符串；如果没有参数，则显示之前的；
    function show() {
        //console.debug(JSON.stringify(arguments));

        visible = true;


        if(arguments.length === 0)
            return;

        //如果第一个参数为数组
        if(/*arguments.length === 1 && */Object.prototype.toString.call(arguments[0]) === '[object Array]') {
            arrList = arguments[0];
        }
        //如果是字符串，则用 , 分割
        else if(Object.prototype.toString.call(arguments[0]) === '[object String]')
            arrList = arguments[0].split(',');


        if(arguments[1] === undefined)
            arrData = arrList;
        else
            arrData = arguments[1];


        if(nPageItemsCount <= 0)
            nMaxPage = 1;
        else
            nMaxPage = Math.ceil(arrList.length / nPageItemsCount);


        nPageIndex = 0;
        nChoiceIndex = -1;
        nChoiceListIndex = arrList.length;


        refresh();
    }

    function hide() {
        //for(let ti of _private.arrItems)
        //    ti.destroy();
        //_private.arrItems = [];
        //columnChoices.implicitHeight = 0;

        visible = false;
    }

    function refresh() {

        let count;
        let i = 0;
        if(nPageItemsCount <= 0) {
            count = arrList.length;
        }
        else {
            //i = nPageIndex * nPageItemsCount;
            if(nMaxPage === 0)
                count = 0;
            else if(nPageIndex === nMaxPage - 1)
                count = arrList.length - nPageItemsCount * nPageIndex;
            else
                count = nPageItemsCount;
        }


        //基下标
        let baseIndex;
        if(nPageItemsCount <= 0)
            baseIndex = 0;
        else
            baseIndex = nPageItemsCount * nPageIndex;

        //显示每一项
        for(; i < count; ++i) {
            if(i >= _private.arrItems.length) {
                _private.arrItems.push(compItem.createObject(columnChoices, {nIndex: i}));
                //++_private.nShowItemCount;
            }
            _private.arrItems[i].visible = true;
            _private.arrItems[i].text.text = arrList[baseIndex + i].toString();

        }
        //隐藏不用的
        for(; i < _private.arrItems.length; ++i) {
            _private.arrItems[i].visible = false;
        }
        //_private.nShowItemCount = arguments.length;

        //arrChoiceList = arguments;
        //console.debug(arguments, arguments.length);
    }



    //一个选项的最大最小高度（宽度自适应）
    //property int nItemMaxHeight: 60
    //property int nItemMinHeight: 20
    property int nItemHeight: 60    //选项高度
    property int nItemFontSize: 16  //选项字体大小
    property color colorItemFontColor: 'white'  //选项字体颜色
    property color colorItemColor1: '#00FFFFFF' //选项静止颜色
    property color colorItemColor2: '#66FFFFFF' //选项被选颜色
    property color colorItemBorderColor: '#60FFFFFF'    //选项边框颜色
    property int nTitleFontSize: 16     //标题字体大小
    property int nTitleHeight: 39
    property color colorTitleColor: '#EE00CC99' //标题颜色
    property color colorTitleFontColor: 'white' //标题文字颜色

    property var itemAlignment: Text.AlignHCenter //每个项目对齐方式


    //property var arrChoiceList  //要显示的列表
    property var arrList: []    //所有列表
    property var arrData    //对应的数据

    property int nPageIndex: 0
    property int nMaxPage: -1
    property int nPageItemsCount: -1


    property int nChoiceIndex: -1
    property int nChoiceListIndex: -1

    property string strTitle: ''


    property alias rectMenuTitle: rectMenuTitle
    property alias textMenuTitle: textMenuTitle


    property alias column1: columnRoot
    property alias column2: columnChoices


    color: '#CF6699FF'
    //color: '#9900CC99'
    //implicitWidth: columnChoices.implicitWidth
    implicitHeight: (rectMenuTitle.visible ? rectMenuTitle.implicitHeight : 0) +
                    (rectPage.visible ? rectPage.height : 0) +
                    columnChoices.height
    //implicitHeight: columnRoot.implicitHeight

    Layout.alignment: Qt.AlignTop | Qt.AlignLeft



    Component {
        id: compItem

        Rectangle {
            id: tRoot

            property int nIndex
            property TextEdit text: TextEdit {
                parent: tRoot
                anchors.fill: parent

                text: ''
                font.pointSize: nItemFontSize
                readOnly: true
                color: colorItemFontColor

                textFormat: TextEdit.RichText

                horizontalAlignment: root.itemAlignment
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //console.debug(tRoot.nIndex)
                        if(nPageItemsCount <= 0)
                            nChoiceIndex = tRoot.nIndex;
                        else
                            nChoiceIndex = nPageItemsCount * nPageIndex + tRoot.nIndex;
                        nChoiceListIndex = tRoot.nIndex;
                        root.sg_choice(nChoiceIndex);
                        mouse.accepted = true;
                    }
                    onDoubleClicked: {
                        if(nPageItemsCount <= 0)
                            nChoiceIndex = tRoot.nIndex;
                        else
                            nChoiceIndex = nPageItemsCount * nPageIndex + tRoot.nIndex;
                        nChoiceListIndex = tRoot.nIndex;
                        root.sg_doubleChoice(nChoiceIndex);
                        mouse.accepted = true;
                    }
                }
            }

            //width: parent.width
            //height: parent.height / _private.nShowItemCount
            //implicitWidth: parent.width
            //implicitHeight: parent.height / _private.nShowItemCount

            Layout.preferredWidth: parent.width
            Layout.fillWidth: true
            //Layout.maximumHeight: nItemMaxHeight
            //Layout.minimumHeight: nItemMinHeight
            Layout.preferredHeight: nItemHeight
            Layout.fillHeight: true
            //Layout.preferredHeight: parent.height / _private.nShowItemCount


            border {
                //color: '#60FFFFFF'
                color: colorItemBorderColor
            }

            //color: nChoiceListIndex === nIndex ? '#66FFFFFF' : '#00FFFFFF'
            color: nChoiceListIndex === nIndex ? colorItemColor2 : colorItemColor1


            Component.onCompleted: {
                //console.debug('[GameMenu]Created!');
            }

            Component.onDestruction: {
                //console.debug('[GameMenu]Destructed!');
            }
        }
    }


    ColumnLayout {
        id: columnRoot
        anchors.fill: parent

        spacing: 0


        Rectangle {
            id: rectMenuTitle

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            //！！如果preferredHeight为-1，则先用implicitHeight，如果没有（貌似包括为0）则用height
            //Layout.preferredHeight: root.nTitleHeight
            Layout.preferredHeight: implicitHeight
            implicitHeight: Math.max(textMenuTitle.implicitHeight, root.nTitleHeight)  //鹰：删除会导致 binding loop 错误
            //height: Math.max(textGameInputTitle.implicitHeight, root.nTitleHeight)

            //visible: (root.strTitle !== false && root.strTitle !== null && root.strTitle !== undefined)
            visible: (root.strTitle)

            //color: 'darkred'
            //color: '#EE00CC99'
            color: colorTitleColor
            //radius: rectMenu.radius

            Text {
                id: textMenuTitle

                anchors.fill: parent

                color: colorTitleFontColor

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: nTitleFontSize
                font.bold: true
                text: root.strTitle
                wrapMode: Text.Wrap
            }
        }


        //翻页组件
        Rectangle {
            id: rectPage

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 30
            //implicitHeight: height

            visible: root.nPageItemsCount !== -1

            color: 'transparent'

            RowLayout {
                anchors.fill: parent

                //左按钮
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    //Layout.preferredWidth: parent.width
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: '#9900CC99'

                    Text {
                        anchors.fill: parent

                        color: 'white'

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 16
                        font.bold: true
                        //wrapMode: Text.Wrap
                        text: '<-'
                    }

                    MouseArea {
                        anchors.fill: parent
                        //onClicked: {
                        onPressed: {
                            if(nPageIndex > 0) {
                                --nPageIndex;
                                nChoiceListIndex -= nPageItemsCount;
                                refresh();
                            };
                        }
                    }
                }

                //个数
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    Layout.preferredWidth: implicitWidth
                    //Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: 'white'

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 9
                    font.bold: true

                    text: `个数：${arrList.length}(${nPageIndex + 1}/${nMaxPage})`
                }

                //右按钮
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    //Layout.preferredWidth: parent.width
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: '#9900CC99'

                    Text {
                        anchors.fill: parent

                        color: 'white'

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 16
                        font.bold: true
                        //wrapMode: Text.Wrap
                        text: '->'
                    }

                    MouseArea {
                        anchors.fill: parent
                        //onClicked: {
                        onPressed: {
                            if(nPageIndex < nMaxPage - 1) {
                                ++nPageIndex;
                                nChoiceListIndex += nPageItemsCount;
                                refresh();
                            };
                        }
                    }
                }
            }

        }


        Flickable {
            id: flickableSkills

            Layout.fillWidth: true
            Layout.fillHeight: true

            contentWidth: width
            contentHeight: columnChoices.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            ColumnLayout {
                id: columnChoices
                //anchors.fill: parent
                width: parent.width
                spacing: 0
            }
        }
    }



    QtObject {
        id: _private

        //所有选项数组，只增不减作为缓存
        property var arrItems: []
        //property int nItemCount: 1
        //使用的选项个数（可能会小于_private.arrItems个数）
        //property int nShowItemCount: 0  //只读，个数

    }



    Component.onCompleted: {
        //_private.arrItems.push(compItem.createObject(columnChoices, {nIndex: 0}));
    }

    Component.onDestruction: {
        for(let ti in _private.arrItems) {
            _private.arrItems[ti].destroy();
        }

        //console.debug('[main]Component.onDestruction');
    }
}
