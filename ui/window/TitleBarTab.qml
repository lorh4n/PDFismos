import QtQuick
import QtQuick.Controls.Basic
import PDFismos

Label {
    id: root

    property bool active: false
    property color accentColor: Theme.accent

    signal closeRequested
    signal clicked

    leftPadding: 30
    rightPadding: 38
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

        color: root.accentColor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10

        width: 18
        height: 18
        radius: 6
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "×"
            color: root.color
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.closeRequested()
        }
    }
}
