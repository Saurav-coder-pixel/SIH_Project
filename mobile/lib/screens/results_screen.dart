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

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          provider.currentNeed != null
              ? '${provider.currentNeed!.category} Nearby'
              : 'Matches',
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Auto-Expansion Notice if applicable
                  if (provider.statusNotice != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.amber),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              provider.statusNotice!,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Results Count & Radius Slider Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${provider.matches.length} Verified Candidates',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textNearBlack,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.tune, size: 16, color: AppTheme.textGray),
                          const SizedBox(width: 4),
                          Text(
                            'Radius: ${provider.searchRadiusKm.toInt()}km',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textGray),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // List of Match Cards
                  Expanded(
                    child: provider.matches.isEmpty
                        ? const Center(
                            child: Text('No candidates found. Try expanding search radius.'),
                          )
                        : ListView.builder(
                            itemCount: provider.matches.length,
                            itemBuilder: (context, index) {
                              final match = provider.matches[index];
                              return MatchCard(
                                match: match,
                                onRequestConnection: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
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
}
