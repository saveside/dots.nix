//@ pragma UseQApplication

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.I3
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // ---- palette ---------------------------------------------------------
    readonly property color bg:        "#000000"
    readonly property color chip:      "#0a0a0a"
    readonly property color chipHover: "#161616"
    readonly property color chipOn:    "#1e1e22"
    readonly property color fg:        "#A0A0A0"   // primary text (muted silver)
    readonly property color muted:     "#333333"   // inactive text (deep charcoal)
    readonly property color line:      "#1f1f22"
    readonly property color accent:    "#FFFFFF"   // stark white — toggled/active
    readonly property color warn:      "#666666"   // mid gray — battery low (blinks)
    readonly property color danger:    "#e46876"

    readonly property string fontFamily: "SFPro Nerd Font"

    // ---- state -----------------------------------------------------------
    property bool idleInhibited: false
    property bool vpnConnected:  false
    property string vpnLocation: ""

    property string netLabel: ""
    property string netIcon:  "\u{F0C9B}"   // md-network-off (default)

    // ---- notifications ---------------------------------------------------
    // IPC-driven state (super+k / DND toggle in center / bar chip).
    property bool notifOpen: false
    property bool dnd:       false

    // ---- mpris flyout ---------------------------------------------------
    property bool mprisOpen: false
    // Short-lived toast queue. Each entry = { n: Notification, expiresAt: ms }.
    property var activeToasts: []
    function removeToast(target) {
        root.activeToasts = root.activeToasts.filter(t => t && t.n && t.n !== target)
    }

    NotificationServer {
        id: notifServer
        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: true
        persistenceSupported: true
        onNotification: n => {
            if (root.dnd) { n.dismiss(); return }
            n.tracked = true
            const to = (n.expireTimeout && n.expireTimeout > 0) ? n.expireTimeout : 5000
            root.activeToasts = root.activeToasts.concat([{ n: n, expiresAt: Date.now() + to }])
        }
    }
    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            const now = Date.now()
            const kept = root.activeToasts.filter(t => t && t.n && t.expiresAt > now)
            if (kept.length !== root.activeToasts.length) root.activeToasts = kept
        }
    }

    // IPC: `qs ipc call notif toggle | open | close | toggleDnd | dismissAll`
    IpcHandler {
        target: "notif"
        function toggle():     void { root.notifOpen = !root.notifOpen }
        function open():       void { root.notifOpen = true }
        function close():      void { root.notifOpen = false }
        function toggleDnd():  void { root.dnd = !root.dnd }
        function dismissAll(): void {
            for (const n of notifServer.trackedNotifications.values.slice()) n.dismiss()
        }
    }

    // ---- ivpn poller -----------------------------------------------------
    Process {
        id: ivpnProc
        running: true
        command: ["sh", "-c",
            "if ivpn status 2>/dev/null | grep -q ' : CONNECTED'; then " +
            "  loc=$(ivpn status | awk -F', ' 'NR==2 {print $2 \", \" $3}'); " +
            "  echo \"UP\t$loc\"; " +
            "else echo 'DOWN'; fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim()
                root.vpnConnected = line.startsWith("UP")
                root.vpnLocation = root.vpnConnected ? line.substring(3).trim() : ""
            }
        }
    }
    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered: ivpnProc.running = true
    }

    // ---- network poller (nmcli) ------------------------------------------
    Process {
        id: netProc
        running: true
        command: ["sh", "-c",
            "nmcli -t -f DEVICE,STATE,CONNECTION,TYPE device status 2>/dev/null | " +
            "awk -F: '$2==\"connected\" && $4!=\"loopback\" {print $4\"\\t\"$3; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim()
                if (!line) { root.netLabel = ""; root.netIcon = "\u{F0C9B}"; return }
                const [kind, name] = line.split("\t")
                root.netLabel = name || ""
                if (kind === "wifi" || kind === "wireless")     root.netIcon = ""  // wifi
                else if (kind === "ethernet" || kind === "tun") root.netIcon = "󰈀"  // ethernet
                else                                            root.netIcon = "󰇨"  // globe/off
            }
        }
    }
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: netProc.running = true
    }

    // ---- idle inhibit (systemd-inhibit) ----------------------------------
    Process {
        id: inhibitProc
        running: root.idleInhibited
        command: ["systemd-inhibit", "--what=idle:sleep", "--who=quickshell",
                  "--why=user-toggled", "--mode=block", "sleep", "infinity"]
    }

    // ---- audio tracker ---------------------------------------------------
    PwObjectTracker { objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : [] }

    // ---- system clock ----------------------------------------------------
    SystemClock { id: clock; precision: SystemClock.Minutes }

    // ---- one bar per screen ----------------------------------------------
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-bar"

            anchors { top: true; left: true; right: true }
            implicitHeight: 34
            color: root.bg


            // ---- layout --------------------------------------------------
            // Anchor-positioned so the title is truly centered on the bar,
            // not centered between left and right groups (which are unequal).
            Item {
                anchors.fill: parent

                Row {
                    id: leftRow
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 20
                    Workspaces { }
                    MprisChip { }
                }

                Text {
                    id: titleText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(
                        implicitWidth,
                        parent.width - 2 * Math.max(leftRow.width, rightRow.width) - 24)
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideMiddle
                    color: root.fg
                    font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                    text: {
                        const t = ToplevelManager.activeToplevel
                        return t && t.title ? t.title : ""
                    }
                }

                Row {
                    id: rightRow
                    anchors.right: parent.right
                    anchors.rightMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 16

                    Chip { props: idleInhibitorC }
                    Chip { props: vpnC }
                    Chip { props: soundC }
                    Chip { props: networkC }
                    Chip { props: dateC }
                    Chip { props: batteryC }
                    Chip { props: notifC }
                    SystemTrayChip { }
                }
            }

            // ---- workspaces (sway = i3ipc) -------------------------------
            // Bare text with an accent-color animated underline for focused.
            component Workspaces: Row {
                spacing: 16
                Repeater {
                    model: I3.workspaces
                    delegate: Item {
                        required property I3Workspace modelData
                        readonly property bool focused: modelData.focused
                        readonly property bool urgent:  modelData.urgent

                        implicitWidth: Math.max(wsLabel.implicitWidth, 8)
                        implicitHeight: 20

                        Text {
                            id: wsLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            color: urgent                ? root.danger
                                 : focused               ? root.accent
                                 : wsMouse.containsMouse ? root.accent
                                 :                         "#6A6A6A"   // brighter than palette muted for legibility
                            font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                            Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                        }

                        Rectangle {
                            id: wsUnderline
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -2
                            width: focused ? Math.max(wsLabel.implicitWidth, 6) : 0
                            height: 2
                            radius: 1
                            color: urgent ? root.danger : root.accent
                            Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                        }

                        MouseArea {
                            id: wsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.activate()
                        }
                    }
                }
            }

            // ---- shared chip component -----------------------------------
            // Bare text, no box. Tone drives color; hover fades muted -> fg.
            // `props` = QtObject { icon, text, tone, onClick, onClickRight }
            component Chip: Item {
                id: c
                required property var props
                property bool hover: false
                readonly property bool blink: props.tone === "warn" || props.tone === "danger"

                implicitHeight: 20
                implicitWidth: chipRow.implicitWidth

                // Default = primary silver; hover fades to white. On/warn/
                // danger override with their palette color.
                readonly property color activeColor:
                    props.tone === "on"     ? root.accent
                  : props.tone === "warn"   ? root.warn
                  : props.tone === "danger" ? root.danger
                  : hover                    ? root.accent
                  :                            root.fg

                Row {
                    id: chipRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    property real blinkAlpha: 1.0
                    opacity: c.blink ? blinkAlpha : 1.0
                    SequentialAnimation on blinkAlpha {
                        running: c.blink
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.30; duration: 700; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0;  duration: 700; easing.type: Easing.InOutSine }
                    }
                    Text {
                        text: c.props.icon || ""
                        color: c.activeColor
                        font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                        visible: text.length > 0
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    }
                    Text {
                        text: c.props.text || ""
                        color: c.activeColor
                        font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                        visible: text.length > 0
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onEntered: c.hover = true
                    onExited:  c.hover = false
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton && c.props.onClickRight)
                            c.props.onClickRight()
                        else if (c.props.onClick)
                            c.props.onClick()
                    }
                }
            }

            // ---- module property bags -----------------------------------
            // All MDI codepoints; SFPro Nerd Font renders them via the
            // Material Design set. Written as \u{XXXXX} escapes.
            QtObject {
                id: idleInhibitorC
                readonly property string icon: root.idleInhibited
                    ? "\u{F0176}"   // md-coffee
                    : "\u{F0FAA}"   // md-power-sleep
                readonly property string text: ""
                readonly property string tone: root.idleInhibited ? "on" : "normal"
                property var onClick: () => root.idleInhibited = !root.idleInhibited
                property var onClickRight: null
            }

            QtObject {
                id: soundC
                readonly property var sink: Pipewire.defaultAudioSink
                readonly property real vol: sink && sink.audio ? sink.audio.volume : 0
                readonly property bool muted: !sink || !sink.audio || sink.audio.muted
                readonly property string icon: muted        ? "\u{F075F}"   // volume-off
                                              : vol > 0.66  ? "\u{F057E}"   // volume-high
                                              :               "\u{F0580}"   // volume-medium
                readonly property string text: muted ? "muted" : Math.round(vol * 100) + "%"
                readonly property string tone: muted ? "on" : "normal"
                property var onClick: () => Quickshell.execDetached(["pavucontrol"])
                property var onClickRight: () => {
                    if (sink && sink.audio) sink.audio.muted = !sink.audio.muted
                }
            }

            QtObject {
                id: batteryC
                readonly property var dev: {
                    const list = UPower.devices ? UPower.devices.values : []
                    for (const d of list) {
                        if (d && d.nativePath && d.nativePath.indexOf("battery_") === 0)
                            return d
                    }
                    return UPower.displayDevice
                }
                readonly property bool ok: dev && dev.isPresent
                readonly property int pct: ok ? Math.round(dev.percentage * 100) : 0
                readonly property bool charging: ok && (
                    dev.state === UPowerDeviceState.Charging ||
                    dev.state === UPowerDeviceState.FullyCharged)
                readonly property string icon: !ok ? "\u{F008E}"   // battery-outline (unknown)
                    : charging   ? "\u{F0084}"   // battery-charging
                    : pct <= 10  ? "\u{F0083}"   // battery-alert
                    : pct <= 20  ? "\u{F007B}"   // battery-20
                    : pct <= 40  ? "\u{F007D}"   // battery-40
                    : pct <= 60  ? "\u{F007F}"   // battery-60
                    : pct <= 80  ? "\u{F0081}"   // battery-80
                    :              "\u{F0079}"   // battery (full)
                readonly property string text: ok ? pct + "%" : "—"
                readonly property string tone:
                    !ok            ? "normal"
                    : charging     ? "on"
                    : pct <= 15    ? "danger"
                    : pct <= 30    ? "warn"
                    :                "normal"
                property var onClick: null
                property var onClickRight: null
            }

            QtObject {
                id: vpnC
                readonly property string icon: root.vpnConnected
                    ? ""   // shield-check
                    : ""   // shield-off-outline
                readonly property string text: root.vpnConnected ? (root.vpnLocation || "vpn") : "off"
                readonly property string tone: root.vpnConnected ? "on" : "normal"
                property var onClick: () => Quickshell.execDetached(
                    root.vpnConnected ? ["ivpn", "disconnect"] : ["ivpn", "connect", "-f"])
                property var onClickRight: () => ivpnProc.running = true
            }

            QtObject {
                id: networkC
                readonly property string icon: root.netIcon
                readonly property string text: root.netLabel
                readonly property string tone: "normal"
                property var onClick: () => Quickshell.execDetached(
                    ["sh", "-c",
                     "wl-copy $(ip -o -4 addr show scope global | awk '{print $4}' | cut -d/ -f1 | head -n1)"])
                property var onClickRight: null
            }

            QtObject {
                id: dateC
                readonly property string icon: "\u{F00ED}"   // md-calendar-today
                readonly property string text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm")
                readonly property string tone: "normal"
                property var onClick: null
                property var onClickRight: null
            }

            QtObject {
                id: notifC
                readonly property int count: notifServer.trackedNotifications.values.length
                readonly property string icon: root.dnd
                    ? "\u{F009B}"   // md-bell-off
                    : "\u{F009A}"   // md-bell
                readonly property string text: count > 0 ? String(count) : ""
                readonly property string tone: (root.dnd || count > 0) ? "on" : "normal"
                property var onClick:      () => root.notifOpen = !root.notifOpen
                property var onClickRight: () => root.dnd = !root.dnd
            }
            // ---- collapsible system tray --------------------------------
            component SystemTrayChip: Item {
                id: tray
                property bool expanded: false

                implicitHeight: 20
                implicitWidth: trayRow.implicitWidth
                Behavior on implicitWidth { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    onEntered: tray.expanded = true
                    onExited:  tray.expanded = false
                }

                Row {
                    id: trayRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Text {
                        text: tray.expanded ? "\u{203A}" : "\u{2039}"   // › / ‹
                        color: hoverArea.containsMouse ? root.accent : "#8A8A8A"   // brighter than palette muted
                        font { family: root.fontFamily; pixelSize: 15; weight: Font.Bold }
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 180 } }
                    }

                    Row {
                        spacing: 10
                        visible: tray.expanded
                        opacity: tray.expanded ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                        Repeater {
                            model: SystemTray.items
                            delegate: Item {
                                required property SystemTrayItem modelData
                                implicitWidth: 18; implicitHeight: 18
                                anchors.verticalCenter: parent.verticalCenter
                                Image {
                                    anchors.fill: parent
                                    source: modelData.icon
                                    smooth: true
                                    fillMode: Image.PreserveAspectFit
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: mouse => {
                                        if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                            modelData.display(bar, mouse.x, mouse.y)
                                        } else {
                                            modelData.activate()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ---- mpris (music player) -----------------------------------
            component MprisChip: Item {
                id: m
                readonly property var player: {
                    const list = Mpris.players ? Mpris.players.values : []
                    for (const p of list) {
                        if (p && (p.canControl === undefined || p.canControl)) return p
                    }
                    return null
                }
                readonly property string _title:   player && player.trackTitle ? player.trackTitle : ""
                readonly property string _artists: {
                    if (!player) return ""
                    const a = player.trackArtists
                    if (Array.isArray(a)) return a.join(", ")
                    return a || ""
                }
                readonly property bool _playing: player && (player.isPlaying === true
                    || (player.playbackState !== undefined && player.playbackState === MprisPlaybackState.Playing))

                visible: player !== null && (_title.length > 0 || _artists.length > 0)
                implicitHeight: 20
                implicitWidth: mprisRow.implicitWidth

                Row {
                    id: mprisRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Text {
                        text: m._playing ? "\u{F03E4}" : "\u{F040A}"   // md-pause / md-play
                        color: root.accent
                        font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: m._artists ? (m._artists + "  —  " + m._title) : m._title
                        color: root.accent
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, 260)
                        font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: mMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => {
                        if (!m.player) return
                        if (mouse.button === Qt.RightButton) {
                            if (m.player.next) m.player.next()
                        } else if (mouse.button === Qt.MiddleButton) {
                            if (m.player.togglePlaying) m.player.togglePlaying()
                        } else {
                            // Left click = open the full flyout.
                            root.mprisOpen = !root.mprisOpen
                        }
                    }
                }
            }
        }
    }

    // ---- toast popups (one panel per screen, overlay, non-exclusive) ----
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: toastWin
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-toasts"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            anchors { top: true; right: true }
            margins { top: 40; right: 12 }
            color: "transparent"
            implicitWidth: 380
            implicitHeight: Math.max(1, toastCol.implicitHeight + 4)
            // Suppress toasts while the notification center is open — the
            // same entry already renders in the shade list.
            visible: root.activeToasts.length > 0 && !root.notifOpen

            Column {
                id: toastCol
                width: parent.width
                spacing: 8

                Repeater {
                    model: root.activeToasts
                    delegate: Rectangle {
                        id: toastCard
                        required property var modelData
                        readonly property var n: modelData ? modelData.n : null
                        width: parent.width
                        implicitHeight: Math.max(60, tLayout.implicitHeight + 20)
                        color: root.chip
                        border { color: root.line; width: 1 }
                        visible: n !== null
                        opacity: 0
                        Component.onCompleted: opacity = 1
                        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                        RowLayout {
                            id: tLayout
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            Item {
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                Layout.alignment: Qt.AlignTop
                                visible: tImg.status === Image.Ready && tImg.source != ""
                                Image {
                                    id: tImg
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    sourceSize.width: 32
                                    sourceSize.height: 32
                                    source: {
                                        const nn = toastCard.n
                                        if (!nn) return ""
                                        if (nn.image) return nn.image
                                        const a = nn.appIcon || ""
                                        if (!a) return ""
                                        if (a.charAt(0) === "/" || a.indexOf("file:") === 0) return a
                                        return Quickshell.iconPath(a, true)
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    Text {
                                        Layout.fillWidth: true
                                        text: toastCard.n
                                            ? (toastCard.n.summary || toastCard.n.appName || "")
                                            : ""
                                        color: root.accent
                                        font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        text: "×"
                                        color: closeMa.containsMouse ? root.accent : root.fg
                                        font { family: root.fontFamily; pixelSize: 16; weight: Font.Bold }
                                        Behavior on color { ColorAnimation { duration: 150 } }
                                        MouseArea {
                                            id: closeMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (toastCard.n) root.removeToast(toastCard.n)
                                            }
                                        }
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: toastCard.n && toastCard.n.body ? toastCard.n.body : ""
                                    color: root.fg
                                    font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                    wrapMode: Text.WordWrap
                                    textFormat: Text.RichText
                                    visible: text.length > 0
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    visible: toastCard.n && toastCard.n.actions && toastCard.n.actions.length > 0
                                    Repeater {
                                        model: toastCard.n ? toastCard.n.actions : []
                                        delegate: Rectangle {
                                            required property var modelData
                                            property bool hover: false
                                            implicitHeight: 22
                                            implicitWidth: aLbl2.implicitWidth + 14
                                            color: hover ? root.chipHover : root.chipOn
                                            border { color: root.line; width: 1 }
                                            radius: 2
                                            Text {
                                                id: aLbl2
                                                anchors.centerIn: parent
                                                text: modelData.text || modelData.identifier || "action"
                                                color: hover ? root.accent : root.fg
                                                font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onEntered: parent.hover = true
                                                onExited:  parent.hover = false
                                                onClicked: {
                                                    modelData.invoke()
                                                    if (toastCard.n) root.removeToast(toastCard.n)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ---- notification center: fullscreen click-catch overlay ----------
    // Overlay layer + top-margin so it sits below the bar; background
    // MouseArea closes on any outside click. Popup box is anchored to
    // the top-right; child interactions bubble through inner MouseAreas.
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: notifShade
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-notif-shade"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 34 }   // clear the bar so bar chips remain clickable
            color: "transparent"
            visible: root.notifOpen

            // Background dismiss
            MouseArea {
                anchors.fill: parent
                onClicked: root.notifOpen = false
            }

            // Popup box anchored top-right
            Rectangle {
                id: notifBox
                x: parent.width - width - 12
                y: 6
                width: 380
                height: Math.min(parent.height - 20, 100 + notifCol.implicitHeight)
                color: root.chip
                border { color: root.line; width: 1 }
                MouseArea { anchors.fill: parent; onClicked: {} }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Text {
                                Layout.fillWidth: true
                                text: "Notifications"
                                color: root.accent
                                font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                            }
                            // DND toggle button — clearly framed so it's easy to spot.
                            Rectangle {
                                id: dndBtn
                                property bool hover: false
                                implicitHeight: 24
                                implicitWidth: dndLbl.implicitWidth + 18
                                color: root.dnd
                                    ? root.accent
                                    : (hover ? root.chipHover : root.chipOn)
                                border { color: root.dnd ? root.accent : root.line; width: 1 }
                                radius: 3
                                Behavior on color { ColorAnimation { duration: 150 } }
                                Text {
                                    id: dndLbl
                                    anchors.centerIn: parent
                                    text: root.dnd ? "DND ON" : "DND"
                                    color: root.dnd ? root.bg : root.fg
                                    font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: parent.hover = true
                                    onExited:  parent.hover = false
                                    onClicked: root.dnd = !root.dnd
                                }
                            }
                            Text {
                                text: "clear"
                                color: root.fg
                                font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: parent.color = root.accent
                                    onExited:  parent.color = root.fg
                                    onClicked: {
                                        for (const n of notifServer.trackedNotifications.values.slice())
                                            n.dismiss()
                                    }
                                }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: root.line }

                        ColumnLayout {
                            id: notifCol
                            Layout.fillWidth: true
                            spacing: 6

                            Repeater {
                                model: notifServer.trackedNotifications
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    implicitHeight: Math.max(60, nCol.implicitHeight + 20)
                                    color: root.chip
                                    border { color: root.line; width: 1 }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 10

                                        Item {
                                            Layout.preferredWidth: 32
                                            Layout.preferredHeight: 32
                                            Layout.alignment: Qt.AlignTop
                                            visible: iconImg.status === Image.Ready && iconImg.source != ""
                                            Image {
                                                id: iconImg
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit
                                                smooth: true
                                                sourceSize.width: 32
                                                sourceSize.height: 32
                                                source: {
                                                    const md = parent.parent.parent.modelData
                                                    if (md.image) return md.image
                                                    const a = md.appIcon || ""
                                                    if (!a) return ""
                                                    if (a.charAt(0) === "/" || a.indexOf("file:") === 0) return a
                                                    return Quickshell.iconPath(a, true)
                                                }
                                            }
                                        }

                                    ColumnLayout {
                                        id: nCol
                                        Layout.fillWidth: true
                                        spacing: 6

                                        RowLayout {
                                            Layout.fillWidth: true
                                            spacing: 6
                                            Text {
                                                Layout.fillWidth: true
                                                text: modelData.summary || modelData.appName || ""
                                                color: root.accent
                                                font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: "×"
                                                color: root.fg
                                                font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                                                MouseArea {
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onEntered: parent.color = root.accent
                                                    onExited:  parent.color = root.fg
                                                    onClicked: modelData.dismiss()
                                                }
                                            }
                                        }
                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.body || ""
                                            color: root.fg
                                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                            wrapMode: Text.WordWrap
                                            textFormat: Text.RichText
                                            visible: text.length > 0
                                        }
                                        // Action buttons — freedesktop notification actions.
                                        RowLayout {
                                            Layout.fillWidth: true
                                            spacing: 6
                                            visible: modelData.actions && modelData.actions.length > 0
                                            Repeater {
                                                model: modelData.actions
                                                delegate: Rectangle {
                                                    required property var modelData
                                                    property bool hover: false
                                                    implicitHeight: 22
                                                    implicitWidth: aLabel.implicitWidth + 14
                                                    color: hover ? root.chipHover : root.chipOn
                                                    border { color: root.line; width: 1 }
                                                    Text {
                                                        id: aLabel
                                                        anchors.centerIn: parent
                                                        text: modelData.text || modelData.identifier || "action"
                                                        color: hover ? root.accent : root.fg
                                                        font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                                    }
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onEntered: parent.hover = true
                                                        onExited:  parent.hover = false
                                                        onClicked: modelData.invoke()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    }
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "no notifications"
                                color: root.muted
                                font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                                visible: notifServer.trackedNotifications.values.length === 0
                                Layout.margins: 12
                            }
                        }
                    }
                }
        }
    }

    // ---- mpris flyout (self-contained, one per screen) -----------------
    MprisFlyout {
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        fontFamily: root.fontFamily
        open:       root.mprisOpen
        onCloseRequested: root.mprisOpen = false
    }
}
