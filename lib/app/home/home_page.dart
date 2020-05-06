import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mademe/app/home/about_page.dart';
import 'package:mademe/common_widgets/avatar.dart';
import 'package:mademe/models/avatar_reference.dart';
import 'package:mademe/services/cooking_plan_service.dart';
import 'package:mademe/services/firebase_auth_service.dart';
import 'package:mademe/services/firebase_storage_service.dart';
import 'package:mademe/services/firestore_service.dart';
import 'package:mademe/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAbout(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AboutPage(),
      ),
    );
  }

  Future<void> _chooseAvatar(BuildContext context) async {
    try {
      // 1. Get image from picker
      final imagePicker =
          Provider.of<ImagePickerService>(context, listen: false);
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        // 2. Upload to storage
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final downloadUrl = await storage.uploadAvatar(file: file);
        // 3. Save url to Firestore
        final database = Provider.of<FirestoreService>(context, listen: false);
        await database.setAvatarReference(AvatarReference(downloadUrl));
        // 4. (optional) delete local file as no longer needed
        await file.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.help),
          onPressed: () => _onAbout(context),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: Column(
            children: <Widget>[
              _buildUserInfo(context: context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.redAccent,
            width: 200.0,
            height: 300.0,
            child: Text('111111342'),
          ),
          _buildPlanList(context: context),
        ],
      ),
    );
  }

  Widget _buildUserInfo({BuildContext context}) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    return StreamBuilder<AvatarReference>(
      stream: database.avatarReferenceStream(),
      builder: (context, snapshot) {
        final avatarReference = snapshot.data;
        return Avatar(
          photoUrl: avatarReference?.downloadUrl,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
          onPressed: () => _chooseAvatar(context),
        );
      },
    );
  }
}

Widget _buildPlanList({BuildContext context}) {
  final planService = Provider.of<PlanService>(context, listen: false);
  return StreamBuilder<QuerySnapshot>(
    //StreamBuilder<List<Plan>>(
    stream: planService.planStream(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error.....sy..: ${snapshot.error}');
      if (!snapshot.hasData) return new Text('dont have data.....y..: ');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:
          print(snapshot.data.documents.length);
          print(snapshot.data.documents.map((doc) => print(doc.data)));
          return new ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot doc) {
              return new ListTile(
                title: new Text(doc.data['title']),
                subtitle: new Text(doc.data['description']),
              );
            }).toList(),
          );
      }
    },
  );
}
