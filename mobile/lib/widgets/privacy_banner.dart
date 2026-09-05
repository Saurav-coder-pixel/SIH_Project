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
        color: AppTheme.trustGreenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.trustGreenText.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppTheme.trustGreenText,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.trustGreenText,
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
