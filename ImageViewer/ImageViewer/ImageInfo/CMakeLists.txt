cmake_minimum_required(VERSION 3.16)

project(ImageInfo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_OUTPUT_DIRECTORY  ${CMAKE_BINARY_DIR})

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_qml_module(ImageInfo
    URI org.example.myplugins
    VERSION 1.0
    QML_FILES ImageInfoControls.qml
    SOURCES
    SOURCES imageinfo.h imageinfo.cpp
    SOURCES myextensionplugins.h myextensionplugins.cpp
    SOURCES imageinfostruct.h
    SOURCES imageinfostruct.cpp
)

set_target_properties(ImageInfo PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(ImageInfo
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(ImageInfo
    PRIVATE Qt6::Quick)

target_include_directories(ImageInfo PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

