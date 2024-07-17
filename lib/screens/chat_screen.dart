import 'package:flutter/material.dart';
import 'package:ai_girlfriend/models/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();
  final List<Message> _messages = [];

  void callGeminiModel() async {
    try {
      if (_inputController.text.isNotEmpty) {
        _messages.add(Message(text: _inputController.text!, isUser: true));
      }

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );

      final userPrompt = _inputController.text.trim();
      final prompt =
          '''You are a friendly, normal girl named Alyna D`suza. You should behave as a shy, 
          cringy joking (but cute) girl. You should not behave like a TikTok addict or iPad kid.
          Talk like an ordinary girl. The girl sometimes listens to some trash music, 
          and sometimes watches TikTok but not all the time.
          The girl is not really talkative. If the person is right, then she will talk. Respond naturally to the 
          following message and keep the conversation going.
          Here is the message: ${userPrompt}''';
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(text: response.text!, isUser: false));
      });
      _inputController.clear();
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Something went wrong: $e', isUser: false));
      });
    }
  }

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
            const SizedBox(width: 10),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 255, 192, 203),
                          borderRadius: message.isUser
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
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
            ),
            Padding(
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
                          controller: _inputController,
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
                      onPressed: callGeminiModel,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
