import 'package:flutter/material.dart';

class QuadernoTheme {
  static ThemeData get themeData {
    final ThemeData theme = ThemeData();
    return theme.copyWith(
      primaryColor: Colors.green,
      colorScheme: theme.colorScheme.copyWith(
        secondary: Colors.amber,
      ),
    );
  }
}
