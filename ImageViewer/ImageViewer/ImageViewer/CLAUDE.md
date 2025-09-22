# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Qt 6 QML-based image viewer application built with CMake. The application provides image viewing capabilities with features like zooming, panning, slide show functionality, and various tool buttons.

## Architecture

- **Frontend**: QML-based UI with custom components
- **Backend**: C++ classes for image processing and slide functionality
- **Build System**: CMake with Qt 6 integration

Key components:
- `Main.qml`: Main application window and UI layout
- Custom QML components: Various tool buttons (MyToolButton, SlideToolButton, etc.)
- `CSlide` class (cslide.h/cpp): Handles image slide show functionality
- Resource files in `res/` directory

## Development Commands

### Build Commands
```bash
# Configure and build with CMake
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .

# Or using Qt Creator for development
```

### Run Application
```bash
# After building, run the executable
./build/appImageViewer.exe
```

### Clean Build
```bash
rm -rf build/
```

## Key Files

- `CMakeLists.txt`: Main build configuration
- `main.cpp`: Application entry point
- `cslide.h/cpp`: C++ backend for slide functionality
- `Main.qml`: Primary QML interface
- Various `*ToolButton.qml`: Custom UI components

## Qt/QML Development

- Uses Qt 6.5+ with Quick module
- QML modules registered via `qmlRegisterType`
- Custom properties and signals for QML-C++ integration
- Image handling with drag-and-drop support

## Image Support

Supported formats: JPG, PNG, GIF
Features: Zoom, pan, slide show (sequential/random), image info display

## C++/QML Integration

- `CSlide` class registered as QML type "org.example.cslide"
- Q_INVOKABLE methods for QML-C++ communication
- Properties with NOTIFY signals for data binding
- Image path processing with file system operations

## 语言规范

- 所有对话和文档都使用中文
- 文档使用 markdown 格式