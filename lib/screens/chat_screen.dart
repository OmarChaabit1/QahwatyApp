import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  final String chatPartnerEmail;

  const chatScreen({super.key, required this.chatPartnerEmail});

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  late User signedInUser;
  String? messageText;

  String getChatId() {
    final emails = [signedInUser.email, widget.chatPartnerEmail];
    emails.sort();
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
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 113, 8, 134),
      //   toolbarHeight: 70,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(LineAwesomeIcons.angle_left_solid,
      //         color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     widget.chatPartnerEmail,
      //     style: const TextStyle(
      //         fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: MessageStreamBuilder(chatId: getChatId())),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (messageTextController.text.trim().isNotEmpty) {
                        _firestore
                            .collection('messages')
                            .doc(getChatId())
                            .collection('chats')
                            .add({
                          'text': messageTextController.text.trim(),
                          'sender': signedInUser.email,
                          'receiver': widget.chatPartnerEmail,
                          'time': FieldValue.serverTimestamp(),
                        });
                        messageTextController.clear();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 113, 8, 134),
                      child: const Icon(Icons.send, color: Colors.white),
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
          return const Center(child: CircularProgressIndicator());
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
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe
                ? const Color.fromARGB(255, 113, 8, 134)
                : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 10 : 0),
              topRight: Radius.circular(isMe ? 0 : 10),
              bottomLeft: const Radius.circular(10),
              bottomRight: const Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
