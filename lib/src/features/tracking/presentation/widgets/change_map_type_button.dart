import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/util/widgets/custom_card.dart';

class ChangeMapTypeButton extends StatelessWidget {
  const ChangeMapTypeButton(
    this.mapType,
    this.toggleMapeType, {
    Key? key,
  }) : super(key: key);

  final MapType mapType;
  final void Function() toggleMapeType;

  String get _nextMapType {
    switch (mapType) {
      case MapType.normal:
        return 'satellite';
      case MapType.satellite:
        return 'terrain';
      case MapType.terrain:
        return 'hybrid';
      case MapType.hybrid:
        return 'normal';
      default:
        return 'normal';
    }
  }

  /*double topIfLandscape(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        -AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    print(bodyHeight);

    final heightFactor = (bodyHeight - 120) / 4;

    return 3.0 * heightFactor + 80.0;
  }*/

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double? top, right, left;
    if (isPortrait) {
      top = 220;
      right = 10;
      left = null;
    } else {
      top = 200; //topIfLandscape(context);
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
            Icons.map_sharp,
            color: Colors.black54,
          ),
          tooltip: 'Change map type to $_nextMapType',
          onPressed: toggleMapeType,
        ),
      ),
    );
  }
}
