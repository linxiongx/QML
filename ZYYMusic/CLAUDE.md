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
build/[build-kit]/appZYYMusic.exe
```

For Release build, adjust the path accordingly (e.g., replace 'Debug' with 'Release', and update the build-kit name as per your Qt version and compiler, such as Desktop_Qt_6_9_1_MinGW_64_bit-Debug).

No linting, type checking, or testing scripts are configured. No single test run available. No testing framework (e.g., QTest) or linting tools (e.g., clang-format) are set up in CMakeLists.txt or elsewhere.

## Architecture

ZYYMusic is a Qt Quick desktop music player with declarative QML UI and minimal C++ backend.

- **Initialization**: `main.cpp` sets up `QGuiApplication`, configures Fusion style via `qputenv("QT_QUICK_CONTROLS_STYLE", "Fusion")`, registers `BasicConfig.qml` as a singleton in the "Basic" module, and loads the QML module "ZYYMusic" (version 1.0) from `Main.qml` using `QQmlApplicationEngine`. `BasicConfig` is a QML singleton for configuration, including color schemes for lyrics and signals like `openLoginPopup` and `blankAreaClicked`.

- **Core UI**:
  - `Main.qml`: Root using `ZYYWindow` (a custom window component), with left navigation `LeftPage.qml`, right dynamic content `RightPage.qml` including title `TitlePage.qml` and minimize/maximize `MinMax.qml`, bottom player `PlayMusic.qml` (height 100), and centered login popups from `mainPopups/` connected to `BasicConfig` signals.
  - `RightPage.qml`: Contains `TitlePage` at the top (height 60) and a `StackView` for dynamic pages, with initial item `CloudMusic.qml` for online music display; the StackView has a bottom margin of 100 to accommodate the player. Supported pages include `Search.qml`, `CloudMusic.qml`, `OthersPage.qml`, `Setting.qml` (with subpages: `Play.qml`, `SystemConfig.qml`, `SoundAndDownload.qml`, `ShortCut.qml`, `Counter.qml`, `Standard.qml`, `MessagingPrivacy.qml`, `DesktopLyrics.qml`), and additional stack pages like `Featured.qml`, `PlaylistSquare.qml`, `Rankings.qml`, `Artists.qml`.
  - `CloudMusic.qml`: Implements tabs ("精选", "歌单广场", "排行榜", "歌手") using Flow and StackLayout with Loaders for the above additional pages, suggesting a cloud music hub (e.g., NetEase integration).

- **Playback**: `PlayMusic/PlayMusic.qml` provides bottom controls and display for music playback, positioned at the bottom of the main window. Currently minimal (basic Rectangle); actual playback logic likely requires QtMultimedia integration or C++ backend for audio handling, playlist management, and progress controls. No current implementation for play/pause/seek or media sources.

- **Cloud Integration**: Cloud music features centered on `CloudMusic.qml` tabs, implying NetEase Cloud Music API usage (based on res.qrc icons for NetEase, QQ Music, etc.). Pages like Featured.qml (recommendations), PlaylistSquare.qml (playlists), Rankings.qml (charts), Artists.qml (singers) are placeholders/loaders. Integration would involve network requests for search, authentication (via login popups), and data binding to UI lists. No API endpoints or HTTP clients visible in current QML; potential future expansion with QtNetwork or C++.

- **Reusable Components**: `CommonUI/` includes custom controls such as `ZYYWindow.qml` (custom window), `ZYYSearchBox.qml`, `ZYYComboBox.qml`, `ZYYRadioButton.qml`, `ZYYCheckBox.qml`, `ZYYShotcutTextField.qml`, `TextFiledCtrl.qml`, and `ZYYDowloadFolderDialog.qml` for download folder selection.

- **Dialogs**: `mainPopups/` contains `LoginPopup.qml` (QR code or credential login) and `LoginByOtherMainsPopup.qml` (third-party login, e.g., QQ, Weibo, WeChat, NetEase), both anchored to the center of `Main.qml`.

- **Configuration**: `Basic/BasicConfig.qml` singleton manages global settings, including readonly properties for text colors and fonts, dynamic color schemes for finished/unfinished lyrics (with gradients and borders), background color, and signals for UI events like opening login popups.

- **Resources**: `res.qrc` bundles assets under the `/Image` prefix from `Res/`, including UI icons (close, mirror, search, etc.), login assets (QR code, flags, eye icons, social logins like QQ, NetEase, Weibo, WeChat), and playback images (album covers as JPGs).

All QML files are explicitly listed and registered in `CMakeLists.txt` for the executable `appZYYMusic`. No custom C++ classes beyond the basic application setup; UI and logic are primarily QML-based, emphasizing music search, cloud music integration (e.g., NetEase), playback controls, comprehensive settings (including desktop lyrics and shortcuts), and user authentication.

## Recent Changes

Recent git status indicates additions like images in Res/PlayMusic/Image/ (1.jpg to 7.jpg, likely album covers), modifications to Setting.qml, DesktopLyrics.qml, CloudMusic.qml, and new/untracked stack pages (Featured.qml, PlaylistSquare.qml, Rankings.qml, Artists.qml) for cloud music tabs. These expand online music discovery but remain as basic loaders without full logic.

## From README.md

The README features UI screenshots demonstrating the music player interface (main window with navigation and content), playback controls (bottom player with album art), search functionality, settings panels (including desktop lyrics and system config), and login screens (QR code and third-party options). It is image-only with no textual descriptions, installation guides, or feature lists.

## Response Language

***除非有特殊说明，请用中文回答。*** (Unless otherwise specified, please respond in Chinese.)