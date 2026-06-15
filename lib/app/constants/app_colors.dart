// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const Color primaryDark = Color(0xFF0A1F61);   // Dark blue
//   static const Color primary = Color(0xFF2752E7);        // Medium blue
//   static const Color topBgColour = Color(0xFFBCD2FA);        // Medium blue
//   static const Color primaryLight = Color(0xFF4F7BFF);   // Light blue
//
//   static const Color textDark = Color(0xFF000000);
//   static const Color grey = Color(0xFF9E9E9E);
//   static const Color white = Colors.white;
//
//
//   static const Color kPrimaryBlue = Color(0xff1E3A8A); // radio + text
//   static const Color kBorder = Color(0xffE2E8F0);
//   static const Color kHint = Color(0xff94A3B8);
//   static const Color kCardBg = Colors.white;
//
//   static const bg = Color(0xffEEF3FF);
//   // static const primary = Color(0xff4A67F6);
//   // static const textDark = Color(0xff1C1C1E);
//   static const textGrey = Color(0xff8E8E93);
//   static const border = Color(0xffE5E7EB);
//   static const success = Color(0xff4CAF50);
//
//   static const Color primaryBlue = Color(0xFF4865F6);
//   static const Color bgColor = Color(0xFFF6F8FF);
//   static const Color cardColor = Color(0xFFFFFFFF);
//   static const Color greyText = Color(0xFF8E8E93);
//   static const Color lightGrey = Color(0xFFE5E7EF);
//   static const Color starColor = Color(0xFFFFC107);
//   static const borderGrey = Color(0xFFEAEAEA);
//
//
//   static const LinearGradient bgGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       // primaryDark,
//       primary,
//       primaryLight,
//     ],
//   );
//   static const LinearGradient bgTopGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       // primaryDark,
//       topBgColour,
//       white,
//     ],
//   );
//
//   static final BoxShadow cardShadow = BoxShadow(
//     color: Colors.black.withOpacity(0.06),
//     blurRadius: 18,
//     offset: const Offset(0, 8),
//   );
//
// }
//

// import 'package:flutter/material.dart';
//
// class AppColors {
//   // ================= PRIMARY (UNCHANGED – SAFE) =================
//   static const Color primaryDark = Color(0xFF03060F);
//   static const Color primary     = Color(0xFF0E1D3A);
//   static const Color topBgColour = Color(0xFF182F58);
//   static const Color primaryLight= Color(0xFF2B9BE6);
//
//   // ================= NEUTRALS =================
//   static const Color textDark = Color(0xFF000000);
//   static const Color grey = Color(0xFF9E9E9E);
//   static const Color white = Colors.white;
//
//   // ================= EXISTING (SAFE) =================
//   static const Color kPrimaryBlue = Color(0xFF182F58);
//   static const Color kBorder = Color(0xffE2E8F0);
//   static const Color kHint = Color(0xff94A3B8);
//   static const Color kCardBg = Colors.white;
//
//   static const bg = Color(0xffEEF3FF);
//   static const textGrey = Color(0xff8E8E93);
//   static const border = Color(0xffE5E7EB);
//   static const success = Color(0xff4CAF50);
//
//   static const Color primaryBlue = Color(0xFF27528D);
//   static const Color bgColor = Color(0xFFF6F8FF);
//   static const Color cardColor = Color(0xFFFFFFFF);
//   static const Color greyText = Color(0xFF8E8E93);
//   static const Color lightGrey = Color(0xFFE5E7EF);
//
//   static const Color starColor = Color(0xFFF0CB57);
//   static const borderGrey = Color(0xFFEAEAEA);
//
//   // ================= 🔥 NEW PREMIUM COLORS (SAFE ADD) =================
//
//   /// Neon / glow accent (logo highlight)
//   static const Color neonBlue = Color(0xFF00D1FF);
//
//   /// Deep glass background
//   static const Color glassDark = Color(0xFF0B2A76);
//
//   /// Soft card overlay (glass effect)
//   static const Color glassWhite = Color(0x1AFFFFFF); // white with opacity
//
//   /// Dark surface for cards
//   static const Color surfaceDark = Color(0xFF061A3A);
//
//   /// Accent secondary
//   static const Color accentBlue = Color(0xFF3FA9F5);
//
//   // ================= 🔥 PREMIUM GRADIENTS =================
//
//   /// Main app gradient (background)
//   static const LinearGradient bgGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       primaryDark,
//       primary,
//       primaryLight,
//     ],
//   );
//
//   /// Top section gradient
//   static const LinearGradient bgTopGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       topBgColour,
//       white,
//     ],
//   );
//
//   /// 🔥 NEW: Premium dark gradient (dashboard sections)
//   static const LinearGradient darkGradient = LinearGradient(
//     colors: [
//       Color(0xFF061A3A),
//       Color(0xFF0B2A76),
//       Color(0xFF0F4C97),
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   /// 🔥 NEW: Neon glow gradient
//   static const LinearGradient glowGradient = LinearGradient(
//     colors: [
//       neonBlue,
//       primaryLight,
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   /// 🔥 NEW: Card gradient (for premium cards)
//   static const LinearGradient cardGradient = LinearGradient(
//     colors: [
//       Color(0xFF0F4C97),
//       Color(0xFF0B2A76),
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   // ================= 🔥 SHADOWS =================
//
//   static final BoxShadow cardShadow = BoxShadow(
//     color: Colors.black.withOpacity(0.06),
//     blurRadius: 18,
//     offset: const Offset(0, 8),
//   );
//
//   /// 🔥 NEW: Glow shadow
//   static BoxShadow glowShadow(Color color) {
//     return BoxShadow(
//       color: color.withOpacity(0.4),
//       blurRadius: 16,
//       offset: const Offset(0, 6),
//     );
//   }
//
//   /// 🔥 NEW: Heavy premium shadow
//   static final BoxShadow premiumShadow = BoxShadow(
//     color: Colors.black.withOpacity(0.4),
//     blurRadius: 20,
//     offset: const Offset(0, 10),
//   );
// }

import 'package:flutter/material.dart';

class AppColors {
  // ================= PRIMARY (UPDATED AS PER LOGO) =================
  static const Color primaryDark = Color(0xFF0D0D0D);   // black
  static const Color primary     = Color(0xFF1A1A1A);   // soft black
  static const Color topBgColour = Color(0xFF000000);   // pure black
  static const Color primaryLight= Color(0xFFD4AF37);   // gold

  // ================= NEUTRALS =================
  static const Color textDark = Color(0xFFFFFFFF); // white (dark bg ke liye)
  static const Color grey = Color(0xFF9E9E9E);
  static const Color white = Colors.white;

  // ================= EXISTING (UPDATED COLORS ONLY) =================
  static const Color kPrimaryBlue = Color(0xFFD4AF37); // gold
  static const Color kBorder = Color(0x33D4AF37); // gold light border
  static const Color kHint = Color(0xFFBDBDBD);
  static const Color kCardBg = Color(0xFF1A1A1A); // dark card

  static const bg = Color(0xFF0D0D0D); // full dark bg
  static const textGrey = Color(0xFFBDBDBD);
  static const border = Color(0x33D4AF37);
  static const success = Color(0xff4CAF50);

  static const Color primaryBlue = Color(0xFFD4AF37); // gold
  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color greyText = Color(0xFFBDBDBD);
  static const Color lightGrey = Color(0xFF2A2A2A);

  static const Color starColor = Color(0xFFD4AF37);
  static const borderGrey = Color(0x33D4AF37);

  // ================= 🔥 NEW PREMIUM COLORS (UNCHANGED NAMES) =================

  static const Color neonBlue = Color(0xFFD4AF37); // gold replace
  static const Color glassDark = Color(0xFF1A1A1A);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color surfaceDark = Color(0xFF0D0D0D);
  static const Color accentBlue = Color(0xFFF5D76E); // light gold

  // ================= 🔥 PREMIUM GRADIENTS =================

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryDark,
      primary,
      primaryLight,
    ],
  );

  static const LinearGradient bgTopGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      topBgColour,
      white,
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF0D0D0D),
      Color(0xFF1A1A1A),
      Color(0xFFD4AF37),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFF5D76E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFF1A1A1A),
      Color(0xFF0D0D0D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ================= 🔥 SHADOWS =================

  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.4),
    blurRadius: 18,
    offset: const Offset(0, 8),
  );

  static BoxShadow glowShadow(Color color) {
    return BoxShadow(
      color: color.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 6),
    );
  }

  static final BoxShadow premiumShadow = BoxShadow(
    color: Colors.black.withOpacity(0.6),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}