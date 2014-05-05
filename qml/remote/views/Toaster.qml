import QtQuick 2.0
import "../utils/Log.js" as Log
Item {
    id: root
    anchors.fill: parent
    clip: true
    layer.enabled: true
    property int activeCount : 0
    property variant messageQueue : []
    onActiveCountChanged: {
        if(activeCount > 0)
        {
            popMessage()
        } else
        {
            _Timer_ShowStatusBar.restart()
        }
    }

    Timer {
        id: _Timer_ShowStatusBar
        interval: 250; running: false; repeat: false;
        onTriggered: {
            _PlatformiOS.statusBarVisible = true
        }
    }

    signal burnToasts(string tag, string message)

    function popMessage(isUpdate)
    {
        Log.notice(root, "popMessage()");
        Log.notice(root, "activeCount = " + activeCount);
        Log.notice(root, "messageQueue.length = " + messageQueue.length);
        if(activeCount > 0 && !isUpdate) return;
        if(messageQueue.length === 0) return;
        _Component_Toast.createObject(root, messageQueue[0]);
        messageQueue = messageQueue.splice(1, messageQueue.length)
    }

    function toast(message, delay, tag)
    {
        _PlatformiOS.statusBarVisible = false
        if(!message) return;
        var d; if(!delay) d = 1; else d = delay;

        var messageObject = new Object;
        messageObject.label = message
        messageObject.z = activeCount
        messageObject.delay = d
        messageObject.tag = tag ? tag : ""

        var mq = messageQueue;
        mq.push(messageObject)
        messageQueue = mq;
        popMessage();
    }

    function bruteToast(message, tag)
    {
        if(!message) return;
        activeCount = 0;
        var mq = new Array;
        messageQueue = mq;
        burnToasts(tag?tag:"", message)
        var messageObject = new Object;
        messageObject.label = message
        messageObject.z = 0
        messageObject.delay = 0
        mq.push(messageObject)
        messageQueue = mq
        popMessage()
    }

    Component {
        id: _Component_Toast
        FlatButton {
            id: _FlatButton
            layer.smooth: true
            layer.enabled: true
            property int delay : 1
            property string tag : ""
            button.width: parent.width
            button.height: 42
            anchors.top: parent.top
            anchors.topMargin: -90
            backgroundColor: "#7f8c8d"
            backgroundPressedColor: "#95a5a6"
            labelColor: "#ffffff"
            text.font.pixelSize: 22
            button.radius: 0
            onClicked: _Timer.action();
            Connections {
                target: root
                onBurnToasts: {
                    if(_FlatButton.tag === tag)
                        _FlatButton.label = message
                    else
                        _FlatButton.destroy()
                }

            }
            Timer {
                id: _Timer_Show
                interval: _FlatButton.delay
                running: false; repeat: false;
                onTriggered: {
                    _FlatButton.state = "visible"
                }
            }

            Timer {
                id: _Timer
                interval: 2500; running: false; repeat: false;
                onTriggered: action();
                function action()
                {
                    root.activeCount -= 1
                   _FlatButton.state = "";
                }
            }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: _FlatButton
                        anchors.topMargin: -48
                    }
                }
            ]
            transitions: [
                Transition {
                    from: ""
                    to: "visible"
                    SequentialAnimation {
                        PauseAnimation { duration: 250 }
                        NumberAnimation {
                            target: _FlatButton
                            property: "anchors.topMargin"
                            duration: 250
                            easing.type: Easing.OutBack
                            easing.overshoot: 0.65
                        }
                        ScriptAction { script: _Timer.restart() }
                    }
                },
                Transition {
                    from: "visible"
                    to: ""
                    SequentialAnimation {
                        NumberAnimation {
                            target: _FlatButton
                            property: "anchors.topMargin"
                            duration: 250
                            easing.type: Easing.InBack
                            easing.overshoot: 0.75
                        }
                        ScriptAction { script: _FlatButton.destroy() }
                    }
                }
            ]
            Component.onCompleted: {
                root.activeCount++
                _Timer_Show.restart()
            }
        }
    }
}
