import 'package:flutter/material.dart';
import 'package:ai_girlfriend/screens/chat_screen.dart';
import 'package:ai_girlfriend/data/girls_list.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void startChat(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return ChatScreen();
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
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CarouselSlider.builder(
            itemCount: girlsList.length,
            options: CarouselOptions(
              height: 600,
            ),
            itemBuilder: (context, index, realIndex) {
              final girl = girlsList[index];
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        girl.photo,
                        fit: BoxFit.cover,
                        height: 400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      girl.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Recently Start Chat',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                startChat(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
