cmake_minimum_required(VERSION 3.16)

project(ImageViewer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appImageViewer
    main.cpp
)

qt_add_qml_module(appImageViewer
    URI ImageViewer
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES MyToolButton.qml
        RESOURCES res/favicon.ico
        QML_FILES LockerToolButton.qml
        QML_FILES ScanToolButton.qml
        QML_FILES SlideToolButton.qml
        QML_FILES BookmarksToolButton.qml
        QML_FILES EditToolButton.qml
        QML_FILES CopyToolButton.qml
        RESOURCES res/ok.png
        QML_FILES MyMenuItem.qml
        QML_FILES MyImageInfo.qml
        QML_FILES FilmStrip.qml
        SOURCES cslide.h cslide.cpp undomanager.h undomanager.cpp
        QML_FILES RotateToolButton.qml
        QML_FILES MyToolBar.qml
        QML_FILES Viewer.qml
        QML_FILES ImageAnimations.qml
        QML_FILES ZoomIndicator.qml
        QML_FILES KeyboardShortcuts.qml
        QML_FILES CropSelection.qml
        QML_FILES ImageViewer.qml
        RESOURCES res/app.png
        RESOURCES res/skin.png
        RESOURCES res/skin_black.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appImageViewer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appImageViewer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appImageViewer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appImageViewer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
