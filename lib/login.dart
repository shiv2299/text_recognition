import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/PickImage.dart';
import 'package:text_recognition/signup.dart';

class login extends StatefulWidget{
  GlobalKey<FlipCardState> cardKey;
  login(this.cardKey);
  @override
  loginState createState() {
    return loginState(cardKey);
  }
}
class loginState extends State<login>{
  GlobalKey<FlipCardState> cardKey;
  loginState(this.cardKey);
  double screenHeight;
  String link_text="Don't have account? Sign Up";
  final _formKey = GlobalKey<FormState>();
  void flip(){
    cardKey.currentState.toggleCard();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginFun(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickImage(emailController.text) ));
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    final email = TextFormField(
      style: TextStyle(fontFamily: 'Hero'),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
      controller: emailController,
    );

    final password = TextFormField(
      style: TextStyle(fontFamily: 'Hero'),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (val) => val.isEmpty ? "Password Required" : null,
      controller: passwordController,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            loginFun();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue  ,
        child: Text('Log In', style: TextStyle(color: Colors.white, fontFamily: 'Hero')),
      ),
    );
    final signup_btn = FlatButton(
      child: Text(link_text, style: TextStyle(color: Colors.blue, fontFamily: 'Hero', decoration: TextDecoration.underline)),
      color: Colors.white,
      onPressed: flip,
      splashColor: Colors.white,
    );
    final forgot_btn = FlatButton(
      child: Text("Forgot Password?", style: TextStyle(color: Colors.blue, fontFamily: 'Hero', decoration: TextDecoration.underline)),
      color: Colors.white,
      onPressed: () {},
      splashColor: Colors.white,
    );
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
                SizedBox(height: 48.0),
                Text("Login", style: TextStyle(fontFamily: "Hero",fontWeight: FontWeight.bold,fontSize: 36, color: Colors.blue),textAlign: TextAlign.center,),
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                forgot_btn,
                SizedBox(height: 8.0),
                signup_btn
              ],

            ),
          ),
        ),
    );
  }
}