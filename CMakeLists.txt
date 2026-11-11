cmake_minimum_required(VERSION 3.16)

project(PDFismos VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Pdf Sql)

qt_standard_project_setup(REQUIRES 6.10)

# # Content of downloaded design from Figma to Qt or similar
# if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
#     add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
# endif()

qt_add_executable(appPDFismos
    main.cpp
    storage/LibraryDatabase.cpp
    storage/LibraryController.h
    storage/LibraryController.cpp
)

set_source_files_properties(ui/Theme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appPDFismos
    URI PDFismos
    QML_FILES
        Main.qml
        NotesPanel.qml
        TitleBar.qml
        ui/Theme.qml
        ui/pages/LibraryPage.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPDFismos PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPDFismos
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPDFismos
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Pdf
    PRIVATE Qt6::Sql
)

install(TARGETS appPDFismos
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
