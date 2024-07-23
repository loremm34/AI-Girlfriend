import 'package:ai_girlfriend/models/message.dart';
import 'package:flutter/material.dart';
import 'package:ai_girlfriend/screens/start_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ai_girlfriend/models/chat.dart';

void main() async {
  await Hive.initFlutter();
  await dotenv.load(fileName: '.env');
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatAdapter());
  await Hive.openBox<Message>('messagesBox');
  await Hive.openBox<Chat>('chatsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const StartScreen(),
      themeMode: ThemeMode.dark,
    );
  }
}
