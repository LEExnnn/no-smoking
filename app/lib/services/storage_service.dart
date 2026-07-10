import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyProfile = 'user_profile';
  static const String _keyQuitDate = 'quit_date';
  static const String _keyCravingsDefeated = 'cravings_defeated';
  static const String _keyMoneySaved = 'money_saved'; // 累计省下金额

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Profile ---
  Future<void> saveProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile));
  }

  Map<String, dynamic>? getProfile() {
    final str = _prefs.getString(_keyProfile);
    if (str != null) {
      return jsonDecode(str) as Map<String, dynamic>;
    }
    return null;
  }

  // --- Quit Date ---
  Future<void> saveQuitDate(DateTime date) async {
    await _prefs.setString(_keyQuitDate, date.toIso8601String());
  }

  DateTime? getQuitDate() {
    final str = _prefs.getString(_keyQuitDate);
    if (str != null) {
      return DateTime.tryParse(str);
    }
    return null;
  }

  // --- Stats ---
  Future<void> addCravingDefeated(double moneySavedIncrement) async {
    int current = _prefs.getInt(_keyCravingsDefeated) ?? 0;
    await _prefs.setInt(_keyCravingsDefeated, current + 1);

    double currentMoney = _prefs.getDouble(_keyMoneySaved) ?? 0.0;
    await _prefs.setDouble(_keyMoneySaved, currentMoney + moneySavedIncrement);
  }

  int getCravingsDefeated() {
    return _prefs.getInt(_keyCravingsDefeated) ?? 0;
  }
  
  double getMoneySaved() {
    return _prefs.getDouble(_keyMoneySaved) ?? 0.0;
  }

  // 清除所有数据（用于重新测试）
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
