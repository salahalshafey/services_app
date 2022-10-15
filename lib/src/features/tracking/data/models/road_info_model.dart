import '../../../../core/util/classes/pair_class.dart';

class RoadInfoModel {
  /// in km/h
  final double averageSpeed;
  final SpeedRange speedRange;
  final Duration duration;
  final Pair<int, int> indexRange;

  const RoadInfoModel({
    required this.averageSpeed,
    required this.speedRange,
    required this.duration,
    required this.indexRange,
  });
}

/// Speed ranges in km/h
enum SpeedRange {
  between0To20,
  between20To40,
  between40To80,
  between80To120,
  largerThan120,
}
