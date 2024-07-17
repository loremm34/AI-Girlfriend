import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget(
      {super.key, required this.callChatBot, required this.controller});

  final TextEditingController controller;

  final void Function() callChatBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 77, 76, 76),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    hintText: 'Type a message...',
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 25),
            IconButton(
              onPressed: callChatBot,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
