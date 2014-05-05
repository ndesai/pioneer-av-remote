import QtQuick 2.2
Rectangle {
    id: root
    property Flickable attachTo
    property int yOffset
    color: "#222222"
    width: 5
    anchors.right: parent.right
    anchors.rightMargin: 10
    height: (attachTo) ? attachTo.visibleArea.heightRatio * (attachTo.height) * 0.90 : 0
    y: (attachTo) ? Math.max(yOffset, attachTo.visibleArea.yPosition* (attachTo.height)) : 0
    radius: 10
    visible: attachTo && attachTo.count && attachTo.interactive
    opacity: 0.0
    Behavior on opacity { NumberAnimation { duration: 350; } }
    Connections {
        target: attachTo ? attachTo : null
        ignoreUnknownSignals: true
        onContentYChanged: {
            _Timer_HideScrollbar._restart();
        }
    }
    Timer {
        id: _Timer_HideScrollbar
        function _restart()
        {
            stop();
            root.opacity = 0.35
            restart();
        }
        interval: 350; running: false; repeat: false;
        onTriggered: root.opacity = 0.0;
    }
}
