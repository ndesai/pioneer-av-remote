import QtQuick 2.0
import QtGraphicalEffects 1.0
Rectangle {
    id: root
    signal clicked;
    property alias iconSource : _Image.source
    property bool darkTheme : false
    property color backgroundColor : darkTheme ? "#151515" : "#efeff4"
    property color backgroundPressedColor : darkTheme ? "#2b2b2c" : "#e1e1e6"
    width: 91; height: 59
    radius: 10
    color: !_MouseArea.pressed ? backgroundColor : backgroundPressedColor
    anchors.right: parent.right
    anchors.rightMargin: 24
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: 20
    Image {
        id: _Image
        anchors.centerIn: parent
    }
    ColorOverlay {
        anchors.fill: _Image
        source: _Image
        color: darkTheme ? "#ffffff" : "#000000"
    }
    MouseArea {
        id: _MouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked();
        }
    }
    states: [
        State {
            name: "right"
            AnchorChanges {
                target: root
                anchors.right: parent.right
            }
            PropertyChanges {
                target: root
                anchors.rightMargin: 25
            }
        },
        State {
            name: "left"
            AnchorChanges {
                target: root
                anchors.left: parent.left
            }
            PropertyChanges {
                target: root
                anchors.leftMargin: 25
            }
        }
    ]
}
