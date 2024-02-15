import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'custom_alret_dialog.dart';

Future<bool> exitWillPopDialog(BuildContext context) async {
  return (await showCustomAlretDialog<bool>(
        context: context,
        constraints: const BoxConstraints(minWidth: 300),
        canPopScope: false,
        barrierDismissible: false,
        dialogDismissedAfter: const Duration(seconds: 5),
        title: AppLocalizations.of(context)!.attention,
        titleColor: Colors.red,
        content: AppLocalizations.of(context)!.doYouWantToExit,
        actionsPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        actionsBuilder: (dialogContext) => [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            child: Text(AppLocalizations.of(context)!.exit),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.red),
              side: MaterialStatePropertyAll(BorderSide(color: Colors.red)),
            ),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      )) ??
      false;
}

/*Future<bool> onWillPopWithDialog(BuildContext context) async {
  return (await showDialog<bool?>(
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 15), () {
              Navigator.of(context).pop(false);
            }),
            builder: (context, snapshot) {
              return AlertDialog(
                title: const Text(
                  "Attention",
                  style: TextStyle(color: Colors.red, fontSize: 25),
                ),
                content: const Text(
                  "Do you really want to exit?",
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle!.color,
                      ),
                    ),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.spaceAround,
              );
            },
          );
        },
      )) ??
      false;
}*/
