import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joalarm/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show base64, json, utf8;
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:joalarm/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

File? _image;

class MyFacePage extends StatefulWidget {
  @override
  _MyFacePageState createState() => _MyFacePageState();
}

class _MyFacePageState extends State<MyFacePage> {
// final File file;
// new File('tmp').createSync();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final picker = ImagePicker();
  var result;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('Image selected.');
      } else {
        print('No image selected.');
      }
    });
  }

  Future<int> attemptUpdateUserPref(List<num> _pref) async {
  String? _jwt = await safeStorage.read(key: 'jwt');
  Map<String, dynamic> _payload = json.decode(
      utf8.decode(base64.decode(base64.normalize(_jwt!.split(".")[1]))));

  // firebaseMessaging = await configureMessaging();

  var url = Uri.parse('$SERVER_IP/userPref');
  var res = await http.post(url,
      headers: {"Authorization": _jwt},
      body: {"userid": "${_payload['userid']}", "pref": "$_pref"});

  // var res = await http.post('$SERVER_IP/userToken',
  //     headers: {"Authorization": _jwt},
  //     body: {"userid": "${_payload['userid']}", "token": "$_fmsToken"});
  return res.statusCode;
}


  final storage = FlutterSecureStorage();
  upload(File imageFile) async {
    String? _jwt = await storage.read(key: 'jwt');
    Map<String, dynamic> _payload = json.decode(
        utf8.decode(base64.decode(base64.normalize(_jwt!.split(".")[1]))));

    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("$SERVER_IP/face");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri)
      ..fields['userid'] = "${_payload['userid']}";

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    // fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("感情大數據分析"),
        ),
        // floatingActionButton: FloatingActionButton(onPressed: ()async{getImage();} , child: Icon(Icons.add_a_photo)),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,children: [
      Center(
          child: _image == null
              ? Text('請拍攝一張露臉清晰照..(這不會讓其他人看到)')
              : Text('分析完成照片會自動銷毀')),
      IconButton(key: Key('btn'),
          tooltip: '開始拍照', onPressed:()async{getImage();} , icon: Icon(Icons.add_a_photo))
    ,SizedBox(
                height: 15,
              ),
    ElevatedButton.icon(key: Key('btn2'),
                onPressed: () {
                  upload(_image!);
                displayDialog(context,
                                  "分析成功",
                                  "感情大數據已同步");
                },
                icon: Icon(Icons.upload_rounded),
                label: Text("開始分析"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),),
                SizedBox(height: 40,),
                Container(
            width: 250,
            height: 300,
            child:

Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.grey[100],
              elevation: 5,child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Text('您比較喜歡誰?'),
                  SizedBox(height: 10,),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
                    Container(child: CircleAvatar(
                                      radius: 50,
                                      
                                      backgroundImage: NetworkImage('https://obs.line-scdn.net/0hu3sPU5VsKhxOKQIOxhZVS3R_KXN9RTkfKh97Hw1HdCg3H2lDdkhscm0qfCRqTm1CJ09meW4rMS0wSm0aIEts/w644')))
                ,
                SizedBox(width: 5,),
                Container(child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage('https://cdn.hk01.com/di/media/images/540956/org/85d0ff659a61840937d9dc5fc5f06bb2.jpg/XTZ4qKzOGRQvx6ZDGUpn2grFCgiltuNt6VtYOelbWDk?v=w1920'))),
          
                  ],),

               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [

ElevatedButton(onPressed: ()async {
                      await attemptUpdateUserPref([1.0, 0.0]);
                      print('iu');
                    }, child: Text('李知恩'),
                    style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),),
SizedBox(width: 25,),

                  ElevatedButton(onPressed: ()async {
                      await attemptUpdateUserPref([0.0, 1.0]);
                    }, child: Text('南柱赫'),
                    style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),),

                  ]),]),
                
                
              ),),
                

    ]),);
  }
}

