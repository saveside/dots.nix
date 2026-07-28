// MPRIS flyout — per-screen overlay list of every active player.
// Palette + open state are injected by the shell root so this component
// stays visually identical to the bar without importing its ids.
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
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

    // ---- open/close state ------------------------------------------------
    required property bool open
    signal closeRequested()

    // ---- geometry --------------------------------------------------------
    property int flyoutWidth: 460
    property int leftOffset:  12     // approx x of MprisChip in the bar
    property int topOffset:   0      // flush against the bar

    // ---- helpers ---------------------------------------------------------
    function fmtTime(sec) {
        if (!sec || sec < 0 || !isFinite(sec)) return "0:00"
        const s = Math.floor(sec % 60)
        const m = Math.floor((sec / 60) % 60)
        const h = Math.floor(sec / 3600)
        const pad = n => (n < 10 ? "0" + n : "" + n)
        if (h > 0) return h + ":" + pad(m) + ":" + pad(s)
        return m + ":" + pad(s)
    }

    // Reactive list of players — falls back to [] before Mpris is ready.
    readonly property var _players: (Mpris.players ? Mpris.players.values : [])

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: flyout
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-mpris"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 34 }        // clear the bar
            color: "transparent"
            visible: root.open

            // Click-outside dismiss
            MouseArea {
                anchors.fill: parent
                onClicked: root.closeRequested()
            }

            // ---- flyout body: pure black, no border, no per-module boxes -
            Rectangle {
                id: box
                x: root.leftOffset
                y: root.topOffset
                width: root.flyoutWidth
                height: Math.max(inner.implicitHeight + 20, 56)
                color: root.bg
                border { color: root.line; width: 1 }
                radius: 4
                // Eat clicks so they don't fall through to the dismiss layer
                MouseArea { anchors.fill: parent; onClicked: {} }

                // Empty state
                Text {
                    anchors.centerIn: parent
                    visible: root._players.length === 0
                    text: "no media"
                    color: root.fg
                    font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                }

                ColumnLayout {
                    id: inner
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 14
                    visible: root._players.length > 0

                    Repeater {
                        model: Mpris.players
                        delegate: PlayerCard {
                            required property MprisPlayer modelData
                            required property int index
                            Layout.fillWidth: true
                            player:      modelData
                            showDivider: index < root._players.length - 1
                        }
                    }
                }
            }

            // =============================================================
            // Reusable component: one card per active player.
            // Layout per card:
            //   [art] Title                              [⏮ ⏯ ⏭]
            //         Artist
            //         Identity (Firefox / mpv / …)
            //   [🕐] ─────── position ───────  1:23 / 3:45
            //   [🔊] ─────── volume  ───────
            //   ─────────── faint separator ───────────
            // =============================================================
            component PlayerCard: ColumnLayout {
                id: card
                property MprisPlayer player: null
                property bool showDivider: false
                spacing: 10

                // ---- derived state --------------------------------------
                readonly property string _title:
                    player && player.trackTitle ? player.trackTitle : "unknown"
                readonly property string _artists: {
                    if (!player) return ""
                    const a = player.trackArtists
                    if (Array.isArray(a)) return a.join(", ")
                    return a || ""
                }
                readonly property string _artUrl: {
                    if (!player || !player.trackArtUrl) return ""
                    const u = player.trackArtUrl
                    // Some players emit a bare filesystem path — turn it
                    // into a valid file:// URI so Qt's Image can load it.
                    if (u.indexOf("://") > 0) return u
                    if (u.charAt(0) === "/")  return "file://" + u
                    return u
                }
                readonly property bool _playing: player && (
                    player.isPlaying === true
                    || (player.playbackState !== undefined
                        && player.playbackState === MprisPlaybackState.Playing))

                // Local ticker — most MPRIS players don't push position
                // updates every second, so we nudge the binding while open
                // and playing (and paused while the user is scrubbing).
                property int _tick: 0
                Timer {
                    interval: 500
                    running: root.open && card._playing && !posSlider.dragging
                    repeat: true
                    onTriggered: card._tick = card._tick + 1
                }
                readonly property real _pos: {
                    _tick   // force re-eval each tick
                    return (player && isFinite(player.position)) ? player.position : 0
                }
                readonly property real _len:
                    (player && isFinite(player.length) && player.length > 0) ? player.length : 0
                readonly property bool _canSeek:
                    !!player && player.canSeek === true && _len > 0

                readonly property bool _canVolPlayer:
                    !!player && player.canSetVolume === true
                readonly property real _vol: {
                    if (_canVolPlayer) return player.volume || 0
                    const s = Pipewire.defaultAudioSink
                    return (s && s.audio) ? s.audio.volume : 0
                }

                // ---- ROW 1: art + text + transport controls -------------
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        id: artFrame
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 56
                        radius: 6
                        clip: true
                        color: root.line          // dark tint under any fallback

                        // Primary: MPRIS-provided cover.
                        Image {
                            id: coverImg
                            anchors.fill: parent
                            source: card._artUrl
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            asynchronous: true
                            cache: false          // never cache a failed load
                            sourceSize.width:  112
                            sourceSize.height: 112
                            visible: status === Image.Ready
                        }

                        // Retry once ~700ms after Error — covers the Firefox
                        // "URL announced before temp file is flushed" case.
                        Timer {
                            interval: 700
                            repeat: false
                            running: coverImg.status === Image.Error && card._artUrl.length > 0
                            onTriggered: {
                                const s = coverImg.source
                                coverImg.source = ""
                                coverImg.source = s
                            }
                        }

                        // Fallback layer: player's app icon, else a glyph.
                        Item {
                            anchors.fill: parent
                            visible: coverImg.status !== Image.Ready
                            Image {
                                id: appIcon
                                anchors.centerIn: parent
                                width:  parent.width  * 0.55
                                height: parent.height * 0.55
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                asynchronous: true
                                visible: status === Image.Ready
                                source: card.player && card.player.desktopEntry
                                    ? Quickshell.iconPath(card.player.desktopEntry, true)
                                    : ""
                            }
                            Text {
                                anchors.centerIn: parent
                                visible: appIcon.status !== Image.Ready
                                text: "\u{F075A}"     // md-music
                                color: root.muted
                                font { family: root.fontFamily; pixelSize: 26; weight: Font.Bold }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3
                        Text {
                            Layout.fillWidth: true
                            text: card._title
                            color: root.accent
                            elide: Text.ElideRight
                            font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: card._artists
                            color: root.fg
                            elide: Text.ElideRight
                            visible: text.length > 0
                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Normal }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: card.player && card.player.identity ? card.player.identity : ""
                            color: root.muted
                            elide: Text.ElideRight
                            visible: text.length > 0
                            font { family: root.fontFamily; pixelSize: 10; weight: Font.Normal }
                        }
                    }

                    Row {
                        spacing: 16
                        Layout.alignment: Qt.AlignVCenter
                        IconBtn {
                            glyph: "\u{F04AE}"           // md-skip-previous
                            active: card.player && card.player.canGoPrevious === true
                            onActivated: if (card.player) card.player.previous()
                        }
                        IconBtn {
                            glyph: card._playing ? "\u{F03E4}" : "\u{F040A}"   // pause / play
                            px: 20
                            active: card.player !== null
                            onActivated: {
                                if (!card.player) return
                                if (card.player.togglePlaying) card.player.togglePlaying()
                                else if (card._playing && card.player.pause) card.player.pause()
                                else if (card.player.play) card.player.play()
                            }
                        }
                        IconBtn {
                            glyph: "\u{F04AD}"           // md-skip-next
                            active: card.player && card.player.canGoNext === true
                            onActivated: if (card.player) card.player.next()
                        }
                    }
                }

                // ---- ROW 2: position (video time) slider ----------------
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "\u{F0150}"                // md-clock-outline
                        color: root.fg
                        font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                        Layout.alignment: Qt.AlignVCenter
                    }

                    ThinSlider {
                        id: posSlider
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        value: card._len > 0
                            ? Math.max(0, Math.min(1, card._pos / card._len))
                            : 0
                        enabled: card._canSeek
                        onSeekTo: v => {
                            if (!card._canSeek || !card.player) return
                            card.player.position = v * card._len
                        }
                    }

                    Text {
                        text: root.fmtTime(card._pos) + " / " + root.fmtTime(card._len)
                        color: root.fg
                        font { family: root.fontFamily; pixelSize: 10; weight: Font.Normal }
                        Layout.alignment: Qt.AlignVCenter
                        Layout.minimumWidth: 82
                        horizontalAlignment: Text.AlignRight
                    }
                }

                // ---- ROW 3: volume slider -------------------------------
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: card._vol <= 0.001 ? "\u{F075F}"    // volume-off
                            : card._vol > 0.66   ? "\u{F057E}"    // volume-high
                            :                      "\u{F0580}"    // volume-medium
                        color: root.fg
                        font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                        Layout.alignment: Qt.AlignVCenter
                    }

                    ThinSlider {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        value: Math.max(0, Math.min(1, card._vol))
                        enabled: true
                        onSeekTo: v => {
                            if (card._canVolPlayer) {
                                card.player.volume = v
                            } else {
                                const s = Pipewire.defaultAudioSink
                                if (s && s.audio) s.audio.volume = v
                            }
                        }
                    }

                    // Spacer so the two sliders line up regardless of the
                    // time text's width.
                    Item {
                        Layout.minimumWidth: 82
                        Layout.preferredHeight: 1
                    }
                }

                // ---- faint separator (skipped after the last card) ------
                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    height: 1
                    color: root.line
                    visible: card.showDivider
                }
            }

            // ---- reusable icon-only transport button ---------------------
            component IconBtn: Item {
                id: btn
                property string glyph
                property real px: 16
                property bool active: true
                property bool hover: false
                signal activated()

                implicitWidth:  glyphText.implicitWidth  + 4
                implicitHeight: glyphText.implicitHeight + 4

                Text {
                    id: glyphText
                    anchors.centerIn: parent
                    text: btn.glyph
                    color: !btn.active ? root.muted
                         : btn.hover  ? root.accent
                         :              root.fg
                    font { family: root.fontFamily; pixelSize: btn.px; weight: Font.Bold }
                    Behavior on color { ColorAnimation { duration: 160; easing.type: Easing.OutCubic } }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: btn.active ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onEntered: btn.hover = true
                    onExited:  btn.hover = false
                    onClicked: if (btn.active) btn.activated()
                }
            }

            // ---- reusable ultra-thin slider ------------------------------
            // 2px track that fattens to 3px on hover/drag. Fill uses accent.
            // Emits seekTo(v) continuously while dragging (0..1).
            // Exposes `dragging` so consumers can pause external animations.
            component ThinSlider: Item {
                id: sl
                property real value: 0
                property bool enabled: true
                property bool dragging: false
                signal seekTo(real value)

                implicitHeight: hover || dragging ? 10 : 8
                Behavior on implicitHeight { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                property bool hover: hitbox.containsMouse

                Rectangle {
                    id: track
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: sl.hover || sl.dragging ? 3 : 2
                    radius: height / 2
                    color: root.line
                    Behavior on height { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                }
                Rectangle {
                    anchors.left: track.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: track.width * Math.max(0, Math.min(1, sl.value))
                    height: track.height
                    radius: height / 2
                    color: sl.enabled ? root.accent : root.muted
                    // Snap when dragging (no lag under the cursor), animate otherwise.
                    Behavior on width  { NumberAnimation { duration: sl.dragging ? 0 : 140
                                                          easing.type: Easing.OutCubic } }
                    Behavior on height { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                    Behavior on color  { ColorAnimation  { duration: 160; easing.type: Easing.OutCubic } }
                }

                MouseArea {
                    id: hitbox
                    anchors.fill: parent
                    // Fat vertical hitbox so the 2px line is easy to grab.
                    anchors.topMargin: -6
                    anchors.bottomMargin: -6
                    hoverEnabled: true
                    enabled: sl.enabled
                    cursorShape: sl.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onPressed: (m) => { sl.dragging = true; sl._commit(m.x) }
                    onReleased:      () => { sl.dragging = false }
                    onCanceled:      () => { sl.dragging = false }
                    onPositionChanged: (m) => { if (sl.dragging) sl._commit(m.x) }
                }

                function _commit(mx) {
                    const v = Math.max(0, Math.min(1, mx / width))
                    sl.seekTo(v)
                }
            }
        }
    }
}
