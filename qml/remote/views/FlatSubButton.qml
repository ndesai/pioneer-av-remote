import QtQuick 2.0

Rectangle {
    id: root
    signal clicked;
    property alias iconSource : _Image.source
    width: 100
    height: parent.button.height
    radius: parent.button.radius
    color: !_MouseArea.pressed ? parent.backgroundColor : parent.backgroundPressedColor
    anchors.verticalCenter: parent.verticalCenter
    Image {
        id: _Image
        anchors.centerIn: parent
    }
    MouseArea {
        id: _MouseArea
        anchors.fill: parent
        onClicked: root.clicked();
    }
    states: [
        State {
            name: "left"
            AnchorChanges {
                target: root
                anchors.left: parent.left
            }
            PropertyChanges {
                target: root
                anchors.leftMargin: parent.leftRightMargin
            }
        },
        State {
            name: "right"
            AnchorChanges {
                target: root
                anchors.right: parent.right
            }
            PropertyChanges {
                target: root
                anchors.rightMargin: parent.leftRightMargin
            }
        }
    ]
}
