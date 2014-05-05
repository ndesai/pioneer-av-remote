import QtQuick 2.0

Item {
    id: superRoot
    property bool darkTheme : superRoot.darkTheme
    width: 320
    height: 568
    Loader {
        id: _Loader
        width: parent.width*2
        height: parent.height*2
        anchors.left: parent.left;
        anchors.top: parent.top
        Scale {
            id: _Scale_iOS
            xScale: 0.5; yScale: 0.5
            origin.x: 0; origin.y: 0
        }

        states: [
            State {
                when: cpPlatform_iOS || cpPlatform_Mac
                PropertyChanges {
                    target: _Loader
                    transform: _Scale_iOS
                }
            },
            State {
                when: cpPlatform_Android
                PropertyChanges {
                    target: superRoot
                    width: 1080
                    height: 1920
                }
                PropertyChanges {
                    target: _Loader
                    width: superRoot.width
                    height: superRoot.height
                }

            }
        ]
        source: "remote.qml"
    }
}
