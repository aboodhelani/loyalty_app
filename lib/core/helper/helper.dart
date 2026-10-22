import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../features/auth/data/data_sources/local/auth_shared_prefs.dart';
import '../utils/constant/app_constants.dart';
import '../utils/injections.dart';

class Helper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// English only for the MVP; formatting and API headers use this locale.
  static const String locale = 'en';

  /// Get svg picture path
  static String getSvgPath(String name) {
    return "$svgPath$name";
  }

  /// Get image picture path
  static String getImagePath(String name) {
    return "$imagePath$name";
  }

  /// Get vertical space
  static double getVerticalSpace() {
    return 10.h;
  }

  /// Get horizontal space
  static double getHorizontalSpace() {
    return 10.w;
  }

  /// Get Dio Header with auth token
  static Map<String, dynamic> getHeaders() {
    final headers = <String, dynamic>{
      'Accept': 'application/json',
      'Accept-Language': 'en_US',
    };
    final token = getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    headers.removeWhere((key, value) => value == null);
    return headers;
  }

  static String? getToken() {
    try {
      return sl<AuthSharedPrefs>().getToken();
    } catch (_) {
      return null;
    }
  }

  /// "AED 50" / "AED 12.50" — whole amounts drop the decimals.
  static String formatMoney(double amount, [String currency = defaultCurrency]) {
    final value = amount == amount.roundToDouble() ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
    return '$currency $value';
  }

  static String formatDistance(double? km) {
    if (km == null) return '';
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  static String formatDate(DateTime date) => DateFormat.yMMMd(locale).format(date);

  static String formatDateTime(DateTime date) => DateFormat.yMMMd(locale).add_jm().format(date);

  static String formatTime(DateTime date) => DateFormat.jm(locale).format(date);
}
