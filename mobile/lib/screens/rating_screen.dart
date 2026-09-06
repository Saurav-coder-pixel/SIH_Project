import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../theme/app_theme.dart';

class RatingScreen extends StatefulWidget {
  final String connectionId;
  final String partnerName;

  const RatingScreen({
    Key? key,
    required this.connectionId,
    required this.partnerName,
  }) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 5.0;
  final List<String> _tags = ['Professional', 'Skilled', 'Punctual', 'Responsive', 'Fair Communication'];
  final Set<String> _selectedTags = {'Professional', 'Skilled'};
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Text('Rate & Review ${widget.partnerName}'),
        iconTheme: const IconThemeData(color: AppTheme.textWhite),
        titleTextStyle: const TextStyle(color: AppTheme.textWhite, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              'How was your interaction with ${widget.partnerName}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ratings help keep the Nook community safe and reliable.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 24),

            // Rating Stars
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: AppTheme.starGold),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 28),

            // Quick Feedback Tags
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Feedback Tags',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textWhite),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
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
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Comment Box
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add an optional comment...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                fillColor: AppTheme.cardDark,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.cardDarkElevated),
                ),
              ),
              style: const TextStyle(color: AppTheme.textWhite),
            ),

            const Spacer(),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rating and feedback recorded successfully!')),
                  );
                },
                child: const Text('Submit Rating'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
