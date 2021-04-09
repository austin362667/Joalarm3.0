import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class FbSignInPage extends StatefulWidget {
  @override
  _FbSignInPageState createState() => _FbSignInPageState();
}

class _FbSignInPageState extends State<FbSignInPage> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken!.toJson()),
    );
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by the fault we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      _printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
      // var url =
      // Uri.parse('https://graph.facebook.com/${_userData!['id']}/picture');
      // final graphResponse = await http.get(url);
      // print(json.decode(graphResponse.body));
      // prettyPrint(_userData!);
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      _checking = false;
    });
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: _checking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Image.network(
                              _userData!['picture']['data']['url'])),
                      Text(
                        _userData != null
                            ? prettyPrint(_userData!)
                            : "NO LOGGED",
                      ),
                      SizedBox(height: 20),
                      _accessToken != null
                          ? Text(
                              prettyPrint(_accessToken!.toJson()),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      CupertinoButton(
                        color: Colors.blue,
                        child: Text(
                          _userData != null ? "LOGOUT" : "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _userData != null ? _logOut : _login,
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
