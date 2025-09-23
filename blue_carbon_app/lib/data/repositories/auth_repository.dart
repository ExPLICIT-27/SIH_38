import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_carbon_app/data/models/models.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter/foundation.dart';

class AuthRepository {
  // Keep for future backend calls; currently Supabase handles auth directly.
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<bool> isLoggedIn() async {
    final client = supabase.Supabase.instance.client;
    if (client.auth.currentSession != null) {
      debugPrint('[Auth] Session found for user ${client.auth.currentUser?.id}');
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  Future<UserModel?> getCurrentUser() async {
    final client = supabase.Supabase.instance.client;
    final u = client.auth.currentUser;
    if (u != null) {
      debugPrint('[Auth] getCurrentUser from Supabase: ${u.id}');
      return UserModel(
        id: u.id,
        email: u.email ?? '',
        role: UserRole.member,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    debugPrint('[Auth] getCurrentUser from local cache');
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  Future<AuthResponse> login(String email, String code) async {
    final client = supabase.Supabase.instance.client;
    debugPrint('[Auth] Verifying OTP for $email');
    final res = await client.auth.verifyOTP(
      email: email,
      token: code,
      type: supabase.OtpType.email,
    );
    final session = res.session;
    final user = res.user ?? client.auth.currentUser;
    if (session == null || user == null) {
      throw Exception('Invalid OTP');
    }
    debugPrint('[Auth] Login successful: user=${user.id}, expiresIn=${session.expiresIn}');
    final userModel = UserModel(
      id: user.id,
      email: user.email ?? '',
      role: UserRole.member,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final auth = AuthResponse(accessToken: session.accessToken, user: userModel);
    await _saveAuthData(auth);
    return auth;
  }

  Future<AuthResponse> signup(String email, String code, String name) async {
    // For passwordless, verifying the OTP creates the session (sign-up on demand)
    return login(email, code);
  }

  Future<void> requestOtp(String email) async {
    final client = supabase.Supabase.instance.client;
    debugPrint('[Auth] Requesting OTP for $email');
    await client.auth.signInWithOtp(email: email);
  }

  Future<void> logout() async {
    final client = supabase.Supabase.instance.client;
    debugPrint('[Auth] Signing out');
    await client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('current_user');
  }

  Future<void> _saveAuthData(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response.accessToken);
    await prefs.setString('current_user', jsonEncode(response.user.toJson()));
  }
}
