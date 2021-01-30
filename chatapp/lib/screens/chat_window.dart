import 'package:chatapp/helper_functions/shared_preference.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final chatwithusername,chatwithname;
  ChatScreen(this.chatwithusername,this.chatwithname);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String chatroomID,messageID="";
  Stream messagestream;
  String myname,myprofilepic,myusername,myemail;
  TextEditingController messagetexteditingcontroller=TextEditingController();

  getinfofromsharedpref()async{
    myname=await SharedPreference().getDisplayName();
    myprofilepic=await SharedPreference().getUserProfilePic();
    myusername=await SharedPreference().getUserName();
    myemail=await SharedPreference().getUserEmail();
    chatroomID=getchatroomidbyusername(myusername,widget.chatwithusername);
  }

  getchatroomidbyusername(String user1,String user2){
    if(user2.compareTo(user1)==-1){
      return "$user2\_$user1";
    }
    else{
      return "$user1\_$user2";
    }
  }

  addmessage(bool sendclicked){
    if(messagetexteditingcontroller.text!=""){
      String message=messagetexteditingcontroller.text;
      var lastmessagetimestamp=DateTime.now();
      Map<String,dynamic>messageinfo={
        "message":message,
        "sendby":myusername,
        "timestamp":lastmessagetimestamp,
        "profilepic":myprofilepic
      };
      if(messageID==""){
        messageID=randomAlphaNumeric(12);
      }
      DatabaseMethods().addMessage(chatroomID, messageID, messageinfo).then((value){
          Map<String,dynamic>lastmessageinfo={
            "lastmessage":message,
            "lastmessagesendtimestamp":lastmessagetimestamp,
            "lastmessagesendby":myusername
          };
          DatabaseMethods().updateLastMessageSend(chatroomID, lastmessageinfo);
          if(sendclicked==true){
            messagetexteditingcontroller.text="";
            messageID="";
          }
      });
    }
  }

  Widget chatmessagetile(String message,bool sendbyme){
    return Row(
      mainAxisAlignment: sendbyme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin:EdgeInsets.symmetric(horizontal: 16,vertical: 4) ,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: sendbyme ? Radius.circular(24) : Radius.circular(0),
                topRight: Radius.circular(24),
                bottomRight: sendbyme ? Radius.circular(0) : Radius.circular(24)
            ),
            color: sendbyme ? Colors.blue : Colors.grey
          ),
          child:Container(child: Text(
            message,
            style:TextStyle(color: Colors.white) ,
          ),)
        ),
      ],
    );
  }

  Widget chatmessages(){
    return StreamBuilder(
      stream: messagestream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            padding: EdgeInsets.only(bottom: 70,top:16),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context,index){
              DocumentSnapshot cur=snapshot.data.docs[index];
              return chatmessagetile(cur["message"],myusername==cur["sendby"]);
            }
        ) : Center(child: CircularProgressIndicator());
      },
    );
  }

  getandsetmessages()async{
    messagestream=await DatabaseMethods().getchatroommessages(chatroomID);
    setState(() {});
  }

  dothisonlauch()async{
    await getinfofromsharedpref();
    getandsetmessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    dothisonlauch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatwithname)),
      body: Container(
        child: Stack(
          children: [
            chatmessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child:Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messagetexteditingcontroller,
                          onChanged: (value){
                            addmessage(false);
                          },
                          style:TextStyle(color:Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: (){addmessage(true);},
                        child: Icon(Icons.send,color:Colors.white)
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
