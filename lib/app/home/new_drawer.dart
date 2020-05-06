import 'package:flutter/material.dart';
import 'package:mademe/common_widgets/avatar.dart';
import 'package:mademe/models/avatar_reference.dart';
import 'package:mademe/services/firebase_auth_service.dart';
import 'package:mademe/services/firestore_service.dart';
import 'package:provider/provider.dart';

class NewDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(color: Color(0xFF433C3E)),
      child: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _createHeader(context)),
          Expanded(
              flex: 5,
              child: ListView(
                children: <Widget>[
                  _createDrawerItem(
                    icon: Icons.home,
                    text: 'Home',
                    context: context,
                  ),
                  _createDrawerItem(
                    icon: Icons.queue_play_next,
                    text: 'New plan',
                    context: context,
                  ),
                  _createDrawerItem(
                    icon: Icons.archive,
                    text: 'Plan archive',
                    context: context,
                  )
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _createDrawerItem(
                    icon: Icons.exit_to_app,
                    text: 'Logout',
                    context: context,
                    onTap: () => _signOut(context),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

Widget _createHeader(BuildContext context) {
  return DrawerHeader(
    child: Column(
      children: <Widget>[
        Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        _buildUserInfo(context: context),
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
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}

Widget _buildUserInfo({BuildContext context}) {
  final database = Provider.of<FirestoreService>(context, listen: false);
  return StreamBuilder<AvatarReference>(
    stream: database.avatarReferenceStream(),
    builder: (context, snapshot) {
      final avatarReference = snapshot.data;
      return Avatar(
        photoUrl: avatarReference?.photoUrl,
        radius: 50,
        borderColor: Colors.black54,
        borderWidth: 2.0,
      );
    },
  );
}
