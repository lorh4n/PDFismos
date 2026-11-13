import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ToolBar {
   id: root


   required property int pageCount
   required property bool documentReady
   property alias pageValue: pageNumber.value

   signal pageRequested(int pageIndex)
   signal fitWidthRequested

    RowLayout {
        anchors.fill: parent

        Label {
            text: qsTr("Page")
        }

        SpinBox {
            id: pageNumber
            from: 1
            to: Math.max(1, root.pageCount)
            value: 1
            editable: true
            enabled: root.documentReady
            onValueModified: root.pageRequested(value - 1)
        }

        Label {
            text: qsTr("of %1").arg(root.pageCount)
        }

        Item {
            Layout.fillWidth: true
        }

        ToolButton {
            text: qsTr("Fit Width")
            enabled: root.documentReady
            onClicked: root.fitWidthRequested()
        }
    }
}
