import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Returns the correct backend base URL depending on the platform.
  /// - Web: localhost:8080
  /// - Android emulator: 10.0.2.2:8080 (emulator loopback to host machine)
  /// - Other (iOS/desktop): localhost:8080
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }
}