﻿import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14


import _Global 1.0
import _Global.Button 1.0

import "qrc:/QML"



Rectangle {
    id: root


    signal s_Compile(string code);
    signal s_close();
    onS_close: {
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
                    text: '*@Buff类型'
                }

                /*ComboBox {
                    id: tcomboType

                    objectName: 'type'

                    Layout.fillWidth: true

                    model: ['毒','乱','封','眠','攻','防','速','灵','幸']

                    background: Rectangle {
                        //implicitWidth: comboBoxComponentItem.comboBoxWidth
                        implicitHeight: 35
                        //border.color: control.pressed ? "#6495ED" : "#696969"
                        //border.width: control.visualFocus ? 2 : 1
                        color: "transparent"
                        //border.color: comboBoxComponentItem.color
                        border.width: 2
                        radius: 6
                    }
                    onActivated: {
                        console.debug('activated:', comboType.currentIndex,
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

                    objectName: 'type'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@Buff类型'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[选择Buff类型]', '毒','乱','封','眠','攻','防','速','灵','幸'],
                                    ['', 0,1,2,3,4,5,6,7,8]];

                        l_list.open({
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

                TextField {
                    id: ttextEffect

                    objectName: 'effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0'
                    placeholderText: '*@效果'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[Buff效果]', '固定值：20','倍率：2.0'],
                                    ['', '20','2.0']];

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                TextField {
                    id: ttextRound

                    objectName: 'round'

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

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                TextField {
                    id: ttextProbability

                    objectName: 'probability'

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

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                ColorButton {
                    id: tbutton
                    text: 'x'
                    onButtonClicked: {
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
                    text: '*效果'
                }

                TextField {
                    id: ttextType

                    objectName: 'type'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@类型'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[影响属性]', '一段HP','二段HP','一段MP'],
                                    ['', 'HP, 0','HP, 1','MP, 0']];

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                TextField {
                    id: ttextEffect

                    objectName: 'effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: '0'
                    placeholderText: '*效果'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[效果]', '固定值：20','倍率：2.0'],
                                    ['', '20','2.0']];

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                TextField {
                    id: ttextCombatant

                    objectName: 'combatant'

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

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                TextField {
                    id: ttextproperty

                    objectName: 'property'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@倍率参考属性'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['[倍率参考属性]', '一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力'],
                                    ['', 'HP,0','HP,1','HP,2','MP,0','MP,1','attack','defense','speed','luck','power']];

                        l_list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

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

                ColorButton {
                    id: tbutton
                    text: 'x'
                    onButtonClicked: {
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



    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true;
        }
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
                                //border.color: control.pressed ? "#6495ED" : "#696969"
                                //border.width: control.visualFocus ? 2 : 1
                                color: "transparent"
                                //border.color: comboBoxComponentItem.color
                                border.width: 2
                                radius: 6
                            }

                            onActivated: {
                                console.debug('activated:', comboType.currentIndex,
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
                        Layout.preferredHeight: 30

                        Label {
                            text: '技能描述：'
                        }

                        TextField {
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
                            text: '*@播放特效'
                        }

                        TextField {
                            id: textSkillEffects

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '60'
                            placeholderText: '*@播放特效'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

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

                                l_list.open({
                                    Data: data[0],
                                    OnClicked: (index, item)=>{
                                        text = data[1][index];

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

                                l_list.open({
                                    Data: data[0],
                                    OnClicked: (index, item)=>{
                                        text = data[1][index];

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

                            //objectName: 'requiredMP'

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '0'
                            placeholderText: '*所需MP'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                        }
                    }

                    ColumnLayout {
                        id: layoutBuff

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                        RowLayout {

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30

                            ColorButton {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                text: '增加Buff效果'

                                onButtonClicked: {
                                    let c = compBuff.createObject(layoutBuff);
                                    _private.arrCacheComponent.push(c);
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        id: layoutEffect

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                        RowLayout {

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30

                            ColorButton {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                text: '增加技能效果'

                                onButtonClicked: {
                                    let c = compEffect.createObject(layoutEffect);
                                    _private.arrCacheComponent.push(c);
                                }
                            }
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

                                l_list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

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

                                l_list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

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

            ColorButton {
                text: "保存"
                font.pointSize: 9
                onButtonClicked: {
                    _private.saveData();
                }
            }
            ColorButton {
                text: "读取"
                font.pointSize: 9
                onButtonClicked: {
                    _private.loadData();
                }
            }
            ColorButton {
                text: "编译"
                font.pointSize: 9
                onButtonClicked: {
                    let jsScript = _private.compile();
                    //let ret = FrameManager.sl_qml_WriteFile(jsScript, _private.filepath + '.js', 0);
                    root.s_Compile(jsScript);

                    console.debug(_private.filepath + '.js', jsScript);
                }
            }
            ColorButton {
                text: "关闭"
                font.pointSize: 9
                onButtonClicked: {
                    _private.close();
                }
            }

            ColorButton {
                text: "帮助"
                font.pointSize: 9
                onButtonClicked: {
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



    QtObject {
        id: _private


        function changeType() {
            switch(comboType.currentIndex) {
            //普通技能
            case 0:
                layoutEffect.visible = false;
                layoutRequiredMP.visible = false;
                break;
            //技能
            case 1:
                layoutEffect.visible = true;
                layoutRequiredMP.visible = true;
                break;
            }
        }


        function saveData() {
            let buffs = [];

            let typeTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'type');
            let effectTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'effect');
            let roundTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'round');
            let probabilityTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'probability');

            for(let tt in typeTextFields) {
                buffs.push([typeTextFields[tt].text.trim(), effectTextFields[tt].text.trim(), roundTextFields[tt].text.trim(), probabilityTextFields[tt].text.trim()])
            }


            let effects = [];

            typeTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'type');
            //let requiredMPTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'requiredMP');
            effectTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'effect');
            let combatantTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'combatant');
            let propertyTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'property');

            for(let tt in typeTextFields) {
                effects.push([typeTextFields[tt].text.trim(), effectTextFields[tt].text.trim(),
                              combatantTextFields[tt].text.trim(), propertyTextFields[tt].text.trim()]);
            }


            let data = {};

            data.SkillType = comboType.currentIndex;
            data.Name = textName.text.trim();
            data.Description = textDescription.text.trim();
            data.Animations = textSkillEffects.text.trim();
            data.Target = textTarget.text.trim();
            data.Count = textCount.text.trim();
            data.RequiredMP = textRequiredMP.text.trim();
            data.Buffs = buffs;
            data.Effects = effects;
            //data.Attack = textAttack.text.trim();

            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify({Version: '0.6', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(filePath);
            console.debug("[GameVisualFightSkill]filePath：", filePath);
            //console.exception("????")

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

                let typeTextFields = FrameManager.sl_qml_FindChild(buff, 'type');
                let effectTextFields = FrameManager.sl_qml_FindChild(buff, 'effect');
                let roundTextFields = FrameManager.sl_qml_FindChild(buff, 'round');
                let probabilityTextFields = FrameManager.sl_qml_FindChild(buff, 'probability');

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

                let typeTextField = FrameManager.sl_qml_FindChild(effect, 'type');
                //let requiredMPTextFields = FrameManager.sl_qml_FindChildren(effect, 'requiredMP');
                let effectTextField = FrameManager.sl_qml_FindChild(effect, 'effect');
                let combatantTextField = FrameManager.sl_qml_FindChild(effect, 'combatant');
                let propertyTextField = FrameManager.sl_qml_FindChild(effect, 'property');

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
            textSkillEffects.text = data.Animations || '';
            textTarget.text = data.Target || '';
            textCount.text = data.Count || '';
            textRequiredMP.text = data.RequiredMP || '';

        }


        //编译（结果为字符串）
        function compile() {
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
                playScript = playScript.replace(/\$\$skilleffect\$\$/g, textSkillEffects.text.trim());

                break;

            case 1:
                type = '1';
                check = _private.strTemplate2check;
                check = check.replace(/\$\$MP\$\$/g, requiredMP);

                //全体
                if(targetCount === '-1') {

                    playScript = strTemplate4playScript;
                    if(targetFlag === 1)
                        playScript = playScript.replace(/\$\$target\$\$/g, '0');
                    else if(targetFlag === 2)
                        playScript = playScript.replace(/\$\$target\$\$/g, '1');
                    else
                        playScript = playScript.replace(/\$\$target\$\$/g, '1');
                }
                //单体
                else {
                    playScript = strTemplate3playScript;
                }
                playScript = playScript.replace(/\$\$skilleffect\$\$/g, textSkillEffects.text.trim());
                playScript = playScript.replace(/\$\$property\$\$/g, textSkillEffects.text.trim());
                playScript = playScript.replace(/\$\$effect\$\$/g, textSkillEffects.text.trim());


                //技能效果
                let typeTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'type');
                //let requiredMPTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'requiredMP');
                let effectTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'effect');
                let combatantTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'combatant');
                let propertyTextFields = FrameManager.sl_qml_FindChildren(layoutEffect, 'property');

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
                            props += `effect = combatant.$$properties.${treferenceproperty} * ${tvalue};\r\n`;
                        else
                            props += `effect = targetCombatant.$$properties.${treferenceproperty} * ${tvalue};\r\n`;
                        props += `targetCombatant.$$properties.${teffectproperty} += effect;\r\n`;
                        //props += `game.addprops(targetCombatant, {'${tarr[0]}': ${tvalue}}, 2);`;
                        props += `yield ({Type: 30, Interval: 0, Color: 'red', Text: effect, FontSize: 20, Combatant: targetCombatant, Position: undefined});\r\n`;
                        props += `yield ({Type: 1});\r\n`;
                        props += '\r\n';
                    }
                    else {
                        //let tvalue = (tarr[1] === '0' ? `[${tvalue}]` : `[${tarr[1]}, ${tvalue}]`);
                        //props += `game.addprops(targetCombatant, {'${teffectproperty}': ${tvalue}});`;
                        props += `targetCombatant.$$properties.${teffectproperty} += ${tvalue};\r\n`;
                        props += `yield ({Type: 30, Interval: 0, Color: 'red', Text: '${tvalue}', FontSize: 20, Combatant: targetCombatant, Position: undefined});`;
                        props += `yield ({Type: 1});`;
                        props += '\r\n';
                    }
                }
                playScript = playScript.replace(/\$\$addprops\$\$/g, props);


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


            let typeTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'type');
            let effectTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'effect');
            let roundTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'round');
            let probabilityTextFields = FrameManager.sl_qml_FindChildren(layoutBuff, 'probability');

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
                    buffs += `game.$$userscripts.getBuff(targetCombatant, 1, {BuffName: '毒', Round: game.rnd(${tRound[0]}, ${tRound[1]}), HarmType: ${ttype}, HarmValue: ${tvalue}});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'green', Text: '毒', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 1:
                    buffs += `game.$$userscripts.getBuff(targetCombatant, 2, {BuffName: '乱', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'orange', Text: '乱', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 2:
                    buffs += `game.$$userscripts.getBuff(targetCombatant, 3, {BuffName: '封', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'yellow', Text: '封', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                case 3:
                    buffs += `game.$$userscripts.getBuff(targetCombatant, 4, {BuffName: '眠', Round: game.rnd(${tRound[0]}, ${tRound[1]})});`;
                    buffs += '\r\n';
                    buffs += `yield ({Type: 30, Interval: 500, Color: 'blue', Text: '眠', FontSize: 20, Combatant: targetCombatant});`;
                    buffs += '\r\n';
                    break;
                default:
                    ttype = (tvalue.indexOf('.') >= 0 ? '2' : '1');
                    switch(parseInt(typeTextFields[tt].text)) {
                    case 4:
                        buffs += `game.$$userscripts.getBuff(targetCombatant, 5, {BuffName: '攻', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['attack', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '攻', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 5:
                        buffs += `game.$$userscripts.getBuff(targetCombatant, 5, {BuffName: '防', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['defense', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '防', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 6:
                        buffs += `game.$$userscripts.getBuff(targetCombatant, 5, {BuffName: '速', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['speed', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '速', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 7:
                        buffs += `game.$$userscripts.getBuff(targetCombatant, 5, {BuffName: '灵', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['power', ${tvalue}, ${ttype}]]});`;
                        buffs += '\r\n';
                        buffs += `yield ({Type: 30, Interval: 500, Color: 'white', Text: '灵', FontSize: 20, Combatant: targetCombatant});`;
                        buffs += '\r\n';
                        break;
                    case 8:
                        buffs += `game.$$userscripts.getBuff(targetCombatant, 5, {BuffName: '幸', Round: game.rnd(${tRound[0]}, ${tRound[1]}), Properties: [['luck', ${tvalue}, ${ttype}]]});`;
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
                buffs = strTemplate4Buffs.replace(/\$\$buffs\$\$/g, buffs);
            }
            //单体
            else {

            }



            let data = strTemplate.
                replace(/\$\$name\$\$/g, textName.text.trim()).
                replace(/\$\$description\$\$/g, textDescription.text.trim()).
                replace(/\$\$type\$\$/g, type).
                replace(/\$\$targetFlag\$\$/g, targetFlag).
                replace(/\$\$targetCount\$\$/g, targetCount).
                replace(/\$\$playScript\$\$/g, playScript).
                replace(/\$\$buffs\$\$/g, buffs).
                /*replace(/\$\$check\$\$/g, textLuck.text.trim()).
                replace(/\$\$speed\$\$/g, textSpeed.text.trim()).
                replace(/\$\$EXP\$\$/g, textEXP.text.trim()).
                replace(/\$\$skills\$\$/g, GlobalLibraryJS.array2string(textSkills.text.trim().split(','))).
                replace(/\$\$goods\$\$/g, GlobalLibraryJS.array2string(textGoods.text.trim().split(','))).
                */
                replace(/\$\$check\$\$/g, check)
            ;

            console.debug(data);

            return data;
        }

        function close() {
            dialogCommon.show({
                Msg: '退出前需要编译和保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function(){
                    let jsScript = _private.compile();
                    //let ret = FrameManager.sl_qml_WriteFile(jsScript, _private.filepath + '.js', 0);
                    root.s_Compile(jsScript);

                    saveData();

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



        //创建的组件缓存
        property var arrCacheComponent: []

        //保存文件路径
        property string filepath

        property string strTemplate: `

//闭包写法
let data = (function() {



    //独立属性，用 skill 来引用；会保存到存档中；
    let $createData = function(params) {
        return {
            /*
            $name: '$$name$$',
            $description: '$$description$$',

            //0：普通攻击；1：技能
            $type: $$type$$,
            //0b10为选对方；0b1为选己方；
            $targetFlag: $$targetFlag$$,
            //选择目标数；-1为全体；>0为个数；数组为范围；
            $targetCount: $$targetCount$$,
            */
        };
    };


    //公用属性，用 skill.$commons 或 skill 来引用；
    let $commons = {

        $name: '$$name$$',
        $description: '$$description$$',

        //0：普通攻击；1：技能
        $type: $$type$$,
        //0b10为选对方；0b1为选己方；
        $targetFlag: $$targetFlag$$,
        //选择目标数；-1为全体；>0为个数；数组为范围；
        $targetCount: $$targetCount$$,


        //选择技能时脚本
        $choiceScript: function *(skill, combatant) {
            return;
        },

        //技能产生的效果 和 动画
        $playScript: function*(skill, combatant) {

$$playScript$$

$$buffs$$

            //Normal 动作特效，无限循环动画、500ms结束、原位置
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Run: 0});
            //yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500});

            //技能结束，必须返回null
            return null;
        },


        //检查技能（有4个阶段会调用：选择时、攻击时、敌人和我方遍历时）；
        //返回：true表示可以使用；字符串表示不能使用并提示的信息（只有选择时）；
        //stage为0表示选择时，为1表示选择某战斗角色（我方或敌方，此时targetCombatant不为null，其他情况为null），为10表示战斗中（在阶段10减去MP的作用：道具的技能可以跳过减MP）；
        $check: function(skill, combatant, targetCombatant, stage) {
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
            if(combatant.$$properties.MP[0] < $$MP$$)
                return '技能点不足';

            //阶段10时减去MP
            if(stage === 10)
                game.addprops(combatant, {'MP': [-$$MP$$]});

            return true;
`

        //普通攻击单体
        property string strTemplate1playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$$$fightData.$attackSkill;
            //目标战斗人物
            let targetCombatant = combatant.$$$$fightData.$$target[0];

            //返回战斗算法结果
            let SkillEffectResult;
            let effect;


            //Normal 动作特效，无限循环动画、500ms结束、对方面前
            yield ({Type: 10, Name: 'Normal', Loops: -1, Interval: 500, Combatant: combatant, Target: targetCombatant, Run: 1});


            //kill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Kill', Loops: 1, Interval: -1, Combatant: combatant});
            //kill 特效，1次，等待播放结束，特效ID，对方和位置
            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 0, RId: '$$skilleffect$$', Combatant: targetCombatant, Position: 1});
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
            //let skill = combatant.$$$$fightData.$$attackSkill;
            //目标战斗人物
            //let targetCombatant = combatant.$$$$fightData.$$target[0];
            let targetCombatants = combatant.$$$$fightData.$$info.$$team[1];

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
                if(targetCombatant.$$properties.HP[0] <= 0)
                    continue;

                //kill 特效，1次，同步播放，对方位置，特效ID
                yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 0, RId: '$$skilleffect$$'+ti, Combatant: targetCombatant, Position: 1});
            }
            //每个被攻击计算并显示伤害
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$properties.HP[0] <= 0)
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
            //let skill = combatant.$$$$fightData.$$attackSkill;
            //目标战斗人物
            let targetCombatant = combatant.$$$$fightData.$$target[0];

            //这里是计算方法
            let SkillEffectResult;
            let effect;


            //Skill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Skill', Loops: 1, Interval: -1});

            //kill 特效，1次，等待播放结束，对方位置，特效ID
            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: -1, RId: '$$skilleffect$$', Combatant: targetCombatant, Position: 1});
            //game.addprops(targetCombatant, {'$$property$$': $$effect$$});
$$addprops$$

`
        //技能全体
        property string strTemplate4playScript: `
            //使用的技能对象（可以用技能的数据）
            //let skill = combatant.$$$$fightData.$$attackSkill;
            //目标战斗人物
            //let targetCombatant = combatant.$$$$fightData.$$target[0];
            let targetCombatants = combatant.$$$$fightData.$$info.$$team[$$target$$];

            //这里是计算方法
            let SkillEffectResult;
            let effect;


            //Skill 动作特效，1次，等待播放结束
            yield ({Type: 10, Name: 'Skill', Loops: 1, Interval: -1});

            yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: -1, RId: '$$skilleffect$$', Position: 2, Target: 1});

            //每个被攻击计算并显示伤害
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$properties.HP[0] <= 0)
                    continue;
                //kill 特效，1次，等待播放结束，对方位置，特效ID
                //yield ({Type: 20, Name: '$$skilleffect$$', Loops: 1, Interval: 100, RId: '$$skilleffect$$'+ti, Combatant: targetCombatant, Position: 1});
$$addprops$$
            }

`

        //技能全体Buffs
        property string strTemplate4Buffs: `
            //每个被攻击Buffs
            for(let ti in targetCombatants) {
                let targetCombatant = targetCombatants[ti];
                if(targetCombatant.$$properties.HP[0] <= 0)
                    continue;
$$buffs$$
            }

`
    }



    Keys.onEscapePressed: {
        _private.close();

        console.debug("[GameVisualScript]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug("[GameVisualScript]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[GameVisualScript]Keys.onPressed:", event.key);
    }
    Keys.onReleased: {
        console.debug("[GameVisualScript]Keys.onReleased:", event.key);
    }


    Component.onCompleted: {
    }

    Component.onDestruction: {
    }

}

