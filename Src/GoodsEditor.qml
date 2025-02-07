import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


import './Core'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();


    function init(goodsName) {

        if(goodsName) {
            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName + GameMakerGlobal.separator + goodsName + GameMakerGlobal.separator + 'goods.js';
            //let data = File.read(filePath);
            //console.debug('[GoodsEditor]filePath：', filePath);

            let data = FrameManager.sl_fileRead(filePath);

            if(data) {
                //data = JSON.parse(data);
                //console.debug('data', data);
                _private.strSavedName = textGoodsName.text = goodsName;
                notepadGoodsScript.setPlainText(data);
                notepadGoodsScript.toBegin();

                return;
            }
        }

        _private.strSavedName = textGoodsName.text = '';

        notepadGoodsScript.setPlainText("
//闭包写法
let data = (function() {



    //独立属性，用 goods 来引用；会保存到存档中；
    //params：使用对象{RID:xxx, Params: 。。。}创建道具时的对象参数。
    let $createData = function (params) {

        return {
            //游戏中显示的 名称和描述
            $name: '零食',
            $description: '好吃的（能刷钱），血+10',

            $price: [20, 30],	//买卖金额，false表示不能买卖
            $type: 2,	//1为装备；2为普通使用；3为战斗使用；4为剧情类
            $position: false,	//装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
            $skills: false,	//道具带的技能（此时道具作为装备，且为 武器 时可用）
            $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

            $fight: ['恢复血量'],    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

            $color: '', //文字颜色
            $image: 'goods.jpg', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
            $size: [50, 50],    //图像大小
        };
    };



    //公用属性，用 goods.$commons 或 goods 来引用；
    //可以用 计算属性，格式：get $description() {return this.xxx;},
    let $commons = {

        /*
        //游戏中显示的 名称和描述
        $name: '零食',
        $description: '好吃的（能刷钱），血+10',
        //get $description() {return this.xxx;},

        $price: [20, 30],	//买卖金额，false表示不能买卖
        $type: 2,	//1为装备；2为普通使用；3为战斗使用；4为剧情类
        $position: false,	//装备位置；武器是特殊位置，普通攻击时会使用 武器 的 skills
        $skills: false,	//道具带的技能（此时道具作为装备，且为 武器 时可用）
        $stackable: true,    //是否可叠加（注意：如果做 随机属性的道具，则最好设置为false，表示每个道具都是单独的，不会叠加）

        $fight: ['恢复血量'],    //战斗中点 使用 的 对应触发的技能（可以不用技能，只用脚本）

        $color: '', //文字颜色
        $image: 'goods.jpg', //图片相对路径（相对于Resources/Images路径，../../表示项目根路径）
        $size: [50, 50],    //图像大小
        */


        /*/装备效果
        //  注意：$$propertiesWithExtra为临时增加，$properties为永久增加，所以可以用$properties作为参考，来修改$$propertiesWithExtra）；
        $equipEffectAlgorithm: function(goods, combatant) {
            combatant.$$propertiesWithExtra.HP[0] += 10;
        },*/
        $equipEffectAlgorithm: null,

        //使用脚本
        $useScript: function *(goods, combatant) {
            if(combatant === undefined || combatant === null)
                combatant = yield game.menu('选择角色', game.fighthero(-1, 1), true);	//选择角色

            game.addprops(combatant, {HP: [10, 5]});

            //yield game.msg('你用西瓜刀切了两片西瓜开始吆喝：好甜的西瓜啊，一斤2块5啦', 50);
            //console.debug(goods.$rid, combatant);

            game.removegoods(goods, 1);	//背包道具-1
            return -1;
        },
        //这样写不会显示 使用 选项
        //$useScript: null,

        /*/装备脚本
        $equipScript: function *(goods, combatant) {
            if(combatant === undefined || combatant === null)
                combatant = yield game.menu('选择角色', game.fighthero(-1, 1), true);	//选择角色
            game.getgoods(game.unload(combatant, goods.$position));	//脱下装备并放入背包
            game.equip(combatant, goods, null);	//装备；使用 goodsId 的 position 属性来装备；
            game.removegoods(goods, 1);	//背包道具-1

            //yield game.msg('西瓜刀在手，打遍天下无敌手');
            console.debug(goods, c);
        },*/
        //这样写不会显示 装备 选项
        $equipScript: null,


        //战斗脚本；分别是：选择道具脚本；检测是否可用；完成代码；
        $fightScript: {
            //选择道具时脚本；如果为null自动调用 goods.$fight[0] 的
            /*$choiceScript: function *(goods, combatant) {
                //调用技能的
                let skill = goods.$fight[0];
                yield* skill.$choiceScript(skill, combatant);

                //选择敌方
                //let r = yield* fight.$sys.gfChoiceSingleCombatantSkill(goods, combatant, {TeamFlags: 0b10, Filter: function(targetCombatant, combatant){if(targetCombatant.$$propertiesWithExtra.HP[0] > 0)return true;return false;}});
                //return r;
            },
            */
            $choiceScript: null,
            //是否可用；如果为null自动调用 goods.$fight[0] 的
            $check: function (goods, combatant, stage) {
                //调用技能的
                let skill = goods.$fight[0];
                return skill.$check(skill, combatant, stage);
            },

            //完成代码（收尾用）；skill的playScript执行完毕会执行它
            $completeScript: function *(goods, combatant) {
                game.removegoods(goods, 1);	//背包道具-1
                //yield fight.msg('...');
                return;
            },
        },
        //这样写不会显示 战时 选项
        //$fightScript: null,
    };



    return ({$createData, $commons});

})();

"
        );

        notepadGoodsScript.toBegin();

    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }


    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Button {
                //Layout.fillWidth: true
                //Layout.preferredHeight: 70

                text: '查'

                onClicked: {
                    let e = GlobalJS.checkJSCode(FrameManager.sl_toPlainText(notepadGoodsScript.textDocument));

                    if(e) {
                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: e,
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                root.forceActiveFocus();
                            },
                        });

                        return;
                    }

                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '恭喜，没有语法错误',
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });

                    return;
                }
            }

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.fillWidth: true
                text: '道具脚本'
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }

            Button {
                id: buttonVisual

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: 'V'
                onClicked: {
                    if(!_private.strSavedName) {
                        rootWindow.aliasGlobal.dialogCommon.show({
                            Msg: '请先保存',
                            Buttons: Dialog.Yes,
                            OnAccepted: function() {
                                root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                root.forceActiveFocus();
                            },
                        });
                        return;
                    }
                    let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'goods.vjs';

                    goodsVisualEditor.forceActiveFocus();
                    goodsVisualEditor.visible = true;
                    goodsVisualEditor.init(filePath);
                }
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            Notepad {
                id: notepadGoodsScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                //textArea.enabled: false
                //textArea.readOnly: true
                textArea.textFormat: TextArea.PlainText
                textArea.text: ''
                textArea.placeholderText: '请输入脚本代码'

                textArea.background: Rectangle {
                    //color: 'transparent'
                    color: Global.style.backgroundColor
                    border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                    border.width: parent.parent.textArea.activeFocus ? 2 : 1
                }

                bCode: true
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10


            Label {
                text: '资源名：'
            }

            TextField {
                id: textGoodsName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ''
                placeholderText: '道具名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            Button {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: '保存'
                onClicked: {
                    _private.save();
                }
            }
        }
    }



    GoodsVisualEditor {
        id: goodsVisualEditor

        anchors.fill: parent

        visible: false

        Connections {
            target: goodsVisualEditor
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                goodsVisualEditor.visible = false;

                root.forceActiveFocus();
            }

            function onSg_compile(code) {
                notepadGoodsScript.setPlainText(code);
                notepadGoodsScript.toBegin();
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private

        //保存后的名字
        property string strSavedName: ''


        function save() {
            textGoodsName.text = textGoodsName.text.trim();

            if(textGoodsName.text.length === 0) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '名称不能为空',
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        textGoodsName.text = _private.strSavedName;

                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        textGoodsName.text = _private.strSavedName;

                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.close();

                        root.forceActiveFocus();
                    },*/
                });

                return false;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;

            function fnSave() {
                let ret = FrameManager.sl_fileWrite(FrameManager.sl_toPlainText(notepadGoodsScript.textDocument), path + GameMakerGlobal.separator + textGoodsName.text + GameMakerGlobal.separator + 'goods.js', 0);

                //复制可视化
                if(_private.strSavedName) {
                    let oldFilePath = path + GameMakerGlobal.separator + _private.strSavedName + GameMakerGlobal.separator + 'goods.vjs';
                    if(textGoodsName.text !== _private.strSavedName && FrameManager.sl_fileExists(oldFilePath)) {
                        ret = FrameManager.sl_fileCopy(oldFilePath, path + GameMakerGlobal.separator + textGoodsName.text + GameMakerGlobal.separator + 'goods.vjs', true);
                    }
                }

                _private.strSavedName = textGoodsName.text;

                //root.focus = true;
                root.forceActiveFocus();
            }

            if(textGoodsName.text !== _private.strSavedName && FrameManager.sl_dirExists(path + GameMakerGlobal.separator + textGoodsName.text)) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textGoodsName.text = _private.strSavedName;

                        root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.close();

                        root.forceActiveFocus();
                    },*/
                });

                return false;
            }
            else {
                fnSave();

                return true;
            }
        }

        function close() {
            rootWindow.aliasGlobal.dialogCommon.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(save())
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
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        _private.close();

        console.debug('[GoodsEditor]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        _private.close();

        console.debug('[GoodsEditor]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[GoodsEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[GoodsEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug('[GoodsEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[GoodsEditor]Component.onDestruction');
    }
}
