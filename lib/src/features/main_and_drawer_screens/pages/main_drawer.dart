import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/l10n/l10n.dart';

import '../../settings/pages/settings_screen.dart';
import '../../account/presentation/pages/account_screen.dart';

import '../../account/presentation/providers/account.dart';
import '../../../core/util/widgets/image_container.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Account>(context);

    return Drawer(
      key: const PageStorageKey('Drawer'),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          MyDrawerHeader(currentUser.image, currentUser.name),
          MenuChoice(
            icon: const Icon(Icons.person),
            name: Strings.of(context).profile,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(AccountScreen.routName);
            },
          ),
          MenuChoice(
            icon: const Icon(Icons.settings),
            name: Strings.of(context).settings,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(SettingsScreen.routName);
            },
          ),
          /* MenuChoice(
            icon: const Icon(Icons.question_mark_rounded),
            name: 'About Us',
            onTap: () {},
          ),*/
          MenuChoice(
            icon: const Icon(Icons.search),
            name: 'Conditions And Terms',
            onTap: () {},
          ),
          MenuChoice(
            icon: const Icon(Icons.share),
            name: Strings.of(context).shareTheApp,
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              const AssetImage('assets/background_images/blue-background.jpg'),
          colorFilter:
              ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.color),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////// User Image //////////////////////////// // overlayColor: WidgetStatePropertyAll<Color>(Colors.black87),
          ImageContainer(
            image: userImage,
            imageSource: From.asset,
            radius: 30,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0),
            showHighlight: true,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(AccountScreen.routName);
            },
          ),

          //////////// User Name ///////////////////////////
          TextButton(
            onPressed: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(AccountScreen.routName);
            },
            child: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              overlayColor:
                  WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
            ),
          ),
        ],
      ),
    );
  }
}
