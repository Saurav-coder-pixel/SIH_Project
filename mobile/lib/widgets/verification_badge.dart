import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VerificationBadge extends StatelessWidget {
  final int tier;

  const VerificationBadge({Key? key, required this.tier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = 'Verified';
    Color iconColor = AppTheme.successGreen;
    Color bgColor = AppTheme.successGreen.withOpacity(0.1);

    if (tier == 3) {
      label = 'Regulated';
    } else if (tier == 2) {
      label = 'Provider';
    } else {
      label = 'Verified';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
