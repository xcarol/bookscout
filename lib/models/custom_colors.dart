import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color ratedBook;
  final Color navigationBarSelected;
  final Color navigationBarNotSelected;
  final Color dividerColor;
  final Color bottomNavigationBarBackground;
  final Color appBarBackground;
  final Color appBarText;
  final Color chipCardBackground;

  const CustomColors({
    required this.ratedBook,
    required this.navigationBarSelected,
    required this.navigationBarNotSelected,
    required this.dividerColor,
    required this.bottomNavigationBarBackground,
    required this.appBarBackground,
    required this.appBarText,
    required this.chipCardBackground,
  });

  @override
  CustomColors copyWith({
    Color? ratedBook,
    Color? navigationBarSelected,
    Color? navigationBarNotSelected,
    Color? dividerColor,
    Color? bottomNavigationBarBackground,
    Color? appBarBackground,
    Color? appBarText,
    Color? chipCardBackground,
  }) {
    return CustomColors(
      ratedBook: ratedBook ?? this.ratedBook,
      navigationBarSelected:
          navigationBarSelected ?? this.navigationBarSelected,
      navigationBarNotSelected:
          navigationBarNotSelected ?? this.navigationBarNotSelected,
      dividerColor: dividerColor ?? this.dividerColor,
      bottomNavigationBarBackground:
          bottomNavigationBarBackground ?? this.bottomNavigationBarBackground,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarText: appBarText ?? this.appBarText,
      chipCardBackground: chipCardBackground ?? this.chipCardBackground,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      ratedBook: Color.lerp(ratedBook, other.ratedBook, t)!,
      navigationBarSelected: Color.lerp(
        navigationBarSelected,
        other.navigationBarSelected,
        t,
      )!,
      navigationBarNotSelected: Color.lerp(
        navigationBarNotSelected,
        other.navigationBarNotSelected,
        t,
      )!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      bottomNavigationBarBackground: Color.lerp(
        bottomNavigationBarBackground,
        other.bottomNavigationBarBackground,
        t,
      )!,
      appBarBackground: Color.lerp(
        appBarBackground,
        other.appBarBackground,
        t,
      )!,
      appBarText: Color.lerp(appBarText, other.appBarText, t)!,
      chipCardBackground: Color.lerp(chipCardBackground, other.chipCardBackground, t)!,
    );
  }
}
