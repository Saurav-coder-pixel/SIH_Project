import 'user_model.dart';

class MatchModel {
  final UserModel candidate;
  final int matchScore;
  final double approxDistanceKm;
  final List<String> explanationTags;

  MatchModel({
    required this.candidate,
    required this.matchScore,
    required this.approxDistanceKm,
    required this.explanationTags,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      candidate: UserModel.fromJson(json['candidate'] ?? {}),
      matchScore: json['match_score'] ?? 80,
      approxDistanceKm: (json['approx_distance_km'] ?? 1.5).toDouble(),
      explanationTags: List<String>.from(json['explanation_tags'] ?? []),
    );
  }
}
