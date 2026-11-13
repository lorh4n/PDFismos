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
import QtQml.Models

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    title: qsTr("PDFismo by Estudismos")
    readonly property real windowCornerRadius: window.visibility === Window.Windowed ? 18 : 0
    font.family: Theme.fontFamily
    property string selectedDocumentUrl: ""

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
        // TODO: IMPLEMNETAR "CONTINUAR ONDE PAROU" MAS ISSO VAI SER  GUARDADO NO BANCO
        // property alias lastPdf: pdfDocument.source
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
                const savedColor = documentId >= 0 ? library.documentColor(documentId) : "";
                const loadedUrl = String(pdfDocument.source);
                const tabIndex = openDocuments.indexOfUrl(loadedUrl);
                if (tabIndex >= 0) {
                    openDocuments.setProperty(
                        tabIndex, "tabColor",
                        savedColor !== "" ? savedColor : String(Theme.accent)
                    );
                }

                const savedPageIndex = documentId >= 0 ? library.readingProgress(documentId) : 0;

                window.pendingPageIndex = savedPageIndex;
                window.restorePageIfReady();
            }
        }
    }

    FileDialog {
        id: pdfFileDialog
        title: qsTr("Escolha um PDF")
        fileMode: FileDialog.OpenFile
        nameFilters: ["PDF files (*.pdf)"]
        onAccepted: {
            window.openDocument(selectedFile);
        }
    }

    header: ColumnLayout {
        spacing: 0

        TitleBar {
            documentTabs: openDocuments
            selectedDocumentUrl: window.selectedDocumentUrl
            Layout.fillWidth: true
            appWindow: window
            cornerRadius: window.windowCornerRadius
            onLibraryRequested: {
                // Atualiza a lista de documentos
                libraryPage.documents = library.documents();
                window.showLibrary = true;
            }
            onDocumentRequested: function (fileUrl) {
                window.openDocument(fileUrl);
            }

            onDocumentCloseRequested: function (tabIndex) {
                window.closeDocumentTab(tabIndex);
            }
        }

        ReaderToolbar {
            id: readerToolbar
            Layout.fillWidth: true
            visible: !window.showLibrary
            pdfView: readerPage.view
            panelVisible: window.panelVisible

            onOpenRequested: pdfFileDialog.open()
            onPanelToggleRequested: window.panelVisible = !window.panelVisible
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

    DocumentTabsModel {
        id: openDocuments
    }

    function openDocument(fileUrl) {
        const url = String(fileUrl);
        window.selectedDocumentUrl = url;


        if (openDocuments.indexofUrl(url) === -1) {
            openDocuments.append({
                tabUrl: url,
                tabTitle: library.fileName(fileUrl),
                tabColor: String(Theme.accent)
            });
        }

        if (String(pdfDocument.source) === url) {
            window.showLibrary = false;
            return;
        }

        window.restoringLastPage = true;
        window.activeDocumentId = -1;
        window.pendingPageIndex = -1;
        pdfDocument.source = fileUrl;
        window.showLibrary = false;
    }

    function closeDocumentTab(tabIndex) {
        const wasSelected = openDocuments.get(tabIndex).tabUrl === window.selectedDocumentUrl;
        openDocuments.remove(tabIndex);

        if (!wasSelected) {
            return;
        }

        if (openDocuments.count > 0) {
            const nextIndex = Math.min(tabIndex, openDocuments.count - 1);
            window.openDocument(openDocuments.get(nextIndex).tabUrl);
            return;
        }

        window.restoringLastPage = true;
        window.activeDocumentId = -1;
        window.pendingPageIndex = -1;
        window.selectedDocumentUrl = "";
        pdfDocument.source = "";
        libraryPage.documents = library.documents();
        window.showLibrary = true;
    }

    onShowLibraryChanged: window.restorePageIfReady()

    function restorePageIfReady() {
        if (window.pendingPageIndex < 0 || window.showLibrary || pdfDocument.status !== PdfDocument.Ready || readerPage.view.width <= 0 || readerPage.view.height <= 0)
            return;

        Qt.callLater(function () {
            if (window.pendingPageIndex < 0 || window.showLibrary || pdfDocument.status !== PdfDocument.Ready || readerPage.view.width <= 0 || readerPage.view.height <= 0)
                return;

            const targetPage = Math.min(window.pendingPageIndex, pdfDocument.pageCount - 1);
            window.pendingPageIndex = -1;
            readerPage.view.goToPage(Math.max(0, targetPage));
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
            window.openDocument(fileUrl);
        }
    }

    ReaderPage {
        id: readerPage

        anchors.fill: parent

        readerBackground: appSettings.theme ? window.reallyLight : window.reallyDark
        readerTextColor: appSettings.theme ? window.dark : window.light

        visible: !window.showLibrary

        currentDocument: pdfDocument
        lightMode: appSettings.theme

        searchText: readerToolbar.searchText

        panelVisible: window.panelVisible
        dark: window.dark
        light: window.light

        onThemeToggleRequested: window.lightMode = !window.lightMode
        onViewportChanged: window.restorePageIfReady()

        onReadingPageChanged: function (pageIndex) {
            if (pageIndex < 0)
                return;

            readerFooter.pageValue = pageIndex + 1;
            if (!window.restoringLastPage && window.activeDocumentId >= 0) {
                library.saveReadingProgress(window.activeDocumentId, pageIndex);
            }
        }
    }

    footer: ReaderFooter {
        id: readerFooter
        visible: !window.showLibrary
        pageCount: pdfDocument.pageCount

        documentReady: pdfDocument.status === PdfDocument.Ready

        onPageRequested: function (pageIndex) {
            readerPage.view.goToPage(pageIndex);
        }

        onFitWidthRequested: readerPage.view.scaleToWidth(readerPage.view.width, readerPage.view.height)
    }
    WindowResizeFrame {
        parent: Overlay.overlay
        anchors.fill: parent
        appWindow: window
    }
}
