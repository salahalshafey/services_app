import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'text_well_formatted.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.error,
    this.errorFontSize,
    this.icon = Icons.close,
    this.iconColor,
    this.iconSize,
    this.backgroundIconColor,
  });

  final String? error;
  final double? errorFontSize;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundIconColor;

  @override
  Widget build(BuildContext context) {
    final color = backgroundIconColor ?? Colors.redAccent.shade700;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                icon,
                size: iconSize ?? 70,
                color: iconColor ?? Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              AppLocalizations.of(context)!.error,
              style: TextStyle(fontSize: (iconSize ?? 70) - 10),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (error != null)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(10),
              color: color.withOpacity(0.1),
            ),
            child: TextWellFormattedWithBulleted(
              data: error ?? "",
              fontSize: errorFontSize ?? 16,
            ),
          ),
      ],
    );
  }
}
