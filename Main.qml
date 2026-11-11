import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Pdf
import QtQuick.Dialogs
import QtCore

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Hello World!!!")

    Settings {
        id: appSettings
        property alias lastPdf: pdfDocument.source
        property int lastPage: 1
        property alias width: window.width
        property alias height: window.height
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
                var documentId = library.registerDocument(pdfDocument.source);

                if (documentId >= 0) {
                    console.log("Documento registrado. ID: ", documentId);
                }

                Qt.callLater(function () {
                    var targetPage = Math.min(appSettings.lastPage - 1, pdfDocument.pageCount - 1);

                    pdfView.goToPage(Math.max(0, targetPage));
                    window.restoringLastPage = false;
                });
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
            pdfDocument.source = selectedFile;
        }
    }

    header: ToolBar {
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

    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"
    property bool panelVisible: true
    property bool restoringLastPage: true

    RowLayout {
        id: grid
        spacing: 0
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            color: window.lightMode ? window.reallyLight : window.reallyDark
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                // Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Label {
                    visible: pdfDocument.status === PdfDocument.Null
                    text: qsTr("Open a PDF to Begin")
                    color: window.lightMode ? window.dark : window.light
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    visible: pdfDocument.status === PdfDocument.Loading
                    text: qsTr("Loading PDF…")
                    color: window.lightMode ? window.dark : window.light
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    visible: pdfDocument.status === PdfDocument.Error
                    text: qsTr("Could not load PDF: %1").arg(pdfDocument.error)
                    color: window.lightMode ? window.dark : window.light
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
                    // TODO: resolver issue #2
                    onCurrentPageChanged: {
                        if (currentPage >= 0) {
                            pageNumber.value = currentPage + 1;

                            if (!window.restoringLastPage)
                                appSettings.lastPage = currentPage + 1;
                        }
                    }
                    searchString: searchField.text
                }
            }
        }

        NotesPanel {
            selectedText: pdfView.selectedText
            pdfViewer: pdfView
            textColor: window.lightMode ? window.dark : window.light
            lightMode: window.lightMode
            light: window.light
            dark: window.dark
            visible: window.panelVisible
            onThemeToggleRequested: window.lightMode = !window.lightMode
        }
    }

    footer: ToolBar {
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
}
