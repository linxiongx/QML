# 建议命令

## 构建和运行
- 构建：mkdir build && cd build && cmake .. && cmake --build . (Windows 使用 MinGW)。
- 运行：build/Desktop_Qt_6_9_1_MinGW_64_bit-Debug/appZYYMusic.exe (调整路径)。

## 代码检查和测试
- 无 linting/测试脚本。无配置，任务完成后可手动验证 UI 通过运行应用。
- Qt linter：qmllint (若 Qt Creator 中运行)，但项目无自定义规则。

## 实用命令 (Windows)
- dir (ls 等价：列出文件)。
- cd (变更目录)。
- git status (当前状态)。
- git add . && git commit -m "消息" (提交)。
- git push (推送)。
- findstr (grep 等价：搜索字符串)。
- type (cat 等价：查看文件)。