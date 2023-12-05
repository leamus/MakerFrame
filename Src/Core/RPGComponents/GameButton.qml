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

Rectangle {
    id: root

    signal s_pressed();

    width: 6 * Screen.pixelDensity
    height: 6 * Screen.pixelDensity

    opacity: 0.6
    radius: width / 2
    color: "white"
    border.color: "black"

    MultiPointTouchArea {
        anchors.fill: parent
        /*onClicked: {
        }
        */
        onPressed: {
            parent.scale = 0.9;

            s_pressed();
        }
        onReleased: {
            parent.scale = 1;
        }
    }
}
