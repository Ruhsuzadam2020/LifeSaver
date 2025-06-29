import 'package:flutter/material.dart';
import 'code_panel.dart';

List<Widget> parseMessageWithCodePanels(String mesaj) {
  final widgets = <Widget>[];
  final lines = mesaj.split('\n');
  bool kodModu = false;
  String kodBuffer = '';
  String textBuffer = '';

  void flushText() {
    if (textBuffer.trim().isNotEmpty) {
      widgets.add(Text(
        textBuffer.trim(),
        style: const TextStyle(color: Colors.black),
      ));
      textBuffer = '';
    }
  }

  for (final line in lines) {
    if (line.trim().startsWith('```')) {
      if (kodModu) {
        // Kod bloğu bitti
        widgets.add(CodePanel(code: kodBuffer.trim()));
        kodBuffer = '';
        kodModu = false;
      } else {
        // Kod bloğu başladı
        flushText();
        kodModu = true;
      }
    } else if (kodModu) {
      kodBuffer += '$line\n';
    } else {
      textBuffer += '$line\n';
    }
  }
  // Kalan metin veya kodu ekle
  flushText();
  if (kodBuffer.isNotEmpty) {
    widgets.add(CodePanel(code: kodBuffer.trim()));
  }
  return widgets;
} 