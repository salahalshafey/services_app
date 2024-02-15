import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/location_info.dart';

import '../../../../core/util/functions/date_time_and_duration.dart';
import '../../../../core/util/functions/distance_and_speed.dart';
import '../../../../core/util/functions/string_manipulations_and_search.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../core/util/widgets/custom_card.dart';

class ShareLocationInfoButton extends StatelessWidget {
  const ShareLocationInfoButton({
    required this.lastSeenLocation,
    required this.serviceGiverName,
    Key? key,
  }) : super(key: key);

  final LocationInfo lastSeenLocation;
  final String serviceGiverName;

  String get sharingText {
    final name = "Name of the service giver: $serviceGiverName\n";

    final locationlink = "Last seen location:\n"
        "https://maps.google.com/?q=${lastSeenLocation.latitude},${lastSeenLocation.longitude}\n";

    final date = lastSeenLocation.time;
    final dateString =
        '${date.day}/${date.month}/${date.year} at ${time24To12HoursFormat(date)}';
    final time = "time: " + dateString + "\n";

    final speed =
        "Speed of movement at this time: ${fromMeterPerSecToKPerH(lastSeenLocation.speed)} km/h";

    return name + locationlink + time + speed;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double? top, right, left;
    if (isPortrait) {
      top = 150;
      right = 10;
      left = null;
    } else {
      top = 120;
      left = 10;
      right = null;
    }

    return Positioned(
      top: top,
      right: right,
      left: left,
      width: 40,
      height: 40,
      child: CustomCard(
        color: Colors.white.withOpacity(0.85),
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.share,
            color: Colors.black54,
          ),
          tooltip:
              'Share ${firstName(serviceGiverName)} last seen location info',
          onPressed: () => _share(context, sharingText),
        ),
      ),
    );
  }
}

Future<void> _share(BuildContext context, String text) async {
  try {
    await Share.share(text);
  } catch (error) {
    showCustomSnackBar(
      context: context,
      content: 'Error happend while trying to share the location info.',
    );
  }
}
