import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'need_composer_screen.dart';
import 'connections_screen.dart';
import 'profile_detail_screen.dart';
import 'notifications_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  final List<String> _categories = [
    'Doctor',
    'Engineer',
    'Mechanic',
    'Finance',
    'Plumber',
    'Tutor'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final List<Widget> pages = [
      _buildMapHomeContent(provider),
      const NeedComposerScreen(), // Actually in Figma this might be triggered from map, but let's keep it in tabs
      const ConnectionsScreen(),
      const ProfileDetailScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: pages[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: AppTheme.primaryPurple,
        unselectedItemColor: AppTheme.textMuted,
        backgroundColor: AppTheme.backgroundDark,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Nearby'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Alerts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NeedComposerScreen()),
                );
              },
              backgroundColor: AppTheme.primaryPurple,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildMapHomeContent(AppProvider provider) {
    const localityCenter = LatLng(12.935, 77.624);
    final radiusMeters = provider.searchRadiusKm * 1000;

    return Stack(
      children: [
        // Full screen map placeholder (since API key is not configured for demo)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF12121A),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dummy circle for radius
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryPurple.withOpacity(0.12),
                  border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.5), width: 2),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: AppTheme.textMuted),
                  SizedBox(height: 8),
                  Text('Interactive Map\n(Requires Google Maps API Key)', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
        ),

        // Top Overlay Header & Search
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                          child: const Icon(Icons.person, color: AppTheme.primaryPurple, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AroundMe',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textWhite, fontFamily: 'Poppins'),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: AppTheme.successGreen, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${provider.currentLocality} · Delhi',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.textWhite),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                          },
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: AppTheme.textWhite),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                              },
                            ),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Search profession or need nearby...',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDarkElevated,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.tune, color: AppTheme.textWhite, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Categories
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = index == 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: isSelected ? AppTheme.primaryPurple : Colors.transparent),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.textMuted,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Draggable Bottom Sheet
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.textDarkGrey, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('7 nearby', style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.cardDarkElevated, borderRadius: BorderRadius.circular(999)),
                          child: const Text('List >', style: TextStyle(color: AppTheme.textWhite, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.cardDarkElevated,
                                child: const Icon(Icons.person, color: AppTheme.textWhite),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Dr. Priya Sharma ✓', style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                                    const Text('Cardiologist', style: TextStyle(color: AppTheme.primaryPurple, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    const Text('AIIMS graduate, 8 years exp...', style: TextStyle(color: AppTheme.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: AppTheme.textMuted, size: 12),
                                        const Text(' 0.2 km  ', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                        const Icon(Icons.star, color: AppTheme.starGold, size: 12),
                                        const Text(' 4.9', style: TextStyle(color: AppTheme.textWhite, fontSize: 11, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text('Connect', style: TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

