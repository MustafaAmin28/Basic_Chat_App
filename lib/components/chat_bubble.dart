import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.message});

  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Material(
          color: kBackgrorundColor,
          elevation: 10,
          shadowColor: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Column(
              children: [
                Text(
                  message.messageText,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "${message.messageDate.toDate().hour}:${message.messageDate.toDate().toLocal().minute}",
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubbleForFriend extends StatelessWidget {
  const ChatBubbleForFriend({required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Material(
          color: kPrimaryColor,
          elevation: 8,
          shadowColor: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Column(
              children: [
                Text(
                  message.messageText,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "${message.messageDate.toDate().hour}:${message.messageDate.toDate().toLocal().minute}",
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
