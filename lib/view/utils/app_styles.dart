import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_file_upload/view/utils/app_colors.dart';

class AppStyles {
  static final AppStyles _singleton = AppStyles._internal();
  AppStyles._internal();
  static AppStyles get instance => _singleton;

  final TextStyle? appHeaderStyles = GoogleFonts.poppins(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 20.sp,
      color: AppColors.appBackgroundColor);

  final TextStyle? whiteTextStyles = GoogleFonts.poppins(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
      color: AppColors.whiteColor);

  final TextStyle? bottomSheetTextStyles = GoogleFonts.poppins(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
      color: AppColors.whiteColor);

  final TextStyle? indicatorTextStyles = GoogleFonts.poppins(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: AppColors.appBackgroundColor);
}
