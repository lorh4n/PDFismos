import QtQuick
import QtQuick.Controls.Basic
import PDFismos

Label {
    id: root

    property bool active: false

    signal clicked

    leftPadding: 30
    rightPadding: 14
    verticalAlignment: Text.AlignVCenter

    font.pixelSize: 13
    font.weight: Font.DemiBold
    elide: Text.ElideRight

    color: root.active ? Theme.textPrimary : Theme.windowControlText

    background: Rectangle {
        color: root.active ? Theme.libraryTabActive : "transparent"

        topLeftRadius: 12
        topRightRadius: 12
    }
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter

        width: 8
        height: 8
        radius: 4

        color: Theme.accent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
