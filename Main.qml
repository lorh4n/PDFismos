import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Pdf

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Hello World!!!")
    Shortcut {
        sequence: "Esc"
        onActivated: window.panelVisible = false
    }


    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: qsTr("Abrir PDF")
                onClicked: console.log("Abrir PDF Foi clicked")
            }

            TextField {
                placeholderText: qsTr("Buscar no documento")
                Layout.fillWidth: true
                onAccepted: console.log("Busca: " + text)
            }

            ToolButton {
                text: "-"
                onClicked: {
                    if (window.zoomPercent > 50)
                        window.zoomPercent -= 10
                }
            }
            Label { text: window.zoomPercent + "%" }
            ToolButton {
                text: "+"
                onClicked: {
                    if (window.zoomPercent < 200)
                        window.zoomPercent += 10
                }
            }
            ToolButton {
                text: window.panelVisible
                      ? qsTr("Ocultar painel")
                      : qsTr("Mostrar painel")
                onClicked: window.panelVisible = !window.panelVisible
            }
        }
    }

    property int zoomPercent: 100
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"
    property bool panelVisible: true

    GridLayout {
        id: grid
        columns: width < 400 || !window.panelVisible ? 1 : 2
        rowSpacing: 0
        columnSpacing: 0
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            color: window.lightMode ? window.reallyLight : window.reallyDark
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                Label {
                    id: text1
                    color: window.lightMode ? window.dark : window.light
                    font.pixelSize: 36
                    fontSizeMode: Text.Fit
                    text: qsTr("Nenhum PDF aberto")
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: rectangle2
            color: window.lightMode ? window.light : window.dark
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: window.panelVisible

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                Label {
                    text: qsTr("Notas e tradução")
                    color: window.lightMode ? window.dark : window.light
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.margins: 16
                }

                Label {
                    text: qsTr("As notas e traduções aparecerão aqui.")
                    color: window.lightMode ? window.dark : window.light
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                }

                Item { Layout.fillHeight: true }

                Button {
                    id: button1
                    text: window.lightMode ? qsTr("\u263D  Dark mode")
                                           : qsTr("\u263C  Light mode")
                    Layout.bottomMargin: 16
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                    contentItem: Text {
                        text: button1.text
                        color: window.lightMode ? window.light : window.dark
                        font: button1.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 36
                        radius: 8
                        color: window.lightMode ? window.dark : window.light
                    }

                    onClicked: window.lightMode = !window.lightMode
                }
            }
        }
    }

}
