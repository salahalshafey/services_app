import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app.dart';

final _context = navigatorKey.currentContext!;

String? validatPassword(String? value) {
  const errorMessage =
      "Password must be at least 8 characters long, with at least 5 alphabet, 2 numbers and 1 special charachters like '~!@#\$%^&*()_'.";

  if (value == null || value.length < 8) {
    return errorMessage;
  }

  final alphabet =
      ("abcdefghijklmnopqrstuvwxyz${"abcdefghijklmnopqrstuvwxyz".toUpperCase()}")
          .characters
          .toSet();
  var countAlpha = 0;
  value.characters.toList().forEach((char) {
    if (alphabet.contains(char)) countAlpha++;
  });
  if (countAlpha < 5) {
    return errorMessage;
  }

  final numbers = "0123456789".characters.toSet();
  var countNum = 0;
  value.characters.toList().forEach((char) {
    if (numbers.contains(char)) countNum++;
  });
  if (countNum < 2) {
    return errorMessage;
  }

  final specialChar = "~!@#\$%^&*()_-+={}[]'\"\\;: ,.<>?/،؟".characters.toSet();
  var countSpecial = 0;
  value.characters.toList().forEach((char) {
    if (specialChar.contains(char)) countSpecial++;
  });
  if (countSpecial < 1) {
    return errorMessage;
  }

  return null;
}

String? validatPassword2(String? value) {
  if (value == null || value.trim().length < 8) {
    return 'Password must be at least 8 characters long.';
  }

  final alphabet =
      ("abcdefghijklmnopqrstuvwxyz${"abcdefghijklmnopqrstuvwxyz".toUpperCase()}")
          .characters
          .toSet();
  var countAlpha = 0;
  value.characters.toList().forEach((char) {
    if (alphabet.contains(char)) countAlpha++;
  });
  if (countAlpha < 5) {
    return "Password must contain at least 5 alphabet characters.";
  }

  final numbers = "0123456789".characters.toSet();
  var countNum = 0;
  value.characters.toList().forEach((char) {
    if (numbers.contains(char)) countNum++;
  });
  if (countNum < 2) {
    return "Password must contain at least 2 numbers.";
  }

  final specialChar = "~!@#\$%^&*()_-+={}[]'\"\\;: ,.<>?/،؟".characters.toSet();
  var countSpecial = 0;
  value.characters.toList().forEach((char) {
    if (specialChar.contains(char)) countSpecial++;
  });
  if (countSpecial < 1) {
    return "Password must contain at least 1 special charachters like '~!@#\$%^&*()_'.";
  }

  return null;
}

String? validatPassword3(String? value) {
  const specialleteral = "'~!@#\$%^&*()_.'";

  if (value == null || value.length < 8) {
    return AppLocalizations.of(_context)!.passwordMustBeAtLeastWithDetails +
        specialleteral;
  }

  List<String> validationValues = [];

  final alphabetRegex = RegExp(r'\p{L}', unicode: true);
  var countAlpha = 0;
  value.characters.toList().forEach((char) {
    if (alphabetRegex.hasMatch(char)) countAlpha++;
  });
  if (countAlpha < 5) {
    validationValues.add(AppLocalizations.of(_context)!.fiveAlphabetCharacters);
  }

  final digitsRegex = RegExp(r'-?[\d٠-٩०-९০-৯]+');
  var countDigit = 0;
  value.characters.toList().forEach((char) {
    if (digitsRegex.hasMatch(char)) countDigit++;
  });
  if (countDigit < 2) {
    validationValues.add(AppLocalizations.of(_context)!.twoNumbers);
  }

  //final specialChar = "~!@#\$%^&*()_-+={}[]'\"\\;: ,.<>?/،؟".characters.toSet();
  var countSpecial = 0;
  value.characters.toList().forEach((char) {
    if (!digitsRegex.hasMatch(char) && !alphabetRegex.hasMatch(char)) {
      countSpecial++;
    }
  });
  if (countSpecial < 1) {
    validationValues.add(
        AppLocalizations.of(_context)!.oneSpecialCharachtersLike +
            specialleteral);
  }

  return _joinValidations(validationValues);
}

String? _joinValidations(List<String> validations) {
  if (validations.isEmpty) {
    return null;
  }

  final s = AppLocalizations.of(_context)!.passwordMustContainAtLeast;
  final comma = AppLocalizations.of(_context)!.comma;
  final and = AppLocalizations.of(_context)!.and;

  if (validations.length == 1) {
    return "$s ${validations.join()}.";
  }

  return "$s ${validations.sublist(0, validations.length - 1).join(comma)} $and ${validations.last}.";
}
