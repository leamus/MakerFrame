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
        id: comp

        Item {
            id: tRoot

            //property alias label: tlable.text


            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            RowLayout {
                anchors.fill: parent

                TextField {
                    id: ttextproperty

                    objectName: 'property'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@属性'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['一段血','二段血','三段血','一段MP','二段MP','攻击','防御','速度','幸运','灵力'],
                                    ['HP,0','HP,1','HP,2','MP,0','MP,1','attack','defense','speed','luck','power']];

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
                    id: ttextParams

                    objectName: 'effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*效果值'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['固定值：20','倍率：2.0'],
                                    ['20','2.0']];

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
                            if(_private.arrCacheComponent[tc] === tRoot) {
                                _private.arrCacheComponent.splice(tc, 1);
                                break;
                            }

                        }
                        tRoot.destroy();
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


                            model: ['装备', '使用', /*'战斗食用', '投掷',*/]

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
                            text: '描述：'
                        }

                        TextField {
                            id: textDescription

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '描述'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '价格：'
                        }

                        TextField {
                            id: textPrice

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '0'
                            placeholderText: '价格'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    /*
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '类型：'
                        }

                        TextField {
                            id: textType

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '4'
                            placeholderText: '类型'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }
                    */

                    /*RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@是否可叠加'
                        }

                        TextField {
                            id: textStackable

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: 'true'
                            placeholderText: '@是否可叠加'
                            readOnly: true

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }
                    */

                    /*RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@战斗使用/投掷技能：'
                        }

                        TextField {
                            id: textFight

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@战斗使用/投掷技能'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

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
                    }*/

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@文字颜色：'
                        }

                        TextField {
                            id: textColor

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: 'white'
                            placeholderText: '@文字颜色'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['白', '红', '绿', '蓝', '黑', '灰', '黄'], ['white', 'red', 'green', 'blue', 'black', 'gray', 'yellow']]
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
                            text: '@图像：'
                        }

                        TextField {
                            id: textImage

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@图像'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                l_list.open({
                                    Data: GameMakerGlobal.imageResourceURL(),
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
                            text: '图像大小：'
                        }

                        TextField {
                            id: textImageWidth

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '50'
                            placeholderText: '宽'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                        TextField {
                            id: textImageHeight

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '50'
                            placeholderText: '高'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        id: layoutFightSkill

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@战斗技能：'
                        }

                        TextField {
                            id: textFightSkill

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '*@战斗技能'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

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
                        id: layoutUseScript

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@使用函数：'
                        }

                        TextField {
                            id: textUseScript

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@使用函数'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['无', '函数', '全局函数'], ['', 'function*(goods, combatant){}', 'game.gd[""]']];
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
                        id: layoutPosition

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*@装备位置：'
                        }

                        TextField {
                            id: textPosition

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '*@装备位置'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = ['头戴', '身穿', '武器', '鞋子'];
                                l_list.open({
                                    Data: data,
                                    OnClicked: (index, item)=>{
                                        text = data[index];

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
                        id: layoutSkills

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@附加技能：'
                        }

                        TextField {
                            id: textSkills

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@附加技能'

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


                    ColumnLayout {
                        id: layoutEffectsLayout

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                        ColorButton {
                            Layout.fillWidth: true

                            text: '增加效果'

                            onButtonClicked: {
                                let c = comp.createObject(layoutEffectsLayout);
                                _private.arrCacheComponent.push(c);
                            }
                        }
                    }
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

                    console.debug("[GameVisualGoods]compile:", _private.filepath, jsScript);
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
  1、价格：支持 单个数字（表示买价，卖价为一半），和 两个数字（用逗号分隔，分别表示买卖价格）；
  2、战斗技能：表示战斗时使用道具时触发的技能（可以做投掷类道具），如果不填表示战斗不能使用；
  3、装备位置：可以选系统提供的，也可以自定义位置（引擎自动识别）；
  4、附加技能：表示装备后主角会额外使用的技能（如果时普通攻击技能，则直接使用）；
  5、增加效果：表示装备后提高的各项属性值，如果是整数表示增强多少值（可负），如果填小数表示增强人物原属性的多少倍，如果为空，表示不可装备（可做投掷类道具）；
注意：
  1、必须点击 编译 才可以使用；
  2、注意代码格式的符号必须是英文半角，中文或全角会报错；
')
                }
            }
        }

    }



    QtObject {
        id: _private


        function changeType() {
            switch(comboType.currentIndex) {
            case 0:
                layoutPosition.visible = true;
                layoutSkills.visible = true;
                layoutUseScript.visible = false;
                break;
            case 1:
                layoutPosition.visible = false;
                layoutSkills.visible = false;
                layoutUseScript.visible = true;
                break;
            }
        }


        function saveData() {
            let properties = [];

            let propertyTextFields = FrameManager.sl_qml_FindChildren(layoutEffectsLayout, 'property');
            let effectTextFields = FrameManager.sl_qml_FindChildren(layoutEffectsLayout, 'effect');

            for(let tt in propertyTextFields) {
                properties.push([propertyTextFields[tt].text.trim(), effectTextFields[tt].text.trim()]);
            }



            let data = {};

            data.Name = textName.text.trim();
            data.Description = textDescription.text.trim();
            data.Price = textPrice.text.trim();
            data.Type = comboType.currentIndex;
            data.Position = textPosition.text.trim();
            data.UseScript = textUseScript.text.trim();
            data.Skills = textSkills.text.trim();
            //data.Stackable = textStackable.text.trim();
            //data.Fight = textFight.text.trim();
            data.Color = textColor.text.trim();
            data.Image = textImage.text.trim();
            data.Size = [textImageWidth.text.trim(), textImageHeight.text.trim()];
            data.Fight = textFightSkill.text.trim();

            data.Properties = properties;

            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify({Version: '0.6', Type: 2, TypeName: 'VisualGoods', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(filePath);
            console.debug("[GameVisualGoods]filePath：", filePath);
            //console.exception("????")

            if(data) {
                data = JSON.parse(data);
                data = data.Data;
            }
            else {
                data = {Price: '0', Type: '0', Position: '', Size: ['50', '50'], Properties: []};
            }


            for(let tc of _private.arrCacheComponent) {
                tc.destroy();
            }
            _private.arrCacheComponent = [];


            for(let tt in data.Properties) {
                let effectComp;
                effectComp = comp.createObject(layoutEffectsLayout);
                _private.arrCacheComponent.push(effectComp);

                let propertyTextFields = FrameManager.sl_qml_FindChild(effectComp, 'property');
                let effectTextFields = FrameManager.sl_qml_FindChild(effectComp, 'effect');

                propertyTextFields.text = data.Properties[tt][0];
                effectTextFields.text = data.Properties[tt][1];
            }


            comboType.currentIndex = data.Type;
            comboType.activated(data.Type);

            textName.text = data.Name || '';
            textDescription.text = data.Description || '';
            textPrice.text = data.Price || '';
            //textType.text = data.Type || '';
            textPosition.text = data.Position || '';
            textUseScript.text = data.UseScript || '';
            textSkills.text = data.Skills || '';
            //textStackable.text = data.Stackable || '';
            //textFight.text = data.Fight || '';
            textColor.text = data.Color || '';
            textImage.text = data.Image || '';
            textImageWidth.text = data.Size[0] || '0';
            textImageHeight.text = data.Size[1] || '0';
            textFightSkill.text = data.Fight || '';

            changeType();
        }


        //编译（结果为字符串）
        function compile() {


            //战斗技能
            let fightskill = textFightSkill.text.trim();
            let fightSkillScript;
            if(fightskill) {
                fightSkillScript = strTemplateFightScript1;
            }
            else
                fightSkillScript = strTemplateFightScript2;


            let type;
            let position;
            let skills;
            let equipScript;
            let useScript;

            //道具效果
            let strEffects = '';
            let propertyTextFields = FrameManager.sl_qml_FindChildren(layoutEffectsLayout, 'property');
            let effectTextFields = FrameManager.sl_qml_FindChildren(layoutEffectsLayout, 'effect');


            //类型
            switch(comboType.currentIndex) {
            //装备
            case 0:
                type = 1;

                position = textPosition.text.trim();
                skills = GlobalLibraryJS.array2string(textSkills.text.trim().split(','));
                useScript = strTemplateUseScript2;


                if(propertyTextFields.length > 0) {
                    //console.debug(propertyTextFields);
                    for(let tt in propertyTextFields) {
                        //console.debug(tt.text.trim());

                        //分隔，看是否多段值
                        let propertyName = propertyTextFields[tt].text.trim().split(',');
                        if(propertyName.length === 2)
                            propertyName = propertyName[0].trim() + '[' + propertyName[1].trim() + ']';
                        else
                            propertyName = propertyName[0].trim();

                        //倍率
                        if(effectTextFields[tt].text.indexOf('.') >= 0)
                            strEffects += "combatant.$$$$$$$$propertiesWithExtra.%1 += combatant.$$properties.%1 * %2;\r\n".arg(propertyName).arg(effectTextFields[tt].text.trim());
                        else
                            strEffects += "combatant.$$$$$$$$propertiesWithExtra.%1 += %2;\r\n".arg(propertyName).arg(effectTextFields[tt].text.trim());
                    }
                    equipScript = _private.strTemplateEquipment1.replace(/\$\$equipEffectAlgorithm\$\$/g, strEffects);
                }
                else {
                    equipScript = _private.strTemplateEquipment1.replace(/\$\$equipEffectAlgorithm\$\$/g, '');
                }

                break;

            //使用
            case 1:
                type = 2;

                position = '';
                skills = '[]';
                equipScript = _private.strTemplateEquipment2;


                if(propertyTextFields.length > 0 || textUseScript.text.trim() !== '') {
                    //console.debug(propertyTextFields);
                    for(let tt in propertyTextFields) {
                        //console.debug(tt.text.trim());

                        //分隔，看是否多段值
                        let propertyName = propertyTextFields[tt].text.trim();

                        //倍率
                        if(effectTextFields[tt].text.indexOf('.') >= 0)
                            strEffects += "game.addprops(combatant, {'%1': %2}, 1);\r\n".arg(propertyName).arg(effectTextFields[tt].text.trim());
                        else
                            strEffects += "game.addprops(combatant, {'%1': %2}, 2);\r\n".arg(propertyName).arg(effectTextFields[tt].text.trim());
                    }

                    if(textUseScript.text.trim() !== '')
                        strEffects += "game.run(%1, -1, goods, combatant);\r\n".arg(textUseScript.text.trim());
                    else
                        strEffects += "game.removegoods(goods, 1);   //背包道具-1\r\n";


                    useScript = _private.strTemplateUseScript1.replace(/\$\$useEffect\$\$/g, strEffects);
                }
                else {
                    useScript = _private.strTemplateUseScript2;
                }

                break;
            }


            let price = textPrice.text.trim().split(',');
            price[0] = price[0].trim();
            if(price.length === 1)
                price[1] = parseInt(price[0] / 2);
            else
                price[1] = price[1].trim();
            price = '[%1]'.arg(price.join(','));



            let data = strTemplate.
                replace(/\$\$name\$\$/g, textName.text.trim()).
                replace(/\$\$description\$\$/g, textDescription.text.trim()).
                replace(/\$\$price\$\$/g, price).
                replace(/\$\$type\$\$/g, type).
                replace(/\$\$color\$\$/g, textColor.text.trim()).
                replace(/\$\$image\$\$/g, textImage.text.trim()).
                replace(/\$\$size\$\$/g, '[%1, %2]'.arg(textImageWidth.text.trim() || 0).arg(textImageHeight.text.trim() || 0)).
                replace(/\$\$position\$\$/g, position).
                replace(/\$\$skills\$\$/g, skills).
                //replace(/\$\$stackable\$\$/g, textLuck.text.trim()).
                replace(/\$\$fight\$\$/g, GlobalLibraryJS.array2string(fightskill.split(','))).
                replace(/\$\$useScript\$\$/g, useScript).
                replace(/\$\$equipScript\$\$/g, equipScript).
                replace(/\$\$fightScript\$\$/g, fightSkillScript)
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



    //独立属性，用 goods 来引用；会保存到存档中；
    //params：使用对象{RId:xxx, Params: 。。。}创建道具时的对象参数。
    let $createData = function(params) {

        return {
            /*
            //游戏中显示的 名称和描述
            $name: '$$name$$',
            $description: '$$description$$',

            $price: $$price$$,	//买卖金额，false表示不能买卖
            $type: $$type$$,	//1为装备；2为普通使用；3为战斗使用；4为剧情类
            $position: '$$position$$',	//装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
            $skills: $$skills$$,	//道具带的技能（此时道具作为装备，且为 武器 时可用）
            $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

            $fight: $$fight$$,    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

            $color: '$$color$$', //文字颜色
            $image: '$$image$$', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
            $size: $$size$$,    //图像大小
            */
        };
    };



    //公用属性，用 goods.$commons 或 goods 来引用；
    let $commons = {

        //游戏中显示的 名称和描述
        $name: '$$name$$',
        $description: '$$description$$',

        $price: $$price$$,	//买卖金额，false表示不能买卖
        $type: $$type$$,	//1为装备；2为普通使用；3为战斗使用；4为剧情类
        $position: '$$position$$',	//装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
        $skills: $$skills$$,	//道具带的技能（此时道具作为装备，且为 武器 时可用）
        $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

        $fight: $$fight$$,    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

        $color: '$$color$$', //文字颜色
        $image: '$$image$$', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
        $size: $$size$$,    //图像大小


        $$useScript$$

        $$equipScript$$

        $$fightScript$$
    };



    return ({$createData, $commons});

})();

`

        property string strTemplateEquipment1: `

    //装备效果
    //  注意：$$$$propertiesWithExtra为临时增加，$$properties为永久增加，所以可以用$$properties作为参考，来修改$$$$propertiesWithExtra）；
    $$equipEffectAlgorithm: function(goods, combatant) {
$$equipEffectAlgorithm$$
    },

    //装备脚本
    $$equipScript: function*(goods, combatant) {
        if(combatant === undefined || combatant === null)
            combatant = yield game.menu('选择角色', game.fighthero(-1, 1), true);   //选择角色
        game.getgoods(game.unload(combatant, goods.$$position));	//脱下装备并放入背包
        game.equip(combatant, goods);	//装备；使用 goods 的 position 属性来装备；
        game.removegoods(goods, 1);	//背包道具-1

        //yield game.msg("装备脚本信息");
        //console.debug(goods, c);
    },

`
        property string strTemplateEquipment2: `
    $$equipEffectAlgorithm: null,
    //这样写不会显示 装备 选项
    $$equipScript: null,
`

        property string strTemplateUseScript1: `
    //使用脚本
    $$useScript: function *(goods, combatant) {
        if(combatant === undefined || combatant === null)
            combatant = yield game.menu('选择角色', game.fighthero(-1, 1), true);   //选择角色

$$useEffect$$

        //yield game.msg("你用西瓜刀切了两片西瓜开始吆喝：好甜的西瓜啊，一斤2块5啦", 50);

        //game.removegoods(goods, 1);   //背包道具-1
        return -1;
    },
`

        property string strTemplateUseScript2: `
    //这样写不会显示 使用 选项
    $$useScript: null,
`

        property string strTemplateFightScript1: `
    //战斗脚本；数组或对象，内容分别是：0，选择道具脚本；1，检测是否可用；2，完成代码；
    $$fightScript: {
        //选择道具时脚本
        $$choiceScript: function *(goods, combatant) {
            //调用技能的
            let skill = goods.$fight[0];
            yield *skill.$$choiceScript(skill, combatant);
        },
        //是否可用
        $$check: function (goods, combatant, targetCombatant, stage) {
            //调用技能的
            let skill = goods.$fight[0];
            return skill.$$check(skill, combatant, targetCombatant, stage);
        },

        //完成代码（收尾用）
        $$completeScript: function *(goods, combatant) {
            game.removegoods(goods, 1);	//背包道具-1
            //yield fight.msg('...');
            return;
        },
    },
`
        property string strTemplateFightScript2: `
    //这样写不会显示 战时 选项
    $$fightScript: null,
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

