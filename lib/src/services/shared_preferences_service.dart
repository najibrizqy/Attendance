import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<Map<String, double?>> getMasterLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Future<void> saveMasterLocation(double latitude, double longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }
}
