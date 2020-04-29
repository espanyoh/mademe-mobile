import 'package:flutter/material.dart';
import 'package:mademe/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Made Me"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('Home Page!')),
        ],
      ),
      drawer: Container(
        width: 200.0,
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Welcome Esponyoh',
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: Theme.of(context).textTheme.body1,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.next_week),
                title: Text(
                  'New Plan',
                  style: Theme.of(context).textTheme.body1,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.archive),
                title: Text(
                  'Archived Plan',
                  style: Theme.of(context).textTheme.body1,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  'About us',
                  style: Theme.of(context).textTheme.body1,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  'Log out',
                  style: Theme.of(context).textTheme.body1,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
