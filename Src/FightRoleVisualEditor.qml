import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

//import GameComponents 1.0
import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();
    onSg_close: {
        for(const tc of _private.arrCacheComponent) {
            tc.destroy();
        }
        _private.arrCacheComponent = [];

        _private.jsLoader.clear();
    }

    signal sg_compile(var result);


    function init(filePath) {
        if(filePath)
            _private.filepath = filePath;
        _private.loadData();
    }

    readonly property var compile: _private.compile


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
                    visible: false
                    text: '*@动作名'
                }

                TextField {
                    id: ttext

                    objectName: 'ActionName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '*@动作名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        const data = [['[动作名]Normal为普通状态，已存在', 'Kill（普通攻击）','Skill（释放技能）'],
                                    ['', 'Kill','Skill']];

                        $list.open({
                            Data: data[0],
                            OnClicked: (index, item)=>{
                                text = data[1][index];

                                $list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                $list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                Label {
                    //id: tlable
                    visible: false
                    text: '@特效名'
                }

                TextField {
                    id: ttextSpriteName

                    objectName: 'SpriteName'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '@特效名'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

                        $list.open({
                            Data: path,
                            OnClicked: (index, item)=>{
                                text = item;

                                $list.visible = false;
                                root.forceActiveFocus();
                            },
                            OnCanceled: ()=>{
                                $list.visible = false;
                                root.forceActiveFocus();
                            },
                        });
                    }
                }

                Button {
                    implicitWidth: 30
                    text: 'P'
                    onClicked: {
                        rectSpriteEffectBackground.visible = true;
                        _private.refreshSpriteEffect(ttextSpriteName.text);
                    }
                }

                Button {
                    id: tbutton

                    implicitWidth: 30

                    text: 'X'

                    onClicked: {
                        for(const tc in _private.arrCacheComponent) {
                            if(_private.arrCacheComponent[tc] === tRoot) {
                                _private.arrCacheComponent.splice(tc, 1);
                                break;
                            }

                        }
                        tRoot.destroy();

                        root.forceActiveFocus();
                    }
                }
            }

        }
    }



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
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

                    //anchors.fill: parent
                    width: parent.width

                    spacing: 16


                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '名字:'
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
                            text: 'HP:'
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
                            text: 'MP:'
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
                            text: '攻击:'
                        }

                        TextField {
                            id: textAttack

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '攻击'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '防御:'
                        }

                        TextField {
                            id: textDefense

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '防御'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '灵力:'
                        }

                        TextField {
                            id: textPower

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '灵力'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '速度:'
                        }

                        TextField {
                            id: textSpeed

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '速度'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '幸运:'
                        }

                        TextField {
                            id: textLuck

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '6'
                            placeholderText: '幸运'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '@头像:'
                        }

                        TextField {
                            id: textAvatar

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@头像'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                const path = GameMakerGlobal.imageResourcePath();

                                $list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text = item;

                                        $list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        $list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                });
                            }
                        }
                        //头像宽
                        TextField {
                            id: textAvatarWidth

                            Layout.preferredWidth: 30
                            //Layout.fillWidth: true
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

                            text: '*'
                            //font.pointSize: _config.nLabelFontSize
                        }
                        //头像高
                        TextField {
                            id: textAvatarHeight

                            Layout.preferredWidth: 30
                            //Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                            //Layout.preferredHeight: 30

                            text: '60'
                            placeholderText: '头像高'
                            //font.pointSize: _config.nLabelFontSize

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }

                        Image {
                            visible: source.length !== 0
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            source: {
                                if(textAvatar.text.length === 0)
                                    return '';
                                if(!$Frame.sl_fileExists(GameMakerGlobal.imageResourcePath(textAvatar.text)))
                                    return '';
                                return GameMakerGlobal.imageResourceURL(textAvatar.text);
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '*@拥有技能:'
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
                                const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

                                $list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

                                        $list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        $list.visible = false;
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
                            text: '@装备:'
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
                                const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;

                                $list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

                                        $list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        $list.visible = false;
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
                            text: '@携带道具（敌）:'
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
                                const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;

                                $list.open({
                                    Data: path,
                                    OnClicked: (index, item)=>{
                                        text += item + ',';

                                        $list.visible = false;
                                        root.forceActiveFocus();
                                    },
                                    OnCanceled: ()=>{
                                        $list.visible = false;
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
                            text: '携带金钱（敌）:'
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

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30

                        Label {
                            text: '额外数据:'
                        }

                        TextField {
                            id: textExtraProperties

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '额外数据'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap
                        }
                    }


                    ColumnLayout {
                        //id: layoutActionGroup

                        Layout.fillWidth: true
                        //Layout.fillHeight: true

                        //spacing: 16

                        Button {
                            Layout.fillWidth: true

                            text: '增加动作'

                            onClicked: {
                                const c = comp.createObject(layoutActionLayout);
                                _private.arrCacheComponent.push(c);

                                $CommonLibJS.setTimeout([function() {
                                    if(flickable.contentHeight > flickable.height)
                                        flickable.contentY = flickable.contentHeight - flickable.height;
                                    }, 1, root, ''], 1);

                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '*@动作名'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                            Label {
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true

                                text: '@特效名'
                                font.pointSize: _config.nLabelFontSize
                                color: Global.style.color(Global.style.Orange)
                            }
                        }

                        ColumnLayout {
                            id: layoutActionLayout

                            Layout.fillWidth: true
                            //Layout.fillHeight: true

                            spacing: 16

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30

                                RowLayout {
                                    id: layoutFirstAction

                                    anchors.fill: parent

                                    Label {
                                        visible: false
                                        text: '*@动作名:'
                                    }

                                    TextField {
                                        objectName: 'ActionName'

                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                        //enabled: false

                                        color: 'red'
                                        text: 'Normal'
                                        placeholderText: '*动作名'

                                        readOnly: true

                                        //selectByKeyboard: true
                                        selectByMouse: true
                                        //wrapMode: TextEdit.Wrap

                                    }
                                    Label {
                                        visible: false

                                        text: '@特效名'
                                    }

                                    TextField {
                                        id: textSpriteName
                                        objectName: 'SpriteName'

                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                        text: ''
                                        placeholderText: '@特效名'

                                        //selectByKeyboard: true
                                        selectByMouse: true
                                        //wrapMode: TextEdit.Wrap

                                        onPressAndHold: {
                                            const path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

                                            $list.open({
                                                Data: path,
                                                OnClicked: (index, item)=>{
                                                    text = item;

                                                    $list.visible = false;
                                                    root.forceActiveFocus();
                                                },
                                                OnCanceled: ()=>{
                                                    $list.visible = false;
                                                    root.forceActiveFocus();
                                                },
                                            });
                                        }
                                    }
                                    Button {
                                        implicitWidth: 30
                                        text: 'P'
                                        onClicked: {
                                            rectSpriteEffectBackground.visible = true;
                                            _private.refreshSpriteEffect(textSpriteName.text);
                                        }
                                    }
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
                    const result = _private.compileAndShowResult();
                    if(result[0] === false)
                        return;
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



    Rectangle {
        id: rectSpriteEffectBackground
        visible: false
        anchors.fill: parent

        color: '#7F000000'

        Rectangle {
            id: rectSprite

            width: spriteEffectComp.width
            height: spriteEffectComp.height
            implicitWidth: spriteEffectComp.implicitWidth
            implicitHeight: spriteEffectComp.implicitHeight
            anchors.centerIn: parent

            color: 'transparent'
            border {
                width: 1
                color: '#FFFFFF'
            }

            SpriteEffect {
                id: spriteEffectComp


                //anchors.centerIn: parent
                //anchors.fill: parent
                //width: 37;
                //height: 58;


                bTest: true
                nType: 1

                //sizeFrame: Qt.size(37, 58);
                /*nFrameCount: 3;
                interval: 100;*/

                /*onSg_clicked: {
                    root.forceActiveFocus();
                }*/
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                spriteEffectComp.stop();
                rectSpriteEffectBackground.visible = false;
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


        //刷新特效；
        function refreshSpriteEffect(spriteName) {
            //console.debug('[FightScene]getSpriteEffect0');

            //读特效信息
            let spriteDirPath = $GlobalJS.toPath(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteName);

            let spriteResourceInfo = $Frame.sl_fileRead(spriteDirPath + GameMakerGlobal.separator + 'sprite.json');
            if(spriteResourceInfo)
                spriteResourceInfo = JSON.parse(spriteResourceInfo);
            else
                return false;

            let script;

            if($Frame.sl_fileExists(spriteDirPath + GameMakerGlobal.separator + 'sprite.js')) {
                _private.jsLoader.clear();
                script = _private.jsLoader.load($GlobalJS.toURL(spriteDirPath + GameMakerGlobal.separator + 'sprite.js'));
            }


            spriteEffectComp.nSpriteType = spriteResourceInfo.SpriteType;
            spriteEffectComp.sprite.stop();


            //spriteEffectComp.$info = spriteResourceInfo;
            //spriteEffectComp.$script = spriteResourceInfo.$script;


            /*switch(spriteResourceInfo.SpriteType) {
            case 1:
                spriteEffectComp.sourceComponent = compSpriteEffect;
                break;
            case 2:
                spriteEffectComp.sourceComponent = compDirSpriteEffect;
                break;
            }
            */


            spriteEffectComp.strSource = GameMakerGlobal.spriteResourceURL(spriteResourceInfo.Image);

            //spriteEffectComp.sprite.width = parseInt(spriteResourceInfo.SpriteSize[0]);
            //spriteEffectComp.sprite.height = parseInt(spriteResourceInfo.SpriteSize[1]);
            spriteEffectComp.rXOffset = spriteResourceInfo.XOffset ?? 0;
            spriteEffectComp.rYOffset = spriteResourceInfo.YOffset ?? 0;
            spriteEffectComp.opacity = spriteResourceInfo.Opacity ?? 1;
            spriteEffectComp.rXScale = spriteResourceInfo.XScale ?? 1;
            spriteEffectComp.rYScale = spriteResourceInfo.YScale ?? 1;

            spriteEffectComp.strSoundeffectName = spriteResourceInfo.Sound ?? '';

            spriteEffectComp.nSoundeffectDelay = spriteResourceInfo.SoundDelay ?? 0;

            spriteEffectComp.nLoops = -1;
            //spriteEffectComp.restart();

            let t = spriteResourceInfo.SpriteSize;
            spriteEffectComp.width = parseInt((t && t[0]) ? t[0] : 0);
            spriteEffectComp.height = parseInt((t && t[1]) ? t[1] : 0);


            //！！！兼容旧代码
            if(spriteEffectComp.nSpriteType === 1) {
                spriteEffectComp.nFrameCount = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameCount'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo, 'FrameCount'),
                0);
                spriteEffectComp.nInterval = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameInterval'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo, 'FrameInterval'),
                0);

                //注意这个放在 spriteEffectComp.sprite.width 和 spriteEffectComp.sprite.height 之前
                let t = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameSize'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo, 'FrameSize'),
                );
                spriteEffectComp.sprite.sizeFrame = Qt.size((t && t[0]) ? t[0] : 0, (t && t[1]) ? t[1] : 0);

                t = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'OffsetIndex'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo, 'OffsetIndex'),
                );
                spriteEffectComp.sprite.pointOffsetIndex = Qt.point((t && t[0]) ? t[0] : 0, (t && t[1]) ? t[1] : 0);
            }
            else if(spriteEffectComp.nSpriteType === 2) {
                let t = spriteResourceInfo.FrameData;

                //！！！兼容旧代码
                spriteEffectComp.nFrameCount = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameCount'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, '1'),
                0);
                spriteEffectComp.nInterval = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameInterval'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, '2'),
                0);
                spriteEffectComp.sprite.nFrameStartIndex = $CommonLibJS.shortCircuit(0b1,
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameStartIndex'),
                    $CommonLibJS.getObjectValue(spriteResourceInfo.FrameData, '0'),
                0);


                if(script)
                    spriteEffectComp.sprite.fnRefresh = script.$refresh;
            }
            spriteEffectComp.start();

            return true;
        }


        function saveData() {
            let actions = [];

            let actionTextFields = $Frame.sl_findChildren(layoutActionLayout, 'ActionName');
            let spriteTextFields = $Frame.sl_findChildren(layoutActionLayout, 'SpriteName');

            for(let tt in actionTextFields) {
                //console.debug(tt.text.trim());
                actions.push([actionTextFields[tt].text.trim(), spriteTextFields[tt].text.trim()]);
            }



            let data = {};

            data.Name = textName.text;
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


            let ret = $Frame.sl_fileWrite(JSON.stringify({Version: '0.6', Type: 4, TypeName: 'VisualFightRole', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = $Frame.sl_fileRead(filePath);
            console.debug('[FightRoleVisualEditor]filePath:', filePath);
            //console.exception('????')

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
                let actionTextField = $Frame.sl_findChild(actionComp, 'ActionName');
                let spriteTextField = $Frame.sl_findChild(actionComp, 'SpriteName');

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


        //编译（结果为数组：[code, 编译结果, 错误]）
        function compile(checkResult=true) {
            let bCheck = true;
            do {
                let actionTextFields = $Frame.sl_findChildren(layoutActionLayout, 'ActionName');
                let spriteTextFields = $Frame.sl_findChildren(layoutActionLayout, 'SpriteName');

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
            } while(0);
            if(!bCheck) {
                return [false, null, new Error('有必填项没有完成')];
            }



            let strActions = '';
            let actionTextFields = $Frame.sl_findChildren(layoutActionLayout, 'ActionName');
            let spriteTextFields = $Frame.sl_findChildren(layoutActionLayout, 'SpriteName');

            //console.debug(actionTextFields);
            for(let tt in actionTextFields) {
                //console.debug(tt.text.trim());
                strActions += '"%1": "%2", '.arg(actionTextFields[tt].text.trim()).arg(spriteTextFields[tt].text.trim());
            }


            let data = strTemplate.
                replace(/\$\$name\$\$/g, textName.text).
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
                replace(/\$\$skills\$\$/g, $CommonLibJS.array2string(textSkills.text.trim().split(','))).
                replace(/\$\$goods\$\$/g, $CommonLibJS.array2string(textGoods.text.trim().split(','))).
                replace(/\$\$equipment\$\$/g, $CommonLibJS.array2string(textEquipment.text.trim().split(','))).
                replace(/\$\$money\$\$/g, textMoney.text.trim() || '0').
                replace(/\$\$EXP\$\$/g, textEXP.text.trim() || '0').
                replace(/\$\$ExtraProperties\$\$/g, textExtraProperties.text.trim()/* || 'undefined'*/)
            ;


            console.debug(data);



            try {
                if(checkResult)
                    eval(data);
            }
            catch(e) {
                return [-1, data, e];
            }

            return [true, data, null];
        }

        function compileAndShowResult() {
            const result = _private.compile(true);
            let errorMsg;

            console.debug('[FightRoleVisualEditor]compile:', _private.filepath, result);

            switch(result[0]) {
            case true:
                break;
            case false:
                errorMsg = result[2].toString();
                break;
            case -1:
            default:
                errorMsg = '错误：' + result[2].toString() + '<BR>请检查各参数';
            }

            if(errorMsg)
                $dialog.show({
                    Msg: errorMsg,
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        //root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();
                        //root.forceActiveFocus();
                    },*/
                });

            if(result[1] !== null)
                //let ret = $Frame.sl_fileWrite(result, _private.filepath + '.js', 0);
                root.sg_compile(result[1]);

            return result;
        }


        function close() {
            $dialog.show({
                Msg: '退出前需要编译和保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    const result = _private.compileAndShowResult();
                    if(result[0] === false)
                        return;

                    saveData();

                    if(result[0])
                        sg_close();

                    ///root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();
                },
                OnDiscarded: ()=>{
                    $dialog.close();
                    //root.forceActiveFocus();
                },
            });
        }



        property var jsLoader: new $GlobalJS.JSLoader(root)


        //创建的组件缓存
        property var arrCacheComponent: []

        //保存文件路径
        property string filepath

        property string strTemplate: `

//闭包写法
const data = (function() {



    //独立属性，用 combatant 来引用；会保存到存档中；
    //params：使用对象{RID:xxx, Params: 。。。}创建时的对象参数。
    const $createData = function(params) { //创建战斗角色时的初始数据，可忽略（在战斗脚本中写）；
        return {
            $name: '$$name$$', $properties: {HP: [$$HP$$,$$HP$$,$$HP$$], MP: [$$MP$$, $$MP$$], attack: $$attack$$, defense: $$defense$$, power: $$power$$, luck: $$luck$$, speed: $$speed$$}, $avatar: '$$avatar$$', $size: [$$size$$], $color: 'white', $skills: $$skills$$, $goods: $$goods$$, $equipment: $$equipment$$, $money: $$money$$, $EXP: $$EXP$$, $$ExtraProperties$$
        };
    };


    //公用属性，可用 combatant.$commons 或 combatant 来引用；
    const $commons = {

        //$name: '$$name$$', $properties: {HP: [$$HP$$,$$HP$$,$$HP$$], MP: [$$MP$$, $$MP$$], attack: $$attack$$, defense: $$defense$$, power: $$power$$, luck: $$luck$$, speed: $$speed$$}, $avatar: '$$avatar$$', $size: [$$size$$], $color: 'white', $skills: $$skills$$, $goods: $$goods$$, $equipment: $$equipment$$, $money: $$money$$, $EXP: $$EXP$$, $$ExtraProperties$$


        //动作包含的 精灵名（可以为函数或对象）
        $actions: function(combatant) {
            return {$$actions$$};
        },



        //角色单独的升级链脚本和升级算法（方法1：这里定义 levelUpScript、levelAlgorithm 或 levelInfos；方法2：载入level_chain.js的）；

        /*/方法1（优先）：
        //角色单独的升级链脚本；
        //  level为0表示检测升级，否则表示直接升级level级；
        levelUpScript: function*(combatant, level=0) {
        },

        //targetLevel级别对应需要达到的 各项属性 的算法
        levelAlgorithm: function(combatant, targetLevel) {
            if(targetLevel <= 0)
                return 0;

            let level = 1;  //级别
            let exp = 10;   //级别的经验

            while(level < targetLevel) {
                exp = exp * 2;
                ++level;
            }

            return {Conditions: {EXP: exp}, //支持'HP,2': xxx，不能有空格
                Properties: {
                    HP: {Type: 1, Value: combatant.$properties.HP[2] * 0.1},
                    MP: {Type: 2, Value: 1.1},
                    attack: {Type: 1, Value: combatant.$properties.attack * 0.1},
                    defense: {Type: 2, Value: 1.1},
                    power: {Type: 3, Value: combatant.$properties.power * 1.1},
                    luck: {Type: 3, Value: combatant.$properties.luck * 1.1},
                    speed: {Type: 3, Value: combatant.$properties.speed * 1.1},
                },
                Skills: [],
            };
        },
        */


        //方法2：
        //levelInfos: [],
    };


    /*/方法1：
    if($Frame.sl_fileExists($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.js')))) {
        const levelChain = game.$sys.caches.jsLoader.load($GlobalJS.toURL(Qt.resolvedUrl('./level_chain.js')));
        if(levelChain.levelUpScript)$commons.levelUpScript = levelChain.levelUpScript;
        if(levelChain.levelAlgorithm)$commons.levelAlgorithm = levelChain.levelAlgorithm;
    }
    */
    //方法2：
    if($Frame.sl_fileExists($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.json')))) {
        const levelInfos = $Frame.sl_fileRead($GlobalJS.toPath(Qt.resolvedUrl('./level_chain.json')));
        try {
            $commons.levelInfos = JSON.parse(levelInfos);
        }
        catch(e) {
            console.warn('[!fight_role]level_chain.json文件不合法：', Qt.resolvedUrl('.'));
        }
    }


    return {$createData, $commons};

})();

`
    }



    Keys.onEscapePressed: function(event) {
        console.debug('[FightRoleVisualEditor]Keys.onEscapePressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[FightRoleVisualEditor]Keys.onBackPressed');
        event.accepted = true;

        _private.close();
    }
    Keys.onPressed: function(event) {
        console.debug('[FightRoleVisualEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[FightRoleVisualEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[FightRoleVisualEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[FightRoleVisualEditor]Component.onDestruction');
    }
}
