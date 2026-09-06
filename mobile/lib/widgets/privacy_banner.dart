import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyBanner extends StatelessWidget {
  final String text;

  const PrivacyBanner({
    Key? key,
    this.text = 'Your contact information is shared only after mutual consent is granted. Safe and reliable.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppTheme.successGreen,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.successGreen,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
