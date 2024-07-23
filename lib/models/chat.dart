import 'package:hive/hive.dart';
import 'package:ai_girlfriend/models/message.dart';

part 'chat.g.dart';

@HiveType(typeId: 1)
class Chat extends HiveObject {
  Chat({required this.name, required this.messages});
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<Message> messages;
}
