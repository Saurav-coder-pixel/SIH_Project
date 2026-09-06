import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/match_card.dart';
import 'connection_request_modal.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final String category = provider.currentNeed?.category ?? 'Professionals';

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nearby People',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textWhite,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'within ${provider.searchRadiusKm.toInt()} km · ${provider.currentLocality}',
                              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDarkElevated,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.map_outlined, color: AppTheme.textWhite, size: 16),
                              SizedBox(width: 6),
                              Text('Map', style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Sorting Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        _buildSortPill('Nearest', true),
                        const SizedBox(width: 8),
                        _buildSortPill('Rating', false),
                        const SizedBox(width: 8),
                        _buildSortPill('New', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filters
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCategoryChip('All', true),
                        const SizedBox(width: 8),
                        _buildCategoryChip(category, false),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Doctor', false),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Engineer', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${provider.matches.length} professionals found',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Auto-Expansion Notice if applicable
                  if (provider.statusNotice != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.starGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.starGold),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppTheme.starGold),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                provider.statusNotice!,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.starGold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // List of Match Cards
                  Expanded(
                    child: provider.matches.isEmpty
                        ? const Center(
                            child: Text('No candidates found. Try expanding search radius.', style: TextStyle(color: AppTheme.textMuted)),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: provider.matches.length,
                            itemBuilder: (context, index) {
                              final match = provider.matches[index];
                              return MatchCard(
                                match: match,
                                onRequestConnection: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => ConnectionRequestModal(
                                      candidate: match.candidate,
                                      needId: provider.currentNeed?.id,
                                    ),
                                  );
                                },
                                onFeedback: (feedbackType) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Feedback recorded: $feedbackType')),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSortPill(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryPurple : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textWhite,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.textWhite : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppTheme.backgroundDark : AppTheme.textWhite,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}
