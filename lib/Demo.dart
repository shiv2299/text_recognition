import 'package:flutter/material.dart';

class Final extends StatefulWidget{
  @override
  FinalState createState() {
    return FinalState();
  }
}
class FinalState extends State<Final>{
  double screenHeight;
  final _formKey = GlobalKey<FormState>();
  bool isVisible=false;
  String btn_text="Login",link_text="Don't have account? Sign Up",head_text="Login";
  void callSignUp() {
    setState(() {
      if(!isVisible){
        isVisible=true;
        btn_text="Sign Up";
        link_text="Already have account? Login";
        head_text="Sign Up";
      }
      else{
        isVisible=false;
        btn_text="Login";
        link_text="Don't have account? Sign Up";
        head_text="Login";
      }
    });
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
          else{

          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text(btn_text, style: TextStyle(color: Colors.white, fontFamily: 'Hero')),
      ),
    );
    final signup_btn = FlatButton(
      child: Text(link_text, style: TextStyle(color: Colors.grey[700], fontFamily: 'Hero')),
      color: Colors.white,
      onPressed: callSignUp,
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
              Text(head_text, style: TextStyle(fontFamily: "Hero",fontWeight: FontWeight.bold,fontSize: 36, color: Colors.blue),textAlign: TextAlign.center,),
              SizedBox(height: 48.0),
              Visibility(
                  visible: isVisible,
                  child: name,
              ),
              SizedBox(height: 24.0),
              email,
              SizedBox(height: 24.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              SizedBox(height: 8.0),
              signup_btn,
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

}