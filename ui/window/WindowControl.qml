import QtQuick
import QtQuick.Controls.Basic
import PDFismos

ToolButton {
    id: control

    property bool closeAction: false

    implicitHeight: 28
    implicitWidth: 28

    hoverEnabled: true

    icon.width: 16
    icon.height: 16

    icon.color: control.closeAction && control.hovered ? Theme.paper : Theme.windowControlText

    background: Rectangle {

        radius: 8

        color: control.hovered ? (control.closeAction ? Theme.windowCloseHover : Theme.windowControlHover) : "transparent"
    }
}
