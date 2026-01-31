import 'dart:convert';

enum AppLanguage {
  spanish('es', 'Español'),
  english('en', 'English');

  final String code;
  final String displayName;

  const AppLanguage(this.code, this.displayName);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.spanish,
    );
  }
}

enum Currency {
  clp('CLP', r'$', 'Peso Chileno', 'es_CL', 0),
  usd('USD', r'$', 'Dólar Estadounidense', 'en_US', 2),
  eur('EUR', '€', 'Euro', 'es_ES', 2),
  gbp('GBP', '£', 'Libra Esterlina', 'en_GB', 2),
  mxn('MXN', r'$', 'Peso Mexicano', 'es_MX', 2),
  cop('COP', r'$', 'Peso Colombiano', 'es_CO', 0),
  ars('ARS', r'$', 'Peso Argentino', 'es_AR', 2),
  brl('BRL', r'R$', 'Real Brasileño', 'pt_BR', 2);

  final String code;
  final String symbol;
  final String displayName;
  final String locale;
  final int decimalDigits;

  const Currency(
    this.code,
    this.symbol,
    this.displayName,
    this.locale,
    this.decimalDigits,
  );

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (currency) => currency.code == code,
      orElse: () => Currency.clp,
    );
  }
}

class NotificationSettings {
  final bool budgetAlerts;
  final bool dailyReminders;
  final bool weeklyReports;
  final bool monthlyReports;
  final int budgetAlertThreshold; // Percentage (e.g., 80 for 80%)

  const NotificationSettings({
    this.budgetAlerts = true,
    this.dailyReminders = false,
    this.weeklyReports = true,
    this.monthlyReports = true,
    this.budgetAlertThreshold = 80,
  });

  NotificationSettings copyWith({
    bool? budgetAlerts,
    bool? dailyReminders,
    bool? weeklyReports,
    bool? monthlyReports,
    int? budgetAlertThreshold,
  }) {
    return NotificationSettings(
      budgetAlerts: budgetAlerts ?? this.budgetAlerts,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      monthlyReports: monthlyReports ?? this.monthlyReports,
      budgetAlertThreshold: budgetAlertThreshold ?? this.budgetAlertThreshold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetAlerts': budgetAlerts,
      'dailyReminders': dailyReminders,
      'weeklyReports': weeklyReports,
      'monthlyReports': monthlyReports,
      'budgetAlertThreshold': budgetAlertThreshold,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      budgetAlerts: json['budgetAlerts'] as bool? ?? true,
      dailyReminders: json['dailyReminders'] as bool? ?? false,
      weeklyReports: json['weeklyReports'] as bool? ?? true,
      monthlyReports: json['monthlyReports'] as bool? ?? true,
      budgetAlertThreshold: json['budgetAlertThreshold'] as int? ?? 80,
    );
  }
}

class AppSettings {
  final AppLanguage language;
  final Currency currency;
  final NotificationSettings notifications;

  const AppSettings({
    this.language = AppLanguage.spanish,
    this.currency = Currency.clp,
    this.notifications = const NotificationSettings(),
  });

  AppSettings copyWith({
    AppLanguage? language,
    Currency? currency,
    NotificationSettings? notifications,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language.code,
      'currency': currency.code,
      'notifications': notifications.toJson(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: AppLanguage.fromCode(json['language'] as String? ?? 'es'),
      currency: Currency.fromCode(json['currency'] as String? ?? 'CLP'),
      notifications: json['notifications'] != null
          ? NotificationSettings.fromJson(
              json['notifications'] as Map<String, dynamic>,
            )
          : const NotificationSettings(),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory AppSettings.fromJsonString(String jsonString) {
    return AppSettings.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
