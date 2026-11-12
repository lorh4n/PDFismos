import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import PDFismos

Rectangle {
    id: root
    required property var appWindow
    required property real cornerRadius
    required property bool documentAvailable
    required property string documentTitle

    signal documentRequested

    topLeftRadius: root.cornerRadius
    topRightRadius: root.cornerRadius

    implicitHeight: 46
    color: Theme.titleBarBackground

    signal libraryRequested

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 4
        anchors.bottomMargin: 0
        spacing: 4

        AppLogo {}

        //  Botão Biblioteca
        Label {
            text: qsTr("Biblioteca")

            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignBottom

            leftPadding: 40
            rightPadding: 14
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: 13
            font.weight: Font.DemiBold

            color: root.appWindow.showLibrary ? Theme.textPrimary : Theme.windowControlText

            // Fundo da aba inteira
            background: Rectangle {
                color: root.appWindow.showLibrary ? Theme.libraryTabActive : "transparent"

                topLeftRadius: 12
                topRightRadius: 12
            }

            // Quadrado atrás do ícone
            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                width: 20
                height: 20
                radius: 6

                color: root.appWindow.showLibrary ? Theme.titleBarBackground : "transparent"

                Image {
                    anchors.centerIn: parent

                    width: 15
                    height: 15

                    source: "Title Bar/assets/library.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            // Action
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.libraryRequested();
                    console.log("Navegando para Biblioteca");
                }
            }
        }
        TitleBarTab {
            visible: root.documentAvailable
            text: root.documentTitle
            active: !root.appWindow.showLibrary

            Layout.preferredHeight: 36
            Layout.maximumWidth: 200
            Layout.alignment: Qt.AlignBottom

            onClicked: root.documentRequested()
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    console.log("Arrea de Arraste: ", width, height);
                    root.appWindow.startSystemMove();
                }
            }
        }

        WindowControl {
            icon.source: "Title Bar/assets/minimize.svg"

            onClicked: root.appWindow.showMinimized()
        }

        WindowControl {
            icon.source: root.appWindow.visibility === Window.Maximized ? "Title Bar/assets/restore.svg" : "Title Bar/assets/maximize.svg"
            onClicked: {
                if (root.appWindow.visibility === Window.Maximized)
                    root.appWindow.showNormal();
                else
                    root.appWindow.showMaximized();
            }
        }

        WindowControl {
            icon.source: "Title Bar/assets/close.svg"

            closeAction: true
            onClicked: root.appWindow.close()
        }
    }
}
