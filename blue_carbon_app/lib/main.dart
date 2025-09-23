import 'package:blue_carbon_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_carbon_app/data/repositories/auth_repository.dart';
import 'package:blue_carbon_app/data/services/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ajexghvwdguxhapzbzhc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqZXhnaHZ3ZGd1eGhhcHpiemhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2NDQ0MzAsImV4cCI6MjA3NDIyMDQzMH0.ecnRoYXHBtimWmeHnnPPs3VVQ3Z9A-Cl88-dKQn59_o',
    debug: true,
  );
  debugPrint('[Supabase] Initialized url=https://ajexghvwdguxhapzbzhc.supabase.co');

  // Initialize services
  final apiService = ApiService();
  final authRepository = AuthRepository(apiService);

  runApp(App(authRepository: authRepository));
}
