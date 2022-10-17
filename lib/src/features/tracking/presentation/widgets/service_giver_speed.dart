import 'package:flutter/material.dart';

import '../../../../core/util/functions/distance_and_speed.dart';
import '../../../../core/util/functions/string_manipulations_and_search.dart';

class ServiceGiverSpeed extends StatelessWidget {
  const ServiceGiverSpeed({
    Key? key,
    required this.speed,
    required this.name,
  }) : super(key: key);

  final double speed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      right: 10,
      child: FloatingActionButton(
        tooltip: 'Last seen ${firstName(name)} speed',
        onPressed: null,
        backgroundColor: Colors.white.withOpacity(0.85),
        foregroundColor: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fromMeterPerSecToKPerH(speed)),
            const Text('km/h'),
          ],
        ),
      ),
    );
  }
}
