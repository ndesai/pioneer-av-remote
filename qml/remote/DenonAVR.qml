import QtQuick 2.7

Item {
    id: root

    Connections {
        target: _AVR
        onInitializeConnection: {
            _AVR.sendMessage("MU?\r\n");
            _AVR.sendMessage("PW?\r\n");
            _AVR.sendMessage("MV?\r\n");
        }
        property var regexPowerResponse: /^PW([A-Z]+)/
        property var regexMasterVolumeResponseLevel: /^MV([0-9]+)/
        property var regexMasterVolumeResponseMax: /^MVMAX+)/
        onResponseReceived: {
            if (message.match(regexMasterVolumeResponseLevel)) {
                var volumeValueString = message.replace("MV", "");
                var volumeValue = parseInt(volumeValueString, 10);
                if (volumeValue > 99) {
                    volumeValue = volumeValue / 10;
                }
                _AVR.volume = volumeValue;
            } else if (message.match(regexMasterVolumeResponseMax)) {
                var volumeMax = parseInt(message.replace("MVMAX ", ""), 10);
                _AVR.volumeMax = volumeMax;
            } else if (message.match(regexPowerResponse)) {
                if (message == "PWON") {
                    _AVR.poweredOn = true;
                } else if (message == "PWSTANDBY") {
                    _AVR.poweredOn = false;
                }
            } else if (message.match(/^MU([A-Z]+)/)) {
                if (message == "MUOFF") {
                    _AVR.mute = false;
                } else if (message == "MUON") {
                    _AVR.mute = true;
                }
            }
        }
    }

    function powerOn() {
        _AVR.sendMessage("PWON\r\n");
        _AVR.poweredOn = true;
    }

    function powerOff() {
        _AVR.sendMessage("PWSTANDBY\r\n");
        _AVR.poweredOn = false;
    }

    function powerToggle() {
        if (!_AVR.poweredOn) {
            powerOn();
        } else {
            powerOff();
        }
    }

    function volumeUp() {
        // Send the volume up command
        _AVR.waitingForVolumeChange = true;
        _AVR.sendMessage("MVUP\r\n");
    }

    function volumeDown() {
        // Send the volume down command
        _AVR.waitingForVolumeChange = true;
        _AVR.sendMessage("MVDOWN\r\n");
    }

    function volume(value) {
        // Send the volume down command
        _AVR.waitingForVolumeChange = true;
        _AVR.sendMessage("MV" + value + "\r\n");
    }

    function mute() {
        _AVR.sendMessage("MUON\r\n");
        _AVR.mute = true;
    }

    function unmute() {
        _AVR.sendMessage("MUOFF\r\n");
        _AVR.mute = false;
    }

    function muteToggle() {
        if(!_AVR.mute) {
            mute();
        } else {
            unmute();
        }
    }
}
