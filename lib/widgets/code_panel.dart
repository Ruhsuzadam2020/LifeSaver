import 'package:flutter/material.dart';

class CodePanel extends StatelessWidget {
  final String code;
  final String? language;

  const CodePanel({super.key, required this.code, this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.greenAccent,
          fontSize: 16,
        ),
      ),
    );
  }
} 