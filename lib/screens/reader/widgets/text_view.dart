import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String text;
  final int? highlightedLineIndex;
  final ScrollController scrollController;

  const TextView({
    super.key,
    required this.text,
    this.highlightedLineIndex,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final isHighlighted = index == highlightedLineIndex;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: isHighlighted
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            lines[index],
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
              color: isHighlighted
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }
}
