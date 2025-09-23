import 'package:flutter/material.dart';

/// App color palette for Blue Carbon MRV platform
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary Colors
  static const Color deepOceanBlue = Color(0xFF1B4B73);
  static const Color coastalTeal = Color(0xFF2E8B8B);
  static const Color seagrassGreen = Color(0xFF4A7C59);
  static const Color mangroveDark = Color(0xFF2F4F2F);

  /// Supporting Colors
  static const Color coralAccent = Color(0xFFFF7F7F);
  static const Color sandyBeige = Color(0xFFF5E6D3);
  static const Color oceanFoam = Color(0xFFE8F4F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF2C3E50);

  /// Status Colors
  static const Color success = seagrassGreen;
  static const Color warning = Color(0xFFFFB347);
  static const Color error = coralAccent;
  static const Color info = coastalTeal;

  /// Gradient Colors
  static const List<Color> oceanGradient = [deepOceanBlue, coastalTeal];

  static const List<Color> greenGradient = [seagrassGreen, mangroveDark];
}
