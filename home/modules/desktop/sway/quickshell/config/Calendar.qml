// Calendar flyout — per-screen overlay, anchored roughly under the date chip.
// Palette + open state injected by ShellRoot; grid regenerates reactively
// as viewYear/viewMonth change.
import Quickshell
import Quickshell.Wayland
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

    // ---- open/close state -----------------------------------------------
    required property bool open
    signal closeRequested()

    // ---- geometry --------------------------------------------------------
    property int flyoutWidth: 300
    property int topOffset:   0

    // ---- current view ----------------------------------------------------
    property int viewYear:  new Date().getFullYear()
    property int viewMonth: new Date().getMonth()

    // ---- date math helpers ----------------------------------------------
    function _daysInMonth(y, m) { return new Date(y, m + 1, 0).getDate() }
    // JS: 0=Sun..6=Sat. We want Monday-first: 0=Mon..6=Sun.
    function _firstWeekdayMon(y, m) { return (new Date(y, m, 1).getDay() + 6) % 7 }

    // Nudge "isToday" cell every 60 s while open so highlight rolls to
    // the next day at midnight without needing a manual refresh.
    property int _dayTick: 0
    Timer {
        interval: 60000; repeat: true; running: root.open
        onTriggered: root._dayTick = root._dayTick + 1
    }

    // Reactive cell model — 42 slots (always 6 rows for stable height).
    readonly property var _cells: {
        _dayTick   // dependency
        const y = viewYear, m = viewMonth
        const lead = _firstWeekdayMon(y, m)
        const days = _daysInMonth(y, m)
        const prev = _daysInMonth(y, m - 1)
        const t = new Date()
        const isCurMonth = t.getFullYear() === y && t.getMonth() === m
        const out = []
        for (let i = lead - 1; i >= 0; i--)
            out.push({ day: prev - i, current: false, today: false })
        for (let d = 1; d <= days; d++)
            out.push({ day: d, current: true, today: isCurMonth && d === t.getDate() })
        while (out.length < 42)
            out.push({ day: out.length - lead - days + 1, current: false, today: false })
        return out
    }

    // ---- navigation ------------------------------------------------------
    // Grid opacity lives on root so every PanelWindow's GridLayout binds
    // to it and the crossfade animation (also on root) can be triggered
    // from goto() regardless of Variants scoping.
    property real gridOpacity: 1

    function goto(y, m) {
        const d = new Date(y, m, 1)
        _navAnim.newYear  = d.getFullYear()
        _navAnim.newMonth = d.getMonth()
        _navAnim.restart()
    }
    function next()      { goto(viewYear, viewMonth + 1) }
    function prev()      { goto(viewYear, viewMonth - 1) }
    function jumpToday() { const t = new Date(); goto(t.getFullYear(), t.getMonth()) }

    // Root-scoped month-change crossfade (dim → swap → un-dim).
    SequentialAnimation {
        id: _navAnim
        property int newYear:  root.viewYear
        property int newMonth: root.viewMonth
        NumberAnimation { target: root; property: "gridOpacity"
                          to: 0; duration: 90;  easing.type: Easing.OutCubic }
        ScriptAction {
            script: {
                root.viewYear  = _navAnim.newYear
                root.viewMonth = _navAnim.newMonth
            }
        }
        NumberAnimation { target: root; property: "gridOpacity"
                          to: 1; duration: 110; easing.type: Easing.OutCubic }
    }

    // ---- keep-alive so the flyout close animation plays -----------------
    property bool _alive: false
    onOpenChanged: {
        if (open) { _closeTimer.stop(); _alive = true }
        else if (_alive) _closeTimer.restart()
    }
    Timer { id: _closeTimer; interval: 220; onTriggered: root._alive = false }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: flyout
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-calendar"
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
                // Anchored horizontally centered — matches the centered title trigger.
                x: (parent.width - width) / 2
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
                    anchors.margins: 12
                    spacing: 10

                    // ---- Header row: < Month Year > ------------------
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        NavBtn { glyph: "\u{2039}"; onActivated: root.prev() }   // ‹

                        // Month title — click to jump to today.
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: monthText.implicitHeight
                            Text {
                                id: monthText
                                anchors.centerIn: parent
                                text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                                color: titleMa.containsMouse ? root.accent : root.fg
                                font { family: root.fontFamily; pixelSize: 13; weight: Font.Bold }
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            MouseArea {
                                id: titleMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.jumpToday()
                            }
                        }

                        NavBtn { glyph: "\u{203A}"; onActivated: root.next() }   // ›
                    }

                    // ---- Weekday header row (M T W T F S S) -----------
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 2
                        columns: 7
                        rowSpacing: 0
                        columnSpacing: 0

                        Repeater {
                            model: ["M","T","W","T","F","S","S"]
                            delegate: Item {
                                required property string modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: root.muted
                                    font {
                                        family: root.fontFamily
                                        pixelSize: 10
                                        weight: Font.Bold
                                        letterSpacing: 0.6
                                    }
                                }
                            }
                        }
                    }

                    // ---- Day grid (crossfades on nav) -----------------
                    GridLayout {
                        id: gridBox
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6 * 30
                        columns: 7
                        rowSpacing: 4
                        columnSpacing: 0
                        opacity: root.gridOpacity

                        Repeater {
                            model: root._cells
                            delegate: Item {
                                id: cell
                                required property var modelData
                                required property int index     // Repeater-injected
                                property bool hover: false
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30

                                readonly property bool _current: modelData.current
                                readonly property bool _today:   modelData.today

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    color: cell._today   ? root.accent
                                         : cell.hover
                                             && cell._current ? root.accent
                                         : cell._current ? root.fg
                                         :                 root.muted
                                    font {
                                        family: root.fontFamily
                                        pixelSize: 12
                                        weight: cell._today ? Font.Black : Font.Normal
                                    }
                                    Behavior on color { ColorAnimation { duration: 140 } }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: cell.hover = true
                                    onExited:  cell.hover = false
                                    // Click a spill-over day → navigate to that month.
                                    onClicked: {
                                        if (cell._current) return
                                        const lead = root._firstWeekdayMon(root.viewYear, root.viewMonth)
                                        if (cell.index < lead) root.prev()
                                        else                   root.next()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ---- Reusable header nav button ------------------------------
            component NavBtn: Item {
                id: btn
                property string glyph
                property bool hover: false
                signal activated()

                implicitWidth:  20
                implicitHeight: 20

                Text {
                    anchors.centerIn: parent
                    text: btn.glyph
                    color: btn.hover ? root.accent : root.fg
                    font { family: root.fontFamily; pixelSize: 18; weight: Font.Bold }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: btn.hover = true
                    onExited:  btn.hover = false
                    onClicked: btn.activated()
                }
            }
        }
    }
}
