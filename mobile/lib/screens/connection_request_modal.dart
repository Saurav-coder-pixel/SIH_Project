import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/privacy_banner.dart';
import 'chat_screen.dart';

class ConnectionRequestModal extends StatefulWidget {
  final UserModel candidate;
  final String? needId;

  const ConnectionRequestModal({
    Key? key,
    required this.candidate,
    this.needId,
  }) : super(key: key);

  @override
  State<ConnectionRequestModal> createState() => _ConnectionRequestModalState();
}

class _ConnectionRequestModalState extends State<ConnectionRequestModal> {
  final TextEditingController _msgController = TextEditingController(
    text: "Hello! I saw your profile on Nook and would like to connect regarding my product photography requirement.",
  );

  String _selectedBudget = '\$300-\$600';
  bool _isSending = false;

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
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.cardDarkElevated,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Text(
              'Connect with ${widget.candidate.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.candidate.profession} • ${widget.candidate.localityName}',
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),

            // Soft Green Consent Reassurance Banner
            const PrivacyBanner(
              text: 'Your contact information is shared only after mutual consent is granted. Safe and reliable.',
            ),
            const SizedBox(height: 20),

            // Message Field
            const Text(
              'Introduce yourself / Task context',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textWhite),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _msgController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: InputDecoration(
                fillColor: AppTheme.backgroundDark,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.cardDarkElevated),
                ),
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                hintText: 'Add details or context for your connection request...',
              ),
            ),
            const SizedBox(height: 16),

            // Budget chips
            const Text(
              'Budget Range (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textWhite),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBudgetChip('\$100-\$300'),
                const SizedBox(width: 8),
                _buildBudgetChip('\$300-\$600'),
                const SizedBox(width: 8),
                _buildBudgetChip('\$600+'),
              ],
            ),
            const SizedBox(height: 24),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSending
                    ? null
                    : () async {
                        setState(() => _isSending = true);
                        await Future.delayed(const Duration(milliseconds: 600));
                        if (mounted) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                connectionId: 'demo_conn_123',
                                partnerName: widget.candidate.name,
                                partnerProfession: widget.candidate.profession,
                                partnerPhone: widget.candidate.phone,
                              ),
                            ),
                          );
                        }
                      },
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Connection Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetChip(String label) {
    final isSelected = _selectedBudget == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryPurple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textWhite,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: AppTheme.backgroundDark,
      side: const BorderSide(color: AppTheme.cardDarkElevated),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      onSelected: (selected) {
        if (selected) setState(() => _selectedBudget = label);
      },
    );
  }
}
