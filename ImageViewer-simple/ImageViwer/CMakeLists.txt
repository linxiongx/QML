cmake_minimum_required(VERSION 3.16)

project(ImageViwer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appImageViwer
    main.cpp
)

qt_add_qml_module(appImageViwer
    URI ImageViwer
    VERSION 1.0
    QML_FILES

        QML_FILES
        images/baseline-menu-24px.svg
        QML_FILES ImageViewerWindow.qml
        QML_FILES MainFile.qml
        QML_FILES +android/MainFile.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appImageViwer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appImageViwer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appImageViwer
    PRIVATE Qt6::Quick  Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appImageViwer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

