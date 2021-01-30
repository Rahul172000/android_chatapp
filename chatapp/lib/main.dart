 import 'package:chatapp/screens/home.dart';
import 'package:chatapp/screens/sign_in.dart';
import 'package:chatapp/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: AuthMethods().getAlreadyLoggedInUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            return Home();
          }
          else{
            return SignIn();
          }
        },
      ),
    );
  }
}

