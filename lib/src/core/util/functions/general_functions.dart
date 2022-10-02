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

String getFirstName(String fullName) => fullName.split(RegExp(r' +')).first;

String time24To12HoursFormat(int hours, int minuts) {
  String minut = minuts.toString();
  if (minut.length < 2) {
    minut = '0' + minut;
  }

  if (hours == 0) {
    return "12:$minut AM";
  } else if (hours == 12) {
    return '12:$minut PM';
  } else if (hours > 21) {
    return '${hours - 12}:$minut PM';
  } else if (hours > 12) {
    return '0${hours - 12}:$minut PM';
  } else if (hours > 9) {
    return '$hours:$minut AM';
  }
  return '0$hours:$minut AM';
}

String formatedDate(DateTime date) {
  final currentDate = DateTime.now();

  if (currentDate.year == date.year &&
      currentDate.month == date.month &&
      currentDate.day == date.day) {
    return 'Today';
  }

  if (currentDate.year == date.year &&
      currentDate.month == date.month &&
      currentDate.day == date.day + 1) {
    return 'Yesterday';
  }

  return '${date.day}/${date.month}/${date.year}';
}

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

String formatedDuration(Duration time) {
  // print(time.toString());
  return time.toString().substring(2, 7);
}

String fromMeterPerSecToKPerH(double speed) {
  return (speed * 3.6).toStringAsFixed(0);
}

String pastOrFutureTimeFromNow(DateTime dateTime) {
  final duration = DateTime.now().difference(dateTime);

  var d = duration.inDays ~/ 3650;
  var res = _res(d, 'decade');
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 365;
  res = _res(d, 'year');
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 30;
  res = _res(d, 'month');
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 7;
  res = _res(d, 'week');
  if (res != null) {
    return res;
  }

  d = duration.inDays;
  res = _res(d, 'day');
  if (res != null) {
    return res;
  }

  d = duration.inHours;
  res = _res(d, 'hour');
  if (res != null) {
    return res;
  }

  d = duration.inMinutes;
  res = _res(d, 'minute');
  if (res != null) {
    return res;
  }

  return 'just now';
}

String? _res(int d, String timeName) {
  if (d > 0) {
    return '$d $timeName${_s(d)} ago';
  }
  if (d < 0) {
    return '${d.abs()} $timeName${_s(d)} from now';
  }
  return null;
}

String _s(int num) => num.abs() > 1 ? 's' : '';

extension on String {
  Set<String> toSet() {
    return {for (int i = 0; i < length; i++) substring(i, i + 1)};
  }

  List<String> toList() {
    return [for (int i = 0; i < length; i++) substring(i, i + 1)];
  }
}
