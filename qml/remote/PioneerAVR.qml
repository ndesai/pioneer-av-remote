import QtQuick 2.7

Item {
    id: root

    Connections {
        target: _AVR
        onInitializeConnection: {
            _AVR.sendMessage("?F\r\n");
            _AVR.sendMessage("?P\r\n");
            _AVR.sendMessage("?V\r\n");
            _AVR.sendMessage("?M\r\n");
        }
        property var regexVolumeResponse: /^VOL([0-9]+)/
        onResponseReceived: {
            if (message.match(regexVolumeResponse)) {
                var volumeValue = message.replace("VOL", "");
                _AVR.volume = parseInt(volumeValue, 10) / 2;
            }
        }
    }

    function powerOn() {
        _AVR.sendMessage("PO\r\n");
        _AVR.poweredOn = true;
    }

    function powerOff() {
        _AVR.sendMessage("PF\r\n");
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
        _AVR.waitingForVolumeChange = true
        _AVR.sendMessage("VU\r\n");
    }

    function volumeDown() {
        // Send the volume down command
        _AVR.waitingForVolumeChange = true
        _AVR.sendMessage("VD\r\n");
    }

    function volume(value) {

    }

    function mute() {
        _AVR.sendMessage("MO\r\n");
        _AVR.mute = true;
    }

    function unmute() {
        _AVR.sendMessage("MF\r\n");
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
