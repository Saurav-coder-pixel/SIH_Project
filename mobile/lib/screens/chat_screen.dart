import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'rating_screen.dart';
import 'report_modal.dart';

class ChatScreen extends StatefulWidget {
  final String connectionId;
  final String partnerName;
  final String partnerProfession;
  final String? partnerPhone;

  const ChatScreen({
    Key? key,
    required this.connectionId,
    required this.partnerName,
    required this.partnerProfession,
    this.partnerPhone,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'them',
      'text':
          'Hi! Thanks for connecting. I am available for product photography shoots this week.',
      'time': '10:32 AM',
    },
    {
      'sender': 'me',
      'text':
          'Great! We have 500 SKUs at our Koramangala studio. Can we discuss schedule and pricing?',
      'time': '10:35 AM',
    },
    {
      'sender': 'them',
      'text':
          'Sure! I can come by tomorrow afternoon to inspect the studio setup.',
      'time': '10:36 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.partnerName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
            Text(widget.partnerProfession,
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ],
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.phone_outlined, color: AppTheme.primaryPurple),
            tooltip: 'Call Partner',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.partnerPhone != null
                        ? 'Consent granted. Unlocked phone: ${widget.partnerPhone}'
                        : 'Initiating in-app call with ${widget.partnerName}...',
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'rate') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RatingScreen(
                      connectionId: widget.connectionId,
                      partnerName: widget.partnerName,
                    ),
                  ),
                );
              } else if (val == 'report') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ReportModal(targetId: widget.connectionId),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'rate', child: Text('Rate & Review')),
              const PopupMenuItem(
                  value: 'report', child: Text('Report / Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // System Consent Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppTheme.cardDark,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDarkGrid,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppTheme.cardDarkElevated),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14, color: AppTheme.textMuted),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Connection accepted. You can now chat and coordinate details freely.',
                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender'] == 'me';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? AppTheme.primaryPurple : AppTheme.cardDark,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                      border:
                          isMe ? null : Border.all(color: AppTheme.cardDarkElevated),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color: isMe ? Colors.white : AppTheme.textWhite,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            color: isMe ? Colors.white70 : AppTheme.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.backgroundDark,
              border: Border(top: BorderSide(color: AppTheme.cardDarkElevated)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppTheme.textMuted),
                      fillColor: AppTheme.cardDark,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () {
                      if (_msgController.text.trim().isNotEmpty) {
                        setState(() {
                          _messages.add({
                            'sender': 'me',
                            'text': _msgController.text.trim(),
                            'time': 'Just now',
                          });
                        });
                        _msgController.clear();
                      }
                    },
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
