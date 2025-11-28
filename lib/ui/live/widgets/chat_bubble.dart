import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String time;
  final bool isMe;

  const ChatBubble({
    required this.message,
    required this.sender,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? Colors.white : const Color(0xFF1B1B1B);
    final textColor = isMe ? Colors.black : Colors.white;
    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final crossAlign =
    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: crossAlign,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white10,
                    child: Text(
                      sender.isNotEmpty ? sender[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                if (!isMe) const SizedBox(width: 6),
                Text(
                  isMe ? 'You' : sender,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 4),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: isMe
                      ? const Radius.circular(14)
                      : const Radius.circular(4),
                  topRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(14),
                  bottomLeft: const Radius.circular(14),
                  bottomRight: const Radius.circular(14),
                ),
              ),
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: isMe
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all,
                          size: 13,
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ],
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
