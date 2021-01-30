import 'package:chatapp/helper_functions/shared_preference.dart';
import 'package:chatapp/screens/home.dart';
import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods{
  final FirebaseAuth auth=FirebaseAuth.instance;

  getAlreadyLoggedInUser() async {
    return await auth.currentUser;
  }

  googleSignIn(BuildContext context) async {
    final FirebaseAuth auth2=FirebaseAuth.instance;
    final GoogleSignIn googlesignin=GoogleSignIn();
    final GoogleSignInAccount googlesigninaccount=await googlesignin.signIn();
    final GoogleSignInAuthentication googlesigninauthentication=await googlesigninaccount.authentication;
    final AuthCredential credential=GoogleAuthProvider.credential(
      idToken:googlesigninauthentication.idToken,
      accessToken: googlesigninauthentication.accessToken
    );
    UserCredential usercredential= await auth2.signInWithCredential(credential);
    User user=usercredential.user;
    if(usercredential!= null){
      SharedPreference().saveDisplayName(user.displayName);
      SharedPreference().saveUserName(user.email.replaceAll("@gmail.com", ""));
      SharedPreference().saveProfilePicKey(user.photoURL);
      SharedPreference().saveUserEmail(user.email);
      SharedPreference().saveUserID(user.uid);

      Map<String,dynamic> userInfo={
        "email":user.email,
        "username":user.email.replaceAll("@gmail.com", ""),
        "displayname":user.displayName,
        "imageURL":user.photoURL
      };

      DatabaseMethods().addUserInfoToDatabase(user.uid, userInfo).then((value) => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()))
      });
    }
  }

  Future signOut()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}