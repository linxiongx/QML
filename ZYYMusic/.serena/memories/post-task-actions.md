# 任务完成后行动

- 构建并运行应用验证变更：cd build && cmake --build . && ./appZYYMusic.exe。
- 检查 git 状态：git status，添加/提交变更。
- 无自动 linting/testing，人工检查 QML UI 和逻辑。
- 若修改 QML，更新 CMakeLists.txt 若新文件，重新构建。