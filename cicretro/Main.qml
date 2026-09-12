import QtQuick
import QtQuick.Window

Window {
    id: window

    visible: true
    visibility: Window.FullScreen
    color: "#050505"
    title: "E9X CIC"

    CicShell {
        anchors.fill: parent
    }
}