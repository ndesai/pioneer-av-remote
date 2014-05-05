import QtQuick 2.0

Item {
    id: root
    signal clicked;
    property color backgroundColor : "#419bdb"
    property color backgroundPressedColor : backgroundColor
    property alias label : _Text.text
    property alias labelColor : _Text.color
    property alias button : _Rectangle
    property alias text : _Text
    property int leftRightMargin : Math.floor((width - _Rectangle.width) / 2)
    property int topBottomMargin : Math.floor((height - _Rectangle.height) / 2)
    width: parent.width
    height: 132
    Rectangle {
        id: _Rectangle
        anchors.centerIn: parent
        color: !_MouseArea.pressed ? root.backgroundColor : root.backgroundPressedColor
        width: 556; height: 95
        radius: 10
        clip: true
        Text {
            id: _Text
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#ffffff"
            font.family: "HelveticaNeue-Light"
            text: ""
            font.pixelSize: 34
            wrapMode: Text.WordWrap
        }

        MouseArea {
            id: _MouseArea
            anchors.fill: parent
            onClicked: {
                root.clicked();
            }
        }
    }
}
