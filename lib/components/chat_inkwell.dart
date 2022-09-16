import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatInkwell extends StatelessWidget {
  final String receiverUser, loginedUser;
  const ChatInkwell({required this.receiverUser, required this.loginedUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: const Color(0xffFBFCFF),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.id, arguments: {
              'loginedUser': loginedUser,
              'receiverUser': receiverUser,
            });
          },
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 25,
                child: Text(
                  receiverUser.substring(0, 1),
                  style: const TextStyle(color: kTextColor),
                ),
              ),
              title: Text(
                receiverUser.split('@').first,
                style: const TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
