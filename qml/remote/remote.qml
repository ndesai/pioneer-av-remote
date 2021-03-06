import QtQuick 2.0
import st.app 1.0 as AppStreet
import "views" as Views
import "utils/Log.js" as Log
import "utils" as Utils
Rectangle {
    id: root
    width: 640
    height: 562*2
    visible: false
    //    layer.enabled: true
    //    layer.smooth: true
    property bool darkTheme : superRoot.darkTheme
    color: darkTheme ? "#000000" : "#ffffff"

    Utils.PersistentStorage {
        id: _PS
    }

    AppStreet.PlatformiOS {
        id: _PlatformiOS
        statusBarStyle: !root.darkTheme ? AppStreet.PlatformiOS.StatusBarStyleDefault
                                       : AppStreet.PlatformiOS.StatusBarStyleLightContent
        applicationIconBadgeNumber: _PC.volume
    }

    AppStreet.AVRCommunicator {
        id: _AVR
        onInputChanged: {
            console.log("onInputChanged - " + input);
        }
        property bool waitingForVolumeChange : false
        onVolumeChanged: {
            console.log("onVolumeChanged - " + volume);
            if(waitingForVolumeChange)
            {
                //_Toaster.bruteToast("Volume changed to " + volume, "volumeToast")
                waitingForVolumeChange = false
            }
        }
        onVolumeMaxChanged: {
            console.log("onVolumeMaxChanged - " + volumeMax);
        }
        onMuteChanged: {
            console.log("onMuteChanged - " + mute);
        }
        onConnectedChanged: {
            console.log("onConnectedChanged - " + connected);
            if(connected)
            {
                _Toaster.toast("Connected to receiver")
            } else
            {
                _Toaster.toast("Disconnected from receiver")
            }
        }
        onPoweredOnChanged: {
            console.log("onPoweredOnChanged - " + poweredOn);
        }
        onAirplayNowPlayingInformationChanged: {
            console.log("onAirplayNowPlayingInformationChanged - ")
            console.log(JSON.stringify(airplayNowPlayingInformation, null, 2));
            var arr = new Array;
            for(var idx in airplayNowPlayingInformation)
            {
                if(airplayNowPlayingInformation[idx].trim() !== "")
                    arr.push(airplayNowPlayingInformation[idx]);
            }
            airplay_albumDetails = arr.join(" - ")
        }
        property string airplay_albumDetails : ""
        onAirplay_albumDetailsChanged: {
            console.log("onAirplay_albumDetailsChanged - ")
            console.log(JSON.stringify(airplay_albumDetails, null, 2));
        }
        onFailedToSendMessage: {
            _Toaster.toast("Failed to send message to receiver")
        }
        onMessageSending: {
            try { _PlatformiOS.networkActivityIndicator = true } catch (ex) { }
        }
        onMessageReceived: {
            try { _PlatformiOS.networkActivityIndicator = false } catch (ex) { }
        }
    }

    property var activeAVR: _loaderDenonAVR.item

    Loader {
        id: _loaderPioneerAVR
        active: true
        sourceComponent: PioneerAVR { }
    }

    Loader {
        id: _loaderDenonAVR
        active: false
        sourceComponent: DenonAVR { }
    }

    Views.Header {
        id: _Header
        title: "Better AVR Remote"
        attachTo: _Flickable
        darkTheme: root.darkTheme
        Views.HeaderButton {
            darkTheme: root.darkTheme
            iconSource: "img/icon-settings.png"
            state: "right"
            onClicked: _SettingsSheet.open();
        }
    }

    Flickable {
        id: _Flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: _Column.height
        interactive: (contentHeight > height)

        Column {
            id: _Column
            width: parent.width
            height: childrenRect.height

            Item {
                width: parent.width
                height: 30 + _Header.height
            }

            Views.FlatButton {
                id: _FlatButton_Power
                label: "Power"
                backgroundColor: "#419bdb"
                backgroundPressedColor: "#3183bd"
                onClicked: {
                    activeAVR.powerToggle();
                }
            }

            Views.FlatButton {
                id: _FlatButton_Input
                label: "Input Mode"
                backgroundColor: "#3bcb73"
                backgroundPressedColor: "#34b968"
                onClicked: {
                    //                    _AVR.sendMessage("?F\r\n");
                    //                    _AVR.sendMessage("?GAP\r\n");
                    _AVR.sendMessage("?FR\r\n");
                    _InputModeSheet.open();
                }

                Views.FlatSubButton {
                    iconSource: "img/arrow-left.png"
                    state: "left"
                    onClicked: {
                        // Cycle in reverse
                        _AVR.inputCycle(true);
                    }
                }

                Views.FlatSubButton {
                    iconSource: "img/arrow-right.png"
                    state: "right"
                    onClicked: {
                        // Cycle in standard direction
                        _AVR.inputCycle(false);
                    }
                }
            }

            Views.FlatButton {
                id: _FlatButton_InputDetails
                backgroundColor: "#efeff4"
                labelColor: "#323232"
                //button.height: _Column_InputDetails.height
                //height: button.height + 2*topBottomMargin
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic; } }
                label: _Label_InputName.text
                Column {
                    id: _Column_InputDetails
                    clip: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: parent.leftRightMargin
                    anchors.rightMargin: parent.leftRightMargin
                    anchors.top: parent.top
                    anchors.topMargin: parent.topBottomMargin
                    height: childrenRect.height
                    visible: false;
                    Item {
                        width: 1
                        height: 25
                    }
                    Views.Label {
                        id: _Label_InputName
                        text: "Unknown"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Item {
                        width: 1
                        height: _Item_InputDetailsContainer.height > 0 ? 10 : 0
                    }
                    Item {
                        id: _Item_InputDetailsContainer
                        width: parent.width
                        height: _Label_InputDetails.text === "" ? 0 : _Label_InputDetails.paintedHeight
                        Views.Label {
                            id: _Label_InputDetails
                            color: "#6d6d6e"
                            text: ""
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            font.pixelSize: 30
                        }
                    }
                    Item {
                        width: 1
                        height: 25
                    }
                }
                states: [
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.AIRPLAY
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Airplay"
                        }
                        PropertyChanges {
                            target: _Label_InputDetails
                            text: _AVR.airplay_albumDetails
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.SATCBL
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Satellite / Cable Box"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.DVD
                        PropertyChanges {
                            target: _Label_InputName
                            text: "DVD"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.BD
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Blu-Ray Drive"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.ADAPTERPORT
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Adapter"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.TUNER
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Tuner"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.CD
                        PropertyChanges {
                            target: _Label_InputName
                            text: "CD"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.TVSAT
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Television / Satellite"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.IPODUSB
                        PropertyChanges {
                            target: _Label_InputName
                            text: "iPod / USB"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.IPODUSB
                        PropertyChanges {
                            target: _Label_InputName
                            text: "iPod / USB"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.FAVORITE
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Favorites"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.MEDIASERVER
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Media Server"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.PANDORA
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Pandora"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.NETRADIO
                        PropertyChanges {
                            target: _Label_InputName
                            text: "NetRadio"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.GAME
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Game"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.VIDEO
                        PropertyChanges {
                            target: _Label_InputName
                            text: "Video"
                        }
                    },
                    State {
                        when: _AVR.input == AppStreet.AVRCommunicator.DVRBDR
                        PropertyChanges {
                            target: _Label_InputName
                            text: "DVR / BDR"
                        }
                    }
                ]
            }
            Views.FlatButton {
                id: _FlatButton_Volume
                label: ""
                backgroundColor: "#364a5e"
                backgroundPressedColor: "#416a92"
                onClicked: {
                    activeAVR.muteToggle();
                }
                Image {
                    id: _Image_VolumeIcon
                    anchors.centerIn: parent
                    source: "img/icon-volume-max.png"
                    states: [
                        State {
                            when: _AVR.mute
                            PropertyChanges {
                                target: _Image_VolumeIcon
                                source: "img/icon-volume-mute.png"
                            }
                        },
                        State {
                            when: _AVR.volume <= (1*_AVR.volumeMax/3)
                            PropertyChanges {
                                target: _Image_VolumeIcon
                                source: "img/icon-volume-min.png"
                            }
                        },
                        State {
                            when: _AVR.volume <= (2*_AVR.volumeMax/3)
                            PropertyChanges {
                                target: _Image_VolumeIcon
                                source: "img/icon-volume-mid.png"
                            }
                        }
                    ]
                }

                Views.FlatSubButton {
                    iconSource: "img/volume-down.png"
                    state: "left"
                    onClicked: {
                        activeAVR.volumeDown();
                    }
                }
                Views.FlatSubButton {
                    iconSource: "img/volume-up.png"
                    state: "right"
                    onClicked: {
                        activeAVR.volumeUp();
                    }
                }
            }
        }
    }

    Views.SettingsSheet {
        id: _SettingsSheet
        darkTheme: root.darkTheme
        onOpened: {
            _Flickable.visible = false
        }
        onClosing: {
            _Flickable.visible = true
        }
    }

    Views.InputModeSheet {
        id: _InputModeSheet
        darkTheme: root.darkTheme
        onOpened: {
            _Flickable.visible = false
        }
        onClosing: {
            _Flickable.visible = true
        }
    }


    Views.Toaster {
        id: _Toaster
        z: 100
    }




    // MODELS


    ListModel {
        id: _ListModel_InputMethods


        property variant dataModel : [
            {
                "identifier": AppStreet.AVRCommunicator.AIRPLAY,
                "code" : "AP",
                "label": "Airplay",
                "canSet" : false
            },
            {
                "identifier": AppStreet.AVRCommunicator.SATCBL,
                "code" : "SATCBL",
                "label":  "Satellite / Cable Box"
            },
            {
                "identifier": AppStreet.AVRCommunicator.DVD,
                "code" : "DVD",
                "label":  "DVD"
            },
            {
                "identifier": AppStreet.AVRCommunicator.BD,
                "code" : "BD",
                "label":  "Blu-Ray Drive"
            },
            {
                "identifier": AppStreet.AVRCommunicator.ADAPTERPORT,
                "code" : "AD.PORT",
                "label": "Adapter"
            },
            {
                "identifier": AppStreet.AVRCommunicator.TUNER,
                "code" : "TUNER",
                "label":  "Radio Tuner"
            },
            {
                "identifier": AppStreet.AVRCommunicator.CD,
                "code" : "CD",
                "label":  "Compact Disc"
            },
            {
                "identifier": AppStreet.AVRCommunicator.TVSAT,
                "code" : "TVSAT",
                "label":  "Television / Satellite"
            },

            {
                "identifier": AppStreet.AVRCommunicator.IPODUSB,
                "code" : "IPOD",
                "label":  "iPod / USB"
            },
            {
                "identifier": AppStreet.AVRCommunicator.FAVORITE,
                "code" : "FAV",
                "label":  "Favorites"
            },
            {
                "identifier": AppStreet.AVRCommunicator.MEDIASERVER,
                "code" : "M.SERVER",
                "label":  "Media Server"
            },
            {
                "identifier": AppStreet.AVRCommunicator.PANDORA,
                "code" : "PANDORA",
                "label":  "Pandora"
            },
            {
                "identifier": AppStreet.AVRCommunicator.NETRADIO,
                "code" : "NET",
                "label":  "NetRadio"
            },
            {
                "identifier": AppStreet.AVRCommunicator.GAME,
                "code" : "GAME",
                "label":  "Game"
            },
            {
                "identifier": AppStreet.AVRCommunicator.VIDEO,
                "code" : "VIDEO",
                "label":  "Video"
            },
            {
                "identifier": AppStreet.AVRCommunicator.DVRBDR,
                "code" : "DVRBDR",
                "label":  "DVR / BDR"
            }
        ]



        Component.onCompleted: {
            for(var i = 0; i < dataModel.length; i++)
            {
                var o = dataModel[i];
                if(typeof o.canSet === "undefined")
                {
                    o.canSet = true;
                }
                append(o);
            }
            _PS.getValue("darkTheme", function(value) {
                Log.notice(root, "setting dark theme to " + value);
                superRoot.darkTheme = value == "true"
                root.visible = true
            })
            _PS.getValue("receiverHost", function(value) {
                Log.notice(root, "setting receiver host to " + value);
                _AVR.receiverHost = value
            })
            _PS.getValue("receiverPort", function(value) {
                Log.notice(root, "setting receiver port to " + value);
                _AVR.port = parseInt(value, 10)
            })
        }
    }
}
