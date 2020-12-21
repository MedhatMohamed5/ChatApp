import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final void Function(Map<String, dynamic> data) sendNotification;

  NewMessage(this.sendNotification);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _message = '';
  var _isRTL = false;
  final _controller = TextEditingController();

  void _sendMessage() async {
    // FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = {
      'text': _message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()['username'],
      'userImage': userData.data()['image_url'],
    };

    FirebaseFirestore.instance.collection('chat').add(data);

    widget.sendNotification(data);

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
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.text,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: 'Send a message ...',
              ),
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
