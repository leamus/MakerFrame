import QtQuick 2.14
import QtQuick.Layouts 1.14


import cn.leamus.gamedata 1.0



Rectangle {
    id: root


    signal clicked(int index, string item)
    signal removeClicked(int index, string item)
    signal canceled()

    function showList(path, suffix = "*", filters = 0x001 | 0x002 | 0x2000 | 0x4000, sort = 0x00) {
        listview.model = GameManager.sl_qml_listDir(path, suffix, filters, sort);

        if(JSON.stringify(listview.model) === "[]") {
            listview.visible = false;
            textEmpty.visible = true;
        }
        else {
            listview.visible = true;
            textEmpty.visible = false;
        }

        //console.debug("filters:", filters);
        //console.debug("DirList:", path, listview.model, JSON.stringify(listview.model));
    }

    function removeItem(index) {
        let tmpModel = listview.model;
        tmpModel.splice(index, 1);
        listview.model = tmpModel;
    }

    anchors.fill: parent


    ListView {
        id: listview
        anchors.fill: parent
        delegate: FileItem {
            text: modelData
            //removeButtonVisible: modelData !== "main.qml"

            onClicked: {
                //console.debug(modelData);
                root.clicked(index, modelData);
            }

            onRemoveClicked: {
                //console.debug("delete", modelData);
                root.removeClicked(index, modelData);
            }
        }
    }

    Text {
        id: textEmpty
        visible: false
        anchors.centerIn: parent
        text: qsTr("空")
    }

    Keys.onEscapePressed:  {
        //console.debug("[DirList]Escape Key");
        canceled();
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        //console.debug("[DirList]Back Key");
        canceled();
        event.accepted = true;
        //Qt.quit();
    }
    Component.onCompleted: {
    }
}
