import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.text,
    required this.iconActive,
    required this.iconDeActive,
    required this.onPressed,
    this.isActive = true,
    super.key,
  });

  final String text;
  final IconData iconActive;
  final IconData iconDeActive;
  final bool isActive;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: TextButton.icon(
        onPressed: isActive ? onPressed : null,
        icon: Icon(
          isActive ? iconActive : iconDeActive,
          color: isActive ? Colors.green : Colors.grey,
        ),
        label: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: !isActive
                  ? Colors.grey
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
