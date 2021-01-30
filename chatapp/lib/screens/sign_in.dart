import 'package:chatapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PAGER")),
      body:Center(
        child:GestureDetector(
          onTap:(){AuthMethods().googleSignIn(context);},
          child: Container(
            child: Text("Sign In with GOOGLE",style: TextStyle(fontSize: 16,color: Colors.white),),
            decoration: BoxDecoration(color: Color(0xffDB4437),borderRadius: BorderRadius.circular(24)),
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          ),
        ),
      )
    );
  }
}
