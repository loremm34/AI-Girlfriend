import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  Message({required this.text, required this.isUser});
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;
}
