import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Pdf
import PDFismos.ui.components

RowLayout {
    id: root

    required property color readerBackground
    required property color readerTextColor

    required property PdfDocument currentDocument
    required property string searchText
    required property bool lightMode
    required property bool panelVisible
    required property color dark
    required property color light

    property alias view: pdfView

    signal viewportChanged
    signal readingPageChanged(int pageIndex)
    signal themeToggleRequested

    spacing: 0

    Rectangle {
        id: rectangle1
        color: root.readerBackground
        Layout.fillHeight: true
        Layout.fillWidth: true

        ColumnLayout {
            anchors.fill: parent
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Label {
                visible: root.currentDocument.status === PdfDocument.Null
                text: qsTr("Open a PDF to Begin")
                color: root.readerTextColor
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                visible: root.currentDocument.status === PdfDocument.Loading
                text: qsTr("Loading PDF…")
                color: root.readerTextColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                visible: root.currentDocument.status === PdfDocument.Error
                text: qsTr("Could not load PDF: %1").arg(root.currentDocument.error)
                color: root.readerTextColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            PdfMultiPageView {
                id: pdfView
                visible: root.currentDocument.status === PdfDocument.Ready
                document: root.currentDocument
                Layout.fillWidth: true
                Layout.fillHeight: true
                renderScale: 1.0
                onWidthChanged: root.viewportChanged()
                onHeightChanged: root.viewportChanged()
                onCurrentPageChanged: root.readingPageChanged(currentPage)
                searchString: root.searchText
            }
        }
    }

    NotesPanel {
        selectedText: pdfView.selectedText
        pdfViewer: pdfView
        textColor: root.readerTextColor
        lightMode: root.lightMode
        light: root.light
        dark: root.dark
        visible: root.panelVisible
        onThemeToggleRequested: root.themeToggleRequested()
    }
}
