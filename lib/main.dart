import 'package:flutter/material.dart';
import 'package:text_recognition/BaseAuth.dart';
import 'package:text_recognition/RootPage.dart';
import 'package:text_recognition/login.dart';
import 'package:text_recognition/signup.dart';
import 'package:flip_card/flip_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: Auth(),),//MyHomePage(title: 'Text Recognition'),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//    body: SingleChildScrollView(
//      child: Container(
//        height: MediaQuery.of(context).size.height,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.only(bottom: 30),
//                child: Image.asset("assets/images.png",height: 100,width: 100,)
//            ),
//            FlipCard(
//              flipOnTouch: false,
//              key: cardKey,
//              front: login(cardKey),
//              back: signup(null,null,cardKey),
//            ),
//          ],
//        ),
//      ),
//    ),

    );
  }
}
*/