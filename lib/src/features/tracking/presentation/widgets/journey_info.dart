import 'package:flutter/material.dart';
import 'package:services_app/src/app.dart';

import '../../../../core/util/functions/date_time_and_duration.dart';
import '../../../../core/util/functions/distance_and_speed.dart';
import '../../../../core/util/widgets/custom_card.dart';

class JourneyInfo extends StatelessWidget {
  const JourneyInfo({
    required this.totalDistance,
    required this.totalDuration,
    Key? key,
  }) : super(key: key);

  final double totalDistance;
  final Duration totalDuration;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Positioned(
      top: 10,
      left: 10,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColumnOrRow(
          alignType: isPortrait ? AlignType.column : AlignType.row,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ColorsInfo(),
            isPortrait
                ? const SizedBox(height: 5)
                : const SizedBox(width: 10), // on Row will be width
            TotalInfo(
              totalDistance: totalDistance,
              totalDuration: totalDuration,
            ),
          ],
        ),
      ),
    );
  }
}

class ColorsInfo extends StatelessWidget {
  const ColorsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Speeds in km/h',
      child: CustomCard(
        color: Colors.white70,
        padding: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(5),
        elevation: 5,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Fast',
              style: TextStyle(color: Colors.black),
            ),
            const ColorDetails(color: Colors.blue, speedRange: '[120 - ...]'),
            const ColorDetails(color: Colors.green, speedRange: '[80 - 120]'),
            const ColorDetails(color: Colors.orange, speedRange: '[40 - 80]'),
            const ColorDetails(color: Colors.red, speedRange: '[20 - 40]'),
            ColorDetails(color: Colors.red[900]!, speedRange: '[0 - 20]'),
            const Text(
              'Slow',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorDetails extends StatelessWidget {
  const ColorDetails({
    required this.color,
    required this.speedRange,
    Key? key,
  }) : super(key: key);

  final Color color;
  final String speedRange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2, bottom: 2),
            width: 7,
            height: 21,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            speedRange,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 10.4),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class TotalInfo extends StatefulWidget {
  const TotalInfo({
    required this.totalDistance,
    required this.totalDuration,
    Key? key,
  }) : super(key: key);

  final double totalDistance;
  final Duration totalDuration;

  @override
  State<TotalInfo> createState() => _TotalInfoState();
}

class _TotalInfoState extends State<TotalInfo> {
  bool _showInfo = false;

  void _toggolShowInfo() {
    setState(() {
      _showInfo = !_showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(navigatorKey.currentContext!),
      child: AnimatedContainer(
        alignment: Alignment.topLeft,
        duration: const Duration(milliseconds: 200),
        width: _showInfo ? 250 : 25,
        height: _showInfo ? 150 : 25,
        decoration: BoxDecoration(
          color: _showInfo ? Colors.white70 : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: !_showInfo
            ? InfoIconButton(onPressed: _toggolShowInfo)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InfoIconButton(onPressed: _toggolShowInfo),
                  ),
                  Info(
                    title: 'Total Distance:',
                    icon: Icon(
                      Icons.swap_calls_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    info: wellFormatedDistance(widget.totalDistance),
                  ),
                  const SizedBox(height: 15),
                  Info(
                    title: 'Total Time:',
                    icon: Icon(
                      Icons.date_range,
                      color: Theme.of(context).primaryColor,
                    ),
                    info: wellFormatedDuration(
                      widget.totalDuration,
                      lineEach: true,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class InfoIconButton extends StatelessWidget {
  const InfoIconButton({required this.onPressed, Key? key}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: const Icon(
        Icons.info,
        color: Colors.white,
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    required this.title,
    required this.icon,
    required this.info,
    Key? key,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Row(
            children: [
              icon,
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: Text(
                  info,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColumnOrRow extends StatelessWidget {
  const ColumnOrRow({
    Key? key,
    required this.alignType,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.children = const <Widget>[],
  }) : super(key: key);

  final AlignType alignType;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return alignType == AlignType.column
        ? Column(
            children: children,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
          )
        : Row(
            children: children,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
          );
  }
}

enum AlignType {
  column,
  row,
}
