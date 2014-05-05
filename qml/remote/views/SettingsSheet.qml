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
            layer.enabled: true
            Header {
                id: _Header
                title: qsTr("Settings")
                darkTheme: root.darkTheme
                onClicked: {
                }
                attachTo: _Flickable
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
                    onClicked: {
                        Qt.inputMethod.hide();
                        if(_TextField.originalValue !== _TextField.text
                                || _Rectangle_OptionBox.originalValue !== _Rectangle_OptionBox.dataValue)
                        {
                            _PS.insert("receiverHost", _TextField.text, function(ret) {
                                _Toaster.toast("Successfully updated receiver settings")
                                _PC.receiverHost = _TextField.text

                                if(_Rectangle_OptionBox.originalValue !== _Rectangle_OptionBox.dataValue)
                                {
                                    _PS.insert("receiverPort", _Rectangle_OptionBox.dataValue, function(ret) {
                                        _PC.port = parseInt(_Rectangle_OptionBox.dataValue, 10)
                                        root.close();
                                    })
                                } else
                                {
                                    root.close();
                                }

                            })
                        } else
                        {
                            root.close();
                        }
                    }
                }
            }
            Flickable {
                id: _Flickable
                anchors.top: _Header.bottom
                anchors.topMargin: 30
                anchors.left: parent.left; anchors.right: parent.right
                anchors.bottom: parent.bottom
                contentHeight: _Column_Content.height
                contentWidth: width
                Column {
                    id: _Column_Content
                    height: childrenRect.height
                    width: parent.width
                    Item { width: 1; height: 10; }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 556
                        text: "Receiver Hostname / IP Address"
                        color: root.darkTheme ? "#eeeeee" : "#000000"
                        horizontalAlignment: Text.AlignLeft
                    }
                    Item { width: 1; height: 15; }
                    Controls.TextField {
                        id: _TextField
                        property string originalValue : ""
                        width: 556
                        height: 95
                        font.pixelSize: 34
                        placeholderText: !activeFocus ?
                                             qsTr("e.g. VSX-822.local")
                                           : ""
                        font.family: "HelveticaNeue-Light"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: ControlStyles.TextFieldStyle {
                            textColor: root.darkTheme ? "#cccccc" : "#6d6d6e"
                            background: Rectangle {
                                radius: 10
                                color: root.darkTheme ? "#232323" : "#efeff4"
                                border {
                                    width: 1;
                                    color: root.darkTheme ? "#333333" : "#f2f2f6"
                                }
                            }
                            placeholderTextColor: root.darkTheme ? "#dddddd" : "#c1c1c1"
                        }
                        Component.onCompleted: {
                            _PS.getValue("receiverHost", function(value) {
                                _TextField.originalValue = value;
                                _TextField.text = value;
                            });
                        }
                    }
                    Item { width: 1; height: 25; }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 556
                        text: "Receiver Port"
                        color: root.darkTheme ? "#eeeeee" : "#000000"
                        horizontalAlignment: Text.AlignLeft
                    }
                    Item { width: 1; height: 15; }
                    Rectangle {
                        id: _Rectangle_OptionBox
                        property string originalValue : "23"
                        property string dataValue : "23"
                        property string dataValueLeft : "23"
                        property string dataValueRight : "8102"
                        width: 556
                        height: 95
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 10
                        color: root.darkTheme ? "#232323" : "#efeff4"
                        states: [
                            State {
                                name: "left"
                                when: _Rectangle_OptionBox.dataValue === _Rectangle_OptionBox.dataValueLeft
                                PropertyChanges {
                                    target: _Rectangle_Left
                                    color: "#419bdb"
                                }
                                PropertyChanges {
                                    target: _Text_Left
                                    color: "#ffffff"
                                }
                            },
                            State {
                                name: "right"
                                when: _Rectangle_OptionBox.dataValue === _Rectangle_OptionBox.dataValueRight
                                PropertyChanges {
                                    target: _Rectangle_Right
                                    color: "#419bdb"
                                }
                                PropertyChanges {
                                    target: _Text_Right
                                    color: "#ffffff"
                                }
                            }
                        ]
                        Rectangle {
                            id: _Rectangle_Left
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: Math.floor(parent.width / 2)
                            color: parent.color
                            radius: 10
                            Text {
                                id: _Text_Left
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: root.darkTheme ? "#cccccc" : "#6d6d6e"
                                font.family: "HelveticaNeue-Light"
                                text: "23"
                                font.pixelSize: 34
                                wrapMode: Text.WordWrap
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: _Rectangle_OptionBox.dataValue = _Rectangle_OptionBox.dataValueLeft
                            }
                        }
                        Rectangle {
                            id: _Rectangle_Right
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: Math.floor(parent.width / 2)
                            color: parent.color
                            radius: 10
                            Text {
                                id: _Text_Right
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: root.darkTheme ? "#cccccc" : "#6d6d6e"
                                font.family: "HelveticaNeue-Light"
                                text: "8102"
                                font.pixelSize: 34
                                wrapMode: Text.WordWrap
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: _Rectangle_OptionBox.dataValue = _Rectangle_OptionBox.dataValueRight
                            }
                        }
                        Rectangle {
                            width: 20
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: parent.color
                        }
                        clip: true
                        Component.onCompleted: {
                            _PS.getValue("receiverPort", function(value) {
                                var portNumber = value;
                                if(portNumber == "")
                                {
                                    portNumber = "23"
                                }
                                _Rectangle_OptionBox.originalValue = portNumber;
                                _Rectangle_OptionBox.dataValue = portNumber;
                            });
                        }
                    }
                    Item { width: 1; height: 25; }
                    Item {
                        height: 116
                        width: 556
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label {
                            text: "Use Dark Theme"
                            anchors.verticalCenter: parent.verticalCenter
                            color: root.darkTheme ? "#eeeeee" : "#000000"
                        }
                        Controls.Switch {
                            id: _CheckBox
                            anchors.right: parent.right
                            checked: superRoot.darkTheme
                            onCheckedChanged: {
                                if(superRoot.darkTheme === checked) return;
                                superRoot.darkTheme = checked
                                _PS.insert("darkTheme", checked, function() {
                                    _Toaster.toast("Successfully updated theme")
                                })
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            style: ControlStyles.SwitchStyle {
                                groove: Rectangle {
                                    implicitWidth: 110
                                    implicitHeight: 62
                                    radius: 35
                                    color: root.darkTheme ? "#232323" : "#efeff4"
                                    border {
                                        width: 1;
                                        color: root.darkTheme ? "#333333" : "#f2f2f6"
                                    }
                                }
                                handle: Rectangle {
                                    implicitWidth: 60
                                    implicitHeight: 60
                                    radius: 30
                                    color: "#419bdb"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

