import 'package:chat_app/components/custom_elevated_button.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email, password;
  bool hidden = true;
  bool isLoading = false;
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
                  height: 80,
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
                  height: 30,
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
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
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  validate: (data) {
                    if (data!.isEmpty) {
                      return "This field is required!";
                    } else if (data.length < 8) {
                      return "Password incorrect! It cannot be less than 8 characters";
                    }
                  },
                  onChange: (data) {
                    password = data;
                  },
                  hintText: "Enter your password",
                  labelText: "Password",
                  hidden: hidden,
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
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomElevatedButton(
                  buttonText: "Login",
                  height: 50,
                  width: 380,
                  buttonColor: kBackgrorundColor,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await loginUser();

                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeScreen.id,
                            arguments: email,
                            (route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(
                              msg: "User not found! Please check your email.",
                              fontSize: 18);
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(
                              msg:
                                  "Wrong password! Please check your password.",
                              fontSize: 18);
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString(), fontSize: 18);
                      }
                      setState(() {
                        isLoading = false;
                      });
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
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: const Text(
                        "Register",
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

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
