import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../utils/colors_and_theme.dart';

class ThemeSubMenu extends ConsumerStatefulWidget {
  const ThemeSubMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ThemeSubMenuWidgetState();
  }
}

class _ThemeSubMenuWidgetState extends ConsumerState<ThemeSubMenu> {
  @override
  Widget build(BuildContext context) {
    final _themeModeProvider = ref.read(themeModeProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    void onThemeSelected(ThemeMode themeMode) {
      _themeModeProvider.updateTheme(themeMode);
      Navigator.pop(context);
    }

    return PopupMenuButton<ThemeMode>(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.brightness_5),
          SizedBox(width: 8),
          Text(
            'Theme',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? kDarkWhiteShade1
                  : null,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_right),
        ],
      ),
      onSelected: (ThemeMode themeMode) {
        onThemeSelected(themeMode);
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.light,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(themeMode == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.light_mode_outlined),
                const SizedBox(width: 8),
                Text(
                  'Light Theme',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDarkWhiteShade1
                        : null,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.dark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.dark_mode_outlined),
                const SizedBox(width: 8),
                Text(
                  'Dark Theme',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDarkWhiteShade1
                        : null,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.system,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(themeMode == ThemeMode.system
                    ? Icons.settings
                    : Icons.settings_outlined),
                const SizedBox(width: 8),
                Text(
                  'System Default',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDarkWhiteShade1
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
