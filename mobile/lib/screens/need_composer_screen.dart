import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

class NeedComposerScreen extends StatefulWidget {
  const NeedComposerScreen({Key? key}) : super(key: key);

  @override
  State<NeedComposerScreen> createState() => _NeedComposerScreenState();
}

class _NeedComposerScreenState extends State<NeedComposerScreen> {
  final TextEditingController _textController = TextEditingController(
    text: "I need product photography for 500 SKUs this week",
  );

  String _selectedBudget = '\$300-\$600';
  String _selectedUrgency = 'this_week';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Describe Your Need'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Textarea Input
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardDarkElevated),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppTheme.primaryPurple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Natural Language Input',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        hintText: "e.g. 'I need a product photographer for catalog shoot this week' or 'Need an electrician for short circuit repair today'",
                        hintStyle: TextStyle(color: AppTheme.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Urgency Selector
            const Text(
              'Urgency / Timeline',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textWhite),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip('Urgent / Today', 'immediate'),
                const SizedBox(width: 8),
                _buildChip('This Week', 'this_week'),
                const SizedBox(width: 8),
                _buildChip('Flexible', 'flexible'),
              ],
            ),
            const SizedBox(height: 20),

            // Radius Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Radius',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textWhite),
                ),
                Text(
                  '${provider.searchRadiusKm.toInt()} km',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryPurple),
                ),
              ],
            ),
            Slider(
              value: provider.searchRadiusKm,
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: AppTheme.primaryPurple,
              onChanged: (val) => provider.setSearchRadius(val),
            ),

            const Spacer(),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  if (_textController.text.trim().isNotEmpty) {
                    await provider.createAndSearchNeed(_textController.text.trim());
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultsScreen()),
                      );
                    }
                  }
                },
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Find Nearby Candidates'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _selectedUrgency == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryPurple,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textWhite,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: AppTheme.cardDark,
      side: const BorderSide(color: AppTheme.cardDarkElevated),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      onSelected: (selected) {
        if (selected) setState(() => _selectedUrgency = value);
      },
    );
  }
}
