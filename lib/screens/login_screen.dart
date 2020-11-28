import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_assignment/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  void _loginWithFacebook() async {
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken facebookAccessToken = result.accessToken;
      AuthCredential authCredential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);

      setState(() {
        loading = true;
      });

      _auth.signInWithCredential(authCredential).then((onValue) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((onError) {
        setState(() {
          loading = false;
        });
        debugPrint('onError $onError');
      });
    } else {
      setState(() {
        loading = false;
      });
      //something
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: loading
          ? Center(
              child: CupertinoActivityIndicator())
          : Center(
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(57, 57, 57, 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200]),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      'Sign in with your facebook account',
                      style: TextStyle(fontSize: 16, color: Colors.grey[200]),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: RaisedButton.icon(
                              color: Color.fromRGBO(66, 103, 178, 1),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                _loginWithFacebook();
                              },
                              icon: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  'images/fblogo.png',
                                  width: 30,
                                ),
                              ),
                              label: Text('Sign in with Facebook',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[200]))),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
