// Native Quickshell OSD — replaces swayosd.
// Triggered exclusively via IPC (`qs ipc call osd volume|mic|brightness`)
// from sway keybindings so we never fire on background/programmatic changes.
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire
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
    required property string fontFamily

    // ---- config ---------------------------------------------------------
    property int hideAfterMs: 1500
    property int cardWidth:   260
    property int cardHeight:   60
    property int bottomOffset: 90     // gap from screen bottom

    // ---- active OSD state -----------------------------------------------
    property string kind: ""          // "volume" | "mic" | "brightness"
    property real   value: 0          // 0..1
    property bool   isMuted: false
    property string icon: ""
    property bool   showing: false

    // Auto-hide timer — restarts on every show()
    Timer {
        id: hideTimer
        interval: root.hideAfterMs
        repeat: false
        onTriggered: root.showing = false
    }

    // Keep-alive so PanelWindow stays mounted through the fade-out.
    property bool _alive: false
    onShowingChanged: {
        if (showing) { _closeTimer.stop(); _alive = true }
        else if (_alive) _closeTimer.restart()
    }
    Timer { id: _closeTimer; interval: 260; repeat: false; onTriggered: root._alive = false }

    // ---- keep PW nodes alive so their audio subobjects fire signals ----
    PwObjectTracker {
        objects: {
            const o = []
            if (Pipewire.defaultAudioSink)   o.push(Pipewire.defaultAudioSink)
            if (Pipewire.defaultAudioSource) o.push(Pipewire.defaultAudioSource)
            return o
        }
    }

    // ---- icon helpers ---------------------------------------------------
    function _volIcon(vol, muted) {
        if (muted) return "\u{F075F}"       // md-volume-off
        if (vol > 0.66) return "\u{F057E}"  // md-volume-high
        if (vol > 0.33) return "\u{F0580}"  // md-volume-medium
        if (vol > 0.001) return "\u{F057F}" // md-volume-low
        return "\u{F075F}"                  // md-volume-off (0)
    }
    function _micIcon(muted) {
        return muted ? "\u{F036D}" : "\u{F036C}"  // md-microphone-off / md-microphone
    }
    function _brtIcon(pct) {
        if (pct > 0.66) return "\u{F00DE}"  // md-brightness-7
        if (pct > 0.33) return "\u{F00DC}"  // md-brightness-5
        return "\u{F00DB}"                  // md-brightness-4
    }

    // ---- generic show helper -------------------------------------------
    function _show(k, v, m, ic) {
        root.kind    = k
        root.value   = Math.max(0, Math.min(1, v))
        root.isMuted = m
        root.icon    = ic
        root.showing = true
        hideTimer.restart()
    }

    // ---- per-kind reads --------------------------------------------------
    function showVolume() {
        const s = Pipewire.defaultAudioSink
        if (!s || !s.audio) return
        _show("volume", s.audio.volume, s.audio.muted, _volIcon(s.audio.volume, s.audio.muted))
    }
    function showMic() {
        const s = Pipewire.defaultAudioSource
        if (!s || !s.audio) return
        _show("mic", 1, s.audio.muted, _micIcon(s.audio.muted))
    }

    // ---- brightness read (via brightnessctl) ---------------------------
    Process {
        id: brightProc
        running: false
        command: ["sh", "-c",
            "brightnessctl -m 2>/dev/null | " +
            "awk -F, 'NR==1 {gsub(/%/,\"\",$4); print $4/100}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseFloat(text.trim())
                if (isNaN(v)) return
                root._show("brightness", v, false, root._brtIcon(v))
            }
        }
    }
    function showBrightness() { brightProc.running = true }

    // ---- IPC (called from sway keybindings) ----------------------------
    // `qs ipc call osd volume | mic | brightness`
    IpcHandler {
        target: "osd"
        function volume():     void { root.showVolume() }
        function mic():        void { root.showMic() }
        function brightness(): void { root.showBrightness() }
    }

    // =========================================================================
    // Overlay panel — one per screen, centered near the bottom.
    // =========================================================================
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-osd"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { left: true; right: true; bottom: true }
            margins { bottom: root.bottomOffset }
            color: "transparent"
            implicitHeight: root.cardHeight + 8
            visible: root._alive

            Rectangle {
                id: card
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width:  root.cardWidth
                height: root.cardHeight
                color:  root.bg
                border { color: root.line; width: 1 }
                radius: 4
                transformOrigin: Item.Center

                // Fade + subtle pop on show; fade on hide.
                opacity: root.showing ? 1.0 : 0.0
                scale:   root.showing ? 1.0 : 0.92
                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on scale   {
                    NumberAnimation { duration: 200; easing.type: Easing.OutBack; easing.overshoot: 1.15 }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    // ---- Icon (MDI glyph) ---------------------------
                    Text {
                        Layout.alignment: Qt.AlignVCenter
                        text: root.icon
                        color: root.isMuted ? root.muted : root.fg
                        font { family: root.fontFamily; pixelSize: 22; weight: Font.Bold }
                        Behavior on color { ColorAnimation { duration: 180 } }
                    }

                    // ---- Label + slider ------------------------------
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 6

                        Text {
                            Layout.fillWidth: true
                            text: {
                                if (root.kind === "mic")
                                    return root.isMuted ? "MIC MUTED" : "MIC ON"
                                if (root.kind === "brightness")
                                    return "BRIGHTNESS  " + Math.round(root.value * 100) + "%"
                                if (root.kind === "volume")
                                    return root.isMuted
                                        ? "MUTED"
                                        : "VOLUME  " + Math.round(root.value * 100) + "%"
                                return ""
                            }
                            color: root.fg
                            font {
                                family: root.fontFamily
                                pixelSize: 10
                                weight: Font.Bold
                                capitalization: Font.AllUppercase
                                letterSpacing: 0.9
                            }
                        }

                        // Ultra-thin slider (3px)
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 4

                            Rectangle {
                                id: track
                                anchors.left:  parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                height: 3
                                radius: 1.5
                                color: "#27272A"
                            }
                            Rectangle {
                                anchors.left: track.left
                                anchors.verticalCenter: parent.verticalCenter
                                width:  track.width * (root.isMuted ? 0 : root.value)
                                height: 3
                                radius: 1.5
                                color:  root.isMuted ? root.muted : root.accent
                                Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                                Behavior on color { ColorAnimation  { duration: 200 } }
                            }
                        }
                    }
                }
            }
        }
    }
}
