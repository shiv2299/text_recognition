import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mlkit/mlkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdw;

class ShowText extends StatefulWidget {
  List<VisionText> visionText = <VisionText>[];
  ShowText(this.visionText);
  @override
  _ShowTextState createState() => _ShowTextState();
}

class _ShowTextState extends State<ShowText> {
  String text = "";
  var finaltext = "";
  _write(ext) async {
    final directory = await getExternalStorageDirectory().then((onValue) async {
      final file = File(onValue.path + "/" + filenamecontroller.text + ext);
      if (ext.toString().compareTo(".pdf") == 0) {
        final pdf = pdw.Document();
        pdf.addPage(pdw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pdw.Context context) {
              return pdw.Text(text);
            }));
        await file.writeAsBytes(pdf.save()).then((onValue) {
          Fluttertoast.showToast(
              msg: filenamecontroller.text + ext + " saved to " + onValue.path,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black);
        });
      } else {
        await file.writeAsString(text).then((onValue) {
          Fluttertoast.showToast(
              msg: filenamecontroller.text + ext + " saved to " + onValue.path,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black);
        });
      }
    });
  }

  TextEditingController filenamecontroller = TextEditingController();
  void copy() {
    if (finaltext.isEmpty) finaltext = text;
    Clipboard.setData(ClipboardData(text: finaltext));
    Fluttertoast.showToast(
        msg: "Copied to clipboard",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  void getfile(context, ext) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 16,
            child: Container(
              height: 200,
              width: 150,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Center(
                    child: Text(
                      "Enter file name",
                      style: TextStyle(
                          fontFamily: "Hero", fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontFamily: 'Hero'),
                    controller: filenamecontroller,
                  ),
                  RaisedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontFamily: "Hero"),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                      _write(ext);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.visionText.length; i++) {
      text += widget.visionText[i].text + "\n";
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Text Recognition",
            style: TextStyle(fontFamily: "Hero", fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: "Courier", fontWeight: FontWeight.bold),
                  decoration: InputDecoration(border: InputBorder.none),
                  maxLines: null,
                  autofocus: false,
                  initialValue: text,
                  expands: false,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    finaltext = value;
                  },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: Text(
                        "Copy",
                        style:
                            TextStyle(color: Colors.white, fontFamily: "Hero"),
                      ),
                      color: Colors.blue,
                      onPressed: copy,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: Text(
                        "Export",
                        style:
                            TextStyle(color: Colors.white, fontFamily: "Hero"),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                elevation: 16,
                                child: Container(
                                  height: 150,
                                  width: 250,
                                  child: ListView(
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text("Text file (.txt)"),
                                        onPressed: () {
                                          getfile(context, '.txt');
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Word file (.docx)"),
                                        onPressed: () {
                                          getfile(context, '.docx');
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("PDF file (.pdf)"),
                                        onPressed: () {
                                          getfile(context, '.pdf');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
