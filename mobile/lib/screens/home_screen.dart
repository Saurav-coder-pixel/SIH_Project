import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'need_composer_screen.dart';
import 'connections_screen.dart';
import 'verification_dashboard_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  final List<String> _categories = [
    'Product Photography',
    'Electrician',
    'Plumber',
    'Tutor / Educator',
    'Event Decorator',
    'Chartered Accountant',
    'Doctor / Health',
    'Mechanic'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final List<Widget> pages = [
      _buildHomeContent(provider),
      const NeedComposerScreen(),
      const ConnectionsScreen(),
      const VerificationDashboardScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(child: pages[_currentTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: AppTheme.primaryIndigo,
        unselectedItemColor: AppTheme.textGray,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Need Search'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Connections'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent(AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Locality Row & Admin Tool shortcut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardWhite,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryIndigo, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      provider.currentLocality,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.textGray),
                tooltip: 'Admin / Concierge Dashboard',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Natural Language Need Search Bar Widget
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NeedComposerScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryIndigo.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryIndigo.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppTheme.primaryIndigo, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Describe what you need in plain text...',
                      style: TextStyle(
                        color: AppTheme.textGray,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppTheme.textGray, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Category Chips Row
          const Text(
            'Browse Popular Needs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textNearBlack),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return ActionChip(
                  label: Text(cat),
                  backgroundColor: AppTheme.cardWhite,
                  surfaceTintColor: Colors.transparent,
                  side: const BorderSide(color: AppTheme.borderLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  onPressed: () {
                    provider.createAndSearchNeed('I need a $cat in my locality');
                    setState(() => _currentTabIndex = 1);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          // Approximate Locality Zone Map Card (Privacy Compliant)
          const Text(
            'Your Locality Zone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textNearBlack),
          ),
          const SizedBox(height: 6),
          const Text(
            'Approximate neighborhood region display. Exact coordinates stay private.',
            style: TextStyle(fontSize: 13, color: AppTheme.textGray),
          ),
          const SizedBox(height: 12),

          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Stack(
              children: [
                // Simulated Grid Zone
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryIndigo.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryIndigo, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.my_location, color: AppTheme.primaryIndigo, size: 32),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppTheme.trustGreenText, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Zone Radius: ${provider.searchRadiusKm.toInt()} km (No exact address shown)',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textNearBlack),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
