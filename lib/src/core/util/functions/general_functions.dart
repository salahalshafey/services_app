// general-purpose functions will be here

import 'dart:math';

num getRangeRandom({
  required double from,
  required double to,
  RandomType randomType = RandomType.double,
}) {
  final doubleRandom = Random().nextDouble() * (to - from) + from;

  if (randomType == RandomType.double) {
    return doubleRandom;
  }

  return doubleRandom.toInt();
}

enum RandomType {
  int,
  double,
}
