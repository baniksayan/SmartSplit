/// Currency data for SmartSplit
/// Top 20 most used currencies + comprehensive list

class Currency {
  final String code;
  final String name;
  final String symbol;
  final bool isPopular;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    this.isPopular = false,
  });

  @override
  String toString() => '$code - $name ($symbol)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

class CurrencyData {
  /// Top 20 popular currencies (shown first in dropdown)
  static final List<Currency> popular = [
    const Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹', isPopular: true),
    const Currency(code: 'USD', name: 'US Dollar', symbol: '\$', isPopular: true),
    const Currency(code: 'EUR', name: 'Euro', symbol: '€', isPopular: true),
    const Currency(code: 'GBP', name: 'British Pound', symbol: '£', isPopular: true),
    const Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', isPopular: true),
    const Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', isPopular: true),
    const Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', isPopular: true),
    const Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', isPopular: true),
    const Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', isPopular: true),
    const Currency(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', isPopular: true),
    const Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', isPopular: true),
    const Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', isPopular: true),
    const Currency(code: 'KRW', name: 'South Korean Won', symbol: '₩', isPopular: true),
    const Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', isPopular: true),
    const Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', isPopular: true),
    const Currency(code: 'MXN', name: 'Mexican Peso', symbol: '\$', isPopular: true),
    const Currency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', isPopular: true),
    const Currency(code: 'ZAR', name: 'South African Rand', symbol: 'R', isPopular: true),
    const Currency(code: 'RUB', name: 'Russian Ruble', symbol: '₽', isPopular: true),
    const Currency(code: 'TRY', name: 'Turkish Lira', symbol: '₺', isPopular: true),
  ];

  /// All other currencies
  static final List<Currency> others = [
    const Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
    const Currency(code: 'AFN', name: 'Afghan Afghani', symbol: '؋'),
    const Currency(code: 'ALL', name: 'Albanian Lek', symbol: 'L'),
    const Currency(code: 'AMD', name: 'Armenian Dram', symbol: '֏'),
    const Currency(code: 'ANG', name: 'Netherlands Antillean Guilder', symbol: 'ƒ'),
    const Currency(code: 'AOA', name: 'Angolan Kwanza', symbol: 'Kz'),
    const Currency(code: 'ARS', name: 'Argentine Peso', symbol: '\$'),
    const Currency(code: 'AWG', name: 'Aruban Florin', symbol: 'ƒ'),
    const Currency(code: 'AZN', name: 'Azerbaijani Manat', symbol: '₼'),
    const Currency(code: 'BAM', name: 'Bosnia-Herzegovina Convertible Mark', symbol: 'KM'),
    const Currency(code: 'BBD', name: 'Barbadian Dollar', symbol: '\$'),
    const Currency(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳'),
    const Currency(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв'),
    const Currency(code: 'BHD', name: 'Bahraini Dinar', symbol: '.د.ب'),
    const Currency(code: 'BIF', name: 'Burundian Franc', symbol: 'Fr'),
    const Currency(code: 'BMD', name: 'Bermudian Dollar', symbol: '\$'),
    const Currency(code: 'BND', name: 'Brunei Dollar', symbol: '\$'),
    const Currency(code: 'BOB', name: 'Bolivian Boliviano', symbol: 'Bs.'),
    const Currency(code: 'BSD', name: 'Bahamian Dollar', symbol: '\$'),
    const Currency(code: 'BTN', name: 'Bhutanese Ngultrum', symbol: 'Nu.'),
    const Currency(code: 'BWP', name: 'Botswanan Pula', symbol: 'P'),
    const Currency(code: 'BYN', name: 'Belarusian Ruble', symbol: 'Br'),
    const Currency(code: 'BZD', name: 'Belize Dollar', symbol: 'BZ\$'),
    const Currency(code: 'CDF', name: 'Congolese Franc', symbol: 'Fr'),
    const Currency(code: 'CLP', name: 'Chilean Peso', symbol: '\$'),
    const Currency(code: 'COP', name: 'Colombian Peso', symbol: '\$'),
    const Currency(code: 'CRC', name: 'Costa Rican Colón', symbol: '₡'),
    const Currency(code: 'CUP', name: 'Cuban Peso', symbol: '\$'),
    const Currency(code: 'CVE', name: 'Cape Verdean Escudo', symbol: '\$'),
    const Currency(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč'),
    const Currency(code: 'DJF', name: 'Djiboutian Franc', symbol: 'Fr'),
    const Currency(code: 'DKK', name: 'Danish Krone', symbol: 'kr'),
    const Currency(code: 'DOP', name: 'Dominican Peso', symbol: '\$'),
    const Currency(code: 'DZD', name: 'Algerian Dinar', symbol: 'د.ج'),
    const Currency(code: 'EGP', name: 'Egyptian Pound', symbol: '£'),
    const Currency(code: 'ERN', name: 'Eritrean Nakfa', symbol: 'Nfk'),
    const Currency(code: 'ETB', name: 'Ethiopian Birr', symbol: 'Br'),
    const Currency(code: 'FJD', name: 'Fijian Dollar', symbol: '\$'),
    const Currency(code: 'FKP', name: 'Falkland Islands Pound', symbol: '£'),
    const Currency(code: 'GEL', name: 'Georgian Lari', symbol: '₾'),
    const Currency(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵'),
    const Currency(code: 'GIP', name: 'Gibraltar Pound', symbol: '£'),
    const Currency(code: 'GMD', name: 'Gambian Dalasi', symbol: 'D'),
    const Currency(code: 'GNF', name: 'Guinean Franc', symbol: 'Fr'),
    const Currency(code: 'GTQ', name: 'Guatemalan Quetzal', symbol: 'Q'),
    const Currency(code: 'GYD', name: 'Guyanese Dollar', symbol: '\$'),
    const Currency(code: 'HNL', name: 'Honduran Lempira', symbol: 'L'),
    const Currency(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn'),
    const Currency(code: 'HTG', name: 'Haitian Gourde', symbol: 'G'),
    const Currency(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft'),
    const Currency(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp'),
    const Currency(code: 'ILS', name: 'Israeli New Shekel', symbol: '₪'),
    const Currency(code: 'IQD', name: 'Iraqi Dinar', symbol: 'ع.د'),
    const Currency(code: 'IRR', name: 'Iranian Rial', symbol: '﷼'),
    const Currency(code: 'ISK', name: 'Icelandic Króna', symbol: 'kr'),
    const Currency(code: 'JMD', name: 'Jamaican Dollar', symbol: 'J\$'),
    const Currency(code: 'JOD', name: 'Jordanian Dinar', symbol: 'د.ا'),
    const Currency(code: 'KES', name: 'Kenyan Shilling', symbol: 'Sh'),
    const Currency(code: 'KGS', name: 'Kyrgystani Som', symbol: 'с'),
    const Currency(code: 'KHR', name: 'Cambodian Riel', symbol: '៛'),
    const Currency(code: 'KMF', name: 'Comorian Franc', symbol: 'Fr'),
    const Currency(code: 'KPW', name: 'North Korean Won', symbol: '₩'),
    const Currency(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك'),
    const Currency(code: 'KYD', name: 'Cayman Islands Dollar', symbol: '\$'),
    const Currency(code: 'KZT', name: 'Kazakhstani Tenge', symbol: '₸'),
    const Currency(code: 'LAK', name: 'Laotian Kip', symbol: '₭'),
    const Currency(code: 'LBP', name: 'Lebanese Pound', symbol: 'ل.ل'),
    const Currency(code: 'LKR', name: 'Sri Lankan Rupee', symbol: 'Rs'),
    const Currency(code: 'LRD', name: 'Liberian Dollar', symbol: '\$'),
    const Currency(code: 'LSL', name: 'Lesotho Loti', symbol: 'L'),
    const Currency(code: 'LYD', name: 'Libyan Dinar', symbol: 'ل.د'),
    const Currency(code: 'MAD', name: 'Moroccan Dirham', symbol: 'د.م.'),
    const Currency(code: 'MDL', name: 'Moldovan Leu', symbol: 'L'),
    const Currency(code: 'MGA', name: 'Malagasy Ariary', symbol: 'Ar'),
    const Currency(code: 'MKD', name: 'Macedonian Denar', symbol: 'ден'),
    const Currency(code: 'MMK', name: 'Burmese Kyat', symbol: 'K'),
    const Currency(code: 'MNT', name: 'Mongolian Tugrik', symbol: '₮'),
    const Currency(code: 'MOP', name: 'Macanese Pataca', symbol: 'P'),
    const Currency(code: 'MUR', name: 'Mauritian Rupee', symbol: '₨'),
    const Currency(code: 'MVR', name: 'Maldivian Rufiyaa', symbol: '.ރ'),
    const Currency(code: 'MWK', name: 'Malawian Kwacha', symbol: 'MK'),
    const Currency(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM'),
    const Currency(code: 'MZN', name: 'Mozambican Metical', symbol: 'MT'),
    const Currency(code: 'NAD', name: 'Namibian Dollar', symbol: '\$'),
    const Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦'),
    const Currency(code: 'NIO', name: 'Nicaraguan Córdoba', symbol: 'C\$'),
    const Currency(code: 'NPR', name: 'Nepalese Rupee', symbol: '₨'),
    const Currency(code: 'OMR', name: 'Omani Rial', symbol: 'ر.ع.'),
    const Currency(code: 'PAB', name: 'Panamanian Balboa', symbol: 'B/.'),
    const Currency(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/.'),
    const Currency(code: 'PGK', name: 'Papua New Guinean Kina', symbol: 'K'),
    const Currency(code: 'PHP', name: 'Philippine Peso', symbol: '₱'),
    const Currency(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨'),
    const Currency(code: 'PLN', name: 'Polish Zloty', symbol: 'zł'),
    const Currency(code: 'PYG', name: 'Paraguayan Guarani', symbol: '₲'),
    const Currency(code: 'QAR', name: 'Qatari Riyal', symbol: 'ر.ق'),
    const Currency(code: 'RON', name: 'Romanian Leu', symbol: 'lei'),
    const Currency(code: 'RSD', name: 'Serbian Dinar', symbol: 'дин.'),
    const Currency(code: 'RWF', name: 'Rwandan Franc', symbol: 'Fr'),
    const Currency(code: 'SAR', name: 'Saudi Riyal', symbol: 'ر.س'),
    const Currency(code: 'SBD', name: 'Solomon Islands Dollar', symbol: '\$'),
    const Currency(code: 'SCR', name: 'Seychellois Rupee', symbol: '₨'),
    const Currency(code: 'SDG', name: 'Sudanese Pound', symbol: '£'),
    const Currency(code: 'SHP', name: 'Saint Helena Pound', symbol: '£'),
    const Currency(code: 'SLL', name: 'Sierra Leonean Leone', symbol: 'Le'),
    const Currency(code: 'SOS', name: 'Somali Shilling', symbol: 'Sh'),
    const Currency(code: 'SRD', name: 'Surinamese Dollar', symbol: '\$'),
    const Currency(code: 'SSP', name: 'South Sudanese Pound', symbol: '£'),
    const Currency(code: 'STN', name: 'São Tomé and Príncipe Dobra', symbol: 'Db'),
    const Currency(code: 'SYP', name: 'Syrian Pound', symbol: '£'),
    const Currency(code: 'SZL', name: 'Swazi Lilangeni', symbol: 'L'),
    const Currency(code: 'THB', name: 'Thai Baht', symbol: '฿'),
    const Currency(code: 'TJS', name: 'Tajikistani Somoni', symbol: 'ЅМ'),
    const Currency(code: 'TMT', name: 'Turkmenistani Manat', symbol: 'm'),
    const Currency(code: 'TND', name: 'Tunisian Dinar', symbol: 'د.ت'),
    const Currency(code: 'TOP', name: 'Tongan Paʻanga', symbol: 'T\$'),
    const Currency(code: 'TTD', name: 'Trinidad and Tobago Dollar', symbol: 'TT\$'),
    const Currency(code: 'TWD', name: 'New Taiwan Dollar', symbol: 'NT\$'),
    const Currency(code: 'TZS', name: 'Tanzanian Shilling', symbol: 'Sh'),
    const Currency(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴'),
    const Currency(code: 'UGX', name: 'Ugandan Shilling', symbol: 'Sh'),
    const Currency(code: 'UYU', name: 'Uruguayan Peso', symbol: '\$U'),
    const Currency(code: 'UZS', name: 'Uzbekistani Som', symbol: 'so\'m'),
    const Currency(code: 'VES', name: 'Venezuelan Bolívar', symbol: 'Bs.S'),
    const Currency(code: 'VND', name: 'Vietnamese Dong', symbol: '₫'),
    const Currency(code: 'VUV', name: 'Vanuatu Vatu', symbol: 'Vt'),
    const Currency(code: 'WST', name: 'Samoan Tala', symbol: 'T'),
    const Currency(code: 'XAF', name: 'Central African CFA Franc', symbol: 'Fr'),
    const Currency(code: 'XCD', name: 'East Caribbean Dollar', symbol: '\$'),
    const Currency(code: 'XOF', name: 'West African CFA Franc', symbol: 'Fr'),
    const Currency(code: 'XPF', name: 'CFP Franc', symbol: 'Fr'),
    const Currency(code: 'YER', name: 'Yemeni Rial', symbol: '﷼'),
    const Currency(code: 'ZMW', name: 'Zambian Kwacha', symbol: 'ZK'),
    const Currency(code: 'ZWL', name: 'Zimbabwean Dollar', symbol: '\$'),
  ];

  /// Get all currencies (popular first, then others)
  static List<Currency> get all => [...popular, ...others];

  /// Find currency by code
  static Currency? findByCode(String code) {
    try {
      return all.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Search currencies by name or code
  static List<Currency> search(String query) {
    if (query.isEmpty) return all;

    final lowerQuery = query.toLowerCase();
    return all.where((currency) {
      return currency.code.toLowerCase().contains(lowerQuery) ||
          currency.name.toLowerCase().contains(lowerQuery) ||
          currency.symbol.contains(query);
    }).toList();
  }
}
