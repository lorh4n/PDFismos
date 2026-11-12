import QtQuick

Item {
    id: frame

    required property var appWindow
    readonly property int cornerSize: 12
    readonly property int edgeSize: 8

    WindowResizeHandle {
        anchors.top: parent.top
        anchors.left: parent.left
        width: frame.cornerSize
        height: frame.cornerSize
        appWindow: frame.appWindow
        resizeEdges: Qt.TopEdge | Qt.LeftEdge
        cursorShape: Qt.SizeFDiagCursor
    }

    WindowResizeHandle {
        anchors.top: parent.top
        anchors.right: parent.right
        width: frame.cornerSize
        height: frame.cornerSize
        appWindow: frame.appWindow
        resizeEdges: Qt.TopEdge | Qt.RightEdge
        cursorShape: Qt.SizeBDiagCursor
    }

    WindowResizeHandle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: frame.cornerSize
        height: frame.cornerSize
        appWindow: frame.appWindow
        resizeEdges: Qt.BottomEdge | Qt.LeftEdge
        cursorShape: Qt.SizeBDiagCursor
    }

    WindowResizeHandle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: frame.cornerSize
        height: frame.cornerSize
        appWindow: frame.appWindow
        resizeEdges: Qt.BottomEdge | Qt.RightEdge
        cursorShape: Qt.SizeFDiagCursor
    }

    WindowResizeHandle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: frame.cornerSize
        anchors.rightMargin: frame.cornerSize
        height: frame.edgeSize
        appWindow: frame.appWindow
        resizeEdges: Qt.TopEdge
        cursorShape: Qt.SizeVerCursor
    }

    WindowResizeHandle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: frame.cornerSize
        anchors.rightMargin: frame.cornerSize
        height: frame.edgeSize
        appWindow: frame.appWindow
        resizeEdges: Qt.BottomEdge
        cursorShape: Qt.SizeVerCursor
    }

    WindowResizeHandle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: frame.cornerSize
        anchors.bottomMargin: frame.cornerSize
        width: frame.edgeSize
        appWindow: frame.appWindow
        resizeEdges: Qt.LeftEdge
        cursorShape: Qt.SizeHorCursor
    }

    WindowResizeHandle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: frame.cornerSize
        anchors.bottomMargin: frame.cornerSize
        width: frame.edgeSize
        appWindow: frame.appWindow
        resizeEdges: Qt.RightEdge
        cursorShape: Qt.SizeHorCursor
    }
}
