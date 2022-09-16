import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/custom_elevated_button.dart';
import '../components/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email, password, confirmPassword;

  bool isLoading = false, hidden = true;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                const Center(
                  child: Text(
                    'My Chat App',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'Secular One'),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    validate: (data) {
                      if (data!.isEmpty) return "This field is required!";
                    },
                    onChange: (data) {
                      email = data;
                    },
                    hintText: "Enter your email",
                    labelText: "Email",
                    ico: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mail,
                        color: kBackgrorundColor,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hidden: hidden,
                    validate: (data) {
                      if (data!.isEmpty) {
                        return "This field is required!";
                      } else if (data.length < 8) {
                        return "Password length should be at least 8 characters.";
                      }
                    },
                    onChange: (data) {
                      password = data;
                    },
                    hintText: "Enter your password",
                    labelText: "Password",
                    ico: IconButton(
                      onPressed: () {
                        setState(() {
                          hidden = !hidden;
                        });
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: kBackgrorundColor,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    hidden: hidden,
                    validate: (data) {
                      if (data!.isEmpty) {
                        return "This field is required!";
                      } else if (data.length < 8) {
                        return "Password length should be at least 8 characters.";
                      }
                    },
                    onChange: (data) {
                      confirmPassword = data;
                    },
                    hintText: "Confirm password",
                    labelText: "Confirm Password",
                    ico: IconButton(
                      onPressed: () {
                        setState(() {
                          hidden = !hidden;
                        });
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: kBackgrorundColor,
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                CustomElevatedButton(
                  buttonText: "Register",
                  height: 50,
                  width: 380,
                  buttonColor: kBackgrorundColor,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      if (password == confirmPassword) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await createUser();
                          Fluttertoast.showToast(
                              msg: "Registered succesfully!", fontSize: 18);

                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.id,
                              arguments: email,
                              (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Fluttertoast.showToast(
                                msg: "Weak password, Please try stronger one.",
                                fontSize: 18);
                          } else if (e.code == 'email-already-in-use') {
                            Fluttertoast.showToast(
                                msg:
                                    "This email is already in use, Please try another one.",
                                fontSize: 18);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: e.toString(), fontSize: 18);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Password doesn't match!", fontSize: 18);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: kBackgrorundColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).set({'username': email});

    CollectionReference conversations =
        FirebaseFirestore.instance.collection('conversations');

    await conversations.doc(email).set({'chats': []});
  }
}
