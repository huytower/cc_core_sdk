// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// /// A utility class for formatting values like numbers, dates, and file sizes.
// class FormatUtils {
//   // Constants for file size formatting
//   static const int bytesInKb = 1024;
//   static const int bytesInMb = 1024 * 1024;
//   static const int bytesInGb = 1024 * 1024 * 1024;
//
//   /// Formats a number with commas as thousand separators.
//   ///
//   /// Example: 1000000 -> "1,000,000"
//   static final NumberFormat _numberFormatter =
//       NumberFormat('###,###,###,###.##', 'en_US');
//
//   /// Formats a phone number with spaces.
//   ///
//   /// Example: "0901234567" -> "090 123 4567"
//   static final NumberFormat _phoneNumberFormatter =
//       NumberFormat('### ### ####', 'en_US');
//
//   /// Formats a file size in bytes to a human-readable string.
//   ///
//   /// Example: 1024 -> "1.0 KB"
//   static String formatFileSize(int bytes) {
//     if (bytes >= bytesInGb) {
//       return '${(bytes / bytesInGb).toStringAsFixed(1)} GB';
//     } else if (bytes >= bytesInMb) {
//       return '${(bytes / bytesInMb).toStringAsFixed(1)} MB';
//     } else if (bytes >= bytesInKb) {
//       return '${(bytes / bytesInKb).toStringAsFixed(1)} KB';
//     } else {
//       return '$bytes B';
//     }
//   }
//
//   /// Formats a number with thousand separators.
//   static String formatNumber(num number) => _numberFormatter.format(number);
//
//   /// Formats a phone number with spaces.
//   static String formatPhoneNumber(String phoneNumber) {
//     try {
//       final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
//       return _phoneNumberFormatter.format(int.tryParse(digits) ?? 0);
//     } catch (e) {
//       return phoneNumber;
//     }
//   }
//
//   /// Formats in-app purchase prices for Vietnamese locale.
//   static List<String> formatIapPricesForVn(List<String> prices) {
//     return prices.map((price) {
//       if (!price.contains('000')) return price;
//
//       if (Platform.isIOS || Platform.isMacOS) {
//         return price.substring(1).replaceAll('000', 'k');
//       } else if (Platform.isAndroid) {
//         return price.substring(0, price.length - 1).replaceAll('.000', 'k');
//       }
//       return price;
//     }).toList();
//   }
//
//   /// Creates a responsive text style based on screen width.
//   ///
//   /// [context] - The build context
//   /// [baseSize] - Base font size in logical pixels
//   /// [minSize] - Minimum font size
//   /// [maxSize] - Maximum font size
//   static double responsiveFontSize(
//     BuildContext context, {
//     required double baseSize,
//     double minSize = 12.0,
//     double maxSize = 24.0,
//   }) {
//     final width = MediaQuery.of(context).size.width;
//     final scale = (width / 360.0).clamp(0.8, 1.5);
//     return (baseSize * scale).clamp(minSize, maxSize);
//   }
// }
