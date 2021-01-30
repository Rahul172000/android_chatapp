import 'package:chatapp/helper_functions/shared_preference.dart';
import 'package:chatapp/screens/chat_window.dart';
import 'package:chatapp/screens/sign_in.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
  
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isSearching=false;
  String myname,myprofilepic,myusername,myemail;
  Stream userstream,conversationsstream;
  TextEditingController searchusernameeditingcontroller=TextEditingController();

  getinfofromsharedpref()async{
    myname=await SharedPreference().getDisplayName();
    myprofilepic=await SharedPreference().getUserProfilePic();
    myusername=await SharedPreference().getUserName();
    myemail=await SharedPreference().getUserEmail();
    conversationsstream=await DatabaseMethods().getconversations();
    setState(() {});
  }

  getchatroomidbyusername(String user1,String user2){
    if(user2.compareTo(user1)==-1){
      return "$user2\_$user1";
    }
    else{
      return "$user1\_$user2";
    }
  }

  onSearchButtonClick()async{
    isSearching=true;
    setState(() {});
    userstream=await DatabaseMethods().getUserByUsername(searchusernameeditingcontroller.text);
    setState(() {});
  }


  Widget conversationslist(){
    return StreamBuilder(
      stream:conversationsstream,
      builder:(context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemBuilder: (context,index){
              DocumentSnapshot cur=snapshot.data.docs[index];
              return conversationlisttile(cur["lastmessage"], cur.id, myusername);
            },
            shrinkWrap: true,
            itemCount:snapshot.data.docs.length ,
        ) : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchlistusertile({String profilepicURL,name,username,email}){
    return GestureDetector(
      onTap: (){
        var chatroomID=getchatroomidbyusername(myusername,username);
        Map<String,dynamic>chatroominfo={
          "users":[myusername,username],
        };
        DatabaseMethods().createChatRoom(chatroomID, chatroominfo);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatScreen(username,name)));
      },
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(40),child: Image.network(profilepicURL,height: 30,width: 30,)),
        SizedBox(width: 12,),
        Column(crossAxisAlignment:CrossAxisAlignment.start,children: [Text(name), Text(email)],)
      ],),
    );
  }

  Widget searcheduserslist(){
    return StreamBuilder(
        stream: userstream,
        builder:(context,snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount:snapshot.data.docs.length ,
              shrinkWrap: true,
              itemBuilder: (context,index){
                DocumentSnapshot cur=snapshot.data.docs[index];
                return searchlistusertile(profilepicURL:cur["imageURL"], name:cur["displayname"],username:cur["username"],email: cur["email"]);
              }
          ): Center(child:CircularProgressIndicator());
        },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getinfofromsharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("PAGER"),
          actions: [
            InkWell(
              onTap: (){AuthMethods().signOut().then((value){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignIn()));
              });},
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:Icon(Icons.exit_to_app)
              )
            )
          ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child:Column(
            children: [
              Row(
                children:[
                  isSearching
                      ? GestureDetector(
                        onTap: (){
                          isSearching=false;
                          searchusernameeditingcontroller.text="";
                          setState(() {});
                        },
                        child: Padding(
                        padding: EdgeInsets.only(right:12),
                        child: Icon(Icons.arrow_back)
                  ),
                      )
                  : Container(),
                  Expanded(
                    child: Container(
                      margin:EdgeInsets.symmetric(vertical:16),
                      padding:EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border:Border.all(color:Colors.grey,width:1.0,style:BorderStyle.solid),
                          borderRadius:BorderRadius.circular(24)
                      ),
                      child:Row(children: [
                        Expanded(child:TextField(
                          controller: searchusernameeditingcontroller,
                          decoration: InputDecoration(
                          border:InputBorder.none,
                          hintText: "Username"
                      ),)),
                        GestureDetector(
                            onTap: (){
                              if(searchusernameeditingcontroller.text!=""){
                                onSearchButtonClick();
                              }
                            },
                            child: Icon(Icons.search)
                        ),
                      ],)
                    ),
                  )
                ]
              ),
              isSearching? searcheduserslist():conversationslist()
            ],
          )
      ),
    );
  }
}

class conversationlisttile extends StatefulWidget {
  final String chatroomid,lastmessage,myusername;
  conversationlisttile(this.lastmessage,this.chatroomid,this.myusername);
  @override
  _conversationlisttileState createState() => _conversationlisttileState();
}

class _conversationlisttileState extends State<conversationlisttile> {
  String profilepicURL="",name="",username="";
  getthisuserinfo()async{
    username=widget.chatroomid.replaceAll(widget.myusername, "").replaceAll("_", "");
    QuerySnapshot qs=await DatabaseMethods().getuserinfo(username);
    name=qs.docs[0]["displayname"];
    profilepicURL=qs.docs[0]["imageURL"];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getthisuserinfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return profilepicURL!="" ? GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(username, name)));},
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(borderRadius:BorderRadius.circular(30),child: Image.network(profilepicURL,height:40,width: 40,)),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: TextStyle(fontSize: 16),),
                SizedBox(height:3),
                Text(widget.lastmessage)
              ],
            )
          ],
        ),
      ),
    ) : Container();
  }
}

