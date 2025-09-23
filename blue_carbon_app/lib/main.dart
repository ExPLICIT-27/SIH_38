import 'package:blue_carbon_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_carbon_app/data/repositories/auth_repository.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize services
  final apiService = ApiService();
  final authRepository = AuthRepository(apiService);

  runApp(App(authRepository: authRepository));
}
