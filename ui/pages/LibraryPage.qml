import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import PDFismos

Rectangle {
    id: libraryPage
    signal openPdfRequested

    property var documents: []

    Component.onCompleted: libraryPage.documents = library.documents()

    color: Theme.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        Label {
            text: qsTr("Meus documentos")
            color: Theme.textPrimary
            font.pixelSize: 28
            font.bold: true
        }

        GridView {
            id: documentGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 190
            cellHeight: 220

            model: libraryPage.documents

            delegate: Rectangle {
               id: documentCard
                required property var modelData

                width: 170
                height: 190
                radius: 18
                color: Theme.surface

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8

                    Label {
                        text: documentCard.modelData.title
                        color: Theme.textPrimary
                        font.pixelSize: 18
                        font.bold: true
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Label {
                        text: documentCard.modelData.filePath
                        color: Theme.textSecondary
                        font.pixelSize: 12
                        wrapMode: Text.WrapAnywhere
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignBottom
                    }
                }
            }
        }

        Button {
            text: qsTr("Abrir PDF")
            onClicked: libraryPage.openPdfRequested()
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
