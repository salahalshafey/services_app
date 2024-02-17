import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app.dart';

class LanguageWithCountryFlag {
  final String languageCode;
  final String languageFullName;
  final String countryFlage;

  const LanguageWithCountryFlag(
    this.languageCode,
    this.languageFullName,
    this.countryFlage,
  );

  @override
  String toString() {
    return "$languageCode, $languageFullName, $countryFlage\n";
  }
}

class Languages {
  /// * All supported Locales only.
  /// * All the languages are translated into the Locale language.
  ///
  static List<LanguageWithCountryFlag> get allLocaleWithDetails {
    final context = navigatorKey.currentContext!;

    return [
      LanguageWithCountryFlag(
        "en",
        AppLocalizations.of(context)!.english,
        "🇺🇸",
      ),
      LanguageWithCountryFlag(
        "ar",
        AppLocalizations.of(context)!.arabic,
        "🇪🇬",
      ),
      /*  LanguageWithCountryFlag(
        "es",
        AppLocalizations.of(context)!.spanish,
        "🇪🇸",
      ),
      LanguageWithCountryFlag(
        "fr",
        AppLocalizations.of(context)!.frensh,
        "🇫🇷",
      ),
      LanguageWithCountryFlag(
        "de",
        AppLocalizations.of(context)!.german,
        "🇩🇪",
      ),
      LanguageWithCountryFlag(
        "tr",
        AppLocalizations.of(context)!.turkish,
        "🇹🇷",
      ),*/
    ];
  }

  /// * All languages +70, whether in supported Locales or not.
  /// * The languages is in its native naming.
  ///
  static List<LanguageWithCountryFlag> get allWithDetails {
    // final context = navigatorKey.currentContext!;

    return [
      const LanguageWithCountryFlag('en', 'English', '🇺🇸'),
      const LanguageWithCountryFlag('es', 'Español', '🇪🇸'),
      const LanguageWithCountryFlag('zh', '中文', '🇨🇳'),
      const LanguageWithCountryFlag('hi', 'हिन्दी', '🇮🇳'),
      const LanguageWithCountryFlag('ar', 'العربية', '🇪🇬'),
      const LanguageWithCountryFlag('pt', 'Português', '🇵🇹'),
      const LanguageWithCountryFlag('bn', 'বাংলা', '🇧🇩'),
      const LanguageWithCountryFlag('ru', 'Русский', '🇷🇺'),
      const LanguageWithCountryFlag('fr', 'Français', '🇫🇷'),
      const LanguageWithCountryFlag('sw', 'Kiswahili', '🇰🇪'),
      const LanguageWithCountryFlag('de', 'Deutsch', '🇩🇪'),
      const LanguageWithCountryFlag('ja', '日本語', '🇯🇵'),
      const LanguageWithCountryFlag('ko', '한국어', '🇰🇷'),
      const LanguageWithCountryFlag('fa', 'فارسی', '🇮🇷'),
      const LanguageWithCountryFlag('ur', 'اردو', '🇵🇰'),
      const LanguageWithCountryFlag('it', 'Italiano', '🇮🇹'),
      const LanguageWithCountryFlag('nl', 'Nederlands', '🇳🇱'),
      const LanguageWithCountryFlag('tr', 'Türkçe', '🇹🇷'),
      const LanguageWithCountryFlag('vi', 'Tiếng Việt', '🇻🇳'),
      const LanguageWithCountryFlag('id', 'Bahasa Indonesia', '🇮🇩'),
      const LanguageWithCountryFlag('th', 'ไทย', '🇹🇭'),
      const LanguageWithCountryFlag('ms', 'Bahasa Melayu', '🇲🇾'),
      const LanguageWithCountryFlag('fil', 'Filipino', '🇵🇭'),
      const LanguageWithCountryFlag('my', 'မြန်မာ', '🇲🇲'),
      const LanguageWithCountryFlag('km', 'ភាសាខ្មែរ', '🇰🇭'),
      const LanguageWithCountryFlag('lo', 'ພາສາລາວ', '🇱🇦'),
      const LanguageWithCountryFlag('ne', 'नेपाली', '🇳🇵'),
      const LanguageWithCountryFlag('si', 'සිංහල', '🇱🇰'),
      const LanguageWithCountryFlag('el', 'Ελληνικά', '🇬🇷'),
      const LanguageWithCountryFlag('pl', 'Polski', '🇵🇱'),
      const LanguageWithCountryFlag('sv', 'Svenska', '🇸🇪'),
      const LanguageWithCountryFlag('fi', 'Suomi', '🇫🇮'),
      const LanguageWithCountryFlag('da', 'Dansk', '🇩🇰'),
      const LanguageWithCountryFlag('no', 'Norsk', '🇳🇴'),
      const LanguageWithCountryFlag('he', 'עברית', '🆓🇵🇸'),
      const LanguageWithCountryFlag('hu', 'Magyar', '🇭🇺'),
      const LanguageWithCountryFlag('cs', 'Čeština', '🇨🇿'),
      const LanguageWithCountryFlag('ro', 'Română', '🇷🇴'),
      const LanguageWithCountryFlag('sk', 'Slovenčina', '🇸🇰'),
      const LanguageWithCountryFlag('hr', 'Hrvatski', '🇭🇷'),
      const LanguageWithCountryFlag('sr', 'Српски', '🇷🇸'),
      const LanguageWithCountryFlag('sl', 'Slovenščina', '🇸🇮'),
      const LanguageWithCountryFlag('bg', 'Български', '🇧🇬'),
      const LanguageWithCountryFlag('uk', 'Українська', '🇺🇦'),
      const LanguageWithCountryFlag('et', 'Eesti', '🇪🇪'),
      const LanguageWithCountryFlag('lv', 'Latviešu', '🇱🇻'),
      const LanguageWithCountryFlag('lt', 'Lietuvių', '🇱🇹'),
      const LanguageWithCountryFlag('mk', 'Македонски', '🇲🇰'),
      const LanguageWithCountryFlag('sq', 'Shqip', '🇦🇱'),
      const LanguageWithCountryFlag('hy', 'Հայերեն', '🇦🇲'),
      const LanguageWithCountryFlag('ka', 'ქართული', '🇬🇪'),
      const LanguageWithCountryFlag('am', 'አማርኛ', '🇪🇹'),
      const LanguageWithCountryFlag('ha', 'Hausa', '🇳🇬'),
      const LanguageWithCountryFlag('yo', 'Yorùbá', '🇳🇬'),
      const LanguageWithCountryFlag('ig', 'Igbo', '🇳🇬'),
      const LanguageWithCountryFlag('pa', 'ਪੰਜਾਬੀ', '🇮🇳'),
      const LanguageWithCountryFlag('ta', 'தமிழ்', '🇮🇳'),
      const LanguageWithCountryFlag('te', 'తెలుగు', '🇮🇳'),
      const LanguageWithCountryFlag('mr', 'मराठी', '🇮🇳'),
      const LanguageWithCountryFlag('uz', 'Oʻzbekcha', '🇺🇿'),
      const LanguageWithCountryFlag('ky', 'Кыргызча', '🇰🇬'),
      const LanguageWithCountryFlag('mn', 'Монгол', '🇲🇳'),
      const LanguageWithCountryFlag('ti', 'ትግርኛ', '🇪🇹'),
      const LanguageWithCountryFlag('so', 'Soomaaliga', '🇸🇴'),
      const LanguageWithCountryFlag('rw', 'Kinyarwanda', '🇷🇼'),
      const LanguageWithCountryFlag('mg', 'Malagasy', '🇲🇬'),
      const LanguageWithCountryFlag('sn', 'ChiShona', '🇿🇼'),
      const LanguageWithCountryFlag('dz', 'རྫོང་ཁ', '🇧🇹'),
      const LanguageWithCountryFlag('bo', 'བོད་སྐད', '🇧🇹'),
      const LanguageWithCountryFlag('ps', 'پښتو', '🇦🇫'),
      const LanguageWithCountryFlag('ug', 'ئۇيغۇرچە', '🇨🇳'),
      const LanguageWithCountryFlag('tk', 'Türkmen', '🇹🇲'),
    ];
  }
}
