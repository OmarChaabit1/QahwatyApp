import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:message_me/screens/Welcome_screen.dart';
// import 'package:message_me/widgets/my_buttons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class chatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  const chatScreen({super.key});

  @override
  _chatScreenState createState() => _chatScreenState();
}

late User signedInUser; //this will give us the email

final _firestore = FirebaseFirestore.instance;

class _chatScreenState extends State<chatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  // the messages :
  String? messageText; //this will give us the message
  // end messages
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
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessagesDB() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Image.asset(
              'images/messageMe2.gif',
              height: 80,
            ),
            Text(
              'MessageMe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
              //Navigator.pushNamed(context,WelcomeScreen.screenRoute);
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessageStreamBuilder(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
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
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      hintText: 'Write your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    messageTextController.clear();
                    _firestore.collection('messages').add({
                      'text': messageText,
                      'sender': signedInUser.email,
                      'time': FieldValue.serverTimestamp(),
                    });
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<messageLine> messageWidgets = [];

        // si on a des data dans BD
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signedInUser.email;
          if (currentUser == messageSender) {
            // the code of the message from the signed in user
          }
          final messageWidget = messageLine(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class messageLine extends StatelessWidget {
  const messageLine({this.text, this.sender, required this.isMe, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.blue[800] : Colors.grey[800],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
