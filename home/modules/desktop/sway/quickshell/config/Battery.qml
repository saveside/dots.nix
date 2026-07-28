// Battery flyout — per-screen overlay, anchored under the battery chip.
// UPower supplies live metrics; asusctl toggles power profiles
// (asusd is enabled in your system config; powerprofilesctl isn't).
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // ---- palette (from ShellRoot) ---------------------------------------
    required property color bg
    required property color fg
    required property color muted
    required property color accent
    required property color line
    required property color danger
    required property string fontFamily

    // ---- open/close state -----------------------------------------------
    required property bool open
    signal closeRequested()

    // ---- geometry --------------------------------------------------------
    property int flyoutWidth: 300
    // Right-edge offset — puts the flyout roughly under the battery chip
    // (right row: tray | notif | battery | …). Tune per your layout.
    property int rightOffset: 90
    property int topOffset:   0

    // ---- UPower device --------------------------------------------------
    readonly property var _device: {
        const list = UPower.devices ? UPower.devices.values : []
        for (const d of list) {
            if (d && d.nativePath && d.nativePath.indexOf("battery_") === 0)
                return d
        }
        return UPower.displayDevice
    }
    readonly property bool _ok:          _device && _device.isPresent
    readonly property int  _pct:         _ok ? Math.round(_device.percentage * 100) : 0
    readonly property int  _state:       _ok ? _device.state : UPowerDeviceState.Unknown
    readonly property bool _charging:    _state === UPowerDeviceState.Charging
    readonly property bool _full:        _state === UPowerDeviceState.FullyCharged
    readonly property bool _discharging: _state === UPowerDeviceState.Discharging
    readonly property bool _low:         _pct > 0 && _pct < 20 && !_charging && !_full
    readonly property real _rate:        _ok && _device.energyRate ? _device.energyRate : 0
    readonly property int  _timeToFull:  _ok && _device.timeToFull  ? _device.timeToFull  : 0
    readonly property int  _timeToEmpty: _ok && _device.timeToEmpty ? _device.timeToEmpty : 0
    readonly property int  _healthPct: {
        if (!_ok || !_device.energyFullDesign || _device.energyFullDesign <= 0) return 0
        return Math.round((_device.energyFull / _device.energyFullDesign) * 100)
    }

    function _fmtTime(sec) {
        if (!sec || sec < 60) return "—"
        const h = Math.floor(sec / 3600)
        const m = Math.floor((sec % 3600) / 60)
        if (h > 0) return h + "h " + m + "m"
        return m + "m"
    }
    function _stateLabel() {
        if (!_ok) return "NO BATTERY"
        if (_full) return "FULLY CHARGED"
        if (_charging) return "CHARGING"
        if (_discharging) return "ON BATTERY"
        return "IDLE"
    }
    function _timeLabel() {
        if (!_ok || _full) return ""
        if (_charging    && _timeToFull  > 0) return _fmtTime(_timeToFull)  + " until full"
        if (_discharging && _timeToEmpty > 0) return _fmtTime(_timeToEmpty) + " until empty"
        return ""
    }

    // ---- power-profile controller (asusctl) -----------------------------
    // asusctl profile -p        →  "Active profile is: Balanced"
    // asusctl profile -P <name> →  sets it; <name> ∈ Quiet | Balanced | Performance
    property string currentProfile: ""      // "" while unknown

    Process {
        id: profileProc
        running: false
        command: ["sh", "-c",
            "asusctl profile -p 2>/dev/null | " +
            "grep -oiE '(quiet|balanced|performance)' | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim().toLowerCase()
                if (!t) return
                root.currentProfile = t.charAt(0).toUpperCase() + t.slice(1)
            }
        }
    }
    Timer {
        interval: 3000; running: root.open; repeat: true
        onTriggered: profileProc.running = true
    }
    Timer {
        id: _refreshDelay
        interval: 400; repeat: false
        onTriggered: profileProc.running = true
    }
    function setProfile(name) {
        Quickshell.execDetached(["asusctl", "profile", "-P", name])
        root.currentProfile = name    // optimistic
        _refreshDelay.restart()
    }

    // ---- keep-alive so the close animation plays ------------------------
    // Combined open-changed handler (QML disallows declaring the same
    // signal handler twice): trigger the profile fetch AND drive _alive.
    property bool _alive: false
    onOpenChanged: {
        if (open) {
            _closeTimer.stop()
            _alive = true
            profileProc.running = true
        } else if (_alive) {
            _closeTimer.restart()
        }
    }
    Timer { id: _closeTimer; interval: 220; repeat: false; onTriggered: root._alive = false }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: flyout
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-battery"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 34 }
            color: "transparent"
            visible: root._alive

            // Click-outside dismiss
            MouseArea {
                anchors.fill: parent
                onClicked: root.closeRequested()
            }

            Rectangle {
                id: box
                x: parent.width - width - root.rightOffset
                y: root.open ? root.topOffset : (root.topOffset - 10)
                width: root.flyoutWidth
                height: content.implicitHeight + 24
                color: root.bg
                border { color: root.line; width: 1 }
                radius: 4
                opacity: root.open ? 1.0 : 0.0

                Behavior on y       { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                MouseArea { anchors.fill: parent; onClicked: {} }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    // ---- Header: big % + state label -----------------
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: root._pct + "%"
                            color: root._low ? root.danger : root.accent
                            font { family: root.fontFamily; pixelSize: 28; weight: Font.Black }
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: root._stateLabel()
                            color: root._charging || root._full ? root.accent : root.fg
                            font {
                                family: root.fontFamily
                                pixelSize: 10
                                weight: Font.Bold
                                capitalization: Font.AllUppercase
                                letterSpacing: 1.0
                            }
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    // ---- Thin charge bar (animated fill) -------------
                    Item {
                        Layout.fillWidth: true
                        Layout.topMargin: 2
                        implicitHeight: 6
                        Rectangle {
                            id: chargeTrack
                            anchors.left:   parent.left
                            anchors.right:  parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: 2
                            radius: 1
                            color: root.line
                        }
                        Rectangle {
                            anchors.left: chargeTrack.left
                            anchors.verticalCenter: parent.verticalCenter
                            width:  chargeTrack.width * (root._pct / 100)
                            height: 2
                            radius: 1
                            color: root._low ? root.danger : root.accent
                            Behavior on width { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    // ---- Time remaining ------------------------------
                    Text {
                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        text: root._timeLabel()
                        color: root.fg
                        visible: text.length > 0
                        font { family: root.fontFamily; pixelSize: 12; weight: Font.Normal }
                    }

                    // ---- Metrics row: draw · health ------------------
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: root._rate > 0.05
                                ? root._rate.toFixed(1) + "W " + (root._charging ? "in" : "out")
                                : "idle"
                            color: root.muted
                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Normal }
                        }
                        Text {
                            text: "·"
                            color: root.muted
                            visible: root._healthPct > 0
                            font { family: root.fontFamily; pixelSize: 11 }
                        }
                        Text {
                            text: root._healthPct + "% health"
                            color: root.muted
                            visible: root._healthPct > 0
                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Normal }
                        }
                        Item { Layout.fillWidth: true }
                    }

                    // ---- Divider -------------------------------------
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.topMargin: 8
                        Layout.bottomMargin: 2
                        height: 1
                        color: root.line
                    }

                    // ---- Profile section header ----------------------
                    Text {
                        Layout.fillWidth: true
                        text: "POWER PROFILE"
                        color: root.muted
                        font {
                            family: root.fontFamily
                            pixelSize: 10
                            weight: Font.Bold
                            capitalization: Font.AllUppercase
                            letterSpacing: 1.0
                        }
                    }

                    // ---- Profile selector row ------------------------
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 2
                        spacing: 20

                        ProfileBtn {
                            label:  "Quiet"
                            active: root.currentProfile === "Quiet"
                            onActivated: root.setProfile("Quiet")
                        }
                        ProfileBtn {
                            label:  "Balanced"
                            active: root.currentProfile === "Balanced"
                            onActivated: root.setProfile("Balanced")
                        }
                        ProfileBtn {
                            label:  "Performance"
                            active: root.currentProfile === "Performance"
                            onActivated: root.setProfile("Performance")
                        }
                        Item { Layout.fillWidth: true }
                    }
                }
            }

            // ---- Reusable text-only profile button --------------------
            component ProfileBtn: Item {
                id: pb
                property string label
                property bool active: false
                property bool hover: false
                signal activated()

                Layout.preferredWidth:  pbLbl.implicitWidth
                Layout.preferredHeight: pbLbl.implicitHeight + 4
                implicitWidth:  pbLbl.implicitWidth
                implicitHeight: pbLbl.implicitHeight + 4

                Text {
                    id: pbLbl
                    anchors.centerIn: parent
                    text: pb.label
                    color: pb.active ? root.accent
                         : pb.hover  ? root.accent
                         :             root.muted
                    font {
                        family: root.fontFamily
                        pixelSize: 11
                        weight: pb.active ? Font.Black : Font.Bold
                        capitalization: Font.AllUppercase
                        letterSpacing: 0.8
                    }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Underline dot for the active profile.
                Rectangle {
                    width: 4; height: 4; radius: 2
                    color: root.accent
                    anchors.top: pbLbl.bottom
                    anchors.topMargin: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: pb.active
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: pb.hover = true
                    onExited:  pb.hover = false
                    onClicked: pb.activated()
                }
            }
        }
    }
}
