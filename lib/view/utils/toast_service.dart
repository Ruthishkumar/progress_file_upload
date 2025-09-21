import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastServices {
  static final ToastServices _singleton = ToastServices._internal();

  final GlobalKey<NavigatorState> globalKey = GlobalKey();

  factory ToastServices() {
    return _singleton;
  }
  ToastServices._internal();

  showSuccess(String? msg, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        msg ?? '',
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showError(String? msg, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        msg ?? '',
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
