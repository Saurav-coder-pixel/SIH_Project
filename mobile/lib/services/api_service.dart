import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/need_model.dart';
import '../models/match_model.dart';

class ApiService {
  static String baseUrl = 'http://10.0.2.2:5000/api'; // Android Emulator default; change for iOS/Web
  static String? authToken;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // Auth: Send OTP
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: _headers,
      body: jsonEncode({'phone': phone}),
    );
    return jsonDecode(response.body);
  }

  // Auth: Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: _headers,
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );
    final data = jsonDecode(response.body);
    if (data['token'] != null) {
      authToken = data['token'];
    }
    return data;
  }

  // Auth: Register User
  static Future<Map<String, dynamic>> register({
    required String phone,
    required String name,
    required String role,
    String profession = '',
    List<String> skills = const [],
    String localityName = 'Koramangala, Bengaluru',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'phone': phone,
        'name': name,
        'role': role,
        'profession': profession,
        'skills': skills,
        'locality_name': localityName,
        'coordinates': [77.6245, 12.9352], // Koramangala default
      }),
    );
    final data = jsonDecode(response.body);
    if (data['token'] != null) {
      authToken = data['token'];
    }
    return data;
  }

  // Submit Need
  static Future<NeedModel> submitNeed(String rawText, {double radiusKm = 5.0}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/needs'),
      headers: _headers,
      body: jsonEncode({
        'raw_text': rawText,
        'radius_km': radiusKm,
      }),
    );
    final data = jsonDecode(response.body);
    return NeedModel.fromJson(data['need']);
  }

  // Get Need Matches
  static Future<Map<String, dynamic>> getMatches(String needId, {double? radiusKm}) async {
    String url = '$baseUrl/needs/$needId/matches';
    if (radiusKm != null) {
      url += '?radius_km=$radiusKm';
    }
    final response = await http.get(Uri.parse(url), headers: _headers);
    return jsonDecode(response.body);
  }

  // Record Feedback
  static Future<void> sendFeedback(String matchId, String feedbackType) async {
    await http.post(
      Uri.parse('$baseUrl/matches/$matchId/feedback'),
      headers: _headers,
      body: jsonEncode({'feedback_type': feedbackType}),
    );
  }

  // Connection Request
  static Future<Map<String, dynamic>> sendConnectionRequest({
    required String providerId,
    String? needId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connections/requests'),
      headers: _headers,
      body: jsonEncode({
        'provider_id': providerId,
        'need_id': needId,
        'message': message,
      }),
    );
    return jsonDecode(response.body);
  }

  // Respond to Connection Request
  static Future<Map<String, dynamic>> respondConnectionRequest(String requestId, String action) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/connections/requests/$requestId'),
      headers: _headers,
      body: jsonEncode({'action': action}),
    );
    return jsonDecode(response.body);
  }

  // Fetch Connections
  static Future<List<dynamic>> getConnections() async {
    final response = await http.get(Uri.parse('$baseUrl/connections'), headers: _headers);
    final data = jsonDecode(response.body);
    return data['connections'] ?? [];
  }

  // Send Message
  static Future<Map<String, dynamic>> sendMessage(String connectionId, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/conversations/messages'),
      headers: _headers,
      body: jsonEncode({
        'connection_id': connectionId,
        'text': text,
      }),
    );
    return jsonDecode(response.body);
  }

  // Fetch Messages
  static Future<List<dynamic>> getMessages(String connectionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$connectionId/messages'),
      headers: _headers,
    );
    final data = jsonDecode(response.body);
    return data['messages'] ?? [];
  }
}
