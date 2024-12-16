import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();



    function init() {
        _private.refresh();
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


    L_List {
        id: l_listMaps

        //visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onSg_canceled: {
            //visible = false;
            //loader.visible = true;
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.item.focus = true;
            sg_close();
        }

        onSg_clicked: {
            //if(!loader.item)
            //    return false;

            //if(index === 0) {
            /*if(item === "..") {
                visible = false;
                return;
            }*/


            //visible = false;
            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            //root.focus = true;
            //root.forceActiveFocus();


            textMapBlockImageURL.enabled = false;
            textMapBlockResourceName.enabled = true;

            if(index === 0) {
                dialogMapData.nCreateMapType = 1;
                dialogMapData.open();
                dialogMapData.forceActiveFocus();
                return;
            }


            let filePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "map.json";
            //let cfg = File.read(filePath);
            let cfg = FrameManager.sl_fileRead(filePath);
            //console.debug("[mainMapEditor]filePath：", filePath);

            if(!cfg)
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            //loader.setSource("./MapEditor.qml", {});
            //loader.item.openMap(cfg);


            dialogMapData.nCreateMapType = 2;

            dialogMapData.mapData = cfg;

            textMapWidth.text = cfg.MapSize[0];
            textMapHeight.text = cfg.MapSize[1];
            textBlockWidth.text = cfg.MapBlockSize[0];
            textBlockHeight.text = cfg.MapBlockSize[1];
            textMapBlockImageURL.text = GameMakerGlobal.mapResourceURL(cfg.MapBlockImage[0]);
            textMapBlockResourceName.text = cfg.MapBlockImage[0];
            //textMapBlockResourceName.text = textMapBlockImageURL.text.slice(textMapBlockImageURL.text.lastIndexOf("/") + 1);

            dialogMapData.open();
            dialogMapData.forceActiveFocus();
        }

        onSg_removeClicked: {
            if(index === 0) {
                return;
            }


            let dirUrl = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + item;

            dialogCommon.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？',
                Buttons: Dialog.Yes | Dialog.Cancel,
                OnAccepted: ()=>{
                    console.debug("[mainMapEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), FrameManager.sl_dirExists(dirUrl), FrameManager.sl_removeRecursively(dirUrl));
                    removeItem(index);

                    l_listMaps.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listMaps.forceActiveFocus();
                },
            });
        }
    }



    Dialog {
        id: dialogMapData

        //1新建；2打开
        property int nCreateMapType: 1
        //1图片，2素材
        //property int nChoiceType: 0

        property var mapData: ({})



        anchors.centerIn: parent
        width: parent.width * 0.9
        //height: 600

        title: "地图数据"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        ColumnLayout {
            width: parent.width

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Label {
                    text: qsTr("地图大小（宽*高）：")
                }

                TextField {
                    id: textMapWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
                Label {
                    text: qsTr("*")
                }
                TextField {
                    id: textMapHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }


            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Label {
                    text: qsTr("地图块大小（宽*高）：")
                }

                TextField {
                    id: textBlockWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                Label {
                    text: qsTr("*")
                }

                TextField {
                    id: textBlockHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }


            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    text: qsTr("路径：")
                }

                TextField {
                    id: textMapBlockImageURL
                    Layout.fillWidth: true
                    placeholderText: ""

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                TextField {
                    id: textMapBlockResourceName
                    Layout.fillWidth: true
                    placeholderText: "素材名"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                CheckBox {
                    id: checkboxSaveResource
                    checked: false
                    enabled: false
                    text: "另存"
                }
            }


            RowLayout {
                Layout.preferredWidth: parent.width * 0.6
                //Layout.maximumWidth:  parent.width * 0.6
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "选择Tile文件"
                    Layout.fillWidth: true
                    onClicked: {
                        //dialogMapData.nChoiceType = 1;
                        filedialogOpenMapBlock.open();
                        //root.forceActiveFocus();
                    }
                }
                Button {
                    text: "选择素材"
                    Layout.fillWidth: true
                    onClicked: {
                        //dialogMapData.nChoiceType = 2;

                        let path = GameMakerGlobal.mapResourcePath();

                        l_listMapBlockResource.show(path, "*", 0x002, 0x00);
                        l_listMapBlockResource.visible = true;

                        dialogMapData.visible = false;
                    }
                }

            }

            RowLayout {
                //Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width

                Label {
                    id: labelDialogTips
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter

                    wrapMode: Label.WrapAnywhere
                    color: "red"
                    text: ""
                }
            }
        }

        onAccepted: {
            //地图块路径 操作

            /*if(textMapBlockImageURL.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "路径不能为空";
                Platform.sl_showToast("路径不能为空");
                return;
            }
            */
            if(textMapBlockResourceName.text.length === 0) {
                open();
                //visible = true;
                labelDialogTips.text = "资源名不能为空";
                Platform.sl_showToast("资源名不能为空");
                return;
            }
            //系统图片
            //if(dialogMapData.nChoiceType === 1) {
            if(checkboxSaveResource.checked) {
                //filepath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapResourceDirName + GameMakerGlobal.separator + textMapBlockResourceName.text;
                let ret = FrameManager.sl_fileCopy(GlobalJS.toPath(textMapBlockImageURL.text), GameMakerGlobal.mapResourcePath(textMapBlockResourceName.text), false);
                if(ret <= 0) {
                    open();
                    labelDialogTips.text = "拷贝到资源目录失败";
                    Platform.sl_showToast("拷贝到资源目录失败");
                    //console.debug("[mainMapEditor]Copy ERROR:", filepath);

                    //root.forceActiveFocus();
                    return;
                }

                //textMapBlockImageURL.text = GlobalJS.toURL(filepath);
            }
            else {  //资源图库
                //console.debug("ttt2:", filepath);

                //textMapBlockImageURL.text = filepath;

                //console.debug("ttt", textMapBlockImageURL.text, Qt.resolvedUrl(textMapBlockImageURL.text))
            }

            textMapBlockImageURL.text = GameMakerGlobal.mapResourceURL(textMapBlockResourceName.text);

            if(!FrameManager.sl_fileExists(GlobalJS.toPath(textMapBlockImageURL.text))) {
                open();
                //visible = true;
                labelDialogTips.text = "图块路径错误或文件不存在:" + GlobalJS.toPath(textMapBlockImageURL.text);
                Platform.sl_showToast("图块路径错误或文件不存在");
                return;
            }



            loader.source = './MapEditor.qml';
        }
        onRejected: {
            textMapBlockImageURL.text = "";
            textMapBlockImageURL.enabled = false;
            textMapBlockResourceName.text = "";
            textMapBlockResourceName.enabled = true;

            labelDialogTips.text = "";


            l_listMaps.forceActiveFocus();


            //console.log("Cancel clicked");
            /*鹰：这点组件树的focus有点奇怪
            let p = dialogMapData;
            let n = 20;
            while(n > 0 && p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
                --n;
            }

            root.focus = true;
            dialogMapData.focus = true;
            root.parent.parent.focus = true;
            console.debug(root.parent.parent.focus);


            p = dialogMapData;
            while(p) {
                console.debug(p, p.focus, p.parent);
                //p.focus = true;
                p = p.parent;
            }*/
        }

    }


    Dialog1.FileDialog {
        id: filedialogOpenMapBlock

        visible: false

        title: "选择地图块文件"
        //folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png *.bmp)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.focus = true;
            //root.forceActiveFocus();

            console.debug("[mainMapEditor]You chose: " + fileUrl, fileUrls);


            if(Qt.platform.os === "android")
                textMapBlockImageURL.text = Platform.sl_getRealPathFromURI(fileUrl);
            else
                textMapBlockImageURL.text = FrameManager.sl_urlDecode(fileUrl);

            textMapBlockResourceName.text = textMapBlockImageURL.text.slice(textMapBlockImageURL.text.lastIndexOf("/") + 1);


            textMapBlockImageURL.enabled = true;
            textMapBlockResourceName.enabled = true;


            checkboxSaveResource.checked = true;
            checkboxSaveResource.enabled = false;


            //鹰（Image的BUG）：3/3改这里
            //canvasMapBlock.loadImage(fileUrl);
            ////canvasMapBlock.requestPaint(); //重新绘图


            //console.log("You chose: " + fileDialog.fileUrls);
            //Qt.quit();
        }
        onRejected: {
            //root.forceActiveFocus();


            //sg_close();
            console.debug("[mainMapEditor]onRejected")
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }


    L_List {
        id: l_listMapBlockResource

        visible: false

        color: Global.style.backgroundColor
        colorText: Global.style.primaryTextColor


        onSg_clicked: {
            //let filepath = GameMakerGlobal.config.strProjectRootPath + "/" + GameMakerGlobal.config.strCurrentProjectName + "/" + GameMakerGlobal.config.strMapResourceDirName + "/" + item;

            textMapBlockImageURL.text = GameMakerGlobal.mapResourceURL(item);
            textMapBlockResourceName.text = item;
            //console.debug("[mainMapEditor]List Clicked::", textMapBlockImageURL.text)

            textMapBlockImageURL.enabled = false
            textMapBlockResourceName.enabled = true;


            checkboxSaveResource.checked = false;
            checkboxSaveResource.enabled = false;


            dialogMapData.visible = true;


            //let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_fileRead(fileUrl);


            visible = false;
            //root.focus = true;
            //root.forceActiveFocus();

            console.debug("[mainMapEditor]filepath", textMapBlockImageURL.text);
        }

        onSg_canceled: {
            dialogMapData.visible = true;

            visible = false;
            //loader.visible = true;
            //root.focus = true;
            //root.forceActiveFocus();
            //loader.item.focus = true;
        }

        onSg_removeClicked: {
            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Resources" + GameMakerGlobal.separator + "Maps" + GameMakerGlobal.separator + item;

            dialogCommon.show({
                Msg: '确认删除 <font color="red">' + item + '</font> ？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    console.debug("[mainMapEditor]删除地图资源：" + path, Qt.resolvedUrl(path), FrameManager.sl_fileDelete(path));
                    removeItem(index);

                    l_listMapBlockResource.forceActiveFocus();
                },
                OnRejected: ()=>{
                    l_listMapBlockResource.forceActiveFocus();
                },
            });
        }
    }



    /*Dialog1.Dialog {
        id: fileDialogSave
        visible: false
          title: "Choose a date"
          standardButtons: Dialog1.StandardButton.Save | Dialog1.StandardButton.Cancel

          onAccepted: console.log("Saving the date ")

      }*/

    /*Dialog {
        id: dialogMapName
        title: "请输入地图数据"
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            //let cfg = File.read(fileUrl);
            let cfg = FrameManager.sl_fileRead(fileUrl);
            //console.debug("cfg", cfg);

            if(!cfg)
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            loader.setSource("./MapEditor.qml", {});
            loader.item.openMap(cfg);
        }
        onRejected: {
            root.forceActiveFocus();


            //console.log("Cancel clicked");
        }

        ColumnLayout {
            width: parent.width

            RowLayout {
                width: parent.width
                Text {
                    text: qsTr("地图块大小（宽*高）：")
                }

                TextField {
                    id: textBlockWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }

                Text {
                    text: qsTr("*")
                }

                TextField {
                    id: textBlockHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "32"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }

            RowLayout {
                width: parent.width
                Text {
                    text: qsTr("地图大小（宽*高）：")
                }

                TextField {
                    id: textMapWidth
                    Layout.fillWidth: true
                    placeholderText: "宽"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
                Text {
                    text: qsTr("*")
                }
                TextField {
                    id: textMapHeight
                    Layout.fillWidth: true
                    placeholderText: "高"
                    text: "50"

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
        }
    }*/



    /*Dialog1.FileDialog {
        id: filedialogOpenMap
        title: "选择地图文件"
        selectMultiple: false
        //folder: shortcuts.home
        folder: GlobalJS._FixLocalPath_W(Platform.externalDataPath + GameMakerGlobal.separator + "Map")
        nameFilters: [ "Json files (*.json *.map *.jsn)", "All files (*)" ]
        selectExisting: true
        selectFolder: false
        visible: false
        onAccepted: {
            loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            loader.item.forceActiveFocus();


            let cfg = File.read(fileUrl);
            //let cfg = FrameManager.sl_fileRead(fileUrl);
            console.debug("cfg", cfg, fileUrl);

            if(!cfg)
                return false;
            cfg = JSON.parse(cfg);
            //console.debug("cfg", cfg);
            //loader.setSource("./MapEditor.qml", {});
            loader.item.openMap(cfg);
        }
        onRejected: {
            root.forceActiveFocus();
        }
        Component.onCompleted: {
        }
    }
    */



    Loader {
        id: loader

        visible: false
        focus: true

        anchors.fill: parent


        //source: "./MapEditor.qml"
        asynchronous: true



        Connections {
            target: loader.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                //!!!!!!作用：绕过 多次载入地图编辑器时黑屏 的问题
                //  经详细排查，貌似是内存不足（创建新图层引起的），但奇怪的是，即使destroy成功，内存也不会释放，但这个Loader释放后就正常了。
                //  游戏中因为没有创建新图层所以不会有问题。
                loader.source = '';
            }
        }


        onStatusChanged: {
            console.debug('[mainMapEditor]loader:', source, status);

            if(status === Loader.Ready) {
            }
            else if(status === Loader.Error) {
                setSource('');

                showBusyIndicator(false);
            }
            else if(status === Loader.Null) {
                visible = false;

                //root.focus = true;
                root.forceActiveFocus();


                _private.refresh();
            }
            else if(status === Loader.Loading) {
                showBusyIndicator(true);
            }
            if(status !== Loader.Loading) {
                clearComponentCache();
                trimComponentCache();
            }
        }

        onLoaded: {
            console.debug("[mainMapEditor]loader onLoaded");

            try {
                //_private.refresh();

                //创建地图工作

                if(dialogMapData.nCreateMapType === 1) {
                    //loader.setSource("./MapEditor.qml", {});
                    //item.newMap({MapBlockSize: [30, 30], MapSize: [20, 20]});
                    loader.item.newMap({MapSize: [parseInt(textMapWidth.text), parseInt(textMapHeight.text)],
                                                 MapBlockSize: [parseInt(textBlockWidth.text), parseInt(textBlockHeight.text)],
                                                 MapBlockImage: [textMapBlockResourceName.text]
                                             });

                    //loader.item.testFresh();

                }
                else if(dialogMapData.nCreateMapType === 2) {

                    dialogMapData.mapData.MapSize[0] = textMapWidth.text;
                    dialogMapData.mapData.MapSize[1] = textMapHeight.text;
                    dialogMapData.mapData.MapBlockSize[0] = textBlockWidth.text;
                    dialogMapData.mapData.MapBlockSize[1] = textBlockHeight.text;
                    dialogMapData.mapData.MapBlockImage[0] = textMapBlockResourceName.text;

                    loader.item.openMap(dialogMapData.mapData);

                }

                textMapBlockImageURL.text = "";
                textMapBlockImageURL.enabled = false;
                textMapBlockResourceName.text = "";
                textMapBlockResourceName.enabled = true;

                labelDialogTips.text = "";



                //应用程序失去焦点时，只有loader先获取焦点（必须force），loader里的组件才可以获得焦点（也必须force），貌似loader和它的item的forceFocus没有先后顺序（说明loader设置focus后会自动再次设置它子组件focus为true的组件的focus为true）；
                //focus = true;
                forceActiveFocus();

                //item.focus = true;
                if(item.forceActiveFocus)
                    item.forceActiveFocus();

                if(item.init)
                    item.init();

                visible = true;


                //console.debug("Ok clicked");
            }
            catch(e) {
                throw e;
            }
            finally {
                //busyIndicator.running = false;
                showBusyIndicator(false);
            }
        }
    }



    //配置
    QtObject {
        id: _config
    }

    QtObject {
        id: _private

        function refresh() {

            //console.debug(filedialogOpenMap.shortcuts, JSON.stringify(filedialogOpenMap.shortcuts))
            //filedialogOpenMap.folder = GlobalJS._FixLocalPath_W(Platform.externalDataPath + GameMakerGlobal.separator + "Map")
            //filedialogOpenMap.folder = filedialogOpenMap.shortcuts.pictures;
            //filedialogOpenMap.setFolder(filedialogOpenMap.shortcuts.pictures);
            //console.debug("filedialogOpenMap.folder:", filedialogOpenMap.folder)
            //filedialogOpenMap.open();


            //console.debug(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator)

            //l_listMaps.show(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator, "*", 0x001 | 0x2000, 0x00);
            let list = FrameManager.sl_dirList(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator, "*", 0x001 | 0x2000 | 0x4000, 0x00)
            list.unshift('【新建地图】');
            l_listMaps.removeButtonVisible = {0: false, '-1': true};
            l_listMaps.show(list);
            //l_listMaps.visible = true;
            //l_listMaps.focus = true;

            //console.debug("path:", GlobalJS._FixLocalPath_W(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName))
            //console.debug("path:", Qt.resolvedUrl(Platform.externalDataPath));
            //console.debug("path:", Qt.resolvedUrl(GlobalJS._FixLocalPath_W(Platform.externalDataPath)));
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[mainMapEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[mainMapEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainMapEditor]Keys.onPressed:", event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug("[mainMapEditor]Keys.onReleased:", event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        console.debug("[mainMapEditor]Component.onCompleted");
    }
    Component.onDestruction: {
        console.debug("[mainMapEditor]Component.onDestruction");
    }
}
