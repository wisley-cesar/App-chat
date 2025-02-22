import 'dart:async';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    return Stream<List<ChatMessage>>.empty();
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // Estou transformando o ChatMessage -> Map<String, dynamic>
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userID': user.id,
      'userName': user.name,
      'userImageUrl': user.imageURL,
    });

    // Estou transformando o Map<String, dynamic> ->  ChatMessage
    // Fazendo o contrario agora
    final doc = await docRef.get();
    final data = doc.data()!;

    return ChatMessage(
      id: doc.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userID: data['userID'],
      userName: data['userName'],
      userImageUrl: data['userImageUrl'],
    );
  }

  // Estou transformando o Map<String, dynamic> ->  ChatMessage

  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userID: doc['userID'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }
}
