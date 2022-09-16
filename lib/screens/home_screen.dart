import 'package:chat_app/components/chat_inkwell.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  static String id = "HomeScreen";
  String? searchUserName;
  TextEditingController controller = TextEditingController();
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String loginedEmail = ModalRoute.of(context)!.settings.arguments as String;
    final conversations = FirebaseFirestore.instance
        .collection('conversations')
        .doc(loginedEmail);
    return StreamBuilder<DocumentSnapshot>(
      stream: conversations.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> chats = [];
          chats = snapshot.data!.get('chats');
          return WillPopScope(
            onWillPop: () async {
              final difference = DateTime.now().difference(timeBackPressed);
              final isExitWarning = difference >= Duration(seconds: 2);
              timeBackPressed = DateTime.now();
              if (isExitWarning) {
                Fluttertoast.showToast(
                    msg: "Press back again to exit.", fontSize: 18);
                return false;
              } else {
                Fluttertoast.cancel();
                return true;
              }
            },
            child: Scaffold(
              backgroundColor: kBackgrorundColor,
              body: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        "Chats",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kTextColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Material(
                      elevation: 5,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                      child: TextField(
                        controller: controller,
                        onChanged: (data) {
                          searchUserName = data;
                        },
                        onSubmitted: (data) async {},
                        decoration: InputDecoration(
                          hintText: 'Search for a user...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (searchUserName != null) {
                                QuerySnapshot<Map<String, dynamic>> users =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .where('username',
                                            isEqualTo: searchUserName)
                                        .get();
                                Map<String, String> arguments = {
                                  'loginedUser': loginedEmail,
                                  'receiverUser': searchUserName!,
                                };
                                if (users.docs.length > 0) {
                                  Navigator.pushNamed(context, ChatScreen.id,
                                      arguments: arguments);
                                  controller.clear();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "User is not found.", fontSize: 18);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Field can't be empty.", fontSize: 18);
                              }
                            },
                            icon: Icon(Icons.search),
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return ChatInkwell(
                          receiverUser: chats[index],
                          loginedUser: loginedEmail,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kBackgrorundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "You don't have chats yet",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
