import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:joalarm/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:joalarm/constants.dart';
final _storage = FlutterSecureStorage();


  Future<String> fbSignIn(String? username, String? fbid, String? email, String? photo) async {
    var url = Uri.parse('$SERVER_IP/fb_sign_in');
    var res = await http
        .post(url, body: {"username": username!, "fbid": fbid!, "email": email!, "photo": photo!});

    if (res.statusCode == 200) return res.body;
    return 'Failed..';
  }


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
      String? username = _userData!['name'];
      String? fbid = _userData!['id'].toString();
      String? email = _userData!['email'];
      String? photo = _userData!['picture']['data']['url'];
      var jwt = await fbSignIn(username, fbid, email, photo);
      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage.fromBase64(jwt)));
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
      // by default we get the userId, emasil,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
      // var url =
      // Uri.parse('https://graph.facebook.com/${_userData!['id']}/picture');
      // final graphResponse = await http.get(url);
      // print(json.decode(graphResponse.body));
      // prettyPrint(_userData!);
      String? username = _userData!['name'];
      String? fbid = _userData!['id'].toString();
      String? email = _userData!['email'];
      String? photo = _userData!['picture']['data']['url'];
      var jwt = await fbSignIn(username, fbid, email, photo);
      if (jwt != 'Failed..') {
                    await _storage.write(key: "jwt", value: jwt);
                    print(jwt);
                    await attemptUpdateUserToken();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage.fromBase64(jwt)));
                  } else {
                    displayDialog(context, "Ooops!錯誤..", "請重新開啟App!");
                  }
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
        body: _checking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
        child: Container(
            padding: EdgeInsets.all(35),
            child: Image(image: AssetImage('3.png')))),
            SizedBox(height: 30),
                        Text(
              "歡迎加入 Joalarm\n",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "喜歡的話，就請敲響彼此的戀愛鈴吧！",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.64),
              ),),
                      SizedBox(height: 50),
                      CupertinoButton(
                        color: Colors.black,
                        child: Text('登入',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async { await _login(); }
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
