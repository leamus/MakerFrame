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

                    objectName: 'Property'

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
                    id: ttextParams

                    objectName: 'Effect'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@效果值'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let data = [['固定值（整数）：20','倍率（小数）：2.0'],
                                    ['20','2.0']];

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

                    //spacing: 16


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
                                //border.color: control.pressed ? '#6495ED' : '#696969'
                                //border.width: control.visualFocus ? 2 : 1
                                color: 'transparent'
                                //border.color: comboBoxComponentItem.color
                                border.width: 2
                                radius: 6
                            }

                            onActivated: {
                                console.debug('[GoodsVisualEditor]ComboBox:', comboType.currentIndex,
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
                            text: '描述：'
                        }

                        TextArea {
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
                                rootWindow.aliasGlobal.list.open({
                                    Data: GameMakerGlobal.imageResourcePath(),
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
                            placeholderText: '@战斗技能'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

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
                                let data = [['无', '函数', '全局函数'], ['', 'function*(goods, combatant){}', 'game.gf[""]']];
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
                                rootWindow.aliasGlobal.list.open({
                                    Data: data,
                                    OnClicked: (index, item)=>{
                                        text = data[index];

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


                    Button {
                        Layout.fillWidth: true

                        text: '增加效果'

                        onClicked: {
                            let c = comp.createObject(layoutEffectsLayout);
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

                            text: '*@属性'
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
                    }

                    ColumnLayout {
                        id: layoutEffectsLayout

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                    }
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

                    console.debug('[GoodsVisualEditor]compile:', _private.filepath, jsScript);
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



    //配置
    QtObject {
        id: _config

        property int nLabelFontSize: 10
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

            let propertyTextFields = FrameManager.sl_findChildren(layoutEffectsLayout, 'Property');
            let effectTextFields = FrameManager.sl_findChildren(layoutEffectsLayout, 'Effect');

            for(let tt in propertyTextFields) {
                properties.push([propertyTextFields[tt].text.trim(), effectTextFields[tt].text.trim()]);
            }



            let data = {};

            data.Name = textName.text;
            data.Description = textDescription.text;
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

            let ret = FrameManager.sl_fileWrite(JSON.stringify({Version: '0.6', Type: 2, TypeName: 'VisualGoods', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_fileRead(filePath);
            console.debug('[GoodsVisualEditor]filePath：', filePath);
            //console.exception('????')

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

                let propertyTextFields = FrameManager.sl_findChild(effectComp, 'Property');
                let effectTextFields = FrameManager.sl_findChild(effectComp, 'Effect');

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
            let bCheck = true;
            do {
                for(let effectComp of _private.arrCacheComponent) {
                    let propertyTextFields = FrameManager.sl_findChild(effectComp, 'Property');
                    let effectTextFields = FrameManager.sl_findChild(effectComp, 'Effect');
                    if(!propertyTextFields.text.trim() || !effectTextFields.text.trim()) {
                        bCheck = false;
                        break;
                    }
                }
                if(!bCheck)
                    break;
                if(comboType.currentIndex === 0 && !textPosition.text.trim()) {
                    bCheck = false;
                    break;
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
            let propertyTextFields = FrameManager.sl_findChildren(layoutEffectsLayout, 'Property');
            let effectTextFields = FrameManager.sl_findChildren(layoutEffectsLayout, 'Effect');


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
                            strEffects += 'combatant.$$$$$$$$propertiesWithExtra.%1 += combatant.$$properties.%1 * %2;\r\n'.arg(propertyName).arg(effectTextFields[tt].text.trim());
                        else
                            strEffects += 'combatant.$$$$$$$$propertiesWithExtra.%1 += %2;\r\n'.arg(propertyName).arg(effectTextFields[tt].text.trim());
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
                            strEffects += 'game.addprops(combatant, {"%1": %2}, 1);\r\n'.arg(propertyName).arg(effectTextFields[tt].text.trim());
                        else
                            strEffects += 'game.addprops(combatant, {"%1": %2}, 2);\r\n'.arg(propertyName).arg(effectTextFields[tt].text.trim());
                    }

                    if(textUseScript.text.trim() !== '')
                        strEffects += 'game.run(%1(goods, combatant) ?? null, -1);\r\n'.arg(textUseScript.text.trim());
                    else
                        strEffects += 'game.removegoods(goods, 1);   //背包道具-1\r\n';


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
                replace(/\$\$name\$\$/g, textName.text).
                replace(/\$\$description\$\$/g, GlobalLibraryJS.convertToHTML(textDescription.text)).
                replace(/\$\$price\$\$/g, price).
                replace(/\$\$type\$\$/g, type).
                replace(/\$\$color\$\$/g, textColor.text.trim()).
                replace(/\$\$image\$\$/g, textImage.text.trim()).
                replace(/\$\$size\$\$/g, '[%1, %2]'.arg(textImageWidth.text.trim() || 0).arg(textImageHeight.text.trim() || 0)).
                replace(/\$\$ExtraProperties\$\$/g, textExtraProperties.text.trim() || 'undefined').
                replace(/\$\$position\$\$/g, position).
                replace(/\$\$skills\$\$/g, skills).
                //replace(/\$\$stackable\$\$/g, textLuck.text.trim()).
                replace(/\$\$fight\$\$/g, GlobalLibraryJS.array2string(fightskill.split(','))).
                replace(/\$\$useScript\$\$/g, useScript).
                replace(/\$\$equipScript\$\$/g, equipScript).
                replace(/\$\$fightScript\$\$/g, fightSkillScript)
            ;


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



    //独立属性，用 goods 来引用；会保存到存档中；
    //params：使用对象{RID:xxx, Params: 。。。}创建道具时的对象参数。
    let $createData = function (params) {

        return {
            /*
            //游戏中显示的 名称和描述
            $name: '$$name$$',
            $description: '$$description$$',

            $price: $$price$$, //买卖金额，false表示不能买卖
            $type: $$type$$, //1为装备；2为普通使用；3为战斗使用；4为剧情类
            $position: '$$position$$', //装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
            $location: 0, //0为无位置；1为在背包；2为装备；3为持有
            $skills: $$skills$$, //道具带的技能（此时道具作为装备，且为 武器 时可用）
            $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

            $fight: $$fight$$,    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

            $color: '$$color$$', //文字颜色
            $image: '$$image$$', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
            $size: $$size$$,    //图像大小

            $$ExtraProperties$$,
            */
        };
    };



    //公用属性，用 goods.$commons 或 goods 来引用；
    let $commons = {

        //游戏中显示的 名称和描述
        $name: '$$name$$',
        $description: '$$description$$',

        $price: $$price$$, //买卖金额，false表示不能买卖
        $type: $$type$$, //1为装备；2为普通使用；3为战斗使用；4为剧情类
        $position: '$$position$$', //装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
        $skills: $$skills$$, //道具带的技能（此时道具作为装备，且为 武器 时可用）
        $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

        $fight: $$fight$$,    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

        $color: '$$color$$', //文字颜色
        $image: '$$image$$', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
        $size: $$size$$,    //图像大小

        $$ExtraProperties$$,


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
    $$equipEffectAlgorithm: function (goods, combatant) {
$$equipEffectAlgorithm$$
    },

    //装备脚本
    $$equipScript: function*(goods, combatant, params) {
        let r = game.$sys.getCommonScriptResource('$equipScript')(goods, combatant, params);
        if(GlobalLibraryJS.isGenerator(r))r = yield* r;
        return r;
    },

    /*/卸载装备脚本
    $unloadScript: function*(goods, combatant, params) {
        let r = game.$sys.getCommonScriptResource('$unloadScript')(goods, combatant, params);
        if(GlobalLibraryJS.isGenerator(r))r = yield* r;
        return r;
    },*/
`
        property string strTemplateEquipment2: `
    $$equipEffectAlgorithm: null,
    //这样写不会显示 装备 选项
    $$equipScript: null,
    //卸载装备脚本
    $unloadScript: null,
`

        property string strTemplateUseScript1: `
    //使用脚本
    $$useScript: function*(goods, combatant, params) {
        params = function*(goods, combatant, params) {
            $$useEffect$$
        }
        let r = game.$sys.getCommonScriptResource('$useScript')(goods, combatant, params);
        if(GlobalLibraryJS.isGenerator(r))r = yield* r;
        return r;
    },
`

        property string strTemplateUseScript2: `
    //这样写不会显示 使用 选项
    $$useScript: null,
`

        property string strTemplateFightScript1: `
    //战斗脚本；分别是：选择道具脚本；检测是否可用；完成代码；
    $$fightScript: {
        //选择道具时脚本；如果为null自动调用 goods.$$fight[0] 的
        /*$$choiceScript: function *(goods, combatant) {
            //调用技能的
            let skill = goods.$$fight[0];
            yield* skill.$$choiceScript(skill, combatant);

            //选择敌方
            //let r = yield* fight.$$sys.gfChoiceSingleCombatantSkill(goods, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
            //return r;
        },
        */
        $$choiceScript: null,
        //是否可用；如果为null自动调用 goods.$$fight[0] 的
        $$check: function (goods, combatant, stage) {
            //调用技能的
            let skill = goods.$$fight[0];
            return skill.$$check(skill, combatant, stage);
        },

        //完成代码（收尾用）；skill的playScript执行完毕会执行它
        $$completeScript: function *(goods, combatant) {
            game.removegoods(goods, 1); //背包道具-1
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



    Keys.onEscapePressed: function(event) {
        _private.close();

        console.debug('[GoodsVisualEditor]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: function(event) {
        _private.close();

        console.debug('[GoodsVisualEditor]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: function(event) {
        console.debug('[GoodsVisualEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: function(event) {
        console.debug('[GoodsVisualEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[GoodsVisualEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[GoodsVisualEditor]Component.onDestruction');
    }
}
