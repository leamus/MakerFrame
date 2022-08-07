import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls 1.2 as Controls1
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import Qt.labs.settings 1.1


ColumnLayout {
    id: root

    signal s_Choice(int index);
    onS_Choice: {
        //console.debug(index)
    }

    //一个选项的最大最小高度（宽度自适应）
    property int nItemMaxHeight: 60
    property int nItemMinHeight: 20



    //显示。
    //参数：为列表的项目，可以是数组，也可以是多个字符串
    function show() {
        //console.debug(JSON.stringify(arguments));

        visible = true;

        if(arguments.length === 1 && Object.prototype.toString.call(arguments[0]) === '[object Array]') {
            arguments = arguments[0];
        }
        //else {
            let i = 0;
            for(; i < arguments.length; ++i) {
                if(i >= _private.arrItems.length) {
                    _private.arrItems.push(compItem.createObject(root, {nIndex: i}));
                    //++_private.nShowItemCount;
                }
                _private.arrItems[i].visible = true;
                _private.arrItems[i].text.text = arguments[i];

            }
            for(; i < _private.arrItems.length; ++i) {
                _private.arrItems[i].visible = false;
            }
            _private.nShowItemCount = arguments.length - 1;
        //}

        //console.debug(arguments, arguments.length);
    }



    spacing: 0
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft



    Component {
        id: compItem

        Rectangle {
            id: tRoot

            property int nIndex
            property TextInput text: TextInput {
                parent: tRoot
                anchors.fill: parent

                text: ""
                font.pointSize: 16
                readOnly: true
                color: "white"

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //console.debug(tRoot.nIndex)
                        root.s_Choice(tRoot.nIndex);
                    }
                }
            }

            //width: parent.width
            //height: parent.height / _private.nShowItemCount
            //implicitWidth: parent.width
            //implicitHeight: parent.height / _private.nShowItemCount

            Layout.preferredWidth: parent.width
            Layout.fillWidth: true
            Layout.maximumHeight: nItemMaxHeight
            Layout.minimumHeight: nItemMinHeight
            Layout.fillHeight: true
            //Layout.preferredHeight: parent.height / _private.nShowItemCount


            border {
                color: '#60FFFFFF'
            }

            color: "#00000000"
        }
    }


    QtObject {
        id: _private

        //所有选项数组，只增不减作为缓存
        property var arrItems: []
        //property int nItemCount: 1
        //使用的选项个数（可能会小于_private.arrItems个数）
        property int nShowItemCount: 0  //只读，个数

    }

    Component.onCompleted: {
        //_private.arrItems.push(compItem.createObject(root, {nIndex: 0}));
    }

}
