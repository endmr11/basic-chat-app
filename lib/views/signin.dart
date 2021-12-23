import 'package:chat_app1/helper/helperfunctions.dart';
import 'package:chat_app1/services/auth.dart';
import 'package:chat_app1/services/database.dart';
import 'package:chat_app1/views/chat_room_screen.dart';
import 'package:chat_app1/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toogle;
  // ignore: use_key_in_widget_constructors
  const SignIn(this.toogle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  /*signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) async {
        if (val != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailController.text);
          databaseMethods.getUserByUserEmail(emailController.text).then((val) {
            userInfoSnapshot = val;
            HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0]['name']);
            HelperFunctions.saveUserEmailSharedPreference(
                userInfoSnapshot.docs[0]['email']);
          });

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoom(),
            ),
          );
        }
      });
    }
  }*/

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await databaseMethods.getUserInfo(emailController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0]["name"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0]["email"]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoom(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val.toString())
                          ? null
                          : "Geçerli Mail Adresi Girin";
                    },
                    controller: emailController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val!.length < 6 ? "6 Karakterden fazla gir" : null;
                    },
                    controller: passwordController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Şifre"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onTap: () {
                signIn();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [
                      Color(0xff007EF4),
                      Color(0xff2A75BC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "GİRİŞ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hesabın var mı? ",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toogle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
