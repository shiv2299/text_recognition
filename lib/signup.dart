import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget{
  GlobalKey<FlipCardState> cardKey;
  signup(this.cardKey);
  @override
  signupState createState() {
    return signupState(cardKey);
  }
}
class signupState extends State<signup>{
  GlobalKey<FlipCardState> cardKey;
  signupState(this.cardKey);
  double screenHeight;
  String link_text="Already have account? Login"
      "";
  final _formKey = GlobalKey<FormState>();
  void flip(){
    cardKey.currentState.toggleCard();
  }
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    final name = TextFormField(
      style: TextStyle(fontFamily: "Hero"),
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Name",
        contentPadding: EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.account_box)
      ),
      validator: (val) {
        if(val.isEmpty)
          return "Please enter name";
        else
          return null;
      },
    );
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
    );

    final phone = TextFormField(
      style: TextStyle(fontFamily: 'Hero'),
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.phone),
      ),
      validator: (val) {
        if (val.isEmpty)
          return "Phone Required";
        else if (val.length < 10 || val.length > 10) {
          return "Invalid Phone";
        } else
          return null;
      },
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
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {}
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Sign Up', style: TextStyle(color: Colors.white, fontFamily: 'Hero')),
      ),
    );
    final signup_btn = FlatButton(
      child: Text(link_text, style: TextStyle(color: Colors.blue, fontFamily: 'Hero', decoration: TextDecoration.underline)),
      color: Colors.white,
      onPressed: flip,
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
              Text("Sign Up", style: TextStyle(fontFamily: "Hero",fontWeight: FontWeight.bold,fontSize: 36, color: Colors.blue),textAlign: TextAlign.center,),
              SizedBox(height: 48.0),
              name,
              SizedBox(height: 8.0),
              phone,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              SizedBox(height: 8.0),
              signup_btn
            ],
          ),
        ),
      ),
      autovalidate: true,
    );
  }
}