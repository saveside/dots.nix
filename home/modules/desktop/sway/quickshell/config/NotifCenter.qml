// Notification center flyout — per-screen overlay, anchored top-right.
// Palette + open/DND state are injected by ShellRoot so this component
// stays visually identical to the bar without importing its ids.
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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

    // ---- external services ----------------------------------------------
    required property var notifServer          // NotificationServer instance
    required property var timestamps           // { [id]: epoch-ms }

    // ---- open/close + dnd state ----------------------------------------
    required property bool open
    required property bool dnd
    signal closeRequested()
    signal dndToggled()

    // ---- geometry --------------------------------------------------------
    property int flyoutWidth: 400
    property int rightMargin: 12
    property int topOffset:   0
    property int maxHeight:   540

    // ---- reactive helpers ------------------------------------------------
    readonly property var _list: notifServer && notifServer.trackedNotifications
        ? notifServer.trackedNotifications.values : []
    readonly property int _count: _list.length

    // Nudge "5m ago" strings every 30 s while open — cheap re-eval trigger.
    property int _tick: 0
    Timer {
        interval: 30000; running: root.open; repeat: true
        onTriggered: root._tick = root._tick + 1
    }

    function relTime(ms) {
        _tick   // dependency
        if (!ms) return ""
        const diff = Date.now() - ms
        if (diff < 45000)   return "just now"
        const m = Math.floor(diff / 60000)
        if (m < 60)         return m + "m ago"
        const h = Math.floor(m / 60)
        if (h < 24)         return h + "h ago"
        return Math.floor(h / 24) + "d ago"
    }

    // ---- keep the PanelWindow alive briefly so close animates -----------
    property bool _alive: false
    onOpenChanged: {
        if (root.open) { _closeTimer.stop(); _alive = true }
        else if (_alive) _closeTimer.restart()
    }
    Timer { id: _closeTimer; interval: 240; repeat: false; onTriggered: root._alive = false }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: flyout
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-notif-center"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 34 }        // clear the bar so bar chips remain clickable
            color: "transparent"
            visible: root._alive

            // Click-outside dismiss
            MouseArea {
                anchors.fill: parent
                onClicked: root.closeRequested()
            }

            // ---- panel: pure black, no border, no per-item cards --------
            Rectangle {
                id: panel
                x: parent.width - width - root.rightMargin
                y: root.open ? root.topOffset : (root.topOffset - 10)
                width: root.flyoutWidth
                height: Math.min(parent.height - 20, content.implicitHeight + 24)
                color: root.bg
                opacity: root.open ? 1.0 : 0.0

                Behavior on y       { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                // Eat clicks so they don't fall through to the dismiss layer
                MouseArea { anchors.fill: parent; onClicked: {} }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    // ---- Header row -----------------------------------
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Notifications"
                            color: root.accent
                            font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Text {
                            text: root._count > 0 ? String(root._count) : ""
                            color: root.muted
                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                            visible: root._count > 0
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }     // spacer

                        HeaderBtn {
                            label: root.dnd ? "• DND ON" : "DND"
                            active: root.dnd
                            onActivated: root.dndToggled()
                        }
                        HeaderBtn {
                            label: "CLEAR"
                            visible: root._count > 0
                            onActivated: {
                                for (const n of root._list.slice()) n.dismiss()
                            }
                        }
                    }

                    // ---- header separator -----------------------------
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: root.line
                    }

                    // ---- Empty state ----------------------------------
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 30
                        Layout.bottomMargin: 30
                        text: "no notifications"
                        color: root.muted
                        font { family: root.fontFamily; pixelSize: 11; weight: Font.Bold }
                        visible: root._count === 0
                    }

                    // ---- Scrollable list ------------------------------
                    Flickable {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.min(root.maxHeight, listCol.implicitHeight)
                        Layout.fillHeight: false
                        contentWidth: width
                        contentHeight: listCol.implicitHeight
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        visible: root._count > 0

                        // Ultra-thin custom scroll indicator.
                        ScrollBar.vertical: ScrollBar {
                            id: sb
                            policy: ScrollBar.AsNeeded
                            interactive: true
                            active: sb.hovered || sb.pressed || parent.moving
                            contentItem: Rectangle {
                                implicitWidth: 3
                                radius: 1.5
                                color: sb.pressed ? root.accent
                                     : sb.hovered ? root.fg
                                     :              root.muted
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            background: Item { implicitWidth: 3 }
                        }

                        Column {
                            id: listCol
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: root.notifServer
                                    ? root.notifServer.trackedNotifications : null
                                delegate: NotifRow {
                                    required property var modelData
                                    required property int index
                                    width: listCol.width
                                    notification: modelData
                                    showDivider: index < root._count - 1
                                }
                            }
                        }
                    }
                }
            }

            // =============================================================
            // Per-notification row — unboxed layout, slides right + fades
            // + collapses height on dismiss before actually invoking .dismiss().
            // =============================================================
            component NotifRow: Item {
                id: nr
                property var notification
                property bool showDivider: false

                // 0 = idle, 1 = fully dismissed. Drives x/opacity/height.
                property real _dismissProgress: 0
                Behavior on _dismissProgress {
                    NumberAnimation { duration: 220; easing.type: Easing.InCubic }
                }

                readonly property real _naturalHeight: Math.max(60, rowCol.implicitHeight + 20)
                implicitHeight: _naturalHeight * (1 - _dismissProgress)
                x: width * _dismissProgress
                opacity: 1 - _dismissProgress

                function dismissAnimated() {
                    if (nr._dismissProgress > 0) return
                    nr._dismissProgress = 1
                    _actualDismiss.start()
                }
                Timer {
                    id: _actualDismiss
                    interval: 230; repeat: false
                    onTriggered: if (nr.notification) nr.notification.dismiss()
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 12

                    // ---- App icon ---------------------------------------
                    Item {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        Layout.alignment: Qt.AlignTop

                        Image {
                            id: iconImg
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            asynchronous: true
                            sourceSize.width:  68
                            sourceSize.height: 68
                            visible: status === Image.Ready
                            source: {
                                if (!nr.notification) return ""
                                if (nr.notification.image) return nr.notification.image
                                const a = nr.notification.appIcon || ""
                                if (!a) return ""
                                if (a.charAt(0) === "/" || a.indexOf("file:") === 0) return a
                                return Quickshell.iconPath(a, true)
                            }
                        }

                        // Text fallback = first letter of app name in a muted glyph.
                        Text {
                            anchors.centerIn: parent
                            visible: !iconImg.visible
                            text: nr.notification && nr.notification.appName
                                ? nr.notification.appName.charAt(0).toUpperCase() : "?"
                            color: root.muted
                            font { family: root.fontFamily; pixelSize: 16; weight: Font.Black }
                        }
                    }

                    // ---- Body column ------------------------------------
                    ColumnLayout {
                        id: rowCol
                        Layout.fillWidth: true
                        spacing: 4

                        // Title row: summary  +  timestamp  +  ×
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                Layout.fillWidth: true
                                text: nr.notification
                                    ? (nr.notification.summary || nr.notification.appName || "")
                                    : ""
                                color: root.accent
                                elide: Text.ElideRight
                                font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                            }
                            Text {
                                text: nr.notification && root.timestamps
                                    ? root.relTime(root.timestamps[nr.notification.id]) : ""
                                color: root.muted
                                font { family: root.fontFamily; pixelSize: 10; weight: Font.Normal }
                                visible: text.length > 0
                            }
                            Item {
                                implicitWidth: 16; implicitHeight: 16
                                Text {
                                    id: closeGlyph
                                    anchors.centerIn: parent
                                    text: "×"     // ×
                                    color: closeMa.containsMouse ? root.accent : root.fg
                                    font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }
                                MouseArea {
                                    id: closeMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: nr.dismissAnimated()
                                }
                            }
                        }

                        // App name row (secondary)
                        Text {
                            Layout.fillWidth: true
                            text: nr.notification && nr.notification.appName
                                ? nr.notification.appName : ""
                            color: root.muted
                            elide: Text.ElideRight
                            font { family: root.fontFamily; pixelSize: 10; weight: Font.Normal }
                            visible: text.length > 0
                        }

                        // Body (truncated to 5 lines, wraps)
                        Text {
                            Layout.fillWidth: true
                            text: nr.notification && nr.notification.body ? nr.notification.body : ""
                            color: root.fg
                            wrapMode: Text.WordWrap
                            textFormat: Text.RichText
                            font { family: root.fontFamily; pixelSize: 11; weight: Font.Normal }
                            elide: Text.ElideRight
                            maximumLineCount: 5
                            visible: text.length > 0
                        }

                        // Inline actions — link-style text, no boxes.
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 14
                            visible: nr.notification && nr.notification.actions
                                && nr.notification.actions.length > 0

                            Repeater {
                                model: nr.notification ? nr.notification.actions : []
                                delegate: Item {
                                    required property var modelData
                                    property bool hover: false
                                    implicitWidth: actLbl.implicitWidth
                                    implicitHeight: actLbl.implicitHeight
                                    Text {
                                        id: actLbl
                                        anchors.centerIn: parent
                                        text: modelData.text || modelData.identifier || "action"
                                        color: parent.hover ? root.accent : root.fg
                                        font {
                                            family: root.fontFamily
                                            pixelSize: 10
                                            weight: Font.Bold
                                            capitalization: Font.AllUppercase
                                            letterSpacing: 0.8
                                        }
                                        Behavior on color { ColorAnimation { duration: 150 } }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -4
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onEntered: parent.hover = true
                                        onExited:  parent.hover = false
                                        onClicked: {
                                            modelData.invoke()
                                            nr.dismissAnimated()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Faint 1px separator between rows.
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: root.line
                    visible: nr.showDivider && nr._dismissProgress < 0.5
                }
            }

            // ---- Reusable header text button (unboxed) ------------------
            component HeaderBtn: Item {
                id: hb
                property string label: ""
                property bool active: false
                property bool hover: false
                signal activated()

                implicitHeight: hbText.implicitHeight
                implicitWidth:  hbText.implicitWidth + 6

                Text {
                    id: hbText
                    anchors.centerIn: parent
                    text: hb.label
                    color: hb.active ? root.accent
                         : hb.hover  ? root.accent
                         :             root.fg
                    font {
                        family: root.fontFamily
                        pixelSize: 10
                        weight: Font.Black
                        capitalization: Font.AllUppercase
                        letterSpacing: 1.0
                    }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: hb.hover = true
                    onExited:  hb.hover = false
                    onClicked: hb.activated()
                }
            }
        }
    }
}
