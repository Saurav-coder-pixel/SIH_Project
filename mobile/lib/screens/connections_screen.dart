import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _activeConnections = [
    {
      'id': 'conn_1',
      'name': 'Ananya Verma',
      'profession': 'Commercial Product Photographer',
      'locality': 'Indiranagar, Bengaluru',
      'phone': '+919876543210',
      'lastMsg': 'Sure! I can come by tomorrow afternoon...',
      'tier': 2,
    },
    {
      'id': 'conn_2',
      'name': 'Rajesh Kumar',
      'profession': 'Licensed Electrician',
      'locality': 'Koramangala, Bengaluru',
      'phone': '+919811223344',
      'lastMsg': 'I can inspect the switchboard at 4 PM.',
      'tier': 2,
    },
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': 'req_1',
      'name': 'Vikram Seth',
      'profession': 'Event Decorator',
      'locality': 'Whitefield, Bengaluru',
      'message': 'Hi, saw your requirement for event decoration.',
    },
  ];

  @override
  void initState() {
    super.initState() {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('My Connections & Requests'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryIndigo,
          unselectedLabelColor: AppTheme.textGray,
          indicatorColor: AppTheme.primaryIndigo,
          tabs: const [
            Tab(text: 'Active Connections'),
            Tab(text: 'Pending Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Connections List
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _activeConnections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final conn = _activeConnections[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryIndigo.withOpacity(0.12),
                    child: Text(
                      conn['name'][0],
                      style: const TextStyle(color: AppTheme.primaryIndigo, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(conn['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${conn['profession']} • ${conn['locality']}'),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 12, color: AppTheme.trustGreenText),
                          const SizedBox(width: 4),
                          Text(
                            'Phone: ${conn['phone']}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.trustGreenText, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryIndigo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          connectionId: conn['id'],
                          partnerName: conn['name'],
                          partnerProfession: conn['profession'],
                          partnerPhone: conn['phone'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Pending Requests List
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _pendingRequests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final req = _pendingRequests[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${req['profession']} • ${req['locality']}', style: const TextStyle(color: AppTheme.textGray, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text('"${req['message']}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => _pendingRequests.removeAt(index));
                              },
                              child: const Text('Decline'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _activeConnections.add({
                                    'id': req['id'],
                                    'name': req['name'],
                                    'profession': req['profession'],
                                    'locality': req['locality'],
                                    'phone': '+919988776655',
                                    'lastMsg': 'Connection accepted!',
                                    'tier': 2,
                                  });
                                  _pendingRequests.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Connection accepted! Chat and contact details unlocked.')),
                                );
                              },
                              child: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
