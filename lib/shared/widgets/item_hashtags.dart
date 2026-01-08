// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ItemHashtags extends StatelessWidget {
  final String tag;

  const ItemHashtags({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    String displayName = tag;
    Color baseColor = Colors.teal.shade500;
    final RegExp regex = RegExp(r'name:\s*([^,]+),\s*color:\s*([0-9a-fA-F]+)');
    final Match? match = regex.firstMatch(tag);

    if (match != null) {
      displayName = match.group(1)?.trim() ?? tag;
      String colorHex = match.group(2) ?? '';
      if (colorHex.isNotEmpty) {
        try {
          baseColor = Color(int.parse('0xFF$colorHex'));
        } catch (e) {}
      }
    } else {
      if (tag == 'Vip') {
        baseColor = Colors.blue.shade600;
      } else if (tag == 'Full') {
        baseColor = Colors.amber.shade700;
      } else if (tag == 'Độc quyền') {
        baseColor = Colors.red.shade600;
      }
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor,

        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: baseColor.withOpacity(0.1), blurRadius: 3),
        ],
      ),
      child: Text(
        displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
