import 'package:shared_preferences/shared_preferences.dart';

class DefaultSettings {
  static const String taxRateKey = 'default_tax_rate';
  static const String currencyKey = 'default_currency';
  static const String policyKey = 'invoice_policy';

  static const String defaultPolicy =
      'Payment is due within 30 days from the invoice date. '
      'Late payments may incur additional charges. '
      'Thank you for your business.';

  static double getTaxRate(SharedPreferences prefs) =>
      prefs.getDouble(taxRateKey) ?? 0.0;

  static String getCurrency(SharedPreferences prefs) =>
      prefs.getString(currencyKey) ?? 'USD';

  static String getPolicy(SharedPreferences prefs) =>
      prefs.getString(policyKey) ?? defaultPolicy;

  static Future<void> setTaxRate(SharedPreferences prefs, double rate) =>
      prefs.setDouble(taxRateKey, rate);

  static Future<void> setCurrency(SharedPreferences prefs, String currency) =>
      prefs.setString(currencyKey, currency);

  static Future<void> setPolicy(SharedPreferences prefs, String policy) =>
      prefs.setString(policyKey, policy);
}
