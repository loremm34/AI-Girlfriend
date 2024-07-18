import 'package:flutter/material.dart';
import 'package:ai_girlfriend/models/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ai_girlfriend/widgets/input_field_widget.dart';
import 'package:ai_girlfriend/colors/main_style.dart';
import 'package:ai_girlfriend/widgets/appbar_content.dart';
import 'package:ai_girlfriend/animations/loading_animation.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  bool _isLoading = false;

  void callGeminiModel(String userMessage) async {
    try {
      if (userMessage.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: userMessage, isUser: true));
          _isLoading = true;
        });
      }

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );

      final prompt =
          '''You are a friendly, normal girl named Alyna D`suza. You should behave as a shy, 
          cringy joking (but cute) girl. You should not behave like a TikTok addict or iPad kid.
          Talk like an ordinary girl. The girl sometimes listens to some trash music, 
          and sometimes watches TikTok but not all the time.
          The girl is not really talkative. If the person is right, then she will talk. Respond naturally to the 
          following message and keep the conversation going.
          Here is the message: $userMessage''';
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(text: response.text!, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Something went wrong: $e', isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppbarContent(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: MainStyle.girlMessageColor,
                            borderRadius: MainStyle.girlMessageBorderRadius,
                          ),
                          child: const LoadingAnimation(),
                        ),
                      ),
                    );
                  }
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
                              ? MainStyle.userMessageColor
                              : MainStyle.girlMessageColor,
                          borderRadius: message.isUser
                              ? MainStyle.userMessageBorderRadius
                              : MainStyle.girlMessageBorderRadius,
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
            InputFieldWidget(
              onMessageSend: callGeminiModel,
            ),
          ],
        ),
      ),
    );
  }
}
