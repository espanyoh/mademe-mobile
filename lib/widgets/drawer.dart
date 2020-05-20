import 'package:flutter/material.dart';
import 'package:mademe/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: Drawer(
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
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Text(
            'Welcome Esponyoh',
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          CircleAvatar(
            radius: 35.0,
            backgroundImage: AssetImage('assets/temp/user.png'),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
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
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
