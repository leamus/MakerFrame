import QtQuick 2.14
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


    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true;
        }
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

                Label {
                    //id: tlable
                    text: '@敌人：'
                }

                TextField {
                    id: ttext

                    objectName: 'enemy'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '@敌人'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap

                    onPressAndHold: {
                        let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;

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
                TextField {
                    id: ttextParams

                    objectName: 'enemyParams'

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                    text: ''
                    placeholderText: '敌人参数（可省略）'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
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
                            text: '@背景图：'
                        }

                        TextField {
                            id: textBackground

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@背景图'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                /*let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "images.json";
                                //let cfg = File.read(filePath);
                                let cfg = FrameManager.sl_qml_ReadFile(filePath);
                                //console.debug("[mainImageEditor]filePath：", filePath);

                                if(cfg === "")
                                    return false;

                                console.debug('!!!', JSON.stringify(JSON.parse(cfg)["List"]))
                                */

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
                            text: '@背景音乐：'
                        }

                        TextField {
                            id: textMusic

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: ''
                            placeholderText: '@背景音乐'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                /*let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "music.json";
                                //let cfg = File.read(filePath);
                                let cfg = FrameManager.sl_qml_ReadFile(filePath);
                                //console.debug("[mainImageEditor]filePath：", filePath);

                                if(cfg === "")
                                    return false;
                                */

                                l_list.open({
                                    Data: GameMakerGlobal.musicResourceURL(),
                                    OnClicked: (index, item)=>{
                                        textMusic.text = item;

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
                            text: '*@逃跑率：'
                        }

                        TextField {
                            id: textRunAway

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '0.1'
                            placeholderText: '*@逃跑率'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['百分比，比如0.1', '调用系统算法'],
                                            ['0.1', 'true']];

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
                            text: '*@敌人数：'
                        }

                        TextField {
                            id: textEnemyCount

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                            text: '3'
                            placeholderText: '*@敌人数'

                            //selectByKeyboard: true
                            selectByMouse: true
                            //wrapMode: TextEdit.Wrap

                            onPressAndHold: {
                                let data = [['随机1-3个', '顺序2个', '全部顺序出现'],
                                            ['1, 3', '2', 'true']];

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

                    ColumnLayout {
                        id: layoutEnemyLayout

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: 16

                        RowLayout {
                            id: layoutFirstEnemy

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30

                            Label {
                                text: '@敌人：'
                            }

                            TextField {
                                //id: textDefense
                                objectName: 'enemy'

                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                text: ''
                                placeholderText: '@敌人'

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap

                                onPressAndHold: {
                                    let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;

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
                            TextField {
                                objectName: 'enemyParams'

                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                                text: ''
                                placeholderText: '敌人参数（可省略）'

                                //selectByKeyboard: true
                                selectByMouse: true
                                //wrapMode: TextEdit.Wrap
                            }

                            ColorButton {
                                text: '增加'

                                onButtonClicked: {
                                    let c = comp.createObject(layoutEnemyLayout);
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
            //Layout.preferredWidth: parent.width
            //Layout.preferredHeight: parent.height
            //Layout.fillHeight: true
            //Layout.fillWidth: true


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

                    console.debug(_private.filepath, jsScript);
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
  1、先点击 命令，然后 填写参数 或者 长按编辑框（大部分可以长按）选择参数，再点击 追加（到最后）或 插入（到当前指令上面）来完成指令编写；
  2、每次打开可视化编辑界面，会自动载入保存的脚本，也可以手动点击 载入 按钮来重新载入；
  3、编写完成后可以点击 保存按钮 来保存当前脚本；点击 编译 来使用当前脚本（此时上一层界面会自动替换为编译后的脚本）；
功能说明：
  1、逃跑率：0~1的小数（表示百分比），填true表示使用系统自带的算法来计算（和速度、幸运有关）；
  2、装备：战斗人物初始装备；
  3、敌人数：1个数字（顺序排列敌人） 或 2个数字（逗号分隔，表示范围随机） 或 true（顺序出现所有敌人）；
  4、敌人参数：可以省略，也可以填对象格式（修改敌人的参数）；
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
            let enemies = [];

            let enemyTextFields = FrameManager.sl_qml_FindChildren(layoutEnemyLayout, 'enemy');
            let enemyParamsTextFields = FrameManager.sl_qml_FindChildren(layoutEnemyLayout, 'enemyParams');

            for(let tt in enemyTextFields) {
                //console.debug(tt.text);
                enemies.push([enemyTextFields[tt].text.trim(), enemyParamsTextFields[tt].text.trim()]);
            }


            let data = {};
            data.BackgroundImage = textBackground.text.trim();
            data.RunAway = textRunAway.text.trim();
            data.EnemyCount = textEnemyCount.text.trim();
            data.Music = textMusic.text.trim();
            data.Enemies = enemies;
            //data.EnemiesParams = enemiesParams;


            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify({Version: '0.6', Data: data}), _private.filepath, 0);

        }


        function loadData() {
            let filePath = _private.filepath;

            //let data = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(filePath);
            console.debug("[GameVisualFightScript]filePath：", filePath);
            //console.exception("????")

            if(data) {
                data = JSON.parse(data);
                data = data.Data;
            }
            else {
                data = {RunAway: '0.1', EnemyCount: '1, 3', Enemies: []};
            }



            for(let tc of _private.arrCacheComponent) {
                tc.destroy();
            }
            _private.arrCacheComponent = [];

            for(let tt in data.Enemies) {
                let enemyComp;
                if(tt === '0') {
                    enemyComp = layoutFirstEnemy;
                }
                else {
                    enemyComp = comp.createObject(layoutEnemyLayout);
                    _private.arrCacheComponent.push(enemyComp);
                }
                let enemyTextField = FrameManager.sl_qml_FindChild(enemyComp, 'enemy');
                let enemyParamsTextField = FrameManager.sl_qml_FindChild(enemyComp, 'enemyParams');

                enemyTextField.text = data.Enemies[tt][0];
                enemyParamsTextField.text = data.Enemies[tt][1];
            }


            textBackground.text = data.BackgroundImage || '';
            textRunAway.text = data.RunAway || '';
            textEnemyCount.text = data.EnemyCount || '';
            textMusic.text = data.Music || '';

        }


        //编译（结果为字符串）
        function compile() {

            let strEnemies = '';
            let enemyTextFields = FrameManager.sl_qml_FindChildren(layoutEnemyLayout, 'enemy');
            let enemyParamsTextFields = FrameManager.sl_qml_FindChildren(layoutEnemyLayout, 'enemyParams');

            //console.debug(enemyTextFields);
            for(let tt in enemyTextFields) {
                //console.debug(tt.text.trim());
                strEnemies += "{RId: '%1', %2}, ".arg(enemyTextFields[tt].text.trim()).arg(enemyParamsTextFields[tt].text.trim());
            }

            /*console.debug('------------', layoutEnemyLayout.children);
            for(let tc in layoutEnemyLayout.children) {
                console.debug(tc);
            }*/

            //layoutEnemyLayout.findChildren('enemy');



            //let filePath = "fight_script.tpl";

            /*let data = File.read(filePath);
            console.debug("filePath：", filePath);
            console.debug("data:", data);
            */

            //let tpl = FrameManager.sl_qml_ReadFile(filePath);
            //console.debug('tpl:', tpl);

            let enemyCount = textEnemyCount.text.trim().split(',');
            if(enemyCount.length === 2)
                enemyCount = `[${enemyCount[0].trim()}, ${enemyCount[1].trim()}]`;
            else
                enemyCount = enemyCount[0].trim();

            let data = strTemplate.
                replace(/\$\$backgroundImage\$\$/g, textBackground.text.trim()).
                replace(/\$\$runAway\$\$/g, textRunAway.text.trim()).
                replace(/\$\$enemyCount\$\$/g, enemyCount).
                replace(/\$\$music\$\$/g, textMusic.text.trim()).
                replace(/\$\$enemiesData\$\$/g, strEnemies)
            ;

            console.debug('data:', data);

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



    //独立属性，用 fightData 来引用；
    let $createData = function(params) {
        /*return {
            //背景图
            $backgroundImage: '$$backgroundImage$$',
            $music: '$$music$$',
            //是否可以逃跑；true则调用 通用逃跑算法；0~1则为概率逃跑；false为不能逃跑
            $runAway: $$runAway$$,
            $enemyCount: $$enemyCount$$,	//为数组（m-n）的随机排列，为数字则依次按顺序排列，如果为true则表示按顺序排列
            //RId是战斗角色资源名（必写），$goods是携带道具（可掉落），其他属性会覆盖战斗角色属性
            $enemiesData: [
$$enemiesData$$
            ],
        }*/
    };


    //公用属性，用 fightData.$commons 或 fightData 来引用；
    let $commons = {

        //背景图
        $backgroundImage: '$$backgroundImage$$',
        $music: '$$music$$',
        //是否可以逃跑；true则调用 通用逃跑算法；0~1则为概率逃跑；false为不能逃跑
        $runAway: $$runAway$$,
        $enemyCount: $$enemyCount$$,	//为数组（m-n）的随机排列，为数字则依次按顺序排列，如果为true则表示按顺序排列
        //RId是战斗角色资源名（必写），$goods是携带道具（可掉落），其他属性会覆盖战斗角色属性
        $enemiesData: [
$$enemiesData$$
        ],


        FightInitScript: function *(teams, fightData) {
            //yield fight.msg('战斗初始化事件', 0);
        },

        FightStartScript: function *(teams, fightData) {
            //yield fight.msg('战斗开始事件');
        },

        FightRoundScript: function *(round, step, teams, fightData) {
            switch(step) {  //step：0，回合开始；1，选择完毕
            case 0:
                //yield fight.msg('第%1回合'.arg(round));
                break;
            case 1:
                break;
            }
        },

        FightEndScript: function *(r, step, teams, fightData) {
            //step：为0是战斗结束时调用；为1时返回地图时调用
            //r中包含：result（战斗结果）、money和exp
            //  这里可以修改r，然后会传递给 通用战斗结束函数
            //console.debug(JSON.stringify(r));
            //r.result = 666;

            switch(step) {  //step：0，回合开始；1，选择完毕
            case 0:
                yield fight.msg('战斗结束事件：' + r.result);
                break;
            case 1:
                yield fight.msg('返回地图事件');
                break;
            }
        },
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

