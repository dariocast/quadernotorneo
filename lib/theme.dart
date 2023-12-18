import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuadernoTheme {
  static ThemeData get themeData {
    final ThemeData theme = ThemeData(useMaterial3: false);
    return theme.copyWith(
      primaryColor: Colors.green,
      textTheme: GoogleFonts.openSansTextTheme(),
      iconTheme: theme.iconTheme.copyWith(),
      colorScheme: theme.colorScheme.copyWith(
        primary: Colors.green,
        secondary: Colors.amber,
      ),
    );
  }
}
