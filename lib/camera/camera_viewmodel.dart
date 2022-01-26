import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewModel extends BaseViewModel {
  File _choosenImage;

  File get choosenImage => _choosenImage;

  File _savedImage;

  File get savedImage => _savedImage;

  String _status;

  String get status => _status;

  Future<File> takePicture() async {
    Directory directory;
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        // if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        final paths = directory.path;
        final String fileName = basename(image.path);
        final String fileExtention = extension(image.path);
        print(directory.path);
        String newPath = '';
        List<String> folders = paths.split('/');
        for (int i = 1; i < folders.length; i++) {
          String folder = folders[i];
          if (folder != 'Android') {
            newPath += '/' + folder;
          } else {
            break;
          }
        }
        newPath = newPath + '/CamApp';
        directory = Directory(newPath).create() as Directory;
        print(directory.path);
        _choosenImage = File(image.path);
        _choosenImage =
            await choosenImage.copy('$newPath/$fileName/$fileExtention');
        // _savedImage = await savePicToDisk();
        // _savedImage = await saveFile(fileName);
        notifyListeners();
        // } else {
        // return null;
        // }

      }
      return choosenImage;
    } catch (e) {
      print(e);
    }

    return takePicture();
  }
}