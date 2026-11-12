import QtQuick

MouseArea {
    id: root

    required property var appWindow
    property int resizeEdges: Qt.TopEdge | Qt.RightEdge

    implicitWidth: 12
    implicitHeight: 12
    cursorShape: Qt.SizeBDiagCursor

    enabled: root.appWindow.visibility === Window.Windowed

    onPressed: {
        root.appWindow.startSystemResize(resizeEdges);
    }
}
