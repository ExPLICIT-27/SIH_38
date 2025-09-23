import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_carbon_app/core/constants/api_constants.dart';
import 'package:blue_carbon_app/data/models/models.dart';

/// Service for handling API requests
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests if available
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Handle unauthorized
            debugPrint('Unauthorized: ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Authentication methods
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(ApiConstants.login, data: request.toJson());

      // Backend returns { token } or { error }
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error')) {
        throw Exception(data['error'] as String);
      }

      final token = data['token'] as String;
      final payload = _decodeJwtPayload(token);

      // Build a minimal UserModel from JWT claims
      final roleClaim = (payload['role'] as String?) ?? 'MEMBER';
      final user = UserModel(
        id: (payload['sub'] ?? payload['userId'] ?? '') as String,
        email: (payload['email'] ?? '') as String,
        role: _mapUserRole(roleClaim),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return AuthResponse(accessToken: token, user: user);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      // Backend does not have a separate signup; reuse login with email + code
      final loginReq = LoginRequest(email: request.email, code: request.code);
      return await login(loginReq);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> requestOtp(String email) async {
    try {
      await _dio.post(ApiConstants.requestOtp, data: {'email': email});
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Organization methods
  Future<List<OrganizationModel>> getOrganizations() async {
    try {
      final response = await _dio.get(ApiConstants.organizations);
      return (response.data as List).map((json) => OrganizationModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<OrganizationModel> getOrganizationById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.organizationById}$id');
      return OrganizationModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<OrganizationModel> createOrganization(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.organizations, data: data);
      return OrganizationModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Project methods
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _dio.get(ApiConstants.projects);
      return (response.data as List).map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProjectModel> getProjectById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.projectById}$id');
      return ProjectModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProjectModel> createProject(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.projects, data: data);
      return ProjectModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Upload methods
  Future<DataUploadModel> uploadFile(File file, Map<String, dynamic> metadata) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        'metadata': jsonEncode(metadata),
      });

      final response = await _dio.post(
        ApiConstants.uploads,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // Backend returns only { id, sha256, path, cid } on upload
      final id = (response.data as Map<String, dynamic>)['id'] as String?;
      if (id == null) {
        throw Exception('Upload failed: no id returned');
      }

      // Fetch full metadata
      final meta = await _dio.get('${ApiConstants.uploadById}$id');
      return DataUploadModel.fromJson(meta.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<DataUploadModel> getUploadById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.uploadById}$id');
      return DataUploadModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Verification methods
  Future<VerificationModel> createVerification(Map<String, dynamic> data) async {
    try {
      // Backend exposes verification under /v1/registry/verify
      final response = await _dio.post('${ApiConstants.registry}/verify', data: data);
      return VerificationModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // No separate anchor endpoint in backend; anchoring is part of verification payload

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout) {
        return const SocketException('Connection timeout');
      }

      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final data = error.response!.data;

        if (statusCode == 401) {
          return Exception('Unauthorized');
        } else if (statusCode == 404) {
          return Exception('Resource not found');
        } else if (data != null && data is Map<String, dynamic> && data.containsKey('message')) {
          return Exception(data['message']);
        }
      }
    }

    return Exception('Something went wrong. Please try again later.');
  }

  // Helpers
  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return <String, dynamic>{};
      final normalized = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(payloadString);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  UserRole _mapUserRole(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'ORG_ADMIN':
        return UserRole.orgAdmin;
      case 'VERIFIER':
        return UserRole.verifier;
      case 'MEMBER':
      default:
        return UserRole.member;
    }
  }
}
