String _symbolFor(String code) {
  switch (code.toUpperCase()) {
    case 'USD': return r'$';
    case 'EUR': return '€';
    case 'GBP': return '£';
    case 'JPY': return '¥';
    case 'SAR': return '﷼';
    case 'AED': return 'د.إ';
    case 'CAD': return r'C$';
    case 'AUD': return r'A$';
    case 'CHF': return 'Fr';
    case 'CNY': return '¥';
    case 'EGP': return 'E£';
    case 'INR': return '₹';
    case 'BRL': return r'R$';
    case 'KRW': return '₩';
    case 'MXN': return r'MX$';
    case 'SEK': return 'kr';
    case 'NOK': return 'kr';
    case 'DKK': return 'kr';
    case 'NZD': return r'NZ$';
    case 'TRY': return '₺';
    case 'ZAR': return 'R';
    case 'SGD': return r'S$';
    case 'HKD': return r'HK$';
    case 'MYR': return 'RM';
    case 'THB': return '฿';
    case 'PHP': return '₱';
    case 'IDR': return 'Rp';
    case 'PLN': return 'zł';
    case 'RUB': return '₽';
    default: return r'$';
  }
}

String getCurrencySymbol(String? currencyCode) {
  if (currencyCode == null || currencyCode.isEmpty) return r'$';
  return _symbolFor(currencyCode);
}

String formatAmount(double amount, String? currencyCode, {int decimals = 2}) {
  final symbol = getCurrencySymbol(currencyCode);
  return '$symbol${amount.toStringAsFixed(decimals)}';
}
