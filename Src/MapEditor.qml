import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


import 'GameVisualScript.js' as GameVisualScriptJS
//import 'File.js' as File



/*

  地图块：
    可以自定义 cols，rows 自动计算，绘制时会根据所选地图块计算出原图坐标并进行绘制；可以防止超范围选择

  操作：
    移动模式：鼠标可以移动，可双指缩放
    绘制模式：可以单击、拖拉、滚轮（缩放），可双指缩放

  绘制：
    点击地图绘制区后产生鼠标事件，将产生的鼠标事件x、y经过缩放比例计算后，和地图块所选区域一并保存到当前地图层的arrMapRepaintPoint中，然后调用Canvas的requestPaint，在onPaint中取出并绘制。

  图层：
    //0层：为障碍物、特殊效果
    //1层：事件层
    n层及以下：地板层
    n层以上：遮挡层


  导入：
    和绘制差不多原理，将所有需要绘制的地方保存到每个地图层的arrMapRepaintPoint中，然后调用requestPaint，在onPaint中取出并绘制

  导出：
    //会导出0层~n层的图片和数据；
    导出数据：
        outputData.Version = '0.6';   //版本
        outputData.MapName = ''; //地图名
        outputData.MapType = 1; //地图类型
        outputData.MapScale = ''; //地图缩放
        outputData.MapSize = [_config.sizeMapSize.width, _config.sizeMapSize.height]; //地图大小（行列）
        outputData.MapBlockSize = [_config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height];  //地图块大小（像素）
        outputData.MapCount = canvasMapContainer.arrCanvasMap.length;  //地图层数
        outputData.MapData = [];    //arrMapData。地图数据（从0开始）
        outputData.MapBlockImageCount = 1;  //地图块图片数
        outputData.MapBlockImage = []   //地图块图片路径 数组
        outputData.MapEventData = objMapEventsData;    //地图上的事件数据（数据格式：{坐标: 事件名}）
        outputData.MapBlockSpecialData = objMapBlockSpecialData;  //地图上的障碍数据（数据格式：{坐标: 障碍号}）
        //outputData.EventData = {};
        //for(i = 0; i < listmodelEventsData.count; ++i) {
        //    outputData.EventData[listmodelEventsData.get(i)['EventName']] = (listmodelEventsData.get(i)['EventCode']);
        //}
        //outputData.EventData = objEventsData;   //事件数据（数据格式：{事件名: 事件代码}）
        //outputData.SystemEventData = objSystemEventsData;   //系统事件数据（数据格式：{事件名: 事件代码}）
        outputData.MapOfRole = 2    //角色所在图层（大于等于这个的会遮盖角色）

    MapData：
      第k个地图层 第j行 第i列，为 地图块图片blockID 的x,y坐标(块坐标）。
      MapData[k][j][i] = [x,y,blockID]。

    MapEventData：
      地图坐标 对应的 事件名。

    //EventData：
      所有事件名和事件的定义。

    //SystemEventData：
      系统事件;目前只有地图载入事件。

  其他：
    没有双指移动的功能。
    没有禁用Flickable的功能（得自己写一个）。
*/


Item {
    id: root



    signal sg_close()
    onSg_close: {
        _private.cleanMap();
    }



    /*function init(mapRID) {
        //textMapRID.text = _private.strMapRID = mapRID;
    }
    */

    //创建新地图
    function newMap(cfg) {
        _private.readConfig(cfg);


        console.debug('[MapEditor]newMap：', cfg.MapBlockImage[0], imageMapBlock1.source, imageMapBlock1.sourceSize.width, imageMapBlock1.sourceSize.height);

        ////0层、1层和2层
        ////_private.createCanvasMap(-1);
        ////_private.createCanvasMap(-1);
        _private.createCanvasMap(_private.initMapData([], [-1,-1,-1]));


        _private.loadScript();
    }

    //打开地图
    function openMap(cfg, mapRID) {
        textMapRID.text = _private.strMapRID = mapRID;
        _private.readConfig(cfg);


        console.debug('[MapEditor]openMap:', imageMapBlock1.source, imageMapBlock1.sourceSize.width, imageMapBlock1.sourceSize.height);


        //读取 地图数据
        //第k个地图层 第j行 第i列，为blockID的x,y坐标
        //  MapData[k][j][i] = [x,y,blockID]
        for(let k in cfg.MapData) {

            let objCanvas = _private.createCanvasMap(cfg.MapData[k]);


            /*arrMapData[k] = cfg.MapData[k];

            //图层
            let objCanvas = compCanvas.createObject(canvasMapContainer, {
                                                        z: canvasMapContainer.arrCanvasMap.length,
                                                        index: canvasMapContainer.arrCanvasMap.length
                                                    });
            canvasMapContainer.arrCanvasMap.push(objCanvas);
            objCanvas.loadImage(imageMapBlock1.source);
            if(objCanvas.isImageLoaded(imageMapBlock1.source)) {
                //console.debug('[MapEditor]objCanvas.loadImage载入OK');
                objCanvas.requestPaint();
            }
            //else
                //console.debug('[MapEditor]objCanvas.loadImage载入NO，等待回调。。。');

            listmodelCanvasMap.append({bVisible: true,
                                  id: canvasMapContainer.arrCanvasMap.length - 1});

            */



            //图层数据

            //let ctx = canvasMapContainer.arrCanvasMap[k].getContext('2d');


            //重新设置地图宽高（地图被重新定义大小）
            //设置cfg.MapData[k]等同于设置arrMapData[k]!!

            //实际高
            cfg.MapData[k].length = _config.sizeMapSize.height;
            //arrMapData[k].length = _config.sizeMapSize.height;

            //循环每一行
            for(let j in cfg.MapData[k]) {

                if(!$CommonLibJS.isArray(cfg.MapData[k][j]))
                    cfg.MapData[k][j] = [];

                //实际宽
                cfg.MapData[k][j].length = _config.sizeMapSize.width;
                //arrMapData[k][j].length = _config.sizeMapSize.width;

                //循环每一列
                for(let i in cfg.MapData[k][j]) {
                    if(!$CommonLibJS.isArray(cfg.MapData[k][j][i])) {
                        cfg.MapData[k][j][i] = [-1, -1, -1];
                        continue;
                    }

                    else if(cfg.MapData[k][j][i].toString() === '-1,-1,-1')
                        continue;


                    //重绘的地区
                    canvasMapContainer.arrCanvasMap[k].arrMapRepaintPoint.push(Qt.point(i, j));

                    //canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint(); //重新绘图


                    /*ctx.clearRect(i * _config.sizeMapBlockSize.width, j * _config.sizeMapBlockSize.height,
                                  _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);

                    ctx.drawImage(imageMapBlock1.source,
                                  cfg.MapData[k][j][i][0] * _config.sizeMapBlockSize.width,
                                  cfg.MapData[k][j][i][1] * _config.sizeMapBlockSize.height,
                                  _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height,
                                  i * _config.sizeMapBlockSize.width, j * _config.sizeMapBlockSize.height,
                                  _config.sizeMapBlockSize.width, config.sizeMapBlockSize.height);
                    */
                }
            }
            //canvasMapContainer.arrCanvasMap[k].requestPaint();
        }



        //事件、系统事件 和 特殊图块
        objMapEventsData = cfg.MapEventData || {};
        //objSystemEventsData = cfg.SystemEventData || {};

        objMapBlockSpecialData = cfg.MapBlockSpecialData || {};



        //开始循环事件

        //兼容之前的版本
        if(cfg.MapEventList === undefined) {
            cfg.MapEventList = [];
            //读取事件数据，创建事件
            for(let i in cfg.MapEventData) {
                if(cfg.MapEventList.indexOf(cfg.MapEventData[i]) < 0)
                    cfg.MapEventList.push(cfg.MapEventData[i]);
            }
            console.debug('[MapEditor]兼容OK');
        }
        //读取事件数据，创建事件
        for(let i in cfg.MapEventList) {
            _private.createEvent(cfg.MapEventList[i]);
        }


        canvasEvent.rePaint();

        canvasBlockSpecial.rePaint();



        //设置 当前地图层
        canvasMapContainer.nCurrentCanvasMap = canvasMapContainer.arrCanvasMap.length - 1;
        listviewCanvasMap.currentIndex = listmodelCanvasMap.count - 1;


        _private.loadScript(_private.strMapRID);
    }



    //地图 数据
    property var arrMapData: [] //地图数据
    property var arrMapBlockImageURL: []    //地图块图片URL

    property var objMapBlockSpecialData: ({})   //地图特殊图块数据（{坐标: 数据代码}）
    property var objMapEventsData: ({}) //地图事件数据（{坐标: 事件名}）
    //property var objEventsData: ({}) //事件数据（{事件名: 事件代码}）
    //property var objSystemEventsData: ({}) //系统事件数据（{事件名: 事件代码}）


    //readonly property int rMapBlockSpecialType_Obstacle: -1


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
        //radius: 9
    }


    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            Layout.preferredHeight: 42
            Layout.minimumHeight: 0
            Layout.maximumHeight: 42
            Layout.alignment: Qt.AlignTop


            Button {
                Layout.minimumWidth: 42
                Layout.maximumWidth: implicitWidth + 16
                Layout.fillWidth: true
                Layout.fillHeight: true
                //Layout.preferredWidth: implicitWidth

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize

                text: {
                    if(_config.bMapMove)
                        return '移动';
                    else if(_config.bMapDraw)
                        return '绘制';
                    //else if(_config.bMapClean)
                    //    return '清除';
                    else if(_config.bMapEvent)
                        return '事件';
                    else if(_config.bMapBlockSpecial)
                        return '特殊';
                    else
                        return 'ERROR';
                }
                background: Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.bottomMargin: 6
                    //anchors.leftMargin: 6
                    //anchors.rightMargin: 6
                    color: 'red'
                }

                onClicked: {
                    //切换模式
                    if(_config.bMapMove)
                        _config.nDrawMapType = 1;
                    else if(_config.bMapDraw)
                        _config.nDrawMapType = 2;
                    //else if(_config.bMapClean)
                    //    _config.nDrawMapType = 0;
                    else if(_config.bMapBlockSpecial)
                        _config.nDrawMapType = 3;
                    else if(_config.bMapEvent)
                        _config.nDrawMapType = 0;
                    else
                        _config.nDrawMapType = 0;
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true
                //Layout.preferredWidth: implicitWidth

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '层>'
                onClicked: {
                    if(itemToolbar.nBar === 1)
                        itemToolbar.nBar = 0;
                    else
                        itemToolbar.nBar = 1;
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true
                //Layout.preferredWidth: implicitWidth

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '事件>'
                onClicked: {
                    if(itemToolbar.nBar === 2)
                        itemToolbar.nBar = 0;
                    else
                        itemToolbar.nBar = 2;
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true
                //Layout.preferredWidth: implicitWidth

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '操作>'
                onClicked: {
                    if(itemToolbar.nBar === 3)
                        itemToolbar.nBar = 0;
                    else
                        itemToolbar.nBar = 3;
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                //Layout.preferredWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true

                //x: 520
                font.pointSize: _config.nFontPointSize
                text: '脚本'
                onClicked: {
                    //textEventName.text = '$1';
                    //scriptEditor.text = objSystemEventsData['$1'] || '';
                    //scriptEditor.editor.setPlainText(objSystemEventsData['$1'] || '');

                    if(!_private.strMapRID) {
                        $dialog.show({
                                Msg: '请先保存地图',
                                Buttons: Dialog.Yes,
                                OnAccepted: function() {
                                    //root.forceActiveFocus();
                                },
                                OnRejected: ()=>{
                                    //root.forceActiveFocus();
                                },
                            });

                        return;
                    }


                    //_private.loadScript(_private.strMapRID);


                    scriptEditor.visible = true;
                    scriptEditor.editor.forceActiveFocus();
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                //Layout.preferredWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '测试'
                onClicked: {
                    //loaderTestMap.item.init({Map: _private.strMapRID});
                    //loaderTestMap.show();
                    hotLoader.reload(Qt.resolvedUrl('mainGameTest.qml'));
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                //Layout.preferredWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '帮助'
                onClicked: {

                    rootGameMaker.showMsg('
地图编辑器说明：
  1、功能和特色：支持各种size的地图块；支持无数层级（目前1层和2层为地板层），角色都在2、3层之间；支持事件脚本编辑；支持复制粘贴功能；
  2、操作说明：
    左上角按钮为鼠标功能选择，有绘制、障碍、事件、移动 4个功能；
      绘制：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制地图（注意选择的当前图层）；
        双击和拖动：清空目标地图块；
        长按+拖动：复制地图选块；
      障碍：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制障碍；
        双击和拖动：清空目标障碍；
        长按+拖动：复制地图选块；
      事件：
        单击：提示地图块坐标和移动粘贴目标；
        单击拖动：绘制事件（注意需要选择一个事件）；
        双击和拖动：清空目标事件；
        长按+拖动：复制地图选块；
      移动：
        可以移动和缩放地图区；
    粘贴：可以复制源地图层的选区到目标地图层的粘贴目标内；
    地图层列表：单击可以选择当前地图层；双击可以显示、隐藏当前地图层；
    事件列表：单击可以选择当前事件进行绘制；双击可以编辑事件名；
    事件：编辑地图的所有事件（事件名就是函数名）；
    保存时的地图资源名：脚本创建时用地图资源名来创建这个地图；
')
                }
            }

            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: implicitWidth
                //Layout.preferredWidth: implicitWidth
                Layout.fillWidth: true
                Layout.fillHeight: true

                //x: 130
                //width: 100
                //height: 30
                font.pointSize: _config.nFontPointSize
                text: '保存'
                onClicked: {
                    //console.debug('canvasMapContainer.nCurrentCanvasMap', canvasMapContainer.nCurrentCanvasMap);
                    //console.debug(arrMapData[canvasMapContainer.nCurrentCanvasMap][0][0]);
                    //console.debug(flickable.contentX, flickable.contentY,flickable.originX, flickable.originY);

                    textMapRID.text = _private.strMapRID;
                    //textMapName.text = _private.strMapName;
                    //textMapScale.text = _private.nMapScaled;
                    dialogSave.open();
                }
            }



            Button {
                //Layout.minimumWidth: 60
                Layout.maximumWidth: 60
                //Layout.preferredWidth: 100
                Layout.fillWidth: true
                Layout.fillHeight: true

                visible: false


                font.pointSize: _config.nFontPointSize
                text: '调试'
                onClicked: {
                    dialogRunScript.open();

                    //console.debug('canvasMapContainer.nCurrentCanvasMap', canvasMapContainer.nCurrentCanvasMap);
                    //console.debug(arrMapData[canvasMapContainer.nCurrentCanvasMap][0][0]);
                    //console.debug(flickable.contentX, flickable.contentY,flickable.originX, flickable.originY);

                    /*console.debug(itemMapBlockContainer.currentMapBlock.imageMapBlock.width,
                                  itemMapBlockContainer.currentMapBlock.imageMapBlock.height,
                                  itemMapBlockContainer.currentMapBlock.imageMapBlock.sourceSize.width,
                                  itemMapBlockContainer.currentMapBlock.imageMapBlock.sourceSize.height
                                  );
                    console.debug(arrMapData)
                    console.debug(JSON.stringify(arrMapData))


                    console.debug('canvasMapContainer.arrCanvasMap[0]', canvasMapContainer.arrCanvasMap[0].arrMapRepaintPoint)
                    canvasMapContainer.arrCanvasMap[0].requestPaint();
                    //for(let j in cfg.MapData[k]) {
                    //arrMapData[k] = cfg.MapData[k];
                    */
                    console.debug('[MapEditor]focus:', root.focus, rootFocusScopeScaled.focus, loaderUserMainProject.focus, rootWindow.focus);
                    console.debug('[MapEditor]', filedialogOpenMapBlock.folder);

                    console.debug('[MapEditor]imageMapBlock:', itemMapBlockContainer.currentMapBlock.imageMapBlock.source);


                    /*canvasMapBlock1.requestPaint(); //重新绘图

                    for(let k in canvasMapContainer.arrCanvasMap)
                        canvasMapContainer.arrCanvasMap[k].requestPaint();
                    */
                }
            }
        }


        Item {
            id: itemToolbar

            property int nBar: 0

            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            Layout.preferredHeight: 42
            Layout.minimumHeight: 0
            Layout.maximumHeight: 42
            Layout.alignment: Qt.AlignTop


            visible: itemToolbar.nBar !== 0
            clip: true


            RowLayout {
                /*Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                Layout.preferredHeight: 30
                Layout.minimumHeight: 0
                Layout.maximumHeight: 30
                */
                anchors.fill: parent

                visible: itemToolbar.nBar === 1


                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    //Layout.preferredWidth: implicitWidth
                    Layout.fillHeight: true

                    //x: 520
                    font.pointSize: _config.nFontPointSize
                    text: '层+'
                    onClicked: {
                        _private.createCanvasMap(_private.initMapData([], [-1,-1,-1]));
                    }
                }
                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    //Layout.preferredWidth: implicitWidth
                    Layout.fillHeight: true

                    //x: 520
                    //y: 30
                    font.pointSize: _config.nFontPointSize
                    text: '层-'
                    onClicked: {

                        if(listmodelCanvasMap.count < 1)
                            return;

                        _private.removeCanvasMap();
                    }
                }

                //图层列表
                ListView {
                    id: listviewCanvasMap

                    //Layout.minimumWidth: 100
                    //Layout.maximumWidth: 100
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //x: 300
                    //anchors.fill: parent
                    //width: 200
                    //height: 200


                    clip: true

                    //snapMode: ListView.SnapOneItem
                    orientation:ListView.Horizontal

                    model: ListModel {
                        id: listmodelCanvasMap
                        //ListElement { key: '全部'; value: '-1' }
                    }

                    delegate: ItemDelegate {
                        width: 30
                        height: listviewCanvasMap.height
                        //color: index % 2 ? 'lightgreen' : 'lightblue'
                        //color: 'lightblue'
                        highlighted: listviewCanvasMap.currentIndex === index
                        Rectangle {
                            anchors.fill: parent
                            color: listviewCanvasMap.currentIndex === index ? 'lightgreen' : 'lightblue'
                            //color: listviewCanvasMap.currentIndex === index ? 'lightgreen' : (canvasMapContainer.arrCanvasMap[index].visible ? 'lightblue' : 'lightgray')
                        }

                        Label {
                            anchors.centerIn: parent

                            font.pointSize: 10
                            //需要判断 canvasMapContainer.arrCanvasMap[index] 是否存在，因为在删除地图层时对象会在最后删除，会导致有绑定错误
                            font.strikeout: canvasMapContainer.arrCanvasMap[index] ? (canvasMapContainer.arrCanvasMap[index].opacity === 0 ? true : false) : false
                            font.underline: canvasMapContainer.arrCanvasMap[index] ? (canvasMapContainer.arrCanvasMap[index].opacity === 0.5 ? true : false) : false

                            text: {
                                switch(index) {
                                //case 0:
                                    //return '设置障碍';
                                //case 1:
                                    //return '设置事件';
                                default:
                                    return index;
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                /*switch(index) {
                                case 0:
                                case 1:
                                    //_config.nDrawMapType = 3;
                                    listviewCanvasMap.currentIndex = index;
                                    canvasMapContainer.nCurrentCanvasMap = index;
                                    break;
                                default:
                                    listviewCanvasMap.currentIndex = index;
                                    canvasMapContainer.nCurrentCanvasMap = index;
                                    break;
                                }*/

                                //选择图层
                                listviewCanvasMap.currentIndex = index;
                                canvasMapContainer.nCurrentCanvasMap = index;

                                console.debug('[MapEditor]', index, listviewCanvasMap.currentIndex);
                                //console.debug(key,value);

                                //let obj = compListItem.createObject(null, {key: 999, value: 666});
                                //listmodelCanvasMap.append({key: '666', value: '999'});
                            }
                            onDoubleClicked: {
                                //!!!隐藏图层，这里加隐藏标志
                                //bVisible = !bVisible;
                                //canvasMapContainer.arrCanvasMap[index].visible = bVisible;
                                if(fOpacity === 0)
                                    fOpacity = 1;
                                else if(fOpacity === 1)
                                    fOpacity = 0.5;
                                else if(fOpacity === 0.5)
                                    fOpacity = 0;
                                canvasMapContainer.arrCanvasMap[index].opacity = fOpacity;
                            }
                        }
                    }
                }
            }


            RowLayout {
                /*Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                Layout.preferredHeight: 30
                Layout.minimumHeight: 0
                Layout.maximumHeight: 30
                */
                anchors.fill: parent

                visible: itemToolbar.nBar === 2


                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    //Layout.preferredWidth: implicitWidth
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //x: 520
                    font.pointSize: _config.nFontPointSize
                    text: 'E+'
                    onClicked: {
                        textEventName.text = '';

                        dialogEvent.nEventIndex = -1;
                        dialogEvent.open();
                    }
                }

                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    //Layout.preferredWidth: implicitWidth
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //x: 520
                    font.pointSize: _config.nFontPointSize
                    text: 'E-'

                    onClicked: {
                        _private.deleteEvent(listviewEvents.currentIndex);
                    }
                }

                //事件列表
                ListView {
                    id: listviewEvents

                    //Layout.minimumWidth: 60
                    //Layout.maximumWidth: 100
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //x: 300
                    //anchors.fill: parent
                    //width: 200
                    //height: 200


                    clip: true

                    //snapMode: ListView.SnapOneItem
                    orientation:ListView.Horizontal

                    //model: listEventsData
                    model: ListModel {
                        id: listmodelEventsData
                        //ListElement { key: '全部'; value: '-1' }
                    }

                    delegate: ItemDelegate {
                        width: 30
                        height: listviewEvents.height
                        //color: index % 2 ? 'lightgreen' : 'lightblue'
                        //color: 'lightblue'
                        highlighted: listviewEvents.currentIndex === index
                        Rectangle {
                            anchors.fill: parent
                            color: listviewEvents.currentIndex === index ? 'lightgreen' : 'lightblue'
                        }

                        Label {
                            anchors.centerIn: parent
                            font.pointSize: 10
                            text: {
                                switch(index) {
                                //case 0:
                                    //return '设置障碍';
                                //case 1:
                                    //return '设置事件';
                                default:
                                    return index;
                                }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                /*switch(index) {
                                case 0:
                                case 1:
                                    //_config.nDrawMapType = 3;
                                    listviewEvents.currentIndex = index;
                                    canvasMapContainer.nCurrentCanvasMap = index;
                                    break;
                                default:
                                    listviewEvents.currentIndex = index;
                                    canvasMapContainer.nCurrentCanvasMap = index;
                                    break;
                                }*/

                                //选择图层
                                listviewEvents.currentIndex = index;
                                //canvasMapContainer.nCurrentCanvasMap = index;

                                console.debug('[MapEditor]', index, listviewEvents.currentIndex);
                                //console.debug(key,value);

                                //let obj = compListItem.createObject(null, {key: 999, value: 666});
                                //listmodelEventsData.append({key: '666', value: '999'});
                            }
                            onDoubleClicked: {
                                //显示事件编辑器

                                bVisible = !bVisible;
                                dialogEvent.nEventIndex = index;
                                textEventName.text = listmodelEventsData.get(index)['EventName'];
                                ////scriptEditor.text = listmodelEventsData.get(index)['EventCode'];
                                //scriptEditor.text = objEventsData[textEventName.text];
                                //scriptEditor.editor.setPlainText(objEventsData[textEventName.text]);

                                dialogEvent.open();
                                //canvasMapContainer.arrCanvasMap[index].visible = bVisible;
                            }
                        }
                    }
                }
            }

            RowLayout {
                /*Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                Layout.preferredHeight: 30
                Layout.minimumHeight: 0
                Layout.maximumHeight: 30
                */
                anchors.fill: parent

                visible: itemToolbar.nBar === 3


                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignLeft


                    //x: 130
                    //width: 100
                    //height: 30
                    font.pointSize: _config.nFontPointSize
                    text: '铺图'
                    onClicked: {
                        let nBlockImageCols = parseInt(itemMapBlockContainer.currentMapBlock.imageMapBlock.sourceSize.width / _config.sizeMapBlockSize.width);
                        let nBlockImageRows = parseInt(itemMapBlockContainer.currentMapBlock.imageMapBlock.sourceSize.height / _config.sizeMapBlockSize.height);

                        for(let by = 0; by < _config.sizeMapSize.height; ++by) {
                            //超出地图块
                            if(by >= nBlockImageRows)
                                break;

                            //检测arrMapData是否正常
                            if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by]))
                                arrMapData[canvasMapContainer.nCurrentCanvasMap][by] = [];

                            for(let bx = 0; bx < _config.sizeMapSize.width; ++bx) {
                                //超出地图块
                                if(bx >= nBlockImageCols)
                                    break;

                                //检测arrMapData是否正常
                                //if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by0][bx0]))
                                //    arrMapData[canvasMapContainer.nCurrentCanvasMap][by0][bx0] = [-1,-1,-1];


                                arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = [bx, by, itemMapBlockContainer.currentMapBlock.nIndex];

                                //console.debug('!!!2', bx, by, nBlockImageCols, nBlockImageRows, _config.sizeMapSize.width, _config.sizeMapSize.height);
                            }
                        }

                        let ctx = canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].getContext('2d');
                        ctx.drawImage(itemMapBlockContainer.currentMapBlock.imageMapBlock.source,
                                      0, 0, itemMapBlockContainer.currentMapBlock.imageMapBlock.width / _config.nMapDrawScale, itemMapBlockContainer.currentMapBlock.imageMapBlock.height / _config.nMapDrawScale);
                        canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint();

                    }
                }

                Button {
                    //Layout.minimumWidth: 42
                    Layout.maximumWidth: implicitWidth
                    //Layout.preferredWidth: implicitWidth
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft

                    //x: 520
                    font.pointSize: _config.nFontPointSize
                    text: '粘贴'
                    onClicked: {
                        //flickableMapBlock.visible = !flickableMapBlock.visible;
                        if(rectCopy.nCopyCanvasID >= canvasMapContainer.arrCanvasMap.length || rectCopy.nCopyCanvasID < 0)
                            return;
                        if(!rectPaste.visible)
                            return;

                        let x1 = rectCopy.x + rectCopy.width - 1;
                        let y1 = rectCopy.y + rectCopy.height - 1;

                        //let bx = parseInt(rectPaste.x / _config.sizeMapBlockSize.width);
                        let by = parseInt(rectPaste.y / _config.sizeMapBlockSize.height);

                        //let bx0 = parseInt(rectCopy.x / _config.sizeMapBlockSize.width);
                        let by0 = parseInt(rectCopy.y / _config.sizeMapBlockSize.height);
                        let bx1 = parseInt(x1 / _config.sizeMapBlockSize.width);
                        let by1 = parseInt(y1 / _config.sizeMapBlockSize.height);

                        //console.debug('!!!1', parseInt(rectCopy.x / _config.sizeMapBlockSize.width), by0, bx1, by1)

                        for(; by0 <= by1; ++by0, ++by) {
                            //超出地图
                            if(by >= _config.sizeMapSize.height) {
                                //console.debug('!1', by, _config.sizeMapSize.height)
                                break;
                            }

                            //检测arrMapData是否正常
                            if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by0]))
                                arrMapData[canvasMapContainer.nCurrentCanvasMap][by0] = [];

                            let bx = parseInt(rectPaste.x / _config.sizeMapBlockSize.width);
                            let bx0 = parseInt(rectCopy.x / _config.sizeMapBlockSize.width);
                            for(; bx0 <= bx1; ++bx0, ++bx) {
                                //超出地图
                                if(bx >= _config.sizeMapSize.width) {
                                    //console.debug('!2', bx, _config.sizeMapSize.width)
                                    break;
                                }

                                //检测arrMapData是否正常
                                //if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by0][bx0]))
                                //    arrMapData[canvasMapContainer.nCurrentCanvasMap][by0][bx0] = [-1,-1,-1];


                                arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = arrMapData[rectCopy.nCopyCanvasID][by0][bx0];

                                //console.debug('!!!2', by0, bx0, bx, by, arrMapData[rectCopy.nCopyCanvasID][by0][bx0]);
                            }
                        }

                        //!!注意这里(Screen.devicePixelRatio)
                        let ctx = canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].getContext('2d');
                        ctx.drawImage(canvasMapContainer.arrCanvasMap[rectCopy.nCopyCanvasID],
                                      rectCopy.x * Screen.devicePixelRatio, rectCopy.y * Screen.devicePixelRatio,
                                      rectCopy.width * Screen.devicePixelRatio, rectCopy.height * Screen.devicePixelRatio,
                                      rectPaste.x, rectPaste.y,
                                      rectCopy.width * Screen.devicePixelRatio, rectCopy.height * Screen.devicePixelRatio);
                        canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint(); //重新绘图
                        //console.debug('!!!3', rectCopy.x, rectCopy.y, rectPaste.x, rectPaste.y, rectCopy.width, rectCopy.height)
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.maximumWidth: contentWidth
                    Layout.alignment: Qt.AlignRight

                    text: '特殊图块值：'
                }

                TextField {
                    id: textMapBlockSpecial

                    //Layout.minimumWidth: 60
                    //Layout.maximumWidth: Math.max(implicitWidth, contentWidth)
                    //Layout.preferredWidth: 100
                    //Layout.fillWidth: true
                    Layout.preferredWidth: Math.max(60, contentWidth)
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight

                    placeholderText: ''
                    text: '1'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
        }




//地图块区域
        //地图块
        Flickable {
            id: flickableMapBlock

            //Layout.preferredHeight: contentHeight
            Layout.minimumHeight: 0
            Layout.maximumHeight: contentHeight
            Layout.fillHeight: true

            Layout.preferredWidth: contentWidth
            Layout.maximumWidth: parent.width
            //Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            //x: 0;
            //y: 420;
            //width: 1020;
            //height: 500;
            implicitWidth: contentWidth
            implicitHeight: contentHeight

            clip: true

            //contentWidth: canvasMapContainer.width * canvasMapContainer.scale
            //contentHeight: canvasMapContainer.height * canvasMapContainer.scale
            //!乘以缩放比例才能正确显示
            contentWidth: itemMapBlockContainer.width * itemMapBlockContainer.scale
            contentHeight: itemMapBlockContainer.height * itemMapBlockContainer.scale

            //flickableDirection: Flickable.VerticalFlick

            boundsBehavior: Flickable.StopAtBounds  //越出时不弹动

            //所有地图块图片 的 容器
            Item {

                id: itemMapBlockContainer

                //地图块显示有多少列，然后计算行数
                property int nCols: 20
                //地图图片文件
                //property string strBlockImagePath;
                property var currentMapBlock: itemMapBlock1



                //anchors.centerIn: parent
                //width: nCols * _config.sizeMapBlockSize.width
                //height: () * _config.sizeMapBlockSize.height



                //地图块集 对象
                Item {
                    id: itemMapBlock1

                    property int nIndex: 0  //地图块标号
                    //地图块中 选择的 在原图中的块坐标(-1,-1为清除)
                    property point pointSelectedMapBlock: Qt.point(0, 0)
                    //分割地图块的 行列 数
                    property size sizeBlockCount: Qt.size(0, 0)
                    property alias imageMapBlock: imageMapBlock1
                    property alias canvasMapBlock: canvasMapBlock1

                    anchors.fill: parent


                    //图片缓存
                    Image {
                        id: imageMapBlock1
                        asynchronous: false

                        //source: strBlockImagePath
                        visible: false

                        //不知为何，安卓手机上选择媒体图片时，Image的宽和高都会小于原图的一半
                        width: sourceSize.width
                        height: sourceSize.height

                        //计算 sizeBlockCount
                        onStatusChanged: {
                            if (status === Image.Ready) {
                                //计算地图块图片所占行列数
                                parent.sizeBlockCount.width = parseInt(sourceSize.width / _config.sizeMapBlockSize.width);
                                parent.sizeBlockCount.height = parseInt(sourceSize.height / _config.sizeMapBlockSize.height);

                                itemMapBlockContainer.nCols = parent.sizeBlockCount.width; //设置为和地图块列数相同

                                //计算地图块canvas大小
                                let nBlockImageCols = parseInt(parent.imageMapBlock.sourceSize.width / _config.sizeMapBlockSize.width);
                                let nBlockImageRows = parseInt(parent.imageMapBlock.sourceSize.height / _config.sizeMapBlockSize.height);
                                itemMapBlockContainer.width = itemMapBlockContainer.nCols * _config.sizeMapBlockSize.width;//nCols * _config.sizeMapBlockSize.width;
                                itemMapBlockContainer.height = Math.ceil((nBlockImageCols * nBlockImageRows) / itemMapBlockContainer.nCols) * _config.sizeMapBlockSize.height;// * _config.sizeMapBlockSize.height;



                                /*
                                parent.canvasMapBlock.requestPaint(); //重新绘图

                                for(let k in canvasMapContainer.arrCanvasMap)
                                    canvasMapContainer.arrCanvasMap[k].requestPaint();
                                */



                                console.debug('[MapEditor]imageMapBlock Loaded:', source, sourceSize.width, sourceSize.height, itemMapBlockContainer.width, itemMapBlockContainer.height);

                            }
                            //console.debug('[MapEditor]onStatusChanged:', status);
                        }
                    }


                    //地图块
                    Canvas {
                        id: canvasMapBlock1

                        anchors.fill: parent

                        smooth: false
                        antialiasing: false

                        renderStrategy: Canvas.Threaded     //Canvas.Immediate / Canvas.Cooperative
                        renderTarget: Canvas.Image  //Canvas.FramebufferObject / Canvas.Image


                        //边框
                        Rectangle {
                            id: rectMapBlockBack
                            anchors.fill: parent

                            color: 'transparent'
                            border.color: 'black'
                        }

                        //双指缩放
                        PinchArea {
                            anchors.fill: parent

                            pinch.maximumScale: 2;
                            pinch.minimumScale: 0.5;
                            pinch.dragAxis: Pinch.XAndYAxis
                            onPinchStarted: {
                                pinch.accepted = true;
                            }
                            //!!可以缩放，没必要
                            onPinchUpdated: {
                                //parent.scale = pinch.scale;
                                //console.debug('onPinchUpdated', pinch.scale)
                            }
                            onPinchFinished: {
                                //previewImage.scale = Math.floor(pinch.scale);
                                //parent.scale = pinch.scale;
                                //console.debug('onPinchFinished', pinch.scale)

                            }

                        /* /!!!不知为何，多次旋转移动后，就点不到itemTest了（点的是MultiPointTouchArea），应该是Qt的Bug，怎么改都无效（替换Mask、移动组件位置、修改z值等等）
                        PinchHandler {
                            id: pinchHandler

                            target: itemMapBlockContainer
                            ////pinch.dragAxis: Pinch.XAndYAxis
                            //禁止旋转
                            maximumRotation: 0
                            minimumRotation: 0

                        }
                        */


                            //选择图块
                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    console.debug('[MapEditor]', mouse.x, mouse.y);

                                    //计算出鼠标点击的 块坐标 和 id号
                                    let x = parseInt(mouse.x / _config.sizeMapBlockSize.width);
                                    let y = parseInt(mouse.y / _config.sizeMapBlockSize.height);
                                    let id = x + y * itemMapBlockContainer.nCols;   //id为从左到右 从上到下的图块数
                                    //console.debug(x, itemMapBlockContainer.nCols, id , itemMapBlock1.sizeBlockCount.width * itemMapBlock1.sizeBlockCount.height)

                                    //超出范围
                                    if(x >= itemMapBlockContainer.nCols) {
                                        console.debug('[MapEditor]超出范围x:', x, itemMapBlockContainer.nCols);
                                        return;
                                    }
                                    if(id >= itemMapBlock1.sizeBlockCount.width * itemMapBlock1.sizeBlockCount.height) {
                                        console.debug('[MapEditor]超出范围y:', id, itemMapBlock1.sizeBlockCount.width, itemMapBlock1.sizeBlockCount.height,
                                                      itemMapBlock1.sizeBlockCount.width * itemMapBlock1.sizeBlockCount.height);
                                        return;
                                    }


                                    rectSelect.x = x * _config.sizeMapBlockSize.width;
                                    rectSelect.y = y * _config.sizeMapBlockSize.height;


                                    //计算点击的块 在原图中的位置
                                    let col = id % parseInt(itemMapBlock1.imageMapBlock.sourceSize.width / _config.sizeMapBlockSize.width);
                                    let row = parseInt(id / parseInt(itemMapBlock1.imageMapBlock.sourceSize.width / _config.sizeMapBlockSize.width));

                                    itemMapBlock1.pointSelectedMapBlock = Qt.point(col, row);

                                    //console.debug('选块：', id, col, row)

                                }
                            }
                        }


                        //选择框
                        Rectangle {
                            id: rectSelect
                            width: _config.sizeMapBlockSize.width
                            height: _config.sizeMapBlockSize.height
                            x: 0
                            y: 0
                            color: 'transparent'
                            border {
                                width: 3
                                color: 'red'
                            }
                        }

                        onPaint: {  //绘制图块

                            //地图块没有准备好
                            if(imageMapBlock1.status !== Image.Ready) {
                                console.debug('[MapEditor]canvasMapBlock：地图块图片没有准备好：', imageMapBlock1.status);
                                return;
                            }

                            if(!available) {
                                console.debug('[MapEditor]canvasMapBlock：地图块没有准备好：');
                                return;
                            }
                            if(!isImageLoaded(imageMapBlock1.source)) {
                                console.debug('[MapEditor]canvasMapBlock：地图块图片没有载入：');
                                //loadImage(imageMapBlock1.source);
                                return;
                            }


                            let ctx = getContext('2d');


                            //计算宽、高
                            let nBlockImageCols = parseInt(parent.imageMapBlock.sourceSize.width / _config.sizeMapBlockSize.width);
                            let nBlockImageRows = parseInt(parent.imageMapBlock.sourceSize.height / _config.sizeMapBlockSize.height);

                            //console.debug(nBlockImageCols,nBlockImageRows)


                            //循环绘制地图块
                            for(let i = 0; i < nBlockImageCols * nBlockImageRows; ++i) {
                                //x1、y1为源，x2、y2为目标
                                let x1 = (i % nBlockImageCols);
                                let y1 = parseInt(i / nBlockImageCols);
                                let x2 = i % itemMapBlockContainer.nCols;
                                let y2 = parseInt(i / itemMapBlockContainer.nCols);    //16

                                //console.debug(i, x1,y1,x2,y2);

                                ctx.drawImage(parent.imageMapBlock.source,
                                              x1 * _config.sizeMapBlockSize.width, y1 * _config.sizeMapBlockSize.height,
                                              _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height,
                                              x2 * _config.sizeMapBlockSize.width, y2 * _config.sizeMapBlockSize.height,
                                              _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);
                            }

                            console.debug('[MapEditor]canvasMapBlock onPaint', nBlockImageCols, nBlockImageRows,
                                          parent.imageMapBlock.status, '-', Image.Ready,
                                          state, available);
                        }

                        onPainted: {
                            console.debug('[MapEditor]canvasMapBlock：onPainted');
                        }

                        onImageLoaded: {    //载入图片完成
                            requestPaint(); //重新绘图
                            console.debug('[MapEditor]canvasMapBlock：onImageLoaded');

                            /*for(let k in canvasMapContainer.arrCanvasMap)
                                canvasMapContainer.arrCanvasMap[k].requestPaint();
                            */
                        }

                        onAvailableChanged: {
                            //if(available === true)
                            //    requestPaint();
                        }

                        Component.onCompleted: {
                            //loadImage(strBlockImagePath);  //载入图片
                            console.debug('[MapEditor]canvasMapBlock：onCompleted');
                        }
                    }

                }

            }
        }





        Item {
            Layout.preferredHeight: flickable.contentHeight
            Layout.minimumHeight: 10
            Layout.maximumHeight: flickable.contentHeight < parent.height ? flickable.contentHeight : parent.height;
            Layout.fillHeight: true
            //Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            //Flickable 边框
            Rectangle {
                anchors.fill: parent

                //color: 'transparent'
                color: 'black'
                border.color: 'black'
            }

            //Map绘制区的
            Flickable {
                id: flickable

                //property point pointLastContent

                //x: 0;
                //y: 420;
                implicitWidth: contentWidth < parent.width ? contentWidth : parent.width;
                implicitHeight: parent.height
                anchors.centerIn: parent
                //flickableDirection: Flickable.AutoFlickIfNeeded

                clip: true


                //!乘以缩放比例才能正确显示
                contentWidth: canvasMapContainer.width * canvasMapContainer.scale
                contentHeight: canvasMapContainer.height * canvasMapContainer.scale

                //flickableDirection: Flickable.VerticalFlick

                boundsBehavior: Flickable.StopAtBounds  //越出时不弹动

                //boundsMovement: Flickable.StopAtBounds
                //boundsBehavior: Flickable.DragAndOvershootBounds

                //pressDelay: 1000

                //synchronousDrag: true

                //mouseEnabled: _config.bMapMove


                //地图层 Canvas 容器
                //宽高由数据来计算
                Item {
                    id: canvasMapContainer

                    property real rLastScale: 1  //保存的是上次缩放比例，再次缩放时计算新的缩放比例
                    property point pointLastPos
                    property point pointScaleCenterPos: Qt.point(0, 0)

                    property int nCurrentCanvasMap: 0   //当前图层id
                    property var arrCanvasMap: []       //图层列表


                    transformOrigin: Item.TopLeft   //!!必须加这句才可以在flickable中缩放到正常位置
                    //anchors.centerIn: parent

                    transform: [
                        Rotation {  //旋转

                        },

                        Translate { //平移

                        },

                        Scale {         //缩放，如果为负则是镜像
                            origin {    //缩放围绕的 原点坐标
                                //x: canvasMapContainer.pointScaleCenterPos.x
                                //y: canvasMapContainer.pointScaleCenterPos.y
                            }
                            /*xScale:
                                rootWindow.width / Global.frameConfig.$sys.windowVirtualSize.width
                            yScale:
                                rootWindow.height / Global.frameConfig.$sys.windowVirtualSize.height
                            */
                        }


                    ]


                    Component {
                        id: compCanvas

                        Canvas {    //地图绘制区
                            id: _canvas


                            //每个地图层的标号（0开始）
                            property int index: 0
                            //地图上需重新绘制的地图块（鼠标点击）
                            property var arrMapRepaintPoint: []


                            anchors.fill: parent

                            smooth: false
                            antialiasing: false


                            renderStrategy: Canvas.Threaded     //Canvas.Immediate / Canvas.Cooperative
                            renderTarget: Canvas.Image  //Canvas.FramebufferObject / Canvas.Image



                            onPaint: {  //
                                console.debug('[MapEditor]地图层', index, 'onPaint');

                                //地图块没有准备好
                                if(imageMapBlock1.status !== Image.Ready) {
                                    console.debug('[MapEditor]Canvas：地图块图片没有准备好：', imageMapBlock1.status);
                                    return;
                                }
                                if(!available) {
                                    console.debug('[MapEditor]Canvas：地图块没有准备好：');
                                    return;
                                }
                                if(!isImageLoaded(imageMapBlock1.source)) {
                                    console.debug('[MapEditor]Canvas：地图块图片没有载入：');
                                    //loadImage(imageMapBlock1.source);
                                    return;
                                }


                                //console.time('onPaint');
                                let ctx = getContext('2d');


                                /*/循环绘制地图块
                                //行
                                for(let y in arrMapData) {
                                    //列
                                    for(let x in arrMapData[y]) {

                                        //跳过空的
                                        if(arrMapData[y][x] === undefined || arrMapData[y][x].x === -1 || arrMapData[y][x].y === -1)
                                            continue;

                                        //删除块
                                        if(arrMapData[y][x].x === -2 && arrMapData[y][x].y === -2) {
                                            ctx.fillStyle = 'white';
                                            ctx.fillRect(x * _config.sizeMapBlockSize.width, y * _config.sizeMapBlockSize.height, _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);
                                            arrMapData[y][x] = Qt.point(-1,-1);
                                        }

                                        //console.debug(arrMapData[y][x].x * _config.sizeMapBlockSize.width, arrMapData[y][x].y * _config.sizeMapBlockSize.height,
                                        //              x * _config.sizeMapBlockSize.width, y * _config.sizeMapBlockSize.height)

                                        //绘制图块
                                        else {
                                            ctx.drawImage(itemMapBlockContainer.currentMapBlock.imageMapBlock.source,
                                                arrMapData[y][x].x * _config.sizeMapBlockSize.width, arrMapData[y][x].y * _config.sizeMapBlockSize.height,
                                                _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height,
                                                x * _config.sizeMapBlockSize.width, y * _config.sizeMapBlockSize.height,
                                                _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);
                                        }
                                    }

                                }*/

                                while(1) {
                                    //let mapRepaintPoint = canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].arrMapRepaintPoint.pop();
                                    let mapRepaintPoint = arrMapRepaintPoint.pop();
                                    //console.debug('[MapEditor]mapRepaintPoint', mapRepaintPoint);

                                    if(mapRepaintPoint === undefined || mapRepaintPoint.x === -1 || mapRepaintPoint.y === -1) {
                                        //console.timeEnd('onPaint');
                                        break;
                                    }


                                    //清除块
                                    if(_config.bMapClean/* && arrMapData[canvasMapContainer.nCurrentCanvasMap][mapRepaintPoint.y][mapRepaintPoint.x] === Qt.point(-1, -1)*/) {
                                        ctx.clearRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width / _config.nMapDrawScale, mapRepaintPoint.y * _config.sizeMapBlockSize.height / _config.nMapDrawScale,
                                                      _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);

                                        //console.debug('删除', y, x, arrMapData[y][x])
                                    }
                                    /*/障碍物
                                    else if(_config.bMapDraw && canvasMapContainer.nCurrentCanvasMap === 0/* && arrMapData[0][y][x] !== Qt.point(0, 0)* /) {
                                        ctx.clearRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width, mapRepaintPoint.y * _config.sizeMapBlockSize.height,
                                                      _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);

                                        ctx.fillStyle = Qt.rgba(255,0,0,0.4);
                                        ctx.fillRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width, mapRepaintPoint.y * _config.sizeMapBlockSize.height,
                                                      _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);

                                        //console.debug('设置障碍2', y, x, arrMapData[0][y][x]);
                                    }
                                    //事件
                                    else if(_config.bMapDraw && canvasMapContainer.nCurrentCanvasMap === 1/* && arrMapData[1][y][x] !== Qt.point(0, 0)* /) {
                                        ctx.clearRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width, mapRepaintPoint.y * _config.sizeMapBlockSize.height,
                                                      _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);

                                        ctx.fillStyle = Qt.rgba(0,255,0,0.4);
                                        ctx.fillRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width, mapRepaintPoint.y * _config.sizeMapBlockSize.height,
                                                      _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);
                                    }*/
                                    //绘制地图
                                    else {
                                        //console.debug('mapRepaintPoint', mapRepaintPoint)
                                        /*console.debug(itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.x,
                                                      itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.y,
                                                      index, mapRepaintPoint,
                                                      arrMapData[index][mapRepaintPoint.y][mapRepaintPoint.x])*/

                                        ctx.clearRect(mapRepaintPoint.x * _config.sizeMapBlockSize.width / _config.nMapDrawScale, mapRepaintPoint.y * _config.sizeMapBlockSize.height / _config.nMapDrawScale,
                                                      _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);

                                        ctx.drawImage(itemMapBlockContainer.currentMapBlock.imageMapBlock.source,
                                                      arrMapData[index][mapRepaintPoint.y][mapRepaintPoint.x][0] * _config.sizeMapBlockSize.width,
                                                      arrMapData[index][mapRepaintPoint.y][mapRepaintPoint.x][1] * _config.sizeMapBlockSize.height,
                                                      //itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.x * _config.sizeMapBlockSize.width,
                                                      //itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.y * _config.sizeMapBlockSize.height,
                                                      _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height,
                                                      mapRepaintPoint.x * _config.sizeMapBlockSize.width / _config.nMapDrawScale, mapRepaintPoint.y * _config.sizeMapBlockSize.height / _config.nMapDrawScale,
                                                      _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);

                                        //console.debug('画', y, x, arrMapData[y][x])
                                    }
                                }
                                //mapRepaintPoint = Qt.point(-1, -1)

                                //console.timeEnd('onPaint');
                            }

                            onPainted: {
                                console.debug('[MapEditor]canvas：onPainted');
                            }

                            onImageLoaded: {
                                requestPaint();
                                console.debug('[MapEditor]canvas：onImageLoaded');
                            }

                            onAvailableChanged: {
                                //if(available === true)
                                //    requestPaint();
                            }
                        }

                    }

                    //Canvas边框
                    Rectangle {
                        anchors.fill: parent

                        color: 'black'
                        border.color: 'red'
                        border.width: 5
                    }


                    Canvas {
                        id: canvasBlockSpecial


                        anchors.fill: parent
                        z: 998

                        smooth: false
                        antialiasing: false


                        renderStrategy: Canvas.Threaded     //Canvas.Immediate / Canvas.Cooperative
                        renderTarget: Canvas.Image  //Canvas.FramebufferObject / Canvas.Image



                        //重新将 objMapBlockSpecialData 绘制
                        function rePaint() {
                            $CommonLibJS.Utils.clearCanvas(canvasBlockSpecial);

                            //地图上绘制 特殊图块
                            let ctx = getContext('2d');
                            for(let i in objMapBlockSpecialData) {
                                let p = i.split(',');
                                let bx = parseInt(p[0]);
                                let by = parseInt(p[1]);

                                //如果越界
                                if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height) {
                                    delete objMapBlockSpecialData[i];
                                    continue;
                                }

                                canvasBlockSpecial.paintBlock(bx, by, objMapBlockSpecialData[i], ctx);
                            }

                            requestPaint();
                        }

                        //绘制一块
                        function paintBlock(bx, by, specialValue, ctx) {
                            if(_private.objSpecialInfo[specialValue])
                                ctx.fillStyle = _private.objSpecialInfo[specialValue].Color;
                            else
                                ctx.fillStyle = Qt.rgba(1, 0.5, 0.5, 0.6);
                            ctx.fillRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);
                        }
                    }

                    Canvas {
                        id: canvasEvent


                        anchors.fill: parent
                        z: 998

                        smooth: false
                        antialiasing: false


                        renderStrategy: Canvas.Threaded     //Canvas.Immediate / Canvas.Cooperative
                        renderTarget: Canvas.Image  //Canvas.FramebufferObject / Canvas.Image



                        //重新将 objMapBlockSpecialData 绘制
                        function rePaint() {
                            $CommonLibJS.Utils.clearCanvas(canvasEvent);

                            //地图上绘制 事件

                            let tmpEventIndex = []; //保存所有事件名 对应的 显示关键字
                            for(let i = 0; i < listmodelEventsData.count; ++i) {
                                tmpEventIndex.push(listmodelEventsData.get(i)['EventName']);
                            }

                            let ctx = canvasEvent.getContext('2d');

                            for(let i in objMapEventsData) {
                                let p = i.split(',');
                                let bx = parseInt(p[0]);
                                let by = parseInt(p[1]);

                                //如果越界
                                if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height) {
                                    delete objMapEventsData[i];
                                    continue;
                                }

                                canvasEvent.paintBlock(bx, by, tmpEventIndex.indexOf(objMapEventsData[i]).toString(), ctx);
                            }

                            requestPaint();
                        }

                        //绘制一块
                        function paintBlock(bx, by, text, ctx) {
                            ctx.fillStyle = Qt.rgba(0.5, 0.5, 1, 0.6);
                            //绘制方块
                            ctx.fillRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);

                            //绘制文字
                            //let eventID = listviewEvents.currentIndex1;
                            //ctx.textAlign='left';
                            //ctx.textBaseLine='middle';
                            ctx.strokeStyle = 'blue';
                            ctx.lineWidth = 1;
                            ctx.font = 'bold %1px 微软雅黑'.arg(_config.sizeMapBlockSize.height / 2 / _config.nMapDrawScale);
                            //console.debug('tmpEventIndex', tmpEventIndex, objMapEventsData[i], tmpEventIndex.indexOf(objMapEventsData[i]), tmpEventIndex.indexOf(objMapEventsData[i]).toString())
                            ctx.strokeText(text, (bx + 0.4) * _config.sizeMapBlockSize.width / _config.nMapDrawScale, (by + 0.2 + 0.5) * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale);

                            //console.debug('绘制方块', bx, by, (bx + 0.4), (by + 0.2), (bx + 0.4) * _config.sizeMapBlockSize.width)
                        }
                    }


                    //复制区域
                    Rectangle {
                        id: rectCopy

                        property int nCopyCanvasID: -1
                        property point pointStart


                        color: '#7F00FF00'
                        visible: false
                        z: 998
                    }

                    //粘贴区域
                    Rectangle {
                        id: rectPaste

                        property point pointStart

                        color: '#7FFFFFFF'
                        border.color: 'red'
                        border.width: 2
                        visible: false
                        //width: 20
                        //height: 20
                        z: 998

                    }
                }



                //捏拉手势（必须放在Flickable中，否则Flickable的鼠标事件失效）
                //两种方法：1：设置target；2：处理3个信号（可以多item同时）
                PinchArea {
                    anchors.fill: parent
                    //x: flickable.x
                    //y: flickable.y
                    //width: flickable.width
                    //height: flickable.height

                    pinch {
                        //target: parent  //要操作的item
                        //active  //目标是否正在被拖动
                        //最小最大缩放系数
                        maximumScale: 2
                        minimumScale: 0.5
                        //最小最大旋转角度
                        //pinch.maximumRotation:
                        //pinch.minimumRotation:
                        //最小最大拖动位置
                        //maximumX:
                        //maximumY:
                        //minimumX:
                        //minimumY:

                        //沿X、Y轴拖动（XAxis、YAxis、NoDrag）
                        dragAxis: Pinch.XAndYAxis
                    }



                    //第一次识别到捏拉事件时发出，要处理它则要将：pinch.accepted = true;
                    onPinchStarted: {
                        pinch.accepted = true;

                        canvasMapContainer.pointScaleCenterPos = canvasMapContainer.pointLastPos = Qt.point(pinch.center.x, pinch.center.y);
                        //flickable.pointLastContent.x = pinch.center.x;
                        //flickable.pointLastContent.y = pinch.center.y;
                    }
                    //pinch.accepted = true;后，pinchUpdated信号就不断地发射。
                    //!!注意每次发送的pinch.scale都是从1开始的，并不是从上次继续的。
                    onPinchUpdated: {
                        canvasMapContainer.scale = canvasMapContainer.rLastScale * pinch.scale;
                        //console.debug('onPinchUpdated', pinch.scale);

                        if(flickable.width < flickable.contentWidth) {
                            let resultX = parseInt(flickable.contentX + (canvasMapContainer.pointLastPos.x - pinch.center.x));
                            if(resultX < 0)
                                flickable.contentX = 0;
                            else if(resultX > flickable.contentWidth - flickable.width)
                                flickable.contentX = flickable.contentWidth - flickable.width;
                            else
                                flickable.contentX = resultX;
                            //flickable.contentX += (canvasMapContainer.pointLastPos.x - pinch.center.x);
                        }
                        if(flickable.height < flickable.contentHeight) {
                            let resultY = parseInt(flickable.contentY + (canvasMapContainer.pointLastPos.y - pinch.center.y));
                            if(resultY < 0)
                                flickable.contentY = 0;
                            else if(resultY > flickable.contentHeight - flickable.height)
                                flickable.contentY = flickable.contentHeight - flickable.height;
                            else
                                flickable.contentY = resultY;
                            //flickable.contentY += (canvasMapContainer.pointLastPos.y - pinch.center.y);
                        }
                        //canvasMapContainer.pointLastPos = Qt.point(pinch.center.x, pinch.center.y);


                        /*if(pinch.scale > 1) {
                            flickable.contentX = pinch.center.x / canvasMapContainer.scale;
                            flickable.contentY = pinch.center.y / canvasMapContainer.scale;

                            //flickable.contentX = flickable.pointLastContent.x + (pinch.scale - 1) * pinch.center.x;
                            //flickable.contentY = flickable.pointLastContent.y + (pinch.scale - 1) * pinch.center.y;
                        }
                        else {
                            flickable.contentX = pinch.center.x / canvasMapContainer.scale;
                            flickable.contentY = pinch.center.y / canvasMapContainer.scale;

                            //flickable.contentX = flickable.pointLastContent.x + (1 - canvasMapContainer.scale) * pinch.center.x;
                            //flickable.contentY = flickable.pointLastContent.y + (1 - canvasMapContainer.scale) * pinch.center.y;
                        }

                        if(flickable.width >= flickable.contentWidth || flickable.contentX < 0) {
                            flickable.contentX = 0;
                            //console.debug('!!!11', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        else if(flickable.contentX + flickable.width > flickable.contentWidth) {
                            flickable.contentX = flickable.contentWidth - flickable.width;
                            //console.debug('!!!12', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }

                        if(flickable.height >= flickable.contentHeight || flickable.contentY < 0) {
                            flickable.contentY = 0;
                            //console.debug('!!!21', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        else if(flickable.contentY + flickable.height > flickable.contentHeight) {
                            flickable.contentY = flickable.contentHeight - flickable.height;
                            //console.debug('!!!22', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        //console.debug('!!!pinch1', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY, pinch.point1.x, pinch.point1.y)
                        console.debug('!!!pinch1', pinch.center.x / canvasMapContainer.scale, pinch.center.y / canvasMapContainer.scale)
                        */

                    }
                    //手指离开时触发
                    onPinchFinished: {
                        //previewImage.scale = Math.floor(pinch.scale);
                        canvasMapContainer.scale = canvasMapContainer.rLastScale * pinch.scale;
                        //console.debug('onPinchFinished', pinch.scale);
                        canvasMapContainer.rLastScale = canvasMapContainer.scale;


                        /*if(pinch.scale > 1) {
                            flickable.contentX = pinch.center.x;
                            flickable.contentY = pinch.center.y;

                            //flickable.contentX = flickable.pointLastContent.x + (pinch.scale - 1) * pinch.center.x;
                            //flickable.contentY = flickable.pointLastContent.y + (pinch.scale - 1) * pinch.center.y;
                        }
                        else {
                            flickable.contentX = pinch.center.x;
                            flickable.contentY = pinch.center.y;

                            //flickable.contentX = flickable.pointLastContent.x + (1 - canvasMapContainer.scale) * pinch.center.x;
                            //flickable.contentY = flickable.pointLastContent.y + (1 - canvasMapContainer.scale) * pinch.center.y;
                        }

                        if(flickable.width >= flickable.contentWidth || flickable.contentX < 0) {
                            flickable.contentX = 0;
                            //console.debug('!!!11', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        else if(flickable.contentX + flickable.width > flickable.contentWidth) {
                            flickable.contentX = flickable.contentWidth - flickable.width;
                            //console.debug('!!!12', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }

                        if(flickable.height >= flickable.contentHeight || flickable.contentY < 0) {
                            flickable.contentY = 0;
                            //console.debug('!!!21', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        else if(flickable.contentY + flickable.height > flickable.contentHeight) {
                            flickable.contentY = flickable.contentHeight - flickable.height;
                            //console.debug('!!!22', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                        }
                        console.debug('!!!pinch2', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY, pinch.center.x, pinch.center.y)
                        */
                    }


                /*/!!!不知为何，多次旋转移动后，就点不到itemTest了（点的是MultiPointTouchArea），应该是Qt的Bug，怎么改都无效（替换Mask、移动组件位置、修改z值等等）
                PinchHandler {
                    id: pinchHandler

                    target: parent
                    ////pinch.dragAxis: Pinch.XAndYAxis
                    //禁止旋转
                    maximumRotation: 0
                    minimumRotation: 0

                }*/

                    //!!这个鼠标事件貌似必须放在Pinch中，否则不能响应Pinch
                    MouseArea {  //可以处理滚轮缩放（如果处理绘制，则会和Flickable的拖动冲突）
                        anchors.fill: parent
                        //width: flickable.width
                        //height: flickable.height
                        onPressed: {
                            //console.debug('flickable onPressed', pinch.width, pinch.height, pinch.scale, flickable.width, flickable.height, flickable.scale)
                            let bx = parseInt((mouse.x) / _config.sizeMapBlockSize.width / canvasMapContainer.scale * _config.nMapDrawScale);
                            let by = parseInt((mouse.y) / _config.sizeMapBlockSize.height / canvasMapContainer.scale * _config.nMapDrawScale);

                            rectPaste.x = bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                            rectPaste.y = by * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                            rectPaste.width = _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                            rectPaste.height = _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                            rectPaste.visible = true;
                            textTips.refresh(bx, by);

                            //$Platform.sl_showToast('%1,%2'.arg(bx).arg(by));
                            //console.debug(bx, by);
                        }
                        onPositionChanged: {
                            //console.debug('flickable onPositionChanged', pinch.width, pinch.height, pinch.scale, flickable.width, flickable.height, flickable.scale)
                        }
                        onWheel:{
                            //console.debug('!!!', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY, wheel.x, wheel.y)

                            if(wheel.angleDelta.y > 0) {
                                //调整坐标
                                flickable.contentX = wheel.x * 1.2 - flickable.width / 2;
                                flickable.contentY = wheel.y * 1.2 - flickable.height / 2;

                                canvasMapContainer.scale *= 1.2;
                                canvasMapContainer.rLastScale = canvasMapContainer.scale;

                            }
                            else {
                                //调整坐标
                                flickable.contentX = wheel.x * 0.8 - flickable.width / 2;
                                flickable.contentY = wheel.y * 0.8 - flickable.height / 2;

                                canvasMapContainer.scale *= 0.8;
                                canvasMapContainer.rLastScale = canvasMapContainer.scale;

                                /*let newWidth = flickable.contentWidth*0.8;
                                let newHeight = flickable.contentHeight*0.8;

                                if(newWidth > flickable.width) {     //判断缩放后的contentWidth是否会小于Flickable的width
                                    flickable.contentWidth = newWidth;
                                    flickable.contentX = flickable.contentX - 0.2 * wheel.x;
                                    if(flickable.contentX < 0) {    //如果此时内容已经到达边界，则不继续移动
                                        flickable.contentX = 0;
                                    }
                                }
                                if(newHeight > flickable.height) {
                                    flickable.contentHeight = newHeight;
                                    flickable.contentY = flickable.contentY - 0.2 * wheel.y;
                                    if(flickable.contentY < 0) {
                                        flickable.contentY = 0;
                                    }
                                }
                                */

                            }

                            //调整坐标
                            if(flickable.width >= flickable.contentWidth || flickable.contentX < 0) {
                                flickable.contentX = 0;
                                //console.debug('!!!11', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                            }
                            else if(flickable.contentX + flickable.width > flickable.contentWidth) {
                                flickable.contentX = flickable.contentWidth - flickable.width;
                                //console.debug('!!!12', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                            }

                            if(flickable.height >= flickable.contentHeight || flickable.contentY < 0) {
                                flickable.contentY = 0;
                                //console.debug('!!!21', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                            }
                            else if(flickable.contentY + flickable.height > flickable.contentHeight) {
                                flickable.contentY = flickable.contentHeight - flickable.height;
                                //console.debug('!!!22', flickable.width, flickable.height, flickable.contentWidth, flickable.contentHeight, flickable.contentX, flickable.contentY)
                            }

                        }
                    }

                    /*Rectangle {
                        anchors.fill: parent
                        //width: flickable.width
                        //height: flickable.height
                        color: 'transparent'
                        border.color: 'yellow'
                    }*/
                }
            }

            //绘制事件
            //只能放在这里，如果放在Flickable，会和拖动冲突导致不能正常绘图。
            MouseArea {

                //鹰：曲线救国（安卓上的长按有问题）
                property point pointMousePressBegin //Press时的坐标
                property point pointLastDraw //上一次有效绘制时的坐标
                property int nMousePressType: 0 //0为初始；1为单击；2为双击；3为长按


                //property int nOpType: 0    //0为空；1为绘制地图；2为绘制事件

                //anchors.fill: flickable
                x: flickable.x
                y: flickable.y
                width: flickable.width
                height: flickable.height

                enabled: !_config.bMapMove

                //propagateComposedEvents: true   //鼠标事件即可通过该MouseArea传递到其下层（Mousea之间的关系不一定非要是parent关系），mouse.accepted=true 可以让事件不传递
                acceptedButtons: Qt.AllButtons  //Qt.LeftButton | Qt.RightButton


                //绘制地图
                function drawMap(bx, by) {

                    //地图层个数为0
                    if(canvasMapContainer.arrCanvasMap.length === 0)
                        return;

                    //console.time('drawMap');

                    //如果是清除模式
                    if(_config.bMapClean) {
                        /*/如果是障碍层
                        if(canvasMapContainer.nCurrentCanvasMap === 0) {
                            if(arrMapData[0][by][bx] !== -1) {
                                arrMapData[0][by][bx] = -1;
                                arrMapRepaintPoint.push(Qt.point(bx, by));
                                canvasMapContainer.arrCanvasMap[0].requestPaint(); //重新绘图
                            }
                        }
                        //如果是事件层
                        else if(canvasMapContainer.nCurrentCanvasMap === 1) {
                            if(arrMapData[1][by][bx] !== -1) {
                                arrMapData[1][by][bx] = -1;
                                arrMapRepaintPoint.push(Qt.point(bx, by));
                                canvasMapContainer.arrCanvasMap[1].requestPaint(); //重新绘图
                            }
                        }
                        //地图层
                        else {
                            if(arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx].toString() !== '-1,-1,-1') {
                                arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = [-1,-1,-1];   //
                                arrMapRepaintPoint.push(Qt.point(bx, by));
                                canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint(); //重新绘图
                            }
                        }*/

                        //地图层，且有图块
                        if(arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx].toString() !== '-1,-1,-1') {
                            arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = [-1,-1,-1];   //
                            canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].arrMapRepaintPoint.push(Qt.point(bx, by));
                            canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint(); //重新绘图
                        }
                        //console.debug('删除', by, bx, arrMapData[by][bx])
                    }

                    /*/障碍物
                    else if(canvasMapContainer.nCurrentCanvasMap === 0) {
                        if(arrMapData[0][by][bx] !== 1) {
                            arrMapData[0][by][bx] = 1;   //
                            arrMapRepaintPoint.push(Qt.point(bx, by));
                            canvasMapContainer.arrCanvasMap[0].requestPaint(); //重新绘图

                            //console.debug('设置障碍', by, bx, arrMapData[0][by][bx]);
                        }
                    }

                    //事件
                    else if(canvasMapContainer.nCurrentCanvasMap === 1) {
                        if(arrMapData[1][by][bx] !== 1) {
                            arrMapData[1][by][bx] = 1;   //
                            arrMapRepaintPoint.push(Qt.point(bx, by));
                            canvasMapContainer.arrCanvasMap[1].requestPaint(); //重新绘图
                        }
                    }*/

                    //绘制模式
                    else {
                        //检测arrMapData是否正常
                        if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by]))
                            arrMapData[canvasMapContainer.nCurrentCanvasMap][by] = [];
                        else if(!$CommonLibJS.isArray(arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx]))
                            arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = [-1,-1,-1];
                        else {
                            //图块相同，则不绘
                            let _block = arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx];
                            if(
                                _block[2] === itemMapBlockContainer.currentMapBlock.nIndex &&     //地图块相同
                                _block[0] === itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.x && //x相同
                                _block[1] === itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.y   //y相同
                              )
                                return;
                        }

                        arrMapData[canvasMapContainer.nCurrentCanvasMap][by][bx] = [itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.x, itemMapBlockContainer.currentMapBlock.pointSelectedMapBlock.y, itemMapBlockContainer.currentMapBlock.nIndex];
                        canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].arrMapRepaintPoint.push(Qt.point(bx, by));
                        canvasMapContainer.arrCanvasMap[canvasMapContainer.nCurrentCanvasMap].requestPaint(); //重新绘图


                        //console.debug(bx,by)
                    }
                    //else
                        //console.debug('err:', _config.bMapBlockSpecial, arrMapData[0][by][bx])
                    //mouse.accept = true;  //无用

                    //console.timeEnd('drawMap');
                }

                //绘制事件
                function drawEvent(bx, by) {

                    //地图层个数为0
                    if(canvasMapContainer.arrCanvasMap.length === 0)
                        return;

                    if(listmodelEventsData.count === 0)
                        return;

                    let strIndex = [bx, by].toString();


                    /*console.debug('strIndex', strIndex, objMapEventsData[strIndex]);
                    console.debug(listmodelEventsData, listmodelEventsData.count)
                    console.debug(listmodelEventsData.get(listviewEvents.currentIndex))
                    console.debug(JSON.stringify(listmodelEventsData.get(listviewEvents.currentIndex)))
                    console.debug(listmodelEventsData.get(listviewEvents.currentIndex).EventName)
                    //console.debug(listmodelEventsData.get(listviewEvents.currentIndex).index)   //undefined
                    //console.debug(listmodelEventsData[listviewEvents.currentIndex])    //undefined
                    */


                    //如果是清除模式
                    if(_config.bMapClean) {
                        if(objMapEventsData[strIndex] === undefined)
                            return;

                        delete objMapEventsData[strIndex];

                        let ctx = canvasEvent.getContext('2d');
                        ctx.clearRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);
                        canvasEvent.markDirty(Qt.rect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale));

                    }
                    else {
                        //console.debug('objMapEventsData', JSON.stringify(objMapEventsData));

                        //如果已经定义过事件
                        //if(objMapEventsData[strIndex] !== undefined)
                        //    return;

                        objMapEventsData[strIndex] = listmodelEventsData.get(listviewEvents.currentIndex)['EventName'];


                        //绘制
                        let ctx = canvasEvent.getContext('2d');
                        ctx.clearRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);
                        canvasEvent.paintBlock(bx, by, listviewEvents.currentIndex.toString(), ctx);

                        canvasEvent.markDirty(Qt.rect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale));

                    }

                    //console.debug('绘制事件：', bx, by);

                }


                //绘制特殊图块
                function drawBlockSpecial(bx, by) {

                    //地图层个数为0
                    if(canvasMapContainer.arrCanvasMap.length === 0)
                        return;

                    let strIndex = [bx, by].toString();


                    /*console.debug('strIndex', strIndex, objMapBlockSpecialData[strIndex]);
                    */

                    //如果是清除模式
                    if(_config.bMapClean) {
                        if(objMapBlockSpecialData[strIndex] === undefined)
                            return;

                        delete objMapBlockSpecialData[strIndex];

                        let ctx = canvasBlockSpecial.getContext('2d');
                        ctx.clearRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);
                        canvasBlockSpecial.markDirty(Qt.rect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale));

                    }
                    else {
                        console.debug('objMapBlockSpecialData', objMapBlockSpecialData, parseInt(textMapBlockSpecial.text));

                        //如果已经定义过
                        //if(objMapBlockSpecialData[strIndex] !== undefined)
                        //    return;

                        let specialValue;
                        try {
                            specialValue = eval(textMapBlockSpecial.text);
                        }
                        //如果值无效
                        catch(e) {
                            $dialog.show({
                                Msg: '特殊图块值无效，请输入一个数字（支持二进制、八进制和十六进制）',
                                Buttons: Dialog.Yes,
                                OnAccepted: function() {
                                    return;
                                },
                                OnRejected: ()=>{
                                    return;
                                },
                            });
                            return;
                        }


                        //!!障碍ID
                        objMapBlockSpecialData[strIndex] = specialValue;

                        let ctx = canvasBlockSpecial.getContext('2d');
                        ctx.clearRect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale);
                        canvasBlockSpecial.paintBlock(bx, by, specialValue, ctx);

                        /*ctx.strokeStyle = 'blue';
                        ctx.lineWidth = 1;
                        ctx.font = 'bold 30px 微软雅黑';
                        ctx.strokeText(listviewEvents.currentIndex.toString(), bx * _config.sizeMapBlockSize.width, by * _config.sizeMapBlockSize.height);
                        */


                        canvasBlockSpecial.markDirty(Qt.rect(bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale, by * _config.sizeMapBlockSize.height / _config.nMapDrawScale, _config.sizeMapBlockSize.width / _config.nMapDrawScale, _config.sizeMapBlockSize.height / _config.nMapDrawScale));

                    }

                    //console.debug('绘制特殊：', bx, by);
                }

                onPressed: {
                    if(mouse.button === Qt.RightButton) {
                        mouse.accepted = false;
                        return;
                    }

                    //nOpType = 1;
                    //console.debug(mouse.x, mouse.y);
                    //drawMap(mouse);
                    //flickable.enabled = false;
                    pointMousePressBegin = Qt.point(mouse.x, mouse.y);
                    pointLastDraw = Qt.point(-1, -1);

                    _config.bMapClean = false;

                    mouse.accepted = true;
                }
                //点击且移动
                onPositionChanged: {
                    //console.debug('onPositionChanged', mouse.x, mouse.y);

                    //如果 nMousePressType 还没确认，且鼠标移动，则为单击移动
                    if(nMousePressType === 0 && pointMousePressBegin !== Qt.point(mouse.x, mouse.y))
                        nMousePressType = 1;


                    //x、y是 canvasMapContainer 上的 地图帧的图块坐标（鼠标点击），arrMapData[y][x]是原图的坐标（都是块坐标）
                    //!!必须加上flickable的content坐标，且除以canvasMapContainer.scale才是正常的缩放后的坐标
                    let bx = parseInt((mouse.x + flickable.contentX) / _config.sizeMapBlockSize.width / canvasMapContainer.scale * _config.nMapDrawScale);
                    let by = parseInt((mouse.y + flickable.contentY) / _config.sizeMapBlockSize.height / canvasMapContainer.scale * _config.nMapDrawScale);

                    //如果越界
                    if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height)
                        return;

                    if(pointLastDraw === Qt.point(bx, by))
                        return;
                    else
                        pointLastDraw = Qt.point(bx, by);


                    /*switch(nMousePressType) {
                    case 1:
                        drawMap(mouse);
                        break;
                    case 2:
                        drawEvent(mouse);
                        break;
                    case 3:
                        drawBlockSpecial(mouse);
                        break;
                    }*/
                    if(nMousePressType === 1 || nMousePressType === 2) {
                        if(_config.bMapDraw) {
                            drawMap(bx, by);
                        }
                        else if(_config.bMapEvent) {
                            drawEvent(bx, by);
                        }
                        else if(_config.bMapBlockSpecial) {
                            drawBlockSpecial(bx, by);
                        }
                    }
                    //复制选区
                    else if(nMousePressType === 3) {
                        if(bx === rectCopy.pointStart.x) {
                            rectCopy.x = bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                            rectCopy.width = _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                        }
                        else if(bx < rectCopy.pointStart.x) {
                            rectCopy.x = bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                            rectCopy.width = (rectCopy.pointStart.x - bx + 1) * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                        }
                        else {
                            ++bx;

                            rectCopy.x = rectCopy.pointStart.x * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                            rectCopy.width = (bx - rectCopy.pointStart.x) * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                        }
                        if(by === rectCopy.pointStart.y) {
                            rectCopy.y = by * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                            rectCopy.height = _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                        }
                        else if(by < rectCopy.pointStart.y) {
                            rectCopy.y = by * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                            rectCopy.height = (rectCopy.pointStart.y - by + 1) * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                        }
                        else {
                            ++by;

                            rectCopy.y = rectCopy.pointStart.y * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                            rectCopy.height = (by - rectCopy.pointStart.y) * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                        }

                        //console.debug('!!!', bx, by, rectCopy.x, rectCopy.y, pointMousePressBegin.x, pointMousePressBegin.y)
                    }

                    mouse.accepted = true;
                }
                onReleased: {
                    console.debug('[MapEditor]onReleased：', nMousePressType);

                    nMousePressType = 0;
                    //nOpType = 0;
                    //flickable.enabled = true;
                    mouse.accepted = true;
                }

                onClicked: {
                    //x、y是 canvasMapContainer 上的 地图帧的图块坐标（鼠标点击），arrMapData[y][x]是原图的坐标（都是块坐标）
                    //!!必须加上flickable的content坐标，且除以canvasMapContainer.scale才是正常的缩放后的坐标
                    let bx = parseInt((mouse.x + flickable.contentX) / _config.sizeMapBlockSize.width / canvasMapContainer.scale * _config.nMapDrawScale);
                    let by = parseInt((mouse.y + flickable.contentY) / _config.sizeMapBlockSize.height / canvasMapContainer.scale * _config.nMapDrawScale);

                    //如果越界
                    if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height)
                        return;


                    //如果 nMousePressType 还没确认，且鼠标没有移动，则为单击
                    //if(nMousePressType === 0 && pointMousePressBegin === Qt.point(mouse.x, mouse.y))
                    //    drawMap(mouse);

                    if(nMousePressType === 0) {
                        if(_config.bMapDraw) {
                            drawMap(bx, by);
                        }
                        else if(_config.bMapEvent) {
                            drawEvent(bx, by);
                        }
                        else if(_config.bMapBlockSpecial) {
                            drawBlockSpecial(bx, by);
                        }
                    }


                    rectPaste.x = bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                    rectPaste.y = by * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                    rectPaste.width = _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                    rectPaste.height = _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                    rectPaste.visible = true;
                    textTips.refresh(bx, by);

                    //$Platform.sl_showToast('%1,%2'.arg(bx).arg(by));
                }

                onDoubleClicked: {

                    //x、y是 canvasMapContainer 上的 地图帧的图块坐标（鼠标点击），arrMapData[y][x]是原图的坐标（都是块坐标）
                    //!!必须加上flickable的content坐标，且除以canvasMapContainer.scale才是正常的缩放后的坐标
                    let bx = parseInt((mouse.x + flickable.contentX) / _config.sizeMapBlockSize.width / canvasMapContainer.scale * _config.nMapDrawScale);
                    let by = parseInt((mouse.y + flickable.contentY) / _config.sizeMapBlockSize.height / canvasMapContainer.scale * _config.nMapDrawScale);

                    //如果越界
                    if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height)
                        return;


                    //nOpType = 2;
                    nMousePressType = 2;
                    //drawEvent(mouse);
                    _config.bMapClean = true;

                    if(_config.bMapDraw) {
                        drawMap(bx, by);
                    }
                    else if(_config.bMapEvent) {
                        drawEvent(bx, by);
                    }
                    else if(_config.bMapBlockSpecial) {
                        drawBlockSpecial(bx, by);
                    }
                }

                onPressAndHold: {

                    //x、y是 canvasMapContainer 上的 地图帧的图块坐标（鼠标点击），arrMapData[y][x]是原图的坐标（都是块坐标）
                    //!!必须加上flickable的content坐标，且除以canvasMapContainer.scale才是正常的缩放后的坐标
                    let bx = parseInt((mouse.x + flickable.contentX) / _config.sizeMapBlockSize.width / canvasMapContainer.scale * _config.nMapDrawScale);
                    let by = parseInt((mouse.y + flickable.contentY) / _config.sizeMapBlockSize.height / canvasMapContainer.scale * _config.nMapDrawScale);

                    //如果越界
                    if(bx < 0 || by < 0 || bx >= _config.sizeMapSize.width || by >= _config.sizeMapSize.height)
                        return;


                    //如果 nMousePressType 还没确认，且鼠标没有移动，则为长按移动
                    if(nMousePressType === 0 && pointMousePressBegin === Qt.point(mouse.x, mouse.y)) {
                        nMousePressType = 3;
                        //drawBlockSpecial(mouse);


                        rectCopy.x = bx * _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                        rectCopy.y = by * _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                        rectCopy.width = _config.sizeMapBlockSize.width / _config.nMapDrawScale;
                        rectCopy.height = _config.sizeMapBlockSize.height / _config.nMapDrawScale;
                        rectCopy.pointStart.x = bx;
                        rectCopy.pointStart.y = by;
                        rectCopy.nCopyCanvasID = canvasMapContainer.nCurrentCanvasMap;
                        rectCopy.visible = true;
                        //console.debug('!!!2', x, y, mouse.x, mouse.y, rectCopy.x, rectCopy.y, pointMousePressBegin.x, pointMousePressBegin.y)
                    }

                }
            }
        }

        /*Rectangle {
            //anchors.bottom: parent.top
            Layout.fillWidth: true
            height: textTips.contentHeight

            color: '#FFFFFFFF'

            Text {
                id: textTips

                function refresh(x, y) {
                    let bx = x / _config.sizeMapBlockSize.width, by = y / _config.sizeMapBlockSize.height;
                    let ret = `(${bx},${by})`;
                    let strPost = `${bx},${by}`;
                    if(strPost in objMapBlockSpecialData)
                        ret += '(特殊：' + objMapBlockSpecialData[strPost] + ')';
                    if(strPost in objMapEventsData)
                        ret += '(事件：' + objMapEventsData[strPost] + ')';

                    //return ret;
                    text = ret;
                }


                textFormat: Text.RichText
            }
        }
        */
        Label {
            id: textTips


            Layout.fillWidth: true
            height: contentHeight


            function refresh(bx, by) {
                //let bx = x / _config.sizeMapBlockSize.width, by = y / _config.sizeMapBlockSize.height;
                let ret = `坐标：${bx},${by}`;
                let strPost = `${bx},${by}`;
                if(strPost in objMapBlockSpecialData) {
                    ret += '，特殊：' + objMapBlockSpecialData[strPost];
                    if(_private.objSpecialInfo[objMapBlockSpecialData[strPost]])
                        ret += '（' + _private.objSpecialInfo[objMapBlockSpecialData[strPost]].Name + '）';
                }
                if(strPost in objMapEventsData)
                    ret += '，事件：' + objMapEventsData[strPost];

                //return ret;
                text = ret;
            }


            textFormat: Label.RichText
        }
    }



    //导出对话框
    Dialog {
        id: dialogSave
        title: '请输入名称'
        width: parent.width * 0.9
        //height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        onAccepted: {
            textMapRID.text = textMapRID.text.trim();
            textMapName.text = textMapName.text.trim();
            if(textMapRID.text.length === 0 || textMapName.text.length === 0) {
                //$Platform.sl_showToast('名称不能为空');
                textDialogMsg.text = '资源ID和名称不能为空';
                open();
                return;
            }

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + textMapRID.text;

            function fnSave() {
                if(_private.exportMap(null)) {
                    //第一次保存，重新刷新
                    if(_private.strMapRID === '')
                        _private.loadScript(textMapRID.text);

                    _private.strMapRID = textMapRID.text;
                    //_private.strMapName = textMapName.text;

                    textDialogMsg.text = '';

                    //root.focus = true;
                    //root.forceActiveFocus();
                }
                else {
                    open();
                }
            }

            if(textMapRID.text !== _private.strMapRID && $Frame.sl_dirExists(path)) {
                $dialog.show({
                    Msg: '目标已存在，强行覆盖吗？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        fnSave();
                    },
                    OnRejected: ()=>{
                        textMapRID.text = _private.strMapRID;

                        textDialogMsg.text = '';


                        //root.forceActiveFocus();
                    },
                    /*OnDiscarded: ()=>{
                        $dialog.close();
                        root.forceActiveFocus();
                    },*/
                });
            }
            else
                fnSave();

        }
        onRejected: {
            textMapRID.text = _private.strMapRID;

            textDialogMsg.text = '';


            //root.focus = true;
            root.forceActiveFocus();

            //console.log('Cancel clicked');
        }

        ColumnLayout {
            width: parent.width
            height: implicitHeight

            RowLayout {
                Label {
                    text: qsTr('地图资源名：')
                }
                TextField {
                    id: textMapRID
                    Layout.fillWidth: true
                    placeholderText: '资源名RID'
                    text: ''

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            RowLayout {
                Label {
                    text: qsTr('地图名：')
                }
                TextField {
                    id: textMapName
                    Layout.fillWidth: true
                    placeholderText: '地图名'
                    text: ''

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            RowLayout {
                Label {
                    text: qsTr('地图缩放：')
                }
                TextField {
                    id: textMapScale
                    Layout.fillWidth: true
                    placeholderText: '1'
                    text: '1'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }
            RowLayout {
                Label {
                    text: qsTr('地板层：<')
                }
                TextField {
                    id: textMapOfRole
                    Layout.fillWidth: true
                    placeholderText: '2'
                    text: '2'

                    //selectByKeyboard: true
                    selectByMouse: true
                    //wrapMode: TextEdit.Wrap
                }
            }

            Label {
                id: textDialogMsg
                color: 'red'
            }
        }
    }



    Dialog {
        id: dialogEvent

        //参数；要修改的EventIndex，-1表示新建
        property int nEventIndex: -1

        visible: false
        title: '请输入事件名'
        width: parent.width * 0.9
        //height: parent.height * 0.9
        anchors.centerIn: parent


        modal: true
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
        standardButtons: Dialog.Ok | Dialog.Cancel


        ColumnLayout {
            anchors.fill: parent

            TextField {
                id: textEventName
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 50
                //width: parent.width
                placeholderText: '请输入事件名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }


        onAccepted: {

            if(textEventName.text.length === 0) {
                open();
                //visible = true;
                $Platform.sl_showToast('事件名不能为空');
                return;
            }


            for(let i = 0; i < listmodelEventsData.count; ++i) {
                if(i === nEventIndex)
                    continue;
                if(listmodelEventsData.get(i)['EventName'] === textEventName.text) {
                    open();
                    //visible = true;
                    $Platform.sl_showToast('事件名不能重复');
                    return;
                }
            }


            if(nEventIndex === -1) {    //新建事件
                //_private.createEvent(textEventName.text, scriptEditor.text);
                _private.createEvent(textEventName.text);
                //scriptEditor.text += '\r\n\r\nfunction* %1(){ //地图事件 \r\n}'.arg(textEventName.text);
                scriptEditor.editor.append('\r\n\r\nfunction* $%1(){ //地图事件 \r\n}'.arg(textEventName.text));
                //scriptEditor.editor.setPlainText($Frame.sl_toPlainText(scriptEditor.editor.textDocument) + '\r\n\r\nfunction* $%1(){ //地图事件 \r\n}'.arg(textEventName.text));
                //scriptEditor.editor.toBegin();
            }
            //else if(nEventIndex === -2) {  //新建系统事件
                //objSystemEventsData[textEventName.text] = scriptEditor.text;
                //objSystemEventsData[textEventName.text] = $Frame.sl_toPlainText(scriptEditor.textDocument);
            //}
            else {  //修改
                let oldEventName = listmodelEventsData.get(nEventIndex)['EventName'];

                //listmodelEventsData.set(nEventIndex, {bVisible: true, EventName: textEventName.text, EventCode: scriptEditor.text});
                listmodelEventsData.set(nEventIndex, {bVisible: true, EventName: textEventName.text});

                //delete objEventsData[oldEventName];
                ////objEventsData[textEventName.text] = scriptEditor.text;
                //objEventsData[textEventName.text] = $Frame.sl_toPlainText(scriptEditor.editor.textDocument);

                if(oldEventName !== textEventName.text)
                    for(let i in objMapEventsData) {    //修改地图上的对应关系
                        if(objMapEventsData[i] === oldEventName)
                            objMapEventsData[i] = textEventName.text;
                    }
            }

            /*_config.events[_config.strEventID] = [, scriptEditor.text];
            let ctx = canvasEvent.getContext('2d');
            ctx.fillStyle = Qt.rgba(0.5, 0.5, 1, 0.6);
            ctx.fillRect(canvasEvent.pointPaint.x * _config.sizeMapBlockSize.width, canvasEvent.pointPaint.y * _config.sizeMapBlockSize.height, _config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height);
            canvasEvent.markDirty(Qt.rect(canvasEvent.pointPaint.x * _config.sizeMapBlockSize.width, canvasEvent.pointPaint.y * _config.sizeMapBlockSize.height, _config.sizeMapBlockSize.width / 2, _config.sizeMapBlockSize.height / 2));
            */

            //!!!这里需要绘制

            nEventIndex = -1;


            root.forceActiveFocus();

            //console.debug('[MapEditor]onAccepted');
        }
        onRejected: {
            nEventIndex = -1;


            root.forceActiveFocus();

            //console.debug('[MapEditor]onRejected');
        }
    }


    /*Dialog1.FileDialog {
        id: fileDialogSave2

        visible: false

        title: '保存文件'
        //folder: shortcuts.home
        folder: $GlobalJS.toReadWriteURL('Map')

        selectMultiple: false
        selectExisting: true
        selectFolder: true

        onAccepted: {
            //root.focus = true;
            root.forceActiveFocus();


            //console.debug('You chose:', fileUrl, fileUrls);
            _private.exportMap(fileUrl.toString());
        }
        onRejected: {
            //console.log('Canceled');
            root.forceActiveFocus();
        }
        Component.onCompleted: {
        }
    }
    */




    /*
      鹰：默认导出的图片大小会乘以 Screen.devicePixelRatio
      如果不需要处理，则直接：
                    ctx.drawImage(canvasMapContainer.arrCanvasMap[i],
                        0, 0)
        或：
                    ctx.drawImage(canvasMapContainer.arrCanvasMap[i],
                        0, 0,
                        canvasMapContainer.arrCanvasMap[i].width, canvasMapContainer.arrCanvasMap[i].height,
                        0, 0,
                        canvasMapContainer.arrCanvasMap[i].width / 2, canvasMapContainer.arrCanvasMap[i].height / 2,
                    );


      如果导出需要原大小，则按以下方式处理（但导出图片不是点对点，貌似有抗锯齿）
    */
    Canvas {
        id: canvasExport

        property var fnExported: null //输出成功后回调（因为直接退出编辑器后无法输出地图，所以必须在回调函数中退出）

        visible: false
        width: canvasMapContainer.width / Screen.devicePixelRatio
        height: canvasMapContainer.height / Screen.devicePixelRatio

        smooth: false
        antialiasing: false


        renderStrategy: Canvas.Threaded     //Canvas.Immediate / Canvas.Cooperative
        renderTarget: Canvas.Image  //Canvas.FramebufferObject / Canvas.Image


        onPaint: {
            if(fnExported) {

                let ctx = getContext('2d');

                ////console.warn('!!!', ctx.imageSmoothingEnabled, ctx.imageSmoothingQuality);
                //ctx.scale(Screen.devicePixelRatio, Screen.devicePixelRatio);

                ctx.clearRect(0, 0, width, height);

                for(let i = 0; i < canvasMapContainer.arrCanvasMap.length; ++i) {

                    ctx.drawImage(canvasMapContainer.arrCanvasMap[i],
                        0, 0,
                        canvasMapContainer.arrCanvasMap[i].width * Screen.devicePixelRatio, canvasMapContainer.arrCanvasMap[i].height * Screen.devicePixelRatio,
                        0, 0,
                        canvasMapContainer.arrCanvasMap[i].width, canvasMapContainer.arrCanvasMap[i].height,
                    );


                    //canvasExport.width = canvasMapContainer.width;
                    //canvasExport.height = canvasMapContainer.height;
                }
            }
        }

        onPainted: {
            let path = GameMakerGlobal.config.strProjectRootPath +
                GameMakerGlobal.config.strCurrentProjectName +
                GameMakerGlobal.separator + '~Cache' +
                GameMakerGlobal.separator + 'Maps';
            //win下，Canvas.save 不支持 file: 开头的路径
            path = path.replace('file:/', '').replace('//', '');

            //if(!$Frame.sl_dirExists(path))
                $Frame.sl_dirCreate(path);

            canvasExport.save(path + GameMakerGlobal.separator + textMapName.text.trim() + '.png');
            //$Frame.sl_fileWrite(canvasExport.toDataURL('image/png'), strOutputPath + '/output_map.png', 0);
            //console.debug('canvasExport ok', strOutputPath + '/output_map.png', Qt.resolvedUrl(strOutputPath + '/output_map.png'));

            if($CommonLibJS.isFunction(fnExported)) {
                fnExported();
                fnExported = null;
            }

            console.debug('[MapEditor]canvasExport onPainted:', canvasExport.width, canvasExport.height);
        }
    }



    ScriptEditor {
        id: scriptEditor

        visible: false
        anchors.fill: parent
        //width: parent.width
        //height: parent.height


        strTitle: `地图脚本：${_private.strMapRID}(${textMapName.text.trim()})`
        /*fnAfterCompile: function(code) {return code;}*/

        visualScriptEditor.strTitle: strTitle + '($filename$)'

        visualScriptEditor.strSearchPath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName
        visualScriptEditor.nLoadType: 1

        visualScriptEditor.defaultCommandsInfo: GameVisualScriptJS.data.commandsInfo
        visualScriptEditor.defaultCommandGroupsInfo: GameVisualScriptJS.data.groupsInfo
        visualScriptEditor.defaultCommandTemplate: [{'command':'函数/生成器{','params':['*$start',''],'status':{'enabled':true}},{'command':'块结束}','params':[],'status':{'enabled':true}}]


        onSg_close: function(saved) {
            scriptEditor.visible = false;
            root.forceActiveFocus();
        }
    }


    //测试脚本对话框
    Dialog {
        id: dialogRunScript

        title: '执行脚本'
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        visible: false

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: '输入脚本命令'

            //textFormat: Text.RichText
            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            console.info(eval(textScript.text));

            //root.focus = true;
            root.forceActiveFocus();
        }
        onRejected: {
            //console.log('Cancel clicked');

            //root.focus = true;
            root.forceActiveFocus();
        }
    }



    /*Loader {
        id: loaderTestMap


        function show() {
            visible = true;
            focus = true;
            //forceActiveFocus();
            item.focus = true;
            //item.forceActiveFocus();
        }


        anchors.fill: parent
        visible: false


        source: './mainGameTest.qml'
        asynchronous: false


        Connections {
            target: loaderTestMap.item
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                loaderTestMap.visible = false;
                //root.focus = true;
                root.forceActiveFocus();
            }
        }
    }
    */
    HotLoader {
        id: hotLoader


        property string strMapRID
        property string strRoleRID
        property var arrPosition

        visible: false
        anchors.fill: parent

        color: 'transparent'

        pinchHandler {
            target: mask    //连同按钮一起缩放，否则只缩放界面
            ////pinch.dragAxis: Pinch.XAndYAxis
            //禁止旋转
            maximumRotation: 0
            minimumRotation: 0
        }

        onSg_close: function() {
            hotLoader.visible = false;

            referenceComponent = null;

            root.forceActiveFocus();
        }

        onSg_release: function(qmlObject) {
            hotLoader.strMapRID = qmlObject.textMapRID;
            hotLoader.strRoleRID = qmlObject.textRoleRID;
            arrPosition = [qmlObject.textMapBlockX, qmlObject.textMapBlockY];

            ///root.forceActiveFocus();
        }

        onSg_reloaded: function(code, data) {
            if(code === 0) {
                referenceComponent = rootTest;

                qmlObject.init({Map: _private.strMapRID, Role: strRoleRID, Position: arrPosition});
            }
            else if(code > 0) {
                qmlObject.init({Map: strMapRID, Role: strRoleRID, Position: arrPosition});
                qmlObject.start();
            }
            else {

            }

            visible = true;
            qmlObject.forceActiveFocus();
        }

        /*//HotLoader可自动链接 sg_close
        Connections {
            target: hotLoader.qmlObject
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_close() {
                //hotLoader.close();

                //hotLoader.visible = false;

                //root.forceActiveFocus();
            }
        }
        */
    }



    QtObject {
        id: _private


        property string strMapRID: ''
        //地图名
        property string strMapName: ''
        //地图缩放倍数（暂存）
        //property real nMapScaled: 1

        //特殊图块信息
        property var objSpecialInfo: ({1: {Color: '#7FFF7F7F', Name: '障碍'}, 2: {Color: '#7F00FF00', Name: '草地'}})



        //读取地图配置和信息
        function readConfig(cfg) {
            //_private.cleanMap();

            //console.debug('init:', cfg.MapBlockSize, cfg.MapSize)

            textMapName.text/* = _private.strMapName*/ = cfg.MapName || '';
            //_private.nMapScaled = cfg.MapScale || 1;
            textMapScale.text = cfg.MapScale || '1';
            textMapOfRole.text = cfg.MapOfRole || '2';

            //得到Size
            _config.sizeMapSize = Qt.size(cfg.MapSize[0], cfg.MapSize[1]);
            _config.sizeMapBlockSize = Qt.size(cfg.MapBlockSize[0], cfg.MapBlockSize[1]);


            //计算 _config.nMapDrawScale
            let mapWidth = _config.sizeMapSize.width * _config.sizeMapBlockSize.width;
            let mapHeight = _config.sizeMapSize.height * _config.sizeMapBlockSize.height;
            for(_config.nMapDrawScale = 1; mapWidth * mapHeight / _config.nMapDrawScale > _config.nMapMaxPixelCount; ++_config.nMapDrawScale) {
            }
            //_config.nMapDrawScale = 2;


            //计算地图宽高
            canvasMapContainer.width = mapWidth / _config.nMapDrawScale;
            canvasMapContainer.height = mapHeight / _config.nMapDrawScale;

            //canvasExport.width = canvasMapContainer.width;
            //canvasExport.height = canvasMapContainer.height;

            flickableMapBlock.implicitHeight = _config.sizeMapBlockSize.height * 3;



            //导入地图数据
            //arrMapData[0] = cfg.Obstacles;
            //arrMapData[1] = cfg.Events;
            //for(let mapID = 0; mapID < cfg.MapCount; ++mapID) {
            //}



            //导入多张 地图块图片
            //for(i = 0; i < cfg.MapBlockImageCount; ++i) {
            //    let mapBlock = itemMapBlockContainer.createObject();
            //    mapBlock.imageSource = cfg.MapData[i];
            //    itemMapBlockContainer.push(mapBlock);
            //}
            //导入图块文件（目前一张）
            //console.debug(cfg.MapBlockImage[0], typeof(cfg.MapBlockImage[0]) )
            root.arrMapBlockImageURL = cfg.MapBlockImage;
            imageMapBlock1.source = GameMakerGlobal.mapResourceURL(cfg.MapBlockImage[0]);


            canvasMapBlock1.loadImage(imageMapBlock1.source);
            if(canvasMapBlock1.isImageLoaded(imageMapBlock1.source)) {
                console.debug('[MapEditor]canvasMapBlock.loadImage载入OK');
                canvasMapBlock1.requestPaint();
            }
            else
                console.debug('[MapEditor]canvasMapBlock.loadImage载入NO，等待回调。。。');

            rectCopy.visible = false;
            rectPaste.visible = false;
        }


        //读取地图脚本
        function loadScript(mapRID) {
            if(!mapRID) {
                scriptEditor.text = ('function* $start(){ //地图载入事件 \r\n}');
                scriptEditor.visualScriptEditor.loadData(null);
                return;
            }

            //let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + mapRID + GameMakerGlobal.separator;
            //if($Frame.sl_fileExists(path + 'map.js')) {
            //File.read(path + 'map.js');
            scriptEditor.init({
                BasePath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + mapRID + GameMakerGlobal.separator,
                RelativePath: 'map.js',
                ChoiceButton: 0b11,
                PathText: 0b11,
                RunButton: 0b0,
                //Focus: false,
            });
            //scriptEditor.editor.forceActiveFocus();
            //scriptEditor.text = $Frame.sl_fileRead(path + 'map.js') || ('function* $start(){ //地图载入事件 \r\n}');
            //scriptEditor.editor.setPlainText(data);
            //scriptEditor.editor.toBegin();
            //scriptEditor.visualScriptEditor.loadData(path + 'map.vjs');

            //console.debug('[MapEditor]filePath：', path + 'map.js');
        }


        //清空地图
        function cleanMap() {

            //listmodelCanvasMap.clear();
            listmodelEventsData.clear();

            //循环删除所有图层
            while(canvasMapContainer.arrCanvasMap.length > 0) {

                //console.debug('ClearMap' + i);
                /*if(i === 0) {
                    _private.removeCanvasMap();
                }
                else if(i === 1) {
                    _private.removeCanvasMap();
                }
                else {
                    _private.removeCanvasMap();
                }*/

                _private.removeCanvasMap();
            }

            canvasMapContainer.width = 0;
            canvasMapContainer.height = 0;



            canvasMapBlock1.unloadImage(imageMapBlock1.source);

            $CommonLibJS.Utils.clearCanvas(canvasMapBlock1);
            $CommonLibJS.Utils.clearCanvas(canvasEvent);
            $CommonLibJS.Utils.clearCanvas(canvasBlockSpecial);
            canvasMapBlock1.requestPaint();
            canvasEvent.requestPaint();
            canvasBlockSpecial.requestPaint();



            //删除多张 地图块图片
            //for(i = 0; i < cfg.MapBlockImageCount; ++i) {
            //    let mapBlock = itemMapBlockContainer.pop(mapBlock);
            //    mapBlock.destroy();
            //}
            //删除一张
            imageMapBlock1.source = '';
            //canvasMapBlock1.markDirty(Qt.rect(0,0,canvasMapBlock1.width,canvasMapBlock1.height));

            //newMap({MapBlockSize: [cfg.MapBlockSize[0], cfg.MapBlockSize[1]], MapSize: [cfg.MapSize[0], cfg.MapSize[1]]});


            objMapBlockSpecialData = {};
            objMapEventsData = {};
            //objEventsData = {};
            //objSystemEventsData = {};


            root.arrMapBlockImageURL = [];


            console.debug('[MapEditor]cleanMap OK');
        }


        //保存js文件
        function saveJS() {
            /*/第一次保存，重新刷新
            if(_private.strRoleRID === '') {
            }*/

            let path = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + textMapRID.text;
            let ret = $Frame.sl_fileWrite($Frame.sl_toPlainText(scriptEditor.editor.textDocument), path + GameMakerGlobal.separator + 'map.js', 0);
        }
        //复制可视化
        function copyVJS() {
            //如果路径不为空，且是另存为，则赋值vjs文件
            if(_private.strMapRID !== '' && textMapRID.text !== '' && _private.strMapRID !== textMapRID.text) {
                let oldFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + _private.strMapRID + GameMakerGlobal.separator + 'map.vjs';
                if($Frame.sl_fileExists(oldFilePath)) {
                    let newFilePath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + textMapRID.text + GameMakerGlobal.separator + 'map.vjs';
                    let ret = $Frame.sl_fileCopy(oldFilePath, newFilePath, true);
                }
            }
        }

        //导出地图
        function exportMap(exportedFunction) {
            if(textMapRID.text.length === 0 || textMapName.text.length === 0)
                return false;

            let newPath = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + textMapRID.text;

            //if(!$Frame.sl_dirExists(newPath))
                $Frame.sl_dirCreate(newPath);


            //绘制所有 0层及以上 canvas
            canvasExport.fnExported = exportedFunction;
            canvasExport.requestPaint();

            //canvasMapContainer.arrCanvasMap[0].save(newPath + '/output_0.png');
            //canvasMapContainer.arrCanvasMap[1].save(newPath + '/output_1.png');


            let i = 0;

            const tmpEventList = []; //保存所有事件名 对应的 显示关键字
            for(i = 0; i < listmodelEventsData.count; ++i) {
                tmpEventList.push(listmodelEventsData.get(i)['EventName']);
            }

            const outputData = {};
            outputData.Version = '0.6';
            outputData.MapName = textMapName.text;
            outputData.MapType = 1; //地图类型
            outputData.MapScale = parseFloat(textMapScale.text) > 0 ? parseFloat(textMapScale.text) : 1;
            outputData.MapSize = [_config.sizeMapSize.width, _config.sizeMapSize.height];
            outputData.MapBlockSize = [_config.sizeMapBlockSize.width, _config.sizeMapBlockSize.height];
            outputData.MapCount = canvasMapContainer.arrCanvasMap.length;
            outputData.MapData = [];
            outputData.MapBlockImageCount = 1;
            outputData.MapBlockImage = [root.arrMapBlockImageURL[0]];
            outputData.MapEventData = objMapEventsData;
            outputData.MapBlockSpecialData = objMapBlockSpecialData;
            outputData.MapOfRole = parseInt(textMapOfRole.text) > 0 ? parseInt(textMapOfRole.text) : 1;
            outputData.MapEventList = tmpEventList;
            //outputData.EventData = {};
            /*for(i = 0; i < listmodelEventsData.count; ++i) {
                outputData.EventData[listmodelEventsData.get(i)['EventName']] = (listmodelEventsData.get(i)['EventCode']);
            }*/
            //outputData.EventData = objEventsData;
            //outputData.SystemEventData = objSystemEventsData;


            for(i = 0; i < canvasMapContainer.arrCanvasMap.length; ++i) {
                //之前3层的算法
                /*if(i === 0) {
                    outputData.Obstacles = arrMapData[0];
                }
                else if(i === 1) {
                    outputData.Events = arrMapData[1];
                }
                else {
                    outputData.MapData[i-2] = arrMapData[i];
                }*/

                outputData.MapData[i] = arrMapData[i];
            }
            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(path + GameMakerGlobal.separator + 'map.json', JSON.stringify(outputData));
            let ret = $Frame.sl_fileWrite(JSON.stringify(outputData), newPath + GameMakerGlobal.separator + 'map.json', 0);
            //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())


            saveJS();

            copyVJS();


            console.debug('[MapEditor]exportMap ret:', ret, newPath + GameMakerGlobal.separator + 'map.json');
            console.debug('[MapEditor]exportMap:', JSON.stringify(outputData));
            //console.debug('[MapEditor]exportMap objEventsData:', JSON.stringify(objEventsData));


            return true;
        }


        //初始化一层地图的数据
        //使用initData进行填充（只填充undefined的元素）
        //_mapData为二维数组，大小会改为为 _config.sizeMapSize.width * _config.sizeMapSize.height；
        function initMapData(_mapData, initData) {

            //计算、设置地图所需数据大小
            //let mapCols = parseInt(canvasMapContainer.width / _config.sizeMapBlockSize.width);
            //let mapRows = parseInt(canvasMapContainer.height / _config.sizeMapBlockSize.height);

            /*/初始化
            for(let y = 0; y < mapRows; y++) {
                arrMapData[y] = [];
                for(let x = 0; x < mapCols; x++) {
                    arrMapData[y][x] = Qt.point(-1,-1);
                }
            }*/

            //初始化（会保存原数据，只填充undefined的元素）
            _mapData.length = _config.sizeMapSize.height;
            for(let y = 0; y < _config.sizeMapSize.height; ++y) {
                if(!(_mapData[y] instanceof(Array))) //如果不是数组，则赋值为数组
                    _mapData[y] = [];

                //console.debug(_mapData[y])

                _mapData[y].length = _config.sizeMapSize.width;
                for(let x = 0; x < _config.sizeMapSize.width; ++x) {
                    if(_mapData[y][x] === undefined) {  //只填充undefined的元素
                        _mapData[y][x] = initData;
                        //console.debug(typeof(_mapData[y][x]), _mapData[y][x])
                    }
                }
            }
            return _mapData;
        }

        //创建一个地图层。
        //mapData：地图的数据
        function createCanvasMap(mapData) {

            arrMapData.push(mapData);

            //必须先创建并push到arrCanvasMap中再listmodelCanvasMap，因为listmodelCanvasMap要用到arrCanvasMap的objCanvas的visible标记颜色
            let objCanvas = compCanvas.createObject(canvasMapContainer, {
                                                        z: canvasMapContainer.arrCanvasMap.length,
                                                        index: canvasMapContainer.arrCanvasMap.length
                                                    });
            objCanvas.loadImage(imageMapBlock1.source);
            if(objCanvas.isImageLoaded(imageMapBlock1.source)) {
                console.debug('[MapEditor]objCanvas.loadImage载入OK');
                objCanvas.requestPaint();
            }
            else
                console.debug('[MapEditor]objCanvas.loadImage载入NO，等待回调。。。');

            canvasMapContainer.arrCanvasMap.push(objCanvas);
            canvasMapContainer.nCurrentCanvasMap = canvasMapContainer.arrCanvasMap.length - 1;

            listmodelCanvasMap.append({fOpacity: 1, //bVisible: true,
                                  id: canvasMapContainer.arrCanvasMap.length - 1});
            listviewCanvasMap.currentIndex = listmodelCanvasMap.count - 1;


            //图层z序
            switch(canvasMapContainer.arrCanvasMap.length) {
            //case 1:
            //case 2:
            //    objCanvas.z = 999;
            //    break;
            default:
                //objCanvas.z = canvasMapContainer.arrCanvasMap.length;
                break;
            }

            return objCanvas;
        }

        //删除一个地图层
        function removeCanvasMap() {
            //先删除 listmodelCanvasMap，它会引用 canvasMapContainer.arrCanvasMap；鹰：貌似没用，因为组件删除貌似是事件
            listmodelCanvasMap.remove(listmodelCanvasMap.count - 1, 1);

            arrMapData.pop();
            let canvasMap = canvasMapContainer.arrCanvasMap.pop();
            canvasMap.unloadImage(imageMapBlock1.source);
            canvasMap.destroy();
            canvasMapContainer.nCurrentCanvasMap = canvasMapContainer.arrCanvasMap.length - 1;
        }


        //创建事件（只是给listview加）
        function createEvent(name) {
            //objEventsData[name] = code;

            //console.debug('listmodelEventsData', listmodelEventsData, JSON.stringify(listmodelEventsData), typeof(listmodelEventsData));
            //listmodelEventsData.append({bVisible: true, EventName: name, EventCode: code});
            listmodelEventsData.append({bVisible: true, EventName: name});
            listviewEvents.currentIndex = listmodelEventsData.count - 1;
        }
        //删除事件
        function deleteEvent(index) {
            index = (index >= 0 ? index : listviewEvents.currentIndex);

            //console.debug('[MapEditor]deleteEvent：', index, listviewEvents.currentIndex);

            if(listmodelEventsData.count <= 0)
                return;

            let eventname = listmodelEventsData.get(index)['EventName'];

            //delete objEventsData[eventname];
            listmodelEventsData.remove(index);

            for(let i in objMapEventsData) {
                if(objMapEventsData[i] === eventname)
                    delete objMapEventsData[i];
            }

            canvasEvent.rePaint();

            //listviewEvents.currentIndex = listmodelEventsData.count - 1;

            //listEventsData.splice(index, 1);
            //listEventsData = listEventsData;
        }

        function close() {
            $dialog.show({
                Msg: '退出前需要保存吗？',
                Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                OnAccepted: function() {
                    if(exportMap(()=>sg_close())) {
                    }
                    else {
                        dialogSave.open();
                    }

                    //root.forceActiveFocus();
                },
                OnRejected: ()=>{
                    sg_close();

                    //root.forceActiveFocus();
                },
                OnDiscarded: ()=>{
                    $dialog.close();
                    //root.forceActiveFocus();
                },
            });
        }
    }


    //配置
    QtObject {
        id: _config


        //模式
        //property QtObject mapOperatorModel: QtObject {
        property int nDrawMapType: 1
        property bool bMapMove: nDrawMapType === 0      //移动模式
        property bool bMapDraw: nDrawMapType === 1      //绘制模式
        //property bool bMapClean: nDrawMapType === -1    //删除模式
        property bool bMapBlockSpecial: nDrawMapType === 2     //障碍
        property bool bMapEvent: nDrawMapType === 3     //事件

        property bool bMapClean: false    //删除模式


        //地图块大小(像素）
        property size sizeMapBlockSize//: Qt.size(30, 30);
        //地图大小（块）
        property size sizeMapSize//: Qt.size(20, 20);

        //最大地图像素数（超过则缩放）
        //32位安卓，70*70绘制一会就飘
        //64位安卓：200*200左右很卡（250*250闪退），100*100：明显卡
        property int nMapMaxPixelCount: 60*60*32*32 //$Platform.sysInfo.sizes === 32 ? 60*60*32*32 : 100*100*32*32
        //绘制地图时缩小倍数（防止太大出错）
        property int nMapDrawScale: 1

        //按钮字体大小
        property int nFontPointSize: 6

    }



    //Keys.forwardTo: [canvasMapContainer]
    Keys.onEscapePressed: function(event) {
        console.debug('[MapEditor]Keys.onEscapePressed');
        event.accepted = true;


        _private.close();

        //focus = false;
        //loader.visible = false;
        //loader.focus = false;
        //menuEsc.hide();

    }
    Keys.onBackPressed: function(event) {
        console.debug('[MapEditor]Keys.onBackPressed');
        event.accepted = true;


        _private.close();

        //focus = false;
        //loader.visible = false;
        //loader.focus = false;
        //menuEsc.hide();
    }
    Keys.onPressed: function(event) {
        console.debug('[MapEditor]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[MapEditor]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        _config.nMapMaxPixelCount = ($Platform.sysInfo.sizes === 32 ? 60*60*32*32 : 100*100*32*32);

        //console.debug(Qt.point(1,1) === Qt.point(1,1), Qt.point(0,1) === Qt.point(1,1));    //true false

        //!!!导入图块图片
        //imageMapBlock1.source = './1.png';
        //newMap({MapBlockSize: [30, 30], MapSize: [20, 20]});

        console.debug('[MapEditor]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[MapEditor]Component.onDestruction');
    }
}
