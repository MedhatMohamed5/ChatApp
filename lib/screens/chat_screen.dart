// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _fbmToken;

  @override
  void initState() {
    super.initState();
    fireBaseMessagingPrepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (identifer) {
              if (identifer == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(sendNotification),
          ],
        ),
      ),
    );
  }

  void fireBaseMessagingPrepare() async {
    final fbm = FirebaseMessaging.instance;
    //fbm.requestNotificationPermissions();
    /*fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );*/
    _fbmToken = await fbm.getToken();
    print(_fbmToken);
    fbm.subscribeToTopic('chat');
  }

  void sendNotification(Map<String, dynamic> msg) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    var response = await http.post(
      url,
      body: json.encode(
        {
          "notification": {
            "title": "Notification from ${msg['username']}",
            "body": "${msg['text']}"
          },
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done"
          },
          // "to": "/topics/all",
          "to": _fbmToken,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=$SERVER_KEY', // SERVER_KEY is from firebase console in settings for cloud messaging
      },
    );
    print(response.body);
  }
}
