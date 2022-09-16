import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageText, senderID, receiverID;
  final Timestamp messageDate;

  Message(
      {required this.messageText,
      required this.messageDate,
      required this.senderID,
      required this.receiverID});

  factory Message.fromJson(jsonData) {
    return Message(
        messageText: jsonData['messageText'],
        messageDate: jsonData['date'],
        senderID: jsonData['senderID'],
        receiverID: jsonData['receiverID']);
  }
}
