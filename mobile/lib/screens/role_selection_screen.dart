import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Brand Logo / Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryIndigo.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: AppTheme.primaryIndigo,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Nook',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textNearBlack,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect with trusted professionals and skilled people living and working right in your locality.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'How would you like to start?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textNearBlack,
                ),
              ),
              const SizedBox(height: 16),

              // Option 1: Find Someone
              _RoleCard(
                title: 'Find someone',
                subtitle: 'Discover verified professionals, tradespeople, or helpers nearby',
                icon: Icons.search_rounded,
                isSelected: provider.selectedRole == 'seeker',
                onTap: () => provider.setRole('seeker'),
              ),
              const SizedBox(height: 16),

              // Option 2: Be Discoverable
              _RoleCard(
                title: 'Offer a skill / Be discoverable',
                subtitle: 'List your profession or services so people in your area can connect with you',
                icon: Icons.badge_outlined,
                isSelected: provider.selectedRole == 'provider' || provider.selectedRole == 'both',
                onTap: () => provider.setRole('both'),
              ),

              const Spacer(),

              // Soft Privacy Reassurance Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.trustGreenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppTheme.trustGreenText, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Private & Safe: Your exact home address is never shown on a map. Contact info is shared only after mutual consent.',
                        style: TextStyle(fontSize: 12, color: AppTheme.trustGreenText, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryIndigo : AppTheme.borderLight,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryIndigo.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryIndigo.withOpacity(0.12)
                    : AppTheme.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryIndigo : AppTheme.textGray,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.primaryIndigo : AppTheme.textNearBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textGray),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryIndigo,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
