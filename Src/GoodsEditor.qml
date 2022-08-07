import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.leamus.gamedata 1.0


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    function init(goodsName) {
        if(goodsName) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName + Platform.separator() + goodsName + Platform.separator() + "goods.json";
            //let data = File.read(filePath);
            //console.debug("[GoodsEditor]filePath：", filePath);

            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                //console.debug("data", data);
                GameManager.setPlainText(notepadGoodsScript.textDocument, data.Goods);
                testGoodsName.text = goodsName;
                return;
            }
        }
        GameManager.setPlainText(notepadGoodsScript.textDocument, '
(function(){



let equipEffectAlgorithm = function(heroProperty, heroPropertyNew) {
    heroPropertyNew.attack += 50;
}
let throwScript = function *(heroProperty, heroPropertyNew, name) {
    yield game.msg("投掷事件");
}
let useScript = function *(heroProperty, heroPropertyNew, name) {
    yield game.msg(name + "使用事件");
}



return ({name: "道具名", discription: "描述", image: "goods.png", size: [100, 100], type: 1,
        useScript, equipEffectAlgorithm, throwScript});

})()');
        testGoodsName.text = "";

    }


    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true

    clip: true


    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop

            Label {
                //Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop
                Layout.fillWidth: true
                text: "道具脚本（载入外部脚本用game.evaluateFile）"
                font.pointSize: 16
                wrapMode: Label.WordWrap
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.fillHeight: true


            Notepad {
                id: notepadGoodsScript

                Layout.preferredWidth: parent.width

                Layout.preferredHeight: textArea.contentHeight
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: 50
                Layout.fillHeight: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


                textArea.text: ''
                textArea.placeholderText: "请输入道具脚本（载入外部脚本用game.evaluateFile）"
            }

        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            ColorButton {
                id: buttonSave

                Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
                //Layout.preferredHeight: 50

                text: "保存"
                onButtonClicked: {
                    if(testGoodsName.text.trim().length === 0)
                        return;

                    let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName + Platform.separator() + testGoodsName.text + Platform.separator() + "goods.json";

                    let outputData = {};
                    outputData.Version = "0.6";
                    outputData.Goods = GameManager.toPlainText(notepadGoodsScript.textDocument);

                    //!!!导出为文件
                    //console.debug(JSON.stringify(outputData));
                    //let ret = File.write(path + Platform.separator() + 'map.json', JSON.stringify(outputData));
                    let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), filePath, 0);
                    //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

                }
            }
            TextField {
                id: testGoodsName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "道具名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

    }


    QtObject {
        id: _private

    }

    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[mainGame]:Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainGame]:Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainGame]Keys.onPressed:", event.key);
    }
    Keys.onReleased:  {
        console.debug("[mainGame]Keys.onReleased:", event.key);
    }



    Component.onCompleted: {

    }
}
