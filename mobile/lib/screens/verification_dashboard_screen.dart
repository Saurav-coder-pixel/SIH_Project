import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/privacy_banner.dart';

class VerificationDashboardScreen extends StatefulWidget {
  const VerificationDashboardScreen({Key? key}) : super(key: key);

  @override
  State<VerificationDashboardScreen> createState() => _VerificationDashboardScreenState();
}

class _VerificationDashboardScreenState extends State<VerificationDashboardScreen> {
  int _currentTier = 1;
  final TextEditingController _licenseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Verification & Profile Trust'),
        iconTheme: const IconThemeData(color: AppTheme.textWhite),
        titleTextStyle: const TextStyle(color: AppTheme.textWhite, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrivacyBanner(
              text: 'Multi-Tiered Verification System: Regulated professions (Doctors, CAs, Lawyers) require mandatory Tier 3 license verification.',
            ),
            const SizedBox(height: 24),

            // Tier 1 Card
            _buildTierCard(
              tier: 1,
              title: 'Tier 1 — Basic Verification',
              subtitle: 'Verified phone OTP & basic community profile badge',
              isCompleted: _currentTier >= 1,
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successGreen, size: 20),
                  SizedBox(width: 8),
                  Text('Phone OTP Verified (+91 98765*****)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textWhite)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tier 2 Card
            _buildTierCard(
              tier: 2,
              title: 'Tier 2 — Skilled Provider Badge',
              subtitle: 'ID document + peer community recommendation signals',
              isCompleted: _currentTier >= 2,
              child: _currentTier >= 2
                  ? const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.successGreen, size: 20),
                        SizedBox(width: 8),
                        Text('Skilled Provider Badge Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textWhite)),
                      ],
                    )
                  : OutlinedButton(
                      onPressed: () {
                        setState(() => _currentTier = 2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tier 2 Skilled Provider Verification completed!')),
                        );
                      },
                      child: const Text('Upgrade to Tier 2'),
                    ),
            ),
            const SizedBox(height: 16),

            // Tier 3 Card
            _buildTierCard(
              tier: 3,
              title: 'Tier 3 — Regulated Professional',
              subtitle: 'Medical / CA / Legal Registration & License Number Verification',
              isCompleted: _currentTier >= 3,
              child: _currentTier >= 3
                  ? const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.successGreen, size: 20),
                        SizedBox(width: 8),
                        Text('Tier 3 Regulated Professional Verified', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textWhite)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mandatory for Doctors, CAs, Lawyers before public profile discovery.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _licenseController,
                          style: const TextStyle(color: AppTheme.textWhite),
                          decoration: const InputDecoration(
                            hintText: 'Enter Registration / License Number (e.g. MCI-98765)',
                            hintStyle: TextStyle(color: AppTheme.textMuted),
                            filled: true,
                            fillColor: AppTheme.cardDarkElevated,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_licenseController.text.trim().isNotEmpty) {
                              setState(() => _currentTier = 3);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tier 3 License verified! Regulated profile now discoverable.')),
                              );
                            }
                          },
                          child: const Text('Submit Tier 3 Verification'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required int tier,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardDarkElevated),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isCompleted ? AppTheme.successGreen.withOpacity(0.2) : AppTheme.backgroundDark,
                  child: Text(
                    '$tier',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? AppTheme.successGreen : AppTheme.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textWhite),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
