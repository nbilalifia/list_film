// navbar_widget.dart

import 'package:flutter/material.dart';
import 'package:list_film/data/notifiers.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedIndex: selectedPage,
          onDestinationSelected: (int index) {
            selectedPageNotifier.value = index;
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box),
              label: 'Tambah',
            ),
          ],
        );
      },
    );
  }
}
