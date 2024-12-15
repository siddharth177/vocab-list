import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocab_list/widgets/theme_popup_menu_widget.dart';

import '../utils/colors_and_theme.dart';
import '../utils/firebase.dart';

class PopMenuWidget extends StatefulWidget {
  const PopMenuWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuWidgetState();
  }
}

class _PopupMenuWidgetState extends State<PopMenuWidget> {
  IconData menuIcon = Icons.menu;

  @override
  Widget build(BuildContext context) {
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
            const PopupMenuItem(
              value: 'theme',
              child: ThemeSubMenu(
              ),
            ),
          ];
        });
  }
}