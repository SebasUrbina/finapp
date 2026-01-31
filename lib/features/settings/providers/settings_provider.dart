import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/models/app_settings.dart';

const _settingsKey = 'app_settings';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        state = AppSettings.fromJsonString(settingsJson);
      }
    } catch (e) {
      // If loading fails, keep default settings
      state = const AppSettings();
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, state.toJsonString());
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await _saveSettings();
  }

  Future<void> setCurrency(Currency currency) async {
    state = state.copyWith(currency: currency);
    await _saveSettings();
  }

  Future<void> updateNotifications(NotificationSettings notifications) async {
    state = state.copyWith(notifications: notifications);
    await _saveSettings();
  }

  Future<void> setBudgetAlerts(bool enabled) async {
    final notifications = state.notifications.copyWith(budgetAlerts: enabled);
    await updateNotifications(notifications);
  }

  Future<void> setDailyReminders(bool enabled) async {
    final notifications = state.notifications.copyWith(dailyReminders: enabled);
    await updateNotifications(notifications);
  }

  Future<void> setWeeklyReports(bool enabled) async {
    final notifications = state.notifications.copyWith(weeklyReports: enabled);
    await updateNotifications(notifications);
  }

  Future<void> setMonthlyReports(bool enabled) async {
    final notifications = state.notifications.copyWith(monthlyReports: enabled);
    await updateNotifications(notifications);
  }

  Future<void> setBudgetAlertThreshold(int threshold) async {
    final notifications = state.notifications.copyWith(
      budgetAlertThreshold: threshold,
    );
    await updateNotifications(notifications);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier();
});
