import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/need_model.dart';
import '../models/match_model.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  String _selectedRole = 'seeker'; // 'seeker' (Find someone) or 'provider' (Be discoverable) or 'both'
  String _currentLocality = 'Koramangala, Bengaluru';
  
  NeedModel? _currentNeed;
  List<MatchModel> _matches = [];
  double _searchRadiusKm = 5.0;
  bool _isLoading = false;
  String? _statusNotice;

  UserModel? get currentUser => _currentUser;
  String get selectedRole => _selectedRole;
  String get currentLocality => _currentLocality;
  NeedModel? get currentNeed => _currentNeed;
  List<MatchModel> get matches => _matches;
  double get searchRadiusKm => _searchRadiusKm;
  bool get isLoading => _isLoading;
  String? get statusNotice => _statusNotice;

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setLocality(String locality) {
    _currentLocality = locality;
    notifyListeners();
  }

  void setSearchRadius(double radius) {
    _searchRadiusKm = radius;
    if (_currentNeed != null) {
      fetchMatchesForCurrentNeed(radiusKm: radius);
    }
    notifyListeners();
  }

  Future<void> createAndSearchNeed(String rawText) async {
    _isLoading = true;
    _statusNotice = null;
    notifyListeners();

    try {
      // Mock / Local fallback if backend unavailable during demo mode
      _currentNeed = NeedModel(
        id: 'need_demo_1',
        rawText: rawText,
        category: 'product photography',
        urgency: 'this_week',
        extractedKeywords: ['photography', 'skus', 'product'],
        localityName: _currentLocality,
        radiusKm: _searchRadiusKm,
        createdAt: DateTime.now(),
      );

      // Attempt live API call if possible
      try {
        final apiNeed = await ApiService.submitNeed(rawText, radiusKm: _searchRadiusKm);
        _currentNeed = apiNeed;
      } catch (e) {
        debugPrint('API call error: $e. Falling back to local demo parser.');
      }

      await fetchMatchesForCurrentNeed(radiusKm: _searchRadiusKm);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMatchesForCurrentNeed({double? radiusKm}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rad = radiusKm ?? _searchRadiusKm;

      // Demo fallback matches guarantee
      _matches = [
        MatchModel(
          candidate: UserModel(
            id: 'demo_provider_1',
            phone: '+919876543210',
            name: 'Ananya Verma',
            role: 'provider',
            profession: 'Commercial Product Photographer',
            skills: ['Product Photography', 'Studio Shoot', 'Photoshop'],
            services: ['E-commerce SKU Photography', 'Catalog Shoot'],
            verificationTier: 2,
            verificationStatus: 'verified',
            reputationScore: 4.9,
            reviewCount: 34,
            localityName: 'Indiranagar, Bengaluru',
            approxDistanceKm: 1.8,
          ),
          matchScore: 95,
          approxDistanceKm: 1.8,
          explanationTags: [
            'Exact Category Match (product photography)',
            'Nearby (1.8 km away)',
            'Tier 2 Verified Provider Badge',
            'Top Rated (4.9 ★)'
          ],
        ),
        MatchModel(
          candidate: UserModel(
            id: 'demo_provider_2',
            phone: '+919811223344',
            name: 'Rohan Sharma',
            role: 'provider',
            profession: 'Studio & Event Photographer',
            skills: ['Lighting', 'Product Photos', 'Edits'],
            verificationTier: 1,
            verificationStatus: 'verified',
            reputationScore: 4.7,
            reviewCount: 18,
            localityName: 'Koramangala, Bengaluru',
            approxDistanceKm: 0.8,
          ),
          matchScore: 88,
          approxDistanceKm: 0.8,
          explanationTags: [
            'Matching Skills: product, photos',
            'Very Close (0.8 km away)',
            'Tier 1 Verified Phone User',
            'Top Rated (4.7 ★)'
          ],
        ),
      ];

      // Try API match lookup
      if (_currentNeed != null && ApiService.authToken != null) {
        try {
          final res = await ApiService.getMatches(_currentNeed!.id, radiusKm: rad);
          if (res['matches'] != null) {
            final list = (res['matches'] as List)
                .map((m) => MatchModel.fromJson(m))
                .toList();
            if (list.isNotEmpty) {
              _matches = list;
            }
          }
          if (res['metadata'] != null && res['metadata']['expansion_notice'] != null) {
            _statusNotice = res['metadata']['expansion_notice'];
          }
        } catch (e) {
          debugPrint('API match fetch error: $e');
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
