import "package:flutter/material.dart";

/// Material 3 theme adapted to the CASEI Tutorías visual system.
///
/// Base visual direction taken from the current web/Figma mockups:
/// - light academic dashboard
/// - soft white cards
/// - blue primary actions
/// - teal / red / amber academic status colors
/// - subtle borders and neutral surfaces
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // ---------------------------------------------------------------------------
  // MAIN COLOR SCHEMES
  // ---------------------------------------------------------------------------

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,

      // Main brand/action color.
      primary: Color(0xff2563eb),
      surfaceTint: Color(0xff2563eb),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdbeafe),
      onPrimaryContainer: Color(0xff1e3a8a),

      // Secondary accent used for "Atípico" and successful/teal states.
      secondary: Color(0xff14b8a6),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffccfbf1),
      onSecondaryContainer: Color(0xff0f766e),

      // Tertiary accent used for "Riesgo moderado" / amber indicators.
      tertiary: Color(0xfff59e0b),
      onTertiary: Color(0xff111827),
      tertiaryContainer: Color(0xfffef3c7),
      onTertiaryContainer: Color(0xff92400e),

      // Critical/error state.
      error: Color(0xffef4444),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffe4e6),
      onErrorContainer: Color(0xffb91c1c),

      // App surfaces.
      surface: Color(0xfff4f6f8),
      onSurface: Color(0xff0f172a),
      onSurfaceVariant: Color(0xff64748b),

      outline: Color(0xffcbd5e1),
      outlineVariant: Color(0xffe2e8f0),

      shadow: Color(0xff000000),
      scrim: Color(0xff000000),

      inverseSurface: Color(0xff1e293b),
      onInverseSurface: Color(0xfff8fafc),
      inversePrimary: Color(0xff93c5fd),

      primaryFixed: Color(0xffdbeafe),
      onPrimaryFixed: Color(0xff172554),
      primaryFixedDim: Color(0xffbfdbfe),
      onPrimaryFixedVariant: Color(0xff1d4ed8),

      secondaryFixed: Color(0xffccfbf1),
      onSecondaryFixed: Color(0xff042f2e),
      secondaryFixedDim: Color(0xff99f6e4),
      onSecondaryFixedVariant: Color(0xff0f766e),

      tertiaryFixed: Color(0xfffef3c7),
      onTertiaryFixed: Color(0xff451a03),
      tertiaryFixedDim: Color(0xfffde68a),
      onTertiaryFixedVariant: Color(0xff92400e),

      surfaceDim: Color(0xffe5e7eb),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8fafc),
      surfaceContainer: Color(0xfff1f5f9),
      surfaceContainerHigh: Color(0xffe2e8f0),
      surfaceContainerHighest: Color(0xffcbd5e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme(), AppThemeColors.light);
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1d4ed8),
      surfaceTint: Color(0xff2563eb),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2563eb),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0f766e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff14b8a6),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffd97706),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff59e0b),
      onTertiaryContainer: Color(0xff111827),
      error: Color(0xffdc2626),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffef4444),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4f6f8),
      onSurface: Color(0xff020617),
      onSurfaceVariant: Color(0xff334155),
      outline: Color(0xff64748b),
      outlineVariant: Color(0xff94a3b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff1e293b),
      onInverseSurface: Color(0xfff8fafc),
      inversePrimary: Color(0xff93c5fd),
      primaryFixed: Color(0xffdbeafe),
      onPrimaryFixed: Color(0xff172554),
      primaryFixedDim: Color(0xffbfdbfe),
      onPrimaryFixedVariant: Color(0xff1d4ed8),
      secondaryFixed: Color(0xffccfbf1),
      onSecondaryFixed: Color(0xff042f2e),
      secondaryFixedDim: Color(0xff99f6e4),
      onSecondaryFixedVariant: Color(0xff0f766e),
      tertiaryFixed: Color(0xfffef3c7),
      onTertiaryFixed: Color(0xff451a03),
      tertiaryFixedDim: Color(0xfffde68a),
      onTertiaryFixedVariant: Color(0xff92400e),
      surfaceDim: Color(0xffd1d5db),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8fafc),
      surfaceContainer: Color(0xffeef2f7),
      surfaceContainerHigh: Color(0xffdbe3ee),
      surfaceContainerHighest: Color(0xffcbd5e1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme(), AppThemeColors.light);
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1e40af),
      surfaceTint: Color(0xff2563eb),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1d4ed8),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0f766e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff0d9488),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffb45309),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd97706),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffb91c1c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffdc2626),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4f6f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff0f172a),
      outline: Color(0xff334155),
      outlineVariant: Color(0xff475569),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff1e293b),
      onInverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xffbfdbfe),
      primaryFixed: Color(0xffdbeafe),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbfdbfe),
      onPrimaryFixedVariant: Color(0xff172554),
      secondaryFixed: Color(0xffccfbf1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff99f6e4),
      onSecondaryFixedVariant: Color(0xff042f2e),
      tertiaryFixed: Color(0xfffef3c7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfffde68a),
      onTertiaryFixedVariant: Color(0xff451a03),
      surfaceDim: Color(0xffcbd5e1),
      surfaceBright: Color(0xffffffff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8fafc),
      surfaceContainer: Color(0xffe2e8f0),
      surfaceContainerHigh: Color(0xffcbd5e1),
      surfaceContainerHighest: Color(0xff94a3b8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme(), AppThemeColors.lightHighContrast);
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xff93c5fd),
      surfaceTint: Color(0xff93c5fd),
      onPrimary: Color(0xff172554),
      primaryContainer: Color(0xff1e3a8a),
      onPrimaryContainer: Color(0xffdbeafe),

      secondary: Color(0xff5eead4),
      onSecondary: Color(0xff042f2e),
      secondaryContainer: Color(0xff115e59),
      onSecondaryContainer: Color(0xffccfbf1),

      tertiary: Color(0xfffbbf24),
      onTertiary: Color(0xff451a03),
      tertiaryContainer: Color(0xff92400e),
      onTertiaryContainer: Color(0xfffef3c7),

      error: Color(0xfffca5a5),
      onError: Color(0xff7f1d1d),
      errorContainer: Color(0xff991b1b),
      onErrorContainer: Color(0xffffe4e6),

      surface: Color(0xff0f172a),
      onSurface: Color(0xffe5e7eb),
      onSurfaceVariant: Color(0xffcbd5e1),

      outline: Color(0xff94a3b8),
      outlineVariant: Color(0xff334155),

      shadow: Color(0xff000000),
      scrim: Color(0xff000000),

      inverseSurface: Color(0xffe2e8f0),
      onInverseSurface: Color(0xff0f172a),
      inversePrimary: Color(0xff2563eb),

      primaryFixed: Color(0xffdbeafe),
      onPrimaryFixed: Color(0xff172554),
      primaryFixedDim: Color(0xffbfdbfe),
      onPrimaryFixedVariant: Color(0xff1d4ed8),

      secondaryFixed: Color(0xffccfbf1),
      onSecondaryFixed: Color(0xff042f2e),
      secondaryFixedDim: Color(0xff99f6e4),
      onSecondaryFixedVariant: Color(0xff0f766e),

      tertiaryFixed: Color(0xfffef3c7),
      onTertiaryFixed: Color(0xff451a03),
      tertiaryFixedDim: Color(0xfffde68a),
      onTertiaryFixedVariant: Color(0xff92400e),

      surfaceDim: Color(0xff0f172a),
      surfaceBright: Color(0xff334155),
      surfaceContainerLowest: Color(0xff020617),
      surfaceContainerLow: Color(0xff111827),
      surfaceContainer: Color(0xff1e293b),
      surfaceContainerHigh: Color(0xff334155),
      surfaceContainerHighest: Color(0xff475569),
    );
  }

  ThemeData dark() {
    return theme(darkScheme(), AppThemeColors.dark);
  }

  static ColorScheme darkMediumContrastScheme() {
    return darkScheme();
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme(), AppThemeColors.dark);
  }

  static ColorScheme darkHighContrastScheme() {
    return darkScheme();
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme(), AppThemeColors.darkHighContrast);
  }

  // ---------------------------------------------------------------------------
  // THEME DATA
  // ---------------------------------------------------------------------------

  ThemeData theme(
    ColorScheme colorScheme, [
    AppThemeColors appColors = AppThemeColors.light,
  ]) =>
      ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        fontFamily: 'Roboto', // Garantiza legibilidad académica
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
          fontFamily: 'Roboto',
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        dividerColor: colorScheme.outlineVariant,
        cardTheme: CardThemeData(
          color: appColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: appColors.cardBorder),
          ),
        ),
        extensions: <ThemeExtension<dynamic>>[
          appColors,
        ],
      );

  /// Extra semantic colors for CASEI-specific UI elements.
  ///
  /// Usage:
  /// `final colors = Theme.of(context).extension<AppThemeColors>()!;`
  /// `colors.profileRegular`
  /// `colors.profileCriticalContainer`
  List<ExtendedColor> get extendedColors => [
        ExtendedColor(
          seed: AppThemeColors.light.profileRegular,
          value: AppThemeColors.light.profileRegular,
          light: const ColorFamily(
            color: Color(0xff3b82f6),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffeff6ff),
            onColorContainer: Color(0xff1d4ed8),
          ),
          lightHighContrast: const ColorFamily(
            color: Color(0xff1d4ed8),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffdbeafe),
            onColorContainer: Color(0xff172554),
          ),
          lightMediumContrast: const ColorFamily(
            color: Color(0xff2563eb),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffdbeafe),
            onColorContainer: Color(0xff1e3a8a),
          ),
          dark: const ColorFamily(
            color: Color(0xff93c5fd),
            onColor: Color(0xff172554),
            colorContainer: Color(0xff1e3a8a),
            onColorContainer: Color(0xffdbeafe),
          ),
          darkHighContrast: const ColorFamily(
            color: Color(0xffbfdbfe),
            onColor: Color(0xff000000),
            colorContainer: Color(0xff1d4ed8),
            onColorContainer: Color(0xffffffff),
          ),
          darkMediumContrast: const ColorFamily(
            color: Color(0xff93c5fd),
            onColor: Color(0xff172554),
            colorContainer: Color(0xff1e40af),
            onColorContainer: Color(0xffffffff),
          ),
        ),
        ExtendedColor(
          seed: AppThemeColors.light.profileAtypical,
          value: AppThemeColors.light.profileAtypical,
          light: const ColorFamily(
            color: Color(0xff14b8a6),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffecfdf5),
            onColorContainer: Color(0xff0f766e),
          ),
          lightHighContrast: const ColorFamily(
            color: Color(0xff0f766e),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffccfbf1),
            onColorContainer: Color(0xff042f2e),
          ),
          lightMediumContrast: const ColorFamily(
            color: Color(0xff0d9488),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffccfbf1),
            onColorContainer: Color(0xff115e59),
          ),
          dark: const ColorFamily(
            color: Color(0xff5eead4),
            onColor: Color(0xff042f2e),
            colorContainer: Color(0xff115e59),
            onColorContainer: Color(0xffccfbf1),
          ),
          darkHighContrast: const ColorFamily(
            color: Color(0xff99f6e4),
            onColor: Color(0xff000000),
            colorContainer: Color(0xff0f766e),
            onColorContainer: Color(0xffffffff),
          ),
          darkMediumContrast: const ColorFamily(
            color: Color(0xff5eead4),
            onColor: Color(0xff042f2e),
            colorContainer: Color(0xff0f766e),
            onColorContainer: Color(0xffffffff),
          ),
        ),
        ExtendedColor(
          seed: AppThemeColors.light.profileCritical,
          value: AppThemeColors.light.profileCritical,
          light: const ColorFamily(
            color: Color(0xffef4444),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xfffff1f2),
            onColorContainer: Color(0xffdc2626),
          ),
          lightHighContrast: const ColorFamily(
            color: Color(0xffb91c1c),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffffe4e6),
            onColorContainer: Color(0xff7f1d1d),
          ),
          lightMediumContrast: const ColorFamily(
            color: Color(0xffdc2626),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xffffe4e6),
            onColorContainer: Color(0xff991b1b),
          ),
          dark: const ColorFamily(
            color: Color(0xfffca5a5),
            onColor: Color(0xff7f1d1d),
            colorContainer: Color(0xff991b1b),
            onColorContainer: Color(0xffffe4e6),
          ),
          darkHighContrast: const ColorFamily(
            color: Color(0xffffcaca),
            onColor: Color(0xff000000),
            colorContainer: Color(0xffdc2626),
            onColorContainer: Color(0xffffffff),
          ),
          darkMediumContrast: const ColorFamily(
            color: Color(0xfffca5a5),
            onColor: Color(0xff7f1d1d),
            colorContainer: Color(0xffb91c1c),
            onColorContainer: Color(0xffffffff),
          ),
        ),
        ExtendedColor(
          seed: AppThemeColors.light.profileModerateRisk,
          value: AppThemeColors.light.profileModerateRisk,
          light: const ColorFamily(
            color: Color(0xfff59e0b),
            onColor: Color(0xff111827),
            colorContainer: Color(0xfffffbeb),
            onColorContainer: Color(0xffd97706),
          ),
          lightHighContrast: const ColorFamily(
            color: Color(0xffb45309),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xfffef3c7),
            onColorContainer: Color(0xff451a03),
          ),
          lightMediumContrast: const ColorFamily(
            color: Color(0xffd97706),
            onColor: Color(0xffffffff),
            colorContainer: Color(0xfffef3c7),
            onColorContainer: Color(0xff92400e),
          ),
          dark: const ColorFamily(
            color: Color(0xfffbbf24),
            onColor: Color(0xff451a03),
            colorContainer: Color(0xff92400e),
            onColorContainer: Color(0xfffef3c7),
          ),
          darkHighContrast: const ColorFamily(
            color: Color(0xfffde68a),
            onColor: Color(0xff000000),
            colorContainer: Color(0xffd97706),
            onColorContainer: Color(0xffffffff),
          ),
          darkMediumContrast: const ColorFamily(
            color: Color(0xfffbbf24),
            onColor: Color(0xff451a03),
            colorContainer: Color(0xffb45309),
            onColorContainer: Color(0xffffffff),
          ),
        ),
      ];
}

/// CASEI-specific semantic colors.
///
/// These colors map directly to the web/Figma design:
/// - Regular: blue
/// - Atípico: teal
/// - Crítico: red
/// - Riesgo moderado: amber/orange
/// - Hombres: blue
/// - Mujeres: pink
/// - Cards and borders: soft neutral surfaces
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.profileRegular,
    required this.profileRegularContainer,
    required this.profileAtypical,
    required this.profileAtypicalContainer,
    required this.profileCritical,
    required this.profileCriticalContainer,
    required this.profileModerateRisk,
    required this.profileModerateRiskContainer,
    required this.genderMale,
    required this.genderMaleContainer,
    required this.genderFemale,
    required this.genderFemaleContainer,
    required this.info,
    required this.infoContainer,
    required this.card,
    required this.cardBorder,
    required this.mutedText,
    required this.sidebar,
    required this.sidebarSelected,
  });

  final Color profileRegular;
  final Color profileRegularContainer;
  final Color profileAtypical;
  final Color profileAtypicalContainer;
  final Color profileCritical;
  final Color profileCriticalContainer;
  final Color profileModerateRisk;
  final Color profileModerateRiskContainer;
  final Color genderMale;
  final Color genderMaleContainer;
  final Color genderFemale;
  final Color genderFemaleContainer;
  final Color info;
  final Color infoContainer;
  final Color card;
  final Color cardBorder;
  final Color mutedText;
  final Color sidebar;
  final Color sidebarSelected;

  static const AppThemeColors light = AppThemeColors(
    profileRegular: Color(0xff3b82f6),
    profileRegularContainer: Color(0xffeff6ff),
    profileAtypical: Color(0xff14b8a6),
    profileAtypicalContainer: Color(0xffecfdf5),
    profileCritical: Color(0xffef4444),
    profileCriticalContainer: Color(0xfffff1f2),
    profileModerateRisk: Color(0xfff59e0b),
    profileModerateRiskContainer: Color(0xfffffbeb),
    genderMale: Color(0xff4f9cf9),
    genderMaleContainer: Color(0xffeaf3ff),
    genderFemale: Color(0xfff472b6),
    genderFemaleContainer: Color(0xfffdf2f8),
    info: Color(0xff8b5cf6),
    infoContainer: Color(0xfff3e8ff),
    card: Color(0xffffffff),
    cardBorder: Color(0xffe2e8f0),
    mutedText: Color(0xff94a3b8),
    sidebar: Color(0xff0f172a),
    sidebarSelected: Color(0xff2563eb),
  );

  static const AppThemeColors lightHighContrast = AppThemeColors(
    profileRegular: Color(0xff1d4ed8),
    profileRegularContainer: Color(0xffdbeafe),
    profileAtypical: Color(0xff0f766e),
    profileAtypicalContainer: Color(0xffccfbf1),
    profileCritical: Color(0xffb91c1c),
    profileCriticalContainer: Color(0xffffe4e6),
    profileModerateRisk: Color(0xffb45309),
    profileModerateRiskContainer: Color(0xfffef3c7),
    genderMale: Color(0xff2563eb),
    genderMaleContainer: Color(0xffdbeafe),
    genderFemale: Color(0xffdb2777),
    genderFemaleContainer: Color(0xfffce7f3),
    info: Color(0xff7c3aed),
    infoContainer: Color(0xffede9fe),
    card: Color(0xffffffff),
    cardBorder: Color(0xff94a3b8),
    mutedText: Color(0xff475569),
    sidebar: Color(0xff020617),
    sidebarSelected: Color(0xff1d4ed8),
  );

  static const AppThemeColors dark = AppThemeColors(
    profileRegular: Color(0xff93c5fd),
    profileRegularContainer: Color(0xff1e3a8a),
    profileAtypical: Color(0xff5eead4),
    profileAtypicalContainer: Color(0xff115e59),
    profileCritical: Color(0xfffca5a5),
    profileCriticalContainer: Color(0xff991b1b),
    profileModerateRisk: Color(0xfffbbf24),
    profileModerateRiskContainer: Color(0xff92400e),
    genderMale: Color(0xff93c5fd),
    genderMaleContainer: Color(0xff1e3a8a),
    genderFemale: Color(0xfff9a8d4),
    genderFemaleContainer: Color(0xff831843),
    info: Color(0xffc4b5fd),
    infoContainer: Color(0xff5b21b6),
    card: Color(0xff1e293b),
    cardBorder: Color(0xff475569), // Más claro para contraste
    mutedText: Color(0xffcbd5e1), // Más claro para legibilidad
    sidebar: Color(0xff020617),
    sidebarSelected: Color(0xff93c5fd),
  );

  static const AppThemeColors darkHighContrast = AppThemeColors(
    profileRegular: Color(0xffbfdbfe),
    profileRegularContainer: Color(0xff1d4ed8),
    profileAtypical: Color(0xff99f6e4),
    profileAtypicalContainer: Color(0xff0f766e),
    profileCritical: Color(0xffffcaca),
    profileCriticalContainer: Color(0xffdc2626),
    profileModerateRisk: Color(0xfffde68a),
    profileModerateRiskContainer: Color(0xffd97706),
    genderMale: Color(0xffbfdbfe),
    genderMaleContainer: Color(0xff2563eb),
    genderFemale: Color(0xfffbcfe8),
    genderFemaleContainer: Color(0xffbe185d),
    info: Color(0xffddd6fe),
    infoContainer: Color(0xff6d28d9),
    card: Color(0xff111827),
    cardBorder: Color(0xff64748b),
    mutedText: Color(0xffcbd5e1),
    sidebar: Color(0xff000000),
    sidebarSelected: Color(0xffbfdbfe),
  );

  @override
  AppThemeColors copyWith({
    Color? profileRegular,
    Color? profileRegularContainer,
    Color? profileAtypical,
    Color? profileAtypicalContainer,
    Color? profileCritical,
    Color? profileCriticalContainer,
    Color? profileModerateRisk,
    Color? profileModerateRiskContainer,
    Color? genderMale,
    Color? genderMaleContainer,
    Color? genderFemale,
    Color? genderFemaleContainer,
    Color? info,
    Color? infoContainer,
    Color? card,
    Color? cardBorder,
    Color? mutedText,
    Color? sidebar,
    Color? sidebarSelected,
  }) {
    return AppThemeColors(
      profileRegular: profileRegular ?? this.profileRegular,
      profileRegularContainer:
          profileRegularContainer ?? this.profileRegularContainer,
      profileAtypical: profileAtypical ?? this.profileAtypical,
      profileAtypicalContainer:
          profileAtypicalContainer ?? this.profileAtypicalContainer,
      profileCritical: profileCritical ?? this.profileCritical,
      profileCriticalContainer:
          profileCriticalContainer ?? this.profileCriticalContainer,
      profileModerateRisk: profileModerateRisk ?? this.profileModerateRisk,
      profileModerateRiskContainer:
          profileModerateRiskContainer ?? this.profileModerateRiskContainer,
      genderMale: genderMale ?? this.genderMale,
      genderMaleContainer: genderMaleContainer ?? this.genderMaleContainer,
      genderFemale: genderFemale ?? this.genderFemale,
      genderFemaleContainer: genderFemaleContainer ?? this.genderFemaleContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      mutedText: mutedText ?? this.mutedText,
      sidebar: sidebar ?? this.sidebar,
      sidebarSelected: sidebarSelected ?? this.sidebarSelected,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      profileRegular:
          Color.lerp(profileRegular, other.profileRegular, t)!,
      profileRegularContainer: Color.lerp(
        profileRegularContainer,
        other.profileRegularContainer,
        t,
      )!,
      profileAtypical:
          Color.lerp(profileAtypical, other.profileAtypical, t)!,
      profileAtypicalContainer: Color.lerp(
        profileAtypicalContainer,
        other.profileAtypicalContainer,
        t,
      )!,
      profileCritical:
          Color.lerp(profileCritical, other.profileCritical, t)!,
      profileCriticalContainer: Color.lerp(
        profileCriticalContainer,
        other.profileCriticalContainer,
        t,
      )!,
      profileModerateRisk: Color.lerp(
        profileModerateRisk,
        other.profileModerateRisk,
        t,
      )!,
      profileModerateRiskContainer: Color.lerp(
        profileModerateRiskContainer,
        other.profileModerateRiskContainer,
        t,
      )!,
      genderMale: Color.lerp(genderMale, other.genderMale, t)!,
      genderMaleContainer:
          Color.lerp(genderMaleContainer, other.genderMaleContainer, t)!,
      genderFemale: Color.lerp(genderFemale, other.genderFemale, t)!,
      genderFemaleContainer:
          Color.lerp(genderFemaleContainer, other.genderFemaleContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      sidebarSelected:
          Color.lerp(sidebarSelected, other.sidebarSelected, t)!,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
