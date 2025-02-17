// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;

  final String userID;
  final String userName;
  final String userImageUrl;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userID,
    required this.userName,
    required this.userImageUrl,
  });
}
