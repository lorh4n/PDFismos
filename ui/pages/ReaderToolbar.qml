import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ToolBar {

    id: root
    
    required property var pdfView
    required property var panelVisible
    property alias searchText: searchField.text


    signal openRequested
    signal panelToggleRequested
    

  

    RowLayout {
        anchors.fill: parent

        ToolButton {
            text: qsTr("Abrir PDF")
            onClicked: {
                console.log("Abrir PDF Foi clicked");
                root.openRequested()
            }
        }

        TextField {
            id: searchField
            placeholderText: qsTr("Buscar no documento")
            Layout.fillWidth: true
            onAccepted: {
                if (root.pdfView.searchModel.count > 0) {
                    root.pdfView.searchForward();
                }
            }
        }
        ToolButton {
            text: "↑"
            enabled: root.pdfView.searchModel.count > 0
            onClicked: root.pdfView.searchBack()
        }

        ToolButton {
            text: "↓"
            enabled: root.pdfView.searchModel.count > 0
            onClicked: root.pdfView.searchForward()
        }

        ToolButton {
            text: "-"
            onClicked: {
                root.pdfView.renderScale = Math.max(0.5, root.pdfView.renderScale - 0.1);
            }
        }
        Label {
            text: Math.round(root.pdfView.renderScale * 100) + "%"
        }
        ToolButton {
            text: "+"
            onClicked: {
                root.pdfView.renderScale = Math.min(2.0, root.pdfView.renderScale + 0.1);
            }
        }
        ToolButton {
            text: root.panelVisible ? qsTr("Ocultar painel") : qsTr("Mostrar painel")
            onClicked: root.panelToggleRequested()
        }
    }
}
