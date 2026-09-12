import QtQuick

Item {
    id: root

    focus: true

    property bool motionEffects: true
    property bool particlesEnabled: true

    property int selectedIndex: 0

    property real menuX: 455
    property real menuTop: 68
    property real rowHeight: 42

    property string timeText: "--:--"

    property var menuItems: [
        { title: "Multimedia",   accent: "#61b8ff", visualKey: "multimedia" },
        { title: "Radio",        accent: "#59c7ff", visualKey: "radio" },
        { title: "Telephone",    accent: "#77bfff", visualKey: "telephone" },
        { title: "Contacts",     accent: "#83cfff", visualKey: "contacts" },
        { title: "Navigation",   accent: "#66d7d1", visualKey: "navigation" },
        { title: "Vehicle Info", accent: "#7dc2ff", visualKey: "vehicle" },
        { title: "Performance",  accent: "#7e9cff", visualKey: "performance" },
        { title: "Diagnostics",  accent: "#92b6ff", visualKey: "diagnostics" },
        { title: "Settings",     accent: "#9ec7ff", visualKey: "settings" }
    ]

    function setSelection(index) {
        var count = menuItems.length
        index = (index + count) % count

        if (index === selectedIndex)
            return

        selectedIndex = index

        var item = menuItems[index]
        visual.transitionTo(item.accent, item.visualKey)
    }

    function moveSelection(amount) {
        setSelection(selectedIndex + amount)
    }

    function activateSelection() {
        console.log("Activate:", menuItems[selectedIndex].title)
    }

    Keys.onUpPressed: moveSelection(-1)
    Keys.onDownPressed: moveSelection(1)
    Keys.onReturnPressed: activateSelection()
    Keys.onEnterPressed: activateSelection()

    Rectangle {
        anchors.fill: parent
        color: "#020407"
    }

    CicVisual {
        id: visual
        anchors.fill: parent

        menuX: root.menuX
        selectionY: root.menuTop + root.selectedIndex * root.rowHeight + root.rowHeight / 2

        motionEnabled: root.motionEffects
        particlesEnabled: root.particlesEnabled
    }

    Rectangle {
        x: root.menuX
        y: root.menuTop
        width: parent.width - x - 22
        height: root.rowHeight * root.menuItems.length
        color: "#0a0f15"
        opacity: 0.97
        border.width: 1
        border.color: "#1b2836"
    }

    Rectangle {
        id: header

        x: root.menuX - 72
        y: 14

        width: parent.width - x - 22
        height: 42

        color: "#121923"
        border.width: 1
        border.color: "#263243"

        Item {
            id: menuSymbol

            x: 14
            anchors.verticalCenter: parent.verticalCenter
            width: 28
            height: 24

            Rectangle {
                x: 1
                y: 3
                width: 7
                height: 7
                radius: 3.5
                color: "transparent"
                border.color: "#d9e8f6"
                border.width: 1
            }

            Repeater {
                model: 3
                Rectangle {
                    x: 12
                    y: 4 + index * 7
                    width: 14
                    height: 1
                    color: "#d9e8f6"
                }
            }
        }

        Text {
            anchors.left: menuSymbol.right
            anchors.leftMargin: 9
            anchors.verticalCenter: parent.verticalCenter

            text: "Main menu"
            color: "#eef6ff"
            font.pixelSize: 19
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            width: 112
            height: 28

            color: "#0c1218"
            border.width: 1
            border.color: "#2e3e51"

            Text {
                anchors.centerIn: parent
                text: root.timeText
                color: "#d8ecff"
                font.pixelSize: 17
            }
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 18
            anchors.verticalCenter: parent.verticalCenter

            text: "Bluetooth"
            color: "#b8d2ea"
            font.pixelSize: 15
        }
    }

    Column {
        id: menuColumn

        x: root.menuX
        y: root.menuTop

        width: parent.width - x - 22
        spacing: 0

        Repeater {
            model: root.menuItems

            delegate: Item {
                required property int index
                required property var modelData

                width: menuColumn.width
                height: root.rowHeight

                Rectangle {
                    anchors.fill: parent
                    color: index % 2 === 0 ? "#0f141a" : "#0c1117"
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: "#202b38"
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2

                    visible: index === root.selectedIndex
                    color: "#12202b"
                    border.width: 2
                    border.color: modelData.accent
                }

                Rectangle {
                    visible: index === root.selectedIndex
                    x: 4
                    y: 4
                    width: parent.width - 8
                    height: parent.height - 8
                    color: modelData.accent
                    opacity: 0.06
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 28
                    anchors.verticalCenter: parent.verticalCenter

                    text: modelData.title
                    color: "#eef4fb"
                    font.pixelSize: 22
                    font.weight: index === root.selectedIndex ? Font.Medium : Font.Normal
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (index === root.selectedIndex)
                            root.activateSelection()
                        else
                            root.setSelection(index)
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                root.moveSelection(-1)
            else if (wheel.angleDelta.y < 0)
                root.moveSelection(1)
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.timeText = Qt.formatTime(new Date(), "h:mm")
        }
    }

    Component.onCompleted: {
        forceActiveFocus()

        var item = menuItems[selectedIndex]
        visual.setImmediate(item.accent, item.visualKey)
    }
}