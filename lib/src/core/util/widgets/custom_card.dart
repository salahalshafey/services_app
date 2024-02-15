import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    required this.child,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.side = BorderSide.none,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.elevation,
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? color;
  final BorderRadius borderRadius;
  final BorderSide side;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final void Function()? onTap;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late double _elevation;

  @override
  void initState() {
    _elevation = widget.elevation ?? 1;
    super.initState();
  }

  void _onHighlightChanged(bool changed) {
    if (changed) {
      setState(() {
        _elevation = 0.5 * _elevation;
      });
    } else {
      setState(() {
        _elevation = 2 * _elevation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius,
        side: widget.side,
      ),
      margin: widget.margin,
      elevation: _elevation,
      child: InkWell(
        borderRadius: widget.borderRadius,
        onHighlightChanged: _onHighlightChanged,
        onTap: widget.onTap,
        child: Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}
