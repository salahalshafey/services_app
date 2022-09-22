import 'package:flutter/material.dart';

Future<T?> showCustomAlretDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  Color? titleColor,
  Color? contentColor,
  List<Widget>? actions,
}) =>
    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: titleColor)),
          content: Text(content, style: TextStyle(color: contentColor)),
          actions: <Widget>[
            if (actions == null)
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            if (actions != null) ...actions,
          ],
        );
      },
    );
