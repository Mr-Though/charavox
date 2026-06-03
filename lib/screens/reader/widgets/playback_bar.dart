import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/providers/playback_provider.dart';

class PlaybackBar extends ConsumerWidget {
  const PlaybackBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackProvider);
    final notifier = ref.read(playbackProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.currentCharacter != null)
            Text(
              '现在: ${state.currentCharacter!.canonicalName}',
              style: Theme.of(context).textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: state.progress,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => notifier.previous(),
              ),
              IconButton(
                icon: Icon(state.status == PlaybackStatus.playing
                    ? Icons.pause
                    : Icons.play_arrow),
                iconSize: 36,
                onPressed: () {
                  state.status == PlaybackStatus.playing
                      ? notifier.pause()
                      : notifier.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => notifier.next(),
              ),
              const SizedBox(width: 16),
              PopupMenuButton<double>(
                initialValue: state.speed,
                onSelected: (speed) => notifier.setSpeed(speed),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 0.5, child: Text('0.5x')),
                  PopupMenuItem(value: 0.75, child: Text('0.75x')),
                  PopupMenuItem(value: 1.0, child: Text('1.0x')),
                  PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  PopupMenuItem(value: 1.5, child: Text('1.5x')),
                  PopupMenuItem(value: 2.0, child: Text('2.0x')),
                  PopupMenuItem(value: 3.0, child: Text('3.0x')),
                ],
                child: Text('${state.speed}x',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              Text(' ${state.currentLineIndex + 1}/${state.totalLines}',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
