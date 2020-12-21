import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final Key key;
  MessageBubble(this.message, this.isMe, this.username, {this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ? Colors.black87
                        : Theme.of(context).accentTextTheme.headline6.color,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline6.color,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: SizedBox(),
          flex: 1,
        ),
      ],
    );
  }
}
