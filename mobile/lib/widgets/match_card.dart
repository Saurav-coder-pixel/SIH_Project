import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../theme/app_theme.dart';
import 'verification_badge.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onRequestConnection;
  final Function(String feedbackType) onFeedback;

  const MatchCard({
    Key? key,
    required this.match,
    required this.onRequestConnection,
    required this.onFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final candidate = match.candidate;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Avatar, Name, Score Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.cardDarkElevated,
                  child: Text(
                    candidate.name.isNotEmpty ? candidate.name[0] : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              candidate.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textWhite,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          VerificationBadge(tier: candidate.verificationTier),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        candidate.profession.isNotEmpty
                            ? candidate.profession
                            : 'Skilled Professional',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppTheme.starGold),
                          const SizedBox(width: 4),
                          Text(
                            '${candidate.reputationScore.toStringAsFixed(1)} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '(${candidate.reviewCount} reviews) • ${candidate.localityName} (${match.approxDistanceKm.toStringAsFixed(1)} km)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Score pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${match.matchScore}% Match',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Skills Chips
            if (candidate.skills.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: candidate.skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDarkGrid,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppTheme.textDarkGrey),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Explainable "Why this result?" breakdown box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDarkGrid,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Why this match?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...match.explanationTags.map((tag) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 12, color: AppTheme.primaryPurple),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action Row: Feedback Buttons + Send Request Button
            Row(
              children: [
                // Quick Feedback menu button
                PopupMenuButton<String>(
                  icon: const Icon(Icons.thumb_up_alt_outlined,
                      size: 20, color: AppTheme.textMuted),
                  tooltip: 'Feedback on result',
                  onSelected: onFeedback,
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Useful', child: Text('👍 Useful')),
                    const PopupMenuItem(value: 'Not Relevant', child: Text('👎 Not Relevant')),
                    const PopupMenuItem(value: 'Too Far', child: Text('📍 Too Far')),
                    const PopupMenuItem(value: 'Not Trustworthy', child: Text('⚠️ Not Trustworthy')),
                    const PopupMenuItem(value: 'Unavailable', child: Text('⏳ Unavailable')),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onRequestConnection,
                  child: const Text('Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
