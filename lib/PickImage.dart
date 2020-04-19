import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:text_recognition/ShowText.dart';
import 'dart:ui';
import 'BaseAuth.dart';

class PickImage extends StatefulWidget {
  PickImage({this.auth, this.userId, this.logoutCallback});
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  PickImageState createState() {
    return PickImageState();
  }
}

class PickImageState extends State<PickImage> {
  File _image;
  var image;
  List<VisionText> visionText = <VisionText>[];
  bool flag = false;
  FirebaseVisionTextDetector detector = FirebaseVisionTextDetector.instance;
  @override
  void initState() {
    super.initState();
  }

  Future camera() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    var currentLabels = await detector.detectFromPath(image?.path);
    setState(() {
      _image = image;
      visionText = currentLabels;
      flag = true;
    });
  }

  Future gallery() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    var currentLabels = await detector.detectFromPath(image?.path);
    setState(() {
      _image = image;
      visionText = currentLabels;
      flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Text Recognition",
          style: TextStyle(fontFamily: "Hero", fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              widget.logoutCallback();
              widget.auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: _image == null
                      ? Text(
                          "No image selected",
                          style: TextStyle(color: Colors.grey),
                        )
                      : new FutureBuilder<Size>(
                          future: _getImageSize(
                              Image.file(_image, fit: BoxFit.fitWidth)),
                          builder: (BuildContext context,
                              AsyncSnapshot<Size> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              return Container(
                                  foregroundDecoration: TextDetectDecoration(
                                      visionText, snapshot.data),
                                  child:
                                      Image.file(_image, fit: BoxFit.fitWidth));
                            } else {
                              return Text("Error detecting text");
                            }
                          },
                        ), //Image.file(_image),
                ),
              ),
            ),
          ),
          flag
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: RaisedButton(
                          child: Text(
                            "Retake",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Hero"),
                          ),
                          color: Colors.blue,
                          onPressed: () => show(context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: RaisedButton(
                          child: Text(
                            "Proceed",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Hero"),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowText(visionText)));
                          },
                        ),
                      ),
                    )
                  ],
                )
              : Container()
        ],
      ),
      floatingActionButton: flag
          ? null
          : FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: () {
                show(context);
              },
              tooltip: "Select Image",
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void show(BuildContext con) {
    showModalBottomSheet(
      context: con,
      builder: (_) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: RaisedButton(
                      child: Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 125,
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: camera,
                    ),
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(fontFamily: "Hero", fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: RaisedButton(
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: 125,
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: gallery,
                    ),
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(fontFamily: "Hero", fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Size> _getImageSize(Image image) async {
    Completer<ImageInfo> completer = Completer();
    image.image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    Size size = Size(
        imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble());
    return size;
  }
}

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;
  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;
  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = new Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _texts) {
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio - 5,
          offset.dy + text.rect.top / _heightRatio - 5,
          offset.dx + text.rect.right / _widthRatio + 5,
          offset.dy + text.rect.bottom / _heightRatio + 5);
      canvas.drawRect(_rect, paint);
    }
    final rect = offset & configuration.size;
    canvas.restore();
  }
}
