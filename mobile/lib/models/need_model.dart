class NeedModel {
  final String id;
  final String rawText;
  final String category;
  final String urgency;
  final List<String> extractedKeywords;
  final String localityName;
  final double radiusKm;
  final DateTime createdAt;

  NeedModel({
    required this.id,
    required this.rawText,
    required this.category,
    required this.urgency,
    required this.extractedKeywords,
    required this.localityName,
    required this.radiusKm,
    required this.createdAt,
  });

  factory NeedModel.fromJson(Map<String, dynamic> json) {
    final parsed = json['parsed_need'] ?? {};
    return NeedModel(
      id: json['_id'] ?? '',
      rawText: json['raw_text'] ?? '',
      category: parsed['category'] ?? 'general service',
      urgency: parsed['urgency'] ?? 'this_week',
      extractedKeywords: List<String>.from(parsed['extracted_keywords'] ?? []),
      localityName: json['locality_name'] ?? 'Bengaluru',
      radiusKm: (json['radius_km'] ?? 5.0).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
