import 'package:flutter/material.dart';

/// App color palette for Blue Carbon MRV platform
/// Inspired by marine ecosystems and carbon sequestration environments
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary Colors - Deep Ocean Ecosystem
  static const Color deepOceanBlue = Color(0xFF0B2447);
  static const Color abyssalBlue = Color(0xFF19376D);
  static const Color coastalTeal = Color(0xFF0F4C75);
  static const Color aquaMarine = Color(0xFF16537e);

  /// Secondary Colors - Coastal Vegetation
  static const Color seagrassGreen = Color(0xFF2E8B57);
  static const Color mangroveDark = Color(0xFF355E3B);
  static const Color kelp = Color(0xFF4F7942);
  static const Color algaeGreen = Color(0xFF6B8E23);

  /// Accent Colors - Marine Life & Coral
  static const Color coralPink = Color(0xFFFF6B9D);
  static const Color pearlWhite = Color(0xFFF8F9FA);
  static const Color seaFoam = Color(0xFFE0F2E7);
  static const Color sandyBeige = Color(0xFFF5F1EB);

  /// Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF2C3E50);
  static const Color slateGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF1F5F9);

  /// Status Colors
  static const Color success = seagrassGreen;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = coralPink;
  static const Color info = coastalTeal;

  /// Gradient Collections
  static const List<Color> oceanDepthGradient = [deepOceanBlue, abyssalBlue, coastalTeal];
  static const List<Color> coastalGradient = [coastalTeal, aquaMarine];
  static const List<Color> vegetationGradient = [seagrassGreen, kelp, mangroveDark];
  static const List<Color> surfaceGradient = [seaFoam, pearlWhite];
  static const List<Color> sunsetGradient = [Color(0xFFFF8A80), Color(0xFFFFB74D), Color(0xFF81C784)];

  /// Specialized Colors for Blue Carbon Elements
  static const Color carbonBlue = Color(0xFF1E3A8A);
  static const Color sequestrationGreen = Color(0xFF059669);
  static const Color verificationGold = Color(0xFFF59E0B);
  static const Color monitoringPurple = Color(0xFF7C3AED);

  /// Opacity Variations
  static Color get deepOceanBlueOpacity10 => deepOceanBlue.withOpacity(0.1);
  static Color get deepOceanBlueOpacity20 => deepOceanBlue.withOpacity(0.2);
  static Color get coastalTealOpacity10 => coastalTeal.withOpacity(0.1);
  static Color get coastalTealOpacity20 => coastalTeal.withOpacity(0.2);
  static Color get seagrassGreenOpacity10 => seagrassGreen.withOpacity(0.1);
  static Color get seagrassGreenOpacity20 => seagrassGreen.withOpacity(0.2);
}
