import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: notesPanel

    property  string  selectedText : ""
    property var pdfViewer
    property color textColor: "#e0e0e0"
    property bool lightMode: true
    property color light: "#e0e0e0"
    property color dark: "#262626"

    signal themeToggleRequested()

    color: lightMode ? light : dark
    Layout.fillHeight: true
    Layout.fillWidth: true

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: qsTr("Notas e tradução")
            color: notesPanel.lightMode ? notesPanel.dark : notesPanel.light
            font.pixelSize: 24
            Layout.fillWidth: true
            Layout.margins: 16
        }


        Label {
            text: notesPanel.selectedText.length > 0
                  ? notesPanel.selectedText
                  : qsTr("Select text in the PDF to preview it here.")
            color: notesPanel.textColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
        }

        Button {
            text: qsTr("Copy selection")
            enabled: notesPanel.selectedText.length > 0
            Layout.alignment: Qt.AlignHCenter
            onClicked: notesPanel.pdfViewer.copySelectionToClipboard()
        }


        Label {
            text: qsTr("As notas e traduções aparecerão aqui.")
            color: notesPanel.lightMode ? notesPanel.dark : notesPanel.light
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
        }

        Item { Layout.fillHeight: true }

        Button {
            id: themeButton
            text: notesPanel.lightMode ? qsTr("\u263D  Dark mode")
                                       : qsTr("\u263C  Light mode")
            Layout.bottomMargin: 16
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            contentItem: Text {
                text: themeButton.text
                color: notesPanel.lightMode ? notesPanel.light : notesPanel.dark
                font: themeButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 36
                radius: 8
                color: notesPanel.lightMode ? notesPanel.dark : notesPanel.light
            }

            onClicked: notesPanel.themeToggleRequested()
        }
    }
}
