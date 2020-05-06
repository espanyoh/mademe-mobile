import 'package:mademe/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:mademe/utilities/styles.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  var _isMember = true;
  var _error = "";

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInEmailPassword(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      if (emailCtrl.value.text == "") {
        setState(() => _error = "Please enter email");
      }
      if (passwordCtrl.value.text == "") {
        setState(() => _error = "Please enter password");
        return;
      }
      var user = await auth.signInEmailPassword(
          emailCtrl.value.text, passwordCtrl.value.text);
      print(user);
      if (user == null) {
        setState(() => _error = "Fail to login");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signUpEmailPassword(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      print("email : ${emailCtrl.value.text}");
      print("passwordCtrl : ${emailCtrl.value.text}");
      if (emailCtrl.value.text == "") {
        setState(() => _error = "Please enter email");
      }
      if (passwordCtrl.value.text == "") {
        setState(() => _error = "Please enter password");
        return;
      }
      if (confirmCtrl.value.text == "") {
        setState(() => _error = "Please enter confirm password");
        return;
      }
      if (passwordCtrl.value.text != confirmCtrl.value.text) {
        _error = "Confirm password does not match";
        return;
      }

      await auth.signUpEmailPassword(
          emailCtrl.value.text, passwordCtrl.value.text);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE6DBDD),
                    Color(0xFF9C9495),
                    Color(0xFF433C3E),
                  ],
                  stops: [0.1, 0.3, 0.9],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'CRAFT CHEF',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF433D3E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0, left: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30.0),
                          _buildEmailTF(),
                          SizedBox(height: 15.0),
                          _buildPasswordTF(),
                          _isMember
                              ? SizedBox(height: 0.0)
                              : SizedBox(
                                  height: 15.0,
                                ),
                          _isMember
                              ? SizedBox(
                                  height: 0.0,
                                )
                              : _buildPasswordConfirmTF(),
                          SizedBox(height: 15.0),
                          _buildSubmitBtn(),
                          _buildErrorDisplay(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 25,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0, left: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildOrDivider(),
                          _buildSocialBtnRow(),
                          _buildSwitchLogInSignUpMode(),
                          SizedBox(
                            height: 10.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _inputBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _inputBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: passwordCtrl,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordConfirmTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: _inputBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: confirmCtrl,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Confirm your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (_isMember) {
            _signInEmailPassword(context);
          } else {
            _signUpEmailPassword(context);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFE3562),
        child: Text(
          _isMember ? 'LOGIN' : 'SIGNUP',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Divider(
                    color: Colors.white,
                    height: 40,
                  )),
            ),
            Text(
              "OR",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                    color: Colors.white,
                    height: 40,
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchLogInSignUpMode() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMember = !_isMember;
          _error = "";
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _isMember
                  ? 'Don\'t have an Account? '
                  : 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: _isMember ? 'Sign Up' : 'Log in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: (_error != "") ? _error : '',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  final _inputBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF433D3E),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}
