import 'package:chatapp/helper_functions/shared_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserInfoToDatabase(String userID,Map<String,dynamic>userInfo) async{
    return await FirebaseFirestore.instance.collection("Users").doc(userID).set(userInfo);
  }

  Future<Stream<QuerySnapshot>>getUserByUsername(String username)async{
    return FirebaseFirestore.instance.collection("Users").where("username",isEqualTo: username).snapshots();
  }

  Future addMessage(String chatRoomID,String messageID,Map messageinfo)async{
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .doc(messageID)
        .set(messageinfo);
  }

  updateLastMessageSend(String chatroomID,Map lastmessageinfo){
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .update(lastmessageinfo);
  }

  createChatRoom(String chatroomID,Map chatroominfo)async{
    final snapShot=await FirebaseFirestore.instance.collection("chatRooms").doc(chatroomID).get();
    if(snapShot.exists){
      return true;
    }
    else{
      return FirebaseFirestore.instance.collection("chatRooms").doc(chatroomID).set(chatroominfo);
    }
  }

  Future<Stream<QuerySnapshot>>getchatroommessages(String chatroomID)async{
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("chats")
        .orderBy("timestamp",descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>>getconversations()async{
    String myusername=await SharedPreference().getUserName();
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .orderBy("lastmessagesendtimestamp",descending: true)
        .where("users",arrayContains: myusername)
        .snapshots();
  }
  
  Future<QuerySnapshot> getuserinfo(String username)async{
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("username",isEqualTo: username)
        .get();
  }
}