import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal sg_compile(string code);
    signal sg_close();
    onSg_close: {
        for(let tc of _private.arrCacheComponent) {
            tc.destroy();
        }
        _private.arrCacheComponent = [];
    }


    function init(filePath) {
        if(filePath)
            _private.filepath = filePath;
        _private.loadData();
    }


    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Component {
        id: compBuff

        Item {
            id: tRootBuff

            //property alias label: tlable.text


            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: 30


            RowLayout {
                anchors.fill: parent


                Label {
                    //id: tlable
                    visible: false
                    text: '*@类型'
                }

                /*ComboBox {
                    id: tcomboType

                    objectName: 'Type'

                    Layout.fillWidth: true

                    model: ['毒','乱','封','眠','攻','防','速','灵','幸']

                    background: Rectangle {
                        //implicitWidth: comboBoxComponentItem.comboBoxWidth
                        implicitHeight: 35
                        //border.color: control.pressed ? '#6495ED' : '#696969'
                        //border.width: control.visualFocus ? 2 : 1
                        color: 'transparent'
                        //border.color: comboBoxComponentItem.color
                        border.width: 2
                        radius: 6
                    }
                    onActivated: {
                        console.debug('[FightSkillVisualEditor]ComboBox:', comboType.currentIndex,
                                      comboType.currentText,
                                      comboType.currentValue);

                        switch(currentIndex) {
                        case 1:
                        case 2:
                        case 3:
                            ttextEffect.visible = false;
                            ttextEffect.text = '0';
                        break;
                        default:
                            ttextEffect.visible = true;
                        }

                    }
                }
                */
                TextField {
                    id: ttextType

                    objectName: 'Type'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@类型'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[选择Buff类型]', '毒','乱','封','眠','攻','防','速','灵','幸'],
                                    ['', 0,1,2,3,4,5,6,7,8]];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                switch(index) {
                                case 1:
                                case 2:
                                case 3:
                                    ttextEffect.visible = false;
                                    ttextEffect.text = '0';
                                break;
                                default:
                                    ttextEffect.visible = true;
                                }

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextEffect

                    objectName: 'Effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0'
                    placeholderText: '*@效果'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[Buff效果]', '固定值（整数）：20','倍率（小数）：2.0'],
                                    ['', '20','2.0']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextRound

                    objectName: 'Round'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '2'
                    placeholderText: '*@回合'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[持续回合数]', '2回合','5回合'],
                                    ['', '2','5']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextProbability

                    objectName: 'Probability'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0.5'
                    placeholderText: '*@概率'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[获得Buff概率]', '50%','100%'],
                                    ['', '0.5','1']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                Button {
                    id: tbutton

                    implicitWidth: 30

                    text: 'x'

                    onClicked: {
                        for(let tc in _private.arrCacheComponent) {
                            if(_private.arrCacheComponent[tc] === tRootBuff) {
                                _private.arrCacheComponent.splice(tc, 1);
                                break;
                            }

                        }
                        tRootBuff.destroy();
                    }
                }
            }

        }
    }


    Component {
        id: compEffect

        Item {
            id: tRootEffect

            //property alias label: tlable.text


            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            RowLayout {
                anchors.fill: parent

                Label {
                    //id: tlable
                    visible: false
                    text: '*效果'
                }

                TextField {
                    id: ttextType

                    objectName: 'Type'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@属性'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[影响属性]', '一段HP','二段HP','一段MP'],
                                    ['', 'HP, 0','HP, 1','MP, 0']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextEffect

                    objectName: 'Effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0'
                    placeholderText: '*@效果'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[效果]', '固定值（整数）：20','倍率（小数）：2.0'],
                                    ['', '20','2.0']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextCombatant

                    objectName: 'Combatant'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0'
                    placeholderText: '*@倍率参考对象'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[倍率参考对象]', '本人','对方'],
                                    ['', '0','1']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                TextField {
                    id: ttextproperty

                    objectName: 'Property'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@倍率参考属性'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[倍率参考属性]', '一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力', '一段血（装备后）','二段血（装备后）','三段血（装备后）','一段MP（装备后）','二段MP（装备后）','攻击（装备后）','防御（装备后）','速度（装备后）','幸运（装备后）','灵力（装备后）'],
                                    ['', '$properties.HP,0','$properties.HP,1','$properties.HP,2','$properties.MP,0','$properties.MP,1','$properties.attack','$properties.defense','$properties.speed','$properties.luck','$properties.power', '$$propertiesWithExtra.HP,0','$$propertiesWithExtra.HP,1','$$propertiesWithExtra.HP,2','$$propertiesWithExtra.MP,0','$$propertiesWithExtra.MP,1','$$propertiesWithExtra.attack','$$propertiesWithExtra.defense','$$propertiesWithExtra.speed','$$propertiesWithExtra.luck','$$propertiesWithExtra.power']];

                        rootWindow.aliasGlobal.list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                rootWindow.aliasGlobal.list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                Button {
                    id: tbutton

                    implicitWidth: 30

                    text: 'x'

                    onClicked: {
                        for(let tc in _private.arrCacheComponent) {
                            if(_private.arrCacheComponent[tc] === tRootEffect) {
                                _private.arrCacheComponent.splice(tc, 1);
                                break;
                            }

                        }
                        tRootEffect.destroy();
                    }
                }
            }

        }
    }



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }


    ColumnLayout {
        //anchors.fill: parent

        anchors.centerIn: parent
        width: parent.width * 0.96
        height: parent.height * 0.96

        //spacing: 16


        Rectangle {
            clip: true

            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: 'transparent'
            border {
                color: 'lightgray'
                width: 1
            }

            Flickable {
                id: flickable

                //anchors.fill: parent

                anchors.centerIn: parent
                width: parent.width * 0.96
                //height: parent.height * 0.9
                height: parent.height * 0.96


                contentWidth: width
                contentHeight: Math.max(layout.implicitHeight, height)

                flickableDirection: Flickable.VerticalFlick


                ColumnLayout {
                    id: layout

                    anchors.fill: parent

                    spacing: 16


                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '类型：'
                        }

                        ComboBox {
                            id: comboType

                            Layout.fillWidth: true

                            model: ['普通攻击', '技能']

                            background: Rectangle {
                                //implicitWidth: comboBoxComponentItem.comboBoxWidth
                                implicitHeight: 35
                                //border.color: control.pressed ? '#6495ED' : '#696969'
                                //border.width: control.visualFocus ? 2 : 1
                                color: 'transparent'
                                //border.color: comboBoxComponentItem.color
                                border.width: 2
                                radius: 6
                            }

                            onActivated: {
                                console.debug('[FightSkillVisualEditor]ComboBox:', comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);

                                _private.changeType();
                            }
                            /*onHighlighted: {
                                console.debug('onHighlighted:', comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);
                            }
                            onAccepted: {
                                console.debug(comboType.currentIndex,
                                              comboType.currentText,
                                              comboType.currentValue);
                            }*/

                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '名字：'
                        }

                        TextField {
                            id: textName

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '名字'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        //Layout.preferredHeight: 30

                        Label {
                            text: '技能描述：'
                        }

                        TextArea {
                            id: textDescription

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '60'
                            placeholderText: '技能描述'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@播放特效'
                        }

                        TextField {
                            id: textSkillEffect

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '60'
                            placeholderText: '@播放特效'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

                                rootWindow.aliasGlobal.list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text = item;

                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*@目标'
                        }

                        TextField {
                            id: textTarget

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '1'
                            placeholderText: '*@目标'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['己方', '对方'],
                                            ['1', '2']];

                                rootWindow.aliasGlobal.list.open({
                                    Data: data[0],
                                    OnClicked: (index, item)=>{
                                        text = data[1][index];

                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*@数量'
                        }

                        TextField {
                            id: textCount

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '*@数量'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['单体', '全体'],
                                            ['1', '-1']];

                                rootWindow.aliasGlobal.list.open({
                                    Data: data[0],
                                    OnClicked: (index, item)=>{
                                        text = data[1][index];

                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                    }

                    RowLayout {
                        id: layoutRequiredMP

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*所需MP：'
                        }

                        TextField {
                            id: textRequiredMP

                            //objectName: 'RequiredMP'

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '0'
                            placeholderText: '*所需MP'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '额外属性:'
                        }

                        TextField {
                            id: textExtraProperties

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '额外属性'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    ColumnLayout {
                        //id: layoutBuff

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        //spacing: 16


                        Button {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '增加Buff效果'

                            onClicked: {
                                let c = compBuff.createObject(layoutBuff);
                                _private.arrCacheComponent.push(c);

                                GlobalLibraryJS.setTimeout(function() {
                                    if(flickable.contentHeight > flickable.height)
                                        flickable.contentY = flickable.contentHeight - flickable.height;
                                    }, 1, root, '');

                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@Buff类型'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@Buff效果'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@持续回合数'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@概率'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                        }

                        ColumnLayout {
                            id: layoutBuff

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            spacing: 16
                        }
                    }


                    ColumnLayout {
                        id: layoutEffectRoot

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        //spacing: 16


                        Button {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '增加技能效果'

                            onClicked: {
                                let c = compEffect.createObject(layoutEffect);
                                _private.arrCacheComponent.push(c);

                                GlobalLibraryJS.setTimeout(function() {
                                    if(flickable.contentHeight > flickable.height)
                                        flickable.contentY = flickable.contentHeight - flickable.height;
                                    }, 1, root, '');

                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@影响属性'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@效果值'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@倍率参考对象'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@倍率参考属性'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                        }

                        ColumnLayout {
                            id: layoutEffect

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            spacing: 16
                        }
                    }

                    /*RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '效果1：'
                        }

                        TextField {
                            id: textEffect1

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '效果1'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                        TextField {
                            id: textEffect1Nums

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '效果1'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '效果2：'
                        }

                        TextField {
                            id: textEffect2

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '效果2'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                        TextField {
                            id: textEffect2Nums

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '效果2'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'power：'
                        }

                        TextField {
                            id: textPower

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: 'Power'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'speed'
                        }

                        TextField {
                            id: textSpeed

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: 'speed'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'luck：'
                        }

                        TextField {
                            id: textLuck

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: 'luck'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*@拥有技能：'
                        }

                        TextField {
                            id: textSkills

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@拥有技能'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

                                rootWindow.aliasGlobal.list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@携带道具（敌）：'
                        }

                        TextField {
                            id: textGoods

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@携带道具（敌）'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;

                                rootWindow.aliasGlobal.list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        rootWindow.aliasGlobal.list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '携带金钱（敌）：'
                        }

                        TextField {
                            id: textMoney

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '携带金钱（敌）'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '携带经验（敌）:'
                        }

                        TextField {
                            id: textEXP

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '携带经验（敌）'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }
                    */
                }
            }
        }


        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Button {
                text: '保存'
                font.pointSize: 9
                onClicked: {
                    _private.saveData();
                }
            }
            Button {
                text: '读取'
                font.pointSize: 9
                onClicked: {
                    _private.loadData();
                }
            }
            Button {
                text: '编译'
                font.pointSize: 9
                onClicked: {
                    let jsScript = _private.compile();
                    if(jsScript === false)
                        return;

                    //let ret = FrameManager.sl_fileWrite(jsScript, _private.filepath + '.js', 0);
                    root.sg_compile(jsScript[1]);

                    console.debug('[FightSkillVisualEditor]compile:', _private.filepath, jsScript);
                }
            }
            Button {
                text: '关闭'
                font.pointSize: 9
                onClicked: {
                    _private.close();
                }
            }

            Button {
                text: '帮助'
                font.pointSize: 9
                onClicked: {
                    rootGameMaker.showMsg('
操作说明：
  1、带 *号 的参数表示是必选，反之可以省略；带 @号 的参数表示可以长按选择；
  2、每次打开可视化编辑界面，会自动载入保存的可视化，也可以手动点击 载入 按钮来重新载入；
  3、编写完成后可以点击 保存 按钮来保存当前脚本；点击 编译 来使用当前脚本（此时上一层界面会自动替换为编译后的脚本）；
功能说明：
  1、技能类型：分为两种，普通攻击和技能，普通攻击不能选择，战斗人物有多个普通攻击（包括道具提供的）时自动选择最后一个；
  2、播放特效：技能使用时播放的特效（会根据单人、全体、己方还是敌方来自动决定位置，可以修改代码来实现其他位置和其他技能）；
  3、目标：是己方还是敌方；
  4、数量：单体、全体，多体还没写；
  5、增加Buff效果：技能释放后产生的buff效果（9种），第2个空为效果，可以提升固定值（整数）或倍率（小数），第3个空为持续回合数，第4个空为概率；
注意：
  1、必须点击 编译 才可以使用；
  2、注意代码格式的符号必须是英文半角，中文或全角会报错；
'
                )}
            }
        }

    }



    //配置
    QtObject {
        id: _config

        property int nLabelFontSize: 10
    }

    QtObject {
        id: _private


        function changeType() {
            switch(comboType.currentIndex) {
            //普通技能
            case 0:
                layoutEffectRoot.visible = false;
                layoutRequiredMP.visible = false;
                break;
            //技能
            case 1:
                layoutEffectRoot.visible = true;
                layoutRequiredMP.visible = true;
                break;
            }
        }


        function saveData() {
            let buffs = [];

            let typeTextFields = FrameManager.sl_findChildren(layoutBuff, 'Type');
            let effectTextFields = FrameManager.sl_findChildren(layoutBuff, 'Effect');
            let roundTextFields = FrameManager.sl_findChildren(layoutBuff, 'Round');
            let probabilityTextFields = FrameManager.sl_findChildren(layoutBuff, 'Probability');

            for(let tt in typeTextFields) {
                buffs.push([typeTextFields[tt].text.trim(), effectTextFields[tt].text.trim(), roundTextFields[tt].text.trim(), probabilityTextFields[tt].text.trim()])
            }


            let effects = [];

            typeTextFields = FrameManager.sl_findChildren(layoutEffect, 'Type');
            //let requiredMPTextFields = FrameManager.sl_findChildren(layoutEffect, 'RequiredMP');
            effectTextFields = FrameManager.sl_findChildren(layoutEffect, 'Effect');
            let combatantTextFields = FrameManager.sl_findChildren(layoutEffect, 'Combatant');
            let propertyTextFields = FrameManager.sl_findChildren(layoutEffect, 'Property');

            for(let tt in typeTextFields) {
                effects.push([typeTextFields[tt].text.trim(), effectTextFields[tt].text.trim(),
                              combatantTextFields[tt].text.trim(), propertyTextFields[tt].text.trim()]);
            }


            let data = {};

            data.SkillType = comboType.currentIndex;
            data.Name = textName.text;
            data.Description = textDescription.text;
            data.Animations = textSkillEffect.text.trim();
            data.Target = textTarget.text.trim();
            data.Count = textCount.text.trim();
            data.RequiredMP = textRequiredMP.text.trim();
            data.Buffs = buffs;
            data.Effects = effects;
            //data.Attack = textAttack.text.trim();

            let ret = FrameManager.sl_fileWrite(JSON.stringify({Version: '0.6', Type: 3, TypeName: 'VisualFightSkill', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_fileRead(filePath);
            console.debug('[FightSkillVisualEditor]filePath：', filePath);
            //console.exception('????')

            if(data) {
                data = JSON.parse(data);
                data = data.Data;
            }
            else {
                data = {SkillType: 0};
            }


            for(let tc of _private.arrCacheComponent) {
                tc.destroy();
            }
            _private.arrCacheComponent = [];

            for(let tt in data.Buffs) {
                let buff = compBuff.createObject(layoutBuff);
                _private.arrCacheComponent.push(buff);

                let typeTextFields = FrameManager.sl_findChild(buff, 'Type');
                let effectTextFields = FrameManager.sl_findChild(buff, 'Effect');
                let roundTextFields = FrameManager.sl_findChild(buff, 'Round');
                let probabilityTextFields = FrameManager.sl_findChild(buff, 'Probability');

                typeTextFields.text = data.Buffs[tt][0];
                effectTextFields.text = data.Buffs[tt][1];
                roundTextFields.text = data.Buffs[tt][2];
                probabilityTextFields.text = data.Buffs[tt][3];

                switch(data.Buffs[tt][0]) {
                case 1:
                case 2:
                case 3:
                    effectTextFields.visible = false;
                    effectTextFields.text = '0';
                break;
                default:
                    //effectTextFields.visible = true;
                }

            }

            for(let tt in data.Effects) {
                let effect = compEffect.createObject(layoutEffect);
                _private.arrCacheComponent.push(effect);

                let typeTextField = FrameManager.sl_findChild(effect, 'Type');
                //let requiredMPTextFields = FrameManager.sl_findChildren(effect, 'RequiredMP');
                let effectTextField = FrameManager.sl_findChild(effect, 'Effect');
                let combatantTextField = FrameManager.sl_findChild(effect, 'Combatant');
                let propertyTextField = FrameManager.sl_findChild(effect, 'Property');

                typeTextField.text = data.Effects[tt][0] || '';
                //requiredMPTextFields.text = data.Effects[tt][1];
                effectTextField.text = data.Effects[tt][1] || '';
                combatantTextField.text = data.Effects[tt][2] || '';
                propertyTextField.text = data.Effects[tt][3] || '';
            }


            comboType.currentIndex = data.SkillType;
            comboType.activated(data.SkillType);

            textName.text = data.Name || '';
            textDescription.text = data.Description || '';
            textSkillEffect.text = data.Animations || '';
            textTarget.text = data.Target || '';
            textCount.text = data.Count || '';
            textRequiredMP.text = data.RequiredMP || '';

        }


        //编译（结果为字符串）
        function compile() {
            let bCheck = true;
            do {
                let typeTextFields = FrameManager.sl_findChildren(layoutBuff, 'Type');
                let effectTextFields = FrameManager.sl_findChildren(layoutBuff, 'Effect');
                let roundTextFields = FrameManager.sl_findChildren(layoutBuff, 'Round');
                let probabilityTextFields = FrameManager.sl_findChildren(layoutBuff, 'Probability');

                //console.debug(actionTextFields);
                for(let tt in typeTextFields) {
                    let typeTextField = typeTextFields[tt];
                    let effectTextField = effectTextFields[tt];
                    let roundTextField = roundTextFields[tt];
                    let probabilityTextField = probabilityTextFields[tt];
                    //console.debug(tt.text.trim());

                    if(!typeTextField.text.trim() || !effectTextField.text.trim() || !roundTextField.text.trim() || !probabilityTextField.text.trim()) {
                        bCheck = false;
                        break;
                    }
                }
                if(!bCheck)
                    break;
                if(!textTarget.text.trim() || !textCount.text.trim()) {
                    bCheck = false;
                    break;
                }
                if(comboType.currentIndex === 1) {
                    if(!textRequiredMP.text.trim()) {
                        bCheck = false;
                        break;
                    }

                    //技能效果
                    let typeTextFields = FrameManager.sl_findChildren(layoutEffect, 'Type');
                    let effectTextFields = FrameManager.sl_findChildren(layoutEffect, 'Effect');
                    let combatantTextFields = FrameManager.sl_findChildren(layoutEffect, 'Combatant');
                    let propertyTextFields = FrameManager.sl_findChildren(layoutEffect, 'Property');

                    for(let tt in typeTextFields) {
                        let typeTextField = typeTextFields[tt];
                        let effectTextField = effectTextFields[tt];
                        let combatantTextField = combatantTextFields[tt];
                        let propertyTextField = propertyTextFields[tt];
                        //console.debug(tt.text.trim());

                        if(!typeTextField.text.trim() || !effectTextField.text.trim() || !combatantTextField.text.trim() || !propertyTextField.text.trim()) {
                            bCheck = false;
                            break;
                        }
                    }
                }
            } while(0);
            if(!bCheck) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '有必填项没有完成',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.close();
                        root.forceActiveFocus();
                    },*/
                });
                return false;
            }



            let type;
            let check;
            let playScript;
            let targetFlag = parseInt(textTarget.text.trim());
            let targetCount = textCount.text.trim();
            let requiredMP = textRequiredMP.text.trim();
            let effects = '';



            //普通攻击 / 技能
            switch(comboType.currentIndex) {
            case 0:
                type = '0';
                check = _private.strTemplate1check;

                //全体
                if(targetCount === '-1') {
                    targetFlag = 2;

                    playScript = strTemplate2playScript;
                }
                //单体
                else {
                    playScript = strTemplate1playScript;
                }
                playScript = GlobalLibraryJS.replaceAll(playScript, '$$skilleffect$$', textSkillEffect.text.trim());

                break;

            case 1:
                type = '1';
                check = _private.strTemplate2check;
                check = GlobalLibraryJS.replaceAll(check, '$$MP$$', requiredMP);

                //全体
                if(targetCount === '-1') {

                    playScript = strTemplate4playScript;
                    if(targetFlag === 1)
                        playScript = GlobalLibraryJS.replaceAll(playScript, '$$targetTeam$$', '0');
                    else if(targetFlag === 2)
                        playScript = GlobalLibraryJS.replaceAll(playScript, '$$targetTeam$$', '1');
                    else
                        playScript = GlobalLibraryJS.replaceAll(playScript, '$$targetTeam$$', '1');
                }
                //单体
                else {
                    playScript = strTemplate3playScript;
                }
                playScript = GlobalLibraryJS.replaceAll(playScript, '$$skilleffect$$', textSkillEffect.text.trim());
                //playScript = playScript.replace(/\$\$property\$\$/g, textSkillEffect.text.trim());
                //playScript = playScript.replace(/\$\$effect\$\$/g, textSkillEffect.text.trim());


                //技能效果
                let typeTextFields = FrameManager.sl_findChildren(layoutEffect, 'Type');
                //let requiredMPTextFields = FrameManager.sl_findChildren(layoutEffect, 'RequiredMP');
                let effectTextFields = FrameManager.sl_findChildren(layoutEffect, 'Effect');
                let combatantTextFields = FrameManager.sl_findChildren(layoutEffect, 'Combatant');
                let propertyTextFields = FrameManager.sl_findChildren(layoutEffect, 'Property');

                let props = '';
                for(let tt in typeTextFields) {
                    let teffectproperty = typeTextFields[tt].text.trim().split(',');
                    if(teffectproperty.length === 1)
                        teffectproperty = teffectproperty[0].trim();
                    else
                        teffectproperty = teffectproperty[0].trim() + '[' + teffectproperty[1].trim() + ']';

                    let tvalue = effectTextFields[tt].text.trim();
                    let tcombatant = combatantTextFields[tt].text.trim();

                    //倍率
                    if(tvalue.indexOf('.') >= 0) {

                        let treferenceproperty = propertyTextFields[tt].text.trim().split(',');
                        if(treferenceproperty.length === 1)
                            treferenceproperty = treferenceproperty[0].trim();
                        else
                            treferenceproperty = treferenceproperty[0].trim() + '[' + treferenceproperty[1].trim() + ']';

                        //let tvalue = (tarr[1] === '0' ? `[${tvalue}]` : `[${tarr[1]}, ${tvalue}]`);
                        props += '\r\n';
                        if(tcombatant === '0')
                            props += `effect = combatant.${treferenceproperty} * ${tvalue};\r\n`;
                        else
                            props += `effect = targetCombatant.${treferenceproperty} * ${tvalue};\r\n`;
                        props += `targetCombatant.$properties.${teffectproperty} += effect;\r\n`;
                        //props += `game.addprops(targetCombatant, {'${tarr[0]}': ${tvalue}}, 2);`;
                        props += `yield ({Type: 30, Interval: 300, Color: 'red', Text: effect, FontSize: 20, Combatant: targetCombatant, Position: undefined});\r\n`;
                        props += `yield ({Type: 1});\r\n`;
                        props += '\r\n';
                    }
                    else {
                        //let tvalue = (tarr[1] === '0' ? `[${tvalue}]` : `[${tarr[1]}, ${tvalue}]`);
                        //props += `game.addprops(targetCombatant, {'${teffectproperty}': ${tvalue}});`;
                        props += `targetCombatant.$properties.${teffectproperty} += ${tvalue};\r\n`;
                        props += `yield ({Type: 30, Interval: 300, Color: 'red', Text: '${tvalue}', FontSize: 20, Combatant: targetCombatant, Position: undefined});`;
                        props += `yield ({Type: 1});`;
                        props += '\r\n';
                    }
                }
                playScript = GlobalLibraryJS.replaceAll(playScript, '$$addprops$$', props);


                break;
            }


            //目标
            switch(targetFlag) {
            //己方
            case 1:
                break;
            //对方
            case 2:
                break;
            }



            //buffs效果
            let buffs = '';


            let typeTextFields = FrameManager.sl_findChildren(layoutBuff, 'Type');
            let effectTextFields = FrameManager.sl_findChildren(layoutBuff, 'Effect');
            let roundTextFields = FrameManager.sl_findChildren(layoutBuff, 'Round');
            let probabilityTextFields = FrameManager.sl_findChildren(layoutBuff, 'Probability');

            for(let tt in typeTextFields) {
                let tRound = roundTextFields[tt].text.trim().split(',');
                tRound[0] = tRound[0].trim();
                if(tRound[0] === '')
                    tRound[0] = 1;
                if(tRound[1] === undefined)
                    tRound[1] = parseInt(tRound[0]) + 1;
                else
                    tRound[1] = tRound[1].trim();

                buffs += `if(Math.random() < ${probabilityTextFields[tt].text.trim()}) {\r\n`;

                let tvalue = effectTextFields[tt].text.trim();

                switch(parseInt(typeTextFields[tt].text)) {
                case 0:
                    let ttype = (tvalue.indexOf('.') >= 0 ? '2' : '1');
                    buffs += `game.$userscripts.getBuff(targetCombatant, 1, {BuffName: '毒', Round: game.rnd(${tRound[0]}, ${tRound[1]}), HarmType: ${ttype}, HarmValue: ${tvalue}});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'green', Text: '毒', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 1:
                    buffs += `game.$userscripts.getBuff(targetCombatant, 2, {BuffName: '乱', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'orange', Text: '乱', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 2:
                    buffs += `game.$userscripts.getBuff(targetCombatant, 3, {BuffName: '封', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'yellow', Text: '封', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 3:
                    buffs += `game.$userscripts.getBuff(targetCombatant, 4, {BuffName: '眠', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'blue', Text: '眠', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                default:
                    ttype = (tvalue.indexOf('.') >= 0 ? '2' : '1');
                    switch(parseInt(typeTextFields[tt].text)) {
                    case 4:
                        buffs += `game.$userscripts.getBuff(targetCombatant, 5, {BuffName: '攻', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['attack', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '攻', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 5:
                        buffs += `game.$userscripts.getBuff(targetCombatant, 5, {BuffName: '防', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['defense', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '防', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 6:
                        buffs += `game.$userscripts.getBuff(targetCombatant, 5, {BuffName: '速', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['speed', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '速', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 7:
                        buffs += `game.$userscripts.getBuff(targetCombatant, 5, {BuffName: '灵', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['power', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '灵', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 8:
                        buffs += `game.$userscripts.getBuff(targetCombatant, 5, {BuffName: '幸', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['luck', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '幸', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    }
                }

                buffs += '}\r\n';
            }

            //全体
            if(targetCount === '-1') {
                buffs = GlobalLibraryJS.replaceAll(strTemplate4Buffs, '$$buffs$$', buffs);
            }
            //单体
            else {

            }



            let data = strTemplate;
            data = GlobalLibraryJS.replaceAll(data, '$$name$$', textName.text);
            data = GlobalLibraryJS.replaceAll(data, '$$description$$', GlobalLibraryJS.convertToHTML(textDescription.text));
            data = GlobalLibraryJS.replaceAll(data, '$$type$$', type);
            data = GlobalLibraryJS.replaceAll(data, '$$targetFlag$$', targetFlag);
            data = GlobalLibraryJS.replaceAll(data, '$$targetCount$$', targetCount);
            data = GlobalLibraryJS.replaceAll(data, '$$ExtraProperties$$', textExtraProperties.text.trim() || 'undefined');
            data = GlobalLibraryJS.replaceAll(data, '$$playScript$$', playScript);
            data = GlobalLibraryJS.replaceAll(data, '$$buffs$$', buffs);
            /*data = GlobalLibraryJS.replaceAll(data, '$$check$$', textLuck.text.trim());
            data = GlobalLibraryJS.replaceAll(data, '$$speed$$', textSpeed.text.trim());
            data = GlobalLibraryJS.replaceAll(data, '$$EXP$$', textEXP.text.trim());
            data = GlobalLibraryJS.replaceAll(data, '$$skills$$', GlobalLibraryJS.array2string(textSkills.text.trim().split(',')));
            data = GlobalLibraryJS.replaceAll(data, '$$goods$$', GlobalLibraryJS.array2string(textGoods.text.trim().split(',')));
            */
            data = GlobalLibraryJS.replaceAll(data, '$$check$$', check);

            console.debug(data);



            try {
                eval(data);
            }
            catch(e) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '错误：' + e.toString() + '<BR>请检查各参数',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.close();
                        root.forceActiveFocus();
                    },*/
                });
                return [false, data];
            }

            return [true, data];
        }

        function close() {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '退出前需要编译和保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    let jsScript = _private.compile();
                    if(jsScript === false)
                        return;

                    //let ret = FrameManager.sl_fileWrite(jsScript, _private.filepath + '.js', 0);
                    root.sg_compile(jsScript[1]);

                    saveData();

                    if(jsScript[0])
                        sg_close();

                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    rootWindow.aliasGlobal.dialogCommon.close();
                    root.forceActiveFocus();
                },
            });
        }



        //创建的组件缓存
        property var arrCacheComponent: []

        //保存文件路径
        property string filepath

        property string strTemplate: `

//闭包写法
let data = (function() {



    //独立属性，用 skill 来引用；会保存到存档中；
    let $createData = function (params) {
        return {
            /*
            $name: '$$name$$',
            $description: '$$description$$',

            //0：普通攻击；1：技能
            $type: $$type$$,

            //如果$choiceScript为null，则根据这两项来选择系统的技能选择机制，反之这两个参数无效
            //0b10为选对方；0b1为选己方；
            $targetFlag: $$targetFlag$$,
            //选择目标数；-1为全体；>0为个数；数组为范围；
            $targetCount: $$targetCount$$,

            $$ExtraProperties$$,
            */
        };
    };


    //公用属性，用 skill.$commons 或 skill 来引用；
    let $commons = {

        $name: '$$name$$',
        $description: '$$description$$',

        //0：普通攻击；1：技能
        $type: $$type$$,

        //如果$choiceScript为null，则根据这两项来选择系统的技能选择机制，反之这两个参数无效
        //0b10为选对方；0b1为选己方；
        $targetFlag: $$targetFlag$$,
        //选择目标数；-1为全体；>0为个数；数组为范围；
        $targetCount: $$targetCount$$,

        $$ExtraProperties$$,


        //选择道具时脚本；如果为null则根据 $targetFlag 和 $targetCount 自动调用 系统定义 的
        /*$choiceScript: function *(skill, combatant) {
            //选择敌方
            //let r = yield* fight.$sys.gfChoiceSingleCombatantSkill(goods, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
            //return r;
        },
        */
        $choiceScript: null,

        //技能产生的效果 和 动画
        $playScript: function *(skill, combatant) {

$$playScript$$

$$buffs$$

            //Normal 动作特效，无限循环动画、500ms结束、原位置
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Run: 0});
            //yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500});

            //技能结束，必须返回null
            return null;
        },


        //检查技能（有4个阶段会调用：见stage）；
        //返回：true表示可以使用；字符串和数组表示不能使用并提示的信息（只有选择时）；
        //stage为0表示我方刚选择技能时，为1表示我方选择技能的步骤完毕，为10表示战斗中我方或敌方刚选择技能时，为11表示战斗中我方或敌方选择技能的步骤完毕（在阶段11减去MP的作用：道具的技能可以跳过减MP）；
        $check: function(skill, combatant, stage) {
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            //let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];
            //使用类型：技能或道具
            let choiceType = combatant.$$fightData.$choice.$type;

$$check$$
        },
    };



    return {$createData, $commons};

})();

`
        //不用检查
        property string strTemplate1check: `
            return true;
`

        //检查MP
        property string strTemplate2check: `
            if(combatant.$properties.MP[0] < $$MP$$)
                return '技能点不足';

            //阶段11时减去MP，道具跳过
            if(stage === 11 && choiceType !== 2)
                game.addprops(combatant, {'MP': [-$$MP$$]});

            return true;
`

        //普通攻击单体
        property string strTemplate1playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];

            //返回战斗算法结果
            let SkillEffectResult;
            let effect;


            //Normal 动作特效，无限循环动画、500ms结束、对方面前
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Combatant: combatant, Target: targetCombatant, Run: 1});


            //kill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant});
            //kill 特效，1次，等待播放结束，特效ID，对方和位置
            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 0, ID: '$$skilleffect$$', Combatant: targetCombatant, Position: 1});
            //效果，Skill：KillType：
            SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {Skill: 1}});
            effect = SkillEffectResult.shift().HP;
            game.addprops(targetCombatant, {'HP': [-effect[0], -effect[1]]});
            //刷新人物信息
            yield ({Type: 1});
            //显示文字，同步播放、红色、内容、大小、对方和位置
            yield ({Type: 30, Interval: 0, Color: 'red', Text: -effect[0], FontSize: 20, Combatant: targetCombatant, Position: undefined});

`

        //普通攻击全体
        property string strTemplate2playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            //let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];
            let targetCombatants = combatant.$$fightData.$info.$teams[1];

            //返回战斗算法结果
            let SkillEffectResult;
            let effect;


            let killCount = game.rnd(1,3);


            //Normal 动作特效，无限循环动画、500ms结束、对方面前
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Target: 1, Run: 2});
            //kill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1});


            //每个被攻击显示 kill 特效
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$propertiesWithExtra.HP[0] <= 0)
                    continue;

                //kill 特效，1次，同步播放，对方位置，特效ID
                yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 0, ID: '$$skilleffect$$'+ti, Combatant: targetCombatant, Position: 1});
            }
            //每个被攻击计算并显示伤害
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$propertiesWithExtra.HP[0] <= 0)
                    continue;
                //Params：传递给通用算法的参数
                SkillEffectResult = yield ({Type: 3, Target: targetCombatant, Params: {Skill: 1}});
                effect = SkillEffectResult.shift().HP;
                game.addprops(targetCombatant, {'HP': [-effect[0], -effect[1]]});
                yield ({Type: 1});
                //显示文字，同步播放、对方位置、红色、内容、大小
                yield ({Type: 30, Interval: 0, Color: 'red', Text: -effect[0], FontSize: 20, Combatant: targetCombatant, Position: undefined});
            }

`

        //技能单体
        property string strTemplate3playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];

            //这里是计算方法
            let SkillEffectResult;
            let effect;


            //Skill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Skill', Loops: 1, Interval: -1});

            //kill 特效，1次，等待播放结束，对方位置，特效ID
            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: -1, ID: '$$skilleffect$$', Combatant: targetCombatant, Position: 1});
            //game.addprops(targetCombatant, {'$$property$$': $$effect$$});
$$addprops$$

`
        //技能全体
        property string strTemplate4playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$fightData.$choice.$attack;
            //目标战斗人物
            //let targetCombatant = combatant.$$fightData.$choice.$targets[0][0];
            let targetCombatants = combatant.$$fightData.$info.$teams[$$targetTeam$$];

            //这里是计算方法
            let SkillEffectResult;
            let effect;


            //Skill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Skill', Loops: 1, Interval: -1});

            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: -1, ID: '$$skilleffect$$', Position: 2, Target: 1});

            //每个被攻击计算并显示伤害
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$propertiesWithExtra.HP[0] <= 0)
                    continue;
                //kill 特效，1次，等待播放结束，对方位置，特效ID
                //yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 100, ID: '$$skilleffect$$'+ti, Combatant: targetCombatant, Position: 1});
$$addprops$$
            }

`

        //技能全体Buffs
        property string strTemplate4Buffs: `
            //每个被攻击Buffs
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$propertiesWithExtra.HP[0] <= 0)
                    continue;
$$buffs$$
            }

`
    }



    Keys.onEscapePressed: function(event) {
        _private.close();

        console.debug('[FightSkillVisualEditor]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: function(event) {
        _private.close();

        console.debug('[FightSkillVisualEditor]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: function(event) {
        console.debug('[FightSkillVisualEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: function(event) {
        console.debug('[FightSkillVisualEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[FightSkillVisualEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[FightSkillVisualEditor]Component.onDestruction');
    }
}
