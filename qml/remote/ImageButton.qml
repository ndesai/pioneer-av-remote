import QtQuick 2.2

Image {
    id: root
    signal clicked;
    property alias pressed : _MouseArea.pressed
    MouseArea {
        id: _MouseArea
        anchors.fill: parent
        onClicked: root.clicked();
    }
}
