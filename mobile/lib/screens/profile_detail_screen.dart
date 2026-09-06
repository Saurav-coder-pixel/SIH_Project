import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textWhite,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share_outlined, color: AppTheme.textWhite),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, color: AppTheme.textWhite),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.cardDarkElevated),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppTheme.cardDarkElevated,
                                child: const Icon(Icons.person, color: AppTheme.textWhite, size: 40),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: AppTheme.primaryPurple, shape: BoxShape.circle),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Alex Kumar', style: TextStyle(color: AppTheme.textWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.verified, color: AppTheme.primaryPurple, size: 18),
                                  ],
                                ),
                                Text('Freelance UI Designer', style: TextStyle(color: AppTheme.primaryPurple, fontSize: 14)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: AppTheme.textMuted, size: 14),
                                    SizedBox(width: 4),
                                    Text('Green Park, Delhi', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('4.9', 'Rating (120)'),
                          Container(width: 1, height: 30, color: AppTheme.cardDarkElevated),
                          _buildStat('85', 'Connections'),
                          Container(width: 1, height: 30, color: AppTheme.cardDarkElevated),
                          _buildStat('2km', 'Radius'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('About', style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Creative UI/UX designer with 5+ years of experience helping local businesses build digital presences. Available for quick turnarounds.',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14, height: 1.5),
                ),
              ),

              const SizedBox(height: 24),

              // Skills/Services
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Skills & Services', style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSkillChip('UI Design'),
                    _buildSkillChip('Webflow'),
                    _buildSkillChip('Prototyping'),
                    _buildSkillChip('Brand Identity'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Verification Tier
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield, color: AppTheme.primaryPurple),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tier 2 Verified', style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                            Text('ID & Community Peer verified', style: TextStyle(color: AppTheme.primaryPurple, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: AppTheme.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.cardDarkElevated),
      ),
      child: Text(skill, style: const TextStyle(color: AppTheme.textWhite, fontSize: 13)),
    );
  }
}
