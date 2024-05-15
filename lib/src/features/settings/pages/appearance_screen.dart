import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/util/extensions/list_seperator.dart';

import '../providers/app_settings.dart';

import '../widgets/change_theme.dart';
import '../widgets/color_picker.dart';
import '../widgets/cusom_switch.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        children: const [
          ChangeTheme(),
          ChangeColorScheme(),
          ChangeUseMaterial3(),
          ResetApearanceButton(),
        ].verticalSeperateBy(const SizedBox(height: 30)),
      ),
    );
  }
}

class ChangeColorScheme extends StatelessWidget {
  const ChangeColorScheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (ctx, provider, child) {
        return ColorPicker(
          colorsCircleRadius: 50,
          spacingBetweenColorsItems: 4.0,
          rowsMainAxisAlignment: MainAxisAlignment.center,
          currentColor: provider.currentColor,
          onSelected: provider.setColor,
        );
      },
    );
  }
}

class ChangeUseMaterial3 extends StatelessWidget {
  const ChangeUseMaterial3({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (ctx, provider, child) {
        return CusomSwitch(
          title: "Material 3",
          subtitle: "Use New Material 3",
          currentValue: provider.useMaterial3,
          onChanged: provider.setuseMaterial3,
        );
      },
    );
  }
}

class ResetApearanceButton extends StatelessWidget {
  const ResetApearanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (ctx, provider, child) {
        return Align(
          alignment: AlignmentDirectional.center,
          child: ElevatedButton(
            onPressed: () {
              provider.setThemeMode(null);
              provider.setColor(null);
              provider.setuseMaterial3(null);
            },
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 40))),
            child: const Text("Reset"),
          ),
        );
      },
    );
  }
}
