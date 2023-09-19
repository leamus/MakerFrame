import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"


import "Core"


import 'GameVisualScript.js' as GameVisualScriptJS



Rectangle {
    id: root


    signal s_close();
    signal s_Compile(string code);


    property var sysCommands: ({})
    property var sysCommandsTree: []


    function clearData() {
        listmodel.clear();
        _private.listModelData.length = 0;
    }

    //载入可视化文件
    function loadData(filePath) {

        clearData();

        if(filePath)
            _private.filepath = filePath;
        else
            filePath = _private.filepath;


        //let data = File.read(filePath);
        let data = FrameManager.sl_qml_ReadFile(filePath + '.vjs');
        console.debug("[GameVisualScript]filePath：", filePath);
        //console.exception("????")

        //读取
        if(data && data !== '[]') {
            let tData = JSON.parse(data);
            if(tData.Version !== undefined && tData.Type !== undefined && tData.Data !== undefined) {
                if(_private.loadAllVisualScripts(tData.Name) < 0) {
                    dialogCommon.show({
                        Msg: '未下载【%1】命令集，请下载或选择其他命令集'.arg(tData.Name),
                        Buttons: Dialog.Yes,
                        OnAccepted: function(){
                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });

                    _private.loadAllVisualScripts(null);

                    _private.listModelData = [{"command":"函数/生成器{","params":["*start",""],"status":{"enabled":true}},{"command":"块结束}","params":[],"status":{"enabled":true}}];
                    _private.strCommandsName = '';
                }
                else {
                    _private.listModelData = tData.Data;
                    _private.strCommandsName = tData.Name || '';
                }
            }
            else {    //!!兼容旧格式
                _private.loadAllVisualScripts(null);

                _private.listModelData = tData;
                _private.strCommandsName = '';
            }
        }
        else {  //新增
            _private.loadAllVisualScripts(null);

            _private.listModelData = [{"command":"函数/生成器{","params":["*start",""],"status":{"enabled":true}},{"command":"块结束}","params":[],"status":{"enabled":true}}];
            _private.strCommandsName = '';
        }

        _private.refreshCommandTabCount();

        //console.debug("data", _private.listModelData);

        for(let d of _private.listModelData) {
            listmodel.append({Test: 1, Data: d});
        }

        //listmodel.append({Data: {command: ['移动主角', 1, 2]}});
    }

    //保存数据
    function saveData() {
        /*let data = [];
        for(let i = 0; i < listmodel.count; ++i) {
            data.push(listmodel.get(i).Data);
        }
        */

        let ret = FrameManager.sl_qml_WriteFile(JSON.stringify({Version: '0.6', Type: 1, TypeName: 'VisualScript', Name: _private.strCommandsName, Data: _private.listModelData}), _private.filepath + '.vjs', 0);

        //console.debug(_private.filepath + '.vjs', JSON.stringify(_private.listModelData))
    }


    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true;
        }
    }


    ColumnLayout {

        anchors.fill: parent

        spacing: 1



        Rectangle {
            Layout.preferredHeight: textCommandsName.implicitHeight + 10
            Layout.fillWidth: true

            color: 'lightgray'
            border.color: '#7F000000'

            Text {
                id: textCommandsName

                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: _private.strCommandsName || '系统'
                font.pointSize: 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let virtualScriptPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Plugins" + GameMakerGlobal.separator + '$Leamus' + GameMakerGlobal.separator + '$VisualScripts' + GameMakerGlobal.separator;
                    let list = FrameManager.sl_qml_listDir(virtualScriptPath, "*", 0x001 | 0x2000 | 0x4000, 0x00)
                    list.unshift('【系统】');
                    l_listCommands.showList(list);
                    l_listCommands.visible = true;
                    l_listCommands.focus = true;
                }
            }
        }

        //图层列表
        ListView {
            id: listview


            //刷新列表（已弃用，因为视图总是会在第一行）
            function refresh() {
                let n = listview.currentIndex;
                listview.model = null;
                listview.model = listmodel;
                if(listmodel.count === 0) {
                    listview.currentIndex = -1;
                }
                else if(n >= listmodel.count) {
                    listview.currentIndex = listmodel.count - 1;
                }
                else {
                    listview.currentIndex = n;
                }
            }


            Layout.minimumWidth: 100
            //Layout.maximumWidth: 100
            Layout.fillHeight: true
            Layout.fillWidth: true


            clip: true


            //snapMode: ListView.SnapOneItem
            orientation: ListView.Vertical


            //x: 300
            //anchors.fill: parent
            //width: 200
            //height: 200
            model: ListModel {
                id: listmodel
                //鹰：如果在这里定义一个ListElement，那以后insert的已有的value类型都必须按照这个类型来传递了（也不能新增key）
                //ListElement { type: 0; name1: "插入"}
            }


            //可以使用index和modelData
            //!!!注意：
            //  只有 没有定义ListElement和只有一个 key 的情况下，modelData才有值（原key也有）!!!，否则直接用 insert方法传递的 对象参数（model） 的key即可使用；
            //  传递的 对象参数（model） 中，第一层的value不能有 数组，否则会卡死（把数组放在某个对象的key里即可）
            delegate: ItemDelegate {

                width: listview.width
                height: 30
                //color: index % 2 ? "lightgreen" : "lightblue"
                //color: "lightblue"
                highlighted: listview.currentIndex === index

                /*Rectangle {
                    anchors.fill: parent
                    color: listview.currentIndex === index ? "yellow" : "white"
                    //color: listviewCanvasMap.currentIndex === index ? "lightgreen" : (canvasMapContainer.arrCanvasMap[index].visible ? "lightblue" : "lightgray")
                }*/

                contentItem: RowLayout {

                    spacing: 0

                    anchors.fill: parent

                    //颜色条
                    Rectangle {
                        height: parent.height
                        width: 6
                        color: _private.getColor(_private.arrCommandTabCount[index]) || '';
                    }

                    Label {
                        //Layout.minimumWidth: _private.listModelData.length.toString().length * 12
                        Layout.minimumWidth: 36
                        Layout.preferredHeight: parent.height

                        color: "red"
                        font.pointSize: 10
                        //horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter

                        background: Rectangle {
                            anchors.fill: parent
                            color: _private.listSelectedCommands[index] === true ? "lightgreen" : "white"
                            //color: listviewCanvasMap.currentIndex === index ? "lightgreen" : (canvasMapContainer.arrCanvasMap[index].visible ? "lightblue" : "lightgray")
                        }

                        text: index + 1 + '. '
                    }

                    //ScrollView {
                    Flickable {
                        id: tFlickable

                        //width: parent.width
                        Layout.fillWidth: true
                        height: parent.height

                        clip: true

                        boundsBehavior: Flickable.StopAtBounds
                        flickableDirection: Flickable.HorizontalFlick
                        contentWidth: tLabel.implicitWidth
                        contentHeight: parent.height

                        //显示
                        Label {
                            id: tLabel
                            //anchors.fill: parent
                            //x: 6
                            width: implicitWidth
                            height: parent.height

                            color: "red"
                            font.pointSize: 10
                            //horizontalAlignment: Label.AlignHCenter
                            verticalAlignment: Label.AlignVCenter

                            background: Rectangle {
                                anchors.fill: parent
                                color: listview.currentIndex === index ? "yellow" : "white"
                                //color: listviewCanvasMap.currentIndex === index ? "lightgreen" : (canvasMapContainer.arrCanvasMap[index].visible ? "lightblue" : "lightgray")
                            }

                            //textFormat: Label.PlainText

                            //font.strikeout: true
                            text: {
                                if(!Data)
                                    return '';


                                //命令定义
                                let tCmdString = sysCommands[Data.command];
                                //let retString = index + '. ';
                                let retString = '';

                                //循环显示每一项

                                /*/如果是第一条，则 缩进为0
                                if(index === 0) {
                                    listview.vStatic.nTabCount = 0;
                                }
                                else {  //缩进
                                    //如果向左缩进，则提前缩进（如果不是注释 && 有缩进设置 && 缩进后 >= 0）
                                    if(Data.status.enabled === true && tCmdString.command[3] !== undefined && tCmdString.command[3] < 0 && listview.vStatic.nTabCount + tCmdString.command[3] >= 0)
                                        listview.vStatic.nTabCount += tCmdString.command[3];

                                    retString += Array(listview.vStatic.nTabCount + 1).join('-');
                                }*/

                                //console.debug(index, _private.arrCommandTabCount)
                                retString += Array(_private.arrCommandTabCount[index] + 1).join('&nbsp;');


                                //是否启用（删除线）
                                if(!Data.status.enabled)
                                    retString += '<s>';
                                //显示命令和参数
                                retString += "<font color='%1'>%2</font>  ".arg(tCmdString.command[5]).arg(GlobalLibraryJS.convertToHTML(tCmdString.command[0], ['<', '>']));
                                for(let i in Data.params) {
                                    let paramValueText = Data.params[i];
                                    if(tCmdString.params[i][3] === 2) {
                                        let tIndex = tCmdString.params[i][4][1].indexOf(Data.params[i]);
                                        if(tIndex >= 0)
                                            paramValueText = tCmdString.params[i][4][0][tIndex];
                                    }

                                    retString += "<font color='%1'>%2</font>  ".arg(tCmdString.params[i][5]).arg(GlobalLibraryJS.convertToHTML(paramValueText, ['<', '>']));
                                }
                                if(!Data.status.enabled)
                                    retString += '</s>';


                                /*/向右缩进个数（如果不是注释 && 有缩进设置 && 缩进后 >= 0）
                                if(Data.status.enabled === true && tCmdString.command[3] !== undefined && tCmdString.command[3] > 0)
                                    listview.vStatic.nTabCount += tCmdString.command[3];
                                */

                                return retString;
                            }
                        }
                    }

                }


                MouseArea {
                    property int lastX: 0

                    anchors.fill: parent

                    onPressed: {
                        lastX = mouse.x;

                    }

                    onReleased: {
                        lastX = 0;
                    }

                    onClicked: {
                        listview.currentIndex = index;

                        if(_private.bMultiple === true) {
                            if(_private.listSelectedCommands[index] !== true)
                                _private.listSelectedCommands[index] = true;
                            else
                                delete _private.listSelectedCommands[index];
                            _private.listSelectedCommands = _private.listSelectedCommands;
                        }
                    }

                    //左右拖动
                    onPositionChanged: {
                        if(pressed) {
                            var d = mouse.x - lastX;

                            //不用移动
                            if(tFlickable.contentWidth < tFlickable.width)
                                ;
                            //右移过头
                            else if(-tFlickable.contentX + d >= 0)
                                tFlickable.contentX = 0;
                            //左移过头
                            else if(-tFlickable.contentX + d < -(tFlickable.contentWidth - tFlickable.width)) {
                                //tFlickable.contentX = -tFlickable.contentWidth;  //循环了
                                tFlickable.contentX = tFlickable.contentWidth - tFlickable.width;
                            }
                            else
                                tFlickable.contentX -= d;

                            lastX = mouse.x;

                            //console.debug(tFlickable.width, tFlickable.contentX);
                        }
                    }

                    //编辑
                    onDoubleClicked: {
                        _private.fCreateCommandMenu(Data.command);


                        let paramItems = FrameManager.sl_qml_FindChildren(columnlayoutParams.compParams, 'param');
                        //for(let i in columnlayoutParams.compParams.children) {
                        for(let i in paramItems) {
                            if(Data.params[i] === undefined)
                                continue;
                            paramItems[i].text = Data.params[i];
                        }

                        checkboxEnabled.checked = Data.status.enabled;

                        textParams.text = _private.createCommandText() || '';

                        if(FrameManager.sl_qml_FindChildren(columnlayoutParams.compParams, 'param').length > 0) {
                            rectParams.bEdit = true;
                            rectParams.visible = true;
                        }
                    }

                }

                onClicked: {
                }

                //不知为何手机上无法双击
                onDoubleClicked: {
                }

            }


            ScrollBar.vertical: ScrollBar { }
            //ScrollIndicator.vertical: ScrollIndicator { }


            /*Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: 'transparent'
            }
            */

        }

        //命令编辑
        Item {
            Layout.fillWidth: true
            //Layout.fillHeight: true
            Layout.preferredHeight: 60
            Layout.minimumHeight: 30
            Layout.maximumHeight: 60

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: 'red'
            }

            RowLayout {
                anchors.fill: parent

                ColorButton {
                    text: '编辑'
                    onButtonClicked: {
                        if(_private.strCurrentCommand === '')
                            return;

                        rectParams.bEdit = true;
                        rectParams.visible = true;
                    }
                }

                CheckBox {
                    id: checkboxEnabled
                    checked: true
                }

                Text {
                    id: textCommandName
                    Layout.fillHeight: true

                    //Layout.preferredWidth: textCommandName.implicitWidth
                    //Layout.verticalCenter: true
                    //Layout.horizontalCenter: true

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    //textFormat: Text.PlainText
                }

                Text {
                    id: textParams
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //Layout.preferredWidth: textCommandName.implicitWidth
                    //Layout.verticalCenter: true
                    //Layout.horizontalCenter: true

                    verticalAlignment: Text.AlignVCenter
                    //horizontalAlignment: Text.AlignHCenter

                    //textFormat: Text.PlainText
                }

            }

        }


        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            ColorButton {
                text: "命令"
                font.pointSize: 9
                onButtonClicked: {
                    rectParams.bEdit = false;
                    rectCommands.visible = true;
                    containerCommandButtons.nChoicedMenu = -1;
                    //containerCommandButtons.cmdList = sysCommandsTree;
                    repeaterCommandButtons.model = sysCommandsTree.length;
                }
            }

            ColorButton {
                text: "追加"
                font.pointSize: 9
                onButtonClicked: {
                    let cmd = _private.createCommand(_private.strCurrentCommand, true);
                    if(!cmd)
                        return;

                    _private.listModelData.push(cmd);
                    _private.refreshCommandTabCount();
                    listmodel.append({Type: 6, Data: cmd});


                    //附带指令
                    if(sysCommands[_private.strCurrentCommand].command[7]) {
                        for(let tcmd of sysCommands[_private.strCurrentCommand].command[7]) {
                            cmd = _private.createCommand(tcmd, false);
                            if(!cmd)
                                return;

                            _private.listModelData.push(cmd);
                            _private.refreshCommandTabCount();
                            listmodel.append({Type: 6, Data: cmd});
                        }
                    }

                    //listview.refresh();
                }
            }

            ColorButton {
                text: "插入"
                font.pointSize: 9
                onButtonClicked: {
                    let cmd = _private.createCommand(_private.strCurrentCommand, true);
                    if(!cmd)
                        return;

                    let insertIndex;
                    if(listview.currentIndex === -1) {
                        insertIndex = _private.listModelData.length;
                    }
                    else {
                        insertIndex = listview.currentIndex;
                    }

                    _private.listModelData.splice(insertIndex, 0, cmd);
                    _private.refreshCommandTabCount();
                    listmodel.insert(insertIndex, {Type: 6, Data: cmd});


                    //附带指令
                    if(sysCommands[_private.strCurrentCommand].command[7]) {
                        for(let tcmd in sysCommands[_private.strCurrentCommand].command[7]) {
                            cmd = _private.createCommand(sysCommands[_private.strCurrentCommand].command[7][tcmd], false);
                            if(!cmd)
                                return;

                            _private.listModelData.splice(insertIndex + parseInt(tcmd) + 1, 0, cmd);
                            _private.refreshCommandTabCount();
                            listmodel.insert(insertIndex + parseInt(tcmd) + 1, {Type: 6, Data: cmd});
                        }
                    }

                    //listview.refresh();

                    _private.listSelectedCommands = [];
                }
            }

            ColorButton {
                text: "修改"
                font.pointSize: 9
                onButtonClicked: {
                    let cmd = _private.createCommand(_private.strCurrentCommand, true);
                    if(!cmd)
                        return;

                    if(listview.currentIndex >= 0) {
                        _private.listModelData[listview.currentIndex] = cmd;
                        _private.refreshCommandTabCount();
                        listmodel.set(listview.currentIndex, {Type: 9, Data: cmd});
                    }

                    //listview.refresh();
                }
            }
            ColorButton {
                text: "删除"
                font.pointSize: 9
                onButtonClicked: {
                    if(listview.currentIndex >= 0) {
                        _private.listModelData.splice(listview.currentIndex, 1);
                        _private.refreshCommandTabCount();
                        listmodel.remove(listview.currentIndex);
                    }

                    //listview.refresh();
                }
            }
            ColorButton {
                text: "向上"
                font.pointSize: 9
                onButtonClicked: {
                    if(listview.currentIndex > 0) {
                        let a = _private.listModelData[listview.currentIndex];
                        _private.listModelData[listview.currentIndex] = _private.listModelData[listview.currentIndex - 1];
                        _private.listModelData[listview.currentIndex - 1] = a;
                        _private.refreshCommandTabCount();
                        listmodel.move(listview.currentIndex, listview.currentIndex - 1, 1);
                    }

                    //listview.refresh();
                }
            }

            ColorButton {
                text: "向下"
                font.pointSize: 9
                onButtonClicked: {
                    if(listview.currentIndex < listmodel.count - 1) {
                        let a = _private.listModelData[listview.currentIndex];
                        _private.listModelData[listview.currentIndex] = _private.listModelData[listview.currentIndex + 1];
                        _private.listModelData[listview.currentIndex + 1] = a;
                        _private.refreshCommandTabCount();
                        listmodel.move(listview.currentIndex, listview.currentIndex + 1, 1);
                    }

                    //listview.refresh();
                }
            }

            ColorButton {
                text: _private.bMultiple ? "多选" : "单选"
                font.pointSize: 9
                onButtonClicked: {
                    _private.bMultiple = !_private.bMultiple;
                    if(!_private.bMultiple)
                        _private.listSelectedCommands = [];
                }
            }
        }


        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            ColorButton {
                text: '复制'
                font.pointSize: 9
                onButtonClicked: {
                    if(_private.listSelectedCommands.length > 0) {
                        let data = [];

                        for(let tc in _private.listSelectedCommands) {
                            data.push(_private.listModelData[tc]);
                        }

                        if(!GlobalLibraryJS.isObject(Global.frameData.$d.GameVisualScript))
                            Global.frameData.$d.GameVisualScript = {};

                        Global.frameData.$d.GameVisualScript.CopyCommands = data;


                        dialogCommon.show({
                            Msg: '复制成功',
                            Buttons: Dialog.Yes,
                            OnAccepted: function(){
                                root.forceActiveFocus();
                            },
                            OnRejected: ()=>{
                                root.forceActiveFocus();
                            },
                        });

                    }
                    else {
                        if(!GlobalLibraryJS.isObject(Global.frameData.$d.GameVisualScript))
                            Global.frameData.$d.GameVisualScript = {};
                        Global.frameData.$d.GameVisualScript.CopyCommands = [];
                    }
                }
            }

            ColorButton {
                text: '粘贴'
                font.pointSize: 9
                onButtonClicked: {
                    //插入的地方
                    let insertIndex;
                    if(listview.currentIndex === -1) {
                        insertIndex = _private.listModelData.length;
                    }
                    else {
                        insertIndex = listview.currentIndex;
                    }


                    //如果没有复制过
                    if(!GlobalLibraryJS.isObject(Global.frameData.$d.GameVisualScript)) {
                        Global.frameData.$d.GameVisualScript = {};
                        return;
                    }
                    //粘贴
                    if(Global.frameData.$d.GameVisualScript.CopyCommands && Global.frameData.$d.GameVisualScript.CopyCommands.length > 0) {
                        _private.listModelData.splice(insertIndex, 0, ...Global.frameData.$d.GameVisualScript.CopyCommands);
                        for(let tc in Global.frameData.$d.GameVisualScript.CopyCommands) {
                            _private.refreshCommandTabCount();
                            listmodel.insert(insertIndex, {Type: 6, Data: Global.frameData.$d.GameVisualScript.CopyCommands[tc]});
                            ++insertIndex;
                        }
                    }

                    _private.listSelectedCommands = [];
                }
            }

            ColorButton {
                text: "保存"
                font.pointSize: 9
                onButtonClicked: {
                    saveData();
                }
            }
            ColorButton {
                text: "读取"
                font.pointSize: 9
                onButtonClicked: {
                    loadData();
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
                text: "测试"
                font.pointSize: 9
                onButtonClicked: {
                    let jsScript = _private.compile();
                    console.debug(jsScript);
                    eval('let __tJSScript__ = function(){%1}'.arg(jsScript));
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
可视化脚本说明：
  1、先点击 命令，然后 填写参数 或者 长按编辑框（大部分可以长按）选择参数，再点击 追加（到最后）或 插入（到当前指令上面）来完成指令编写；
  2、每次打开可视化编辑界面，会自动载入保存的脚本，也可以手动点击 载入 按钮来重新载入；
  3、双击某命令可以修改，点击”修改“按钮替换当前命令；
  4、编写完成后可以点击 测试 来测试当前可视化脚本语法，如果有报错右下角会出现红色数字，点击后可看到详细错误；
  5、测试没问题后可点 保存按钮 来保存当前脚本；点击 编译 来使用当前脚本（此时上一层界面会自动替换为编译后的脚本）；
  6、语法：
    有缩进的命令（比如 函数/生成器、块开始 等），必须有 块结束 匹配，否则语法错误；
    所有的代码尽量写在 函数/生成器 中，不同的 函数/生成器 有不同的作用，比如：
      *$start：表示载入事件（地图载入或游戏载入）；
      *$地图事件名：表示主角进入地图事件块时的事件；
      *$地图事件名_leave：表示主角离开地图事件块时的事件；
      *$NPC名：表示主角与NPC对话时的事件；
      *$map_click：地图点击事件；
      *$NPC名_click：NPC点击事件；
      *$NPC名_collide：主角与NPC或NPC与NPC的触碰事件；
      *$NPC名_arrive：主角或NPC自动行走到达目的地时触发的事件；
注意：
  1、必须点击 编译 才可以使用；
  2、带 *号 的参数表示是必选，反之可以省略；带 @号 的参数表示可以长按选择；
  3、条件、否则条件、循环、括号开始 命令，都带有左括号符号，最后面必须跟 括号结束 来配对；
  4、函数/生成器、块开始 命令，都带有左大括号，命令块 编写完毕后必须跟 块结束 来配对；
  5、注意代码格式的符号必须是英文半角，中文或全角会报错；
  6、如果要写复杂指令，可以使用 自定义 命令；
  7、字符串 中显示 变量/表达式 的方法： ${变量名/表达式}，需要手动写字符串引号时请用反斜引号（位置在1键左边）；
  8、函数/生成器 命名：可以是中文、英文、数字和$、下划线（数字不可以开头），名字和事件名或角色名相同，则事件触发时会自动会自动调用；
    生成器的命名是在 名字前加个 *号，初学者如果分不清，加*号是肯定没错的。
')
                }
            }
        }

    }



    //选择指令框
    Rectangle {
        id: rectCommands
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9
        visible: false

        color: '#7F000000'



        //某个命令点击
        function onCommandButtonClicked(index) {
            //如果 没有点击 第一层按钮，则显示第一层
            if(containerCommandButtons.nChoicedMenu === -1) {
                //？？？只能这样写，否则会出现释放错误（model为0时会释放所有按钮）？？？
                //  还是这样写会刷新按钮？？？
                repeaterCommandButtons.model = 0;
                containerCommandButtons.nChoicedMenu = index;
                repeaterCommandButtons.model = sysCommandsTree[index][2].length;
                //containerCommandButtons.cmdList = sysCommandsTree[index][2];
            }
            else {
                //创建第二层按钮

                _private.fCreateCommandMenu(sysCommandsTree[containerCommandButtons.nChoicedMenu][2][index]);

                rectCommands.visible = false;
                repeaterCommandButtons.model = 0;
                //containerCommandButtons.nChoicedMenu = -1;

                //containerCommandButtons.cmdList = [];
                if(FrameManager.sl_qml_FindChildren(columnlayoutParams.compParams, 'param').length > 0)
                    rectParams.visible = true;
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.visible = false;
                repeaterCommandButtons.model = 0;
                containerCommandButtons.nChoicedMenu = -1;
            }
        }

        Flow {
            id: containerCommandButtons

            property int nChoicedMenu: -1
            property var cmdList


            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.9

            spacing: 6

            Repeater {
                id: repeaterCommandButtons
                model: 0
                ColorButton {
                    //color: sysCommands[Object.keys(sysCommands)[index]].command[6]
                    //text: sysCommands[Object.keys(sysCommands)[index]].command[0]
                    colors: {
                        if(containerCommandButtons.nChoicedMenu === -1) {
                            let c = sysCommandsTree[index][1];
                            return [c, c, c];
                        }
                        else {
                            let c = sysCommands[sysCommandsTree[containerCommandButtons.nChoicedMenu][2][index]].command[6];
                            return [c, c, c];
                        }
                    }
                    text: {
                        if(containerCommandButtons.nChoicedMenu === -1) {
                            return sysCommandsTree[index][0];
                        }
                        else {
                            return sysCommands[sysCommandsTree[containerCommandButtons.nChoicedMenu][2][index]].command[0];
                        }
                    }
                    onButtonClicked: rectCommands.onCommandButtonClicked(index);
                }
            }
        }
    }




    //参数系列
    Rectangle {
        id: rectParams

        property bool bEdit: false

        anchors.centerIn: parent

        width: parent.width * 0.9
        height: parent.height * 0.9

        visible: false
        clip: true


        color: '#7F000000'



        /*MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.visible = false;
            }
        }*/

        ColumnLayout {
            anchors.centerIn: parent

            width: parent.width * 0.9
            height: parent.height * 0.9


            spacing: 6


            Flickable {
                id: flickableParams

                Layout.fillWidth: true
                Layout.fillHeight: true

                //anchors.centerIn: parent
                //anchors.fill: parent

                //width: parent.width * 0.9
                //height: parent.height * 0.9

                //visible: false
                clip: true


                contentWidth: width
                contentHeight: Math.max(columnlayoutParams.implicitHeight, height)
                flickableDirection: Flickable.VerticalFlick

                ColumnLayout {
                    id: columnlayoutParams

                    //参数的所有组件
                    property var compParams: null

                    anchors.fill: parent

                    spacing: 6
                }
            }


            RowLayout {
                Layout.preferredWidth: parent.width
                Layout.fillWidth: true

                ColorButton {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    text: '确  定'
                    onButtonClicked: {
                        let t = _private.createCommandText();
                        if(!t) {
                            dialogCommon.show({
                                Msg: '有必填项没填',
                                Buttons: Dialog.Yes,
                                OnAccepted: function(){
                                    root.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    root.forceActiveFocus();
                                },
                            });

                            return;
                        }


                        textParams.text =  t;
                        rectParams.visible = false;


                        //如果不是编辑模式
                        if(rectParams.bEdit === false) {
                            return;
                        }
                        rectParams.bEdit = false;

                        let cmd = _private.createCommand(_private.strCurrentCommand, true);
                        if(!cmd)
                            return;

                        if(listview.currentIndex >= 0) {
                            _private.listModelData[listview.currentIndex] = cmd;
                            _private.refreshCommandTabCount();
                            listmodel.set(listview.currentIndex, {Type: 9, Data: cmd});
                        }
                    }
                }

                ColorButton {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    text: '检 查'
                    onButtonClicked: {
                        let t = _private.createCommandText();
                        if(!t) {
                            dialogCommon.show({
                                Msg: '有必填项没填',
                                Buttons: Dialog.Yes,
                                OnAccepted: function(){
                                    root.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    root.forceActiveFocus();
                                },
                            });

                            return;
                        }


                        let errString = '';
                        let paramItems = FrameManager.sl_qml_FindChildren(columnlayoutParams.compParams, 'param');

                        //循环每个子控件，将值取出放在 ret.params 中
                        //for(let i in columnlayoutParams.compParams.children) {
                        for(let i = 0; i < paramItems.length; ++i) {
                            if(paramItems[i].text.trim() === '' && sysCommands[_private.strCurrentCommand].params[i][2] !== true)
                                continue;

                            if(sysCommands[_private.strCurrentCommand].params[i][1] === 'number') {
                                if(!GlobalLibraryJS.isStringNumber(paramItems[i].text)) {
                                    errString += '参数%1的数字格式不正确\r\n'.arg(i+1);
                                }
                            }
                            else if(sysCommands[_private.strCurrentCommand].params[i][1] === 'bool') {
                                if(paramItems[i].text !== 'true' && paramItems[i].text !== 'false') {
                                    errString += '参数%1的布尔格式不正确\r\n'.arg(i+1);
                                }
                            }
                            else if(sysCommands[_private.strCurrentCommand].params[i][1] === 'json') {
                                try {
                                    //JSON.parse(paramItems[i].text);
                                    eval('(%1)'.arg(paramItems[i].text));
                                }
                                catch(e) {
                                    errString += '参数%1的JSON格式【有可能】不正确：%2\r\n'.arg(i+1).arg(e);
                                }
                            }
                            else if(sysCommands[_private.strCurrentCommand].params[i][1] === 'name') {
                                try {
                                    //JSON.parse(paramItems[i].text);
                                    eval('{let %1=0}'.arg(paramItems[i].text));
                                }
                                catch(e) {
                                    errString += '参数%1的name格式【有可能】不正确：%2\r\n'.arg(i+1).arg(e);
                                }
                            }
                        }

                        if(errString !== '') {
                            dialogCommon.show({
                                Msg: '检查结果：\r\n%1\r\n请注意：【有可能】不代表错误，因为这是一种简单的常量运行检查（并不是语法检查），如果涉及到变量和生成器请自行判断。'.arg(errString),
                                Buttons: Dialog.Yes,
                                OnAccepted: function(){
                                    root.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    root.forceActiveFocus();
                                },
                            });
                        }
                        else  {
                            dialogCommon.show({
                                Msg: '参数格式无误',
                                Buttons: Dialog.Yes,
                                OnAccepted: function(){
                                    root.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    root.forceActiveFocus();
                                },
                            });
                        }
                    }
                }

                ColorButton {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    text: '取  消'
                    onButtonClicked: {
                        rectParams.visible = false;
                        rectParams.bEdit = false;
                    }
                }
            }
        }
    }



    //显示 预定义好的 命令的参数 的选择列表
    L_List {
        id: l_listParam

        //保存选中的参数控件
        property var compParam

        visible: false

        onClicked: {
            //参数下标
            let paramID = compParam.nIndex;

            //如果选择类型是1，则直接用值
            if(sysCommands[_private.strCurrentCommand].params[paramID][3] === 1)
                compParam.text = item;
            //如果选择类型是2，则在列表中选择对应值
            else if(sysCommands[_private.strCurrentCommand].params[paramID][3] === 2)
                compParam.text = sysCommands[_private.strCurrentCommand].params[paramID][4][1][index];


            l_listParam.visible = false;
            //root.focus = true;
            root.forceActiveFocus();
        }

        onCanceled: {
            l_listParam.visible = false;
            //root.focus = true;
            root.forceActiveFocus();
        }
    }


    //显示 预定义好的 命令的参数 的选择列表
    L_List {
        id: l_listCommands

        visible: false

        onClicked: {
            l_listCommands.visible = false;


            if(index === 0 && _private.strCommandsName === '')
                return;
            if(item === _private.strCommandsName)
                return;

            dialogCommon.show({
                Msg: '切换命令集会清空当前脚本，确定？',
                Buttons: Dialog.Yes | Dialog.No/* | Dialog.Discard*/,
                OnAccepted: function() {
                    if(index === 0) {
                        item = null;
                    }

                    _private.strCommandsName = item || '';

                    clearData();
                    _private.unloadAllVisualScripts();
                    _private.loadAllVisualScripts(item);


                    //root.focus = true;
                    root.forceActiveFocus();
                },
                OnRejected: function() {
                    //root.focus = true;
                    root.forceActiveFocus();
                },
                OnDiscarded: function() {
                    //root.focus = true;
                    root.forceActiveFocus();
                },
            });
        }

        onCanceled: {
            l_listCommands.visible = false;
            //root.focus = true;
            root.forceActiveFocus();
        }
    }

    QtObject {
        id: _private


        //命令集的名字，系统的为空字符串
        property string strCommandsName: ''

        //多选状态
        property bool bMultiple: false
        //多选的指令下标
        property var listSelectedCommands: []


        //JS引擎，用来载入外部JS文件
        property var jsEngine: new GlobalJS.JSEngine(root)



        //保存文件路径
        property string filepath


        //同listmodel，完全相同的内容（除了含有HTML代码），用来计算命令缩进
        property var listModelData: []


        //根据命令计算缩进数（存到 arrCommandTabCount数组 里）
        //!!原理：命令的存放有两处：listModelData 和 listmodel，前者用来计算命令的缩进数，后者用来显示，所以有顺序要求!!!
        property var arrCommandTabCount: []
        function refreshCommandTabCount() {
            let tabCount = 0;
            //循环每一条命令
            for(let i = 0; i < _private.listModelData.length; ++i) {
                //console.debug(i, JSON.stringify(_private.listModelData))
                let cmd = _private.listModelData[i];    //一条命令
                let cmdKey = cmd.command;    //命令key
                let tCmdString = sysCommands[cmdKey];

                if(tCmdString === undefined || cmdKey === undefined) {
                    console.warn('[GameVisualScript]找不到指令：', cmdKey);
                    continue;
                }

                //如果向左缩进，则提前缩进（如果不是注释 && 有缩进设置 && 缩进后 >= 0）
                if(cmd.status.enabled === true && tCmdString.command[3] !== undefined && tCmdString.command[3] < 0 && tabCount + tCmdString.command[3] >= 0)
                    tabCount += tCmdString.command[3];

                arrCommandTabCount[i] = tabCount;

                if(cmd.status.enabled === true && tCmdString.command[3] !== undefined && tCmdString.command[3] > 0)
                    tabCount += tCmdString.command[3];

            }

            //刷新list的代理
            _private.arrCommandTabCount = _private.arrCommandTabCount;
        }

        function getColor(count) {
            count %= 48;
            if(count < 4) {
                return 'blue';
            }
            if(count < 8) {
                return 'green';
            }
            if(count < 12) {
                return 'red';
            }
            if(count < 16) {
                return 'yellowgreen';
            }
            if(count < 20) {
                return 'lightgreen';
            }
            if(count < 24) {
                return 'wheat';
            }
            if(count < 28) {
                return 'lightpink';
            }
            if(count < 32) {
                return 'lightblue';
            }
            if(count < 36) {
                return 'linen';
            }
            if(count < 40) {
                return 'gold';
            }
            if(count < 44) {
                return 'greenyellow';
            }
            if(count < 48) {
                return 'lightslategray';
            }
        }


        //存当前选择的命令
        property string strCurrentCommand
        //动态为命令 创建 控件
        function fCreateCommandMenu(name) {
            //['地图名', 'string', 'green', true, 1],

            //创建控件字符串
            var strCreateMenu = "";

            for(let paramId in sysCommands[name].params) {
                let param = sysCommands[name].params[paramId];
                let defaultValue = '';
                if(param[3] === 0 && param[4] !== undefined)
                    defaultValue = param[4];
                if(param[3] === 2 && param[4][2] !== undefined)
                    defaultValue = param[4][2];
                //console.debug('!!!~~~', param[4][2])
                switch(param[1]) {
                case 'string|number':
                case 'string':
                case 'number':
                case 'bool':
                case 'name':
                case 'json':
                case 'unformatted':
                    //nIndex是长按时给相关函数传递的本控件下标
                    //strCreateMenu += "TextField {property int nIndex: %1; placeholderText: '%2'; selectByMouse: true; Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter; Layout.fillWidth: true; MouseArea {anchors.fill: parent; onPressed: {parent.focus = true;} onDoubleClicked: {_private.showParamValues(parent); mouse.accepted = false;}} } ".arg(paramId).arg(param[0]);
                    strCreateMenu += "TextField {property int nIndex: %1; objectName: 'param'; width: parent.width; /*Layout.alignment: Qt.AlignLeft | Qt.AlignTop; Layout.fillWidth: true;*/  text: '%2'; placeholderText: '%3'; selectByMouse: true; onPressAndHold: {_private.showParamValues(this);} } ".arg(paramId).arg(defaultValue).arg(param[0]);
                    break;
                case 'code':
                    strCreateMenu += "Notepad {objectName: 'param'; width: parent.width; height: textArea.implicitHeight; /*Layout.alignment: Qt.AlignLeft | Qt.AlignTop; Layout.fillWidth: true;*/ textArea.text: '%1'; textArea.placeholderText: '%2'; textArea.textFormat: TextArea.PlainText; textArea.selectByMouse: true; textArea.selectByKeyboard: true;} ".arg(defaultValue).arg(param[0]);
                    break;
                case 'label':
                    strCreateMenu += "Label {width: parent.width; height: implicitHeight; /*Layout.alignment: Qt.AlignLeft | Qt.AlignTop; Layout.fillWidth: true;*/ color: 'white'; font.pointSize: 16; text: '%1'; wrapMode: Label.Wrap} ".arg(param[0]);
                    break;
                default:
                    strCreateMenu += "TextField {objectName: 'param'; width: parent.width; /*Layout.alignment: Qt.AlignLeft | Qt.AlignTop; Layout.fillWidth: true;*/ text: '%1'; placeholderText: '%2'; selectByMouse: true;} ".arg(defaultValue).arg(param[0]);
                }

            }


            //目前的命令名
            _private.strCurrentCommand = name;
            //textCommandName.text = sysCommands[name].command[0];
            textCommandName.text =  "<font color='%1'>%2</font>".arg(sysCommands[name].command[5]).arg(sysCommands[name].command[0]);
            //参数重置
            textParams.text = '';


            //删除原来的
            if(columnlayoutParams.compParams)
                columnlayoutParams.compParams.destroy();

            columnlayoutParams.compParams = Qt.createQmlObject("import QtQuick 2.14; import QtQuick.Controls 2.14; import QtQuick.Layouts 1.14; import 'qrc:/QML'; import _Global 1.0; Column {Layout.fillWidth: true; Layout.fillHeight: true; spacing: 6; %1}".arg(strCreateMenu), columnlayoutParams);

            //columnlayoutParams.x = 0;
        }

        //显示可选择的 命令参数 预定值
        function showParamValues(compParam) {
            l_listParam.compParam = compParam;
            let paramID = compParam.nIndex;

            //如果选择类型是1，则显示 某目录
            if(sysCommands[_private.strCurrentCommand].params[paramID][3] === 1) {
                l_listParam.show(sysCommands[_private.strCurrentCommand].params[paramID][4]);
                l_listParam.visible = true;
                l_listParam.focus = true;
            }
            //如果选择类型是2，则显示 预定义值
            else if(sysCommands[_private.strCurrentCommand].params[paramID][3] === 2) {
                l_listParam.showList(sysCommands[_private.strCurrentCommand].params[paramID][4][0]);
                l_listParam.visible = true;
                l_listParam.focus = true;
            }
        }


        //创建一条 指令（用于 显示到列表）
        //commandName是命令字符串（key）；makeParam表示是否处理参数（一般都需要，只有 命令关联其他命令时 不需要）；
        function createCommand(commandName, makeParam) {
            if(commandName === '')
                return false;

            let ret = {command: commandName, params: [], status: {enabled: checkboxEnabled.checked}};

            if(makeParam) {
                let paramItems = FrameManager.sl_qml_FindChildren(columnlayoutParams.compParams, 'param');

                //循环每个子控件，将值取出放在 ret.params 中
                //for(let i in columnlayoutParams.compParams.children) {
                for(let i in paramItems) {
                    if(sysCommands[commandName].params[i][2] === true && paramItems[i].text === '') {
                        return false;
                    }
                    else
                        ret.params.push(paramItems[i].text);
                }
            }

            //console.debug(ret);
            return ret;
        }

        //创建指令字符串（目前只是参数，显示到下方）
        function createCommandText() {
            let Data = _private.createCommand(_private.strCurrentCommand, true);
            if(!Data)
                return null;

            let tCmdString = sysCommands[Data.command];
            let retString = '';
            //显示命令和参数
            //retString += "<font color='%1'>%2</font>".arg(tCmdString.command[5]).arg(tCmdString.command[0]);
            for(let i in Data.params) {
                let paramValueText = Data.params[i];
                if(tCmdString.params[i][3] === 2) {
                    let tIndex = tCmdString.params[i][4][1].indexOf(Data.params[i]);
                    if(tIndex >= 0)
                        paramValueText = tCmdString.params[i][4][0][tIndex];
                }
                retString += "<font color='%1'>%2</font>  ".arg(tCmdString.params[i][5]).arg(GlobalLibraryJS.convertToHTML(paramValueText, ['<', '>']));
            }
            return retString;
        }


        //编译（结果为字符串）
        function compile() {
            let data = '';
            //循环每一条命令
            for(let i = 0; i < listmodel.count; ++i) {
                let cmd = listmodel.get(i).Data;    //一条命令
                let cmdKey = cmd.command;    //命令key



                //解析一条命令
                let tstrCmd = '';

                if(cmd.status.enabled === false)
                    tstrCmd = '/*/\r\n';
                tstrCmd += (Array(_private.arrCommandTabCount[i] + 1).join(' ') + sysCommands[cmdKey].command[1]);

                //如果命令是字符串
                if(GlobalLibraryJS.isString(tstrCmd)) {
                    //data += (tstrCmd + '(');
                }
                //是数字
                else if(GlobalLibraryJS.isValidNumber(tstrCmd)) {
                }
                //console.debug('~~~tstrCmd', tstrCmd, _private.arrCommandTabCount[i])

                //console.debug('params:', cmd.command.length)


                //如果有处理函数
                if(GlobalLibraryJS.isFunction(sysCommands[cmdKey].command[8])) {
                    let params = [];
                    for(let j = 0; j < cmd.params.length; ++j) {
                        let tParamValue = cmd.params[j];
                        params.push(tParamValue);
                    }
                    tstrCmd = sysCommands[cmdKey].command[8](tstrCmd, params);
                }
                //按默认处理
                else {

                    //循环参数

                    //输出的指令下标
                    //let tmpOutputIndex = 0;
                    //循环参数组件
                    for(let j = 0; j < cmd.params.length; ++j) {
                        //if(sysCommands[cmdKey].params[j][2] === undefined)
                        //    continue;

                        //let tParam = GlobalLibraryJS.chineseSymbols2EnglishSymbols(cmd.params[j]);
                        let tParam = cmd.params[j];
                        //如果参数为空
                        if(tParam === '') {
                            //如果这个参数不需要
                            if(sysCommands[cmdKey].params[j][2] === false)
                                tstrCmd = tstrCmd.arg('');
                            else if(sysCommands[cmdKey].params[j][2] === undefined)
                                tstrCmd = tstrCmd.arg('undefined');
                            else if(sysCommands[cmdKey].params[j][2] === null)
                                tstrCmd = tstrCmd.arg('null');
                            else    //有默认值
                                tstrCmd = tstrCmd.arg("%1".arg(sysCommands[cmdKey].params[j][2]));

                            continue;
                        }

                        //console.debug('param:', tParam)
                        //第1个参数，加,号
                        //if(j > 0)
                        //    data += ',';

                        //判断参数类型
                        switch(sysCommands[cmdKey].params[j][1]) {
                        case 'number':
                            tstrCmd = tstrCmd.arg(tParam);
                            break;
                        case 'bool':
                            if(tParam === '0' || tParam.toLowerCase() === 'false')
                                tstrCmd = tstrCmd.arg('false');
                            else
                                tstrCmd = tstrCmd.arg('true');
                            break;
                        case 'string':
                            tstrCmd = tstrCmd.arg("`%1`".arg(tParam));
                            break;
                        case 'string|number':
                            if(GlobalLibraryJS.isStringNumber(tParam))
                                tstrCmd = tstrCmd.arg("%1".arg(tParam));
                            else
                                tstrCmd = tstrCmd.arg("`%1`".arg(tParam));
                            break;
                        case 'name':
                        case 'json':
                        case 'unformatted':
                        case 'code':
                        default:
                            tstrCmd = tstrCmd.arg("%1".arg(tParam));
                        }

                        /*
                        if(sysCommands[cmdKey].params[j][1] === 'number')
                        else if(sysCommands[cmdKey].params[j][1] === 'bool') {
                        }
                        else if(sysCommands[cmdKey].params[j][1] === 'string')
                        else if(sysCommands[cmdKey].params[j][1] === 'json')
                        else if(sysCommands[cmdKey].params[j][1] === 'code')
                        else
                            tstrCmd = tstrCmd.arg("%1".arg(tParam));
                        */
                    }

                    //如果命令是字符串
                    //if(GlobalLibraryJS.isString(tstrCmd))
                    //    data += ');';
                }


                if(cmd.status.enabled === false)
                    tstrCmd += '\r\n/*/\r\n';

                //!!!命令
                data += tstrCmd;
                if(sysCommands[cmdKey].command[4])
                    data += '\r\n';

                //一条命令完毕
            }

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



        //载入一个目录下 可视化的自定义命令集
        //jsPrefix：指令的key 是否携带 js脚本名
        function loadExtraVisualScripts(path, jsPrefix=true) {
            if(!path) {
                root.sysCommands = GameVisualScriptJS.data.sysCommands;
                root.sysCommandsTree = GameVisualScriptJS.data.sysCommandsTree;
                return;
            }

            //循环文件
            let jsFiles = FrameManager.sl_qml_listDir(path, '*', 0x002 | 0x2000 | 0x4000, 0);
            for(let tf of jsFiles) {

                if(tf.slice(tf.lastIndexOf(".")).toLowerCase() !== '.js')
                    continue;


                let ts;

                try {
                    ts = _private.jsEngine.load(tf, Global.toURL(path));
                }
                catch(e) {
                    console.error(e);
                    continue;
                }

                //js名
                let jsName = tf.slice(0, tf.lastIndexOf("."));

                ts.data.groupInfo.push([]);
                for(let tc of ts.data.commandInfos) {
                    let commandID;
                    if(jsPrefix)
                        commandID = jsName + '_' + tc.command[0];
                    else
                        commandID = tc.command[0];
                    ts.data.groupInfo[2].push(commandID);
                    sysCommands[commandID] = tc;
                }


                sysCommandsTree.push(ts.data.groupInfo);
            }
        }


        //载入所有的可视化脚本命令集
        function loadAllVisualScripts(name=null) {
            let pluginsPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + "Plugins" + GameMakerGlobal.separator;
            let virtualScriptPath = pluginsPath + '$Leamus' + GameMakerGlobal.separator + '$VisualScripts' + GameMakerGlobal.separator;


            //1.载入对应插件指令
            if(name) {
                if(FrameManager.sl_qml_DirExists(virtualScriptPath + name))
                    _private.loadExtraVisualScripts(virtualScriptPath + name + GameMakerGlobal.separator, false);
                else
                    return -1;
            }
            else {  //载入默认命令集
                _private.loadExtraVisualScripts(null, false);
            }


            //2.载入自定义指令（全局）
            let path = Platform.getExternalDataPath() + GameMakerGlobal.separator + "MakerFrame" + GameMakerGlobal.separator + "RPGMaker" + GameMakerGlobal.separator + "Plugins" + GameMakerGlobal.separator + '$Leamus' + GameMakerGlobal.separator + '$VisualScripts' + GameMakerGlobal.separator;
            //console.debug(path);
            //console.debug('~~~', FrameManager.sl_qml_listDir(path, '*', 0x002 | 0x2000 | 0x4000, 0));

            _private.loadExtraVisualScripts(path);


            //（工程）

            //3.循环三方插件根目录
            for(let tc0 of FrameManager.sl_qml_listDir(Global.toPath(pluginsPath), '*', 0x001 | 0x2000 | 0x4000, 0)) {
                if(tc0 === '$Leamus')
                    continue;

                //循环三方插件目录
                for(let tc1 of FrameManager.sl_qml_listDir(Global.toPath(pluginsPath + tc0 + GameMakerGlobal.separator), '*', 0x001 | 0x2000 | 0x4000, 0)) {

                    path = pluginsPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'VisualScripts' + GameMakerGlobal.separator;

                    //console.debug(path);
                    //console.debug('~~~', FrameManager.sl_qml_listDir(path, '*', 0x002 | 0x2000 | 0x4000, 0));

                    _private.loadExtraVisualScripts(path);

                }
            }

            //console.debug(ts);
            //console.debug(ts, ts.a);

            return 0;
        }

        function unloadAllVisualScripts() {
            root.sysCommands = {};
            root.sysCommandsTree = [];

            _private.jsEngine.clear();
        }

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

