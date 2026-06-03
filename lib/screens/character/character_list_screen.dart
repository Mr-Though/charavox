import 'package:flutter/material.dart';
import 'package:charavox/models/character.dart';

class CharacterListScreen extends StatelessWidget {
  final List<CharacterInfo> characters;
  final VoidCallback? onReanalyze;

  const CharacterListScreen({
    super.key,
    required this.characters,
    this.onReanalyze,
  });

  @override
  Widget build(BuildContext context) {
    final nonNarrator =
        characters.where((c) => !c.isNarrator).toList();
    final narrator = characters.where((c) => c.isNarrator).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text('角色管理 (${nonNarrator.length} 个)'),
        actions: [
          if (onReanalyze != null)
            TextButton.icon(
              onPressed: onReanalyze,
              icon: const Icon(Icons.refresh),
              label: const Text('重新分析'),
            ),
        ],
      ),
      body: ListView(
        children: [
          ...nonNarrator.map((c) => _CharacterTile(character: c)),
          if (narrator != null) ...[
            const Divider(),
            _CharacterTile(character: narrator, isNarrator: true),
          ],
        ],
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  final CharacterInfo character;
  final bool isNarrator;

  const _CharacterTile({required this.character, this.isNarrator = false});

  @override
  Widget build(BuildContext context) {
    final genderIcon = switch (character.gender) {
      Gender.male => Icons.male,
      Gender.female => Icons.female,
      Gender.unknown => Icons.person,
    };

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isNarrator
            ? Colors.grey
            : Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          isNarrator ? Icons.volume_up : genderIcon,
          color: isNarrator
              ? Colors.white
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Row(
        children: [
          Text(character.canonicalName),
          if (character.aliases.isNotEmpty)
            Text(' (${character.aliases.join(", ")})',
                style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${character.age.name} · ${character.gender.name}'),
          Text(character.voicePrompt, maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      isThreeLine: true,
    );
  }
}
