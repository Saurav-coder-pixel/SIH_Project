class UserModel {
  final String id;
  final String phone;
  final String name;
  final String role; // 'seeker', 'provider', 'both'
  final String bio;
  final String profession;
  final List<String> skills;
  final List<String> services;
  final int verificationTier;
  final String verificationStatus;
  final double reputationScore;
  final int reviewCount;
  final String localityName;
  final double? approxDistanceKm;
  final String? unlockedPhone;

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    this.bio = '',
    this.profession = '',
    this.skills = const [],
    this.services = const [],
    this.verificationTier = 1,
    this.verificationStatus = 'unverified',
    this.reputationScore = 5.0,
    this.reviewCount = 0,
    required this.localityName,
    this.approxDistanceKm,
    this.unlockedPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final v = json['verification'] ?? {};
    final r = json['reputation'] ?? {};

    return UserModel(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? 'Anonymous User',
      role: json['role'] ?? 'both',
      bio: json['bio'] ?? '',
      profession: json['profession'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      verificationTier: v['tier'] ?? 1,
      verificationStatus: v['status'] ?? 'unverified',
      reputationScore: (r['score'] ?? 5.0).toDouble(),
      reviewCount: r['review_count'] ?? 0,
      localityName: json['locality_name'] ?? 'Nearby Locality',
      approxDistanceKm: json['approx_distance_km'] != null
          ? (json['approx_distance_km'] as num).toDouble()
          : null,
      unlockedPhone: json['phone'],
    );
  }
}
