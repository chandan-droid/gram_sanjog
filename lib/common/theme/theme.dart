import 'package:flutter/material.dart';

class AppColors {
  // === Brand Identity ===
  static const Color primary = Color(0xFF000000);     // Black - used for primary text
  static const Color secondary = Color(0xFF34571C);   // Dark Green - used for secondary UI
  static const Color accent = Color(0xFF820707);      // Maroon Red - used for CTAs
  static const Color highlight = Color(0xFF6C8E2E);   // Light Green - used for emphasis
  static const Color background = Color(0xFFD6D6D6);  // Light Gray - background areas

  // === Text Colors ===
  static const Color textPrimary = primary;           // Headlines, titles
  static const Color textSecondary = Color(0xFF333333); // Subheadings, less emphasized text
  static const Color textMuted = Color(0xFF666666);   // Timestamps, captions, etc.

  // === Backgrounds ===
  static const Color scaffoldBackground = background; // Main app background
  static const Color cardBackground = Color(0xFFF2F2F2); // Cards or article containers
  static const Color inputBackground = Color(0xFFEFEFEF); // TextFields

  // === Button Colors ===
  static const Color buttonPrimary = accent;          // Main buttons (e.g., Submit, Read More)
  static const Color buttonSecondary = secondary;     // Secondary actions
  static const Color buttonText = Colors.white;       // Button text color

  // === Border & Divider Colors ===
  static const Color border = Color(0xFFCCCCCC);      // Default border color
  static const Color divider = Color(0xFFB0B0B0);      // Dividers between sections

  // === Status & Alerts ===
  static const Color success = highlight;             // Approved/verified indicators
  static const Color error = Color(0xFFD32F2F);        // Error messages, alerts
  static const Color warning = Color(0xFFFFA000);      // Warnings or caution
  static const Color info = Color(0xFF1976D2);         // Informational alerts

  // === Icon Colors ===
  static const Color iconPrimary = primary;
  static const Color iconSecondary = secondary;

  // === Other UI Elements ===
  static const Color shimmerBase = Color(0xFFE0E0E0);  // Placeholder loading base
  static const Color shimmerHighlight = Color(0xFFF5F5F5); // Shimmer animation overlay
}
