import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 2, 1, 166),
  brightness: Brightness.light,
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  surface: Color.fromARGB(255, 255, 255, 255),
  surfaceBright: Color.fromARGB(255, 255, 255, 255),
  surfaceContainerLow: Color.fromARGB(255, 255, 255, 255),
);

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  appBarTheme: AppBarTheme(
    foregroundColor: colorScheme.onPrimary,
    backgroundColor: colorScheme.primary,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: colorScheme.primary,
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(color: colorScheme.onPrimary),
    ),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(color: colorScheme.onPrimary),
    ),
    indicatorColor: colorScheme.secondary,
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
  ),
);
