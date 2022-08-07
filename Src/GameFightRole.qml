import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


//import cn.leamus.gamedata 1.0


import _Global 1.0
import _Global.Button 1.0


//import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();
    //property alias arrRoleSprites: _private.arrRoleSprites
    //property alias strFightRoleName: textFightRoleName.text


    function init(fightRoleName) {
        if(fightRoleName) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightRoleDirName + Platform.separator() + fightRoleName + Platform.separator() + "fight_role.json";
            //let data = File.read(filePath);
            //console.debug("[GameFightRole]filePath：", filePath);

            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                //console.debug("data", data);

                _private.arrRoleSprites = data.ActionData;
                textFightRoleName.text = fightRoleName || "";
                textActionName.text = "normal";
                textFightRoleProperty.text = data.Property || "";

                return;
            }

        }

        _private.arrRoleSprites = [];
        textFightRoleName.text = "";
        textActionName.text = "normal";
        textFightRoleProperty.text = '';
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

        ListView {
            id: listview

            Layout.fillHeight: true
            Layout.fillWidth: true

            model: _private.arrRoleSprites

            delegate: FileItem {
                text: "动作" + index + "【" + modelData.ActionName + "】：" + modelData.SpriteName
                bSelected: index === listview.currentIndex
                //removeButtonVisible: modelData !== "main.qml"

                onClicked: {
                    listview.currentIndex = index;
                    //root.clicked(index, modelData.ActionName);

                    textActionName.text = modelData.ActionName;
                    textSpriteName.text = modelData.SpriteName;

                    console.debug(JSON.stringify(modelData));
                }

                onRemoveClicked: {
                    //console.debug("delete", modelData);
                    //root.removeClicked(index, modelData.ActionName);
                    _private.arrRoleSprites.splice(index, 1);
                    _private.arrRoleSprites = _private.arrRoleSprites;
                }
            }
        }



        Notepad {
            id: textFightRoleProperty

            Layout.preferredWidth: parent.width

            Layout.preferredHeight: textArea.contentHeight
            Layout.maximumHeight: parent.height
            Layout.minimumHeight: 50
            //Layout.fillHeight: true

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop


            textArea.text: '(function(){return {name: "敌人1", properties: {HP: 5, healthHP: 5, remainHP: 5, EXP: 5}, skills: [{id: "fight"}], FightRoleName: "killer2", money: 5}})();'
            textArea.placeholderText: "属性"
        }


        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            TextField {
                id: textActionName
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "动作名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textSpriteName

                Layout.preferredWidth: 60
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "特效名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }

            TextField {
                id: textFightRoleName

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter// | Qt.AlignTop

                text: ""
                placeholderText: "战斗角色名"

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextEdit.Wrap
            }
        }

        RowLayout {
            Layout.maximumWidth: root.width * 0.9
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50
            Layout.bottomMargin: 10

            ColorButton {
                id: buttonChoiceSprite

                //Layout.preferredWidth: 60

                text: "选择"
                onButtonClicked: {
                    dirListSprite.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strSpriteDirName, "*", 0x001 | 0x2000, 0x00);
                    dirListSprite.visible = true;
                    dirListSprite.focus = true;
                }
            }
            ColorButton {
                id: buttonAddAction

                //Layout.preferredWidth: 60

                text: "新增"
                onButtonClicked: {
                    if(textActionName.text.trim().length === 0)
                        return;

                    for(let m in _private.arrRoleSprites) {
                        if(_private.arrRoleSprites[m]["ActionName"] === textActionName.text) {
                            return;
                        }
                    }


                    _private.arrRoleSprites.push({"ActionName": textActionName.text, "SpriteName": textSpriteName.text});
                    _private.arrRoleSprites = _private.arrRoleSprites;

                    listview.currentIndex = _private.arrRoleSprites.length - 1;
                }
            }

            ColorButton {
                id: buttonModifyAction

                //Layout.preferredWidth: 60

                text: "修改"
                onButtonClicked: {
                    if(textActionName.text.trim().length === 0) {
                        return;
                    }

                    if(listview.currentIndex < 0 || listview.currentIndex >= _private.arrRoleSprites.length) {
                        return;
                    }


                    /*for(let m in _private.arrRoleSprites) {
                        if(m === listview.currentIndex)
                            continue;

                        //console.debug(m, listview.currentIndex, typeof(m), typeof(listview.currentIndex), _private.arrRoleSprites[m]["ActionName"])

                        if(_private.arrRoleSprites[m]["ActionName"] === textActionName.text) {
                            return;
                        }
                    }*/


                    //let index = listview.currentIndex;

                    _private.arrRoleSprites[listview.currentIndex] = ({"ActionName": textActionName.text, "SpriteName": textSpriteName.text});
                    _private.arrRoleSprites = _private.arrRoleSprites;

                    //listview.currentIndex = index;
                }
            }

            ColorButton {
                id: buttonPlaySprite

                //Layout.preferredWidth: 60

                text: "播放"
                onButtonClicked: {

                }
            }

            ColorButton {
                id: buttonSave

                //Layout.preferredWidth: 60

                text: "保存"
                onButtonClicked: {
                    if(textFightRoleName.text.trim().length === 0)
                        return;

                    let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightRoleDirName + Platform.separator() + textFightRoleName.text + Platform.separator() + "fight_role.json";

                    let outputData = {};

                    outputData.Version = "0.6";
                    outputData.ActionData = _private.arrRoleSprites;
                    outputData.Property = textFightRoleProperty.text;


                    //!!!导出为文件
                    //console.debug(JSON.stringify(outputData));
                    //let ret = File.write(path + Platform.separator() + 'map.json', JSON.stringify(outputData));
                    let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData), filePath, 0);
                    //console.debug(canvasMapContainer.arrCanvasMap[2].toDataURL())

                }
            }

        }
    }



    DirList {
        id: dirListSprite
        visible: false


        onCanceled: {
            //loader.visible = true;
            root.focus = true;
            //loader.item.focus = true;
            visible = false;
        }

        onClicked: {
            if(item === "..") {
                visible = false;
                return;
            }

            textSpriteName.text = item;


            //loader.visible = true;
            //loader.focus = true;
            //loader.item.focus = true;
            root.focus = true;
            visible = false;

        }

        /*onRemoveClicked: {
            let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + item;

            textDialogCommonTips.text = "确认删除?";
            textinputDialogCommonInput.visible = false;
            dialogCommon.standardButtons = Dialog.Ok | Dialog.Cancel;
            dialogCommon.fOnAccepted = ()=>{
                console.debug("[GameFightRole]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                removeItem(index);
            };
            dialogCommon.fOnRejected = ()=>{
            };
            dialogCommon.open();
        }*/
    }



    //配置
    QtObject {
        id: config
    }

    QtObject {
        id: _private

        property var arrRoleSprites: []
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed:  {
        s_close();

        console.debug("[GameFightRole]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[GameFightRole]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[GameFightRole]Keys.onPressed:", event.key);
    }
    Keys.onReleased:  {
        console.debug("[GameFightRole]Keys.onReleased:", event.key);
    }



    Component.onCompleted: {
        console.debug("[GameFightRole]Component.onCompleted");
    }
}
