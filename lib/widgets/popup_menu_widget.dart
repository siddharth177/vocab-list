import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../utils/colors_and_theme.dart';
import '../utils/firebase.dart';

class PopMenuWidget extends ConsumerStatefulWidget {
  const PopMenuWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PopupMenuWidgetState();
  }
}

class _PopupMenuWidgetState extends ConsumerState<PopMenuWidget> {
  IconData menuIcon = Icons.menu;
  bool _showThemeMenu = false;

  void _toggleThemeMenu() {
    setState(() {
      _showThemeMenu = !_showThemeMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.watch(themeModeProvider);
    final themeMode = ref.watch(themeModeProvider);
    return PopupMenuButton<String>(
        onOpened: () {
          setState(() {
            menuIcon = Icons.menu_open;
          });
        },
        onCanceled: () {
          setState(() {
            menuIcon = Icons.menu;
          });
        },

        icon: Icon(menuIcon),
        onSelected: (value) {
          if (value == 'logout') {
            firebaseAuthInstance.signOut();
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.logout),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kDarkWhiteShade1
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            // PopupMenuItem<String>(
            //   value: 'theme',
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       const Icon(Icons.brightness_5),
            //       Text(
            //         'Theme',
            //         style: TextStyle(
            //           color: Theme.of(context).brightness == Brightness.dark
            //               ? kDarkWhiteShade1
            //               : null,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        });
  }
}
