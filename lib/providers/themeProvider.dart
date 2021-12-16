import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier({ThemeMode themeMode = ThemeMode.system}) : super(themeMode);

  switchThemeMode(ThemeMode themeMode) => state = themeMode;
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
