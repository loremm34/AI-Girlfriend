import 'package:flutter/material.dart';
import 'package:ai_girlfriend/screens/chat_screen.dart';
import 'package:ai_girlfriend/data/girls_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ai_girlfriend/models/chat.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int currentIndex = 0;
  late Box<Chat> _chatBox;

  @override
  void initState() {
    super.initState();
    _chatBox = Hive.box<Chat>("chatsBox");
  }

  void startChat(
      BuildContext context, String name, String photo, String description) {
    final chat = Chat(name: name, messages: []);
    _chatBox.add(chat); // Ensure the chat is added to the Hive box
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return ChatScreen(
            chat: chat,
            name: name,
            photo: photo,
            description: description,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 500,
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: girlsList.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 10),
                    height: 600,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final girl = girlsList[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            girl.photo,
                            fit: BoxFit.cover,
                            height: 410,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          girl.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recently Start Chat',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final girl = girlsList[currentIndex];
                          startChat(
                            context,
                            girl.name,
                            girl.photo,
                            girl.description,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Start Chat',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
