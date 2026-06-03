# 聆书 charavox

多角色分音色有声书阅读器。LLM 自动识别小说角色，AI 生成独特音色——打开 EPUB，等待片刻，听到一本广播剧。

## 功能

- 导入 EPUB / TXT 小说
- LLM 自动分析角色（中日文小说）
- 多角色分音色 TTS 朗读
- 播放控制（倍速、跳转、章节导航）
- 阅读进度自动保存

## 快速开始

### 安装

```bash
# Arch Linux (AUR)
yay -S flutter
cd charavox
flutter pub get
flutter run -d linux
```

### 配置 API

首次启动需配置 LLM 和 TTS API Key：
- 阿里云百炼（推荐）：[注册获取 API Key](https://dashscope.aliyun.com)
- 火山引擎 / DeepSeek / MiniMax 同样支持
- 或使用本地 Ollama + Docker TTS（隐私模式，无需 API Key）

## 开发

```bash
flutter pub get
flutter run -d linux
flutter test
flutter analyze
flutter build linux
```

## 许可证

GPL v3

## 仓库

https://github.com/Mr-Though/charavox
