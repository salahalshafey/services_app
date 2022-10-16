import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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

String wellFormattedDateTime(DateTime date) {
  return formatedDate(date) +
      '\n' +
      time24To12HoursFormat(date.hour, date.minute);
}

String wellFormattedDateTime2(DateTime date) {
  return formatedDate(date) +
      ' at ' +
      time24To12HoursFormat(date.hour, date.minute);
}

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

String wellFormatedDuration(Duration duration, {bool lineEach = false}) {
  int durationInSecond = duration.inSeconds;

  final hours = durationInSecond ~/ 3600;
  final hoursString =
      hours == 0 ? '' : '$hours hour${_s(hours)}${_lineOrSpace(lineEach)}';
  durationInSecond %= 3600;

  final minutes = durationInSecond ~/ 60;
  final minutesString = minutes == 0
      ? ''
      : '$minutes minute${_s(minutes)}${_lineOrSpace(lineEach)}';
  durationInSecond %= 60;

  final secondsString = '$durationInSecond second${_s(durationInSecond)}';

  return hoursString + minutesString + secondsString;
}

String _lineOrSpace(bool lineEach) {
  return lineEach ? '\n' : ' ';
}

String wellFormatedDistance(double distanceInMeter) {
  if (distanceInMeter >= 1000) {
    return (distanceInMeter / 1000).toStringAsFixed(1) + ' km';
  }

  return distanceInMeter.toStringAsFixed(0) + ' meter';
}

String fromMeterPerSecToKPerH(double speed) {
  return (speed * 3.6).toStringAsFixed(0);
}

String fromKilometerPerHourToMPerSec(double speed) {
  return (speed * (5 / 18)).toStringAsFixed(0);
}

double distanceBetweenTwoCoordinate(LatLng l1, LatLng l2) {
  final lat1 = l1.latitude;
  final lon1 = l1.longitude;
  final lat2 = l2.latitude;
  final lon2 = l2.longitude;
  const p = 0.017453292519943295; // PI / 180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

  return 12742000 * asin(sqrt(a)); // 2 * R * 1000; R = 6371 km
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
