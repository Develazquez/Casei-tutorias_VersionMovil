import 'package:flutter/material.dart';

import 'cacei_ui_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: CaceiUiColors.appThemeSeed),
      scaffoldBackgroundColor: CaceiUiColors.scaffoldBackground,
    );
  }
}
