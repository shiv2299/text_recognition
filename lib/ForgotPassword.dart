import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_recognition/BaseAuth.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  GlobalKey<FlipCardState> cardKey;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  ValueNotifier<bool> isSignup;
  ForgotPassword(this.cardKey, this.auth, this.loginCallback, this.isSignup);
  @override
  ForgotPasswordState createState() {
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  final databaseReference = Firestore.instance;
  var email;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String btn_text = "Proceed";
  String phone = "";
  String _email = "";
  String otp = "";
  bool flag = true;

  void verifyemail() {
    widget.auth.resetPassword(_email);
    Fluttertoast.showToast(
        msg: "Password reset link sent to " + _email + " Please check email",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black);
    widget.cardKey.currentState.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    if (flag) {
      email = TextFormField(
        style: TextStyle(fontFamily: 'Hero'),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
          prefixIcon: Icon(Icons.email),
        ),
        validator: (val) {
          if (val.isEmpty)
            return "Email Required";
          else if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(val)) {
            return "Invalid Email";
          } else
            return null;
        },
        onSaved: (value) => _email = value.trim(),
        controller: emailController,
      );
    }

    final verify = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            verifyemail();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text(btn_text,
            style: TextStyle(color: Colors.white, fontFamily: 'Hero')),
      ),
    );
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Center(
        child: Card(
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
          elevation: 10,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    widget.cardKey.currentState.toggleCard();
                  },
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                "Forgot Password",
                style: TextStyle(
                    fontFamily: "Hero",
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              email,
              verify,
              //showErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
