import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var roboto = GoogleFonts.roboto();

var largeTitle = roboto.copyWith(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

var heading1 = roboto.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

var heading2 = roboto.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

var body1Regular = roboto.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

var body1Bold = roboto.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

var body2Regular = roboto.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

var body2Bold = roboto.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

var caption = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

var body3Regular = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

var body3Bold = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

var verySmallText = roboto.copyWith(
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

// Colors

const screenBackground = Color(0xFF0F0E0E);
const searchBarBackground = Color(0xFF1E1E1E);
const primaryButton = Color(0xFFD9D9D9);
const posterBorder = Color(0xFFB5A9A9);
const buttonGrey = Color(0xFF504F4F);
const matchGreen = Color(0xFF00C853);
const badgeGrey = Color(0xFF424242);

ThemeData createTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.grey,
      onSecondary: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: Typography.material2021().englishLike.copyWith(
      headlineLarge: heading1,
      headlineMedium: heading2,
      headlineSmall: body2Regular,
      titleLarge: largeTitle,
      titleMedium: heading2,
      titleSmall: body2Bold,
      bodyLarge: body1Regular,
      bodyMedium: body2Regular,
      bodySmall: body3Regular,
      labelLarge: body1Bold,
      labelMedium: body2Bold,
      labelSmall: caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: searchBarBackground,
      labelTextStyle: WidgetStateTextStyle.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Colors.white);
        }
        return TextStyle(color: posterBorder);
      }),
      iconTheme: WidgetStatePropertyAll<IconThemeData>(
        IconThemeData(color: Colors.white),
      ),
      indicatorColor: posterBorder,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: searchBarBackground,
      selectedItemColor: Colors.white,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
    ),
  );
}
