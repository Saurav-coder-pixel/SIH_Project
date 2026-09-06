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
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Right Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('Skip', style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            
            const Spacer(),

            // Graphic / Map Illustration Mockup
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 280,
              decoration: BoxDecoration(
                color: AppTheme.backgroundDarkGrid,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardDarkElevated),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Pulsing Pin
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryPurple.withOpacity(0.4),
                    ),
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  // Fake nearby pins
                  Positioned(
                    top: 60, left: 60,
                    child: _buildMockPin(Colors.pinkAccent, '0.2 km'),
                  ),
                  Positioned(
                    bottom: 70, right: 50,
                    child: _buildMockPin(Colors.orangeAccent, '0.4 km'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // Text Content
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    "See who's around you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textWhite,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Discover doctors, engineers, tutors, and more — living just streets away, invisible until now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24, height: 6,
                  decoration: BoxDecoration(color: AppTheme.primaryPurple, borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(color: AppTheme.cardDarkElevated, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(color: AppTheme.cardDarkElevated, shape: BoxShape.circle),
                ),
              ],
            ),

            const Spacer(),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Set default role for demo purposes as seeker
                    provider.setRole('seeker');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No spam · No data selling · Made for communities',
              style: TextStyle(fontSize: 11, color: AppTheme.textDarkGrey),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMockPin(Color color, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      ],
    );
  }
}
