import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Pdf
import QtQuick.Dialogs
import QtCore
import PDFismos
import PDFismos.ui.components
import PDFismos.ui.pages
import PDFismos.ui.window

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    title: qsTr("Hello World!!!")
    readonly property real windowCornerRadius: window.visibility === Window.Windowed ? 18 : 0

    palette.window: lightMode ? Theme.background : reallyDark
    palette.windowText: lightMode ? Theme.textPrimary : light
    palette.base: lightMode ? Theme.paper : reallyDark
    palette.alternateBase: lightMode ? Theme.surface : dark
    palette.text: lightMode ? Theme.textPrimary : light
    palette.button: lightMode ? Theme.surface : dark
    palette.buttonText: lightMode ? Theme.textPrimary : light
    palette.mid: lightMode ? "#a0a0a0" : "#666666"
    palette.dark: lightMode ? "#808080" : "#111111"
    palette.light: lightMode ? "#ffffff" : "#444444"
    palette.placeholderText: lightMode ? "#626262" : "#aaaaaa"
    palette.highlight: lightMode ? Theme.accentPressed : "#3269c7"
    palette.highlightedText: lightMode ? Theme.textPrimary : "#ffffff"
    palette.disabled.text: lightMode ? "#808080" : "#858585"
    palette.disabled.buttonText: lightMode ? "#808080" : "#858585"

    Settings {
        id: appSettings
        property alias lastPdf: pdfDocument.source
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.lightMode
    }

    Shortcut {
        sequence: "Esc"
        onActivated: window.panelVisible = false
    }
    PdfDocument {
        id: pdfDocument

        // TODO: resolver issue #2
        onStatusChanged: function (status) {
            if (status === PdfDocument.Ready) {
                const documentId = library.registerDocument(pdfDocument.source);
                window.activeDocumentId = documentId;

                const savedPageIndex = documentId >= 0 ? library.readingProgress(documentId) : 0;

                window.pendingPageIndex = savedPageIndex;
                window.restorePageIfReady();
            }
        }
    }

    FileDialog {
        id: pdfFileDialog
        title: qsTr("Choose a PDF")
        fileMode: FileDialog.OpenFile
        nameFilters: ["PDF files (*.pdf)"]
        onAccepted: {
            window.restoringLastPage = true;
            window.activeDocumentId = -1;
            window.pendingPageIndex = -1;
            pdfDocument.source = selectedFile;
            window.showLibrary = false;
        }
    }

    header: ColumnLayout {
        spacing: 0

        TitleBar {
            Layout.fillWidth: true
            appWindow: window
            cornerRadius: window.windowCornerRadius
        }

        ToolBar {
            visible: !window.showLibrary

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    text: qsTr("Abrir PDF")
                    onClicked: {
                        console.log("Abrir PDF Foi clicked");
                        pdfFileDialog.open();
                    }
                }

                TextField {
                    id: searchField
                    placeholderText: qsTr("Buscar no documento")
                    Layout.fillWidth: true
                    onAccepted: {
                        if (pdfView.searchModel.count > 0) {
                            pdfView.searchForward();
                        }
                    }
                }
                ToolButton {
                    text: "↑"
                    enabled: pdfView.searchModel.count > 0
                    onClicked: pdfView.searchBack()
                }

                ToolButton {
                    text: "↓"
                    enabled: pdfView.searchModel.count > 0
                    onClicked: pdfView.searchForward()
                }

                ToolButton {
                    text: "-"
                    onClicked: {
                        pdfView.renderScale = Math.max(0.5, pdfView.renderScale - 0.1);
                    }
                }
                Label {
                    text: Math.round(pdfView.renderScale * 100) + "%"
                }
                ToolButton {
                    text: "+"
                    onClicked: {
                        pdfView.renderScale = Math.min(2.0, pdfView.renderScale + 0.1);
                    }
                }
                ToolButton {
                    text: window.panelVisible ? qsTr("Ocultar painel") : qsTr("Mostrar painel")
                    onClicked: window.panelVisible = !window.panelVisible
                }
            }
        }
    }

    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"
    property bool panelVisible: true
    property bool restoringLastPage: true
    property bool showLibrary: true
    property var activeDocumentId: -1
    property int pendingPageIndex: -1

    onShowLibraryChanged: window.restorePageIfReady()

    function restorePageIfReady() {
        if (window.pendingPageIndex < 0 || window.showLibrary || pdfDocument.status !== PdfDocument.Ready || pdfView.width <= 0 || pdfView.height <= 0)
            return;

        Qt.callLater(function () {
            if (window.pendingPageIndex < 0 || window.showLibrary || pdfDocument.status !== PdfDocument.Ready || pdfView.width <= 0 || pdfView.height <= 0)
                return;

            const targetPage = Math.min(window.pendingPageIndex, pdfDocument.pageCount - 1);
            window.pendingPageIndex = -1;
            pdfView.goToPage(Math.max(0, targetPage));
            window.restoringLastPage = false;
        });
    }

    LibraryPage {
        id: libraryPage
        anchors.fill: parent
        visible: window.showLibrary
        cornerRadius: window.windowCornerRadius
        onOpenPdfRequested: pdfFileDialog.open()
        onDocumentSelected: function (fileUrl) {
            window.restoringLastPage = true;
            window.activeDocumentId = -1;
            window.pendingPageIndex = -1;
            pdfDocument.source = fileUrl;
            window.showLibrary = false;
        }
    }

    RowLayout {
        id: grid
        spacing: 0
        anchors.fill: parent
        visible: !window.showLibrary

        Rectangle {
            id: rectangle1
            color: appSettings.theme ? window.reallyLight : window.reallyDark
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                // Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Label {
                    visible: pdfDocument.status === PdfDocument.Null
                    text: qsTr("Open a PDF to Begin")
                    color: appSettings.theme ? window.dark : window.light
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    visible: pdfDocument.status === PdfDocument.Loading
                    text: qsTr("Loading PDF…")
                    color: appSettings.theme ? window.dark : window.light
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    visible: pdfDocument.status === PdfDocument.Error
                    text: qsTr("Could not load PDF: %1").arg(pdfDocument.error)
                    color: appSettings.theme ? window.dark : window.light
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                PdfMultiPageView {
                    id: pdfView
                    visible: pdfDocument.status === PdfDocument.Ready
                    document: pdfDocument
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    renderScale: 1.0
                    onWidthChanged: window.restorePageIfReady()
                    onHeightChanged: window.restorePageIfReady()
                    // TODO: resolver issue #2
                    onCurrentPageChanged: {
                        if (currentPage >= 0) {
                            pageNumber.value = currentPage + 1;

                            if (!window.restoringLastPage && window.activeDocumentId >= 0) {
                                library.saveReadingProgress(window.activeDocumentId, currentPage);
                            }
                        }
                    }
                    searchString: searchField.text
                }
            }
        }

        NotesPanel {
            selectedText: pdfView.selectedText
            pdfViewer: pdfView
            textColor: appSettings.theme ? window.dark : window.light
            lightMode: appSettings.theme
            light: window.light
            dark: window.dark
            visible: window.panelVisible
            onThemeToggleRequested: window.lightMode = !window.lightMode
        }
    }

    footer: ToolBar {
        visible: !window.showLibrary

        RowLayout {
            anchors.fill: parent

            Label {
                text: qsTr("Page")
            }

            SpinBox {
                id: pageNumber
                from: 1
                to: Math.max(1, pdfDocument.pageCount)
                value: 1
                editable: true
                enabled: pdfDocument.status === PdfDocument.Ready
                onValueModified: pdfView.goToPage(value - 1)
            }

            Label {
                text: qsTr("of %1").arg(pdfDocument.pageCount)
            }

            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                text: qsTr("Fit Width")
                enabled: pdfDocument.status === PdfDocument.Ready
                onClicked: pdfView.scaleToWidth(pdfView.width, pdfView.height)
            }
        }
    }
    WindowResizeFrame {
        parent: Overlay.overlay
        anchors.fill: parent
        appWindow: window
    }
}
