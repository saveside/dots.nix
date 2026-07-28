// Toast notification overlay — top-right, stacks new arrivals.
// Owns its own ListModel so per-card animation state survives when
// siblings are dismissed (a plain JS-array Repeater would re-bind
// delegates by index and reset animations on every removal).
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
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

    // ---- config ----------------------------------------------------------
    property int toastWidth:     380
    property int topMargin:      40    // below the 34px bar + gap
    property int rightMargin:    12
    property int stackSpacing:   6
    property int defaultTimeout: 5000

    // When true, the overlay hides and new pushes are dropped (used by the
    // notification center + DND — the entry is still in trackedNotifications).
    property bool suppressed: false

    // ---- public API (called by ShellRoot's onNotification) --------------
    function push(n) {
        if (root.suppressed || !n) return
        _model.append({ notif: n })
    }

    // Manual removal by notification ref (used by internal card signals).
    function _removeByRef(target) {
        for (let i = 0; i < _model.count; i++) {
            if (_model.get(i).notif === target) {
                _model.remove(i)
                return
            }
        }
    }

    ListModel {
        id: _model
        dynamicRoles: true       // stores var-typed notification refs
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay
            required property var modelData
            screen: modelData
            WlrLayershell.namespace: "quickshell-toasts"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors { top: true; right: true }
            margins { top: root.topMargin; right: root.rightMargin }
            color: "transparent"
            implicitWidth:  root.toastWidth + 40    // room for slide-in offset
            implicitHeight: Math.max(1, stack.implicitHeight + 4)
            visible: !root.suppressed && _model.count > 0

            Column {
                id: stack
                anchors.right: parent.right
                anchors.top:   parent.top
                width:         root.toastWidth
                spacing:       root.stackSpacing

                Repeater {
                    model: _model
                    delegate: ToastCard {
                        required property int index
                        required property var model
                        width: root.toastWidth
                        notification: model.notif
                        suppressed:   root.suppressed
                        onExpired:    root._removeByRef(notification)
                    }
                }
            }

            // =============================================================
            // Toast card — self-contained animation + countdown.
            // =============================================================
            component ToastCard: Item {
                id: card
                property var  notification
                property bool suppressed: false
                property bool hover:      false
                property bool leaving:    false
                property int  elapsed:    0
                signal expired()

                readonly property int _duration: notification && notification.expireTimeout > 0
                    ? Math.max(1500, notification.expireTimeout)
                    : root.defaultTimeout
                readonly property real _progress: Math.min(1, elapsed / _duration)

                // ---- ENTER animation ---------------------------------
                property real _entered: 0
                NumberAnimation on _entered {
                    from: 0; to: 1
                    duration: 180
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.15
                    running: true
                }

                // ---- EXIT animation ---------------------------------
                property real _exit: 0
                NumberAnimation on _exit {
                    id: exitAnim
                    from: 0; to: 1
                    duration: 130
                    easing.type: Easing.InCubic
                    running: card.leaving
                    onStopped: if (card._exit >= 0.999) card.expired()
                }

                // ---- composited transform + opacity -----------------
                x:       (1 - _entered) * 28            // slide in from right
                y:       _exit * -10                    // slide up on exit
                scale:   0.97 + _entered * 0.03         // tiny springy pop
                opacity: _entered * (1 - _exit)         // fade in + fade out
                implicitHeight: body.implicitHeight * (1 - _exit)
                width: parent.width

                // ---- countdown (paused on hover / when suppressed) --
                Timer {
                    interval: 100
                    repeat: true
                    running: !card.hover && !card.leaving
                        && !card.suppressed && card._entered >= 0.6
                        && card.notification !== null
                    onTriggered: {
                        card.elapsed += 100
                        if (card.elapsed >= card._duration) card.leaving = true
                    }
                }

                // ---- Card body: pure black, unboxed -----------------
                Rectangle {
                    id: body
                    anchors.left:  parent.left
                    anchors.right: parent.right
                    color: root.bg
                    border { color: root.line; width: 1 }
                    radius: 4
                    implicitHeight: contentCol.implicitHeight + 20

                    RowLayout {
                        id: contentCol
                        anchors.left:   parent.left
                        anchors.right:  parent.right
                        anchors.top:    parent.top
                        anchors.margins: 10
                        anchors.bottomMargin: 12       // clearance for progress bar
                        spacing: 12

                        // ---- App icon (32px, top-aligned) -----------
                        Item {
                            Layout.preferredWidth:  32
                            Layout.preferredHeight: 32
                            Layout.alignment: Qt.AlignTop
                            Image {
                                id: appIco
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                asynchronous: true
                                sourceSize.width:  64
                                sourceSize.height: 64
                                visible: status === Image.Ready
                                source: {
                                    const n = card.notification
                                    if (!n) return ""
                                    if (n.image) return n.image
                                    const a = n.appIcon || ""
                                    if (!a) return ""
                                    if (a.charAt(0) === "/" || a.indexOf("file:") === 0) return a
                                    return Quickshell.iconPath(a, true)
                                }
                            }
                            Text {
                                anchors.centerIn: parent
                                visible: !appIco.visible
                                text: card.notification && card.notification.appName
                                    ? card.notification.appName.charAt(0).toUpperCase() : "?"
                                color: root.muted
                                font { family: root.fontFamily; pixelSize: 14; weight: Font.Black }
                            }
                        }

                        // ---- Text block -----------------------------
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            // App name (muted secondary) + close × on hover
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Text {
                                    Layout.fillWidth: true
                                    text: card.notification && card.notification.appName
                                        ? card.notification.appName : ""
                                    color: root.muted
                                    elide: Text.ElideRight
                                    font {
                                        family: root.fontFamily
                                        pixelSize: 10
                                        weight: Font.Bold
                                        capitalization: Font.AllUppercase
                                        letterSpacing: 0.8
                                    }
                                }
                                Item {
                                    implicitWidth: 14; implicitHeight: 14
                                    opacity: card.hover ? 1 : 0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "×"
                                        color: closeMa.containsMouse ? root.accent : root.fg
                                        font { family: root.fontFamily; pixelSize: 14; weight: Font.Bold }
                                        Behavior on color { ColorAnimation { duration: 150 } }
                                    }
                                    MouseArea {
                                        id: closeMa
                                        anchors.fill: parent
                                        anchors.margins: -4
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (card.notification) card.notification.dismiss()
                                            card.leaving = true
                                        }
                                    }
                                }
                            }

                            // Title
                            Text {
                                Layout.fillWidth: true
                                text: card.notification
                                    ? (card.notification.summary || card.notification.appName || "")
                                    : ""
                                color: root.accent
                                elide: Text.ElideRight
                                font { family: root.fontFamily; pixelSize: 12; weight: Font.Bold }
                            }

                            // Body — max 2 lines with truncation
                            Text {
                                Layout.fillWidth: true
                                text: card.notification && card.notification.body
                                    ? card.notification.body : ""
                                color: root.fg
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                maximumLineCount: 2
                                textFormat: Text.RichText
                                font { family: root.fontFamily; pixelSize: 11; weight: Font.Normal }
                                visible: text.length > 0
                            }

                            // Inline actions — link-style, accent on hover
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.topMargin: 4
                                spacing: 14
                                visible: card.notification && card.notification.actions
                                    && card.notification.actions.length > 0

                                Repeater {
                                    model: card.notification ? card.notification.actions : []
                                    delegate: Item {
                                        required property var modelData
                                        property bool hover: false
                                        implicitWidth:  actTxt.implicitWidth
                                        implicitHeight: actTxt.implicitHeight
                                        Text {
                                            id: actTxt
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
                                                if (card.notification) card.notification.dismiss()
                                                card.leaving = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ---- 1px razor-thin progress line ----------------
                    // Shrinks left→right (width bound to remaining time).
                    Rectangle {
                        anchors.left:   parent.left
                        anchors.bottom: parent.bottom
                        height: 1
                        width:  parent.width * (1 - card._progress)
                        color:  root.accent
                        opacity: card.leaving ? 0 : 1
                        Behavior on opacity { NumberAnimation { duration: 140 } }
                    }
                }

                // Card-wide hover detector (pauses countdown, reveals close ×).
                // Placed BELOW the interactive children so their MouseAreas win.
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton     // don't swallow clicks
                    onEntered: card.hover = true
                    onExited:  card.hover = false
                    z: -1
                }
            }
        }
    }
}
