import 'package:flutter/material.dart';
import 'package:services_app/l10n/l10n.dart';
import 'package:services_app/src/core/util/builders/go_to_screen_with_slide_transition.dart';

import 'appearance_screen.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routName = '/settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: [
          SettingsItem(
            icon: const Icon(Icons.language),
            title: Strings.of(context).language,
            onTap: () {
              goToScreenWithSlideTransition(context, const LanguageScreen());
            },
          ),
          SettingsItem(
            icon: const Icon(Icons.remove_red_eye_outlined),
            title: "Appearance",
            onTap: () {
              goToScreenWithSlideTransition(context, const AppearanceScreen());
            },
          ),
          SettingsItem(
            icon: const Icon(Icons.person_outline),
            title: "Account",
            onTap: () {},
          ),
          SettingsItem(
            icon: const Icon(Icons.notifications_none),
            title: Strings.of(context).notifications,
            onTap: () {},
          ),
          SettingsItem(
            icon: const Icon(Icons.lock_outline_rounded),
            title: "Privacy & Security",
            onTap: () {},
          ),
          SettingsItem(
            icon: const Icon(Icons.headphones_outlined),
            title: "Help and Support",
            onTap: () {},
          ),
          SettingsItem(
            icon: const Icon(Icons.question_mark_rounded),
            title: Strings.of(context).about,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          leading: icon,
          title: Text(title),
          trailing: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            textDirection: Directionality.of(context) == TextDirection.rtl
                ? TextDirection.ltr
                : TextDirection.rtl,
          ),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
