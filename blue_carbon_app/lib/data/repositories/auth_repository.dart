import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_carbon_app/data/models/models.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  Future<AuthResponse> login(String email, String code) async {
    final request = LoginRequest(email: email, code: code);
    final response = await _apiService.login(request);

    await _saveAuthData(response);
    return response;
  }

  Future<AuthResponse> signup(String email, String code, String name) async {
    // No dedicated signup on backend; fallback to login
    final request = LoginRequest(email: email, code: code);
    final response = await _apiService.login(request);
    await _saveAuthData(response);
    return response;
  }

  Future<void> requestOtp(String email) async {
    await _apiService.requestOtp(email);
  }

  Future<void> logout() async {
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
