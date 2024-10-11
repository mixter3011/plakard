import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("P R O F I L E"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("M Y  C A R D S"),
                  leading: const Icon(Icons.credit_card),
                  onTap: () {
                    if (ModalRoute.of(context)!.settings.name == '/my-cards') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamed(context, '/my-cards');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void logout() {}
}
