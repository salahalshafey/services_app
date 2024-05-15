import 'package:flutter/material.dart';

class BackButtonWithImage extends StatelessWidget {
  /// if it will be used in the [AppBar.leading] you have to set [leadingWidth] = 80
  ///
  const BackButtonWithImage({required this.networkImage, super.key});
  final String networkImage;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 5),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.all(4)),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
              backgroundColor:
                  const WidgetStatePropertyAll(Colors.transparent)),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(backgroundImage: NetworkImage(networkImage)),
            ],
          ),
        ),
      ),
    );
  }
}
