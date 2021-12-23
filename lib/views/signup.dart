import 'package:chat_app1/helper/helperfunctions.dart';
import 'package:chat_app1/services/auth.dart';
import 'package:chat_app1/views/chat_room_screen.dart';
import 'package:chat_app1/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app1/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toogle;
  // ignore: use_key_in_widget_constructors
  const SignUp(this.toogle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameController.text,
        "email": emailController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameController.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        debugPrint(val.userId);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatRoom(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                            return val!.isEmpty || val.length < 3
                                ? "3 Karakterden Fazla Griniz"
                                : null;
                          },
                          controller: userNameController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Kullanıcı Adı"),
                        ),
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val.toString())
                                ? null
                                : "Geçerli Mail Giriniz";
                          },
                          controller: emailController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("E-Mail"),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val!.length < 6
                                ? "6 Karakterden Fazla Griniz"
                                : null;
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
                      signMeUp();
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
                        "KAYIT OL",
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
                            vertical: 8,
                          ),
                          child: const Text(
                            "Giriş Yap",
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
