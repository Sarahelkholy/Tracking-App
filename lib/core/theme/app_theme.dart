import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AppTheme {
  static ThemeData appTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,

      ///? Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorMaxLines: 2,
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return AppTextStyles.regular12(
              context,
            ).copyWith(color: AppColors.error);
          }
          return AppTextStyles.regular12(
            context,
          ).copyWith(color: AppColors.grayDark);
        }),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return AppTextStyles.regular12(
              context,
            ).copyWith(color: AppColors.error);
          }
          return AppTextStyles.regular12(
            context,
          ).copyWith(color: AppColors.grayDark);
        }),
        filled: true,
        fillColor: AppColors.background,
        errorStyle: AppTextStyles.regular12(
          context,
        ).copyWith(color: AppColors.error),
        hintStyle: AppTextStyles.regular14(
          context,
        ).copyWith(color: AppColors.grayMedium),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.grayDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.grayDark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.grayDark),
        ),
      ),

      ///?  Search Bar
      searchBarTheme: SearchBarThemeData(
        hintStyle: WidgetStatePropertyAll(
          AppTextStyles.medium14(
            context,
          ).copyWith(color: AppColors.textHint, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.background),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.textHint, width: 1.5),
          ),
        ),
      ),

      ///?  Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          disabledForegroundColor: AppColors.background,
          minimumSize: Size(double.infinity, 48),
          textStyle: AppTextStyles.medium16(context),
          foregroundColor: AppColors.background,
          backgroundColor: AppColors.primaryColor,
          disabledBackgroundColor: AppColors.disabledGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),

      ///?  AppBar
      appBarTheme: AppBarTheme(
        titleSpacing: 0,

        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.medium20(
          context,
        ).copyWith(color: AppColors.black100),
        iconTheme: const IconThemeData(color: AppColors.black100),
      ),

      ///?  Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),

      ///?  Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,

        elevation: 1,

        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        indicatorColor: Colors.transparent,

        overlayColor: WidgetStateProperty.all(
          AppColors.primaryColor.withValues(alpha: 0.2),
        ),

        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return AppTextStyles.regular12(context).copyWith(
            color: isSelected ? AppColors.primaryColor : AppColors.disabledGray,
          );
        }),
      ),
    );
  }
}
