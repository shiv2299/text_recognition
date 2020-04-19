import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'BaseAuth.dart';

class login extends StatefulWidget {
  GlobalKey<FlipCardState> cardKey;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  ValueNotifier<bool> isSignup;
  login(this.cardKey, this.auth, this.loginCallback, this.isSignup);
  @override
  loginState createState() {
    return loginState();
  }
}

class loginState extends State<login> {
  double screenHeight;
  String link_text = "Don't have account? Sign Up";
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void flip() {
    widget.isSignup.value = true;
    widget.cardKey.currentState.toggleCard();
  }

  void frgt() {
    widget.isSignup.value = false;
    widget.cardKey.currentState.toggleCard();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginFun() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    String userId = "";
    try {
      userId = await widget.auth.signIn(_email, _password);
      setState(() {
        _isLoading = false;
      });
      if (userId.length > 0 && userId != null) widget.loginCallback();
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickImage(emailController.text) ));
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _formKey.currentState.reset();
      });
    }
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

    final password = TextFormField(
      style: TextStyle(fontFamily: 'Hero'),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (val) => val.isEmpty ? "Password Required" : null,
      controller: passwordController,
      onSaved: (value) => _password = value.trim(),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            loginFun();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Log In',
            style: TextStyle(color: Colors.white, fontFamily: 'Hero')),
      ),
    );
    final signup_btn = FlatButton(
      child: Text(link_text,
          style: TextStyle(
              color: Colors.blue,
              fontFamily: 'Hero',
              decoration: TextDecoration.underline)),
      color: Colors.white,
      onPressed: flip,
      splashColor: Colors.white,
    );
    final forgot_btn = FlatButton(
      child: Text("Forgot Password",
          style: TextStyle(
              color: Colors.blue,
              fontFamily: 'Hero',
              decoration: TextDecoration.underline)),
      color: Colors.white,
      onPressed: frgt,
      splashColor: Colors.white,
    );
    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          style: TextStyle(
              fontFamily: 'Hero',
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    return _isLoading
        ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Form(
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
                    Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: "Hero",
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48.0),
                    email,
                    SizedBox(height: 8.0),
                    password,
                    SizedBox(height: 24.0),
                    loginButton,
                    forgot_btn,
                    showErrorMessage(),
                    SizedBox(height: 8.0),
                    signup_btn
                  ],
                ),
              ),
            ),
          );
  }
}
