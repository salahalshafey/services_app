import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/l10n/l10n.dart';
import 'package:services_app/src/core/util/widgets/custom_card.dart';
import 'package:services_app/src/features/settings/providers/app_settings.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppSettings>(context);

    return CustomCard(
      padding: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000, minWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            DropdownButton<bool?>(
              value: provider.themeIsDark(),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.settings),
                          const SizedBox(width: 15),
                          Text(Strings.of(context).systemDefault),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.light_mode_outlined),
                      const SizedBox(width: 15),
                      Text(Strings.of(context).light),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.dark_mode_outlined),
                      const SizedBox(width: 15),
                      Text(Strings.of(context).dark),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                provider.setThemeMode(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////
///////////////////
//////

class ChangeTheme2 extends StatelessWidget {
  const ChangeTheme2({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppSettings>(context);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Theme",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          DropdownMenu<bool?>(
            initialSelection: provider.themeIsDark(),
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: null,
                label: Strings.of(context).systemDefault,
                leadingIcon: const Icon(Icons.settings),
              ),
              DropdownMenuEntry(
                value: false,
                label: Strings.of(context).light,
                leadingIcon: const Icon(Icons.light_mode_outlined),
              ),
              DropdownMenuEntry(
                value: true,
                label: Strings.of(context).dark,
                leadingIcon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            onSelected: (value) {
              provider.setThemeMode(value);
            },
          ),
        ],
      ),
    );
  }
}
