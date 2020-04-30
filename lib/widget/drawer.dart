import 'package:flutter/material.dart';
import 'package:mademe/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   fit: BoxFit.fill,
          //   image: AssetImage('path/to/header_background.png'),
          // ),
          ),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon,
      String text,
      GestureTapCallback onTap,
      BuildContext context}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.body1,
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
            context: context,
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.new_releases,
            text: 'New Plan',
            context: context,
          ),
          _createDrawerItem(
            icon: Icons.archive,
            text: 'Archived Plan',
            context: context,
          ),
          _createDrawerItem(
            icon: Icons.info,
            text: 'About us',
            context: context,
          ),
          SizedBox(
            height: 100.0,
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Log out',
            context: context,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
