import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();



    function $load(...params) {
        _private.refresh();
    }



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: $Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: $Global.style.backgroundColor
        //radius: 9
    }


    ColumnLayout {
        anchors.fill: parent

        L_List {
            id: l_listGoods

            //visible: false
            //anchors.fill: parent
            //width: parent.width
            //height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: $Global.style.backgroundColor
            colorText: $Global.style.primaryTextColor


            onSg_canceled: {
                //close();
                //loader.visible = true;
                //root.focus = true;
                //root.forceActiveFocus();
                //loader.item.focus = true;

                root.sg_close();
            }

            onSg_clicked: {
                _private.openItem(item);
            }

            onSg_removeClicked: {
                const dirPath = $GameMakerGlobal.goodsPath(item);
                console.debug('[mainGoodsEditor]删除：', dirPath, $Frame.sl_dirExists(dirPath), );

                $dialog.show({
                    Msg: '确认删除 <font color="red">' + item + '</font> ？',
                    Buttons: Dialog.Ok | Dialog.Cancel,
                    OnAccepted: function() {
                        if($Frame.sl_removeRecursively(dirPath))
                            removeItem(index);

                        //l_listGoods.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        //l_listGoods.forceActiveFocus();
                    },
                });
            }
        }

        RowLayout {
            //Layout.preferredWidth: root.width * 0.96
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50

            Button {
                id: buttonCreate

                //Layout.preferredWidth: 60

                text: '新　建'
                onClicked: {
                    _private.openItem(null);
                }
            }

            Button {
                id: buttonCompileAll

                //Layout.preferredWidth: 60

                text: '编译全部可视化'
                onClicked: {
                    $dialog.show({
                        Msg: '确定？<BR>注意：该操作会覆盖所有目标脚本，且不可逆！',
                        Buttons: Dialog.Ok | Dialog.Cancel,
                        OnAccepted: function() {
                            //l_listGoods.forceActiveFocus();
                            //let count = 0;
                            const successed = [];
                            const failed = [];
                            const noCompile = [];
                            const list = $Frame.sl_dirList($GameMakerGlobal.goodsPath(), [], 0x001 | 0x2000 | 0x4000, 0x0);
                            for(const tn of list) {
                                const path = $GameMakerGlobal.goodsPath(tn) + '/';
                                if(!$Frame.sl_fileExists(path + 'goods.vjs')) {
                                    //console.debug('[mainGoodsEditor]没有可视化文件:', tn);
                                    noCompile.push(tn);
                                    continue;
                                }

                                goodsVisualEditor.init(path + 'goods.vjs');
                                const result = goodsVisualEditor.compile(false);
                                console.debug('[mainGoodsEditor]result:', result);
                                if(result[1]) {
                                    $Frame.sl_fileWrite(result[1], path + 'goods.js', 0);
                                    //++count;
                                    successed.push(tn);
                                }
                                else {
                                    failed.push(tn);
                                    console.warn('[!mainGoodsEditor]ERROR:', result[2].toString());
                                }
                            }

                            $dialog.show({
                                Msg: '编译成功%1个脚本，失败%2个脚本，没有编译%3个脚本'
                                    .arg(successed.length).arg(failed.length).arg(noCompile.length),
                                Buttons: Dialog.Ok,
                                OnRejected: ()=>{
                                },
                            });
                            console.info('[mainGoodsEditor]编译成功：%1，失败：%2，没有编译：%3'.arg(successed).arg(failed).arg(noCompile));
                        },
                        OnRejected: ()=>{
                            //l_listGoods.forceActiveFocus();
                        },
                    });
                }
            }
        }
    }



    L_Loader {
        id: loader


        visible: false
        focus: true
        clip: true

        //anchors.fill: parent

        //active: false
        source: './GoodsEditor.qml'
        //asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                _private.refresh();

                loader.visible = false;
                //root.focus = true;
                //l_listGoods.forceActiveFocus();
            }
        }


        onStatusChanged: {
            console.debug('[mainGoodsEditor]loader onStatusChanged:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                //close();
                //active = false;
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();
            }
            else if(status === Loader.Loading) {
            }
        }

        onLoaded: {
            console.debug('[mainGoodsEditor]loader onLoaded');

            //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
            ///focus = true;
            //forceActiveFocus();

            /*if(item.$load) {
                try {
                    item.$load();
                }
                catch(e) {
                    $CommonLibJS.printException(e);
                    //console.warn('[!mainGoodsEditor]', e);
                    //throw e;
                }
                finally {
                }
            }
            */

            //visible = true;
        }
    }


    GoodsVisualEditor {
        id: goodsVisualEditor

        anchors.fill: parent

        visible: false

        /*
        Connections {
            target: goodsVisualEditor
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                goodsVisualEditor.visible = false;

                root.forceActiveFocus();
            }

            function onSg_compile(result) {
                console.debug('', result);
            }
        }
        */
    }



    QtObject {
        id: _private

        readonly property QtObject config: QtObject { //配置
            //id: _config
        }


        function refresh() {
            const list = $Frame.sl_dirList($GameMakerGlobal.goodsPath(), [], 0x001 | 0x2000 | 0x4000, 0x0);
            //list.unshift('【新建道具】');
            //l_listGoods.removeButtonVisible = {0: false, '-1': true};
            l_listGoods.show(list);

        }

        function openItem(item) {
            if(!loader.item)
                return false;

            //if(item === '..') {
            //    $list.close();
            //    return;
            //}


            /*if(index === 0) {
                item = null;
            }
            else if(index === 1) {
            }
            */


            /*
            let filePath = $GameMakerGlobal.goodsPath(item) + '/goods.json';

            console.debug('[mainGoodsEditor]filePath：', filePath);

            //let cfg = File.read(filePath);
            let cfg = $Frame.sl_fileRead(filePath);

            if(cfg) {
                cfg = JSON.parse(cfg);
                //console.debug('cfg', cfg);
                //loader.load('./MapEditor_1.qml', {});
                loader.item.openGoods(cfg);
            }
            */

            loader.item.init(item);


            //visible = false;
            loader.visible = true;
            //loader.focus = true;
            loader.forceActiveFocus();
            //loader.item.focus = true;
            //loader.item.forceActiveFocus();
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[mainGoodsEditor]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[mainGoodsEditor]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[mainGoodsEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[mainGoodsEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        console.debug('[mainGoodsEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[mainGoodsEditor]Component.onDestruction');
    }
}
