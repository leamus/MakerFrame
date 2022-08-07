import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14


import _Global 1.0
import _Global.Button 1.0


import "qrc:/QML"



//import "File.js" as File



Rectangle {
    id: root


    signal s_close();


    //width: 600
    //height: 800
    anchors.fill: parent

    clip: true
    focus: true



    MouseArea {
        anchors.fill: parent
    }



    ColumnLayout {
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent

        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            //Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "新建战斗角色"
                onButtonClicked: {
                    loader.source = "./GameFightRole.qml";

                    if(loader.status === Loader.Ready) {
                        loader.item.init("");

                        loader.item.forceActiveFocus();
                    }
                    else {
                        loader.fOnLoaded = () => {
                            loader.item.init("");

                            loader.fOnLoaded = null;
                        }
                    }

                    loader.visible = true;
                    loader.focus = true;
                }
            }

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "打开战斗角色"
                onButtonClicked: {

                    dirList.visible = true;
                    dirList.focus = true;
                    dirList.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightRoleDirName, "*", 0x001 | 0x2000, 0x00);
                    dirList.fOnClicked = (index, item)=>{

                        loader.source = "./GameFightRole.qml";
                        if(loader.status === Loader.Ready) {
                            loader.item.init(item);

                            loader.item.forceActiveFocus();
                        }
                        else {
                            loader.fOnLoaded = () => {
                                loader.item.init(item);

                                loader.item.forceActiveFocus();

                                loader.fOnLoaded = null;
                            }
                        }

                        loader.visible = true;
                        loader.focus = true;

                        dirList.fOnClicked = null;
                        dirList.visible = false;
                    }
                    dirList.fOnRemoveClicked = (index, item) =>{

                        let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightRoleDirName + Platform.separator() + item;

                        dialogCommon.text = "确认删除?";
                        dialogCommon.fOnAccepted = ()=>{
                            console.debug("[mainFightEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                            dirList.removeItem(index);

                            dirList.forceActiveFocus();
                        };
                        dialogCommon.fOnRejected = ()=>{
                            dirList.forceActiveFocus();
                        };
                        dialogCommon.open();
                    }

                }
            }
        }

        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            //Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "新建技能"
                onButtonClicked: {

                    loader.source = "./GameFightSkill.qml";

                    if(loader.status === Loader.Ready) {
                        loader.item.init("");

                        loader.item.forceActiveFocus();
                    }
                    else {
                        loader.fOnLoaded = () => {
                            loader.item.init("");

                            loader.fOnLoaded = null;
                        }
                    }

                    loader.visible = true;
                    loader.focus = true;
                }
            }

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "打开技能"
                onButtonClicked: {

                    dirList.visible = true;
                    dirList.focus = true;
                    dirList.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName, "*", 0x001 | 0x2000, 0x00);
                    dirList.fOnClicked = (index, item)=>{

                        loader.source = "./GameFightSkill.qml";
                        if(loader.status === Loader.Ready) {
                            loader.item.init(item);

                            loader.item.forceActiveFocus();
                        }
                        else {
                            loader.fOnLoaded = () => {
                                loader.item.init(item);

                                loader.item.forceActiveFocus();

                                loader.fOnLoaded = null;
                            }
                        }

                        loader.visible = true;
                        loader.focus = true;

                        dirList.fOnClicked = null;
                        dirList.visible = false;
                    }
                    dirList.fOnRemoveClicked = (index, item) =>{

                        let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName + Platform.separator() + item;

                        dialogCommon.text = "确认删除?";
                        dialogCommon.fOnAccepted = ()=>{
                            console.debug("[mainFightEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                            dirList.removeItem(index);

                            dirList.forceActiveFocus();
                        };
                        dialogCommon.fOnRejected = ()=>{
                            dirList.forceActiveFocus();
                        };
                        dialogCommon.open();
                    }

                }
            }
        }

        RowLayout {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width * 0.4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 50
            Layout.minimumHeight: 20
            //Layout.fillHeight: true

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "新建战斗脚本"
                onButtonClicked: {
                    loader.source = "./GameFightScript.qml";

                    if(loader.status === Loader.Ready) {
                        loader.item.init("");

                        loader.item.forceActiveFocus();
                    }
                    else {
                        loader.fOnLoaded = () => {
                            loader.item.init("");

                            loader.fOnLoaded = null;
                        }
                    }

                    loader.visible = true;
                    loader.focus = true;
                }
            }

            ColorButton {
                Layout.preferredWidth: parent.width * 0.4
                Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                //Layout.preferredHeight: 50
                //Layout.minimumHeight: 20
                //Layout.fillHeight: true

                text: "打开战斗脚本"
                onButtonClicked: {
                    dirList.visible = true;
                    dirList.focus = true;
                    dirList.showList(GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightScriptDirName, "*", 0x001 | 0x2000, 0x00);
                    dirList.fOnClicked = (index, item)=>{

                        loader.source = "./GameFightScript.qml";
                        if(loader.status === Loader.Ready) {
                            loader.item.init(item);

                            loader.item.forceActiveFocus();
                        }
                        else {
                            loader.fOnLoaded = () => {
                                loader.item.init(item);

                                loader.item.forceActiveFocus();

                                loader.fOnLoaded = null;
                            }
                        }

                        loader.visible = true;
                        loader.focus = true;

                        dirList.fOnClicked = null;
                        dirList.visible = false;
                    }
                    dirList.fOnRemoveClicked = (index, item) =>{

                        let dirUrl = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightScriptDirName + Platform.separator() + item;

                        dialogCommon.text = "确认删除?";
                        dialogCommon.fOnAccepted = ()=>{
                            console.debug("[mainFightEditor]删除：" + dirUrl, Qt.resolvedUrl(dirUrl), GameManager.sl_qml_DirExists(dirUrl), GameManager.sl_qml_RemoveRecursively(dirUrl));
                            dirList.removeItem(index);

                            dirList.forceActiveFocus();
                        };
                        dialogCommon.fOnRejected = ()=>{
                            dirList.forceActiveFocus();
                        };
                        dialogCommon.open();
                    }

                }
            }
        }

        ColorButton {
            //Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //Layout.preferredHeight: 50

            text: "通用（技能、战斗、恢复）算法"
            onButtonClicked: {
                loader.source = "./GameCommonAlgorithm.qml"

                if(loader.status === Loader.Ready) {
                    loader.item.init();

                    loader.item.forceActiveFocus();
                }
                else {
                    loader.fOnLoaded = () => {
                        loader.item.init();

                        loader.fOnLoaded = null;
                    }
                }

                loader.visible = true;
                loader.focus = true;

            }
        }
    }



    Loader {
        id: loader

        property var fOnLoaded

        visible: false
        focus: true
        anchors.fill: parent

        //source: "./RoleEditor.qml"
        asynchronous: false

        onLoaded: {
            if(fOnLoaded)fOnLoaded();
            //console.debug("!!!loader fOnClicked", fOnLoaded)
            console.debug("[mainFightEditor]Loader onLoaded");
        }

        Connections {
            target: loader.item
            function onS_close() {
                loader.visible = false;
                root.focus = true;
            }
        }
    }

    DirList {
        id: dirList
        visible: false


        property var fOnClicked
        property var fOnRemoveClicked


        onCanceled: {
            //loader.visible = true;
            root.focus = true;
            //loader.item.focus = true;
            visible = false;
        }

        onClicked: {
            if(item === "..") {
                dirList.visible = false;
                return;
            }

            if(fOnClicked)fOnClicked(index, item);
            //console.debug("!!!DirList fOnClicked", fOnClicked)
        }

        onRemoveClicked: {
            if(fOnRemoveClicked)fOnRemoveClicked(index, item);
            //console.debug("!!!DirList fOnRemoveClicked", fOnRemoveClicked)
        }
    }



    //通用对话框
    /*/Dialog1.Dialog {
        anchors.centerIn: parent

        title: "深林孤鹰"
        //modality: Qt.WindowModal   //Qt.NonModal、Qt.WindowModal、Qt.ApplicationModal
        //standardButtons: Dialog1.StandardButton.Ok | Dialog1.StandardButton.Cancel
    */
    Dialog {
        id: dialogCommon

        property var fOnAccepted
        property var fOnRejected

        property alias text: textDialogTips.text



        visible: false
        anchors.centerIn: parent
        //width: 300
        //height: 200

        title: "深林孤鹰提示"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true



        Text {
            id: textDialogTips
            //text: qsTr("text")
        }


        onAccepted: {
            if(fOnAccepted)fOnAccepted();
            console.debug("[mainFightEditor]onAccepted");
        }
        onRejected: {
            if(fOnRejected)fOnRejected();
            console.debug("[mainFightEditor]onRejected");
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

        console.debug("[mainFightEditor]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainFightEditor]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainFightEditor]key:", event, event.key, event.text)
    }



    Component.onCompleted: {

    }
}
