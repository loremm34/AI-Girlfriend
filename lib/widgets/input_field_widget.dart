import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  const InputFieldWidget({super.key, required this.onMessageSend});

  final void Function(String) onMessageSend;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onMessageSend(text);
      _controller.clear();
    }
  }

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
                  controller: _controller,
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
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
