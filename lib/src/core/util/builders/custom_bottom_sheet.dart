import 'package:flutter/material.dart';

Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  double? hight,
  String? title,
  bool containingButton = true,
  String? buttonTitle,
  void Function()? onButtonPressed,
}) =>
    showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          final keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;

          return SizedBox(
            height: hight ?? screenHeight * 0.8,
            child: Column(
              children: [
                ListTile(
                  leading: const SizedBox(),
                  title: Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.clear_rounded),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                Expanded(
                  child: child,
                ),
                if (containingButton)
                  ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ButtonStyle(
                      minimumSize:
                          WidgetStatePropertyAll(Size(screenWidth * 0.9, 20)),
                    ),
                    child: Text(buttonTitle ?? ''),
                  ),
                SizedBox(height: keyBoardHeight),
              ],
            ),
          );
        });
