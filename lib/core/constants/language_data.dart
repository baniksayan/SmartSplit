/// Language data for SmartSplit
/// Commonly used languages for the app

class Language {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  @override
  String toString() => '$name ($nativeName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

class LanguageData {
  static final List<Language> all = [
    const Language(code: 'en', name: 'English', nativeName: 'English'),
    const Language(code: 'hi', name: 'Hindi', nativeName: 'हिंदी'),
    const Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
    const Language(code: 'fr', name: 'French', nativeName: 'Français'),
    const Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
    const Language(code: 'zh', name: 'Chinese', nativeName: '中文'),
    const Language(code: 'ja', name: 'Japanese', nativeName: '日本語'),
    const Language(code: 'ko', name: 'Korean', nativeName: '한국어'),
    const Language(code: 'pt', name: 'Portuguese', nativeName: 'Português'),
    const Language(code: 'ru', name: 'Russian', nativeName: 'Русский'),
    const Language(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
    const Language(code: 'it', name: 'Italian', nativeName: 'Italiano'),
    const Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands'),
    const Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska'),
    const Language(code: 'pl', name: 'Polish', nativeName: 'Polski'),
    const Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe'),
    const Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    const Language(code: 'th', name: 'Thai', nativeName: 'ไทย'),
    const Language(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia'),
    const Language(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu'),
    const Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    const Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    const Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    const Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    const Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    const Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    const Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    const Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
    const Language(code: 'ur', name: 'Urdu', nativeName: 'اردو'),
    const Language(code: 'fa', name: 'Persian', nativeName: 'فارسی'),
    const Language(code: 'he', name: 'Hebrew', nativeName: 'עברית'),
    const Language(code: 'el', name: 'Greek', nativeName: 'Ελληνικά'),
    const Language(code: 'cs', name: 'Czech', nativeName: 'Čeština'),
    const Language(code: 'da', name: 'Danish', nativeName: 'Dansk'),
    const Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi'),
    const Language(code: 'hu', name: 'Hungarian', nativeName: 'Magyar'),
    const Language(code: 'no', name: 'Norwegian', nativeName: 'Norsk'),
    const Language(code: 'ro', name: 'Romanian', nativeName: 'Română'),
    const Language(code: 'uk', name: 'Ukrainian', nativeName: 'Українська'),
  ];

  /// Find language by code
  static Language? findByCode(String code) {
    try {
      return all.firstWhere((l) => l.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Search languages by name or native name
  static List<Language> search(String query) {
    if (query.isEmpty) return all;

    final lowerQuery = query.toLowerCase();
    return all.where((language) {
      return language.code.toLowerCase().contains(lowerQuery) ||
          language.name.toLowerCase().contains(lowerQuery) ||
          language.nativeName.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
