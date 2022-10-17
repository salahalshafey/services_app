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

String wellFormattedDateTime(DateTime date, {bool seperateByLine = false}) {
  return formatedDate(date) +
      (seperateByLine ? '\n' : ' at ') +
      time24To12HoursFormat(date.hour, date.minute);
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
