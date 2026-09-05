import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportModal extends StatefulWidget {
  final String targetId;

  const ReportModal({Key? key, required this.targetId}) : super(key: key);

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  String _selectedReason = 'false_skill_claim';
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, String>> _reasons = [
    {'value': 'false_skill_claim', 'label': 'False Skill / Credential Claim'},
    {'value': 'spam', 'label': 'Spam / Commercial Misuse'},
    {'value': 'harassment', 'label': 'Harassment / Inappropriate Behavior'},
    {'value': 'too_far', 'label': 'Location Misrepresentation'},
    {'value': 'other', 'label': 'Other Issue'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report or Block User',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textNearBlack),
          ),
          const SizedBox(height: 4),
          const Text(
            'Help keep Nook safe. Reports are reviewed by community moderators.',
            style: TextStyle(fontSize: 12, color: AppTheme.textGray),
          ),
          const SizedBox(height: 16),

          ..._reasons.map((r) => RadioListTile<String>(
                title: Text(r['label']!),
                value: r['value']!,
                groupValue: _selectedReason,
                activeColor: AppTheme.primaryIndigo,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
              )),

          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Additional details or evidence reference...',
              filled: true,
              fillColor: AppTheme.backgroundLight,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted for admin moderation review.')),
                );
              },
              child: const Text('Submit Report & Block User'),
            ),
          ),
        ],
      ),
    );
  }
}
