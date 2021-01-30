import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  static String userIDKey="USERID";
  static String userNameKey="USERNAME";
  static String displayNameKey="DISPLAYNAME";
  static String userEmailKey="USEREMAIL";
  static String userProfilePicKey="USERPROFILEPIC";

  Future<bool> saveUserName(String username) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, username);
  }
  Future<bool> saveUserID(String userID) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userIDKey, userID);
  }
  Future<bool> saveDisplayName(String displayname) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, displayname);
  }
  Future<bool> saveUserEmail(String useremail) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, useremail);
  }
  Future<bool> saveProfilePicKey(String profilekey) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, profilekey);
  }

  Future<String> getUserName() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
  Future<String> getUserID() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userIDKey);
  }
  Future<String> getDisplayName() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }
  Future<String> getUserEmail() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  Future<String> getUserProfilePic() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}