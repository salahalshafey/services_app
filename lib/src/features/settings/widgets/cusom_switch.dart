import 'package:flutter/material.dart';

import '../../../core/util/widgets/custom_card.dart';

class CusomSwitch extends StatelessWidget {
  const CusomSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentValue,
    this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool currentValue;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: CustomCard(
          borderRadius: BorderRadius.circular(15),
          child: SwitchListTile(
            contentPadding: const EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 14, fontFamily: 'Metrophobic'),
            ),
            value: currentValue,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
