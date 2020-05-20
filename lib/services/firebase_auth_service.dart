import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
class User {
  const User({@required this.uid});
  final String uid;
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInEmailPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print("authResult.user = ${authResult.user}");
    return _userFromFirebase(authResult.user);
  }

  Future<User> signUpEmailPassword(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future loginWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email', "public_profile"]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;
        final authResult = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.getCredential(accessToken: token));
        createDefaultPlan(authResult.user);
        return _userFromFirebase(authResult.user);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancel login');
        break;
      case FacebookLoginStatus.error:
        print('error : ' + result.errorMessage);
        break;
    }
  }

  Future loginWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final googleAccount = await _googleSignIn.signIn();
    print('googleAccount:' + googleAccount.toString());
    final GoogleSignInAuthentication googleAuthen =
        await googleAccount.authentication;
    print('googleAuthen:' + googleAuthen.toString());
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuthen.accessToken,
      idToken: googleAuthen.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    print('authResult:' + authResult.toString());
    createDefaultPlan(authResult.user);
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  void createDefaultPlan(FirebaseUser user) async {
    var now = ((new DateTime.now()).millisecondsSinceEpoch / 1000).round();
    await Firestore.instance.collection('profiles').document(user.uid).setData({
      "photoUrl": user.photoUrl,
      "created_at": now,
      "username": user.displayName,
      "email": user.email
    });

    var plan = await Firestore.instance
        .collection('profiles')
        .document(user.uid)
        .collection('plans')
        .add({"active": true, "created_at": now, "title": "Welcome plan"});
    print('done for create plan' + plan.documentID);
  }
}
