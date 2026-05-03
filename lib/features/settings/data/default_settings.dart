import 'package:shared_preferences/shared_preferences.dart';

class DefaultSettings {
  static const String taxRateKey = 'default_tax_rate';
  static const String currencyKey = 'default_currency';

  static double getTaxRate(SharedPreferences prefs) =>
      prefs.getDouble(taxRateKey) ?? 0.0;

  static String getCurrency(SharedPreferences prefs) =>
      prefs.getString(currencyKey) ?? 'USD';

  static Future<void> setTaxRate(SharedPreferences prefs, double rate) =>
      prefs.setDouble(taxRateKey, rate);

  static Future<void> setCurrency(SharedPreferences prefs, String currency) =>
      prefs.setString(currencyKey, currency);
}
