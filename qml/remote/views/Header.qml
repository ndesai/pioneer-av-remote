import QtQuick 2.2
import QtGraphicalEffects 1.0
Item {
    id: root
    property Item attachTo
    property alias title : _Text.text
    property alias themeColor : _Rectangle.color
    property alias titleColor : _Text.color
    signal clicked;
    property alias blurYOffset : _ShaderEffectSource.yOffset
    property bool darkTheme : false
    width: parent.width
    height: _FastBlur.height
    z: attachTo ? attachTo.z + 1 : 1
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(root.attachTo && root.attachTo.positionViewAtBeginning)
            {
                root.attachTo.positionViewAtBeginning();
            }
            root.clicked();
        }
    }
    Rectangle {
        id: _Rectangle
        anchors.fill: _FastBlur
        color: darkTheme ? "#222222" : "#ffffff"
    }
    FastBlur {
        id: _FastBlur
        height: 128
        width: root.width
        radius: 100
        opacity: 0.30
        source: ShaderEffectSource {
            id: _ShaderEffectSource
            property int yOffset : 0//1*_FastBlur.height
            sourceItem: root.attachTo ? root.attachTo : _Dummy
            sourceRect: Qt.rect(0,yOffset,root.width,_FastBlur.height)
        }
    }
    Item {
        id: _Dummy
    }
    Rectangle {
        // Bottom accent
        width: root.width
        height: 1
        anchors.top: _FastBlur.bottom
        color: darkTheme ? "#00000022" : "#656565"
        opacity: 0.60
    }
    Text {
        id: _Text
        color: darkTheme ? "#ffffff" : "#000000"
        font.family: "HelveticaNeue-Light"
        font.pixelSize: 34
        anchors.left: _FastBlur.left
        anchors.leftMargin: 35
        anchors.right: _FastBlur.right
        anchors.rightMargin: 35
        anchors.verticalCenter: _FastBlur.verticalCenter
        font.letterSpacing: -0.29
        anchors.verticalCenterOffset: 20
        font.weight: Font.DemiBold
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }
}
