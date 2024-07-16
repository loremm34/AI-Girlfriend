import 'package:flutter/material.dart';
import 'package:ai_girlfriend/models/message.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(text: "Hi", isUser: true),
    Message(text: "Hi", isUser: false),
    Message(text: "Idi nahuy chort", isUser: true),
    Message(text: "Sam idi nahuy", isUser: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/girl.png',
                fit: BoxFit.cover,
                height: 45,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Alyna D\'suza',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return ListTile(
            title: Align(
              alignment:
                  message.isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? const Color.fromARGB(
                          255,
                          42,
                          42,
                          42,
                        )
                      : const Color.fromARGB(255, 255, 192, 203),
                  borderRadius: message.isUser
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
