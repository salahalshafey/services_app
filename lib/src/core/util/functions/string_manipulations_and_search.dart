String wellFormatedString(String str) {
  return str.isEmpty
      ? str
      : str
          .split(RegExp(r' +'))
          .map(
            (word) =>
                word.substring(0, 1).toUpperCase() +
                word.substring(1).toLowerCase(),
          )
          .join(' ');
}

String firstName(String fullName) => fullName.split(RegExp(r' +')).first;

bool firstCharIsArabic(String text) {
  if (text.isEmpty) {
    return false;
  }

  final arabicChars = 'ا؟؛أإءئؤآبتثةجحخدذرزسشصضطظعغفقكلمنهويلالآى'.toSet();
  final englishChars =
      'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'.toSet();

  final listOfText = text.toList();

  for (final char in listOfText) {
    if (arabicChars.contains(char)) {
      return true;
    }
    if (englishChars.contains(char)) {
      return false;
    }
  }

  return false; // if all chars is special chars
}

extension on String {
  Set<String> toSet() {
    return {for (int i = 0; i < length; i++) substring(i, i + 1)};
  }

  List<String> toList() {
    return [for (int i = 0; i < length; i++) substring(i, i + 1)];
  }
}
