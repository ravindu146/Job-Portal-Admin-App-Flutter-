import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              DrawerHeader(
                  child: Icon(
                Icons.work,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),

              // Home tile
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('H O M E'),
                  onTap: () {
                    // This is already the homeScreen, So we just pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // companies
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(Icons.business),
                  title: Text('C O M P A N I E S'),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/companies_page');
                  },
                ),
              ),

              // profile tile
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(Icons.business),
                  title: Text('P R O F I L E'),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, bottom: 25),
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('L O G O U T'),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // logout
                    logOut();
                  },
                ),
              ),
            ],
          )

          //
        ],
      ),
    );
  }
}
