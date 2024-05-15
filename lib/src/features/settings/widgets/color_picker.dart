import 'dart:math';
import 'package:flutter/material.dart';
import 'package:services_app/l10n/l10n.dart';

import '../../../core/util/widgets/custom_card.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.colorsCircleRadius,
    required this.spacingBetweenColorsItems,
    this.rowsMainAxisAlignment = MainAxisAlignment.center,
    required this.currentColor,
    required this.onSelected,
  });

  final double colorsCircleRadius;
  final double spacingBetweenColorsItems;
  final MainAxisAlignment rowsMainAxisAlignment;
  final Color currentColor;
  final void Function(Color color) onSelected;

  static final _colors = <Color>[
    Colors.blue[900]!,
    Colors.indigo,
    Colors.blueGrey,
    Colors.brown,
    const Color.fromRGBO(95, 190, 30, 1),
    Colors.lime,
    const Color.fromRGBO(224, 168, 0, 1),
    Colors.teal,
    Colors.deepOrangeAccent,
    Colors.red,
    Colors.pink,
    Colors.purpleAccent,
  ];

  /// ## Don't use this function if [_colors] is not 12 in length.
  ///
  int _fixedCountForEachRowFor12ColorsLength(int count) {
    if (count >= 12) {
      return count;
    }

    if (count >= 6) {
      return 6;
    }

    if (count == 5) {
      return 4;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: CustomCard(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          // margin: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(15),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              int countForEachRow = constraints.maxWidth ~/
                  (spacingBetweenColorsItems * 2 + colorsCircleRadius);
              if (countForEachRow == 0) {
                countForEachRow = 1;
              }

              countForEachRow =
                  _fixedCountForEachRowFor12ColorsLength(countForEachRow);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, bottom: 5),
                    child: Text(
                      Strings.of(context).color,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (int i = 0; i < _colors.length; i += countForEachRow)
                    ColorsRow2(
                      colors: _colors,
                      fromIndex: i,
                      toIndex: min(i + countForEachRow, _colors.length),
                      colorsCircleRadius: colorsCircleRadius,
                      spacingBetweenColorsItems: spacingBetweenColorsItems,
                      mainAxisAlignment: rowsMainAxisAlignment,
                      currentColor: currentColor,
                      onSelected: onSelected,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ColorsRow extends StatelessWidget {
  const ColorsRow({
    super.key,
    required this.colors,
    required this.fromIndex,
    required this.toIndex,
    required this.colorsCircleRadius,
    required this.spacingBetweenColorsItems,
    required this.mainAxisAlignment,
    required this.currentColor,
    required this.onSelected,
  });

  final List<Color> colors;
  final int fromIndex;
  final int toIndex;
  final double colorsCircleRadius;
  final double spacingBetweenColorsItems;
  final MainAxisAlignment mainAxisAlignment;
  final Color currentColor;
  final void Function(Color color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: colors
          .sublist(fromIndex, toIndex)
          .map(
            (color) => Padding(
              padding: EdgeInsets.all(spacingBetweenColorsItems),
              child: IconButton(
                onPressed: () => onSelected(color),
                icon: currentColor.value == color.value
                    ? const Icon(Icons.check, color: Colors.white)
                    : const SizedBox(),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(color),
                  fixedSize: WidgetStatePropertyAll(
                    Size(colorsCircleRadius, colorsCircleRadius),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ColorsRow2 extends StatelessWidget {
  const ColorsRow2({
    super.key,
    required this.colors,
    required this.fromIndex,
    required this.toIndex,
    required this.colorsCircleRadius,
    required this.spacingBetweenColorsItems,
    required this.mainAxisAlignment,
    required this.currentColor,
    required this.onSelected,
  });

  final List<Color> colors;
  final int fromIndex;
  final int toIndex;
  final double colorsCircleRadius;
  final double spacingBetweenColorsItems;
  final MainAxisAlignment mainAxisAlignment;
  final Color currentColor;
  final void Function(Color color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: colors
          .sublist(fromIndex, toIndex)
          .map(
            (color) => Padding(
              padding: EdgeInsets.all(spacingBetweenColorsItems),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                width: colorsCircleRadius,
                height: colorsCircleRadius,
                child: InkWell(
                  onTap: () => onSelected(color),
                  radius: colorsCircleRadius,
                  borderRadius: BorderRadius.circular(1000),
                  child: currentColor.value == color.value
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

////////////////////////////////////////////////////////////////////
/////////////////////////////////////
/////

class ColorPickerFromGrid extends StatelessWidget {
  const ColorPickerFromGrid({super.key});

  static const _colors = <Color>[
    Color.fromRGBO(95, 190, 30, 1),
    Colors.blueGrey,
    Colors.red,
    Colors.pink,
    Colors.purpleAccent,
    Colors.indigo,
    Color.fromRGBO(224, 168, 0, 1),
    Colors.blue,
    Colors.teal,
    Colors.lime,
    Colors.deepOrangeAccent,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Color",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  //  crossAxisCount: 6,
                  maxCrossAxisExtent: 60,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  // mainAxisExtent: 50,
                ),
                children: _colors
                    .map((color) => IconButton(
                          onPressed: () {},
                          icon: const SizedBox(),
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(color)),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
