import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VerificationBadge extends StatelessWidget {
  final int tier;

  const VerificationBadge({Key? key, required this.tier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = 'Tier 1 Verified';
    Color iconColor = AppTheme.primaryIndigo;
    Color bgColor = AppTheme.primaryIndigo.withOpacity(0.1);

    if (tier == 3) {
      label = 'Tier 3 Regulated';
      iconColor = AppTheme.trustGreenText;
      bgColor = AppTheme.trustGreenBg;
    } else if (tier == 2) {
      label = 'Tier 2 Provider';
      iconColor = AppTheme.primaryIndigo;
      bgColor = AppTheme.primaryIndigo.withOpacity(0.1);
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
          Icon(Icons.verified, size: 14, color: iconColor),
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
