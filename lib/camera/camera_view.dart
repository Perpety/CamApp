import 'package:cam_app/camera/camera_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return ViewModelBuilder<CameraViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Camera App',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _size.width * 0.7,
              height: _size.height * 0.7,
              decoration: BoxDecoration(),
            ),
            SizedBox(
              height: _size.height * 0.03,
            ),
            Container(
              width: _size.width * 0.2,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  // model.takePicture();
                },
                child: Text(
                  'Upload an image',
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => CameraViewModel(),
    );
  }
}
