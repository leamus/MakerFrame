import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
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

                Label {
                    //id: tlable
                    text: '*动作名'
                }

                TextField {
                    id: ttext

                    objectName: 'actionName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*动作名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                Label {
                    //id: tlable
                    text: '@特效名'
                }

                TextField {
                    id: ttextParams

                    objectName: 'spriteName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '@特效名'

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

                Button {
                    id: tbutton
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
        //height: parent.height * 0.9
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
                            text: 'HP：'
                        }

                        TextField {
                            id: textHP

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '60'
                            placeholderText: 'HP'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'MP：'
                        }

                        TextField {
                            id: textMP

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '60'
                            placeholderText: 'MP'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'attack：'
                        }

                        TextField {
                            id: textAttack

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: 'attack'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: 'defense：'
                        }

                        TextField {
                            id: textDefense

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: 'defense'

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
                            text: '@头像（主角）：'
                        }

                        TextField {
                            id: textAvatar

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '@头像'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let path = GameMakerGlobal.imageResourcePath();

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
                        //头像宽
                        TextField {
                            id: textAvatarWidth

                            Layout.preferredWidth: 50
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 30

                            text: '60'
                            placeholderText: '头像宽'
                            //font.pointSize: _config.nLabelFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                        Label {
                            //Layout.preferredWidth: 80
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            Layout.preferredWidth: 10

                            text: "*"
                            //font.pointSize: _config.nLabelFontSize
                        }

                        //头像高
                        TextField {
                            id: textAvatarHeight

                            Layout.preferredWidth: 50
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 30

                            text: '60'
                            placeholderText: '头像高'
                            //font.pointSize: _config.nLabelFontSize

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
                            placeholderText: '*@拥有技能'

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
                            text: '@装备：'
                        }

                        TextField {
                            id: textEquipment

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@装备'

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

                    ColumnLayout {
                        id: layoutActionLayout

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                        RowLayout {
                            id: layoutFirstAction

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30

                            Label {
                                text: '*动作名：'
                            }

                            TextField {
                                objectName: 'actionName'

                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                enabled: false

                                text: 'Normal'
                                placeholderText: '*动作名'

                                readOnly: true

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                            }
                            Label {
                                //id: tlable
                                text: '@特效名'
                            }

                            TextField {
                                objectName: 'spriteName'

                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                text: ''
                                placeholderText: '@特效名'

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

                            Button {
                                text: '增加'

                                onClicked: {
                                    let c = comp.createObject(layoutActionLayout);
                                    _private.arrCacheComponent.push(c);
                                }
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

            Button {
                text: "保存"
                font.pointSize: 9
                onClicked: {
                    _private.saveData();
                }
            }
            Button {
                text: "读取"
                font.pointSize: 9
                onClicked: {
                    _private.loadData();
                }
            }
            Button {
                text: "编译"
                font.pointSize: 9
                onClicked: {
                    let jsScript = _private.compile();
                    if(jsScript === false)
                        return;

                    //let ret = FrameManager.sl_qml_WriteFile(jsScript, _private.filepath + '.js', 0);
                    root.s_Compile(jsScript);

                    console.debug("[GameVisualFightRole]compile:", _private.filepath, jsScript);
                }
            }
            Button {
                text: "关闭"
                font.pointSize: 9
                onClicked: {
                    _private.close();
                }
            }

            Button {
                text: "帮助"
                font.pointSize: 9
                onClicked: {
                    rootGameMaker.showMsg('
操作说明：
  1、先点击 命令，然后 填写参数 或者 长按编辑框（大部分可以长按）选择参数，再点击 追加（到最后）或 插入（到当前指令上面）来完成指令编写；
  2、每次打开可视化编辑界面，会自动载入保存的脚本，也可以手动点击 载入 按钮来重新载入；
  3、编写完成后可以点击 保存按钮 来保存当前脚本；点击 编译 来使用当前脚本（此时上一层界面会自动替换为编译后的脚本）；
功能说明：
  1、拥有技能：战斗人物初始时会的技能（敌人至少要有一个技能，多个技能会随机选择）；技能名逗号分隔；战斗人物有多个普通攻击（包括道具提供的）时自动选择最后一个；
  2、装备：战斗人物初始装备；
  3、携带道具：只有敌人有，随机掉落；
  4、携带金钱、携带经验，你懂的；
  5、动作名：这个要注意，必须要有一个Normal动作，表示战斗起始状态，如果可以再加一个Kill（普攻用）和Skill（技能用）动作，引擎会自动调用，如果没有的话会自动调用Normal动作；
    其他的动作，供代码版使用；
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


        function saveData() {
            let actions = [];

            let actionTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'actionName');
            let spriteTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'spriteName');

            for(let tt in actionTextFields) {
                //console.debug(tt.text.trim());
                actions.push([actionTextFields[tt].text.trim(), spriteTextFields[tt].text.trim()]);
            }



            let data = {};

            data.Name = textName.text.trim();
            data.HP = textHP.text.trim();
            data.MP = textMP.text.trim();
            data.Attack = textAttack.text.trim();
            data.Defense = textDefense.text.trim();
            data.Power = textPower.text.trim();
            data.Luck = textLuck.text.trim();
            data.Speed = textSpeed.text.trim();
            data.EXP = textEXP.text.trim();
            data.Money = textMoney.text.trim();
            data.Skills = textSkills.text.trim();
            data.Goods = textGoods.text.trim();
            data.Equipment = textEquipment.text.trim();
            data.Avatar = textAvatar.text.trim();
            data.Width = textAvatarWidth.text.trim();
            data.Height = textAvatarHeight.text.trim();

            data.Actions = actions;


            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify({Version: '0.6', Type: 4, TypeName: 'VisualFightRole', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(filePath);
            console.debug("[GameVisualFightRole]filePath：", filePath);
            //console.exception("????")

            if(data) {
                data = JSON.parse(data);
                data = data.Data;
            }
            else {
                data = {Name: '战斗人物', HP: '60', MP: '60', Attack: '6', Defense: '6', Power: '6', Luck: '6', Speed: '6', EXP: '6', Money: '6',
                    Width: '60', Height: '60', Actions: [['Normal', '']]};
            }



            for(let tc of _private.arrCacheComponent) {
                tc.destroy();
            }
            _private.arrCacheComponent = [];

            for(let tt in data.Actions) {
                let actionComp;
                if(tt === '0') {
                    actionComp = layoutFirstAction;
                }
                else {
                    actionComp = comp.createObject(layoutActionLayout);
                    _private.arrCacheComponent.push(actionComp);
                }
                let actionTextField = FrameManager.sl_qml_FindChild(actionComp, 'actionName');
                let spriteTextField = FrameManager.sl_qml_FindChild(actionComp, 'spriteName');

                actionTextField.text = data.Actions[tt][0];
                spriteTextField.text = data.Actions[tt][1];
            }


            textName.text = data.Name || '';
            textHP.text = data.HP || '';
            textMP.text = data.MP || '';
            textAttack.text = data.Attack || '';
            textDefense.text = data.Defense || '';
            textPower.text = data.Power || '';
            textLuck.text = data.Luck || '';
            textSpeed.text = data.Speed || '';
            textEXP.text = data.EXP || '';
            textMoney.text = data.Money || '';
            textSkills.text = data.Skills || '';
            textGoods.text = data.Goods || '';
            textEquipment.text = data.Equipment || '';
            textAvatar.text = data.Avatar || '';
            textAvatarWidth.text = data.Width || '';
            textAvatarHeight.text = data.Height || '';
        }


        //编译（结果为字符串）
        function compile() {
            let bCheck = true;
            do {
                let actionTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'actionName');
                let spriteTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'spriteName');

                //console.debug(actionTextFields);
                for(let tt in actionTextFields) {
                    let actionTextField = actionTextFields[tt];
                    let spriteTextField = spriteTextFields[tt];
                    //console.debug(tt.text.trim());

                    if(!actionTextField.text.trim()/* || !spriteTextField.text.trim()*/) {
                        bCheck = false;
                        break;
                    }
                }
                if(!bCheck)
                    break;
                if(!textSkills.text.trim()) {
                    bCheck = false;
                    break;
                }
            }while(0);
            if(!bCheck) {
                dialogCommon.show({
                    Msg: '有必填项没有完成',
                    Buttons: Dialog.Yes,
                    OnAccepted: function(){
                        //dialogCommon.close();
                        root.forceActiveFocus();
                    },
                    OnDiscarded: ()=>{
                        //dialogCommon.close();
                        root.forceActiveFocus();
                    },
                });
                return false;
            }



            let strActions = '';
            let actionTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'actionName');
            let spriteTextFields = FrameManager.sl_qml_FindChildren(layoutActionLayout, 'spriteName');

            //console.debug(actionTextFields);
            for(let tt in actionTextFields) {
                //console.debug(tt.text.trim());
                strActions += "'%1': '%2', ".arg(actionTextFields[tt].text.trim()).arg(spriteTextFields[tt].text.trim());
            }


            let data = strTemplate.
                replace(/\$\$name\$\$/g, textName.text.trim()).
                replace(/\$\$actions\$\$/g, strActions).
                replace(/\$\$avatar\$\$/g, textAvatar.text.trim()).
                replace(/\$\$size\$\$/g, textAvatarWidth.text.trim() + ',' + textAvatarHeight.text.trim()).
                replace(/\$\$HP\$\$/g, textHP.text.trim()).
                replace(/\$\$MP\$\$/g, textMP.text.trim()).
                replace(/\$\$attack\$\$/g, textAttack.text.trim()).
                replace(/\$\$defense\$\$/g, textDefense.text.trim()).
                replace(/\$\$power\$\$/g, textPower.text.trim()).
                replace(/\$\$luck\$\$/g, textLuck.text.trim()).
                replace(/\$\$speed\$\$/g, textSpeed.text.trim()).
                replace(/\$\$skills\$\$/g, GlobalLibraryJS.array2string(textSkills.text.trim().split(','))).
                replace(/\$\$goods\$\$/g, GlobalLibraryJS.array2string(textGoods.text.trim().split(','))).
                replace(/\$\$equipment\$\$/g, GlobalLibraryJS.array2string(textEquipment.text.trim().split(','))).
                replace(/\$\$money\$\$/g, textMoney.text.trim() || '0').
                replace(/\$\$EXP\$\$/g, textEXP.text.trim() || '0')
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
                    if(jsScript === false)
                        return;

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



    //独立属性，用 combatant 来引用；会保存到存档中；
    //params：使用对象{RId:xxx, Params: 。。。}创建时的对象参数。
    let $createData = function(params) { //创建战斗角色时的初始数据，可忽略（在战斗脚本中写）；
        return {
            $name: '$$name$$', $properties: {HP: [$$HP$$,$$HP$$,$$HP$$], MP: [$$MP$$, $$MP$$], attack: $$attack$$, defense: $$defense$$, power: $$power$$, luck: $$luck$$, speed: $$speed$$}, $avatar: '$$avatar$$', $size: [$$size$$], $color: 'white', $skills: $$skills$$, $goods: $$goods$$, $equipment: $$equipment$$, $money: $$money$$, $EXP: $$EXP$$,
        };
    };


    //公用属性，可用 combatant.$commons 或 combatant 来引用；
    let $commons = {

        //$name: '$$name$$', $properties: {HP: [$$HP$$,$$HP$$,$$HP$$], MP: [$$MP$$, $$MP$$], attack: $$attack$$, defense: $$defense$$, power: $$power$$, luck: $$luck$$, speed: $$speed$$}, $avatar: '$$avatar$$', $size: [$$size$$], $color: 'white', $skills: $$skills$$, $goods: $$goods$$, $equipment: $$equipment$$, $money: $$money$$, $EXP: $$EXP$$,


        //动作包含的 精灵名
        $actions: function(combatant) {
            return {$$actions$$};
        }


        //角色单独的升级链脚本和升级算法，可忽略（会自动使用通用的升级链和算法）

        /*
        //角色单独的升级链脚本
        function *levelUpScript(combatant) {
        }

        //targetLeve级别对应需要达到的 各项属性 的算法（升级时会设置，可选；注意：只增不减）
        function levelAlgorithm(combatant, targetLevel) {
            if(targetLevel <= 0)
                return 0;

            let level = 1;  //级别
            let exp = 10;   //级别的经验

            while(level < targetLevel) {
                exp = exp * 2;
                ++level;
            }
            return {EXP: exp};
        }
        */
    };



    return {$createData, $commons};

})();

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

