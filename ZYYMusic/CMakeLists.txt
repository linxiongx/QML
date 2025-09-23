cmake_minimum_required(VERSION 3.16)

project(ZYYMusic VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_AUTORCC ON)

qt_add_executable(appZYYMusic
    main.cpp res.qrc
)

qt_add_qml_module(appZYYMusic
    URI ZYYMusic
    VERSION 1.0
    QML_FILES
        Main.qml
        RightPage/RightPage.qml
        RightPage/TitlePage.qml
        RightPage/MinMax.qml
        RightPage/OthersPage.qml
        LeftPage/LeftPage.qml
        PlayMusic/PlayMusic.qml
        CommonUI/ZYYWindow.qml

    RESOURCES
        res.qrc
        QML_FILES RightPage/Search.qml
        QML_FILES CommonUI/ZYYSearchBox.qml
        QML_FILES Basic/BasicConfig.qml
        QML_FILES mainPopups/LoginPopup.qml
        QML_FILES mainPopups/LoginByOtherMainsPopup.qml
        QML_FILES CommonUI/TextFiledCtrl.qml
        QML_FILES CommonUI/ZYYCheckBox.qml
        QML_FILES RightPage/StackPages/CloudMusic.qml
        QML_FILES RightPage/StackPages/Setting.qml
        QML_FILES RightPage/StackPages/SettingItem/Counter.qml
        QML_FILES RightPage/StackPages/SettingItem/Standard.qml
        QML_FILES CommonUI/ZYYComboBox.qml
        QML_FILES CommonUI/ZYYRadioButton.qml
        QML_FILES RightPage/StackPages/SettingItem/SystemConfig.qml
        QML_FILES RightPage/StackPages/SettingItem/Play.qml
        QML_FILES RightPage/StackPages/SettingItem/MessagingPrivacy.qml
        QML_FILES CommonUI/ZYYShotcutTextField.qml
        QML_FILES RightPage/StackPages/SettingItem/ShortCut.qml
        QML_FILES RightPage/StackPages/SettingItem/SoundAndDownload.qml
        QML_FILES RightPage/StackPages/SettingItem/DesktopLyrics.qml
        QML_FILES CommonUI/ZYYDowloadFolderDialog.qml
        QML_FILES RightPage/StackPages/Featured.qml
        QML_FILES RightPage/StackPages/PlaylistSquare.qml
        QML_FILES RightPage/StackPages/Rankings.qml
        QML_FILES RightPage/StackPages/Artists.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appZYYMusic PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appZYYMusic
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appZYYMusic
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appZYYMusic
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
