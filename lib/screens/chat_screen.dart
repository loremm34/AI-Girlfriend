import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_girlfriend/models/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ai_girlfriend/widgets/input_field_widget.dart';
import 'package:ai_girlfriend/colors/main_style.dart';
import 'package:ai_girlfriend/animations/loading_animation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ai_girlfriend/models/chat.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String description;
  final String photo;
  final Chat chat;

  const ChatScreen(
      {super.key,
      required this.name,
      required this.description,
      required this.photo,
      required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  bool _isLoading = false;
  late Box<Message> _messagesBox;
  late Box<Chat> _chatsBox;

  @override
  void initState() {
    super.initState();
    _messagesBox = Hive.box<Message>('messagesBox');
    _chatsBox = Hive.box<Chat>("chatsBox");
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _messages.addAll(widget.chat.messages);
    });
  }

  void callGeminiModel(String userMessage) async {
    try {
      if (userMessage.isNotEmpty) {
        final userMessageObject = Message(text: userMessage, isUser: true);
        setState(() {
          widget.chat.messages.add(userMessageObject);
          _isLoading = true;
        });
        _messagesBox.add(userMessageObject);
        widget.chat.save();
        print("User message added: ${userMessageObject.text}");
      }

      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        print('API key is missing');
      }

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );

      final prompt = '''
        ${widget.description} Here is the message: $userMessage''';
      final content = [Content.text(prompt)];

      print("Sending request to Gemini model...");
      final response = await model.generateContent(content);
      print("Response received from Gemini model: ${response.text}");

      if (response.text != null) {
        final geminiMessageObject =
            Message(text: response.text!, isUser: false);

        setState(() {
          widget.chat.messages.add(geminiMessageObject);
          _isLoading = false;
        });

        _messagesBox.add(geminiMessageObject);
        widget.chat.save();
        print("Gemini message added: ${geminiMessageObject.text}");
      } else {
        throw Exception("Empty response from Gemini model");
      }
    } catch (e) {
      final errorMessageObj =
          Message(text: 'Something went wrong: $e', isUser: false);
      setState(() {
        widget.chat.messages.add(errorMessageObj);
        _isLoading = false;
      });
      _messagesBox.add(errorMessageObj);
      widget.chat.save();
      print("Error occurred: $e");
    }
  }

  void _createNewChat() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Demo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Chat Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newChat = Chat(name: controller.text, messages: []);
                  _chatsBox.add(newChat);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return ChatScreen(
                            name: widget.name,
                            description: widget.description,
                            photo: widget.photo,
                            chat: newChat);
                      },
                    ),
                  );
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
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
                widget.photo,
                fit: BoxFit.cover,
                height: 45,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _createNewChat,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _chatsBox.length,
          itemBuilder: (context, index) {
            final chat = _chatsBox.getAt(index);
            return ListTile(
              title: Text(chat!.name),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ChatScreen(
                          name: chat.name,
                          description: widget.description,
                          photo: widget.photo,
                          chat: chat);
                    },
                  ),
                );
              },
            );
          },
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
                itemCount: widget.chat.messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == widget.chat.messages.length) {
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
                  final message = widget.chat.messages[index];
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
                          style: GoogleFonts.ubuntu(
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
