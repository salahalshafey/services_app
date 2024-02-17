import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_app/l10n/l10n.dart';

import '../providers/app_settings.dart';
import '../providers/languages.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).language),
        centerTitle: true,
      ),
      body: Consumer<AppSettings>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            itemCount: Languages.allLocaleWithDetails.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SystemDefaultLanguage();
              }

              return ListTile(
                leading: Text(
                  Languages.allLocaleWithDetails[index - 1].countryFlage,
                  style: const TextStyle(fontSize: 16),
                ),
                title: Text(
                    Languages.allLocaleWithDetails[index - 1].languageFullName),
                trailing: Offstage(
                  offstage: !provider.currentLanguageIsSameOf(
                      Languages.allLocaleWithDetails[index - 1].languageCode),
                  child: const Icon(Icons.check),
                ),
                onTap: () => provider.setLanguage(
                    Languages.allLocaleWithDetails[index - 1].languageCode),
              );
            },
          );
        },
      ),
    );
  }
}

class SystemDefaultLanguage extends StatelessWidget {
  const SystemDefaultLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppSettings>(context);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings),
          iconColor: Theme.of(context).primaryColor,
          title: Text(Strings.of(context).systemDefault),
          trailing: Offstage(
            offstage: !(provider.currentLocal == null),
            child: const Icon(Icons.check),
          ),
          onTap: () => provider.setLanguage(null),
        ),
        const Divider(),
      ],
    );
  }
}
