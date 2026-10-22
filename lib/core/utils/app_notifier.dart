import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/app_colors.dart';

class AppNotifier extends ChangeNotifier {
  Color _brandColor = AppColors.primaryColor;
  Color _brandHover = AppColors.primaryHover;
  Color _brandSoft = AppColors.primarySoft;
  Color _brandRing = AppColors.primaryRing;

  AppNotifier() {
    _initialise();
  }

  Color get brandColor => _brandColor;
  Color get brandHover => _brandHover;
  Color get brandSoft => _brandSoft;
  Color get brandRing => _brandRing;

  Future _initialise() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    notifyListeners();
  }

  /// Rebrands the whole app (theme + tokens) at runtime.
  void updateBrandColor(Color? color) {
    if (color != null) {
      AppColors.applyBrand(color);
    } else {
      AppColors.resetBrand();
    }
    _brandColor = AppColors.primary;
    _brandHover = AppColors.primaryHover;
    _brandSoft = AppColors.primarySoft;
    _brandRing = AppColors.primaryRing;
    notifyListeners();
  }
}
