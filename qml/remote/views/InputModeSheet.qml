import QtQuick 2.0
import "../utils/Utility.js" as Utility
import "../utils/Log.js" as Log
import QtQuick.Controls 1.1 as Controls
import QtQuick.Controls.Styles 1.1 as ControlStyles
Sheet {
    id: root
    sourceComponent: _Content
    Component {
        id: _Content
        Item {
            Header {
                id: _Header
                title: qsTr("Input Mode")
                darkTheme: root.darkTheme
                onClicked: {
                    root.close();
                }
                attachTo: _ListView
                blurYOffset: -1*height
                HeaderButton {
                    darkTheme: root.darkTheme
                    state: "right"
                    Label {
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        text: "Done"
                        color: root.darkTheme ? "#eeeeee" : "#000000"
                    }
                    onClicked: root.close();
                }
            }
            ListView {
                id: _ListView
                anchors.top: _Header.bottom
                anchors.topMargin: 0
                anchors.left: parent.left; anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: _ListModel_InputMethods
                pixelAligned: true
                cacheBuffer: 10000
                function itemClicked(dataObject)
                {
                    if(!dataObject.canSet)
                    {
                        _Toaster.toast("Could not set input")
                        return;
                    }
                    var i = ""+dataObject.identifier+"";
                    if(i.length == 1)
                        i = "0" + "" + i
                    _AVR.sendMessage(i+"FN\r\n");
                    _Toaster.toast("Set input to " + dataObject.label)
                }

                delegate: Rectangle {
                    id: _Item_Delegate
                    width: ListView.view.width
                    height: 116
                    layer.enabled: true
                    layer.smooth: true
                    color: root.color
                    Row {
                        anchors.fill: parent
                        Item {
                            height: 1; width: 30
                        }
                        Rectangle {
                            id: _Rectangle_CodeContainer
                            anchors.top: parent.top
                            anchors.topMargin: 35
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: anchors.topMargin
                            width: Math.max(165, _Label_CodeName.paintedWidth + 30)
                            radius: 10
                            border { width: 2; color: "#419bdb" }
                            color: "transparent"
                            Label {
                                id: _Label_CodeName
                                anchors.centerIn: parent
                                color: "#419bdb"
                                font.pixelSize: 24
                                font.bold: true
                                text: model.code
                            }
                        }
                        Item {
                            height: 1; width: 40
                        }
                        Label {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 30
                            verticalAlignment: Text.AlignVCenter
                            text: model.label
                            color: root.darkTheme ? "#f3f3f3" : "#232323"
                        }
                    }
                    MouseArea {
                        id: _MouseArea
                        anchors.fill: parent
                        onClicked: _Item_Delegate.ListView.view.itemClicked(model);
                    }
                    BottomAccent { color: root.darkTheme ? "#333333" : "#dddddd" }
                    TopAccent { color: root.darkTheme ? "#333333" : "#dddddd"; visible: index === 0; }
                    states: [
                        State {
                            when: _MouseArea.pressed
                            PropertyChanges {
                                target: _Item_Delegate
                                color: root.darkTheme ? "#111111" : "#eeeeee"
                            }
                        },
                        State {
                            name: "active"
                            when: model.identifier === _AVR.input
                            PropertyChanges {
                                target: _Label_CodeName
                                color: "#ffffff"
                            }
                            PropertyChanges {
                                target: _Rectangle_CodeContainer
                                color: "#419bdb"
                                border.width: 0
                            }
                            PropertyChanges {
                                target: _MouseArea
                                enabled: false
                            }
                        }
                    ]
                }
            }
        }
    }
}

