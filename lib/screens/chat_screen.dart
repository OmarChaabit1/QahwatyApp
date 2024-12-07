import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  final String chatPartnerEmail;

  const chatScreen({super.key, required this.chatPartnerEmail});

  @override
  cChatScreenState createState() => cChatScreenState();
}

class cChatScreenState extends State<chatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  late User signedInUser;
  String? messageText;

  String getChatId() {
    final emails = [signedInUser.email, widget.chatPartnerEmail];
    emails.sort(); // Sort emails alphabetically to ensure consistency
    return emails.join('_');
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerEmail),
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: MessageStreamBuilder(chatId: getChatId()),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.blue, width: 2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (messageText == null || messageText!.trim().isEmpty) {
                        return;
                      }
                      messageTextController.clear();
                      _firestore
                          .collection('messages')
                          .doc(getChatId())
                          .collection('chats')
                          .add({
                        'text': messageText,
                        'sender': signedInUser.email,
                        'receiver': widget.chatPartnerEmail,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  final String chatId;

  const MessageStreamBuilder({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc(chatId)
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data!.docs;

        List<MessageBubble> messageWidgets = messages.map((message) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final isMe = messageSender == currentUser;

          return MessageBubble(text: messageText, isMe: isMe);
        }).toList();

        return ListView(reverse: true, children: messageWidgets);
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            color: isMe ? Colors.blue[800] : Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
