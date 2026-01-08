import 'package:flutter/material.dart';

class VipBadge extends StatelessWidget {
  final int vipId;

  const VipBadge({super.key, required this.vipId});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    //TODO: Api chưa phân loại VIP theo thời gian
    switch (vipId) {
      case 1:
        text = 'VIP';
        color = Colors.amber;
        break;
      case 4:
        text = 'VIP 1 năm';
        color = Colors.amber;
        break;
      case 2:
        text = 'VIP 6 tháng';
        color = Colors.deepOrange;
        break;
      case 3:
        text = 'VIP 1 năm';
        color = Colors.purpleAccent;
        break;
      default:
        text = 'VIP';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
