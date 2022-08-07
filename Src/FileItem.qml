/****************************************************************************
**
** Copyright (C) 2013-2015 Oleg Yadrov
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
**
****************************************************************************/

import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14

Item {
    id: rootFileItem

    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined
    implicitHeight: 9.25 * Screen.pixelDensity

    property alias text: buttonLabel.text
    property alias removeButtonVisible: removeButton.visible
    property bool bSelected: false

    signal clicked()
    signal removeClicked()



    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                //color: "yellow"
                visible: {
                    if(buttonMouseArea.pressed) {
                        color = "yellow";
                        return true;
                    }
                    else if(rootFileItem.bSelected) {
                        color = "lightgreen";
                        return true;
                    }
                    return false;
                }
            }

            Text {
                id: buttonLabel
                anchors.fill: parent
                anchors.leftMargin: 2.5 * Screen.pixelDensity
                anchors.rightMargin: 1.5 * Screen.pixelDensity

                //font.family: "Roboto"
                font.pixelSize: 3 * Screen.pixelDensity
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                color: "black"
            }

            MouseArea {
                id: buttonMouseArea
                anchors.fill: parent
                onClicked: rootFileItem.clicked()
            }
        }

        Item {
            id: removeButton

            visible: !(buttonLabel.text === ".." || buttonLabel.text === ".")

            Layout.fillHeight: true
            Layout.minimumWidth: height

            Rectangle {
                anchors.fill: parent
                color: "yellow"
                visible: removeButtonMouseArea.pressed
            }

            Text {
                anchors.centerIn: parent
                text: "X"

                font.pixelSize: 5 * Screen.pixelDensity
                //font.family: "FontAwesome"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                color: "black"
            }

            MouseArea {
                id: removeButtonMouseArea
                anchors.fill: parent
                onClicked: rootFileItem.removeClicked()
            }
        }
    }

    FontLoader {
        //name: "fontawesome.ttf"
        //source: "fontawesome.ttf"
    }

    Component.onCompleted: {
        //console.debug("FileItem", parent)
    }
    Component.onDestruction: {
        //console.debug("~FileItem", parent)
    }
}
