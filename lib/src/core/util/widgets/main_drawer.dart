import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_container.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<MyAccount>(context);

    return Drawer(
      key: const PageStorageKey('Drawer'),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          MyDrawerHeader(currentUser.image, currentUser.name),
          MenuChoice(
            icon: const Icon(Icons.language),
            name: 'Language',
            onTap: () {},
          ),
          MenuChoice(
            icon: const Icon(Icons.details),
            name: 'About Us',
            onTap: () {},
          ),
          MenuChoice(
            icon: const Icon(Icons.search),
            name: 'Conditions And Terms',
            onTap: () {},
          ),
          MenuChoice(
            icon: const Icon(Icons.share),
            name: 'Share',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///////////// Some Widgets only wanted in this file ////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class MenuChoice extends StatelessWidget {
  const MenuChoice({
    required this.icon,
    required this.name,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final String name;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              icon,
              const SizedBox(width: 40),
              Text(name),
            ],
          ),
          onTap: onTap,
        ),
        const Divider(
          height: 5,
        ),
      ],
    );
  }
}

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader(this.userImage, this.userName, {Key? key})
      : super(key: key);

  final String userImage;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_images/blue-background.jpg'),
          // colorFilter: ColorFilter.linearToSrgbGamma(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////// User Image //////////////////////////// // overlayColor: MaterialStateProperty.all<Color>(Colors.black87),
          ImageContainer(
            image: userImage,
            imageSource: From.asset,
            radius: 30,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0),
            showHighlight: true,
            onTap: () =>
                Navigator.of(context).popAndPushNamed(ProfileScreen.routName),
          ),

          //////////// User Name ///////////////////////////
          TextButton(
            onPressed: () =>
                Navigator.of(context).popAndPushNamed(ProfileScreen.routName),
            child: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.white.withOpacity(0.1)),
            ),
          ),
        ],
      ),
    );
  }
}
