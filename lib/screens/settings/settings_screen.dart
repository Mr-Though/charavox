import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/providers/settings_provider.dart';
import 'package:charavox/models/api_config_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _llmUrl = TextEditingController();
  final _llmKey = TextEditingController();
  final _llmModel = TextEditingController();
  final _ttsUrl = TextEditingController();
  final _ttsKey = TextEditingController();
  final _ttsModel = TextEditingController();
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    final config = ref.read(settingsProvider);
    if (config != null) {
      _llmUrl.text = config.llmBaseUrl;
      _llmKey.text = config.llmApiKey;
      _llmModel.text = config.llmModel;
      _ttsUrl.text = config.ttsBaseUrl;
      _ttsKey.text = config.ttsApiKey;
      _ttsModel.text = config.ttsModel;
    }
  }

  @override
  void dispose() {
    _llmUrl.dispose();
    _llmKey.dispose();
    _llmModel.dispose();
    _ttsUrl.dispose();
    _ttsKey.dispose();
    _ttsModel.dispose();
    super.dispose();
  }

  void _applyPreset(String llmPreset) {
    ref.read(settingsProvider.notifier).applyPreset(
          llmPreset: llmPreset,
          ttsPreset: '阿里云百炼',
        );
    _loadConfig();
  }

  Future<void> _save() async {
    final config = ApiConfig(
      llmBaseUrl: _llmUrl.text.trim(),
      llmApiKey: _llmKey.text.trim(),
      llmModel: _llmModel.text.trim(),
      ttsBaseUrl: _ttsUrl.text.trim(),
      ttsApiKey: _ttsKey.text.trim(),
      ttsModel: _ttsModel.text.trim(),
    );
    await ref.read(settingsProvider.notifier).save(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('配置已保存')),
      );
    }
  }

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    await _save();
    final error = await ref.read(settingsProvider.notifier).testConnection();
    setState(() => _testing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error == null ? '连接测试通过' : '连接失败: $error'),
        backgroundColor: error == null ? Colors.green : Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API 配置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('快速预设', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ApiPresets.llmPresets.keys.map((name) {
              return ActionChip(
                label: Text(name),
                onPressed: () => _applyPreset(name),
              );
            }).toList(),
          ),
          const Divider(height: 32),
          Text('LLM 配置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _llmUrl,
            decoration: const InputDecoration(labelText: 'Base URL'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _llmKey,
            decoration: const InputDecoration(labelText: 'API Key'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _llmModel,
            decoration: const InputDecoration(labelText: 'Model'),
          ),
          const Divider(height: 32),
          Text('TTS 配置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsUrl,
            decoration: const InputDecoration(labelText: 'Base URL'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsKey,
            decoration: const InputDecoration(labelText: 'API Key'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsModel,
            decoration: const InputDecoration(labelText: 'Model'),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存配置'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _testing ? null : _testConnection,
                  child: _testing
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('测试连接'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
