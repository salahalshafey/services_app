import 'package:flutter/material.dart';

class BackButtonWithImage extends StatelessWidget {
  /// if it will be used in the [AppBar.leading] you have to set [leadingWidth] = 80
  const BackButtonWithImage({required this.networkImage, Key? key})
      : super(key: key);
  final String networkImage;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(backgroundImage: NetworkImage(networkImage)),
            ],
          ),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
              backgroundColor:
                  const MaterialStatePropertyAll(Color.fromARGB(0, 2, 1, 1))),
        ),
      ),
    );
  }
}
