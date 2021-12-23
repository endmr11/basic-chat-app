import 'package:chat_app1/helper/constants.dart';
import 'package:chat_app1/services/database.dart';
import 'package:chat_app1/views/conversation_screen.dart';
import 'package:chat_app1/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapShot;
  initialSearch() {
    databaseMethods.getUserByUserName(searchController.text).then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            itemCount: searchSnapShot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapShot!.docs[index]['name'],
                userEmail: searchSnapShot!.docs[index]['email'],
              );
            })
        : Center(
            child: Text(
              "Boş",
              style: simpleTextStyle(),
            ),
          );
  }

  createChatRoomAndStartConversation({required String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [
        userName,
        Constants.myName,
      ];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId,
            chatRoomMap['users'][0]
                .replaceAll("_", "")
                .replaceAll(Constants.myName, ""),
          ),
        ),
      );
    } else {
      // ignore: avoid_print
      print("aynı kullanıcı");
    }
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({required String userName, required String userEmail}) {
    return ListTile(
      title: Text(
        userName,
        style: simpleTextStyle(),
      ),
      subtitle: Text(
        userEmail,
        style: simpleTextStyle(),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          createChatRoomAndStartConversation(
            userName: userName,
          );
        },
        child: const Text(
          "Mesaj",
        ),
      ),
    );
  }

  @override
  void initState() {
    initialSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: textFieldInputDecoration("Kullanıcı Ara"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initialSearch();
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: searchList(),
            ),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    // ignore: unnecessary_string_escapes
    return "$b\_$a";
  } else {
    // ignore: unnecessary_string_escapes
    return "$a\_$b";
  }
}
