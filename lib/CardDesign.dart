import 'package:flutter/material.dart';
import 'package:text_recognition/ForgotPassword.dart';
import 'package:text_recognition/login.dart';
import 'package:text_recognition/signup.dart';
import 'package:flip_card/flip_card.dart';

import 'BaseAuth.dart';

class CardDesign extends StatefulWidget {
  CardDesign({this.auth, this.loginCallback});
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  CardDesignState createState() => CardDesignState();
}

class CardDesignState extends State<CardDesign>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> isSignUp = ValueNotifier<bool>(true);
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/images.png")),
                  ),
                ),
              ),
              Center(
                child: FlipCard(
                  flipOnTouch: false,
                  key: cardKey,
                  front: login(
                      cardKey, widget.auth, widget.loginCallback, isSignUp),
                  back: ValueListenableBuilder(
                    valueListenable: isSignUp,
                    builder: (BuildContext context, bool value, Widget child) {
                      return value
                          ? signup(cardKey, widget.auth, widget.loginCallback)
                          : ForgotPassword(cardKey, widget.auth,
                              widget.loginCallback, isSignUp);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
