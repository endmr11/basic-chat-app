import 'package:chat_app1/helper/authenticate.dart';
import 'package:chat_app1/helper/constants.dart';
import 'package:chat_app1/helper/helperfunctions.dart';
import 'package:chat_app1/services/auth.dart';
import 'package:chat_app1/services/database.dart';
import 'package:chat_app1/views/conversation_screen.dart';
import 'package:chat_app1/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream? chatRoomsStream;

  @override
  void initState() {
    /*getUserInfo();*/
    getUserInfogetChats();

    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRoomsStream = snapshots;
      });
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data != null
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    snapshot.data.docs[index]["chatroomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index]["chatroomId"],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DUYGU <3 EREN",
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              HelperFunctions.deleteSharedPreference();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Authenticate(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: const Icon(
                Icons.exit_to_app,
              ),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.message,
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoom;

  // ignore: use_key_in_widget_constructors
  const ChatRoomsTile(this.userName, this.chatRoom);

  deleteChatRooms(String chatRoomId) async {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(top: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: ListTile(
          onLongPress: () => deleteChatRooms(chatRoom),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoom, userName),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              userName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          title: Text(
            userName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            size: 40.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
