import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app1/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseMethods {
  Future getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future getUserByUserEmail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      debugPrint(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      // ignore: avoid_print
      print(
        e.toString(),
      );
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    if (messageMap['sendBy'] != Constants.myName) {
      notify(messageMap['sendBy'], messageMap['message']);
    }

    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    //notify("messageMap['sendBy']", "messageMap['message']");
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }
}

void notify(String gonderen, String mesaj) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'key1',
      title: gonderen,
      body: mesaj,
      displayOnBackground: true,
      displayOnForeground: true,
    ),
  );
}
