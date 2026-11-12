import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: root
    required property var appWindow
    implicitHeight: 40
    color: "#191817"

    RowLayout {
        anchors.fill: parent
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

        ToolButton {
            text: "—"
            onClicked: root.appWindow.showMinimized()
        }

        ToolButton {
            text: root.appWindow.visibility === Window.Maximized ? "❐" : "□"
            onClicked: {
                if (root.appWindow.visibility === Window.Maximized)
                    root.appWindow.showNormal();
                else
                    root.appWindow.showMaximized();
            }
        }

        ToolButton {
            text: "×"
            onClicked: root.appWindow.close()
        }
    }

}
