import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  io.File choosenImage;

  io.File saved;

  // @override
  // void initState() {
  //   super.initState();
  //   saveFile();
  // }

  Future<io.File> takePic() async {
    XFile pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    // Directory directory;
    if (pickedFile != null) {
      final String fileName = basename(pickedFile.path);
      final String fileExtention = extension(pickedFile.path);
      final String urlSpilt = fileName + fileExtention;
      final List<String> url = urlSpilt.split('.');

      setState(() {
        choosenImage = io.File(pickedFile.path);
        // Future saved = saveFile(url);
        // if (saved != null) {
        //   print("File Saved");
        // } else {
        //   print("Problem Saving the File");
        // }
      });
      bool saved = await saveFile(url);
      if (saved) {
        print("File Saved");
      } else {
        print("Problem Saving the File");
      }
      setState(() {});
      return choosenImage;
    }
    return takePic();
  }

  Future<dynamic> saveFile(List<String> url) async {
    io.Directory directory;
    try {
      if (io.Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          // directory = await getExternalStorageDirectory();
          directory = await getApplicationDocumentsDirectory();
          print(directory);
          String newPath = "";
          List<String> folders = directory.path.split('/');
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/CamApp";
          directory = io.Directory(newPath);
          print(directory);
        } else {
          return false;
        }
      } else {
        // IOS Platform
        if (await requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if (await directory.exists()) {
        // io.File savePhoto = await choosenImage.copy('${directory.path}/$url');
        // setState(() {
        //   saved = savePhoto;
        // });
        print("exist");
      } else {
        print("not exist");
        await directory.createSync(recursive: true);
        final storeFile = directory.path;
        print(directory);
        // io.File savePhoto = await choosenImage.copy("${storeFile}/$url");
        // File saveImage = File(storeFile);
        // setState(() {
        //   choosenImage = savePhoto;
        //   saved = savePhoto;
        // });
      }
    } catch (e) {}
    return false;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            choosenImage != null
                ? Container(
                    width: _size.width * 0.7,
                    height: _size.height * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(width: 2),
                        image: DecorationImage(
                          image: FileImage(choosenImage),
                          fit: BoxFit.fill,
                        )),
                  )
                : Container(
                    width: _size.width * 0.7,
                    height: _size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(width: 2),
                    ),
                  ),
            SizedBox(
              height: _size.height * 0.03,
            ),
            Container(
              // width: _size.width * 0.2,
              // height: 40,
              child: OutlinedButton(
                onPressed: () {
                  takePic();
                },
                child: Text(
                  'Upload an image',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
