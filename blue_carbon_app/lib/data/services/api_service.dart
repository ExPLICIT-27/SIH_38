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
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(ApiConstants.signup, data: request.toJson());
      return AuthResponse.fromJson(response.data);
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

      return DataUploadModel.fromJson(response.data);
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
      final response = await _dio.post(ApiConstants.verifications, data: data);
      return VerificationModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<VerificationModel> anchorVerification(String id) async {
    try {
      final response = await _dio.post('${ApiConstants.verificationById}$id${ApiConstants.anchorVerification}');
      return VerificationModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

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
}
