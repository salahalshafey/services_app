import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app.dart';
import 'nouns_in_diff_languages.dart';

final _context = navigatorKey.currentContext!;

/// * DateFormat pattern = `hh:mm a`.
///
/// * example of returning string: `06:22 PM` in case of the current locale is `en`.

String time24To12HoursFormat(DateTime dateTime) {
  return intl.DateFormat(
    "hh:mm a",
    Localizations.localeOf(_context).languageCode,
  ).format(dateTime);
}

/*String time24To12HoursFormat(int hours, int minuts) {
  String minut = minuts.toString();
  if (minut.length < 2) {
    minut = '0$minut';
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
}*/

/// ### Examples of returning string in case of the current locale is `en`
///
/// * `Today` **OR**
/// * `Yesterday` **OR**
/// * `23/7/2022` or `٢٠٢٢/٧/٢٣` for `ar`.
///
/// ## details
///
/// * If the [date] is today the returning string is `Today` in case of the current locale is `en`.
///
/// * If the [date] is yesterday the returning string is `Yesterday` in case of the current locale is `en`.
///
/// * If before the above DateFormat pattern is: `Directionality.of(context) == TextDirection.rtl ? "y/M/d" : "d/M/y"`. for example: `23/7/2022` OR `٢٠٢٢/٧/٢٣`

String formatedDate(DateTime date) {
  final currentDate = DateTime.now();

  if (currentDate.year == date.year &&
      currentDate.month == date.month &&
      currentDate.day == date.day) {
    return AppLocalizations.of(_context)!.today;
  }

  if (currentDate.year == date.year &&
      currentDate.month == date.month &&
      currentDate.day == date.day + 1) {
    return AppLocalizations.of(_context)!.yesterday;
  }

  // return '${date.day}/${date.month}/${date.year}';

  return intl.DateFormat(
    Directionality.of(_context) == TextDirection.rtl ? "y/M/d" : "d/M/y",
    Localizations.localeOf(_context).languageCode,
  ).format(date);
}

/// ### Examples of returning string in case of the current locale is `en`
///
/// * `Today at 06:22 PM` **OR**
/// * `Yesterday at 06:22 PM` **OR**
/// * `23/7/2022 at 06:22 PM` **OR** for `ar`
/// * `٢٠٢٢/٧/٢٣ الساعة ٠٨:٤٨ م`
///
/// * if [seperateByLine] = `true`, the time `06:22 PM` will be in new line.
///
/// ## details
///
/// * If the [date] is today the returning string is `Today at 06:22 PM` in case of the current locale is `en`.
///
/// * If the [date] is yesterday the returning string is `Yesterday at 06:22 PM` in case of the current locale is `en`.
///
/// * If before the above DateFormat pattern is:
///
///  ```
/// Directionality.of(context) == TextDirection.rtl ? "y/M/d" : "d/M/y"
/// ```
/// * for example:
///   * `23/7/2022 at 06:22 PM` OR
///   * `٢٠٢٢/٧/٢٣ الساعة ٠٨:٤٨ م`
///

String wellFormattedDateTime(DateTime date, {bool seperateByLine = false}) {
  final at = AppLocalizations.of(_context)!.at;

  return formatedDate(date) +
      (seperateByLine ? '\n' : ' $at ') +
      time24To12HoursFormat(date);
}

/// ### Examples of returning string in case of the current locale is `en`
/// * `Sunday, August 8, 2023 02:30 PM`.
///
/// * if [seperateByLine] = `true`, the time `02:30 PM` will be in new line.

String wellFormattedDateTimeLong(DateTime dateTime,
    {bool seperateByLine = false}) {
  final date = intl.DateFormat(
    "EEEE, d MMMM, y",
    Localizations.localeOf(_context).languageCode,
  ).format(dateTime);

  return date + (seperateByLine ? '\n' : ' ') + time24To12HoursFormat(dateTime);
}

/// ### Examples of returning string in case of the current locale is `en`
/// * ` August 2023` **OR** for `ar`
/// * `أغسطس ٢٠٢٣`

String wellFormattedDateWithoutDay(DateTime dateTime) {
  return intl.DateFormat(
    "MMMM yyy",
    Localizations.localeOf(_context).languageCode,
  ).format(dateTime);
}

DateTime getCurrentDateTimeremovedMinutesAndSeconds() =>
    DateTime.now().copyWith(
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

String formatedDuration(Duration time) {
  // print(time.toString());
  return time.toString().substring(2, 7);
}

String wellFormatedDuration(Duration duration, {bool lineEach = false}) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  final hoursString = hours == 0
      ? ''
      : '${hourWithLocalization(hours)}${_lineOrSpace(lineEach)}';

  final minutesString = minutes == 0
      ? ''
      : '${minuteWithLocalization(minutes)}${_lineOrSpace(lineEach)}';

  final secondsString = seconds == 0 ? '' : secondWithLocalization(seconds);

  return hoursString + minutesString + secondsString;
}

String _lineOrSpace(bool lineEach) {
  return lineEach ? '\n' : ' ';
}

String pastOrFutureTimeFromNow(DateTime dateTime) {
  final duration = DateTime.now().difference(dateTime);

  var d = duration.inDays ~/ 3650;
  var res = _res(d, decadeWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 365;
  res = _res(d, yearWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 30;
  res = _res(d, monthWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inDays ~/ 7;
  res = _res(d, weekWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inDays;
  res = _res(d, dayWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inHours;
  res = _res(d, hourWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  d = duration.inMinutes;
  res = _res(d, minuteWithLocalization(d.abs()));
  if (res != null) {
    return res;
  }

  return AppLocalizations.of(_context)!.justNow;
}

String? _res(int d, String timeInString) {
  if (d > 0) {
    return AppLocalizations.of(_context)!.durationAgo(timeInString);
  }

  if (d < 0) {
    return AppLocalizations.of(_context)!.durationFromNow(timeInString);
  }

  return null;
}
