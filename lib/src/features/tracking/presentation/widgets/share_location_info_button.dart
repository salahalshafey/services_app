import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/location_info.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../core/util/functions/general_functions.dart';
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
        '${date.day}/${date.month}/${date.year} at ${time24To12HoursFormat(date.hour, date.minute)}';
    final time = "time: " + dateString + "\n";

    final speed =
        "Speed of movement at this time: ${fromMeterPerSecToKPerH(lastSeenLocation.speed)} km/h";

    return name + locationlink + time + speed;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150,
      right: 10,
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
              'share ${getFirstName(serviceGiverName)} last seen location info',
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
