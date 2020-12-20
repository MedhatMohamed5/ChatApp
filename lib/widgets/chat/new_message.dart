import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _message = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    // FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('chat').add({
      'text': _message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    });
    _controller.clear();
    setState(() {
      _message = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
