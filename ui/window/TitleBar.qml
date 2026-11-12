import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import PDFismos

Rectangle {
    id: root
    required property var appWindow
    required property real cornerRadius

    topLeftRadius: root.cornerRadius
    topRightRadius: root.cornerRadius

    implicitHeight: 46
    color: Theme.titleBarBackground

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 4

        Label {
            text: "E"
            color: "#191817"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.preferredWidth: 40
            Layout.fillHeight: true
            background: Rectangle {
                color: "#EDF57A"
                radius: 10
            }
        }

        Label {
            text: "PDFismos"
            color: "white"
            leftPadding: 8
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
            icon.source: "Title Bar/minimize.svg"

            onClicked: root.appWindow.showMinimized()
        }

        WindowControl {
            icon.source: root.appWindow.visibility === Window.Maximized ? "Title Bar/restore.svg" : "Title Bar/maximize.svg"
            onClicked: {
                if (root.appWindow.visibility === Window.Maximized)
                    root.appWindow.showNormal();
                else
                    root.appWindow.showMaximized();
            }
        }

        WindowControl {
            icon.source: "Title Bar/close.svg"

            closeAction: true
            onClicked: root.appWindow.close()
        }
    }
}
