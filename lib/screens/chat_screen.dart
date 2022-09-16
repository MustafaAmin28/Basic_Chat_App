import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  static String id = "ChatScreen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatMessage;
  final scrollController = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            backgroundColor: kBackgrorundColor,
            appBar: AppBar(
              backgroundColor: kBackgrorundColor,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: kPrimaryColor,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    radius: 20,
                    child: Text(
                      arguments['receiverUser'].substring(0, 1),
                      style: const TextStyle(color: kTextColor),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    arguments['receiverUser'].toString().split('@')[0],
                    style: const TextStyle(color: kTextColor),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: 'This feature isn\'t working yet :P',
                          fontSize: 18);
                    },
                    icon: const Icon(
                      Icons.call,
                      color: kPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: 'This feature isn\'t working yet :P',
                          fontSize: 18);
                    },
                    icon: const Icon(
                      Icons.video_call,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        if ((messageList[index].senderID ==
                                    arguments['loginedUser'] &&
                                messageList[index].receiverID ==
                                    arguments['receiverUser']) ||
                            (messageList[index].senderID ==
                                    arguments['receiverUser'] &&
                                messageList[index].receiverID ==
                                    arguments['loginedUser'])) {
                          if (messageList[index].senderID ==
                              arguments['loginedUser']) {
                            return ChatBubble(
                              message: messageList[index],
                            );
                          } else {
                            return ChatBubbleForFriend(
                                message: messageList[index]);
                          }
                        } else {
                          return const Text("");
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: TextField(
                    controller: controller,
                    onChanged: (data) {
                      chatMessage = data;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          addMessage(arguments);
                          controller.clear();
                          scrollController.jumpTo(0);
                          addConversation(arguments);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                        color: kPrimaryColor,
                      ),
                      hintText: 'Send a message',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kBackgrorundColor,
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: Text(arguments['receiverUser'].toString().split('@')[0]),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Loading...",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          );
        }
      },
    );
  }

  void addConversation(Map arguments) async {
//create reference to converstaion collection
    CollectionReference conversations =
        FirebaseFirestore.instance.collection('conversations');

    //add the receiver user to conversation collection for the logined user
    await conversations.doc('${arguments['loginedUser']}').set({
      'chats': FieldValue.arrayUnion([arguments['receiverUser']])
    }, SetOptions(merge: true));
    //add the receiver user to conversation collection for the receive user
    await conversations.doc('${arguments['receiverUser']}').set({
      'chats': FieldValue.arrayUnion([arguments['loginedUser']])
    }, SetOptions(merge: true));
  }

  void addMessage(Map arguments) async {
    messages.add({
      'messageText': chatMessage,
      'date': DateTime.now(),
      'senderID': arguments['loginedUser'],
      'receiverID': arguments['receiverUser'],
    });
  }
}
