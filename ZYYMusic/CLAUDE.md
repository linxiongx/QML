# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Run

To build the project (requires Qt 6.8 or later with MinGW 64-bit on Windows, CMake 3.16+):

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

To run the application (example for Debug build in Qt Creator on Windows):

```bash
build/Desktop_Qt_6_9_1_MinGW_64_bit-Debug/appZYYMusic.exe
```

For Release build, adjust the path accordingly (e.g., replace 'Debug' with 'Release').

No linting, type checking, or testing scripts are configured. No single test run available.

## Architecture

ZYYMusic is a Qt Quick desktop music player with declarative QML UI and minimal C++ backend.

- **Initialization**: `main.cpp` sets up `QGuiApplication`, configures Fusion style via `qputenv("QT_QUICK_CONTROLS_STYLE", "Fusion")`, and loads the QML module "ZYYMusic" (version 1.0) from `Main.qml` using `QQmlApplicationEngine`. `BasicConfig` is a QML singleton for configuration and emitting signals like openLoginPopup.

- **Core UI**:
  - `Main.qml`: Root using `ZYYWindow`, left navigation `LeftPage.qml`, right dynamic content `RightPage.qml` with title `TitlePage.qml` and `MinMax.qml`, bottom player `PlayMusic.qml`, and login popups from `mainPopups/`.
  - `RightPage.qml`: Uses StackView for dynamic pages including `Search.qml`, `CloudMusic.qml` (initial for online music), `OthersPage.qml`, `Setting.qml` (subpages: `Play.qml`, `SystemConfig.qml`, `SoundAndDownload.qml`, `ShortCut.qml`, `Counter.qml`, `Standard.qml`, `MessagingPrivacy.qml`, `DesktopLyrics.qml`).

- **Playback**: `PlayMusic/PlayMusic.qml` for bottom controls and display.

- **Reusable Components**: `CommonUI/` with `ZYYWindow.qml`, `ZYYSearchBox.qml`, `ZYYComboBox.qml`, `ZYYRadioButton.qml`, `ZYYCheckBox.qml`, `ZYYShotcutTextField.qml`, `TextFiledCtrl.qml`, `ZYYDowloadFolderDialog.qml`.

- **Dialogs**: `mainPopups/` for `LoginPopup.qml` and `LoginByOtherMainsPopup.qml`, centered in `Main.qml`.

- **Configuration**: `Basic/BasicConfig.qml` singleton for settings like colors and signals.

- **Resources**: `res.qrc` bundles assets from `Res/` (images for UI elements like login, icons).

All QML files are registered in `CMakeLists.txt` for the executable `appZYYMusic`. No custom C++ classes; UI and logic are primarily QML-based, focusing on music search, playback, settings, and cloud integration.

## From README.md

The README features UI screenshots demonstrating the music player interface, playback controls, search, settings, and login screens.

## Response Language

***除非有特殊说明，请用中文回答。*** (Unless otherwise specified, please respond in Chinese.)