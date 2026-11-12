import QtQuick
import PDFismos

Rectangle {
    implicitHeight: 28
    implicitWidth: 28

    radius: 8

    color: Theme.accent

    // TODO: trocar para logo
    Text {
        anchors.centerIn: parent
        font.family: Theme.fontFamily
        text: "E"
        color: Theme.titleBarBackground

        font.bold: true
        font.pixelSize: 16
    }
}
