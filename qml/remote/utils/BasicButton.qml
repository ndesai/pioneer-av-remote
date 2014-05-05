import QtQuick 2.2

Rectangle {
    id: root
    signal clicked
    width: 100
    height: 62
    z: 10000
    anchors.centerIn: parent
    color: "#00FEAA"
    opacity: 0.25
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
