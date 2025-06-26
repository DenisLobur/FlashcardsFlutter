import 'package:flutter/material.dart';

class ColorUtils {
  /// Converts a hex color string to a Flutter Color object
  /// 
  /// Example:
  /// ```dart
  /// Color blue = ColorUtils.hexToColor('#2196F3');
  /// Color red = ColorUtils.hexToColor('F44336'); // # is optional
  /// ```
  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  /// Converts a Flutter Color object to a hex string
  /// 
  /// Example:
  /// ```dart
  /// String hexColor = ColorUtils.colorToHex(Colors.blue); // Returns '#2196F3'
  /// ```
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
} 