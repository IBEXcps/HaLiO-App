/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.1
import org.kde.kirigami 2.1 as Kirigami
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls
import QtQuick.Controls.Material 2.1

Kirigami.ApplicationItem {
    id: root

    property var recColor: "red"
    property var data: ""

    function getData(url) {
        var xmlhttp = new XMLHttpRequest();
        print('url:', url)
        xmlhttp.onreadystatechange=function() {
            print('return:', xmlhttp.responseText)
            if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                myFunction(xmlhttp.responseText);
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.setRequestHeader("Authorization", "Basic "+ Qt.btoa("admin:batatadoce"));

        xmlhttp.send();
    }

    function myFunction(response) {
        print('response:', response)
        var arr = JSON.parse(response);
        data = JSON.stringify(arr, undefined, 2)
        print(data)
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: "HaLiO Controller"
        titleIcon: "face.jpg"

        actions: [
            Kirigami.Action {
                text: "Meus dispostivos"
                iconName: "icons/IcoMoon-Free-master/PNG/64px/184-power-cord.png"
                Kirigami.Action {
                    text: "Chuveiro"
                    onTriggered: {
                        root.recColor =  "blue"
                        root.getData('http://ibexcps.com:5228/users/?format=json')
                    }
                }
                Kirigami.Action {
                    text: "Ventilador"
                    onTriggered: {
                        root.recColor =  "pink"
                        root.getData('http://ibexcps.com:5228/groups/?format=json')
                    }
                }
                Kirigami.Action {
                    text: "Geladeira"
                    onTriggered: {
                        root.recColor =  "red"
                        root.getData('http://ibexcps.com:5228/houses/?format=json')
                    }
                }
            },
            Kirigami.Action {
                text: "Estastisticas"
                iconName: "icons/IcoMoon-Free-master/PNG/64px/156-stats-dots.png"
                onTriggered: {
                        root.recColor =  "back"
                        root.getData('http://ibexcps.com:5228/nodes/?format=json')
                }
            },
            Kirigami.Action {
                text: "Serviços"
                iconName: "icons/IcoMoon-Free-master/PNG/64px/119-user-tie.png"
                onTriggered: {
                        root.recColor =  "white"
                        root.getData('http://ibexcps.com:5228/data/?format=json')
                }
            },
            Kirigami.Action {
                text: "Suporte"
                iconName: "109-bubbles.png"
                onTriggered : {
                    pageStack.replace(supportPage)
                }
            }
        ]
        handleVisible: true
    }
    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: mainPageComponent

    Component {
        id: supportPage

        Kirigami.Page {
            id: page
            title: "Main Page 2"

            ColumnLayout {
                id: lay
                width: page.width
                spacing: Kirigami.Units.smallSpacing

                property string buttonText: "Turn HaLiO " + state2Str(!bottomDrawer.state)

                Controls.Button {
                    text: lay.buttonText
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: bottomDrawer.open()
                }

                Rectangle {
                    color: root.recColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: KirigamiUnits.gridUnit*20
                    height: Kirigami.Units.gridUnit*20
                }

                Text {
                    text: root.data
                }

            }
        }
    }

    Component {
        id: mainPageComponent

        Kirigami.Page {
            id: page
            title: "Main Page"

            actions {
                contextualActions: [
                    Kirigami.Action {
                        text: "Doing.."
                    }
                ]
            }

            function state2Str(state) {
                return state === false ? "off" : "on"
            }


            Kirigami.OverlayDrawer {
                id: bottomDrawer
                edge: Qt.BottomEdge

                property bool state: false

                contentItem: Item {
                    implicitHeight: childrenRect.height + Units.gridUnit
                    ColumnLayout {
                        anchors.centerIn: parent
                        Controls.Button {
                            id: button
                            text: state2Str(!bottomDrawer.state)
                            onClicked: {
                                bottomDrawer.state = !bottomDrawer.state
                                var url = "http://ibexcps.com:5228/switchnode/1/" +( bottomDrawer.state ? "true" : "false")
                                getData(url)
                                showPassiveNotification("Turning HaLiO " + state2Str(bottomDrawer.state))
                            }
                        }
                        Item {
                            Layout.minimumHeight: Units.gridUnit
                        }
                    }
                }
            }

            ColumnLayout {
                id: lay
                width: page.width
                spacing: Units.smallSpacing

                property string buttonText: "Turn HaLiO " + state2Str(!bottomDrawer.state)

                Controls.Button {
                    text: lay.buttonText
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: bottomDrawer.open()
                }

                Rectangle {
                    color: root.recColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Units.gridUnit*20
                    height: Units.gridUnit*20
                }

                Text {
                    text: root.data
                }

            }
        }
   }


}
