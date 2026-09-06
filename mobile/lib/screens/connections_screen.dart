import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  int _selectedTab = 0; // 0 for Primary, 1 for Requests

  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'conn_1',
      'name': 'Priya Sharma',
      'profession': 'Cardiologist',
      'lastMsg': 'The clinic is open until 8 PM today.',
      'time': '2m ago',
      'unread': 2,
      'online': true,
      'phone': '+919876543210',
    },
    {
      'id': 'conn_2',
      'name': 'Rahul Verma',
      'profession': 'Electrician',
      'lastMsg': 'I can come by tomorrow morning.',
      'time': '1h ago',
      'unread': 0,
      'online': false,
      'phone': '+919811223344',
    },
    {
      'id': 'conn_3',
      'name': 'Dr. Anil Gupta',
      'profession': 'Pediatrician',
      'lastMsg': 'Please bring the previous reports.',
      'time': 'Yesterday',
      'unread': 0,
      'online': true,
      'phone': '+919988776655',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // Segmented Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? AppTheme.cardDarkElevated : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Primary',
                            style: TextStyle(
                              color: _selectedTab == 0 ? AppTheme.textWhite : AppTheme.textMuted,
                              fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? AppTheme.cardDarkElevated : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Requests (2)',
                            style: TextStyle(
                              color: _selectedTab == 1 ? AppTheme.textWhite : AppTheme.textMuted,
                              fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Search messages...',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Message List
            Expanded(
              child: _selectedTab == 0
                  ? ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return _buildMessageTile(msg);
                      },
                    )
                  : const Center(
                      child: Text(
                        'You have 2 pending connection requests.',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> msg) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              connectionId: msg['id'],
              partnerName: msg['name'],
              partnerProfession: msg['profession'],
              partnerPhone: msg['phone'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.cardDarkElevated,
                  child: Text(
                    msg['name'][0],
                    style: const TextStyle(color: AppTheme.primaryPurple, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (msg['online'] == true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.backgroundDark, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        msg['name'],
                        style: const TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        msg['time'],
                        style: TextStyle(
                          color: msg['unread'] > 0 ? AppTheme.primaryPurple : AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: msg['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          msg['lastMsg'],
                          style: TextStyle(
                            color: msg['unread'] > 0 ? AppTheme.textWhite : AppTheme.textMuted,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (msg['unread'] > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            msg['unread'].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
