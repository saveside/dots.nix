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
    // Notification receive timestamps keyed by notification.id — feeds the
    // "5m ago" strings in the notification center. Cleared when a notif
    // is dismissed (no strict need, but keeps the object small).
    property var notifTimestamps: ({})

    // ---- mpris flyout ---------------------------------------------------
    property bool mprisOpen: false

    // ---- calendar flyout ------------------------------------------------
    property bool calendarOpen: false

    // ---- battery flyout -------------------------------------------------
    property bool batteryOpen: false

    // ---- active-capture indicators (mic / screencast) -------------------
    property bool micActive:    false
    property bool screenActive: false

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
            root.notifTimestamps[n.id] = Date.now()
            root.notifTimestamps = root.notifTimestamps   // notify bindings
            toasts.push(n)                                // hand off to Toasts.qml
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

    // ---- mic / screencast poller ----------------------------------------
    // Mic: any pactl source-output that is RUNNING, not corked, and not a
    //      *.monitor loopback of a sink.
    // Screencast: xdg-desktop-portal creates a "Stream/Output/Video" node
    //      in Pipewire while a screencast session is live.
    Process {
        id: mediaCapProc
        running: true
        command: ["sh", "-c",
            "d=$(pw-dump 2>/dev/null); " +
            // Mic: pactl (fast, well-formed) — skip corked + sink monitors.
            "m=0; pactl list source-outputs 2>/dev/null | " +
            "awk 'BEGIN{RS=\"\"} /State: RUNNING/ && !/Corked: yes/ && !/Source: .*\\.monitor/ {found=1} END{exit !found}' && m=1; " +
            // Screen: any *running* Stream/(Input|Output)/Video node.
            //   Excludes Video/Source (webcams register that permanently).
            //   Excludes idle/suspended streams left open by chat apps.
            "s=0; echo \"$d\" | jq -e 'any(.[]; (.info.state // \"\") == \"running\" and ((.info.props[\"media.class\"] // \"\") | test(\"^Stream/(Input|Output)/Video$\")))' >/dev/null 2>&1 && s=1; " +
            "echo \"$m $s\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/)
                const m = parts[0] === "1"
                const s = parts[1] === "1"
                if (m !== root.micActive || s !== root.screenActive)
                    console.log("[capture] mic=" + m + " screen=" + s + "  raw='" + text.trim() + "'")
                root.micActive    = m
                root.screenActive = s
            }
        }
    }
    Timer {
        interval: 2500; running: true; repeat: true
        onTriggered: mediaCapProc.running = true
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

                // Sleek 1px stroke sitting flush against the bar's bottom edge.
                Rectangle {
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: root.line          // faint gray, matches separators elsewhere
                }

                Row {
                    id: leftRow
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12
                    Workspaces { }
                    MprisChip { }
                    AlertChip {
                        glyph:  "\u{F036C}"                          // md-microphone
                        label:  "MIC"
                        active: root.micActive
                        onClick: () => Quickshell.execDetached(["pavucontrol", "-t", "1"])
                    }
                    AlertChip {
                        glyph:  "\u{F0F5F}"                          // md-monitor-share
                        label:  "SHARE"
                        active: root.screenActive
                        // Left-click → force-stop every active screencast.
                        //   1) systemctl stop portal-wlr — graceful SIGTERM
                        //      so portal dispatches session-Close on D-Bus
                        //      to consumers (Discord/OBS/…) *before* dying.
                        //      Without this, consumers just see frames stop
                        //      and freeze on the last frame instead of
                        //      updating their UI.
                        //   2) pw-cli destroy any lingering video stream
                        //      nodes as belt-and-suspenders.
                        //   Portal socket-activates back on next request.
                        onClick: () => Quickshell.execDetached(["sh", "-c",
                            "systemctl --user stop xdg-desktop-portal-wlr.service 2>/dev/null; " +
                            "pw-dump 2>/dev/null | " +
                            "jq -r '.[] | select((.info.state // \"\") == \"running\") | " +
                                     "select((.info.props[\"media.class\"] // \"\") | " +
                                     "test(\"^Stream/(Input|Output)/Video$\")) | .id' | " +
                            "xargs -r -n1 pw-cli destroy 2>/dev/null; " +
                            "true"])
                        onClickRight: null
                    }
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
                    // Accent when hovered OR calendar is open — signals it's clickable.
                    color: root.calendarOpen || titleMouse.containsMouse
                        ? root.accent : root.fg
                    font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                    text: {
                        const t = ToplevelManager.activeToplevel
                        return t && t.title ? t.title : ""
                    }
                    Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }

                    MouseArea {
                        id: titleMouse
                        anchors.fill: parent
                        anchors.margins: -6
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.calendarOpen = !root.calendarOpen
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
                    root.batteryOpen ? "on"
                    : !ok            ? "normal"
                    : charging       ? "on"
                    : pct <= 15      ? "danger"
                    : pct <= 30      ? "warn"
                    :                  "normal"
                property var onClick: () => root.batteryOpen = !root.batteryOpen
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

            // ---- solid white "alert" pill ------------------------------
            // Active-capture indicator: mic in use / screencast live.
            // White bg, black icon + tiny caps label, red LED pulse dot.
            // Bounce-in on appear, hover scales up subtly.
            component AlertChip: Item {
                id: ac
                property string glyph: ""
                property string label: ""
                property bool active: false
                property var onClick: null
                property var onClickRight: null
                property bool hover: false

                // Zero footprint when inactive so leftRow doesn't reserve space.
                visible: pill.implicitWidth > 1
                implicitHeight: 22
                implicitWidth: pill.implicitWidth

                Rectangle {
                    id: pill
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: ac.implicitHeight
                    // Width slides open on activate → creates a subtle
                    // "reveal" animation as the pill grows into place.
                    implicitWidth: ac.active
                        ? pillRow.implicitWidth + 14
                        : 0
                    Behavior on implicitWidth {
                        NumberAnimation { duration: 260; easing.type: Easing.OutBack }
                    }

                    color: root.accent
                    radius: height / 2                    // perfect pill

                    // Scale/opacity affordance for hover + appear.
                    scale: ac.active ? (ac.hover ? 1.06 : 1.0) : 0.6
                    opacity: ac.active ? (ac.hover ? 0.92 : 1.0) : 0.0
                    Behavior on scale   { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    clip: true

                    Row {
                        id: pillRow
                        anchors.centerIn: parent
                        spacing: 5

                        // Red REC-style LED, breathes while live.
                        Rectangle {
                            id: dot
                            width: 6; height: 6
                            radius: 3
                            color: root.danger
                            anchors.verticalCenter: parent.verticalCenter
                            SequentialAnimation on opacity {
                                running: ac.active
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.35; duration: 900; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 1.0;  duration: 900; easing.type: Easing.InOutSine }
                            }
                        }

                        Text {
                            text: ac.glyph
                            color: root.bg
                            font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: ac.label
                            color: root.bg
                            visible: text.length > 0
                            anchors.verticalCenter: parent.verticalCenter
                            // Tiny bold caps with letter-spacing → "TAG" feel.
                            font {
                                family: root.fontFamily
                                pixelSize: 9
                                weight: Font.Black
                                letterSpacing: 1.1
                                capitalization: Font.AllUppercase
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: (ac.onClick || ac.onClickRight)
                        ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onEntered: ac.hover = true
                    onExited:  ac.hover = false
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton && ac.onClickRight)
                            ac.onClickRight()
                        else if (ac.onClick)
                            ac.onClick()
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

    // ---- battery flyout (self-contained) --------------------------------
    Battery {
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        danger:     root.danger
        fontFamily: root.fontFamily
        open:       root.batteryOpen
        onCloseRequested: root.batteryOpen = false
    }

    // ---- calendar flyout (self-contained) ------------------------------
    Calendar {
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        fontFamily: root.fontFamily
        open:       root.calendarOpen
        onCloseRequested: root.calendarOpen = false
    }

    // ---- OSD (volume / mic / brightness — IPC-triggered) ---------------
    Osd {
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        fontFamily: root.fontFamily
    }

    // ---- toast overlay (self-contained; suppressed when center is open) --
    Toasts {
        id: toasts
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        fontFamily: root.fontFamily
        suppressed: root.notifOpen
    }

    // ---- notification center (modular, self-contained) ----------------
    NotifCenter {
        bg:         root.bg
        fg:         root.fg
        muted:      root.muted
        accent:     root.accent
        line:       root.line
        danger:     root.danger
        fontFamily: root.fontFamily
        notifServer: notifServer
        timestamps:  root.notifTimestamps
        open:        root.notifOpen
        dnd:         root.dnd
        onCloseRequested: root.notifOpen = false
        onDndToggled:     root.dnd = !root.dnd
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
