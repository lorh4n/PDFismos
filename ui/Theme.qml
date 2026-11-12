pragma Singleton
import QtQuick

QtObject {
    id: theme
    // UI - WINDOW
    readonly property color titleBarBackground: "#161514"
    readonly property color windowControlText: "#B8B6B3"
    readonly property color windowControlHover: "#343230"
    readonly property color windowCloseHover: "#E84B5C"

    // TitleBar
    readonly property color libraryTabActive: "#EFECE6"

    readonly property color background: "#E4E3E6"
    readonly property color surface: "#F0EFF1"
    readonly property color textPrimary: "#1A1918"
    readonly property color textSecondary: "#4B4844"
    readonly property color accent: "#EDF57A"
    readonly property color accentPressed: "#C9D63E"
    readonly property color paper: "#FAF8F3"

    // FONTS

    readonly property FontLoader mainFont: FontLoader {
        id: fontLoader

        source: "../assets/fonts/space-grotesk/SpaceGrotesk.ttf"

        onStatusChanged: {
            if (fontLoader.status === FontLoader.Ready)
                console.log("Font Carregada: ", fontLoader.name);
            else if (fontLoader.status === FontLoader.Error)
                console.warn("Não foi possivel carregar a fonte principal");
        }
        Component.onCompleted: {
            console.log("Fonte pronta:", fontLoader.status === FontLoader.Ready, "família:", fontLoader.name);
        }
    }

    readonly property string fontFamily: theme.mainFont.name
}
