import 'package:flutter/services.dart';

class FontController {
  // Loaders family for each font
  static final FontLoader _iconsaxLoader = FontLoader('Iconsax');

  //package name
  static const String package = 'dual_custom_date_picker';

  // state of load each font
  static bool _iconsaxLoaded = false;

  /// Load all Iconsax font weights
  static Future<void> loadIconSax() async {
    if (_iconsaxLoaded) return;

    _iconsaxLoader.addFont(
      rootBundle.load('packages/$package/fonts/Iconsax.ttf'),
    );

    await _iconsaxLoader.load();
    _iconsaxLoaded = true;
  }

  /// Load all fonts
  static Future<void> loadAllFonts() async {
    await Future.wait([
      loadIconSax(),
    ]);
  }
}
