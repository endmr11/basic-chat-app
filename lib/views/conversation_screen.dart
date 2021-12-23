import 'dart:async';
import 'package:chat_app1/helper/constants.dart';
import 'package:chat_app1/services/database.dart';
import 'package:chat_app1/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String kisiAdi;
  // ignore: use_key_in_widget_constructors
  const ConversationScreen(this.chatRoomId, this.kisiAdi);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream? chatMessagesStream;

  Widget chatMessageList() {
    return Expanded(
      child: StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data.docs[snapshot.data.docs.length - 1]["sendBy"] !=
              Constants.myName) {
            notify(snapshot.data.docs[snapshot.data.docs.length - 1]["sendBy"],
                snapshot.data.docs[snapshot.data.docs.length - 1]["message"]);
          }

          return snapshot.data != null
              ? ListView.builder(
                  controller: scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      snapshot.data.docs[index]["message"],
                      snapshot.data.docs[index]["sendBy"],
                      snapshot.data.docs[index]["time"],
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
      Timer(
        const Duration(milliseconds: 200),
        () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent),
      );
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kisiAdi.toUpperCase(),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Column(
        children: [
          chatMessageList(),
          Container(
            height: 75,
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: textFieldInputDecoration("Mesaj"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String isSendByMe;
  final int date;

  // ignore: use_key_in_widget_constructors
  const MessageTile(this.message, this.isSendByMe, this.date);

  @override
  Widget build(BuildContext context) {
    final bool sendByMe = isSendByMe == Constants.myName;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        width: MediaQuery.of(context).size.width,
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: sendByMe ? Colors.blue : Colors.grey,
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23)),
          ),
          child: Column(
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
